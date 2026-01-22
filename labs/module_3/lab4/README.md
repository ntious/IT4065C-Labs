# **Lab 4 — Data Lifecycle Design and Management**

**Module 3: Data Lifecycle Design and Management**
**Mode:** 🧪 Hands-On (Required)
**Primary SLOs:** SLO 2, SLO 4
**Estimated Time:** 60–90 minutes
**Risk Level:** Moderate
**Environment Stress:** Low (dbt + Postgres only)

---

## **Purpose of This Lab**

In this lab, you will **operate and analyze a complete data lifecycle** using dbt.

Rather than creating new models, you will **run, observe, and reason about** how data moves through lifecycle stages—from raw ingestion to analytics-ready outputs—and how governance, quality, and access decisions apply at each stage.

This lab emphasizes **understanding and interpretation**, not configuration or setup.

---

## **What You Have Already Done (Labs 1–3)**

Before starting Lab 4, you have already:

* Installed and validated PostgreSQL and dbt (Lab 1)
* Explored raw data and documented governance classifications (Lab 2)
* Built and validated dbt models across **staging → core → marts** (Lab 3)

👉 **Lab 4 does NOT repeat these tasks.**
Instead, it focuses on **lifecycle execution, lineage visualization, and decision documentation**.

---

## **Learning Outcomes**

By completing this lab, you will be able to:

1. Map the **full data lifecycle**: raw → staging → core → marts
2. Execute a **controlled lifecycle build** using dbt
3. Generate and interpret a **dbt lineage (DAG) graph**
4. Explain how lifecycle stages support:

   * Data quality
   * Governance
   * Access control
   * Analytics readiness
5. Document lifecycle decisions using a structured framework

---

## **Lab Concept: Data Lifecycle in Practice**

A well-designed data lifecycle ensures that:

* **Raw data** is preserved and auditable
* **Staging models** standardize and clean data
* **Core models** enforce business meaning and integrity
* **Marts** serve specific operational or analytical use cases

dbt makes this lifecycle **visible and testable**, especially through its lineage graph.

---

## **Before You Begin**

Make sure that:

* You successfully completed **Labs 1–3**
* You are working inside your cloned course repository
* You are using the **same database credentials** configured in Lab 1
* Your PostgreSQL service is running

⚠️ If Lab 3 did not run successfully, fix that first before continuing.

---

## **Step 1 — Run the Full Lifecycle Pipeline**

From the **root of the course repository**, run:

```bash
bash labs/module_3/lab4/lab4_run_all.sh
```

This script will:

1. Validate your dbt environment
2. Confirm raw data availability
3. Run all Lab 3 dbt models (**staging → core → marts**)
4. Execute dbt tests
5. Generate dbt documentation for lineage analysis

⏳ This may take a few minutes.
If the script completes without errors, you are ready to continue.

---

## **Step 2 — Launch dbt Docs and View Lineage**

Navigate to the dbt project directory:

```bash
cd dbt/it4065c_platform
```

Start the dbt documentation server:

```bash
dbt docs serve --port 8080
```

Open the URL displayed in your terminal (usually [http://localhost:8080](http://localhost:8080)).

---

## **Step 3 — Explore the Data Lineage Graph**

Inside the dbt Docs interface:

1. Go to **Lineage Graph**
2. Search for one of the following models:

   * `olap_sales_by_day`
   * `oltp_order_detail`
3. Trace the full upstream flow:

   * Raw tables
   * Staging models
   * Core entities
   * Mart models

### As You Observe, Ask Yourself:

* Where does raw data first get cleaned or standardized?
* Which models enforce business meaning?
* Which models are designed for analytics vs. operations?
* If a raw column were misclassified or exposed, which downstream models would inherit that risk?

📸 You will capture screenshots of this graph later.

---

## **Step 4 — Run Lifecycle Quick Checks**

Return to the repository root and run:

```bash
psql -h localhost -U postgres -d it4065c \
  -f labs/module_3/lab4/lab4_quick_checks.sql
```

These checks confirm:

* All lifecycle layers exist
* Downstream tables contain data
* The lifecycle executed successfully end-to-end

Review the output carefully.
If row counts are zero for downstream layers, revisit Step 1.

---

## **Step 5 — Document Lifecycle Decisions**

Open the file:

```
labs/module_3/lab4/lab4_turnin_template.md
```

Complete the **Lifecycle Decision Log**, documenting:

* Purpose of each lifecycle layer
* What types of transformations are allowed
* Where quality checks act as promotion gates
* Who should access each layer
* How lifecycle design supports governance and analytics

There are **no right or wrong answers**, but your reasoning must be clear and defensible.

---

## **Deliverables**

Submit the following to Canvas:

### **Required Screenshots**

1. **Lifecycle Build Completion**
   Terminal output showing `lab4_run_all.sh` completed successfully
2. **dbt Lineage Graph**
   Showing raw → staging → core → marts for at least one mart model
3. **Quick Checks Output**
   Showing lifecycle layers and row counts

### **Written Artifacts**

4. **Completed Lifecycle Decision Log**
   (from `lab4_turnin_template.md`)
5. **Short Reflection (3–6 sentences)**
   Respond to:

   > How does lifecycle design reduce risk and improve trust in data?

---

## **How This Lab Connects to the Course**

This lab brings together concepts from across the course:

* **Governance** (classification, accountability, stewardship)
* **Modeling** (structure supports usage)
* **Lifecycle management** (promotion, testing, and access)
* **Analytics readiness** (marts are not accidental—they are designed)

You are not just running pipelines—you are **designing and defending data systems**.

---

## **Troubleshooting (Quick Guidance)**

* ❌ `dbt debug` fails → Re-activate your virtual environment
* ❌ No raw tables listed → Re-run the Lab 2 seed script
* ❌ dbt build fails → Read the first error carefully; most issues are upstream
* ❌ Docs page won’t load → Ensure `dbt docs serve` is still running

For persistent issues, consult the **Lab 4 Troubleshooting Appendix** or contact your TA.

---

