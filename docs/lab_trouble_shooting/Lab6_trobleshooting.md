# Lab 6 Troubleshooting Guide
## Monitoring Evidence & Compliance Reasoning (IT4065C)

This guide covers common errors students may encounter when running **Lab 6** and how to fix them. It also includes anticipated pitfalls that frequently cause confusion.

> **Lab 6 goal reminder:** You are generating and interpreting a **32-hour audit window** of access logs (Section 0–8 output), then writing an audit memo supported by **Section 7 (Candidate Incidents)**.

---

## Quick Preflight Checklist (Do This First)

Run these from your Ubuntu terminal:

```bash
cd ~/IT4065C-Labs
ls -R labs/module_6/lab6
````

You should see:

* `run_lab6_audit_report.sh`
* `00_prepare_audit_evidence.sql`
* `01_generate_audit_report.sql`

Also confirm your PostgreSQL client is available:

```bash
psql --version
```

---

## Most Common Problems and Fixes

### 1) “No such file or directory” when trying to `cd` into lab6

**Symptoms**

* `cd: .../labs/module_6/lab6: No such file or directory`

**Cause**

* You didn’t create the directory, or you’re not inside `~/IT4065C-Labs`.

**Fix**

```bash
cd ~
cd IT4065C-Labs
mkdir -p labs/module_6/lab6
ls -R labs/module_6
```

---

### 2) Script runs but says it can’t find SQL files

**Symptoms**

* `psql: error: could not open file "00_prepare_audit_evidence.sql": No such file or directory`
* Or the script prints file-not-found messages.

**Cause**

* The three Lab 6 files were not copied into the correct folder, or were renamed.

**Fix**

```bash
cd ~/IT4065C-Labs/labs/module_6/lab6
ls -l
```

Make sure the filenames match **exactly**:

* `run_lab6_audit_report.sh`
* `00_prepare_audit_evidence.sql`
* `01_generate_audit_report.sql`

If needed, re-copy from the unzipped folder (wherever you extracted it).

---

### 3) “Permission denied” when running the script

**Symptoms**

* `bash: .../run_lab6_audit_report.sh: Permission denied`

**Cause**

* Script doesn’t have execute permission (common after zip extraction).

**Fix**

```bash
chmod +x labs/module_6/lab6/run_lab6_audit_report.sh
bash labs/module_6/lab6/run_lab6_audit_report.sh
```

---

### 4) Password prompts keep appearing (or password auth fails)

**Symptoms**

* You are repeatedly asked for a password.
* `psql: FATAL: password authentication failed for user ...`

**Common causes**

* `PGPASSWORD` not set in the same terminal session.
* Password contains special characters and was not quoted correctly.
* Wrong database user/host/DB name in the script.

**Fix**
Set the password exactly as the lab instructs, in the SAME terminal:

```bash
export PGPASSWORD='Pa$$w0rd123!'
```

Then rerun:

```bash
cd ~/IT4065C-Labs
bash labs/module_6/lab6/run_lab6_audit_report.sh
```

If you still see auth failures, test direct login (adjust username/dbname to your course setup if needed):

```bash
psql -h localhost -U airflow -d airflow_db -c "SELECT now();"
```

If that fails, the problem is not Lab 6—it’s your Postgres connectivity or credentials.

---

### 5) “Could not connect to server” (PostgreSQL not reachable)

**Symptoms**

* `psql: error: connection to server at "localhost" (...) failed: Connection refused`
* or “No such file or directory” for the socket.

**Cause**

* PostgreSQL service isn’t running (common after reboot).
* You are in an environment where Postgres runs inside Docker and the script expects localhost.

**Fix A: If Postgres is installed on Ubuntu**

```bash
sudo service postgresql status
sudo service postgresql start
```

**Fix B: If your course uses Docker services**
Check containers:

```bash
docker ps
```

Start your stack if required by your course environment (example):

```bash
docker compose up -d
```

Then test:

```bash
psql -h localhost -U airflow -d airflow_db -c "SELECT 1;"
```

---

### 6) “relation does not exist” / missing tables or schemas

**Symptoms**

* `ERROR: relation ... does not exist`
* `ERROR: schema ... does not exist`
* Audit report sections are empty or fail early.

**Cause**

* Prerequisite lab objects weren’t created (Labs 3–5 feed into Lab 6 assumptions).
* You ran Lab 6 before your pipeline/security work existed in the database.

**Fix**
Verify that your course database objects exist (examples — adapt schema names to your account):

```sql
-- inside psql
\dn
\dt
```

If key schemas/tables are missing, return to the prerequisite lab and re-run its scripts.

---

### 7) “role does not exist” (analyst_02, steward_01, etc.)

**Symptoms**

* `ERROR: role "analyst_02" does not exist`
* `ERROR: role "steward_01" does not exist`

**Cause**

* Lab 5 RBAC roles/users were not created, or were created under different names.
* You are running Lab 6 in a fresh environment without the Lab 5 security setup.

**Fix**
Confirm roles:

```sql
-- in psql
\du
```

If roles are missing, re-run Lab 5 role/user creation scripts, or confirm the expected role names for your section.

---

### 8) “permission denied for schema/table” during audit generation

**Symptoms**

* `ERROR: permission denied for schema ...`
* `ERROR: permission denied for relation ...`

**Cause**

* The script is executing as a user who lacks required privileges to read logs/tables used by the audit.
* RBAC grants are incomplete or were applied to different objects.

**Fix**
Run the script using the intended privileged account for this lab (the one used in the script).
If you’re unsure, test as the user configured in your environment:

```bash
psql -h localhost -U airflow -d airflow_db -c "SELECT current_user;"
```

Then validate privileges (examples):

```sql
-- in psql
\dp
```

If permissions are missing, revisit Lab 5 and confirm grants were applied to the correct schemas/views.

---

### 9) Script runs, but you “don’t see Section 7 / Section 8”

**Symptoms**

* You only see part of the output.
* You can’t find the Candidate Incidents.

**Cause**

* Terminal buffer/scrollback is limited, or output is long.

**Fix A: Increase scrollback**
In your terminal settings, increase scrollback history.

**Fix B: Capture output to a file**

```bash
cd ~/IT4065C-Labs
bash labs/module_6/lab6/run_lab6_audit_report.sh | tee lab6_audit_output.txt
```

Then search:

```bash
grep -n "Section 7" -n lab6_audit_output.txt
grep -n "Candidate" -n lab6_audit_output.txt
```

---

### 10) ZIP extraction issues (files not appearing)

**Symptoms**

* You downloaded `Lab6_Source.zip` but don’t see files after unzip.

**Cause**

* Unzipped into a different directory than expected.
* Using GUI extractor that nested directories unexpectedly.

**Fix**
Locate the zip and unzip explicitly:

```bash
cd ~/Downloads
ls
unzip -l Lab6_Source.zip
unzip Lab6_Source.zip -d ~/lab6_tmp
ls -R ~/lab6_tmp
```

Then copy the required files into:

```bash
cp ~/lab6_tmp/* ~/IT4065C-Labs/labs/module_6/lab6/
```

---

## Anticipated Student Pitfalls (Not “Errors,” But Common Mistakes)

### A) Running the script from the wrong directory

The lab expects execution from repo root:

```bash
cd ~/IT4065C-Labs
bash labs/module_6/lab6/run_lab6_audit_report.sh
```

Running it from inside `lab6/` may break relative paths depending on how the script is written.

---

### B) Forgetting to include Section 7 screenshot in the submission

Your submission must include proof you ran the script:

* Screenshot of **Section 7: Candidate Incidents**
* Your written audit memo (Steps 3–4)

**Tip:** If output scrolls away, use the `tee` capture method above.

---

### C) Confusing “Attempted Violation” vs “Control Failure”

* **Attempted Violation:** suspicious behavior occurred, but the system denied access correctly.
* **Control Failure:** access succeeded when it should have been blocked, or logging is incomplete.

Your memo should explicitly label which one applies to each incident.

---

### D) Writing descriptions instead of governance reasoning

Weak: “I saw denied attempts.”
Strong: “Repeated denied attempts + role switching indicates intent to escalate privileges; system enforcement appears effective, suggesting attempted violation rather than control failure.”

---

### E) Ignoring `client_ip` and `app_name`

These fields are part of **accountability**. Use them:

* Shared credentials become traceable
* Unexpected app_name can indicate automation or misuse
* IP patterns can suggest offsite access

---

### F) Overusing GenAI without evidence checks

If you consult GenAI:

* You must still confirm the evidence is actually present in your output
* Write in your own words
* Include a brief note/screenshot of the prompt (per lab instructions)

---

## When to Escalate to Instructor/TA

Escalate (with screenshots) if:

* You have verified file placement and permissions, but the script still fails
* You can connect to Postgres manually, but the script cannot
* Section 7 shows empty incidents unexpectedly across multiple students (possible upstream dataset or script issue)

When asking for help, include:

* The exact error message
* The command you ran
* Output of:

```bash
pwd
ls -R labs/module_6/lab6
```

---

## Quick “Reset” Strategy (If You’re Stuck)

1. Confirm repo root:

```bash
cd ~/IT4065C-Labs
```

2. Confirm lab6 files exist:

```bash
ls -l labs/module_6/lab6
```

3. Set password:

```bash
export PGPASSWORD='Pa$$w0rd123!'
```

4. Run and capture output:

```bash
bash labs/module_6/lab6/run_lab6_audit_report.sh | tee lab6_audit_output.txt
```

5. Search for Section 7:

```bash
grep -n "Section 7" lab6_audit_output.txt
```

---
