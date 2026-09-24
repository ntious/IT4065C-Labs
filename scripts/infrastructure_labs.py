# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
"""Optional isolated PostgreSQL experiments; never connect to the core database."""
from __future__ import annotations

import argparse
from contextlib import closing
import csv
import json
import os
from pathlib import Path
import re
import secrets
import shutil
import socket
import subprocess
import tempfile
import time

import psycopg2
from psycopg2 import sql

from course import ROOT, isolated_libpq_environment, require


def private_write(path, value):
    fd = os.open(path, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
    with os.fdopen(fd, "w", encoding="utf-8", newline="\n") as stream:
        stream.write(value)


def password_setting(key):
    value = os.environ.get(key, secrets.token_urlsafe(32))
    require(len(value) >= 24 and not any(c in value for c in "\x00\r\n"),
            key + " must contain at least 24 characters on one line.")
    return value


def executable(name):
    """Allow an explicit installed binary directory, otherwise use pg_config/PATH."""
    directory = os.environ.get("IT4065C_PG_BIN")
    if directory:
        path = Path(directory) / (name + (".exe" if os.name == "nt" else ""))
        require(path.is_file(), "IT4065C_PG_BIN must contain PostgreSQL server tools.")
        return str(path)
    found = shutil.which(name)
    if found:
        return found
    config = shutil.which("pg_config")
    if config:
        result = subprocess.run([config, "--bindir"], capture_output=True, text=True, check=True)
        path = Path(result.stdout.strip()) / name
        if path.is_file():
            return str(path)
    candidates = list(Path("/usr/lib/postgresql").glob("*/bin/" + name)) if os.name != "nt" else []
    if candidates:
        return str(max(candidates, key=lambda p: tuple(int(x) for x in p.parent.parent.name.split("."))))
    raise ValueError("Install PostgreSQL server tools or set IT4065C_PG_BIN; see the optional infrastructure guide.")


def run(args):
    result = subprocess.run(args, capture_output=True, text=True, timeout=90)
    # Do not echo subprocess output: it may include local identities or private paths.
    require(result.returncode == 0, "A local server/certificate command failed; inspect the private run directory and guide.")


def free_port():
    with socket.socket() as sock:
        sock.bind(("127.0.0.1", 0))
        return sock.getsockname()[1]


class Instance:
    def __init__(self, root, name):
        self.directory = root / name
        self.directory.mkdir(mode=0o700)
        self.data = self.directory / "data"
        self.port = free_port()
        self.admin = os.environ.get("IT4065C_EXPERIMENT_ADMIN", "experiment_admin")
        self.reader = os.environ.get("IT4065C_EXPERIMENT_READER", "experiment_reader")
        for role in (self.admin, self.reader):
            require(re.fullmatch(r"[a-z][a-z0-9_]{0,39}", role), "Experiment role names must be lowercase identifiers, at most 40 characters.")
            require(not role.startswith("pg_"), "Experiment role names cannot begin pg_.")
        require(self.admin != self.reader, "Use distinct experiment administrator and reader names.")
        self.password = password_setting("IT4065C_EXPERIMENT_ADMIN_PASSWORD")
        self.reader_password = password_setting("IT4065C_EXPERIMENT_READER_PASSWORD")
        require(self.password != self.reader_password, "Experiment administrator and reader passwords must differ.")
        self.started = False
        pwfile = self.directory / "bootstrap-password"
        private_write(pwfile, self.password + "\n")
        try:
            run([executable("initdb"), "-D", str(self.data), "-U", self.admin,
                 "--pwfile=" + str(pwfile), "--auth=scram-sha-256", "--encoding=UTF8", "--no-locale"])
        finally:
            pwfile.unlink(missing_ok=True)
        config = "\n".join([
            "listen_addresses = '127.0.0.1'", f"port = {self.port}",
            "unix_socket_directories = ''", "password_encryption = 'scram-sha-256'",
            "logging_collector = on", "log_destination = 'csvlog'",
            "log_filename = 'events.log'", "log_file_mode = 0600",
            "log_statement = 'none'", "log_min_error_statement = error",
        ])
        with (self.data / "postgresql.conf").open("a", encoding="utf-8") as stream:
            stream.write("\n" + config + "\n")

    def start(self):
        if os.name == "nt":
            # Direct foreground binary avoids pg_ctl's nested Windows token creation.
            with (self.directory / "startup.log").open("ab") as log:
                process = subprocess.Popen([executable("postgres"), "-D", str(self.data)],
                                           stdout=log, stderr=log, creationflags=subprocess.CREATE_NO_WINDOW)
            deadline = time.monotonic() + 30
            while time.monotonic() < deadline:
                require(process.poll() is None, "Teaching server exited during startup.")
                ready = subprocess.run([executable("pg_isready"), "-h", "127.0.0.1", "-p", str(self.port)], capture_output=True)
                if ready.returncode == 0:
                    break
                time.sleep(0.1)
            else:
                raise ValueError("Teaching server startup timed out.")
        else:
            run([executable("pg_ctl"), "-D", str(self.data), "-l", str(self.directory / "startup.log"), "-w", "-t", "30", "start"])
        self.started = True

    def stop(self):
        # pg_ctl targets only the newly generated directory, never the system service.
        result = subprocess.run([executable("pg_ctl"), "-D", str(self.data), "status"], capture_output=True)
        if result.returncode == 0:
            run([executable("pg_ctl"), "-D", str(self.data), "-m", "fast", "-w", "stop"])
        self.started = False

    def connect(self, reader=False, **kwargs):
        values = dict(host="127.0.0.1", port=self.port, dbname="postgres",
                      user=self.reader if reader else self.admin,
                      password=self.reader_password if reader else self.password,
                      connect_timeout=3, sslmode="disable", application_name="optional_experiment")
        values.update(kwargs)
        with isolated_libpq_environment():
            return psycopg2.connect(**values)

    def query(self, statement, params=None, reader=False, **kwargs):
        with closing(self.connect(reader=reader, **kwargs)) as conn:
            conn.autocommit = True
            with conn.cursor() as cur:
                cur.execute(statement, params)
                return cur.fetchall() if cur.description else []

    def provision(self):
        self.query(sql.SQL("CREATE ROLE {} LOGIN PASSWORD %s NOSUPERUSER NOCREATEDB NOCREATEROLE NOREPLICATION").format(sql.Identifier(self.reader)), (self.reader_password,))
        self.query("REVOKE CREATE ON SCHEMA public FROM PUBLIC")
        self.query("CREATE TABLE public.events(id integer PRIMARY KEY, amount integer NOT NULL, created_at timestamptz NOT NULL DEFAULT clock_timestamp())")
        self.query("INSERT INTO public.events(id,amount) VALUES (1,10)")
        self.query(sql.SQL("GRANT SELECT ON public.events TO {}").format(sql.Identifier(self.reader)))


def audit(instance):
    # Duration logging includes completed SQL when statement logging is disabled.
    instance.query(sql.SQL("ALTER ROLE {} SET log_statement = 'none'").format(sql.Identifier(instance.reader)))
    instance.query(sql.SQL("ALTER ROLE {} SET log_min_duration_statement = 0").format(sql.Identifier(instance.reader)))
    marker = "audit_" + secrets.token_hex(8)
    with closing(instance.connect(reader=True, application_name=marker)) as conn:
        conn.autocommit = True
        with conn.cursor() as cur:
            cur.execute("SELECT sum(amount) FROM public.events")
            require(cur.fetchone()[0] == 10, "Reader SELECT result changed.")
            for statement in ("UPDATE public.events SET amount=0", "SELECT pg_read_file('postgresql.conf')"):
                try:
                    cur.execute(statement)
                except psycopg2.errors.InsufficientPrivilege:
                    pass
                else:
                    raise ValueError("Expected reader denial did not occur.")
    deadline = time.monotonic() + 8
    rows = []
    while time.monotonic() < deadline:
        rows = []
        for path in (instance.data / "log").glob("*.csv"):
            with path.open(encoding="utf-8", newline="") as stream:
                rows.extend(row for row in csv.reader(stream) if len(row) > 22 and row[22] == marker and row[1] == instance.reader)
        allowed = [row for row in rows if "duration:" in row[13] and "SELECT sum(amount)" in row[13]]
        denied = [row for row in rows if row[12] == "42501" and "UPDATE public.events" in row[19]]
        if allowed and denied:
            break
        time.sleep(0.1)
    require(allowed and denied, "Server CSV evidence did not contain both query completion and denial.")
    require(allowed[0][5] == denied[0][5], "Client actions did not correlate to one server session.")
    return {"allow": {"time": allowed[0][0], "role": allowed[0][1], "session": allowed[0][5], "result": "SELECT completed"},
            "deny": {"time": denied[0][0], "role": denied[0][1], "session": denied[0][5], "sqlstate": denied[0][12], "object": "public.events"},
            "reader_log_access_denied": True,
            "limitation": "Server CSV logging in a student-owned instance, not tamper-resistant independent auditing."}


def transfer(source, target):
    target.query("DELETE FROM public.events")
    target.query(sql.SQL("GRANT INSERT, UPDATE, DELETE ON public.events TO {}").format(sql.Identifier(target.reader)))

    def copy():
        rows = source.query("SELECT id,amount,created_at FROM public.events ORDER BY id", reader=True)
        with closing(target.connect(reader=True)) as conn:
            with conn.cursor() as cur:
                cur.execute("DELETE FROM public.events")
                cur.executemany("INSERT INTO public.events VALUES (%s,%s,%s)", rows)
            conn.commit()
        return rows

    def snapshot():
        return target.query("SELECT id,amount,created_at FROM public.events ORDER BY id", reader=True)

    require(source.port != target.port, "Instances must have distinct ports.")
    source_id = source.query("SELECT system_identifier FROM pg_control_system()")
    target_id = target.query("SELECT system_identifier FROM pg_control_system()")
    require(source_id != target_id, "Instances must have distinct cluster identities.")
    baseline = copy()
    source.query("INSERT INTO public.events(id,amount) VALUES (2,20)")
    changed_at = time.monotonic()
    source.stop()
    failed = False
    try:
        copy()
    except psycopg2.OperationalError:
        failed = True
    require(failed and snapshot() == baseline, "Outage must preserve the last target publication.")
    recovery_start = time.monotonic()
    source.start()
    recovered = copy()
    recovery_seconds = time.monotonic() - recovery_start
    stale_seconds = time.monotonic() - changed_at
    require(len(recovered) == 2 and sum(row[1] for row in recovered) == 30, "Recovery lost source records.")
    require(snapshot() == recovered and copy() == recovered and snapshot() == recovered, "Repeat transfer changed the result.")
    return {"distinct_cluster_ids": True, "outage_preserved_target": True, "missing_records_during_outage": 1,
            "observed_staleness_seconds": round(stale_seconds, 4), "observed_restart_and_transfer_seconds": round(recovery_seconds, 4),
            "recovered_records": 2, "recovered_total": 30, "retry_idempotent": True,
            "limitation": "Manual batch transfer with source shutdown; not streaming replication, network partition, automatic failover or production RPO/RTO."}


def certificates(directory):
    openssl = os.environ.get("IT4065C_OPENSSL") or shutil.which("openssl")
    require(openssl, "Install openssl or set IT4065C_OPENSSL to its executable.")
    for name in ("ca", "wrong-ca"):
        run([openssl, "req", "-x509", "-newkey", "rsa:2048", "-nodes", "-days", "2",
             "-subj", "/CN=Teaching-" + name, "-keyout", str(directory / (name + ".key")), "-out", str(directory / (name + ".crt"))])
    run([openssl, "req", "-newkey", "rsa:2048", "-nodes", "-subj", "/CN=localhost",
         "-keyout", str(directory / "server.key"), "-out", str(directory / "server.csr")])
    private_write(directory / "extensions.cnf", "subjectAltName=DNS:localhost\nextendedKeyUsage=serverAuth\n")
    run([openssl, "x509", "-req", "-in", str(directory / "server.csr"), "-CA", str(directory / "ca.crt"),
         "-CAkey", str(directory / "ca.key"), "-CAcreateserial", "-days", "2", "-extfile", str(directory / "extensions.cnf"), "-out", str(directory / "server.crt")])
    for path in directory.glob("*.key"):
        path.chmod(0o600)


def tls(instance):
    instance.stop()
    certificates(instance.data)
    with (instance.data / "postgresql.conf").open("a", encoding="utf-8") as stream:
        stream.write("\nssl=on\nssl_cert_file='server.crt'\nssl_key_file='server.key'\n")
    # All TCP clients, including bootstrap owner, must use TLS after this point.
    (instance.data / "pg_hba.conf").write_text("hostssl all all 127.0.0.1/32 scram-sha-256\nhostnossl all all 127.0.0.1/32 reject\n", encoding="utf-8")
    instance.start()
    options = dict(host="localhost", hostaddr="127.0.0.1", sslmode="verify-full", sslrootcert=str(instance.data / "ca.crt"))
    require(instance.query("SELECT ssl FROM pg_stat_ssl WHERE pid=pg_backend_pid()", reader=True, **options) == [(True,)], "Verified TLS did not negotiate encryption.")
    cases = [(dict(options, sslrootcert=str(instance.data / "wrong-ca.crt")), "certificate verify failed"),
             (dict(options, host="wrong.example.invalid"), "does not match host name"),
             (dict(options, sslmode="disable"), "pg_hba.conf rejects connection")]
    for bad, expected in cases:
        try:
            instance.query("SELECT 1", reader=True, **bad)
        except psycopg2.OperationalError as error:
            require(expected in str(error), "Connection failed for an unexpected reason; negative control inconclusive.")
        else:
            raise ValueError("An unsafe connection unexpectedly succeeded.")
    old = instance.reader_password
    new = password_setting("IT4065C_EXPERIMENT_ROTATED_PASSWORD")
    require(new not in {old, instance.password}, "Rotated credential must differ from both existing credentials.")
    instance.query(sql.SQL("ALTER ROLE {} PASSWORD %s").format(sql.Identifier(instance.reader)), (new,), **options)
    try:
        instance.query("SELECT 1", reader=True, password=old, **options)
    except psycopg2.OperationalError as error:
        require("password authentication failed" in str(error), "Old password rejection was not an authentication failure.")
    else:
        raise ValueError("Old password still authenticates.")
    instance.reader_password = new
    require(instance.query("SELECT count(*) FROM public.events", reader=True, **options) == [(1,)], "Rotated password cannot read the fixture.")
    return {"verified_tls": True, "wrong_ca_rejected": True, "wrong_hostname_rejected": True,
            "plaintext_rejected": True, "old_password_rejected": True, "new_password_accepted": True,
            "limitation": "Fresh connections only; rotation does not terminate existing sessions. TLS does not encrypt files or backups."}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("lab", choices=("audit", "transfer", "tls"))
    args = parser.parse_args()
    require(not hasattr(os, "geteuid") or os.geteuid() != 0, "Run as your normal Ubuntu user, not root/sudo.")
    os.umask(0o077)
    executable("initdb")
    executable("pg_ctl")
    private = ROOT / ".local" / "infrastructure"
    private.mkdir(parents=True, mode=0o700, exist_ok=True)
    root = Path(tempfile.mkdtemp(prefix=args.lab + "-", dir=private))
    instances = []
    print("Private run directory: " + root.relative_to(ROOT).as_posix())
    try:
        for name in (["source", "target"] if args.lab == "transfer" else ["server"]):
            instance = Instance(root, name)
            instances.append(instance)
            instance.start()
            instance.provision()
        result = {"audit": lambda: audit(instances[0]), "transfer": lambda: transfer(*instances), "tls": lambda: tls(instances[0])}[args.lab]()
        private_write(root / "evidence.json", json.dumps(result, indent=2) + "\n")
    finally:
        failures = []
        for instance in instances:
            try:
                instance.stop()
            except Exception:
                failures.append(instance.directory.name)
        require(not failures, "Could not confirm shutdown. Use the guide's pg_ctl stop command for: " + ", ".join(failures))
    print("PASS: optional " + args.lab + " assertions verified; teaching instances stopped. Read evidence.json and complete the reflection.")
    print("Read your results with:")
    print(".venv/bin/python -m json.tool " + (root / "evidence.json").relative_to(ROOT).as_posix())


if __name__ == "__main__":
    try:
        main()
    except ValueError as error:
        print("Experiment stopped without PASS: " + str(error))
        raise SystemExit(1)
    except (OSError, subprocess.SubprocessError, psycopg2.Error):
        # Server errors can contain identifiers and local paths: keep raw details private.
        print("Experiment stopped without PASS. Check prerequisites and private server logs; see recovery guidance.")
        raise SystemExit(1)
