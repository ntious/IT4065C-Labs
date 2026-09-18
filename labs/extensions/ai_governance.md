# Lab 7: AI ethics and governance

**Outcomes:** SLO 6. **Estimated time:** 60–90 minutes; allow additional time for installation and support.
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
.venv/bin/python scripts/course.py lab 7
```

Expected: **Baseline and mitigation group metrics in .local/ai-evaluation.json.** The final line is `LAB 7 COMPLETE`.
Rerunning is supported; existing raw and governance data are preserved.
Do not confuse a printed expectation with a passed assertion: the runner stops on unexpected outcomes.

## Hands-on investigation

Open `.local/ai-evaluation.json` and `data/ai_predictions.csv`. Recalculate one
group's false-negative rate by hand; compare both policies. Complete
`labs/extensions/ai_decision_template.md`, including a decision, owner, review
trigger and appeal route. Explain whose interests a metric can fail to capture.
Use NIST AI RMF 1.0 as the named framework version for this exercise.

For custom SQL, use the [query helper instructions](../practice/README.md#execute-your-own-sql-without-managing-passwords).

## Interpret and transfer

Complete the [AI governance decision template](ai_decision_template.md). Explain the mitigation’s false-positive tradeoff, tiny sample size, label bias and why metric parity alone does not prove fairness.

## Submit

Use the [submission template](../../submissions/template.md). Include the command,
relevant PASS lines or accessible text evidence, your interpretation, one limitation,
and your transfer-task response. A screenshot is optional; crop/redact identities
and never include configuration secrets. Submit privately through your course system;
independent learners keep their work locally. Execution success alone does not
complete the reasoning task.

Assessment uses only the [AI decision rubric](ai_decision_template.md): lifecycle 20%,
bias analysis/limitations 25%, mitigation tradeoffs 20%, transparency 15%, and
accountability/framework application 20%. The general core-lab rubric does not apply.

## Recovery

Use the [setup troubleshooting table](../../docs/setup.md). Read errors before retrying;
never delete tests or change authentication to make a result pass. There is no
automatic destructive reset. For an isolated new start use a new DB/user pair.

[Back to all labs](../../labs/README.md)

---

Author: [Isaac K. Nti](../../AUTHORS.md). [Citation and reuse terms](../../CITATION.md).
