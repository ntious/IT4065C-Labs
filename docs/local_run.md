# Run the course on your Windows computer using Ubuntu

Use **Ubuntu 24.04 in WSL2** or a dedicated Ubuntu 24.04 VM. Both Ubuntu 22.04 and 24.04 passed the complete published workflow at
commit `f7b01ce777f6ee94743e139b48aaf2cad555afdd`, including optional Labs 10–11.
This verifies Ubuntu CI; it is not a separate interactive WSL usability test.
See [validation](validation.md) for the distinction between published and local checks.

## 1. Check or install Ubuntu: PowerShell

Run in PowerShell:

```powershell
wsl --list --verbose
```

If Ubuntu 24.04 is already listed with version 2, open that distribution. If it is
not installed, use **PowerShell as Administrator**:

```powershell
wsl --list --online
wsl --install -d Ubuntu-24.04
```

Use the exact distribution name shown by the online list. Restart if prompted,
then launch Ubuntu and create your own Linux username/password. You will use the
Linux password for sudo; it is different from the generated course database passwords.
Do not type or publish either password in a command example or issue.

Microsoft references: [WSL installation](https://learn.microsoft.com/en-us/windows/wsl/install),
[file placement](https://learn.microsoft.com/en-us/windows/wsl/filesystems).

## 2. Clone inside Linux: Ubuntu terminal

Use a new clone in your Linux home directory. Keep the Windows checkout for your
normal editing/publishing workflow. The Linux clone avoids cross-filesystem permission
surprises for `.env` and the virtual environment. Do not copy a Windows `.venv` into Ubuntu.

```bash
sudo apt-get update
sudo apt-get install -y git
mkdir -p ~/courses
cd ~/courses
git clone https://github.com/ntious/IT4065C-Labs.git
cd IT4065C-Labs
bash scripts/setup.sh
```

If that Linux clone already exists, enter it and review `git status` before using
`git pull --ff-only`; do not overwrite your own edits. Push desired Windows changes
before pulling them into the Linux clone.

Setup installs PostgreSQL and the Python environment, generates `.env`, provisions
the dedicated database and runs Lab 1. Keep `.env` private. No profile editing or
manual password exports are needed for the standard route.

## 3. Run and interpret the labs

```bash
.venv/bin/python scripts/course.py check
.venv/bin/python scripts/course.py lab 2
```

Follow the [lab sequence](../labs/README.md) one lab at a time. For your instructor
rehearsal on the unchanged synthetic fixture:

```bash
.venv/bin/python -m unittest discover -s tests -v
.venv/bin/python scripts/verify.py
.venv/bin/python scripts/optional_labs.py catalog
.venv/bin/python scripts/optional_labs.py promotion
```

The verifier deliberately introduces one bad quantity, requires a data-test failure,
restores the original value and rebuilds. It must finish with `VERIFICATION COMPLETE`.
Do not use this fixture-specific verifier on your independent real dataset.

After Lab 4, view lineage with:

```bash
.venv/bin/python scripts/course.py docs
```

Open http://127.0.0.1:8080 locally; stop the server with Ctrl+C. The optional KPI
report is `.local/optional-kpi.html`. To find it from WSL, `explorer.exe .local`
opens that output folder in Windows Explorer. Keep generated reports/logs private.

## 4. Stop and resume

You can close the Ubuntu terminal without deleting the database. Next time, return
to `~/courses/IT4065C-Labs`, start PostgreSQL if needed with
`sudo service postgresql start`, then run the `check` command. No venv activation is
required. See [setup and recovery](setup.md) for custom database names, passwords,
port conflicts and preserving existing data. Do not weaken authentication to fix an error.

---

Author: [Isaac K. Nti](../AUTHORS.md). [Citation and reuse terms](../CITATION.md).
