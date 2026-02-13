
# Lab 4: Data Lifecycle Execution & Lineage Analysis

**Estimated Time:** 60–90 minutes  
**Environment:** PostgreSQL + dbt  
**Focus:** Lifecycle execution, lineage interpretation, governance reasoning  

---

# What Lab 4 Is Really About

Lab 4 is not a modeling lab.

You are not creating new SQL models.

You are operating and analyzing a complete data lifecycle that you already built in Lab 3.

This lab shifts from:

> “Can I build models?”

to

> “Do I understand how data flows through a governed system?”

You will:

- Execute the full lifecycle pipeline
- Generate dbt documentation
- Explore the lineage graph (DAG)
- Interpret how governance applies at each stage

This is an observation and reasoning lab — not a construction lab.

---

# What You Are Actually Learning

Lab 4 develops five professional capabilities:

---

## 1. Seeing the Full Lifecycle

You will execute:

```

raw → staging → core → marts

````

This layered flow represents:

- **Raw** = preserved intake  
- **Staging** = standardization and cleanup  
- **Core** = business meaning and integrity  
- **Marts** = analytics-ready outputs  

You are learning to see the entire pipeline as one connected system.

---

## 2. Operating a Controlled Lifecycle Build

You will run:

```bash
cd ~/IT4065C-Labs
bash labs/module_3/lab4/_run_all.sh
````

This script:

* Validates your dbt environment
* Confirms raw data availability
* Runs staging → core → marts
* Executes dbt tests
* Generates dbt documentation

This simulates a controlled enterprise deployment.

You are not just “running commands.”

You are executing a lifecycle build.

---

## 3. Understanding Lineage (DAG)

When you launch:

```bash
dbt docs serve --port 8080
```

You will open the dbt documentation interface and view the lineage graph.

The DAG shows:

* Upstream dependencies
* Transformation layers
* Data flow paths
* Structural relationships

Lineage is architectural transparency.

If you cannot explain the lineage, you do not fully understand the system.

---

## 4. Tracing Dependencies Across Layers

When you open a mart model (e.g., `oltp_order_detail`) in dbt Docs, you should observe:

* It depends on core fact and dimension models
* Those depend on staging models
* Those depend on raw source tables

This confirms:

Marts do not directly query raw data.

That separation is intentional and critical for governance.

It protects:

* Data integrity
* Business logic enforcement
* Auditability
* Controlled transformation

---

## 5. Connecting Code to Governance

In the staging layer (e.g., `stg_orders`), you will see:

```sql
from {{ source('raw', 'orders') }}
```

This line explicitly declares:

* Where the data originates
* Which schema owns it
* That staging depends on raw

Governance begins at source declaration.

Explicit references create traceability.

---

# What You Should Be Thinking About

While exploring the lineage graph, ask:

* Why don’t marts reference raw tables directly?
* Why is staging isolated from marts?
* Where is business logic introduced?
* Where would data quality tests fail?
* Which layer is safest for analysts?

This lab trains architectural awareness.

---

# How Lab 4 Connects to Previous Labs

## Connection to Lab 2 (Classification)

Lab 2 asked:

> What data is sensitive?

In Lab 4, you observe that:

Sensitive data originates in raw.

By the time it reaches marts:

* It has been structured
* It has been tested
* It has been controlled

Lifecycle design reduces governance risk.

---

## Connection to Lab 3 (Model Construction)

Lab 3 built the models.

Lab 4 demonstrates:

* How they connect
* Why they exist
* What dependencies mean

Modeling without lineage understanding is incomplete.

---

## Connection to Lab 5 (Security Enforcement)

Lab 4 shows:

How data flows.

Lab 5 will control:

Who can access which layer.

Understanding lifecycle flow is required before enforcing access control.

---

# Lifecycle Chain Requirement

You must write one complete lifecycle chain that starts from raw and ends in a mart.

Example:

```
raw.orders
→ stg_orders
→ fct_orders
→ olap_sales_by_day
```

Your chain must:

* Start with `raw.*`
* Include one `stg_*` model
* Include one `fct_*` or `dim_*` model
* End with `olap_*` or `oltp_*` model
* Use exact model names
* Use arrows (→) to show flow

You only need one valid path.

This demonstrates lifecycle understanding.

---

# What Strong Submissions Demonstrate

Strong work:

* Identifies correct upstream dependencies
* Shows full raw → staging → core → marts flow
* Uses exact model names
* Understands layer separation
* Avoids skipping lifecycle stages

Weak work:

* Skips staging
* Jumps from raw to mart
* Uses incorrect model names
* Describes theory without referencing the actual lineage graph

---

# Final Perspective

Lab 4 is where the course shifts from:

> “I built models.”

to

> “I understand how the system works.”

That difference defines architectural maturity.

Anyone can run dbt.

Professionals understand lineage.

Explore the DAG carefully.
Observe how layers protect and structure data.

Lifecycle awareness is foundational to governance, analytics engineering, and enterprise data architecture.

```


