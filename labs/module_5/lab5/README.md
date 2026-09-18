# Lab 5: Access control and masking

**Outcomes:** SLO 5. **Estimated time:** 60–90 minutes; allow additional time for installation and support.
**Environment:** your dedicated local course database. Synthetic data only.

## Concept

Authentication establishes the login. Authorization determines which operations it
can perform. The lab opens separate connections for the analyst and steward; successful
builder queries are not proof that those reader identities have the same access.

The builder owns the raw data and controlled views. Readers receive schema usage and
SELECT on specified views, but no raw schema access or membership in the builder role.
The analyst sees sales aggregates; the steward can additionally use masked customer
fields. A 42501 response confirms an authorization denial. A wrong-password error or
missing-table error would not establish the intended access boundary.

The views use their owner’s access to expose a deliberately restricted projection.
Granting access to an owner-controlled view therefore requires reviewing its entire
query. Adding a raw column later could expose it to every existing reader of that view.
The owner is trusted; the design does not protect raw data from its own owner.

Masking is data minimization, not proof of anonymity. Domains, suffixes, identifiers
and joinable patterns can still reveal information. Unkeyed hashes of predictable
identifiers are not a safe substitute for an access policy.

**Check your understanding:** Predict all three commands in the practice guide before
running them. Explain both the role grant and the view projection behind each result.

> **Completion:** Automation passing means the environment checks worked. Complete
> the independent investigation, interpretation and evidence below before submitting.

## Before you begin

Complete [setup](../../../docs/setup.md) and Lab 1. Complete the previous core labs for context.
The runner checks its required state and reports missing prerequisites.

## Predict and run

Read the expected result below and predict what would fail with the wrong identity or missing input.
From the repository root in your Ubuntu terminal:

```bash
.venv/bin/python scripts/course.py lab 5
```

Expected: **Nine real allow/deny checks using separate authenticated sessions, including denied escalation.** The final line is `LAB 5 COMPLETE`.
Rerunning is supported; existing raw and governance data are preserved.
Do not confuse a printed expectation with a passed assertion: the runner stops on unexpected outcomes.

## Hands-on investigation

```bash
.venv/bin/python scripts/query.py labs/practice/read_sales.sql --role analyst
.venv/bin/python scripts/query.py labs/practice/read_masked.sql --role analyst
.venv/bin/python scripts/query.py labs/practice/read_masked.sql --role steward
```

Predict each result first. The middle command must exit unsuccessfully with 42501;
that is successful protection. These are different authenticated connections, not
an administrator pretending to be a reader. Explain what the masked values still
reveal. Propose a narrower view for a different legitimate business purpose.

For custom SQL, use the [query helper instructions](../../practice/README.md#execute-your-own-sql-without-managing-passwords).

## Interpret and transfer

Predict each outcome before running. Explain partial masking versus anonymization. Why must an expected denial be SQLSTATE 42501 rather than any error?

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
