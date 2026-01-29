# M2 Lab 2 Troubleshooting Guide (Raw Data Exploration & Data Classification)

**Lab:** Module 2 – Lab 2 (Postgres + SQL only)  
**Audience:** IT4065C students working in UC Sandbox Ubuntu VM or personal Ubuntu/WSL  
**Goal:** Quickly diagnose the most common failures and recover without “starting over.”

---

## 0) Before You Troubleshoot: Confirm Where You Are

### Symptom
Commands like `psql -f labs/module_2/lab2_seed.sql` fail with “No such file or directory”.

### Likely cause
You’re not inside the repo folder.

### Fix
```bash
cd ~/IT4065C-Labs
ls
# You should see: labs/  (and other repo files)
ls labs/module_2
# You should see: lab2_seed.sql, lab2_governance_register.sql, etc.
```

---

## 1) Can't connect to Postgres

### 1.1 `psql: could not connect to server: Connection refused`
**Command that triggers it**
```bash
psql -h localhost -U postgres -d it4065c
```

**Likely causes**
- Postgres service isn’t running.
- You’re in WSL and Postgres isn’t installed/running there (common if the lab was set up only in the UC VM).
- Wrong host/port (rare in this lab).

**Fix (Ubuntu VM / Linux with systemd)**
```bash
sudo systemctl status postgresql
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

**Fix (WSL common case: `systemctl` not available)**
- If `systemctl` fails with: `System has not been booted with systemd...`
  - Use the UC Sandbox VM if that’s the course standard.
  - Or install/start Postgres via the WSL-supported method:
    ```bash
    sudo service postgresql status
    sudo service postgresql start
    ```
  - If Postgres is not installed:
    ```bash
    sudo apt update
    sudo apt install -y postgresql postgresql-contrib
    ```

---

### 1.2 `psql: FATAL: password authentication failed for user "postgres"`
**Likely causes**
- Password typo (note the special characters).
- Your environment’s postgres password is different than the lab handout.

**Fix**
1. Re-type carefully (watch for `!` and `$`).
2. If you *know* Postgres is yours (personal install) and you need to reset:
   ```bash
   sudo -u postgres psql
   ALTER USER postgres WITH PASSWORD 'Pa$$w0rd123!';
   \q
   ```
3. If you are on the UC Sandbox and password doesn’t work, do **not** keep guessing—verify the course-provided password in the Lab 1 environment instructions or ask your instructor/TA.

---

### 1.3 `psql: error: connection to server at "localhost" ... failed: FATAL: database "it4065c" does not exist`
**Likely cause**
Database was never created, or you’re connected to a different Postgres instance.

**Fix**
List databases:
```bash
psql -h localhost -U postgres -d postgres -c "\l"
```
If `it4065c` is missing, seed/setup may not have been completed in Lab 1. Ask your TA/instructor or rerun the course setup (Lab 1/bootstrapping script if provided).

---

## 2) Step 2: Raw tables are missing

### Symptom
Inside `psql`:
```sql
\dt raw.*
```
returns **no relations**.

### Likely causes
- Seed file has not been executed yet.
- Seed file executed against the wrong database or wrong Postgres server.
- You’re connected to a different database than you think.

### Fix (recommended sequence)
1. Exit psql:
```sql
\q
```
2. Confirm repo path:
```bash
cd ~/IT4065C-Labs
```
3. Run seed file:
```bash
psql -h localhost -U postgres -d it4065c -f labs/module_2/lab2_seed.sql
```
4. Reconnect and verify:
```bash
psql -h localhost -U postgres -d it4065c
\dt raw.*
```

### If seed execution shows file errors
- `psql: error: labs/module_2/lab2_seed.sql: No such file or directory`
  - You are not in the repo root or your repo clone is incomplete.
  - Fix:
    ```bash
    cd ~/IT4065C-Labs
    ls labs/module_2/lab2_seed.sql
    ```

### If seed execution shows permissions errors
- `ERROR: permission denied for schema raw`
  - You’re not using the expected superuser (`postgres`).
  - Fix: connect as `postgres` per lab instructions.

---

## 3) Step 3: `\d raw.customers` or SELECT errors

### 3.1 `Did not find any relation named "raw.customers"`
**Likely causes**
- The seed did not run successfully.
- You’re in the wrong database.

**Fix**
Re-run Step 2 verification:
```sql
\dt raw.*
```
If empty, rerun seed file (Section 2).

---

### 3.2 `ERROR: permission denied for table ...`
**Likely cause**
You connected as a user without privileges.

**Fix**
Reconnect as postgres:
```bash
psql -h localhost -U postgres -d it4065c
```

---

### 3.3 Table dump is huge / terminal “freezes”
**Likely cause**
You ran `SELECT * FROM raw.customers;` without `LIMIT`.

**Fix**
- Interrupt:
  - Press `Ctrl + C`
- Then rerun safely:
```sql
SELECT * FROM raw.customers LIMIT 10;
SELECT * FROM raw.orders LIMIT 10;
```

---

## 4) Step 5: Governance register script issues

### 4.1 `ERROR: could not open file "labs/module_2/lab2_governance_register.sql": No such file or directory`
**Likely cause**
You’re not in `~/IT4065C-Labs`.

**Fix**
```bash
cd ~/IT4065C-Labs
psql -h localhost -U postgres -d it4065c -f labs/module_2/lab2_governance_register.sql
```

---

### 4.2 `ERROR: schema "student_kofi" already exists`
**Likely cause**
You already ran the register script once (this is normal).

**Fix options**
- If the script continues after that error, you may be fine.
- If it fails hard and you want a clean reset (only if instructed):
  ```bash
  psql -h localhost -U postgres -d it4065c
  DROP SCHEMA IF EXISTS student_kofi CASCADE;
  \q
  psql -h localhost -U postgres -d it4065c -f labs/module_2/lab2_governance_register.sql
  ```

---

### 4.3 `\dt student_kofi.*` shows nothing
**Likely causes**
- Register script failed.
- You verified inside the wrong database.

**Fix**
1. Ensure you ran the script successfully:
```bash
psql -h localhost -U postgres -d it4065c -f labs/module_2/lab2_governance_register.sql
```
2. Reconnect and verify:
```bash
psql -h localhost -U postgres -d it4065c
\dt student_kofi.*
```

---

## 5) Step 6: Insert template problems (most common grading deductions)

### 5.1 Nano edits not saved / file unchanged
**Symptom**
You ran the script, but verification shows 0 rows.

**Likely cause**
You exited nano without saving, or edited the wrong file.

**Fix**
1. Open and confirm your changes exist:
```bash
nano labs/module_2/lab2_insert_templates.sql
```
2. Save properly:
- `Ctrl + O` then `Enter`
- `Ctrl + X`

---

### 5.2 `ERROR: syntax error at or near ...`
**Likely causes**
- You accidentally broke the SQL structure (extra comma, missing quote, deleted parenthesis).
- You left placeholder tokens like `<<table_name>>` unchanged.

**Fix**
- Compare to the original structure (don’t alter commas/parentheses).
- Common safe checks:
  - Every text value must be in single quotes: `'raw.customers'`
  - Don’t use smart quotes (“ ”). Use `'`.
  - End INSERT with `;`

Run a quick lint by printing the file:
```bash
sed -n '1,200p' labs/module_2/lab2_insert_templates.sql
```

---

### 5.3 `ERROR: invalid input value for enum ...` (or classification rejected)
**Likely cause**
Your `classification_level` value doesn’t match what the table expects (e.g., `Sensitive` vs `SENSITIVE`, or a fixed domain list).

**Fix**
Check allowed values by describing the register table:
```bash
psql -h localhost -U postgres -d it4065c
\d student_kofi.data_classification_register
```
Then update your INSERT to match the exact allowed value spelling.

---

### 5.4 `ERROR: null value in column ... violates not-null constraint`
**Likely cause**
You left a required field blank.

**Fix**
Open the template and fill **all required placeholders**, especially:
- table name
- column name
- classification
- rationale
- owner role
- retention

---

### 5.5 `ERROR: relation "student_kofi.data_classification_register" does not exist`
**Likely cause**
You skipped Step 5 or it failed.

**Fix**
Run the register initialization:
```bash
cd ~/IT4065C-Labs
psql -h localhost -U postgres -d it4065c -f labs/module_2/lab2_governance_register.sql
```
Then rerun your insert script.

---

## 6) Step 7: Verify script output problems

### 6.1 `ERROR: could not open file "labs/module_2/lab2_verify_register.sql"`
**Likely cause**
Wrong working directory.

**Fix**
```bash
cd ~/IT4065C-Labs
psql -h localhost -U postgres -d it4065c -f labs/module_2/lab2_verify_register.sql
```

---

### 6.2 Output opens in a pager and shows `(END)`
**Symptom**
You can’t type commands; bottom shows `(END)`.

**Cause**
`psql` is using the pager (`less`).

**Fix**
Press:
- `q` to quit the pager.

**Optional (prevent pager for this session)**
```bash
export PAGER=cat
```

---

### 6.3 Verification shows 0 rows but you “ran the insert”
**Most likely causes**
- Insert file wasn’t saved.
- Insert failed with an error you missed.
- You connected to the wrong database when inserting.

**Fix checklist**
1. Re-run insert and watch for errors:
```bash
psql -h localhost -U postgres -d it4065c -f labs/module_2/lab2_insert_templates.sql
```
2. Immediately query the table:
```bash
psql -h localhost -U postgres -d it4065c -c "SELECT COUNT(*) FROM student_kofi.data_classification_register;"
```
3. Then re-run verify script.

---

## 7) Screenshot & submission pitfalls (non-technical, but common)

### 7.1 Screenshot 1 doesn’t show `\dt raw.*`
**Fix**
Inside psql:
```sql
\dt raw.*
```
Make sure the screenshot includes:
- The command
- The output showing the table list

### 7.2 Screenshot 2 doesn’t show counts/entries clearly
**Fix**
Re-run:
```bash
psql -h localhost -U postgres -d it4065c -f labs/module_2/lab2_verify_register.sql
```
Scroll so the counts/rows are visible, then screenshot.

### 7.3 Reflection is too vague (grading risk)
**Fix**
Use specific language:
- “This column directly identifies…”
- “This is operational but not identifying…”
- “I needed business context like…”

---

## 8) Quick “Nuclear Reset” (only if you’re stuck and instructed)

If your environment is messy and your TA says to reset your register:

```bash
psql -h localhost -U postgres -d it4065c
DROP SCHEMA IF EXISTS student_kofi CASCADE;
\q

cd ~/IT4065C-Labs
psql -h localhost -U postgres -d it4065c -f labs/module_2/lab2_governance_register.sql
# Re-run your insert after re-checking placeholders
psql -h localhost -U postgres -d it4065c -f labs/module_2/lab2_insert_templates.sql
psql -h localhost -U postgres -d it4065c -f labs/module_2/lab2_verify_register.sql
```

---

## 9) Fast Diagnostic Commands (Copy/Paste)

```bash
# Confirm repo paths
cd ~/IT4065C-Labs && ls labs/module_2

# Confirm Postgres is reachable
psql -h localhost -U postgres -d it4065c -c "SELECT NOW();"

# Confirm raw tables exist
psql -h localhost -U postgres -d it4065c -c "\dt raw.*"

# Confirm your register exists
psql -h localhost -U postgres -d it4065c -c "\dt student_kofi.*"

# Confirm you have at least one classification row
psql -h localhost -U postgres -d it4065c -c "SELECT COUNT(*) FROM student_kofi.data_classification_register;"
```

---

## When to Stop and Ask for Help

Escalate to your TA/instructor if:
- You can’t start Postgres (service won’t run).
- The `it4065c` database is missing and you don’t have a course setup script.
- Seed/register scripts error repeatedly even after confirming paths and user (`postgres`).
