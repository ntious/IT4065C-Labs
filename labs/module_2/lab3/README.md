# Lab 3: Modeling and data quality

**Outcomes:** SLO 4. **Estimated time:** 60–90 minutes; allow additional time for installation and support.
**Environment:** your dedicated local course database. Synthetic data only.

## Why this lab matters

A report can run successfully and still give the wrong answer. Joining orders to
their items can count the same order total repeatedly, while including cancelled
orders can change reported revenue. Data administrators need to trace a reported
number to its sources and test the assumptions behind it.

This lab builds the supplied retail models, checks their data and asks you to
explain the completed-order revenue before designing a test of your own.

## Learning objectives

These instructor-developed lab objectives support SLO 4. By the end of the lab,
you should be able to:

- Trace data from raw tables through staging and core models to reporting marts.
- Identify each model's grain (what one row represents) and explain how a join
  can repeat order-level values.
- Reconcile completed-order revenue with source records and explain the treatment
  of cancelled orders.
- Write and run a dbt SQL data test, explain which rows would violate its rule,
  and distinguish passing tests from proof that all data is correct.

## Skills you will practice

Run a supplied dbt build through the course runner, read model SQL, inspect query
results, reason about joins and aggregation, and add a focused data-quality test.
You will also practice explaining the evidence behind a business metric.

If joins or aggregation are unfamiliar, review the
[foundations bridge](../../../docs/foundations.md) first. The supplied models provide
the starting point; you do not need to build a complete pipeline from scratch.

## What you will produce

- Relevant baseline execution results and your interpretation.
- A source-to-report explanation of the completed-order total of 139.95 for the
  supplied, unmodified fixture, including grain and cancellation assumptions.
- One original dbt SQL test, your prediction, its observed result after rerunning
  Lab 3, and an explanation of the rule it checks.
- A short explanation of a join-related calculation risk and one evidence limitation.

The runner produces technical results. You write the reconciliation, test reasoning
and limitations in your private submission; follow the Submit section below.

## Concept

The pipeline separates raw source records, standardized staging views, core entities
and purpose-specific marts. In this teaching database, raw records are synthetic;
the core models are derived copies, not automatically an authoritative system of record.

State the grain before writing a join. An order has several items. Joining its total
to each item repeats that total, which can distort sums and averages. The sales mart
first aggregates items to one row per order, then aggregates completed orders by day.
Its cancelled-order policy is a business assumption that must be documented.

A dbt data test returns rows violating an expectation. Uniqueness, missing values,
relationships and amount reconciliation are different claims. A passing test does
not prove the entire dataset is correct. Tests run when invoked; they are not database
constraints that prevent every future invalid write. This fixture deliberately leaves
some relationships to dbt tests so learners can observe the distinction.

The detailed and aggregate marts illustrate workload differences. They do not establish
transaction throughput, dimensional completeness or production performance. Explain
which additional measurements would be needed for those claims.

**Check your understanding:** Why is an average over joined line items different from
average order value? Derive both denominators and design a test that catches the error.

> **Completion:** Automation passing means the environment checks worked. Complete
> the independent investigation, interpretation and evidence below before submitting.

## Before you begin

We strongly recommend completing these earlier labs before starting Lab 3:

- [Lab 1: Environment readiness](../../module1_preflight/README.md): understand
  configuration, database identities and the limits of a successful connection check.
  Setup runs its technical checks automatically; its investigation and written work
  are separate learning activities.
- [Lab 2: Classification and stewardship](../M2_lab2_governance.md): become familiar
  with the synthetic retail data, query helper and governance decisions used here.

Use the same working environment and repository checkout from those labs. **Do not
repeat setup or Lab 1's technical checks just to start Lab 3.** A configured local
environment is required; if you are joining here without one, follow
[Student start here](../../../STUDENT_START_HERE.md) first. The runner checks its
required technical state, but it does not assess completion of earlier written work.

## Lab route

| Part | Your task | Completion checkpoint |
| --- | --- | --- |
| A: Guided baseline | Build the supplied models, inspect the sales output and trace its meaning | Ten models and 37 tests on an unchanged checkout; two daily sales rows totaling 139.95 |
| B: Test-writing practice and independent application | Run a complete example test, then write a different rule in your own file | Your named test appears in dbt results and you explain its rule, result and limits |
| C: Submission | Separate observed results from your own reasoning | A private, labeled evidence-and-reasoning submission |

Run commands one at a time from the repository root. Do not repeat setup. Additional
tests from previous practice can increase the count; do not delete them just to match
this guide. Stop on errors and use Recovery rather than treating a later PASS as a fix.

## Part A: Guided baseline and annotated results

### A1. Build the supplied project

Before running, record what you expect a successful build to establish and one thing
it cannot establish. If you already ran it, say so rather than inventing a prediction.

```bash
.venv/bin/python scripts/course.py lab 3
```

Expected on the unchanged supplied project:

```text
PASS: connection, dedicated database, schemas and non-superuser builder.
PASS: synthetic seed present (existing data preserved).
PASS: dbt build --selector course
PASS: 10 models and 37 data tests actually executed.
LAB 3 COMPLETE: technical checks passed; review interpretation and deliverables in labs/README.md.
```

The build creates the models and executes tests. The model/test count is verified
from dbt artifacts, not merely a printed target. Passing proves only the selected
checks for this execution. It does not complete the written task or prove production
readiness. Retain the relevant PASS lines privately.

### A2. Inspect daily sales

```bash
.venv/bin/python scripts/query.py labs/practice/inspect_sales.sql
```

After the environment PASS line, expect:

```json
[
  ["2026-01-10", 2, "3", "129.97", "64.9850000000000000"],
  ["2026-01-11", 1, "2", "9.98", "9.9800000000000000"]
]
```

Whitespace may differ. The helper serializes some PostgreSQL numeric values as
quoted text; this display does not mean the database columns store currency as text.
Do not paste this JSON into SQL. Each inner list is one day, with these annotations:

| Position | Model column | Meaning | January 10 | January 11 |
| --- | --- | --- | --- | --- |
| 1 | `order_date` | Day of completed orders | 2026-01-10 | 2026-01-11 |
| 2 | `orders_count` | Number of completed orders | 2 | 1 |
| 3 | `items_sold` | Sum of quantities, not count of order-item rows | 3 | 2 |
| 4 | `gross_sales` | Sum of completed orders' item amounts | 129.97 | 9.98 |
| 5 | `avg_order_value` | Average completed-order total for that day | 64.985 | 9.98 |

**What to notice:** daily revenue sums to **139.95**. January 10's average is
129.97 / 2 = 64.985; its long decimal display is normal. January 11 has one order
containing two units, so units sold and order count differ. The date-level rows
are already aggregated; they are not individual orders.

### A3. Read a worked reconciliation

Open the following source files in your editor or follow these links:

- [Synthetic source records](../lab2_seed.sql).
- [Order staging](../../../dbt/it4065c_platform/models/staging/lab3/stg_orders.sql).
- [Order model](../../../dbt/it4065c_platform/models/core/lab3/fct_orders.sql).
- [Item model](../../../dbt/it4065c_platform/models/core/lab3/fct_order_items.sql).
- [Daily sales model](../../../dbt/it4065c_platform/models/marts/lab3/olap_sales_by_day.sql).
- [Detailed order mart](../../../dbt/it4065c_platform/models/marts/lab3/oltp_order_detail.sql).

For the supplied fixture, completed orders 1 and 2 contribute 79.98 and 49.99 on
January 10. Completed order 4 contributes 2 × 4.99 = 9.98 on January 11. Order 3
is cancelled, so its 19.95 is excluded. Thus 79.98 + 49.99 + 9.98 = 139.95.
This is a worked explanation to help you read the model, not an answer you must
rediscover without support.

**Your explanation:** trace where the SQL filters completed orders, aggregates
items to order grain, and groups orders by day. Explain why those operations produce
the observed rows. Contrast the detailed mart's grain with the daily mart's grain.
Use your own words and cite the model names; a text flow is sufficient.

**Transfer question:** order 1 has multiple item rows. Explain how summing its
order-level total after a direct item join could count it more than once. Also
explain why averaging the two daily averages gives a different result from the
overall average across three completed orders. These are reasoning questions;
no source-data modifications are required.

> **Part A complete:** your baseline build passed and the inspected daily rows match
> the supplied fixture, including total revenue 139.95. Keep that output and your
> explanation. You have not yet created an independent data test; that is Part B.

## Part B: Learn the test pattern, then write your own

A dbt SQL data test is a SELECT that returns **violations**. Zero returned rows
means pass; returned rows mean the rule failed. A syntax or connection error means
the test could not run, which is different from finding bad data. A passing rule
can still be incomplete or poorly designed, so your explanation matters.

### B1. Run a complete teaching example

The [guided test SQL](lab3_guided_test.sql) asks whether a daily sales row has a
missing or non-positive completed-order count. Its assumption is that each reported
day contains at least one completed order.

```sql
select order_date, orders_count
from {{ ref('olap_sales_by_day') }}
where orders_count is null or orders_count <= 0
```

`ref` tells dbt which model to use and records the dependency. Unlike Lab 2's
`{{schema}}` SQL, this test must run through dbt via the course runner, **not**
through `scripts/query.py`. Do not replace `ref` with a password, schema or table path.

Copy the complete example into the dbt test directory:

```bash
cp -i labs/module_2/lab3/lab3_guided_test.sql dbt/it4065c_platform/tests/lab3_guided_daily_orders.sql
```

If prompted to overwrite existing work, answer `n` and inspect that file first.
Predict its result on the two observed daily rows, then run:

```bash
.venv/bin/python scripts/course.py lab 3
```

With exactly the original tests plus this example, expect **10 models and 38 tests**.
The project selector includes tests in this package, so no YAML edits are needed.
The named result in B3 is stronger evidence than the count alone.

### B2. Write a different rule in your own test file

Choose one additional rule and state its assumption in your private notes. Possible
starting questions include whether a reported daily sales amount can be negative,
whether a daily order value can be missing, or whether two related reported measures
can contradict each other under this fixture's assumptions. Inspect the three
existing SQL tests and model YAML before selecting a rule; explain any overlap.
Do not simply rename the guided test and submit its unchanged rule as your own.

Create or reopen this exact file:

```bash
nano dbt/it4065c_platform/tests/lab3_my_sales_rule.sql
```

Write one SELECT against `{{ ref('olap_sales_by_day') }}` using the B1 pattern.
Select `order_date` and the field(s) that would help investigate a violation.
Change the WHERE condition to return rows that **break your rule**, not rows that
satisfy it. Use the five actual column names in A2. Do not add INSERT, UPDATE,
DELETE, CREATE TABLE or copied terminal output to this file.

In your notes, state: the rule, why it matters, the expected result on the current
data and a hypothetical row that should violate it. You do not need to insert that
hypothetical row into the course database. Treat the hypothetical as reasoning,
not evidence of a failure you actually executed.

Save with Ctrl+O, Enter, then Ctrl+X. Editing this file does not run the test.
These student-authored tests live under the dbt project so dbt can discover them;
they are not ignored private files. Keep the work locally and submit through the LMS,
not through a public repository push. Never put personal data or credentials in it.

### B3. Execute and verify your named test

```bash
.venv/bin/python scripts/course.py lab 3
```

With one guided and one independent test added to the original project, expect
**10 models and 39 tests**, provided all pass. Counts may be higher after earlier
practice. Now inspect only your two named results using this read-only command:

```bash
.venv/bin/python - <<'PY'
import json
from pathlib import Path
wanted = {'lab3_guided_daily_orders', 'lab3_my_sales_rule'}
p = Path('dbt/it4065c_platform/target/run_results.json')
results = json.loads(p.read_text())['results']
found = set()
for result in results:
    name = result['unique_id'].split('.')[-1]
    if name in wanted:
        found.add(name)
        print(name, 'status=' + str(result['status']),
              'failures=' + str(result.get('failures')))
missing = wanted - found
if missing:
    raise SystemExit('Missing test results: ' + ', '.join(sorted(missing)))
PY
```

Copy the whole block, including the final `PY`, at the shell prompt. Expected for
passing tests:

```text
lab3_guided_daily_orders status=pass failures=0
lab3_my_sales_rule status=pass failures=0
```

The order can differ. Inspect results immediately after this Lab 3 run; another dbt
command can replace the artifact. A file existing on disk is not evidence it ran.
If the independent test fails, investigate whether your predicate is wrong, the
assumption is inappropriate or the data violates a justified rule. Record the result
honestly. Never weaken an assertion or delete existing tests merely to obtain PASS.

> **Part B complete:** the named independent test executed, you can explain its
> predicate and result, and you have documented its limitations. Resolve unintended
> errors before submission; if blocked, report the problem rather than claiming pass.

## Part C: Submit evidence and reasoning

Use a private copy of the [shared template](../../../submissions/template.md).
Label Part A and Part B. Readable text is sufficient; screenshots are optional.

| Item | Required evidence |
| --- | --- |
| Part A execution | Lab 3 command, relevant PASS lines and the two inspected daily rows |
| Part A interpretation | Your source-to-report explanation, grain comparison, cancellation policy and join/average reasoning from A3 |
| Part B guided practice | Your prediction and the named guided-test result from B3 |
| Part B independent work | File name, complete SQL, rule/assumption, prediction and named actual result |
| Test reasoning | A hypothetical violating row, why your predicate catches it, one overlap or difference from existing checks, and one limitation |
| Recovery and assistance | Any errors and actual recovery; AI assistance and how verified, or None, following course rules |

Do not submit full dbt logs, personal shell prompts, `.env`, credentials or generated
artifact directories. Logs can contain local paths; use the narrow result excerpts
above. Keep written work private. Independent learners retain their evidence locally.

Rubric: evidence 25%; interpretation 35%; transfer/tradeoffs 30%; clarity/limits 10%.
These are activity-level weights, not institutional course grade weights.

**Instructor handoff:** Part A is a reproducible supplied example. Part B uses one
guided test followed by one original rule. Assess the predicate, assumption and named
execution evidence, not just a larger test count or copied revenue explanation.
A hypothetical bad row is not an executed negative test. Controlled failure injection
in `scripts/verify.py` is an instructor rehearsal, not an extra student requirement.

## Recovery

| Symptom | What to check |
| --- | --- |
| Build stops | Read the first relevant error in `.local/dbt-last.log` locally; do not publish the full log. |
| New test missing | Confirm the exact `.sql` file is saved in the dbt tests directory, uses a valid ref, and rerun Lab 3. |
| SQL syntax error | Check selected column names, WHERE syntax and the ref expression. Do not run this dbt test through query.py. |
| Test returns failures | Inspect the rule and violating condition; distinguish data failure from an unjustified assumption. |
| Revenue differs | Check source/model changes and cancellation policy; do not reset or delete data to match the fixture. |
| Named result absent or old | Rerun Lab 3 and inspect run_results immediately afterward. |

Use [setup recovery](../../../docs/setup.md) for environment issues.

[Back to all labs](../../README.md)

---

Author: [Isaac K. Nti](../../../AUTHORS.md). [Citation and reuse terms](../../../CITATION.md).
