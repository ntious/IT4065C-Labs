# Data Technologies Administration Platform Preflight  
## PostgreSQL + dbt Connection & Environment Verification

⚠️ **This document is mandatory for Lab 1.**  
You may NOT proceed to Lab 2 until all verification gates below pass.

This guide ensures your analytics platform is correctly configured before you begin governed data modeling.

---

# 🎯 Purpose of This Document

In IT4065C, you are not simply running SQL.

You are operating inside a controlled analytics platform that includes:

- PostgreSQL (analytics warehouse)
- dbt (transformation engine)
- Schema isolation (governance boundary)
- Version-controlled environment

Before building models, you must prove that your platform is stable.

This is called **Preflight Validation**.

---

# 🧱 Platform Architecture Overview

| Component | Role |
|------------|--------|
| PostgreSQL | Analytics warehouse |
| dbt | Transformation framework |
| Git | Version control |
| Virtual Environment (`dbt-venv`) | Controlled dependency isolation |
| Schema (`student_<yourname>`) | Governance boundary |

You are responsible only for your assigned schema.

---

# 🚫 Important Rules

- Do NOT install dbt globally.
- Do NOT use Docker.
- Do NOT modify system schemas.
- Always activate `dbt-venv` before running dbt.
- Do NOT upgrade dbt versions manually.

This course uses controlled versions to simulate enterprise deployment discipline.

---

# 🧭 Step 1 — Clone the Course Repository

```bash
git clone <COURSE_REPO_URL>
cd IT4065C-Labs
````

---

# 🧭 Step 2 — Activate the Controlled Environment

Inside the repository root:

```bash
source dbt-venv/bin/activate
```

If successful, your terminal will show:

```
(dbt-venv)
```

---

# 🔎 Verification Gate 1 — dbt Version Check

Run:

```bash
dbt --version
```

You should see compatible versions of:

* dbt-core
* dbt-postgres

If you see plugin incompatibility errors:

STOP.
Go to `docs/lab_troubleshooting/Lab1_troubleshooting.md`

Do NOT run `pip install` manually.

---

# 🧭 Step 3 — Configure profiles.yml

Location:

```
~/.dbt/profiles.yml
```

Example configuration:

```yaml
it4065c_platform:
  target: dev
  outputs:
    dev:
      type: postgres
      host: <HOST>
      user: <USERNAME>
      password: <PASSWORD>
      port: 5432
      dbname: <DATABASE>
      schema: student_<yourname>
      threads: 1
```

Replace all placeholders with instructor-provided credentials.

Your schema MUST follow this format:

```
student_<yourname>
```

Example:

```
student_kofi
```

---

# 🔎 Verification Gate 2 — Connection Test

Navigate into the dbt project directory:

```bash
cd dbt/it4065c_platform
```

Run:

```bash
dbt debug
```

Expected output:

```
All checks passed!
```

If not:

* Verify schema name
* Verify credentials
* Verify environment activation
* Use troubleshooting guide

---

# 🔎 Verification Gate 3 — Controlled Execution Test

Run:

```bash
dbt run --select +stg_customers
```

You should see:

```
Completed successfully
```

This confirms:

* Warehouse connectivity
* Schema write permissions
* Model compilation
* Adapter compatibility

---

# 🧠 Why This Matters

In real enterprises:

* Engineers do not “just start building.”
* Environments must be reproducible.
* Access boundaries must be enforced.
* Version conflicts must be controlled.

This preflight ensures you are operating inside a governed analytics system.

---

# 🛑 Common Failure Causes

| Issue                   | Cause              |
| ----------------------- | ------------------ |
| Plugin not compatible   | Global dbt install |
| Relation does not exist | Wrong schema       |
| Permission denied       | Wrong user         |
| dbt command not found   | venv not activated |

---

# 📸 Required Lab 1 Evidence

You must capture screenshots of:

1. `(dbt-venv)` activated
2. `dbt --version`
3. Successful `dbt debug`

These are required for Lab 1 submission.

---

# 🏁 Completion Criteria

You are cleared to begin Lab 2 only if:

* All three verification gates pass
* Screenshots are captured
* No version warnings exist

---

# 🔐 Governance Reminder

Your schema is your sandbox.

Do not:

* Query other students’ schemas
* Modify system tables
* Change core project configurations

Schema isolation is part of your grade.

---

# 📌 Final Note

If your environment breaks:

Go to:

```
docs/lab_troubleshooting/
```

Do not search random fixes online.

Controlled systems require controlled fixes.

---

**Course:** Data Technologies Administration
**Phase:** Platform Readiness
**Level:** Mandatory Preflight Gate

```
bypass it.
```
