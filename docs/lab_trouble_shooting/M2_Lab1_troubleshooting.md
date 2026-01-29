# Lab 1 Troubleshooting — Preflight & Environment Readiness (IT4065C)

This troubleshooting guide is tailored to **Lab 1: Preflight & Environment Readiness** and focuses on the most common (and most likely) failure points students hit while completing Steps 1–11. It is written to be “copy/paste ready” with concrete commands.

> Scope: Ubuntu VM (UC Sandbox) **and** Windows WSL Ubuntu (Microsoft Store).  
> Lab reference: *Lab 1: Preflight & Environment Readiness* (PDF). fileciteturn0file0

---

## Quick “triage” checklist (do these first)

Run these in a terminal and compare to expected outcomes.

```bash
lsb_release -a
git --version
python3 --version
psql --version
```

Expected:
- Ubuntu **22.04 LTS or higher** (Jammy+).
- Git/Python/psql print version numbers. (Lab Step 3) fileciteturn0file0

If any command is missing, jump to **Step 3 issues** below.

---

## Step 1 — Ubuntu environment problems

### 1A) UC Sandbox VM won’t load / login fails
**Symptoms**
- VM page loads blank, freezes, or login fails repeatedly.
- Keyboard input doesn’t work in the VM console.

**Likely causes**
- Range/sandbox service hiccup.
- Browser issues, blocked third‑party cookies, or network restrictions.

**Fix**
- Try a different browser (Chrome/Edge), disable strict tracking, re-login.
- If still failing, **stop** and contact instructor/IT (the lab explicitly instructs this). fileciteturn0file0

---

### 1B) WSL Ubuntu installation issues (Microsoft Store)
**Symptoms**
- Ubuntu won’t launch, closes immediately, or shows “WslRegisterDistribution failed”.
- You get stuck at “Installing, this may take a few minutes…”.

**Fix**
1) Reboot Windows once after installing Ubuntu.
2) Ensure WSL is enabled and updated (PowerShell as Admin):
```powershell
wsl --update
wsl --shutdown
```
3) Relaunch Ubuntu and complete initial username/password setup. fileciteturn0file0

---

## Step 2 — `apt update/upgrade` problems

### 2A) “Could not get lock /var/lib/dpkg/lock-frontend”
**Symptoms**
- `sudo apt update` or `sudo apt upgrade -y` fails with a lock error.

**Cause**
- Another package process is running (often unattended upgrades).

**Fix**
Wait 1–3 minutes and retry:
```bash
sudo apt update
```
If it persists:
```bash
ps aux | grep -E "apt|dpkg"
```
Only if you’re sure it’s stuck (rare), you can reboot.

---

### 2B) “Temporary failure resolving …” / DNS errors
**Symptoms**
- `apt` cannot reach repositories.

**Fix**
- Confirm you have internet access.
- In WSL, restart WSL:
```powershell
wsl --shutdown
```
Then relaunch Ubuntu and retry Step 2. fileciteturn0file0

---

## Step 3 — Tool installation problems (git/python/postgres)

### 3A) `sudo: command not found` or “permission denied”
**Symptoms**
- `sudo` doesn’t work.

**Fix**
- On the UC VM, you should have sudo.
- On WSL, ensure you created your user during first launch (Step 1.2.4). fileciteturn0file0  
If you’re not an admin user, reinstall Ubuntu WSL or use the UC VM.

---

### 3B) `psql: command not found` after install
**Symptoms**
- `psql --version` fails after `apt install postgresql...`.

**Fix**
```bash
sudo apt update
sudo apt install -y postgresql postgresql-contrib
which psql
psql --version
```
If `which psql` returns nothing, your PATH is unusual; log out/in or reboot.

---

## Step 4 — PostgreSQL service status issues

### 4A) `systemctl` fails (very common on WSL)
**Symptoms**
- `sudo systemctl status postgresql` returns:
  - `System has not been booted with systemd`
  - or `Failed to connect to bus`.

**Cause**
- Many WSL setups do not run `systemd` by default, so `systemctl` won’t work.

**Fix (WSL-friendly)**
Use `service` instead:
```bash
sudo service postgresql status
sudo service postgresql start
```
Then confirm:
```bash
pg_isready
```
If `pg_isready` is not installed:
```bash
sudo apt install -y postgresql-client
```
(You can keep the rest of the lab the same; only the service commands change.) fileciteturn0file0

---

### 4B) PostgreSQL is “inactive (dead)”
**Fix**
```bash
sudo systemctl start postgresql   # UC VM
# or (WSL)
sudo service postgresql start
```

---

## Step 5 — Database/schema creation issues

### 5A) Confusing `psql` vs `Psql` (case sensitivity)
**Symptoms**
- Typing `Psql` gives: `command not found`.

**Cause**
- Linux commands are case sensitive. The PDF shows `Psql` once in Step 4; the actual command is `psql`. fileciteturn0file0

**Fix**
Use lowercase:
```bash
psql
```

---

### 5B) `createdb: command not found`
**Cause**
- PostgreSQL client utilities not installed.

**Fix**
```bash
sudo apt install -y postgresql-client
```

---

### 5C) `sudo -u postgres createdb it4065c` fails with permissions
**Symptoms**
- “role ‘postgres’ does not exist” (rare) or permissions errors.

**Fix**
1) Ensure PostgreSQL installed and running (Step 4 fixes).
2) Confirm postgres user exists:
```bash
getent passwd postgres
```
3) Retry:
```bash
sudo -u postgres createdb it4065c
```

---

### 5D) Schema already exists (not an error)
**Symptoms**
- `ERROR: schema "raw" already exists`

**Fix**
This is OK in re-runs. Continue.

---

### 5E) **Hard bug in lab instructions: postgres password is never actually set**
**Where it shows up**
- Step 8/9 expects dbt to connect as `user: postgres` with password `"Pa$$w0rd123!"`.  
- Step 10 expects you to authenticate with `psql -h localhost -U postgres ...` using that password. fileciteturn0file0

**Why students fail**
- On a fresh Ubuntu Postgres install, local connections commonly use **peer authentication** (no password), and the `postgres` role often has **no password set** for TCP connections. The lab does not include an `ALTER USER postgres PASSWORD ...` step.

**Fix (recommended, do once)**
1) Set the postgres password:
```bash
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'Pa$$w0rd123!';"
```

2) Ensure localhost auth allows password (common on Ubuntu):
Open pg_hba.conf:
```bash
sudo -u postgres psql -t -P format=unaligned -c "SHOW hba_file;"
```
Then edit that file:
```bash
sudo nano /path/printed/above
```

Look for lines like these (examples):
- `local   all   postgres   peer`
- `host    all   all       127.0.0.1/32   scram-sha-256` (or `md5`)

**Safe adjustment**
- For the postgres user, change `peer` → `scram-sha-256` or `md5` (depending on what the file uses elsewhere).
- Save and restart Postgres:
```bash
sudo systemctl restart postgresql   # UC VM
# or (WSL)
sudo service postgresql restart
```

Then test:
```bash
psql -h localhost -U postgres -d it4065c
```
Use password: `Pa$$w0rd123!` fileciteturn0file0

> Teaching note: This is the single biggest “it works for me but not for them” issue in this lab.

---

## Step 6 — Git clone issues

### 6A) `git clone` fails (authentication / network)
**Symptoms**
- “Could not resolve host: github.com”
- “TLS handshake” / proxy errors.

**Fix**
- Confirm internet and DNS (see Step 2B).
- On restricted networks, try from home or UC VM network.

---

### 6B) `IT4065C-Labs` folder already exists
**Fix**
Either remove it or pull updates:
```bash
rm -rf ~/IT4065C-Labs
# or
cd ~/IT4065C-Labs && git pull
```

---

## Step 7 — Python venv / dbt install issues

### 7A) `python3 -m venv dbt-venv` fails (“ensurepip is not available”)
**Fix**
```bash
sudo apt update
sudo apt install -y python3-venv python3-pip
python3 -m venv dbt-venv
```
(Lab Step 3 includes these packages; the failure typically means Step 3 didn’t complete.) fileciteturn0file0

---

### 7B) `pip install dbt-postgres` installs, but `dbt` command not found
**Cause**
- venv not activated in the current shell.

**Fix**
```bash
source ~/IT4065C-Labs/dbt-venv/bin/activate
which dbt
dbt --version
```
You should see the Postgres adapter listed. fileciteturn0file0

---

### 7C) `pip install` fails with SSL / certificate errors
**Fix**
Update certificates:
```bash
sudo apt update
sudo apt install -y ca-certificates
```
Retry install in the venv.

---

## Step 8 — dbt profile configuration issues (profiles.yml)

### 8A) dbt can’t find your profile
**Symptoms**
- `dbt debug` shows:
  - “Could not find profile named …”
  - “No profiles.yml found”

**Cause**
- dbt looks for profiles at `~/.dbt/profiles.yml` by default.  
- The lab instructs editing `profiles.yml` **inside** `dbt/it4065c_platform/` (project folder). fileciteturn0file0  
Unless the project sets `DBT_PROFILES_DIR` (or you run dbt with `--profiles-dir`), dbt won’t read that file.

**Fix Option A (most reliable for students)**
Copy the profile to the default location:
```bash
mkdir -p ~/.dbt
cp ~/IT4065C-Labs/dbt/it4065c_platform/profiles.yml ~/.dbt/profiles.yml
```

**Fix Option B (keep profile in project folder)**
Run dbt with an explicit profiles directory:
```bash
dbt debug --profiles-dir .
```
(You must run that from inside `dbt/it4065c_platform`.)

> Instructor improvement: consider adding one explicit line in the lab:  
> `cp profiles.yml ~/.dbt/profiles.yml` OR instruct `dbt ... --profiles-dir .`

---

### 8B) YAML indentation errors (extremely common)
**Symptoms**
- `dbt debug` fails with YAML parsing errors.
- Or it loads profile but outputs are missing.

**Cause**
- YAML is whitespace sensitive. A single mis-indent breaks it.

**Fix**
Use exactly this structure (spacing matters). **Do not use tabs.**
```yaml
it4065c_platform:
  target: dev
  outputs:
    dev:
      type: postgres
      user: postgres
      password: "Pa$$w0rd123!"
      host: localhost
      port: 5432
      dbname: it4065c
      schema: student_kofi
      threads: 2
      sslmode: prefer
```
This matches the lab’s expected configuration. fileciteturn0file0

---

### 8C) Wrong schema name (students forget to customize)
**Symptoms**
- dbt connects, but later labs write into the wrong schema or permissions fail.
- `CREATE TABLE student_kofi.test_table...` fails because schema doesn’t exist.

**Cause**
- Step 5 creates `student_kofi` in the PDF example; students must use **their own** schema name if required by course policy (or keep exactly as instructed).

**Fix**
- If you are required to use a personalized schema (e.g., `student_jane`), create it:
```sql
CREATE SCHEMA student_jane;
```
…and update `schema:` in profiles.yml accordingly.

---

## Step 9 — `dbt debug` failures (connection test)

### 9A) “Connection test: FAILED” / authentication errors
**Most likely causes**
- Postgres password not set (see **Step 5E**).
- pg_hba.conf still uses `peer` for the postgres user.
- Wrong host/port/dbname in profiles.yml.

**Fix**
- Apply Step 5E (set password + adjust pg_hba.conf).
- Re-run:
```bash
dbt debug
```
Expected: “Profile loaded successfully” and “Connection test: OK”. fileciteturn0file0

---

### 9B) “could not connect to server: Connection refused”
**Cause**
- Postgres not running.

**Fix**
Start service (Step 4A/4B), then retry.

---

### 9C) Port 5432 already in use (rare)
**Symptoms**
- Postgres won’t start or binds fail.
- `ss -ltnp | grep 5432` shows another process.

**Fix**
- Identify the process:
```bash
sudo ss -ltnp | grep 5432
```
- Stop conflicting service or change Postgres port (advanced; typically instructor/TA handles).

---

## Step 10 — Basic SQL validation issues

### 10A) `psql -h localhost -U postgres -d it4065c` prompts for password but always fails
**Cause**
- Password not set or auth method mismatch (Step 5E).
- You typed the password wrong (note special characters).

**Fix**
- Re-run the password set command and restart Postgres:
```bash
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'Pa$$w0rd123!';"
sudo systemctl restart postgresql  # or sudo service postgresql restart (WSL)
```
- Try again.

---

### 10B) `ERROR: schema "student_kofi" does not exist`
**Cause**
- Step 5 schema creation wasn’t done, or you used a different schema name.

**Fix**
Create it:
```bash
sudo -u postgres psql it4065c
```
Then:
```sql
CREATE SCHEMA student_kofi;
\q
```
Retry Step 10 queries. fileciteturn0file0

---

### 10C) `permission denied for schema student_kofi`
**Cause**
- Ownership/privileges mismatch (rare if created as postgres).

**Fix**
Grant privileges (run as postgres in psql):
```sql
GRANT ALL ON SCHEMA student_kofi TO postgres;
```

---

## Step 11 — Deliverables / “I rebooted and everything broke”

### 11A) dbt stops working after reboot
**Cause**
- venv not activated.

**Fix**
The lab’s resume instructions are correct: fileciteturn0file0
```bash
cd ~/IT4065C-Labs
source dbt-venv/bin/activate
```

### 11B) Postgres not running after reboot (WSL especially)
**Fix**
Start it again:
```bash
sudo service postgresql start   # WSL
# or
sudo systemctl start postgresql # UC VM
```

---

## “Known lab text issues” instructors may want to patch

1) **`Psql` should be `psql`** (Step 4). fileciteturn0file0  
2) **Postgres password setup is referenced but not included** (Step 8/10 depend on it). fileciteturn0file0  
3) **profiles.yml location ambiguity**: dbt default is `~/.dbt/profiles.yml`; lab edits a project-local file without explicitly setting `--profiles-dir` or copying to `~/.dbt`. fileciteturn0file0

---

## If you’re still stuck (what to capture for fast TA help)

Send **one screenshot** or paste of:
1) `lsb_release -a`
2) `sudo systemctl status postgresql` (or `sudo service postgresql status` on WSL)
3) `dbt debug` output (full)
4) The **exact** contents of your `profiles.yml` (redact password if required)

This typically makes issues solvable in one response.
