# Module 2 – Lab 3  
## Data Modeling with dbt (Staging, Core Entities, and OLTP vs OLAP)

**Course:** IT4065C – Data Technologies Administration  
**Module:** Module 2 – Data Modeling for Operational and Analytical Systems  
**Primary SLO:** SLO 4  
**Recommended Mode:** 🧪 Hands-On (Required)  
**Estimated Time:** 60–90 minutes  
**Risk Level:** Moderate  
**Environment Stress:** Low (dbt + PostgreSQL only)

---

## Important Note (Read First)

> ✅ **All scripts and files required for this lab are already included in the repository.**  
>  
> ❌ You are **not required** to write, edit, or create any SQL or dbt files.  
>  
> Your responsibility in this lab is to:
> - Verify that required files exist
> - Run the provided commands
> - Validate outputs
> - Demonstrate critical thinking and reasoning about data models

You may explore or extend the scripts **only if you choose to advance beyond the requirements**, but this is **not required** for successful completion.

---

## Why This Lab Matters

In earlier labs, you focused on:
- Environment readiness
- Exploring raw data
- Thinking about data classification and governance

In this lab, you move into **data modeling**, which is where structure, integrity, and usability come together.

You will see how:
- Raw data becomes standardized
- Core business entities are defined
- Different model designs support different workloads (OLTP vs OLAP)
- Data quality rules are enforced without changing the database schema

This mirrors how modern data teams operate in real organizations.

---

## Learning Outcomes

By completing this lab, you will be able to:

1. Explain the purpose of **staging models** in a data pipeline
2. Identify **core entity models** and their role as trusted data sources
3. Differentiate between **OLTP-style** and **OLAP-style** models
4. Interpret **dbt tests** for data quality and referential integrity
5. Reason about modeling decisions using governance and lifecycle concepts

---

## Part 1 — Required Files Checklist (No Editing)

Before running any commands, confirm that the following files exist in your cloned repository.

> 📌 If any file is missing, **stop and notify the instructor or TA**.

---

### 1️⃣ Lab Instruction & Validation Files

| File | Purpose |
|----|----|
| `labs/module_2/lab3/README.md` | Lab instructions (this file) |
| `labs/module_2/lab3/lab3_quick_checks.sql` | Prewritten SQL validation queries |
| `labs/module_2/lab3/lab3_turnin_template.md` | Submission and reflection template |

---

### 2️⃣ Raw Data Dependency

| File | Purpose |
|----|----|
| `labs/module_2/lab2_seed.sql` | Loads raw tables used by this lab |

> This ensures Lab 3 can be completed even if Lab 2 has not yet been finished.

---

### 3️⃣ dbt Staging Models (Standardization Layer)

| File | Purpose |
|----|----|
| `models/lab3/staging/stg_customers.sql` | Standardizes customer data |
| `models/lab3/staging/stg_orders.sql` | Standardizes order data |
| `models/lab3/staging/stg_products.sql` | Standardizes product data |
| `models/lab3/staging/stg_order_items.sql` | Standardizes order line items |

---

### 4️⃣ dbt Core Models (Trusted Entities)

| File | Purpose |
|----|----|
| `models/lab3/core/dim_customers.sql` | Customer dimension |
| `models/lab3/core/dim_products.sql` | Product dimension |
| `models/lab3/core/fct_orders.sql` | Orders fact table |
| `models/lab3/core/fct_order_items.sql` | Order line-item fact table |

---

### 5️⃣ Analytical Views (Usage-Oriented Models)

| File | Purpose |
|----|----|
| `models/lab3/marts/oltp_order_detail.sql` | OLTP-style normalized view |
| `models/lab3/marts/olap_sales_by_day.sql` | OLAP-style aggregated view |

---

### 6️⃣ Data Quality & Governance Rules

| File | Purpose |
|----|----|
| `models/lab3/_lab3_models.yml` | dbt tests for keys and relationships |

---

### Student Checkpoint

✔ Confirm all files exist  
✔ Do **not** modify any files  

**Screenshot 1 (Required):** Directory listing showing Lab 3 files exist.

---

## Part 2 — Running the Lab (Commands Only)

### Step 2.1 — Activate Your Environment

```bash
cd ~/IT4065C-Labs
source dbt-venv/bin/activate
cd dbt/it4065c_platform
````

---

### Step 2.2 — Verify dbt Configuration

```bash
dbt debug
```

**Expected Result:**

* Connection test passes successfully

**Screenshot 2 (Required):** Successful `dbt debug` output

---

### Step 2.3 — Build Lab 3 Models Only

```bash
dbt run --select path:models/lab3
```

**Expected Result:**

* Staging, core, and marts models build successfully

**Screenshot 3 (Required):** `dbt run` results

---

### Step 2.4 — Run Data Quality Tests

```bash
dbt test --select path:models/lab3
```

**Expected Result:**

* All tests pass
* No null or duplicate primary keys
* No orphan foreign keys

**Screenshot 4 (Required):** `dbt test` results

---

### Step 2.5 — Validate Outputs (No SQL Writing)

```bash
cd ~/IT4065C-Labs
psql -h localhost -U postgres -d it4065c -f labs/module_2/lab3/lab3_quick_checks.sql
```

**Expected Result:**

* Reasonable row counts
* Aggregated results from OLAP model
* Sample rows from OLTP model

**Screenshot 5 (Required):** Output of validation queries

---

## Part 3 — Critical Thinking & Reflection

Answer the following questions in **6–10 sentences each**.

### Q1 — Modeling Layers

Why does this lab separate **staging models** from **core models** instead of modeling directly from raw tables?

---

### Q2 — OLTP vs OLAP

Compare the `oltp_order_detail` and `olap_sales_by_day` models.
Which would you use for analytics dashboards?
Which would you use for transaction-level investigation? Why?

---

### Q3 — Data Quality & Governance

Choose one dbt test from `_lab3_models.yml`.
What real-world data problem does this test help detect or prevent?

---

### Q4 — Governance Continuity

Based on earlier discussions about data classification, identify one field in this lab that would require restricted access or monitoring in a real organization.
Where would that control be enforced?

---

## Deliverables

Submit **one PDF or Word document** containing:

1. Screenshot 1 – Required files exist
2. Screenshot 2 – `dbt debug`
3. Screenshot 3 – `dbt run`
4. Screenshot 4 – `dbt test`
5. Screenshot 5 – Validation query results
6. Written responses to all reflection questions

---

## Troubleshooting (Quick Reference)

**dbt command not found**

```bash
source dbt-venv/bin/activate
```

**Raw tables missing**

```bash
psql -h localhost -U postgres -d it4065c -f labs/module_2/lab2_seed.sql
```

**dbt test failure**

* Do not modify tests
* Identify which constraint failed
* Explain the implication in your reflection

---

## Final Reminder

This lab is about **understanding, validating, and reasoning about data models** — not writing code under pressure.

Focus on:

* Structure
* Integrity
* Purpose
* Governance

That is how real data systems are evaluated.

