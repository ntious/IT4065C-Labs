# Lab 4: Lifecycle and lineage

**Outcomes:** SLOs 2,4. **Estimated time:** 45–60 minutes; allow additional time for installation and support.
**Environment:** your dedicated local course database. Synthetic data only.

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

> **Completion:** Automation passing means the environment checks worked. Complete
> the independent investigation, interpretation and evidence below before submitting.

## Before you begin

Complete [setup](../../../docs/setup.md) and Lab 1. Complete the previous core labs for context.
The runner checks its required state and reports missing prerequisites.

## Predict and run

Read the expected result below and predict what would fail with the wrong identity or missing input.
From the repository root in your Ubuntu terminal:

```bash
.venv/bin/python scripts/course.py lab 4
```

Expected: **Models/tests rebuilt, dbt docs generated and raw.orders lineage edge verified.** The final line is `LAB 4 COMPLETE`.
Rerunning is supported; existing raw and governance data are preserved.
Do not confuse a printed expectation with a passed assertion: the runner stops on unexpected outcomes.

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
