# Lab 4: Lifecycle and lineage

**Outcomes:** SLOs 2,4. **Estimated time:** 45–60 minutes; allow additional time for installation and support.
**Environment:** your dedicated local course database. Synthetic data only.

## Why this lab matters

When a source record changes or is removed, the reports built from it may also
need to change. A data administrator must know where data goes, which copies
could remain and what evidence would confirm that a change reached its destination.

In Lab 3 you built and checked sales models. In this lab you follow the connections
between those models and explain a retention scenario. These connections are
called **lineage**. You will use supplied documentation to make a lifecycle
decision, rather than assume that changing a source automatically changes every copy.

## Learning objectives

These instructor-developed lab objectives support SLOs 2 and 4. By the end of this
lab, you should be able to:

- Trace the supplied order data from its raw source through staging and core models
  to the reporting marts using generated documentation or a written path.
- Explain why a view and a stored table can respond differently to a source-data
  change, and identify downstream copies to investigate in a retention scenario.
- Complete a lifecycle decision log connecting each stage to its transformation,
  quality check, permitted role and supporting evidence.
- Distinguish a documented dependency from evidence that access restrictions or
  deletion requirements have actually been enforced.

## Skills you will practice

- Generate and navigate local dbt documentation using the supplied commands.
- Read model dependencies and describe what one row represents at each stage.
- Reason about refresh and retention responsibilities without deleting course data.
- Record a proposed action, its evidence needs and its limitations clearly.

No prior experience with lineage tools is assumed. A **dependency** means that
one model uses another source or model. A **DAG** is a diagram of these directed
connections without circular paths. You may describe the same connections in text;
you do not need to draw a diagram or write a new pipeline for this lab.

## What you will produce

- The relevant execution results from the Lab 4 runner.
- A source-to-report lineage path, shown in text or an optional screenshot.
- A completed [lifecycle decision log](_turnin_template.md), including your
  explanation of which downstream copies might remain after a source record is
  removed and what you would investigate or refresh.
- An explanation of one action the lineage diagram cannot prevent and one limit
  of your evidence. The retention scenario is a reasoning task, not an instruction
  to delete records.

Use the shared submission template to organize this evidence and include the
completed decision log. You do not need to repeat the same explanation in both.

## Concept

Lineage records dependencies: changing a raw source can affect several downstream
models. dbt’s manifest and local documentation expose these relationships. A dependency
edge describes transformation structure; it does not prove authorization or retention.

Views read underlying data when queried. Materialized tables hold copies until rebuilt
or changed. Deleting a source record therefore does not imply deletion from every
materialized downstream model, export, backup or AI training set. Trace each copy,
its owner, refresh behavior and evidence of deletion in the lifecycle decision log.

Separate acquisition, validation, transformation, permitted use, sharing, retention
and retirement. At each transition ask who approves the change and what evidence
would demonstrate it. Do not label a proposed control as implemented because it
appears in a diagram.

**Check your understanding:** A raw email is removed while a downstream table still
contains a derived identifier. What is your evidence of propagation, and what remains
unknown? Lab 8 extends this reasoning to a simulated restore and deletion ledger.

> **Completion:** Automation passing means the selected technical checks passed. Complete
> the independent investigation, interpretation and evidence below before submitting.

## Before you begin

We recommend completing [Lab 1](../../module1_preflight/README.md),
[Lab 2](../../module_2/M2_lab2_governance.md) and
[Lab 3](../../module_2/lab3/README.md) first. They introduce the environment,
governance decisions and sales models used here. These are earlier course
activities, not assumed prior programming qualifications.

Use the same configured environment. You do not need to repeat setup or Lab 1's
technical checks. If you are joining without an environment, follow
[Student start here](../../../STUDENT_START_HERE.md). The Lab 4 runner rebuilds
and tests the Lab 3 models before generating documentation; this is expected,
including any saved tests you added during Lab 3.

## Predict and run

Read the expected result below and predict what would fail with the wrong identity or missing input.
From the repository root in your Ubuntu terminal:

```bash
.venv/bin/python scripts/course.py lab 4
```

**Expected output after completing Lab 3 with both added test files:**

```text
PASS: connection, dedicated database, schemas and non-superuser builder.
PASS: synthetic seed present (existing data preserved).
PASS: dbt build --selector course
PASS: 10 models and 39 data tests actually executed.
PASS: dbt docs generate
PASS: raw.orders -> stg_orders lineage present; documentation generated.
LAB 4 COMPLETE: technical checks passed; review interpretation and deliverables in labs/README.md.
```

**What these results mean:**

| Result | What it confirms |
| --- | --- |
| Connection PASS | The connection, dedicated database, schemas and non-superuser builder checks passed. |
| Synthetic seed PASS | The existing course source data was preserved. |
| dbt build and model/test count | Lab 4 rebuilt the Lab 3 project and its selected tests passed. It is normal to see these checks again. |
| dbt docs generate PASS | dbt generated local documentation artifacts. This does not open them in your browser. |
| Lineage PASS | The generated manifest records that `stg_orders` depends on `raw.orders`. This specific check does not verify every downstream relationship, access restriction or deletion action. |
| LAB 4 COMPLETE | The automated checks finished. The investigation and written decision log remain to be completed. |

**Your test count can differ:** the unchanged supplied project has 37 tests.
Adding the B1 guided test and the B2 test file in Lab 3 brings it to 39. Other
saved tests can increase it further. Rerunning does not duplicate tests; do not
delete your work to match a sample count.

**Checkpoint:** save the command and relevant PASS lines privately for your
submission. If you already ran the command before recording a prediction, state
that honestly. If a check fails, use Recovery before continuing; a partial set
of PASS lines does not establish completion.

Rerunning is supported; existing raw and governance data are preserved. Once the
checks pass, continue to **Hands-on investigation** to open the documentation
and trace the downstream path yourself. No setup rerun is needed.

## Hands-on investigation

Open the generated local documentation using `.venv/bin/python scripts/course.py docs`. Trace
`raw.orders` through staging and the fact table to both marts. Complete
`labs/module_3/lab4/_turnin_template.md`. Suppose retention removes a raw record:
which materialized downstream copies could persist, and what would you refresh?
Document the lineage path in text as an accessible alternative to a screenshot.

For custom SQL, use the [query helper instructions](../../practice/README.md#execute-your-own-sql-without-managing-passwords).

## Interpret and transfer

Trace raw.orders → stg_orders → fct_orders → olap_sales_by_day. Explain what the DAG proves and what requires an access-control or promotion test. Complete the lifecycle decision template.

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
