# Lab 2: Classification and stewardship

**Outcomes:** SLOs 1,5. **Estimated time:** 45–60 minutes; allow additional time for installation and support.
**Environment:** your dedicated local course database. Synthetic data only.

## Concept

Classification connects a data field to an intended use, accountable owner and
control. A label alone does not restrict a query. The register records your reasoning;
Lab 5 implements selected controls through database grants and views.

Use the field’s meaning, context and plausible harm to justify its class. A customer
email is a contact identifier even if its SQL type is merely text. Aggregation can
reduce exposure but small groups and joins may reveal information. Classification
can change when data is combined or repurposed for AI.

Worked entries demonstrate the format, not an organization-wide policy. Retention
periods must come from an approved purpose and applicable requirements; do not invent
a universal legal retention duration. Record unresolved assumptions explicitly.

**Check your understanding:** Two teams classify an amount differently. What business
context would resolve the disagreement? What evidence would show that their chosen
control actually operates? Add a field with your own rationale using the investigation below.

> **Completion:** Automation passing means the environment checks worked. Complete
> the independent investigation, interpretation and evidence below before submitting.

## Before you begin

Complete [setup](../../docs/setup.md) and Lab 1. No university service or hidden download is needed.
The runner checks its required state and reports missing prerequisites.

## Predict and run

Read the expected result below and predict what would fail with the wrong identity or missing input.
From the repository root in your Ubuntu terminal:

```bash
.venv/bin/python scripts/course.py lab 2
```

Expected: **Four synthetic tables and two worked governance entries. Reruns preserve existing data.** The final line is `LAB 2 COMPLETE`.
Rerunning is supported; existing raw and governance data are preserved.
Do not confuse a printed expectation with a passed assertion: the runner stops on unexpected outcomes.

## Hands-on investigation

Inspect the register:

```bash
.venv/bin/python scripts/query.py labs/practice/inspect_register.sql
```

Copy the insert example in
`labs/module_2/lab2_insert_templates.sql` to `.local/my-classification.sql`. Replace
the two worked entries with one new field from the synthetic raw dataset; provide
your own classification, rationale, owner, retention rule and AI-use restriction.
Execute `.venv/bin/python scripts/query.py .local/my-classification.sql`,
then inspect the register again. Rerun
Lab 2 and verify your row is preserved. Defend one plausible alternative classification.

For custom SQL, use the [query helper instructions](../practice/README.md#execute-your-own-sql-without-managing-passwords).

## Interpret and transfer

Classify one additional customer field and one order field in your submission: sensitivity, owner, rationale, retention and permitted AI use. Compare one ambiguous classification with a peer.

## Submit

Use the [submission template](../../submissions/template.md). Include the command,
relevant PASS lines or accessible text evidence, your interpretation, one limitation,
and your transfer-task response. A screenshot is optional; crop/redact identities
and never include configuration secrets. Submit privately through your course system;
independent learners keep their work locally. Execution success alone does not
complete the reasoning task.

Rubric: correct execution/evidence 25%; accurate interpretation 35%; transfer and
tradeoff reasoning 30%; clarity and evidence limitations 10%.

## Recovery

Use the [setup troubleshooting table](../../docs/setup.md). Read errors before retrying;
never delete tests or change authentication to make a result pass. There is no
automatic destructive reset. For an isolated new start use a new DB/user pair.

[Back to all labs](../../labs/README.md)

---

Author: [Isaac K. Nti](../../AUTHORS.md). [Citation and reuse terms](../../CITATION.md).
