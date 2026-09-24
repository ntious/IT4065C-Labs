# Lab 6: Monitoring and evidence

**Outcomes:** SLO 5. **Estimated time:** 60–90 minutes; allow additional time for installation and support.
**Environment:** your dedicated local course database. Synthetic data only.


## Why this lab matters

An alert needs evidence and interpretation before it becomes an incident finding. You will separate real query observations from simulated events and decide what further investigation is needed.

## Learning objectives

These instructor-developed objectives support the outcomes listed above. You will:

- Identify whether a finding comes from a live client or a synthetic fixture.
- Explain a detection rule, one false positive and one missed-incident scenario.
- Propose responsibility and protection for a stronger evidence source.

## Skills you will practice

Open a JSON report, correlate rule and event, and write a concise incident memo.

## Terms you need for this lab

| Term | Meaning here |
| --- | --- |
| Event → alert → incident | An observed action → a signal for review → an occurrence assessed as requiring a response. Not every event becomes an alert or an incident. |
| False positive / false negative | An unnecessary alert / a missed condition that should have triggered an alert. An alert is not proof of misconduct. |

Use the [glossary](../../../docs/glossary.md#tests-and-operational-evidence) for more detail; this is reference support, not another assignment.

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

Complete [Lab 5](../../module_5/lab5/README.md); its reader allow/deny checks are
reused here.
Run each command separately from the repository root in Ubuntu. Keep the same
configured environment; do not repeat setup. If you need an environment, use
[Student start here](../../../STUDENT_START_HERE.md). No prior SQL qualification
is assumed. Copy commands from code blocks; write explanations in your private
submission, not in the terminal.

## Part A: Generate and read the evidence

### A1. Run the monitoring exercise

```bash
.venv/bin/python scripts/course.py lab 6
```

Expected:

```text
PASS: connection, dedicated database, schemas and non-superuser builder.
PASS: synthetic seed present (existing data preserved).
PASS: nine access checks using separate authenticated connections, including escalation denials.
PASS: live permission evidence + deterministic simulated incident analysis. See .local/audit-report.json.
LAB 6 COMPLETE: technical checks passed; review interpretation and deliverables in labs/README.md.
```

The runner repeats Lab 5's checks and writes a local report. It does not install
a server audit extension. Rerunning refreshes this report; save any excerpt you
need in your private submission before another run.

### A2. Open the report as readable text

```bash
.venv/bin/python -m json.tool .local/audit-report.json
```

This command prints the report; it changes no data. A JSON object uses named
keys; a list uses square brackets. Read these three sections:

| Key | Expected content | What to do with it |
| --- | --- | --- |
| `live_client_events` | Five recorded query outcomes: analyst sales allowed, analyst masked denied, analyst raw denied, steward masked allowed, steward raw denied | Choose one allow and one denial; record role, action and result. Time and configured role names vary. |
| `simulated_incidents` | Three rows shown below | Interpret these as fixture findings, not actual misconduct by a user. |
| `limitation` | Client observations are not an independent server audit trail | State what additional evidence would strengthen your conclusion. |

The runner checks **nine** access outcomes but records **five** query observations
in this report. The four remaining escalation checks are assertions, not extra
rows you must find. `00000` denotes success; `42501` denotes permission denied.

Expected simulated rows; positions are **rule, fictional actor, event count**:

```json
[["REPEATED_DENIAL", "analyst_demo", 3],
 ["ROLE_SWITCH", "analyst_demo", 1],
 ["AFTER_HOURS_EXPORT", "steward_demo", 1]]
```

### A3. Explain one rule using its fixture

Read the event rows in [the fixture](00_prepare_audit_evidence.sql) and the
matching condition in [the report query](01_generate_audit_report.sql).
Choose **one** row above and write two or three sentences explaining why it
was flagged. The query checks three or more denials, role-switch events, and
exports before 07:00 or at/after 19:00 UTC respectively. A flag is a reason to
investigate, not proof that data was stolen or a control failed.

## Part B: Write an incident memo

Write these three short sections in your private submission. No SQL edit is needed.

1. **Evidence:** include the one live allow, one live denial, and the simulated
   rule explained in A3. Label their sources. Explain whether the denied query
   represents attempted access or a demonstrated control failure.
2. **Detection limits:** give one legitimate activity that could trigger a rule
   (false positive), and one harmful activity these rules could miss. Explain why.
3. **Response and ownership:** propose one follow-up check, a server-side evidence
   source, the role allowed to read it, and who controls retention and alteration.
   Explain why this client report alone is insufficient.

A few sentences per section are enough. Optional [Lab 12](../../extensions/server_audit.md)
implements a server-logging experiment; it is not required to finish this memo.

## Submit

Use the [submission template](../../../submissions/template.md). Include A1's
completion lines, the selected report excerpts and the three-part memo. These
are your interpretation and transfer responses; no second essay is required.
Use text or cropped screenshots. Keep complete local logs, identities and secrets
private, and submit through the LMS. Independent learners retain their work locally.

Rubric: correct execution/evidence 25%; accurate interpretation 35%; transfer and
tradeoff reasoning 30%; clarity and evidence limitations 10%.

## Recovery

Use the [setup troubleshooting table](../../../docs/setup.md). Read errors before retrying;
never delete tests or change authentication to make a result pass. There is no
automatic destructive reset. For an isolated new start use a new DB/user pair.

[Back to all labs](../../../labs/README.md)

---

Author: [Isaac K. Nti](../../../AUTHORS.md). [Citation and reuse terms](../../../CITATION.md).
