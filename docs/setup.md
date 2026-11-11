# Setup and configuration

## Prerequisites

For first installation on Windows/WSL or native Ubuntu, follow the
[single installation route](local_run.md). This page is a configuration and recovery
reference; you do not need to read it in full before starting.
Ubuntu 22.04 and 24.04 passed the published workflow at commit `71653bf`;
see [validation](validation.md) for exact scope and evidence.

Use Ubuntu 22.04 or 24.04 in an individual VM or WSL2, with Python 3.10–3.12,
sudo access, internet access for the initial installation, and about 4 GB of
available RAM and 4 GB of free disk for this small local stack. These are planning
guidelines, not measured minimums. In WSL, clone into your Linux home directory
so private-file permissions behave as expected. Windows users run the commands inside Ubuntu,
not PowerShell. macOS users can use an Ubuntu VM. No institutional account is
required. Do not run setup on a shared or production PostgreSQL server.

From your checkout run `bash scripts/setup.sh`. It first runs offline preflight
and stops on FAIL before installing packages, starting services or creating the
virtual environment. On a passing runtime, it installs Ubuntu packages,
starts PostgreSQL, installs the hash-locked Python dependencies into `.venv`,
creates `.env` if absent, provisions course identities, and executes Lab 1.
It does not upgrade the entire operating system or delete existing data.

## Unsupported Ubuntu or Python

The supported route currently validates Ubuntu 22.04/24.04 with Python 3.10–3.12.
A newer Ubuntu release is not automatically compatible with the pinned Python
packages, PostgreSQL tools or service setup. Ubuntu 26.04/Python 3.14 is not yet
validated by the course workflow. Keep the host OS and use an individual Ubuntu
24.04 VM with its default Python for the supported route; WSL is unnecessary on
an Ubuntu host. Do not replace the host's system Python to match this course.

If preflight reports FAIL for the OS or Python version, stop before setup.
Setup repeats offline preflight so directly invoking it cannot skip this check.
A passing preflight checks prerequisites, not successful completion of every lab.

A failure such as `Failed building wheel for psycopg2-binary` followed by
`libpq-fe.h: No such file or directory` means pip attempted a source build and
could not find the PostgreSQL client headers. This can happen when a pinned
package has no matching wheel for the interpreter/platform. The current pin is
`psycopg2-binary==2.9.10`; its upstream
[release notes](https://www.psycopg.org/docs/news.html) add Python 3.14 support in
2.9.11. Upstream [build prerequisites](https://www.psycopg.org/docs/install.html#build-prerequisites)
identify the client headers, normally supplied by `libpq-dev` on Ubuntu.
Installing headers alone does not validate the old pin or the rest of the locked
stack on Python 3.14. Do not remove hash checks or upgrade one package manually
inside the course environment to bypass the supported configuration.

If an older setup already failed after installing packages, preserve the checkout,
private work and any database state. There is no need to uninstall PostgreSQL,
delete the database or rerun setup repeatedly. Create a fresh clone inside the
supported VM and follow its matching setup instructions. Move only needed private
work through an appropriate private route; keep the new environment's generated
credentials rather than copying the failed host's configuration over them.

Native support for a new release requires a reviewed dependency/lock update,
fresh installation on that release and full lab/recovery verification, while
retaining checks on existing supported releases. Until that is recorded, the
new release remains unvalidated rather than silently added to the allowlist.

## Your one configuration file

`.env` is a private, ignored text file. Setup generates three different strong
passwords. **You do not need to change anything for the default local route.**
The public `.env.example` explains the fields without containing passwords.

| Variable | Meaning | Default |
|---|---|---|
| IT4065C_DB_HOST | Local PostgreSQL address | 127.0.0.1 |
| IT4065C_DB_PORT | Local PostgreSQL port | 5432 |
| IT4065C_DB_NAME | Dedicated course database; also prefixes reader roles | it4065c |
| IT4065C_DB_USER | Non-superuser builder login | it4065c_owner |
| IT4065C_DB_SCHEMA | Your model/register schema | student |
| IT4065C_DB_SSLMODE | Local transport setting | disable |
| IT4065C_DB_PASSWORD | Unique builder password | generated |
| IT4065C_ANALYST_PASSWORD | Unique analyst password | generated |
| IT4065C_STEWARD_PASSWORD | Unique steward password | generated |

To customize **before provisioning**:

```bash
python3 scripts/course.py configure
nano .env
chmod 600 .env
bash scripts/setup.sh
```

If `.env` already exists, skip `configure`. Keep each entry on one line as
`KEY=value`. Do not add quotes, `export`, spaces around `=`, or shell expressions.
Dollar signs and other password punctuation are literal data; the file is never
sourced or evaluated. Passwords must be distinct and at least 16 characters.
Database/user/schema identifiers use lowercase letters, digits and underscores,
start with a letter and have at most 40 characters. Reader usernames are
`<database>_analyst` and `<database>_steward`. Environment variables override the
file for automated testing, so unset old IT4065C variables if edits seem ignored.

To rotate a password, edit its value in `.env`, keep the same database/user names,
then run `.venv/bin/python scripts/course.py bootstrap` followed by `lab 5`.
Never put a password directly in a terminal command or public issue. Bootstrap
refuses unrelated existing databases/roles rather than adopting or deleting them.
For a new isolated workspace choose **both** a new DB name and builder username.
There is no automatic destructive reset command. Keep the old database until
you have preserved any work you need.

`raw` is a fixed source schema inside your dedicated course database; the student
schema is configurable. A schema name is not isolation by itself: grants and
separate database identities enforce access. Builder has no superuser, database-
creation or role-creation privileges. Only bootstrap uses local OS administrator
access. Reader passwords are passed internally, never printed in command output.

## Restart, checks and recovery

After closing the terminal, follow [stop and resume](local_run.md#stop-and-resume).
Return to your next unfinished lab; restarting does not mean repeating Lab 2.

You do not need to activate the venv because the full Python path selects it.
Commands work from other directories when you supply the full script path.

| Message | Next action |
|---|---|
| PostgreSQL connection failed | Start it with `sudo service postgresql start`; check port in .env. |
| .env missing/short password | Run configure once, or restore your private .env; then bootstrap. |
| Existing database/role is not managed | Choose unused DB/user names. Do not delete unknown objects. |
| Authentication failed after edits | Run bootstrap to synchronize your new local credentials. |
| Partial raw dataset | Preserve your work; use a fresh DB/user pair. The runner never silently drops data. |
| dbt failed | Read `.local/dbt-last.log` locally; identify the first error. |
| Selection incomplete/test failure | Check changes to SQL/YAML; tests must not be removed to force success. |

For help send the lab number, command and a redacted error. Never send `.env`,
passwords, full connection strings or an uncropped desktop screenshot. Local dbt
logs can include your filesystem username. Keep `.local` and dbt target/logs private.

## View lineage

After Lab 4, run `.venv/bin/python scripts/course.py docs` and open
http://127.0.0.1:8080 in the same machine. Stop with Ctrl+C. A remote Ubuntu VM
needs an instructor-approved SSH tunnel; do not expose port 8080 publicly.
The local profile deliberately supports loopback only. A cloud/remote deployment
requires a separate reviewed profile, firewall/access design and verified TLS.

## Read-only installation preflight

Before installation, run `python3 scripts/preflight.py` in Ubuntu. It checks the
supported OS/Python, required commands, checkout access, disk space, an IPv4
loopback port and bounded HTTPS connectivity. It installs nothing, reads no secret
configuration and never requests sudo. FAIL means a prerequisite needs attention;
WARN requires review, not necessarily a broken setup. Existing PostgreSQL commonly
produces a port warning. The non-interactive sudo policy query does not authenticate or run a privileged
command; even a successful query does not guarantee every setup command is allowed.
Use `--offline` to omit network probes, or `--port 55432` to inspect a custom port.
The optional argument does not update `.env` or reserve that port.

## Managed computers

Ask the instructor for an individual Ubuntu VM when your device blocks WSL,
installation or sudo. The VM administrator runs the same setup, and the student
uses its non-administrator database identities. Each learner needs a private
checkout, private generated credentials and an isolated lab server; do not share
the example account or a production database. The instructor must confirm the
connection instructions and a private submission route before assigning work.
An offline machine cannot perform the first installation without prepared packages.
This repository does not provision a hosted VM service. A container path is not
part of the tested setup.

## PostgreSQL port and existing installations

On your disposable Ubuntu machine, inspect before changing anything:

```bash
pg_lsclusters
ss -ltn
```

If `pg_lsclusters` is unavailable, PostgreSQL's Ubuntu management packages may not
yet be installed. A TCP listener does not prove that the service is PostgreSQL or
that it belongs to this course. Never kill an unfamiliar process, remove its data,
or weaken authentication to resolve a conflict. Use a fresh individual VM if the
existing installation serves other work.

For an already provisioned, dedicated local PostgreSQL cluster on another port,
set `IT4065C_DB_PORT` in private `.env` to the port shown by `pg_lsclusters`, then
run bootstrap and Lab 1. The value selects an existing server; it does not change
the server's listening port.

An instructor can create a separate cluster on an unused port in a disposable VM:

```bash
pg_lsclusters
sudo pg_createcluster <installed-major-version> it4065c --port=55432 --start
```

Replace `<installed-major-version>` with the installed PostgreSQL major version
(for example, the version displayed by `pg_lsclusters`); do not paste the placeholder.
Confirm port 55432 is unused first. Generate `.env` with
`python3 scripts/course.py configure` only if absent, edit its port to `55432`,
then run `bash scripts/setup.sh`. If Python dependencies are already installed,
run `.venv/bin/python scripts/course.py bootstrap` and then `lab 1` instead.
Do not rerun cluster creation if the named cluster already exists; inspect its
status and consult its administrator. Existing course DB/role ownership markers
still apply. Keep server changes under instructor supervision.


---

Author: [Isaac K. Nti](../AUTHORS.md). [Citation and reuse terms](../CITATION.md).
