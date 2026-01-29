# M2 Lab 3 Troubleshooting Guide (dbt Modeling: Staging → Core → Marts)

This guide anticipates the most common failure points students hit in **M2 Lab 3** and gives **fast fixes** you can try *without editing dbt/SQL files* (the lab is command-driven).  
Use it when `dbt debug`, `dbt run`, `dbt test`, or the `psql ... -f lab3_quick_checks.sql` validation step fails.  
(Reference lab steps and expectations from the Lab 3 handout.) fileciteturn2file0

---

## 0) Quick triage checklist (do this first)

### Confirm you are in the right repo and project folder
```bash
pwd
ls
```
Expected: you are inside `~/IT4065C-Labs`.

Then:
```bash
cd ~/IT4065C-Labs
source dbt-venv/bin/activate
cd dbt/it4065c_platform
```
If you are not inside `dbt/it4065c_platform`, dbt will often fail with “project not found” symptoms. fileciteturn2file0

### Confirm required files exist (Lab Step 1)
From repo root:
```bash
ls -la labs/module_2/lab3
ls -la dbt/it4065c_platform/models/staging/lab3
ls -la dbt/it4065c_platform/models/core/lab3
ls -la dbt/it4065c_platform/models/marts/lab3
ls -la dbt/it4065c_platform/models/lab3/_lab3_models.yml
```
If any are missing: **stop** and re-clone / notify TA. fileciteturn2file0

---

## 1) Environment & activation errors (Step 2.1)

### Error: `source: not found` or “activate” doesn’t change prompt
**Symptoms**
- You ran `source dbt-venv/bin/activate` but your prompt doesn’t show `(dbt-venv)`.
- `dbt: command not found`.

**Likely causes**
- You are in the wrong directory.
- The virtual environment folder doesn’t exist.

**Fix**
```bash
cd ~/IT4065C-Labs
ls -la dbt-venv/bin/activate
source dbt-venv/bin/activate
which dbt
dbt --version
```
If `dbt-venv/` is missing, your environment setup didn’t complete—run the course preflight / setup steps (or re-run the lab’s setup script if your course uses one).

---

## 2) `dbt debug` failures (Step 2.2)

### Error: `Could not find profile named ...` / `profiles.yml` not found
**Symptoms**
- `dbt debug` shows: *“Could not find profile named …”* or *“profiles.yml not found”*.

**Likely causes**
- Your `profiles.yml` is missing or not where dbt expects it (`~/.dbt/profiles.yml` by default).
- `DBT_PROFILES_DIR` is not set (or set incorrectly).

**Fix**
1) Check expected location:
```bash
ls -la ~/.dbt/profiles.yml
```
2) If your course uses a repo-based profiles dir, check env var:
```bash
echo $DBT_PROFILES_DIR
```
3) If `profiles.yml` exists but dbt can’t see it, try:
```bash
dbt debug --profiles-dir ~/.dbt
```
If you do not have a `profiles.yml`, do **not** guess values—notify TA (it is course-provided).

---

### Error: `Database Error: connection refused` (Postgres not reachable)
**Symptoms**
- `dbt debug` fails on connection with “connection refused”.

**Likely causes**
- Postgres service is not running.
- Wrong host/port in dbt profile.
- You’re on a different machine/context than expected (sandbox vs personal install).

**Fix**
First, confirm Postgres is listening:
```bash
psql -h localhost -U postgres -d postgres -c "select 1;"
```
If that fails, try checking service status (depends on environment):

**Ubuntu VM / regular Linux service**
```bash
sudo systemctl status postgresql
sudo systemctl start postgresql
```

**WSL note:** `systemctl` may not work in some WSL setups. If `systemctl` fails, use the course’s recommended Postgres startup method (Docker compose, service script, etc.) for your environment.

---

### Error: `password authentication failed for user "postgres"` / prompts for password unexpectedly
**Symptoms**
- `dbt debug` fails with authentication error.
- `psql` prompts for a password but you don’t know it.

**Likely causes**
- Your local Postgres user password is not what the dbt profile expects.
- `pg_hba.conf` is enforcing md5/scram auth (normal).

**Fix**
Try connecting with password prompt:
```bash
psql -h localhost -U postgres -d postgres
```
If you can’t authenticate, you must use the **course-provided** credentials or Postgres setup instructions for the lab environment. Do not randomly reset passwords if your course VM is shared/managed—notify TA.

---

### Error: `database "it4065c" does not exist`
**Symptoms**
- `dbt debug` fails because the target database is missing.
- Later, quick checks fail for the same reason.

**Fix**
Confirm databases:
```bash
psql -h localhost -U postgres -d postgres -c "\l"
```
If `it4065c` is missing, it usually means your lab database setup/seed step didn’t run. Follow your course’s environment setup instructions or ask TA.

---

## 3) `dbt run --select path:models/lab3` problems (Step 2.3)

### Error: `The selection criterion 'path:models/lab3' does not match any nodes`
**Symptoms**
- dbt says selection matches 0 models.

**Likely causes**
- You are in the wrong dbt project directory (not in `dbt/it4065c_platform`).
- Your dbt project’s `models/` structure differs (or files missing).

**Fix**
```bash
cd ~/IT4065C-Labs/dbt/it4065c_platform
ls -la models/lab3
dbt ls --select path:models/lab3
```
If `models/lab3` doesn’t exist, notify TA (files missing).

---

### Error: `Compilation Error` / `Parsing Error` / `Jinja` error
**Symptoms**
- dbt fails before running SQL.

**Likely causes**
- Corrupted repo files due to partial download or accidental edits.
- Wrong dbt version vs course package expectations.

**Fix**
1) Confirm you did not edit lab files (per lab instructions). fileciteturn2file0  
2) Hard reset repo if needed (only if you know git):
```bash
cd ~/IT4065C-Labs
git status
git checkout -- .
git clean -fd
```
If you’re not comfortable with git: re-clone the repo (TA can help).

---

### Error: `relation "raw.orders" does not exist` (or other raw tables missing)
**Symptoms**
- dbt run fails saying a raw table is missing.

**Likely causes**
- Raw seed tables were not loaded.
- You are pointing dbt at the wrong database/schema.

**Fix**
Check whether raw tables exist:
```bash
psql -h localhost -U postgres -d it4065c -c "\dt raw.*"
```
If empty, run the provided raw loader (Lab notes say Lab 3 includes a seed script from Lab 2). fileciteturn2file0  
From repo root:
```bash
cd ~/IT4065C-Labs
psql -h localhost -U postgres -d it4065c -f labs/module_2/lab2_seed.sql
```
Then rerun:
```bash
cd dbt/it4065c_platform
dbt run --select path:models/lab3
```

---

### Error: `permission denied for schema ...` or `must be owner of schema`
**Symptoms**
- dbt can connect, but cannot create models.

**Likely causes**
- The user in your dbt profile does not have CREATE privileges.
- You are using a restricted Postgres account.

**Fix**
- Use the **course-specified** user/account.
- If you can access postgres as admin, verify privileges (TA may do this):
```sql
-- Example (run in psql as an admin)
GRANT CREATE ON SCHEMA public TO <your_user>;
```
In student environments, the correct fix is usually: **use the right credentials/profile** rather than changing permissions.

---

## 4) `dbt test` failures (Step 2.4)

The lab expects **all tests pass**, including uniqueness/not-null and relationships. fileciteturn2file0

### Test failure: `not_null_*` or `unique_*`
**Symptoms**
- dbt test shows FAIL for not_null / unique.

**Likely causes**
- Raw data load was incomplete/corrupted (seed script didn’t fully run).
- You are using the wrong database instance (data differs).
- Someone edited raw data in the DB.

**Fix**
Re-seed raw data cleanly:
```bash
cd ~/IT4065C-Labs
psql -h localhost -U postgres -d it4065c -f labs/module_2/lab2_seed.sql
```
Then rebuild and retest:
```bash
cd ~/IT4065C-Labs/dbt/it4065c_platform
dbt run --select path:models/lab3
dbt test --select path:models/lab3
```
If still failing, take a screenshot of the failing test output and notify TA (don’t edit models).

---

### Test failure: `relationships_*` (foreign key “orphans”)
**Symptoms**
- Relationship tests fail (e.g., order items referencing orders/customers/products that don’t exist).

**Likely causes**
- Partial load: one raw table loaded but another didn’t.
- Inconsistent data in your database instance.

**Fix**
Same as above: re-run the seed, then run + test again. If it persists, notify TA (your dataset may be inconsistent).

---

## 5) `psql -f lab3_quick_checks.sql` problems (Step 2.5)

### Error: `psql: command not found`
**Fix**
Install client tools (TA may handle for sandbox). On Ubuntu:
```bash
sudo apt-get update
sudo apt-get install -y postgresql-client
```
In managed environments, you may not have sudo—notify TA.

---

### Error: `could not connect to server: No such file or directory` or `connection refused`
**Fix**
Same as dbt debug connection fixes: ensure Postgres is running and reachable on `localhost`. (See Section 2.)

---

### Error: `permission denied` selecting from schemas (core/marts)
**Likely causes**
- You’re connecting as a user without SELECT access.

**Fix**
Use the same DB user the course expects for querying (often `postgres` in local labs):
```bash
psql -h localhost -U postgres -d it4065c -f labs/module_2/lab3/lab3_quick_checks.sql
```

---

### You see `(END)` and can’t type commands
This is `less` pager, not an error. The lab warns about this. fileciteturn2file0

**Fix**
- Press `q` to exit pager.
- Or disable pager for the session:
```bash
export PAGER=cat
```

---

### Output row counts are different from “expected”
Lab explicitly says exact numbers may differ slightly; you’re checking **existence, structure, and non-zero counts**. fileciteturn2file0  
If you see **all zeros**, that usually means models didn’t build or you queried the wrong DB.

---

## 6) Screenshot / submission pitfalls (Deliverables)

Lab requires 5 screenshots (files exist, debug, run, test, quick checks) plus written answers. fileciteturn2file0

### Common issues
- Screenshot cuts off the command or the success/fail line.
- Screenshot shows the wrong directory (missing context).
- Students submit only screenshots and forget written responses.

**Fix**
- Always capture the **command + output + prompt** in one image.
- For `dbt run/test`, capture the final summary lines.
- For quick checks, capture at least one portion showing results + row counts.

---

## 7) “Do not edit files” guardrails (important)

The lab’s core principle: **do not guess and do not change dbt/SQL files** to “make it pass.” fileciteturn2file0  
If outputs don’t match expectations after re-seeding and re-running, document what happened (screenshots) and escalate to TA/instructor.

---

## 8) High-probability issues by step (fast map)

- **Step 2.1**: venv not activated → `dbt` not found.
- **Step 2.2**: profiles missing / Postgres down / wrong password → `dbt debug` fails.
- **Step 2.3**: raw tables missing → `relation raw.* does not exist`.
- **Step 2.4**: partial seed → relationship tests fail.
- **Step 2.5**: pager `(END)` confusion / wrong DB name / Postgres not reachable.

---

## 9) When to escalate (don’t burn time)

Escalate to TA/instructor if:
- Required files are missing.
- `profiles.yml` is missing and you were not given one.
- You cannot authenticate to Postgres with course credentials.
- dbt compilation errors persist after re-cloning/resetting.
- Relationship/uniqueness tests fail after a clean reseed and rebuild.

Include: the exact command you ran + the last 20 lines of the error output + screenshot(s).
