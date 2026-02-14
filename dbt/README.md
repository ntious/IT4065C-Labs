# dbt Transformation Layer  
## Data Technologies Administration Governed Analytics Platform

This directory contains the dbt project that powers the transformation layer of the IT4065C analytics platform.

It converts structured source data into:

- Dimensional models
- Fact tables
- OLTP-style views
- OLAP-style analytical aggregates

This mirrors a real-world warehouse architecture.

---

# 📁 Directory Structure

```

dbt/
└── it4065c_platform/
├── models/
│   ├── staging/
│   ├── core/
│   │   └── lab3/
│   │       ├── dim_customers.sql
│   │       ├── dim_products.sql
│   │       ├── fct_orders.sql
│   │       └── fct_order_items.sql
│   ├── marts/
│   │   └── lab3/
│   │       ├── olap_sales_by_day.sql
│   │       └── oltp_order_detail.sql
│   └── lab3/
│       └── _lab3_models.yml
│
├── dbt_project.yml
├── profiles_template.yml
└── profiles.yml

```

---

# 🧱 Layer Responsibilities

## 1️⃣ Staging Layer

Location:
```

models/staging/

```

Purpose:
- Standardize source data
- Rename columns
- Apply light cleaning
- Maintain 1:1 mapping to source tables

No business logic allowed here.

---

## 2️⃣ Core Layer (Dimensional Modeling)

Location:
```

models/core/lab3/

```

This is where the dimensional warehouse is built.

### Dimension Tables

- `dim_customers.sql`
- `dim_products.sql`

Purpose:
- Descriptive attributes
- Surrogate keys (if implemented)
- Slowly changing logic (if extended later)

---

### Fact Tables

- `fct_orders.sql`
- `fct_order_items.sql`

Purpose:
- Transaction-level records
- Foreign keys to dimensions
- Measures (amount, quantity, etc.)

This layer implements your Logical Data Model (LDM).

---

## 3️⃣ Marts Layer (Consumption Layer)

Location:
```

models/marts/lab3/

```

This layer prepares outputs for:

- Reporting
- Dashboards
- Executive analytics

### OLTP-Style View
- `oltp_order_detail.sql`
  - Transaction-level detail
  - Operational visibility

### OLAP-Style View
- `olap_sales_by_day.sql`
  - Aggregated sales metrics
  - Time-based summarization

This separation reinforces:
- Operational vs Analytical systems
- Transactional vs Aggregated design

---

## 4️⃣ YAML Configuration

Location:
```

models/lab3/_lab3_models.yml

```

Purpose:
- Model documentation
- Column descriptions
- Tests (not_null, unique, relationships)

This file enforces:
- Data quality rules
- Documentation standards
- Governance metadata

---

# ⚙️ Project Configuration

## dbt_project.yml

Defines:
- Model paths
- Schema configuration
- Materialization defaults
- Naming conventions

Do not modify unless instructed.

---

## profiles.yml

Contains:
- Database credentials
- Target schema
- Connection settings

Each student must configure:

```

schema: student_<yourname>

````

Never commit credentials.

---

# 🚀 Running the Project

Always activate the controlled virtual environment:

```bash
source dbt-venv/bin/activate
````

Navigate into the project:

```bash
cd dbt/it4065c_platform
```

Run:

```bash
dbt debug
dbt run
dbt test
```

---

# 🔐 Governance Boundaries

You may:

* Build models in your assigned schema
* Modify lab-specific files if instructed
* Add tests in YAML files

You may NOT:

* Change other students’ schemas
* Modify core platform configuration
* Upgrade dbt versions manually
* Edit staging sources without instruction

---

# 🧠 Architectural Concepts Reinforced

| Component        | Course Concept                    |
| ---------------- | --------------------------------- |
| Staging          | Data lifecycle refinement         |
| Core             | Logical Data Model implementation |
| Dimensions       | Entity modeling                   |
| Facts            | Relationship modeling             |
| OLTP View        | Operational design                |
| OLAP View        | Analytical aggregation            |
| YAML             | Governance & testing              |
| Schema isolation | Access control                    |

---

# 🧪 Before Submitting Any Lab

You must confirm:

* `dbt run` completes successfully
* `dbt test` passes
* Objects are created only in your schema
* No warnings about version mismatch

---

# 🎯 Why This Structure Exists

This directory simulates:

* Enterprise data warehouse design
* Layered transformation logic
* Controlled deployment workflow
* Governed analytics engineering

You are not writing isolated SQL files.

You are building a layered transformation pipeline with traceability and control.

---

**Course:** Data Technologies Administration
**Layer:** Transformation Engine
**Framework:** dbt + PostgreSQL

```
