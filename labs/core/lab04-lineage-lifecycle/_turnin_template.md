# Lab 4: Lifecycle decision log

## How to complete this file

This is a writing worksheet, not a SQL script. Edit your private copy in `.local`
or use a word processor. Do not run this file in the terminal.

This file is your complete Lab 4 submission. Keep the headings and replace the
bracketed answer prompts. Short responses are enough. No separate general
submission template is needed.

1. Record your execution evidence and prediction in section 0.
2. Confirm the two lineage paths and explain one dependency in section 1.
3. Keep the supplied Raw example and complete the three stage sections in section 2.
4. Answer the three retention questions in section 3, then complete section 4.

The labeled sections are designed for Nano. You may use a word processor or
organize the same answers in a table instead; only one format is required.
Save in Nano with Ctrl+O, Enter, then exit with Ctrl+X. Saving does not execute SQL.

## 0. Execution evidence and prediction

Command actually run: [Write here]

Relevant PASS lines from my run: [Paste here, without personal shell prompts]

Prediction recorded before running: [Paste your one- or two-sentence prediction,
or state that you ran the command before recording a prediction. Do not invent one.]

Comparison with my result: [Briefly explain whether the checks passed and how
that compares with your prediction, if you recorded one.]

## 1. Record the lineage you inspected

Use the supplied paths as a guide and confirm them in the graph or model SQL:

```text
raw.orders -> stg_orders -> fct_orders -> olap_sales_by_day
raw.orders -> stg_orders -> fct_orders -> order_detail_mart
```

Method used (graph or model SQL): [Write here]

One source() or ref() dependency I inspected: [Name the SQL file and expression]

What that dependency means: [Write one sentence identifying its input]

## 2. Explain each lifecycle stage

Use the path ending at `olap_sales_by_day`. Grain means what one row represents.
Keep the Raw example labeled as supplied; it is not evidence of your own test.
For each other stage, replace the four prompts with brief responses.

### Raw: supplied example

**Input and grain:** `raw.orders`; one row per order.

**Transformation:** Stores supplied synthetic orders.

**Quality check:** Proposed: check that `order_id` is present and unique.

**Permitted role:** Proposed: course builder for maintenance.

**Evidence and limitation:** `lab2_seed.sql` describes the source fixture;
it does not establish access restrictions.

### Staging: `stg_orders`

**Input and grain:** One row per order with standardized fields.

**Transformation:** [Write briefly what is standardized.]

**Quality check:** [Name an observed check with evidence, or label a check Proposed.]

**Permitted role:** [Propose who should use the data and why, or cite tested access.]

**Evidence and limitation:** [Name a supporting file/output and what it cannot prove.]

### Core: `fct_orders`

**Input and grain:** One row per order.

**Transformation:** [Write briefly what the core model selects and stores.]

**Quality check:** [Name an observed check with evidence, or label a check Proposed.]

**Permitted role:** [Propose who should use the data and why, or cite tested access.]

**Evidence and limitation:** [Name a supporting file/output and what it cannot prove.]

### Marts: `olap_sales_by_day`

**Input and grain:** One row per day of completed-order sales.

**Transformation:** [Write briefly what is filtered, combined and aggregated.]

**Quality check:** [Name an observed check with evidence, or label a check Proposed.]

**Permitted role:** [Propose who should use the data and why, or cite tested access.]

**Evidence and limitation:** [Name a supporting file/output and what it cannot prove.]

### Help with the responses

- **Transformation:** describe what happens to the input. Look at the model's SQL.
- **Quality check:** choose a check relevant to that stage. A test is observed
  only if your execution evidence supports the claim. A check you recommend but
  have not run must say “Proposed.” You do not need to discover or execute a new test for each stage.
  If you lack specific execution evidence, propose a relevant check instead.
- **Permitted role:** identify who should use the data and why. Label this
  “Proposed” unless you have tested that role's access. A graph cannot prove access.
  You may name a business responsibility or a database role; make clear which
  you mean. A business responsibility alone does not establish database grants.
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

## 4. Assistance disclosure

[If you used AI assistance, describe where it helped and how you checked the
result. Otherwise write None. Follow your course's AI-use rules.]

## Completion checklist

- I included my command, relevant output and honest prediction record.
- I confirmed both paths and explained one connection.
- I completed the three student stage sections; the Raw example remains labeled as supplied.
- I distinguished observed evidence from proposed checks and roles.
- I answered all three scenario questions without claiming I executed deletion.
- I removed the answer placeholders and saved this log as my private submission.

Keep credentials and personal terminal details out of the submission. Do not
submit the supplied example as an independently tested result.

---

Template author: Isaac K. Nti. Repository authorship and reuse information is in
AUTHORS.md and CITATION.md at the repository root. Student responses remain the
student's work; template attribution does not establish authorship of those responses.
