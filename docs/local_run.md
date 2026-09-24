# Install and resume the local course environment

This is the single installation route. Choose **A or B**, then follow the common
steps once. Course commands run in an **Ubuntu terminal**, including on Windows.

| Your computer | Route |
| --- | --- |
| Windows | A: Ubuntu through WSL2 |
| Ubuntu 24.04 or 22.04 | B: use Ubuntu directly; WSL is unnecessary |
| Another Linux distribution or macOS | Use an individual Ubuntu 24.04 VM, then B. The scripts use Ubuntu packages; other distributions are not verified installation targets. |

Ubuntu 24.04 is recommended for a new environment; Ubuntu 22.04 is also supported.
Use your own disposable learning environment with internet access, sudo permission,
and about 4 GB free RAM and disk as planning allowances. Do not use a shared or
production database server. A managed device may need its administrator to provide
an individual Ubuntu VM. No paid or institutional account is needed for the local labs.

## Terms used during setup

| Term | Meaning here |
| --- | --- |
| Terminal | The window where you type commands. Use PowerShell only where labeled; run course commands in Ubuntu. |
| WSL2 / VM | A Linux environment on Windows / a separate virtual operating-system environment. Neither is needed on native Ubuntu. |
| `.venv` | The course's Python package environment, not a separate operating system. |
| Repository root | The checkout folder containing `scripts`, `labs` and `docs`. Run course commands there. |

The [environment glossary](glossary.md#course-and-environment) is available if you need more detail.

## A. Windows: open Ubuntu through WSL2

**In PowerShell**, check:

```powershell
wsl --list --verbose
```

If Ubuntu 22.04/24.04 is listed with VERSION 2, open that Ubuntu distribution from
the Windows Start menu. Otherwise, in **PowerShell as Administrator**, run:

```powershell
wsl --list --online
```

Choose Ubuntu 24.04 from that list. When its name is `Ubuntu-24.04`, install it with:

```powershell
wsl --install -d Ubuntu-24.04
```

Restart if requested. Open Ubuntu and create your Linux username/password. While
typing a Linux password, no characters may appear; that is normal. Keep it private.
For installation or WSL-version problems, use [Microsoft's WSL guide](https://learn.microsoft.com/en-us/windows/wsl/install).

**Now switch to the Ubuntu terminal.** Use the release check in Route B if your
distribution is simply named `Ubuntu` and you do not know its release. Then
continue at Common step 1. Do not run the
remaining commands in PowerShell. Store the checkout in Ubuntu's home directory,
not under `/mnt/c`; see [Microsoft's file-placement guidance](https://learn.microsoft.com/en-us/windows/wsl/filesystems).

## B. Ubuntu: use the installed system directly

Open the Terminal application. Confirm your Ubuntu release:

```bash
cat /etc/os-release
```

Look for Ubuntu and version 22.04 or 24.04. No WSL installation is needed.
On a dedicated Ubuntu VM the steps are the same. Continue below.

## Common step 1: obtain the course files

Run each command separately in Ubuntu. The first two require your Linux sudo
password. They prepare Git so you can download the repository.

```bash
sudo apt-get update
```

```bash
sudo apt-get install -y git
```

```bash
mkdir -p ~/courses
```

```bash
cd ~/courses
```

```bash
git clone https://github.com/ntious/IT4065C-Labs.git
```

```bash
cd ~/courses/IT4065C-Labs
```

If this checkout already exists, enter it; do not clone over or delete your work.
If you intentionally chose another location, use that location in all return commands.
A **repository root** is this folder: running `ls` shows `README.md`, `labs` and `scripts`.

## Common step 2: check readiness

```bash
python3 scripts/preflight.py
```

Expected: readiness results labeled PASS, WARN or FAIL. This command installs nothing.

- **PASS:** that prerequisite check succeeded.
- **WARN:** read the explanation. An existing database listener or an unconfirmed
  non-interactive sudo query is not automatically a failure. Follow the matching
  [setup guidance](setup.md#read-only-installation-preflight).
- **FAIL:** resolve the named prerequisite using [recovery](troubleshooting.md)
  before proceeding. If Python is missing, ask the Ubuntu administrator to install
  `python3`; the preflight cannot run until an interpreter is available.

For an unconfirmed sudo-policy WARN on your own Ubuntu environment, run `sudo -v`.
It may request your Linux password; a return to the prompt without an error confirms
that authentication succeeded. It does not guarantee that a managed device permits
every installation command. If permission is denied, contact its administrator.
For a port WARN, use [port diagnostics](setup.md#postgresql-port-and-existing-installations)
before setup; do not stop a service used by other work.

If terminal commands are unfamiliar, work through [Foundations, Part A](foundations.md#part-a-before-installation)
before continuing. No SQL knowledge is needed for installation.

## Common step 3: install and verify once

```bash
bash scripts/setup.sh
```

Setup installs PostgreSQL and a private Python environment, creates `.env` with
unique passwords, provisions the course database and runs Lab 1's technical checks.
It may ask for the Linux sudo password. It never asks for university credentials.
Package-download output can be long; wait for the command to finish. Download time
varies with the network. If it ends with an error, preserve the short error message
and follow [setup recovery](setup.md#restart-checks-and-recovery).

Near the end, successful setup includes:

```text
PASS: connection, dedicated database, schemas and non-superuser builder.
PASS: dbt debug
```

Keep these two lines privately. Do not copy the full package list or `.env`.
Default configuration needs no edits. Custom configuration is documented in
[setup](setup.md#your-one-configuration-file), for learners who need it.

## Common step 4: begin the learning activity

Open [Lab 1](../labs/module1_preflight/README.md). Use your setup evidence and
complete its short worksheet. **Do not repeat installation or the technical check
after success.** The next activity is Lab 2; follow the [course checklist](course_checklist.md)
so discussions and the capstone are not hidden behind separate navigation routes.

## Stop and resume

After saving your writing, you can close the terminal. If serving Lab 4 documentation,
first stop its server with Ctrl+C. Closing the terminal does not delete the database.

Next time open Ubuntu and run:

```bash
cd ~/courses/IT4065C-Labs
```

Continue at the next unfinished step on your lab page. No environment activation,
password export, new clone or repeat setup is needed. If a command reports a database
connection failure, start the local service:

```bash
sudo service postgresql start
```

Then check:

```bash
.venv/bin/python scripts/course.py check
```

Return to your lab when the check passes. For private help or independent-study
support, use [the help guide](self_study.md#when-you-are-stuck).

---

Author: [Isaac K. Nti](../AUTHORS.md). [Citation and reuse terms](../CITATION.md).
