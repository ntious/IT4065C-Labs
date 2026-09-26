# Lab 4 sample submission: Lifecycle and lineage

> **Optional example: format, evidence selection and level of detail.**
> Complete your own [decision log](_turnin_template.md) using the
> [Lab 4 instructions](README.md). This sample is not another assignment or a
> second submission template. Use your own observations and explanations.

## How to use this sample

The command output and graph observations below come from the instructor's shared
walkthrough. Personal terminal details and the earlier completion banner are
omitted. The current runner uses the wording `LAB 4 TECHNICAL CHECKS COMPLETE`.
The sample does not claim a new execution of the updated runner.

Explanations labeled **Illustrative reasoning** demonstrate an appropriate level
of detail; they are not a record of additional tests or actions performed during
that walkthrough. The separate library scenario is fictional and does not require
you to create tables or run commands.

The numbered sections match your decision log. One to three clear sentences per
response usually suffice. Text evidence is sufficient; screenshots are optional.

## 0. Execution evidence and prediction

**Command run in the walkthrough:**

```bash
.venv/bin/python scripts/course.py lab 4
```

**Relevant observed result excerpt:**

```text
PASS: connection, dedicated database, schemas and non-superuser builder.
PASS: synthetic seed present (existing data preserved).
PASS: dbt build --selector course
PASS: 10 models and 39 data tests actually executed.
PASS: dbt docs generate
PASS: raw.orders -> stg_orders lineage present; documentation generated.
```

The count includes the two saved Lab 3 tests. Your count can differ if your saved
tests differ. Record your actual count; do not delete tests to match this sample.

**Prediction:** the shared walkthrough did not include a recorded advance
prediction. Do not infer one from the successful result. If this also describes
your run, you can write: "I ran the command before recording a prediction."

**Illustrative result explanation:**
The selected build and tests completed, and the manifest check confirmed the
`raw.orders` to `stg_orders` dependency. This does not establish every downstream
relationship or demonstrate deletion or access enforcement. Without an advance
prediction, I cannot claim to compare the result with one.

**Documentation observation:**
The instructor ran `.venv/bin/python scripts/course.py docs` and opened the local
documentation in a browser. The shared focused graph displayed the two paths in
section 1. The page initially loaded slowly; its eventual display confirms that
it responded, but does not establish what caused the delay. Report recovery only
if you experienced it yourself; there is no required error to reproduce.

## 1. Record the lineage you inspected

**Observed method:** focused graph, with `+stg_orders+` selected.

**Paths visible in the supplied graph:**

```text
raw.orders -> stg_orders -> fct_orders -> olap_sales_by_day
raw.orders -> stg_orders -> fct_orders -> order_detail_mart
```

The [annotated graph](../../../sample_screenshots/lab4-focused-lineage-annotated.png)
helps distinguish the source, models and tests. Other inputs are hidden by this
filter; these two paths are not the whole project.

**Illustrative dependency explanation:**
In [the daily sales model](../../../dbt/it4065c_platform/models/marts/lab3/olap_sales_by_day.sql),
`ref('fct_orders')` identifies `fct_orders` as an input model. It records a
transformation dependency; it does not grant a user permission to read the data.

For your log, name the SQL file and dependency you actually inspected. A test
node in the graph does not prove that the test passed; execution evidence is
separate.

## 2. Explain each lifecycle stage

The following is the **supplied Raw example**, also present in the worksheet.
It shows the length and evidence boundaries expected for a stage response.

### Raw: supplied example

**Input and grain:** `raw.orders`; one row per order.

**Transformation:** Stores supplied synthetic orders.

**Quality check:** Proposed: check that `order_id` is present and unique.

**Permitted role:** Proposed: course builder for maintenance.

**Evidence and limitation:**
[The seed SQL](../lab02-classification/lab2_seed.sql) describes the source fixture.
It does not establish access restrictions. The proposed check above is not being
reported as an executed test.

### What you complete independently

In your own log, keep the Raw example labeled as supplied and complete the
**Staging**, **Core** and **Marts** sections. Their model names and grains are
already supplied. For each, write the transformation, quality check, permitted
role with justification, and supporting evidence with a limitation.

Use a specifically evidenced check or label your recommendation **Proposed**.
You do not need a new test for each stage. A business responsibility and a
database login are different: make clear which you mean when proposing a role.
The completed Raw example demonstrates the format, not tested authorization.

## 3. Reason about retention

**Illustrative reasoning in a different, fictional scenario:**
Suppose a library loads borrowing events into `raw.loans`, exposes them through
an ordinary `stg_loans` view, and rebuilds a stored `monthly_loan_counts` table.
Those names are examples only; they are not course database objects. Assume an
approved retention decision removes one source event.

### Question 1: Which copies could remain?

The stored monthly count could still include the removed event until it is
recomputed. The ordinary staging view reads its source when queried and does not
hold a separately stored copy of its results.

### Question 2: What would you refresh and verify?

**Proposed:** rebuild the monthly summary from the updated source through its
staging dependency. Compare the affected month's count with an independently
calculated count from the retained source events, using the same reporting rules.
This is a verification plan, not an action I executed.

### Question 3: What does the graph not prove or prevent?

A reader could have exported an earlier report. Rebuilding the monthly table
would not establish removal from that export or from backups. I would need an
inventory of those copies, responsible owners and evidence of the applicable
retention actions before making a broader deletion claim.

**Your actual response:** answer the three questions for the lab's order-data
scenario, naming the affected course models on both paths you inspected. Do not
submit the library example or claim that you deleted or refreshed records.

## 4. Assistance disclosure

Use your actual assistance history. An illustrative disclosure, only if accurate:

> I used AI assistance to clarify the distinction between a dependency and a
> stored copy. I checked the explanation against the linked model SQL and
> `dbt_project.yml`. I did not execute the hypothetical deletion or refresh.

If no AI assistance was used, write `None`. Follow the current course's AI-use
rules; this example does not grant permission to use tools an assignment prohibits.

## Before submitting

Your one private decision log should contain your execution evidence and honest
prediction record; two checked paths and a named dependency explanation; three
completed stage sections beside the supplied Raw example; three answers about the
order-data scenario; and an assistance disclosure. Replace the worksheet prompts
with your responses. Do not attach this sample as your completed work.

Omit passwords, `.env` contents, personal shell prompts and full logs. Submit
through the LMS, or retain privately for self-study. Do not publish a filled
student submission in this repository.

[Return to Lab 4 instructions](README.md#submit).

---

Author: [Isaac K. Nti](../../../AUTHORS.md). [Citation and reuse terms](../../../CITATION.md).
