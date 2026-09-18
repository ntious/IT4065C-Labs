# Lab 9: Infrastructure snapshot experiment

**Outcomes:** SLO 3. **Estimated time:** 45–60 minutes; allow additional time for installation and support.
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
.venv/bin/python scripts/course.py lab 9
```

Expected: **Stale analytical snapshot detected and refreshed to total 30.** The final line is `LAB 9 COMPLETE`.
Rerunning is supported; existing raw and governance data are preserved.
Do not confuse a printed expectation with a passed assertion: the runner stops on unexpected outcomes.

## Hands-on investigation

Read `labs/extensions/infrastructure.sql`; identify the exact point when the
snapshot becomes stale. Copy it locally and insert a third operational record;
update your predicted count and total assertions, then execute. Compare on-premises,
cloud and hybrid options for freshness, failure domains, identity, connectivity,
cost and operational ownership. This experiment tests snapshot logic; it does not
measure network replication, availability, RPO or RTO.

For custom SQL, use the [query helper instructions](../practice/README.md#execute-your-own-sql-without-managing-passwords).

## Interpret and transfer

Compare on-premises, cloud and hybrid placement using an architecture decision record. Explain why this single-instance exercise cannot establish replication, failover or multi-cluster administration.

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
