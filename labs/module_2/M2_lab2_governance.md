# Lab 2 — Raw Data Exploration & Data Classification
* **Estimated Time:** 45–75 minutes
* **Risk Level:** Low
* **Environment Stress:** Minimal (Postgres + SQL only)

---

## What You Will Learn After This Lab

By the end of this lab, you will be able to:

* Navigate a real database schema and inspect tables and columns
* Identify **PII, financial, and operational data** using SQL
* Classify data fields using governance categories (Public, Internal, Sensitive, Restricted)
* Document governance decisions in a structured, auditable format
* Explain *why* certain data requires stricter controls than others

> This lab focuses on **seeing and thinking**, not transforming data.

---

## Important Scope Reminder (Please Read)

* ❌ **No dbt in this lab**
* ❌ **No data transformations**
* ❌ **No performance tuning**
* ✅ **Yes to exploration, classification, and documentation**

If you feel unsure at any point, that is **normal**.
You are learning how professionals reason about data—not memorizing steps.

---

## What You Are Given

When you cloned the course repository in Lab 1, you already received:

* A working Postgres database (`it4065c`)
* A `raw` schema containing retail data
* A seed file located at:

```text
IT4065C-Labs/labs/module_2/lab2_seed.sql
```

You will use this file **only if the raw tables are not already present**.

---

## Part 0 — Resume Your Environment (Low Stress Check)

If you restarted your VM:

```bash
cd ~/IT4065C-Labs
```

Then connect to Postgres:

```bash
psql -h localhost -U postgres -d it4065c
```

✔ Success looks like:

```text
it4065c=#
```

If you cannot connect, **stop here** and resolve before continuing.

---

## Part 1 — Ensure Raw Data Exists

### Step 1.1: Check for raw tables

Inside `psql`, run:

```sql
\dt raw.*
```

### If you see tables (customers, orders, products, order_items):

✅ **Proceed to Part 2**

### If you do NOT see any tables:

Run the provided seed file **once**:

```bash
psql -h localhost -U postgres -d it4065c -f labs/module_2/lab2_seed.sql
```

Then reconnect to `psql` and re-run:

```sql
\dt raw.*
```

> This step ensures everyone works with the **same clean dataset**, reducing confusion.

---

## Part 2 — Explore Raw Tables (Think Like a Data Steward)

You will explore **at least two raw tables**.

### Step 2.1: Inspect table structure

Example:

```sql
\d raw.customers
```

This tells you:

* Column names
* Data types
* Which fields *might* be sensitive

### Step 2.2: Preview sample data (safe amount)

```sql
SELECT * FROM raw.customers LIMIT 10;
```

⚠️ Do **not** dump entire tables.

---

## Part 3 — Identify Sensitive Data

As you explore tables, ask:

* Does this identify a person?
* Does this involve money or payment?
* Would misuse of this data cause harm?

### Classification Levels You Will Use

| Level      | Meaning                              |
| ---------- | ------------------------------------ |
| Public     | Safe to share broadly                |
| Internal   | Business-use only                    |
| Sensitive  | PII or financial data                |
| Restricted | High-risk personal or financial data |

There is **no single “correct” answer**—your **reasoning** matters.

---

## Part 4 — Create a Governance Register (Your Workspace)

You will document your decisions in your own schema.

### Step 4.1: Create the register table

```sql
CREATE TABLE IF NOT EXISTS student_kofi.data_classification_register (
  schema_name     TEXT NOT NULL,
  table_name      TEXT NOT NULL,
  column_name     TEXT NOT NULL,
  data_type       TEXT NOT NULL,
  classification  TEXT NOT NULL,
  rationale       TEXT NOT NULL,
  owner_role      TEXT NOT NULL,
  retention_type  TEXT NOT NULL,
  created_at      TIMESTAMP DEFAULT NOW()
);
```

This table represents how governance is **actually tracked** in practice.

---

## Part 5 — Populate the Register (Main Task)

### Minimum Requirement

You must classify:

* **At least 12 columns**
* From **at least 2 different tables**

### Example Insert

```sql
INSERT INTO student_kofi.data_classification_register
(schema_name, table_name, column_name, data_type, classification, rationale, owner_role, retention_type)
VALUES
('raw', 'customers', 'email', 'text', 'Sensitive',
 'Direct customer identifier used for communication.',
 'Customer Data', 'Long-term');
```

✔ Your **rationale must be specific**
❌ Avoid vague reasons like “because it is PII”

---

## Part 6 — Verify Your Work

Run:

```sql
SELECT table_name, COUNT(*) AS classified_columns
FROM student_kofi.data_classification_register
GROUP BY table_name;
```

Then:

```sql
SELECT *
FROM student_kofi.data_classification_register
ORDER BY table_name, column_name;
```

You should see real, meaningful entries.

---

## Part 7 — Reflection (Short, Important)

In **4–6 sentences**, answer:

1. Which columns were easiest to classify, and why?
2. Which columns were uncertain?
3. What additional business context would help you decide?
4. How does separating `raw` data from governed data help with accountability?

---

## What You Should *Not* Worry About

* Perfect classifications
* Advanced security controls
* Performance
* dbt, pipelines, or transformations

Those come later.

---

## Deliverables

Submit:

* Screenshots showing:

  * Raw table exploration
  * Governance register populated
* Short reflection (4–6 sentences)

---

## How This Prepares You for Module 2

In Module 2, you will:

* Use these same tables
* Build logical models from them
* Implement governed models using dbt

This lab ensures you understand **what data exists before modeling it**.

---

## If Something Feels Confusing

That is expected.

Data governance is **judgment-based**, not formula-based.
Your goal is to **explain your reasoning**, not guess the instructor’s answer.

---
