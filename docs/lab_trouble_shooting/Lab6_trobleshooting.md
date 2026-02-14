# Lab 6 Troubleshooting Guide
## Module 6 – Lab 6: Monitoring Evidence & Compliance Reasoning (IT4065C)

This guide is tailored to the **actual Lab 6 script**:

- **DB:** `it4065c`  
- **Host:** `localhost`  
- **User:** `postgres`  
- **SQL files:**  
  - `labs/module_6/lab6/00_prepare_audit_evidence.sql`  
  - `labs/module_6/lab6/01_generate_audit_report.sql`

Script excerpt (for reference):

```bash
psql -h localhost -U postgres -d it4065c -f labs/module_6/lab6/00_prepare_audit_evidence.sql
psql -h localhost -U postgres -d it4065c -f labs/module_6/lab6/01_generate_audit_report.sql
````

> **Lab 6 goal:** Generate a monitoring/audit report and use **the output** as evidence for a compliance-style analysis (routine vs suspicious activity, attempted violation vs control failure).

---

## Quick Preflight Checklist (Run These First)

From repo root:

```bash
cd ~/IT4065C-Labs
```

Confirm files exist:

```bash
ls -l labs/module_6/lab6
```

You should see:

* `run_lab6_audit_report.sh`
* `00_prepare_audit_evidence.sql`
* `01_generate_audit_report.sql`

Confirm Postgres is reachable:

```bash
psql -h localhost -U postgres -d it4065c -c "SELECT now();"
```

If that works, the lab should run.

---

## Common Errors and Fixes

### 1) `Permission denied` when running the script

**Symptom**

* `bash: .../run_lab6_audit_report.sh: Permission denied`

**Cause**

* Script is not executable (common after unzip or git permissions issues).

**Fix**

```bash
chmod +x labs/module_6/lab6/run_lab6_audit_report.sh
bash labs/module_6/lab6/run_lab6_audit_report.sh
```

---

### 2) `psql: error: connection to server at "localhost"... failed`

**Symptoms**

* `Connection refused`
* `No such file or directory`
* `could not connect to server`

**Most common causes**

* PostgreSQL service is not running
* You are using an environment where Postgres is not installed locally
* Postgres is running, but not on `localhost` / not on default port (rare in this course)

**Fix A: Start PostgreSQL (Ubuntu service)**

```bash
sudo service postgresql status
sudo service postgresql start
```

Re-test:

```bash
psql -h localhost -U postgres -d it4065c -c "SELECT 1;"
```

**Fix B: If you’re in a Docker-only setup**
Lab 6 script assumes Postgres is on `localhost`. If your Postgres is in Docker with a different host/port, this lab will fail until the environment matches the course standard. Use the course-provided Postgres service (recommended) or adjust your environment to expose it on localhost.

---

### 3) `FATAL: password authentication failed for user "postgres"`

**Symptoms**

* Password prompt appears; password is rejected
* Or you see authentication failure immediately

**Cause**

* The `postgres` user password differs from the expected one for your environment
* You are typing the wrong password
* You changed the password earlier (common when troubleshooting prior labs)
* `.pgpass` or environment variables are not set, causing confusion

**Fix A: Confirm you can log in manually**

```bash
psql -h localhost -U postgres -d it4065c
```

If you cannot log in, Lab 6 cannot run. Fix Postgres auth first.

**Fix B: If you know the password, set it once**

```bash
export PGPASSWORD='YOUR_POSTGRES_PASSWORD'
bash labs/module_6/lab6/run_lab6_audit_report.sh
```

**Fix C: If you do not know/reset password (Ubuntu local Postgres)**
In many Ubuntu setups, local `postgres` can connect via peer auth:

```bash
sudo -u postgres psql -d it4065c -c "SELECT now();"
```

If that works, your `psql -U postgres -h localhost` path is using password auth. You may need to:

* set a password for postgres, or
* adjust pg_hba.conf auth method (only if your lab policy allows it)

If your course environment expects a standard auth setup, ask the TA before changing `pg_hba.conf`.

---

### 4) `psql: error: could not open file ".../00_prepare_audit_evidence.sql": No such file or directory`

**Cause**

* Files are not in the correct path
* Files were renamed
* You ran the script outside the repository root and relative paths broke (rare here, but possible if your script assumes root)

**Fix**
From repo root:

```bash
cd ~/IT4065C-Labs
ls -l labs/module_6/lab6/00_prepare_audit_evidence.sql
ls -l labs/module_6/lab6/01_generate_audit_report.sql
```

If missing, re-copy the lab files into:

```bash
~/IT4065C-Labs/labs/module_6/lab6/
```

---

### 5) `ERROR: database "it4065c" does not exist`

**Cause**

* Database was not created (Lab 1/previous setup not completed), or it was created under a different name.

**Fix**
Check databases:

```bash
psql -h localhost -U postgres -c "\l"
```

If missing, create it (only if permitted in your course environment):

```bash
createdb -h localhost -U postgres it4065c
```

Then rerun Lab 6.

---

### 6) `ERROR: relation ... does not exist` (missing tables/views)

**Symptoms**

* `ERROR: relation ... does not exist`
* `ERROR: schema ... does not exist`

**Cause**

* Prerequisite objects weren’t created (Labs 3–5 not fully executed), or
* You are running in the wrong database, or
* `00_prepare_audit_evidence.sql` expects certain base schemas/tables to already exist

**Fix**
Confirm you are in the right DB:

```bash
psql -h localhost -U postgres -d it4065c -c "SELECT current_database();"
```

List schemas:

```bash
psql -h localhost -U postgres -d it4065c -c "\dn"
```

If expected schemas (e.g., your `student_*` schema) are missing, revisit earlier labs and ensure the pipeline and security artifacts were created successfully.

---

### 7) `ERROR: permission denied for schema ...` or `permission denied for relation ...`

**Cause**

* This typically happens when the script is not truly running as `postgres`, or
* Your database privileges were altered, or
* Objects referenced in SQL are owned by another role and permissions were removed

**Fix**
Confirm who is executing:

```bash
psql -h localhost -U postgres -d it4065c -c "SELECT current_user;"
```

If it is not `postgres`, you are not using the intended account.

If it is `postgres` and you still see permission denied, the database security configuration may have been changed. Contact the TA with the exact error line.

---

### 8) Script runs, but you “lose” the report output (can’t find Section 7/8)

**Cause**

* Terminal scrollback is limited
* Output is long and scrolls away

**Fix: Capture output to a file**
From repo root:

```bash
bash labs/module_6/lab6/run_lab6_audit_report.sh | tee lab6_audit_output.txt
```

Search within:

```bash
grep -n "Section 7" lab6_audit_output.txt
grep -n "Candidate" lab6_audit_output.txt
grep -n "Incident" lab6_audit_output.txt
```

---

## Anticipated Student Pitfalls (Common Mistakes)

### A) Running the script from the wrong folder

While the script uses relative paths, best practice is:

```bash
cd ~/IT4065C-Labs
bash labs/module_6/lab6/run_lab6_audit_report.sh
```

---

### B) Confusing **Attempted Violation** vs **Control Failure**

Your audit memo should classify incidents correctly:

* **Attempted Violation:** suspicious action occurred but access was blocked and logged correctly
* **Control Failure:** suspicious action succeeded when it should not have, or logging is missing/incomplete

A strong memo explicitly uses this language.

---

### C) Treating logs as “facts” without interpretation

Lab 6 is not “copy the log.”

Strong analysis connects:

* role used
* action attempted
* object targeted
* time-of-day
* repeated pattern
* success/denial outcome

…into a governance conclusion.

---

### D) Overlooking context fields (IP, app_name, time patterns)

These fields exist for accountability:

* repeated after-hours access
* unusual application names
* IP inconsistencies
* rapid role switching

Use them as reasoning evidence.

---

### E) Writing generic risk statements

Weak: “This is suspicious.”
Strong: “Repeated denied access attempts against restricted customer profile views suggests privilege probing; controls appear effective, indicating attempted violation rather than control failure.”

---

## When to Escalate to TA/Instructor

Escalate with screenshots + terminal output if:

* Postgres is running and `psql -h localhost -U postgres -d it4065c -c "SELECT 1"` works, **but** the script still fails
* The SQL files exist but reference objects that do not exist (possible environment mismatch)
* Multiple students see the same error (possible packaging or SQL dependency issue)

When asking for help, include:

```bash
pwd
ls -l labs/module_6/lab6
psql -h localhost -U postgres -d it4065c -c "SELECT current_user, current_database();"
```

---

## Fast Reset Workflow (Recommended)

```bash
cd ~/IT4065C-Labs
export PGPASSWORD='YOUR_POSTGRES_PASSWORD'
bash labs/module_6/lab6/run_lab6_audit_report.sh | tee lab6_audit_output.txt
grep -n "Section 7" lab6_audit_output.txt
```

---

## Notes for TAs (Quick Diagnosis)

If a student reports failure, determine which category it is:

1. **File/path issue** (missing SQL/script)
2. **Service issue** (Postgres not running / wrong environment)
3. **Auth issue** (postgres password / login method mismatch)
4. **Dependency issue** (missing schemas/tables from prior labs)
5. **Output capture issue** (report ran but student can’t retrieve evidence)

Most Lab 6 problems fall into one of these five buckets.

```
```
