# Appendix E
# Environment Setup and Troubleshooting

This appendix provides a stable orientation to the course environment and a diagnostic reference. Follow `docs/local_run.md` in the checked-out repository for the complete installation procedure. The instructions here were checked against commit `d860dd98256a8090ffc6bd3766c59cb15a553c12`; commands and supported versions can change in later releases.

## E.1 Choose an isolated learning environment

The documented route is Ubuntu 24.04, with Ubuntu 22.04 also supported. Windows users use WSL 2 with Ubuntu or an individual Ubuntu virtual machine. The baseline supports Python 3.10–3.12. Its installer assumes a dedicated local learning environment and initial internet access and administrator privileges. Do not run it against a shared or production database server.

On Windows, these are PowerShell commands, not Ubuntu commands:

```powershell
wsl --list --verbose
wsl --list --online
```

Inspect whether an appropriate Ubuntu distribution is already installed and running as WSL 2. If a new distribution is needed and the machine permits installation, the documented installation form is:

```powershell
wsl --install -d Ubuntu-24.04
```

Use an administrator PowerShell window if Windows requires it; restart if prompted. Confirm the distribution name against the online list. On a managed device, use the institution's supported route. An existing WSL installation does not by itself prove that PostgreSQL or the course dependencies are ready.

## E.2 Prepare and run the supported setup

Open Ubuntu and work in its home filesystem. These are Bash commands. They install prerequisite tools and create a fresh checkout; if you already have a checkout, inspect it rather than cloning over existing work.

```bash
sudo apt-get update
sudo apt-get install -y git python3
mkdir -p ~/courses
cd ~/courses
git clone https://github.com/ntious/IT4065C-Labs.git
cd ~/courses/IT4065C-Labs
python3 scripts/preflight.py
bash scripts/setup.sh
```

The clone obtains the remote repository's current default branch. Record `git rev-parse HEAD`; do not label that checkout as the book's pinned baseline unless the identifiers match. For an assigned historical revision, follow the instructor's checkout instructions before setup. Do not overwrite local work to force a match.

The setup establishes the dedicated database configuration, Python environment, and dbt connection checks. Among its success messages are `PASS: connection, dedicated database, schemas and non-superuser builder.` and `PASS: dbt debug`. Preserve errors and warnings as well as success lines. These messages establish setup checks, not completion of the lab's written analysis or correctness of every later activity.

The default local connection uses host `127.0.0.1`, port `5432`, database `it4065c`, builder role `it4065c_owner`, student schema `student`, and source schema `raw`. The builder is a non-superuser. Local operating-system administration during provisioning is a separate authority. The loopback configuration's `sslmode=disable` is a local-course setting, not a recommendation for remote database traffic.

## E.3 Resume without reinstalling

In a later Ubuntu session, return to the checkout and run its check:

```bash
cd ~/courses/IT4065C-Labs
.venv/bin/python scripts/course.py check
```

If the diagnostic shows the local PostgreSQL service is stopped, use the repository's supported service command, `sudo service postgresql start`, then repeat the check. Avoid reinstalling merely because a service was stopped. The explicit `.venv/bin/python` path selects the project interpreter without requiring shell activation.

Run only the assigned lab. Core Labs 1–7 form the main sequence; Labs 8–15 are optional extensions. For example, `.venv/bin/python scripts/course.py lab 3` invokes the documented Lab 3 workflow. Complete the associated reasoning and evidence tasks as well as the technical steps.

## E.4 Protect configuration

The private `.env` contains literal `KEY=value` entries parsed by the course tools. Do not add shell `export` statements, command substitutions, or surrounding quotation marks unless the documented parser explicitly requires them. Do not run `source .env`. Existing environment variables can override values in the file; check for conflicting settings without printing their secret values.

The setup uses distinct generated credentials for the builder, analyst, and steward. Reader role names are derived from the database name. Do not reuse production credentials. Keep the file out of Git, screenshots, public submissions, and support messages. Changing a password in a file alone does not change the server-side password: use the documented bootstrap and Lab 5 workflow when rotation is needed.

Changing a configured port does not make PostgreSQL listen on that port. Changing only a database name does not isolate every related role or resource. If another exercise needs an independent environment, follow the documented naming and provisioning route; never delete an unfamiliar database or role to make setup succeed.

## E.5 Troubleshoot from the observed symptom

| Symptom | Check first | Reasonable next step |
| --- | --- | --- |
| Script cannot be found | Current directory and checkout contents. | Return to the repository root; verify spelling and case. |
| Python package is missing | Interpreter path and setup result. | Use `.venv/bin/python`; inspect the setup failure before installing ad hoc packages. |
| Connection refused | Service status, host, and port. | Start the dedicated local service if appropriate; inspect the configured endpoint. |
| Password authentication failed | Intended role and private configuration consistency. | Use the supported credential repair procedure; redact secrets from reports. |
| SQLSTATE 42501 | Effective role, object, and intended permission. | Determine whether denial is the expected test outcome or a configuration problem. |
| SQLSTATE 42P01 | Object name, schema, and prerequisite lab. | Verify creation and qualification; this is not evidence of permission denial. |
| dbt reports missing relation or failed test | Selection, prerequisites, resource-level results. | Preserve the error and inspect the named dependency or failed assertion. |
| Permission error under a Windows-mounted path | Filesystem location and ownership. | Use the documented Ubuntu-home checkout; do not grant universal permissions. |
| Port already in use | `pg_lsclusters` and listening ports, where available. | Identify the existing service; do not terminate an unfamiliar process. |

If evidence is needed for support, record the repository revision, OS, Python/PostgreSQL/dbt versions, exact command, UTC start/end times, exit status, and a redacted error excerpt. State what you expected and what actually happened. An installation failure is useful evidence; it should not be rewritten as a successful run.

## E.6 Choose the course or companion route

The local repository has two distinct learning routes. The existing `labs/` sequence uses the course setup and configured database. The optional book examples live in the root-level `textbook-companion/` folder and create temporary private database clusters. Start at `textbook-companion/README.md`; its `CHAPTER_GUIDE.md` connects examples and activities to the chapters. Direct repository access is https://github.com/ntious/IT4065C-Labs .

The companion launcher was exercised on Ubuntu 24.04.4 under WSL, with Python 3.12.3 and PostgreSQL 16.15. Its supported target is a non-root Linux/WSL account, Python 3.12 and PostgreSQL 16 server/client tools; the lifecycle suite also uses the locked psycopg2 dependency. This is narrower than the general course Python range. Installing all prerequisites on a fresh machine and independent learner completion were not verified by those runs. Follow `textbook-companion/SETUP.md` for the current tool list and prerequisites.

From the repository root, after prerequisites are available, choose a relevant suite:

```bash
.venv/bin/python textbook-companion/run.py foundations
.venv/bin/python textbook-companion/run.py transactions
.venv/bin/python textbook-companion/run.py lifecycle
.venv/bin/python textbook-companion/run.py reasoning
```

These are alternatives, not a requirement to run all four. The launcher ignores inherited database-target settings and generates temporary demonstration credentials where needed. It does not connect to the course database. Do not run the low-level SQL or shell harnesses directly against an existing database.

Inspect the selected suite's PASS/FAIL status in its private `summary.json`, then inspect the actual observations and limitations. Results go to a new directory under `.local/textbook-companion/`; the public `textbook-companion/evidence/` contains supplied reference extracts. A custom output directory must be new. Missing server tools require prerequisite repair; an existing result directory requires a new name; a failed assertion requires investigation and retention of the failure, not a changed expectation merely to obtain PASS.

The earlier course baseline does not contain this new companion folder. Use an edition that includes it, and record both the course fixture baseline and the companion revision or manifest as described in Appendix C. The native PostgreSQL companion run did not verify Docker setup. Normal and handled-failure cleanup is implemented; forced termination or an operating-system crash requires a separate ownership-aware cleanup check.

## E.7 Sources and further reading

Microsoft. (n.d.). Install WSL. https://learn.microsoft.com/en-us/windows/wsl/install

Microsoft. (n.d.). Working across Windows and Linux file systems. https://learn.microsoft.com/en-us/windows/wsl/filesystems

Nti, I. K. (2026). IT4065C-Labs: Data Technologies Administration [Software and instructional materials]. https://doi.org/10.5281/zenodo.24046602 . Direct repository: https://github.com/ntious/IT4065C-Labs . Authoritative course sources: docs/local_run.md, docs/setup.md, scripts/README.md, and scripts/course.py at commit d860dd98256a8090ffc6bd3766c59cb15a553c12.
