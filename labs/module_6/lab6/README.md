# Lab 6: Monitoring and evidence

**Outcomes:** SLO 5. **Estimated time:** 60–90 minutes; allow additional time for installation and support.
**Environment:** your dedicated local course database. Synthetic data only.

## Concept

The access runner records what its client observed during live queries. Those records
are useful for demonstrating tested allow/deny outcomes, but a client can alter or
omit them. They are not an independent, tamper-resistant PostgreSQL audit trail.

The incident table is a separate, deterministic simulation. It deliberately includes
repeated denials, a role-switch event and an after-hours export. The SQL rules return
one row per rule/actor so one incident classification does not hide another.

An alert is a hypothesis requiring investigation. A legitimate shift worker may export
after hours; a single authorized query can still misuse data without triggering these
rules. UTC timestamps make this exercise reproducible but do not define every team’s
business hours. Distinguish event time, observation time and the clock/time-zone assumption.

An operational design also needs coverage, retention, access restrictions, integrity,
review ownership and an incident response process. A server audit extension or managed
platform log is a candidate evidence source, not something this client fixture has enabled.

**Check your understanding:** For each finding, label its source, what it supports,
what it cannot establish and a follow-up investigation. Include one false positive
and one missed-incident scenario in your memo.

> **Completion:** Automation passing means the environment checks worked. Complete
> the independent investigation, interpretation and evidence below before submitting.

## Before you begin

Complete [setup](../../../docs/setup.md) and Lab 1. Complete the previous core labs for context.
The runner checks its required state and reports missing prerequisites.

## Predict and run

Read the expected result below and predict what would fail with the wrong identity or missing input.
From the repository root in your Ubuntu terminal:

```bash
.venv/bin/python scripts/course.py lab 6
```

Expected: **Fresh live client observations plus three kinds of simulated incidents in .local/audit-report.json.** The final line is `LAB 6 COMPLETE`.
Rerunning is supported; existing raw and governance data are preserved.
Do not confuse a printed expectation with a passed assertion: the runner stops on unexpected outcomes.

## Hands-on investigation

Read `.local/audit-report.json` locally. For each flag, trace the rule in
`labs/module_6/lab6/01_generate_audit_report.sql` and the corresponding synthetic
fixture. Write one false-positive explanation and one possible missed incident.
Distinguish what the live client observed from what the fixture merely simulates.
Propose a server-side evidence source and who should control access to it.

For custom SQL, use the [query helper instructions](../../practice/README.md#execute-your-own-sql-without-managing-passwords).

## Interpret and transfer

Write an incident memo distinguishing observed evidence, scenario assumptions, attempted violations and control failures. Explain why client observations are not tamper-proof server audit logs.

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
