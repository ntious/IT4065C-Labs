
# Module 2 – Lab 3  
## Submission Template  
**Data Modeling with dbt (Staging, Core Entities, OLTP vs OLAP)**

**Course:** IT4065C – Data Technologies Administration  
**Student Name:** ____________________________  
**Section:** ____________________________  
**Date Submitted:** ____________________________

---

## Submission Instructions (Read Carefully)

- Submit **one (1) PDF or Word document** to Canvas.
- Do **not** submit individual screenshots or raw files.
- Do **not** upload database credentials, passwords, or `.env` files.
- Screenshots must be clear and readable.
- Reflection responses must be written in your own words.

> ⚠️ **Academic Integrity Notice**  
> You may review provided scripts and outputs, but written explanations must reflect your personal understanding.

---

## Part 1 — Environment & File Verification

### Screenshot 1 — Required Files Exist

📸 **Attach Screenshot Here**

> Show a directory listing confirming the presence of the Lab 3 files  
> (e.g., `labs/module_2/lab3/` and `models/lab3/`).

---

## Part 2 — dbt Execution Evidence

### Screenshot 2 — dbt Debug

📸 **Attach Screenshot Here**

> Must show a successful `dbt debug` with no connection errors.

---

### Screenshot 3 — dbt Run (Lab 3 Models Only)

📸 **Attach Screenshot Here**

> Command used:
```bash
dbt run --select path:models/lab3
````

> Output should indicate that staging, core, and marts models were built.

---

### Screenshot 4 — dbt Test Results

📸 **Attach Screenshot Here**

> Command used:

```bash
dbt test --select path:models/lab3
```

> All tests should pass unless otherwise instructed.

---

## Part 3 — Model Output Validation

### Screenshot 5 — Validation Queries

📸 **Attach Screenshot Here**

> Output from running:

```bash
psql -h localhost -U postgres -d it4065c -f labs/module_2/lab3/lab3_quick_checks.sql
```

> Screenshots should show:

* Row counts for core models
* Aggregated results from the OLAP model
* Sample rows from the OLTP model

---

## Part 4 — Critical Thinking & Reflection

Respond to **each question** in **6–10 complete sentences**.
Use clear, professional language.

---

### Q1 — Modeling Layers

**Question:**
Why does this lab separate *staging models* from *core models* instead of modeling directly from raw tables?

**Your Response:**

> *(Write your response here)*

---

### Q2 — OLTP vs OLAP Design

**Question:**
Compare the `oltp_order_detail` model and the `olap_sales_by_day` model.
Which is better suited for analytical dashboards?
Which is better for transaction-level investigation? Explain why.

**Your Response:**

> *(Write your response here)*

---

### Q3 — Data Quality & Governance

**Question:**
Choose one dbt test defined in `_lab3_models.yml`.
What real-world data issue does this test help detect or prevent?

**Your Response:**

> *(Write your response here)*

---

### Q4 — Governance Continuity

**Question:**
Based on earlier discussions about data classification, identify one field used in this lab that would require restricted access or monitoring in a real organization.
Where would that control be enforced?

**Your Response:**

> *(Write your response here)*

---

## Optional Reflection (Not Graded)

### Q5 — Scalability Thinking

**Question:**
If this dataset grew to billions of records, which part of the model design would need to change first, and why?

**Your Response:**

> *(Optional)*

---

## Final Review Checklist (Student)

Before submitting, confirm that:

* [ ] All required screenshots are included and readable
* [ ] No passwords, secrets, or `.env` files appear in screenshots
* [ ] All reflection questions are answered fully
* [ ] The submission is a single PDF or Word document

---

## Submission Confirmation

I confirm that:

* This work reflects my own understanding
* I followed the lab instructions
* I did not modify required scripts unless explicitly allowed

**Student Signature (Typed):** ____________________________
**Date:** ____________________________

---

```

---

## Why This Template Is Best Practice

- ✔ Prevents accidental credential exposure
- ✔ Encourages professional documentation habits
- ✔ Makes grading faster and more consistent
- ✔ Emphasizes reasoning, not syntax
- ✔ Mirrors real-world data validation reports

---