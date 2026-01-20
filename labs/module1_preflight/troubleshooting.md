# **Troubleshooting Guide – IT4065C Labs**

This document helps you resolve common issues encountered during labs in **IT4065C: Data Technologies Administration**, especially **Lab 1 (Preflight & Environment Readiness)**.

Before contacting the instructor, read this guide carefully and try the suggested fixes.

---

## **Before You Ask for Help (Required)**

When asking for help, always include:

1. The **exact command** you ran
2. The **full error message** (copy/paste or screenshot)
3. Your **operating system** (Ubuntu version)
4. The **step number** where the issue occurred

Incomplete help requests may be returned without response.

---

## **Section 1: Ubuntu & System Issues**

### ❌ Issue: Ubuntu VM does not load or freezes

**Cause:** VM startup or network issue.

**What to do:**

* Refresh the browser
* Log out and log back into the VM portal
* Wait 1–2 minutes after login before opening the terminal

If the VM still fails to load, contact **IT support**. This is not a course issue.

---

### ❌ Issue: `sudo: command not found`

**Cause:** You are not in a standard Ubuntu shell (very rare).

**Fix:**
Log out and log back into the VM. If it persists, contact IT.

---

## **Section 2: Package Installation Issues**

### ❌ Issue: `apt update` or `apt install` fails

**Cause:** Temporary package repository or network issue.

**Fix:**

```bash
sudo apt clean
sudo apt update
```

Then retry the install command.

---

### ❌ Issue: `pip3` command not found

**Cause:** Python pip is not installed.

**Fix:**

```bash
sudo apt install -y python3-pip
```

Verify:

```bash
pip3 --version
```

---

## **Section 3: PostgreSQL Issues**

### ❌ Issue: `psql: command not found`

**Cause:** PostgreSQL client not installed.

**Fix:**

```bash
sudo apt install -y postgresql postgresql-contrib
```

Verify:

```bash
psql --version
```

---

### ❌ Issue: PostgreSQL service is not running

**Symptom:**

```bash
sudo systemctl status postgresql
```

Shows **inactive** or **failed**.

**Fix:**

```bash
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

Recheck status.

---

### ❌ Issue: Permission denied when creating database or schema

**Cause:** Commands were not run as the postgres user.

**Fix:**
Always create databases and schemas using:

```bash
sudo -u postgres createdb it4065c
sudo -u postgres psql it4065c
```

Do **not** use your regular Ubuntu user for admin tasks.

---

## **Section 4: dbt Installation Issues**

### ❌ Issue: `dbt: command not found`

**Cause:** dbt is not installed or PATH is not refreshed.

**Fix:**

```bash
pip3 install dbt-postgres
```

Then restart the terminal and verify:

```bash
dbt --version
```

---

### ❌ Issue: dbt installs but `dbt --version` fails

**Cause:** Python environment path issue.

**Fix:**
Try:

```bash
python3 -m pip install dbt-postgres
python3 -m dbt --version
```

If this works, continue using `python3 -m dbt` instead of `dbt`.

---

## **Section 5: dbt `profiles.yml` Issues (MOST COMMON)**

### ❌ Issue: `Could not find profile named it4065c_platform`

**Cause:** Profile name in `profiles.yml` does not match `dbt_project.yml`.

**Fix:**

* Open `~/.dbt/profiles.yml`
* Ensure the top-level key is:

```yaml
it4065c_platform:
```

---

### ❌ Issue: YAML parsing error

**Cause:** Indentation or formatting error.

**Fix:**

* Use spaces, not tabs
* Ensure consistent indentation
* Compare with `profiles_template.yml`

---

### ❌ Issue: Authentication failed for user "postgres"

**Cause:** Password or authentication mismatch.

**Fix:**

* Leave `password:` blank if peer authentication is enabled
* Ensure you are using:

```yaml
host: localhost
user: postgres
```

If unsure, ask the instructor before modifying authentication settings.

---

### ❌ Issue: `schema does not exist`

**Cause:** Schema name in `profiles.yml` was not created.

**Fix:**
Re-enter PostgreSQL:

```bash
sudo -u postgres psql it4065c
```

Create the schema:

```sql
CREATE SCHEMA student_kofi;
\q
```

Ensure the schema name exactly matches `profiles.yml`.

---

## **Section 6: dbt Debug Failures**

### ❌ Issue: `Connection test: FAILED`

**Checklist:**

* PostgreSQL service is running
* Database name is correct (`it4065c`)
* Schema exists
* Profile name matches project name

Re-run:

```bash
dbt debug
```

---

### ❌ Issue: dbt connects but later commands fail

**Cause:** dbt is working correctly, but SQL or config is invalid.

**Fix:**

* Re-read the error message carefully
* dbt error messages are descriptive
* Do not guess—trace the exact line mentioned

---

## **Section 7: SQL Query Issues**

### ❌ Issue: `permission denied for schema raw`

**Cause:** Expected behavior.

**Explanation:**
The `raw` schema is read-only or restricted to simulate governance controls.

**What to do:**
Run queries only in your assigned schema (`student_kofi`).

---

### ❌ Issue: `relation does not exist`

**Cause:** Table name is misspelled or not in your schema.

**Fix:**
Check tables:

```sql
\dt student_kofi.*
```

---

## **Section 8: Git & Repository Issues**

### ❌ Issue: `git clone` fails

**Fix:**

* Verify the URL is correct
* Check internet access
* Retry after a few minutes

---

### ❌ Issue: Accidentally edited files in the repo

**Fix:**

```bash
git status
git restore <filename>
```

Do **not** commit `profiles.yml` or credentials.

---

## **Section 9: When to Contact the Instructor**

Contact the instructor **only after**:

* You have followed this guide
* You can describe what failed
* You can show the error message

Include:

* Screenshot or copy/paste error
* Step number
* Ubuntu version

---

## **Final Reminder**

Most issues in Week 1 are:

* Configuration-related
* Fixable within minutes
* Part of learning system administration

Stay calm, read errors carefully, and proceed step by step.

---

