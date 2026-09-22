# Lab 4: Lifecycle decision log

## How to complete this file

This is a writing worksheet, not a SQL script. Edit your private copy in `.local`
or use a word processor. Do not run this file in the terminal.

1. Read the completed Raw example. You may keep it unchanged as the supplied example.
2. Complete the Staging, Core and Marts rows: replace each `[Write: ...]` prompt
   with a short explanation. Model names and grain are provided for you.
3. Answer the three retention questions below. No records should be deleted.

In Nano, type between the table's `|` separators; preserve them. Wide rows can
extend beyond the screen, which is normal. You do not need to align the spacing.
If editing a Markdown table is difficult, write a labeled paragraph for each
stage using the same column names instead. Save with Ctrl+O, Enter, then exit
with Ctrl+X. Saving records your answers; it does not execute SQL.

## 1. Record the lineage you inspected

Use the supplied paths as a guide and confirm them in the graph or model SQL:

```text
raw.orders -> stg_orders -> fct_orders -> olap_sales_by_day
raw.orders -> stg_orders -> fct_orders -> oltp_order_detail
```

Method used (graph or model SQL): [Write here]

One connection I inspected and what it means: [Write one sentence here]

## 2. Complete the decision table

Use the path ending at `olap_sales_by_day` for this table. A grain describes what
one row represents. The raw row is a worked example, not evidence of your own test.

| Stage | Input and grain | Transformation | Quality check | Permitted role | Evidence and limitation |
| --- | --- | --- | --- | --- | --- |
| Raw (supplied example) | raw.orders; one row per order | Stores supplied synthetic orders | Proposed: check order_id is present and unique | Proposed: course builder for maintenance | lab2_seed.sql describes the source fixture; it does not establish access restrictions |
| Staging | stg_orders; one row per order with standardized fields | [Write: what is standardized?] | [Write: a relevant check and whether observed or proposed] | [Write: a proposed role, or tested role with evidence] | [Write: supporting file/output and one limitation] |
| Core | fct_orders; one row per order | [Write: what does the core model select and store?] | [Write: a relevant check and whether observed or proposed] | [Write: a proposed role, or tested role with evidence] | [Write: supporting file/output and one limitation] |
| Marts | olap_sales_by_day; one row per day of completed-order sales | [Write: what is filtered and combined?] | [Write: a relevant check and whether observed or proposed] | [Write: a proposed role, or tested role with evidence] | [Write: supporting file/output and one limitation] |

### Help with the columns

- **Transformation:** describe what happens to the input. Look at the model's SQL.
- **Quality check:** choose a check relevant to that stage. A test is observed
  only if your execution evidence supports the claim. A check you recommend but
  have not run must say “Proposed.” You do not need to run an additional test here.
- **Permitted role:** identify who should use the data and why. Label this
  “Proposed” unless you have tested that role's access. A graph cannot prove access.
- **Evidence and limitation:** name a file, test result or observation and state
  what it does not establish. A general PASS count does not identify a specific test.

Find `stg_orders`, `fct_orders` and `olap_sales_by_day` in the local dbt catalog.
The lab guide also links their SQL files. These filenames are relative to the
repository root if you prefer a local editor:

```text
dbt/it4065c_platform/models/staging/lab3/stg_orders.sql
dbt/it4065c_platform/models/core/lab3/fct_orders.sql
dbt/it4065c_platform/models/marts/lab3/olap_sales_by_day.sql
dbt/it4065c_platform/dbt_project.yml
```

## 3. Reason about retention

**Scenario:** an approved retention decision removes one order from `raw.orders`.
This is hypothetical. Do not delete data or run a refresh to answer these questions.
The project uses views for staging and stored tables for core and marts. A view
reads its input when queried; a stored table needs a separate rebuild or change.

### Question 1: Which copies could remain?

Name downstream stored models that could retain the order or its contribution to
sales totals. Consider both reporting paths above.

Answer: [Write here]

### Question 2: What would you refresh and verify?

Propose a refresh order based on dependencies. Describe a query or before/after
comparison you would use to verify the result. Plain language is sufficient; no
executable SQL is required. Consider related item records when explaining limits.

Answer: [Write here]

### Question 3: What does the graph not prove or prevent?

Explain one action it cannot prevent, such as an authorized reader exporting a
copy. Name the additional evidence or control needed, and explain what remains
unknown about copies such as exports or backups.

Answer: [Write here]

## Completion checklist

- I confirmed both paths and explained one connection.
- I completed the three student rows; the Raw row remains labeled as supplied.
- I distinguished observed evidence from proposed checks and roles.
- I answered all three scenario questions without claiming I executed deletion.
- I removed the answer placeholders and included this log in my private submission.

Keep credentials and personal terminal details out of the submission. Do not
submit the supplied example as an independently tested result.

---

Template author: Isaac K. Nti. Repository authorship and reuse information is in
AUTHORS.md and CITATION.md at the repository root. Student responses remain the
student's work; template attribution does not establish authorship of those responses.
