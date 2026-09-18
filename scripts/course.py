# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
"""One safe entry point for the local, synthetic IT4065C teaching platform.

Configuration is parsed as data, never sourced/evaluated. SQL identifiers and
values use psycopg quoting. Runtime commands never accept administrator passwords
on their command line and never print credential values.
"""
from __future__ import annotations

import argparse
import csv
from contextlib import closing, contextmanager
import json
import os
from pathlib import Path
import re
import secrets
import shutil
import subprocess
import sys
from datetime import datetime, timezone

ROOT = Path(__file__).resolve().parents[1]
MARKER = "IT4065C disposable course v2"
DEFAULTS = {
    "IT4065C_DB_HOST": "127.0.0.1", "IT4065C_DB_PORT": "5432",
    "IT4065C_DB_NAME": "it4065c", "IT4065C_DB_USER": "it4065c_owner",
    "IT4065C_DB_SCHEMA": "student", "IT4065C_DB_SSLMODE": "disable",
}
PASSWORDS = ("IT4065C_DB_PASSWORD", "IT4065C_ANALYST_PASSWORD", "IT4065C_STEWARD_PASSWORD")
IDENT = re.compile(r"^[a-z][a-z0-9_]{0,39}$")


@contextmanager
def isolated_libpq_environment():
    """The CLI is single-threaded. Never let ambient libpq settings redirect it."""
    ambient = {key: value for key, value in os.environ.items() if key.startswith("PG")}
    try:
        for key in ambient:
            os.environ.pop(key)
        yield
    finally:
        os.environ.update(ambient)


def require(condition, message):
    if not condition:
        raise ValueError(message)


def configure():
    path = ROOT / ".env"
    require(not path.exists(), ".env already exists; edit it locally instead of overwriting credentials.")
    values = dict(DEFAULTS)
    values.update({key: secrets.token_urlsafe(32) for key in PASSWORDS})
    fd = os.open(path, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
    with os.fdopen(fd, "w", encoding="utf-8", newline="\n") as stream:
        stream.write("# Private course settings. Literal values; no shell expansion.\n")
        for key, value in values.items():
            stream.write(f"{key}={value}\n")
    print("Created private .env with unique passwords. See docs/setup.md before changing settings.")


def settings():
    values = dict(DEFAULTS)
    path = ROOT / ".env"
    if path.exists():
        if os.name != "nt":
            require(path.stat().st_mode & 0o077 == 0, "Run chmod 600 .env; this file must be private.")
        seen = set()
        for number, line in enumerate(path.read_text(encoding="utf-8").splitlines(), 1):
            if not line.strip() or line.lstrip().startswith("#"):
                continue
            key, sep, value = line.partition("=")
            require(sep and key in {*DEFAULTS, *PASSWORDS}, f"Invalid .env key on line {number}.")
            require(key not in seen, f"Duplicate .env key on line {number}.")
            seen.add(key)
            values[key] = value
    for key in {*DEFAULTS, *PASSWORDS}:
        if key in os.environ:
            values[key] = os.environ[key]
    for key in ("IT4065C_DB_NAME", "IT4065C_DB_USER", "IT4065C_DB_SCHEMA"):
        require(bool(IDENT.fullmatch(values[key])), f"{key}: use lowercase letters, digits and underscores (max 40).")
    require(values["IT4065C_DB_SCHEMA"] not in {"raw", "public", "information_schema"}
            and not values["IT4065C_DB_SCHEMA"].startswith("pg_"), "Choose a private student schema.")
    require(values["IT4065C_DB_USER"] != "postgres", "Routine course work must not use postgres.")
    require(values["IT4065C_DB_NAME"] not in {"postgres", "template0", "template1"}, "Choose a dedicated course database.")
    require(values["IT4065C_DB_HOST"] in {"127.0.0.1", "localhost", "::1"},
            "This edition supports an isolated local database only; remote deployments need instructor review.")
    require(values["IT4065C_DB_PORT"].isdigit() and 0 < int(values["IT4065C_DB_PORT"]) < 65536, "Invalid DB port.")
    require(values["IT4065C_DB_SSLMODE"] in {"disable", "require", "verify-full"}, "Invalid SSL mode.")
    for key in PASSWORDS:
        require(len(values.get(key, "")) >= 16 and not any(c in values[key] for c in "\x00\r\n"), f"{key} must have at least 16 characters on one line. Run configure or edit .env.")
    require(len({values[key] for key in PASSWORDS}) == len(PASSWORDS), "Use a different password for each role.")
    require(values["IT4065C_DB_USER"] not in {values["IT4065C_DB_NAME"] + "_analyst", values["IT4065C_DB_NAME"] + "_steward"}, "Builder and reader identities must differ.")
    return values


class Course:
    def __init__(self):
        import psycopg2
        from psycopg2 import sql
        self.pg, self.sql = psycopg2, sql
        self.cfg = settings()
        self.schema = self.cfg["IT4065C_DB_SCHEMA"]
        self.roles = {"owner": self.cfg["IT4065C_DB_USER"],
                      "analyst": self.cfg["IT4065C_DB_NAME"] + "_analyst",
                      "steward": self.cfg["IT4065C_DB_NAME"] + "_steward"}
        self.private = ROOT / ".local"
        self.private.mkdir(mode=0o700, exist_ok=True)

    def connect(self, role="owner", database=None):
        password = {"owner": "IT4065C_DB_PASSWORD", "analyst": "IT4065C_ANALYST_PASSWORD", "steward": "IT4065C_STEWARD_PASSWORD"}[role]
        with isolated_libpq_environment():
            conn = self.pg.connect(host=self.cfg["IT4065C_DB_HOST"], port=self.cfg["IT4065C_DB_PORT"],
                dbname=database or self.cfg["IT4065C_DB_NAME"], user=self.roles[role], password=self.cfg[password],
                sslmode=self.cfg["IT4065C_DB_SSLMODE"], connect_timeout=5, application_name="it4065c_" + role,
                options="-c timezone=UTC -c statement_timeout=15000")
        conn.autocommit = True
        return conn

    def execute(self, query, params=None, role="owner"):
        with closing(self.connect(role)) as conn:
            with conn.cursor() as cur:
                cur.execute(query, params)
                return cur.fetchall() if cur.description else []

    def template(self, path):
        # Only trusted repository SQL is templated; identifiers are quoted by psycopg.
        text = (ROOT / path).read_text(encoding="utf-8")
        with closing(self.connect()) as conn:
            for key, value in {"schema": self.schema, **self.roles}.items():
                text = text.replace("{{" + key + "}}", self.sql.Identifier(value).as_string(conn))
        return text

    def file(self, path):
        self.execute(self.template(path))

    def bootstrap(self):
        """Local admin provisioning only. Refuse unrelated existing DBs/roles."""
        # Ubuntu uses OS peer auth. CI/native verification can supply admin env
        # on an isolated local server. These values are never read from .env.
        if os.environ.get("IT4065C_ADMIN_PASSWORD"):
            with isolated_libpq_environment():
                admin = self.pg.connect(host=self.cfg["IT4065C_DB_HOST"], port=self.cfg["IT4065C_DB_PORT"],
                    dbname="postgres", user=os.environ.get("IT4065C_ADMIN_USER", "postgres"),
                    password=os.environ["IT4065C_ADMIN_PASSWORD"], connect_timeout=5)
            admin.autocommit = True
            def run(query):
                with admin.cursor() as cur:
                    cur.execute(query)
                    return cur.fetchall() if cur.description else []
            quote = lambda value: self.sql.Literal(value).as_string(admin)
            ident = lambda value: self.sql.Identifier(value).as_string(admin)
        else:
            require(sys.platform.startswith("linux"), "Bootstrap needs Ubuntu sudo/peer authentication, or a local test administrator via environment.")
            def run(query):
                result = subprocess.run(["sudo", "-u", "postgres", "psql", "-X", "-qAt", "-v", "ON_ERROR_STOP=1", "-p", self.cfg["IT4065C_DB_PORT"], "-d", "postgres"],
                    input="SET standard_conforming_strings=on;\n" + query, text=True, capture_output=True,
                    env={key: value for key, value in os.environ.items() if not key.startswith("PG")})
                require(result.returncode == 0, "Local PostgreSQL provisioning failed. Check service/port and sudo permissions; SQL output suppressed to protect secrets.")
                return [(x,) for x in result.stdout.strip().splitlines()] if result.stdout.strip() else []
            quote = lambda value: "'" + value.replace("'", "''") + "'"
            ident = lambda value: '"' + value.replace('"', '""') + '"'
        try:
            db = self.cfg["IT4065C_DB_NAME"]
            existing = run(f"SELECT coalesce(shobj_description(oid,'pg_database'),'<unmanaged>') FROM pg_database WHERE datname={quote(db)};")
            require(not existing or existing[0][0] == MARKER, "Existing database is not managed by this course. Choose a new IT4065C_DB_NAME; no changes made.")
            for name in self.roles.values():
                rows = run(f"SELECT coalesce(shobj_description(oid,'pg_authid'),'<unmanaged>') FROM pg_roles WHERE rolname={quote(name)};")
                require(not rows or rows[0][0] == MARKER + ':' + db, "A role name belongs to another setup. Choose unique database/user names; no changes made.")
                memberships = run(f"SELECT 1 FROM pg_auth_members WHERE member=(SELECT oid FROM pg_roles WHERE rolname={quote(name)}) OR roleid=(SELECT oid FROM pg_roles WHERE rolname={quote(name)});")
                require(not memberships, "Course roles have unexpected memberships. Use a fresh DB/user pair or ask your instructor to investigate; no changes made.")
            owners = run(f"SELECT pg_get_userbyid(datdba) FROM pg_database WHERE datname={quote(db)};")
            require(not owners or owners[0][0] == self.roles['owner'], "Course database owner does not match configuration; no changes made.")
            for role, name in self.roles.items():
                rows = run(f"SELECT 1 FROM pg_roles WHERE rolname={quote(name)};")
                key = {"owner": PASSWORDS[0], "analyst": PASSWORDS[1], "steward": PASSWORDS[2]}[role]
                verb = "ALTER" if rows else "CREATE"
                run(f"{verb} ROLE {ident(name)} LOGIN NOSUPERUSER NOCREATEDB NOCREATEROLE NOINHERIT NOREPLICATION NOBYPASSRLS PASSWORD {quote(self.cfg[key])}; COMMENT ON ROLE {ident(name)} IS {quote(MARKER + ':' + db)};")
            if not existing:
                run(f"CREATE DATABASE {ident(db)} OWNER {ident(self.roles['owner'])};")
                run(f"COMMENT ON DATABASE {ident(db)} IS {quote(MARKER)};")
            run(f"REVOKE ALL ON DATABASE {ident(db)} FROM PUBLIC; GRANT CONNECT ON DATABASE {ident(db)} TO {', '.join(ident(x) for x in self.roles.values())};")
        finally:
            if os.environ.get("IT4065C_ADMIN_PASSWORD"):
                admin.close()
        self.execute(self.sql.SQL("CREATE SCHEMA IF NOT EXISTS raw; CREATE SCHEMA IF NOT EXISTS {}; REVOKE ALL ON SCHEMA public FROM PUBLIC; REVOKE ALL ON SCHEMA raw FROM PUBLIC; REVOKE ALL ON SCHEMA {} FROM PUBLIC;").format(self.sql.Identifier(self.schema), self.sql.Identifier(self.schema)))
        print("Provisioned dedicated course database and three non-superuser logins.")

    def preflight(self):
        row = self.execute("SELECT current_user, current_database(), rolsuper, rolcreatedb, rolcreaterole, rolbypassrls, rolreplication FROM pg_roles WHERE rolname=current_user")[0]
        require(row[0] == self.roles["owner"] and not any(row[2:]), "Builder has unexpected identity or administrative privileges.")
        marker = self.execute("SELECT shobj_description(oid,'pg_database') FROM pg_database WHERE datname=current_database()")[0][0]
        require(marker == MARKER, "Refusing to use a database not provisioned by course bootstrap.")
        memberships = self.execute("SELECT count(*) FROM pg_auth_members m JOIN pg_roles r ON r.oid=m.member OR r.oid=m.roleid WHERE r.rolname = ANY(%s)", (list(self.roles.values()),))
        require(memberships[0][0] == 0, "Unexpected role memberships; ask your instructor to investigate.")
        require(self.execute("SELECT count(*) FROM information_schema.schemata WHERE schema_name IN (%s,'raw')", (self.schema,))[0][0] == 2, "Course schemas missing: run bootstrap.")
        print("PASS: connection, dedicated database, schemas and non-superuser builder.")

    def seed(self):
        count = self.execute("SELECT count(*) FROM information_schema.tables WHERE table_schema='raw' AND table_name IN ('customers','orders','products','order_items')")[0][0]
        require(count in {0, 4}, "Partial raw dataset found. Restore the missing table or use a fresh course database; automatic destructive reseeding is disabled.")
        if count == 0:
            self.file("labs/module_2/lab2_seed.sql")
        require(self.execute("SELECT count(*) FROM raw.customers")[0][0] > 0, "Raw dataset empty; use a fresh course database.")
        print("PASS: synthetic seed present (existing data preserved).")

    def dbt(self, *args):
        env = os.environ.copy()
        # Prevent ambient profile/target settings from changing the selected database.
        for key in list(env):
            if key.startswith("DBT_") or key.startswith("PG") or key.startswith("IT4065C_ADMIN_"):
                env.pop(key)
        env.update(self.cfg)
        env["DBT_ENV_SECRET_DB_PASSWORD"] = self.cfg[PASSWORDS[0]]
        env["DBT_SEND_ANONYMOUS_USAGE_STATS"] = "false"
        executable = Path(sys.executable).parent / ("dbt.exe" if os.name == "nt" else "dbt")
        require(executable.exists(), "dbt missing from this Python environment. Run scripts/setup.sh.")
        command = [str(executable), *args, "--project-dir", str(ROOT / "dbt/it4065c_platform"),
                   "--profiles-dir", str(ROOT / "dbt/it4065c_platform")]
        result = subprocess.run(command, env=env, cwd=ROOT, text=True, capture_output=True)
        # Keep potentially identifying debug output local; stdout is a concise checkpoint.
        log = result.stdout + result.stderr
        for key in PASSWORDS:
            log = log.replace(self.cfg[key], "[REDACTED]")
        (self.private / "dbt-last.log").write_text(log, encoding="utf-8")
        require(result.returncode == 0, "dbt failed. Read .local/dbt-last.log locally; redact paths before sharing.")
        print("PASS: dbt " + " ".join(args))

    def lab2(self):
        self.seed()
        self.file("labs/module_2/lab2_governance_register.sql")
        self.file("labs/module_2/lab2_insert_templates.sql")
        rows = self.execute(self.sql.SQL("SELECT table_name,column_name,classification FROM {}.data_classification_register ORDER BY table_name,column_name").format(self.sql.Identifier(self.schema)))
        require(len(rows) >= 2, "Governance register must include at least two fields.")
        print("PASS: governance register. Add your own rationale in the submission template.")

    def lab3(self):
        self.seed()
        self.dbt("build", "--selector", "course")
        manifest = json.loads((ROOT / "dbt/it4065c_platform/target/manifest.json").read_text())
        results = json.loads((ROOT / "dbt/it4065c_platform/target/run_results.json").read_text())["results"]
        models = [r for r in results if manifest["nodes"][r["unique_id"]]["resource_type"] == "model"]
        tests = [r for r in results if manifest["nodes"][r["unique_id"]]["resource_type"] == "test"]
        require(len(models) == 10 and len(tests) >= 30, "Selection incomplete: expected ten models and at least thirty tests.")
        require(all(r["status"] in {"success", "pass"} for r in results), "A selected node did not succeed.")
        print(f"PASS: {len(models)} models and {len(tests)} data tests actually executed.")

    def lab4(self):
        self.lab3()
        self.dbt("docs", "generate")
        manifest = json.loads((ROOT / "dbt/it4065c_platform/target/manifest.json").read_text())
        node = manifest["nodes"]["model.it4065c_platform.stg_orders"]
        require("source.it4065c_platform.raw.orders" in node["depends_on"]["nodes"], "Raw lineage edge missing.")
        print("PASS: raw.orders -> stg_orders lineage present; documentation generated.")

    def lab5(self):
        self.seed()
        self.file("labs/module_5/lab5/02_build_safe_objects.sql")
        self.file("labs/module_5/lab5/03_rbac_and_grants.sql")
        events = []
        cases = [("analyst", "v_sales_by_day", True), ("analyst", "v_customers_masked", False),
                 ("analyst", "v_customers_raw_pii", False), ("steward", "v_customers_masked", True),
                 ("steward", "v_customers_raw_pii", False)]
        for role, obj, allowed in cases:
            query = self.sql.SQL("SELECT count(*) FROM {}.{}").format(self.sql.Identifier(self.schema), self.sql.Identifier(obj))
            state = "00000"
            try:
                self.execute(query, role=role)
            except self.pg.Error as error:
                state = error.pgcode
            require(state == ("00000" if allowed else "42501"), f"Unexpected access outcome for {role}/{obj}: SQLSTATE {state}.")
            events.append({"actor": self.roles[role], "object": obj, "expected_allowed": allowed,
                           "sqlstate": state, "observed_at": datetime.now(timezone.utc).isoformat(),
                           "evidence_type": "live_client_observation"})
        for role in ("analyst", "steward"):
            for query in ("SELECT count(*) FROM raw.customers", self.sql.SQL("SET ROLE {}").format(self.sql.Identifier(self.roles["owner"]))):
                try:
                    self.execute(query, role=role)
                except self.pg.Error as error:
                    require(error.pgcode == "42501", "Denial was not an authorization error.")
                else:
                    raise ValueError("Reader unexpectedly accessed raw data or assumed builder identity.")
        (self.private / "access-evidence.json").write_text(json.dumps(events, indent=2), encoding="utf-8")
        print("PASS: nine access checks using separate authenticated connections, including escalation denials.")

    def lab6(self):
        self.lab5()
        events = json.loads((self.private / "access-evidence.json").read_text())
        require(sum(e["sqlstate"] == "42501" for e in events) == 3, "Live observation count incorrect.")
        self.file("labs/module_6/lab6/00_prepare_audit_evidence.sql")
        rows = self.execute(self.template("labs/module_6/lab6/01_generate_audit_report.sql"))
        (self.private / "audit-report.json").write_text(json.dumps({"live_client_events": events,
            "simulated_incidents": rows, "limitation": "Client observations and a synthetic fixture; not tamper-proof server audit logging."}, indent=2, default=str), encoding="utf-8")
        require(len(rows) >= 2, "Expected simulated incidents missing.")
        print("PASS: live permission evidence + deterministic simulated incident analysis. See .local/audit-report.json.")

    def lab7(self):
        # Fixed, synthetic predictions: learner interprets rates, not demographic truth.
        with (ROOT / "data/ai_predictions.csv").open(encoding="utf-8") as stream:
            rows = list(csv.DictReader(stream))
        report = {}
        for policy in ("baseline", "mitigated"):
            report[policy] = {}
            for group in ("A", "B"):
                subset = [r for r in rows if r["group"] == group]
                positive = [r for r in subset if r["eligible"] == "1"]
                negative = [r for r in subset if r["eligible"] == "0"]
                report[policy][group] = {"n": len(subset), "selection_rate": sum(int(r[policy]) for r in subset)/len(subset),
                    "false_negative_rate": sum(r[policy] == "0" for r in positive)/len(positive),
                    "false_positive_rate": sum(r[policy] == "1" for r in negative)/len(negative)}
        require(report["baseline"]["B"]["false_negative_rate"] > report["baseline"]["A"]["false_negative_rate"], "Bias fixture lost its intended contrast.")
        (self.private / "ai-evaluation.json").write_text(json.dumps(report, indent=2), encoding="utf-8")
        print("PASS: AI metrics calculated. Complete the governance decision; metric parity is not proof of fairness.")

    def lab8(self):
        self.file("labs/extensions/retention.sql")
        print("PASS: retention, legal hold and deletion-ledger replay after simulated restoration.")

    def lab9(self):
        self.file("labs/extensions/infrastructure.sql")
        print("PASS: snapshot refresh and stale-data detection. This single-instance simulation does not prove multi-cluster administration.")

    def run(self, number):
        self.preflight()
        if number == 1:
            self.dbt("debug")
        else:
            getattr(self, f"lab{number}")()
        print(f"LAB {number} COMPLETE â€” review the interpretation and deliverables in labs/README.md.")


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("command", choices=["configure", "bootstrap", "check", "lab", "all", "docs"])
    parser.add_argument("number", nargs="?", type=int, choices=range(1, 10))
    args = parser.parse_args()
    if args.command == "configure":
        configure()
        return
    course = Course()
    if args.command == "bootstrap":
        course.bootstrap()
    elif args.command == "check":
        course.preflight()
    elif args.command == "lab":
        require(args.number is not None, "Specify a lab number, e.g. lab 1.")
        course.run(args.number)
    elif args.command == "all":
        for number in range(1, 10):
            course.run(number)
    else:
        course.preflight()
        course.dbt("docs", "serve", "--host", "127.0.0.1", "--port", "8080", "--no-browser")


if __name__ == "__main__":
    try:
        main()
    except (ValueError, OSError) as error:
        print(f"STOP: {error}", file=sys.stderr)
        sys.exit(1)
    except Exception:
        # DB driver exceptions may contain connection details or SQL: keep private.
        print("STOP: operation failed. Check service, configuration and prerequisites. No credentials were printed.", file=sys.stderr)
        sys.exit(1)
