# Lab 8: Retention and deletion

**Outcomes:** SLOs 2,5. **Estimated time:** 45–60 minutes; allow additional time for installation and support.
**Environment:** your dedicated local course database. Synthetic data only.

> **Completion:** Automation passing means the environment checks worked. Complete
> the independent investigation, interpretation and evidence below before submitting.

## Before you begin

Complete [setup](../../docs/setup.md) and Lab 1. No university service or hidden download is needed.
The runner checks its required state and reports missing prerequisites.

## Predict and run

Read the expected result below and predict what would fail with the wrong identity or missing input.
From the repository root in your Ubuntu terminal:

```bash
.venv/bin/python scripts/course.py lab 8
```

Expected: **Expired unheld records removed, held record retained, deletion ledger reapplied after simulated restore.** The final line is `LAB 8 COMPLETE`.
Rerunning is supported; existing raw and governance data are preserved.
Do not confuse a printed expectation with a passed assertion: the runner stops on unexpected outcomes.

## Hands-on investigation

Read `labs/extensions/retention.sql` and predict the surviving IDs after each delete.
Copy it to `.local/retention-experiment.sql`, add an expired record under legal hold,
and add an assertion that the hold survives deletion and simulated restore. Keep
the final ROLLBACK; execute using `scripts/query.py`. Explain how a separately
protected deletion ledger and real backup policy would differ from temporary tables.

For custom SQL, use the [query helper instructions](../practice/README.md#execute-your-own-sql-without-managing-passwords).

## Interpret and transfer

Draw all data copies and identify what the single-transaction simulation omits: external backups, legal review, audit retention and model-training copies.

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
