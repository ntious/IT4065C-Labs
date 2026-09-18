# Setup and configuration

## Prerequisites

Start with [the local Windows/Ubuntu run guide](local_run.md) if you use Windows.
Ubuntu 22.04 and 24.04 passed the published workflow at commit `f7b01ce`;
see [validation](validation.md) for exact scope and evidence.

Use Ubuntu 22.04 or 24.04 in an individual VM or WSL2, with Python 3.10–3.12,
sudo access, internet access for the initial installation, and about 4 GB of
available RAM and 4 GB of free disk for this small local stack. These are planning
guidelines, not measured minimums. In WSL, clone into your Linux home directory
so private-file permissions behave as expected. Windows users run the commands inside Ubuntu,
not PowerShell. macOS users can use an Ubuntu VM. No institutional account is
required. Do not run setup on a shared or production PostgreSQL server.

From your checkout run `bash scripts/setup.sh`. It installs Ubuntu packages,
starts PostgreSQL, installs the hash-locked Python dependencies into `.venv`,
creates `.env` if absent, provisions course identities, and executes Lab 1.
It does not upgrade the entire operating system or delete existing data.

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

After closing the terminal, `cd` back to the checkout and run:

```bash
.venv/bin/python scripts/course.py check
.venv/bin/python scripts/course.py lab 2
```

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

---

Author: [Isaac K. Nti](../AUTHORS.md). [Citation and reuse terms](../CITATION.md).
