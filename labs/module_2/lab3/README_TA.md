# Module 2 – Lab 3  
## TA / Instructor Guide  
**Data Modeling with dbt (Staging, Core Entities, OLTP vs OLAP)**

⚠️ **TA-ONLY DOCUMENT — NOT STUDENT-FACING**

---

## Purpose of This Document

This guide supports TAs and instructors in:

- Verifying Lab 3 submissions efficiently
- Understanding expected outputs and behaviors
- Diagnosing common failures without guesswork
- Grading consistently across sections
- Distinguishing execution issues from reasoning gaps

Lab 3 is intentionally designed so students **do not write or edit code**.
Assessment focuses on:
- Correct execution
- Verification discipline
- Conceptual reasoning

---

## High-Level Lab Intent (For TA Context)

Lab 3 teaches students how to:
- Operate an existing dbt project
- Understand modeling layers (staging → core → marts)
- Validate data pipelines professionally
- Reason about OLTP vs OLAP use cases
- Interpret data quality tests

It is **not** a SQL-writing lab.

---

## Files That Must Exist (Pre-Scaffolded)

Before grading any submission, confirm the repo contains:

### Lab Files
- `labs/module_2/lab3/README.md`
- `labs/module_2/lab3/lab3_quick_checks.sql`
- `labs/module_2/lab3/lab3_turnin_template.md`
- `labs/module_2/lab3/lab3_run_all.sh` (optional but recommended)
- `labs/module_2/lab2_seed.sql`

### dbt Models
- `models/lab3/staging/*.sql`
- `models/lab3/core/*.sql`
- `models/lab3/marts/*.sql`
- `models/lab3/_lab3_models.yml`

If any of these are missing **in the repo**, that is an instructional issue, not a student error.

---

## Expected Command Outcomes (What “Correct” Looks Like)

### 1. `dbt debug`

✅ Expected:
- All checks pass
- Database connection successful

❌ Common issues:
- Virtual environment not activated
- Incorrect Postgres credentials
- dbt not installed in venv

---

### 2. `dbt run --select path:models/lab3`

✅ Expected:
- All staging, core, and marts models build
- Model count roughly matches repo contents
- No compilation errors

❌ Common issues:
- Raw tables missing (Lab 2 seed not run)
- Wrong database/schema
- Student running `dbt run` without `--select`

---

### 3. `dbt test --select path:models/lab3`

✅ Expected:
- All tests pass

⚠️ Acceptable partial failures (contextual):
- Relationship test failures caused by dirty seed data  
  → Student should explain implication correctly in reflection

❌ Red flags:
- Student removed tests
- Student edited `_lab3_models.yml`
- Student claims “tests don’t matter”

---

### 4. SQL Validation Script

File:
```bash
labs/module_2/lab3/lab3_quick_checks.sql
````

✅ Expected:

* Non-zero row counts for:

  * `dim_customers`
  * `dim_products`
  * `fct_orders`
  * `fct_order_items`
* `olap_sales_by_day` returns aggregated rows
* `oltp_order_detail` returns detailed rows (LIMIT 10)

❌ Common issues:

* Student points psql at wrong database
* Student runs script before dbt
* Empty outputs due to missing seed

---

## Understanding the Models (TA Reference)

### Staging Models (`stg_*`)

* Thin wrappers over raw tables
* No business logic
* Standardized column selection
* Used to isolate raw schema changes

### Core Models

* `dim_*`: descriptive entities
* `fct_*`: transactional events
* Clear grain definition
* Enforced with dbt tests

### Mart Models

* `oltp_order_detail`: detailed, row-level, investigative
* `olap_sales_by_day`: aggregated, analytics-friendly

Students should articulate this distinction in reflection answers.

---

## Common Student Issues & How to Respond

### Issue: “dbt test failed — what should I do?”

✔ Correct guidance:

* Do not remove the test
* Identify what the failure indicates
* Explain impact in reflection

---

### Issue: “My counts don’t match another student’s”

✔ Correct response:

* Counts may vary slightly depending on seed state
* Focus is on **existence, structure, and reasoning**, not exact numbers

---

### Issue: Student modified dbt models

⚠️ Handling:

* If modification was unnecessary and broke intent → deduct
* If modification is clearly advanced, correct, and explained → optional bonus (if allowed)

---

## Grading Guidance (Conceptual Emphasis)

Recommended weighting (adjust as needed):

| Category                         | Weight |
| -------------------------------- | ------ |
| Execution evidence (screenshots) | 40%    |
| Validation discipline            | 20%    |
| Reflection quality               | 40%    |

### Reflection Evaluation Criteria

Strong answers:

* Correctly use terms like *grain*, *dimension*, *fact*, *aggregation*
* Explain *why*, not just *what*
* Tie models to real-world use cases
* Reference governance and integrity meaningfully

Weak answers:

* Purely descriptive (“this table joins data”)
* No mention of use case or risk
* Confuses OLTP and OLAP

---

## TA Fast-Check Workflow (5 Minutes per Submission)

1. Skim screenshots:

   * dbt debug OK?
   * dbt run OK?
   * dbt test OK?
2. Spot-check validation output
3. Read reflection Q2 (OLTP vs OLAP)
4. Read reflection Q3 (dbt test meaning)

If those four are solid, the submission is likely strong.

---

## Final Notes for TAs

* This lab is intentionally **low-syntax, high-reasoning**
* Do not penalize students for:

  * Minor formatting issues
  * Slight output differences
* Do penalize for:

  * Skipping steps
  * Editing protected files
  * Superficial reflections

This lab models **professional data operations**, not coding drills.

---

If you encounter repeated issues across many students, flag them to the instructor — it likely indicates an environment or instruction-level fix is needed.

```



