# Lab 3: Modeling and data quality

**Outcomes:** SLO 4. **Estimated time:** 60–90 minutes; allow additional time for installation and support.
**Environment:** your dedicated local course database. Synthetic data only.

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

Complete [setup](../../../docs/setup.md) and Lab 1. Complete the previous core labs for context.
The runner checks its required state and reports missing prerequisites.

## Predict and run

Read the expected result below and predict what would fail with the wrong identity or missing input.
From the repository root in your Ubuntu terminal:

```bash
.venv/bin/python scripts/course.py lab 3
```

Expected: **Ten models and at least thirty data tests actually executed. Completed-order revenue is 139.95.** The final line is `LAB 3 COMPLETE`.
Rerunning is supported; existing raw and governance data are preserved.
Do not confuse a printed expectation with a passed assertion: the runner stops on unexpected outcomes.

## Hands-on investigation

```bash
.venv/bin/python scripts/query.py labs/practice/inspect_sales.sql
```

Trace each result to raw orders and items using the staging/core/mart SQL. Work out
the completed-order total of 139.95 independently. Explain why cancelled orders and
the number of line items affect naive calculations. Add one new dbt SQL test in
`dbt/it4065c_platform/tests/`, predicting pass/fail first, and rerun Lab 3. A test
returns rows that violate its rule. Submit your rule and reasoning, not copied
dbt debug logs. Instructors can use `scripts/verify.py` for a controlled bad-data
injection and restoration rehearsal on the unmodified fixture.

For custom SQL, use the [query helper instructions](../../practice/README.md#execute-your-own-sql-without-managing-passwords).

## Interpret and transfer

Predict the grain of each mart, then inspect the SQL. Propose a new test for an orphan or wrong total. Explain why averaging order totals after joining line items is unsafe.

## Submit

Use the [submission template](../../../submissions/template.md). Include the command,
relevant PASS lines or accessible text evidence, your interpretation, one limitation,
and your transfer-task response. A screenshot is optional; crop/redact identities
and never include configuration secrets. Submit privately through your course system;
independent learners keep their work locally. Execution success alone does not
complete the reasoning task.

Rubric: correct execution/evidence 25%; accurate interpretation 35%; transfer and
tradeoff reasoning 30%; clarity and evidence limitations 10%.

## Recovery

Use the [setup troubleshooting table](../../../docs/setup.md). Read errors before retrying;
never delete tests or change authentication to make a result pass. There is no
automatic destructive reset. For an isolated new start use a new DB/user pair.

[Back to all labs](../../../labs/README.md)

---

Author: [Isaac K. Nti](../../../AUTHORS.md). [Citation and reuse terms](../../../CITATION.md).
