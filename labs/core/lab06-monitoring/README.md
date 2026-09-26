# Lab 6: Monitoring and evidence

**Outcomes:** SLO 5. **Estimated time:** 60–90 minutes; allow additional time for installation and support.  
**Environment:** your dedicated local course database. Synthetic data only.

## At a glance

| Before starting | Labs 1–5 |
| --- | --- |
| You will run | Run monitoring checks and inspect the generated JSON evidence report. |
| You will write | One live allow, one live denial, one explained simulated finding, and a three-part incident memo. |
| Done when | You can distinguish live observations from simulated findings and explain what the evidence supports, misses and requires next. |
| Safe stopping point | After a completed section; save your draft before closing the editor. |
| Submission format | Use the shared submission template and refer to the three-part memo rather than duplicating it. |

Follow the steps below in order. Keep configuration, generated logs and submissions private.
Return to the [required course path](../../../docs/course_checklist.md) when this lab is complete.

## Why this lab matters

An alert needs evidence and interpretation before it becomes an incident finding.
You will separate real query observations from simulated events, explain why one
rule fired and decide what further investigation or stronger evidence would be needed.

## Learning objectives

These instructor-developed objectives support the outcomes listed above. You will:

- Identify whether a finding comes from a live client or a synthetic fixture.
- Explain a detection rule, one false-positive scenario and one missed-incident scenario.
- Distinguish expected policy from observed execution evidence.
- Propose responsibility, access and protection for a stronger evidence source.

## Skills you will practice

Open and read a JSON report, distinguish live from simulated evidence, correlate
a fixture event with a detection rule, interpret SQLSTATE results and write a
concise incident memo.

## What you will produce

- Relevant Lab 6 technical PASS evidence.
- One live allowed-event excerpt and one live denied-event excerpt.
- One explained simulated incident finding.
- A short three-part incident memo covering evidence, detection limits and response.
- One limitation of the client-side evidence and one proposed stronger evidence source.

You do not need to paste the entire JSON report into your submission. Narrow excerpts
that support your explanation are sufficient.

## Terms you need for this lab

| Term | Meaning here |
| --- | --- |
| Event → alert → incident | An observed action → a signal for review → an occurrence assessed as requiring a response. Not every event becomes an alert or an incident. |
| False positive / false negative | An unnecessary alert / a missed condition that should have triggered an alert. An alert is not proof of misconduct. |
| Expected outcome / observed result | What the policy says should happen / what the client actually observed during execution. |
| Fixture | Prepared synthetic data used to produce a reproducible teaching result; it is not evidence that a real user performed the activity. |

Use the [glossary](../../../docs/glossary.md#tests-and-operational-evidence) for more detail; this is reference support, not another assignment.

## Concept

The access runner records what its client observed during live queries. Those records
are useful for demonstrating tested allow/deny outcomes, but a client can alter or
omit them. They are not an independent, tamper-resistant PostgreSQL audit trail.

The incident table is a separate, deterministic simulation. It deliberately includes
repeated denials, a role-switch event and an after-hours export. The SQL rules return
one row per rule/actor so one incident classification does not hide another.

Keep this distinction in mind throughout the lab:

```text
live_client_events
    = queries the course runner actually attempted using course roles

simulated_incidents
    = fabricated fixture events inserted specifically for this exercise
```

Do not describe `analyst_demo` or `steward_demo` as real users on your system.

An alert is a hypothesis requiring investigation. A legitimate shift worker may export
after hours; a single authorized query can still misuse data without triggering these
rules. UTC timestamps make this exercise reproducible but do not define every team’s
business hours. Distinguish event time, observation time and the clock/time-zone assumption.

An operational design also needs coverage, retention, access restrictions, integrity,
review ownership and an incident response process. A server audit extension or managed
platform log is a candidate evidence source, not something this client fixture has enabled.

A useful reasoning chain for this lab is:

```text
evidence source
→ observed event
→ detection rule
→ generated alert/finding
→ follow-up investigation
→ evidence limitation
→ stronger evidence
```

**Check your understanding:** For each finding, label its source, what it supports,
what it cannot establish and a follow-up investigation. Include one false-positive
scenario and one missed-incident scenario in your memo.

> **Completion:** Automation passing means the environment checks worked. Complete
> the investigation, interpretation and evidence below before submitting.

## Before you begin

Complete [Lab 5](../lab05-access-control/README.md); its reader allow/deny checks are
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
LAB 6 TECHNICAL CHECKS COMPLETE. Return to labs/core/lab06-monitoring/README.md for interpretation and deliverables.
```

The runner repeats Lab 5's access checks and writes a local report. It does not install
a server audit extension. Rerunning refreshes this report, including its live observation
timestamps, so save any excerpt you need in your private submission before another run.

The runner checks **nine** access outcomes. You will not see nine rows in the JSON report:
five query outcomes are recorded as live observations, while four additional escalation
checks are assertions used by the runner. You do not need to recreate all nine manually.

**Checkpoint:** save the Lab 6 command and the relevant PASS lines privately. Technical
completion does not replace the interpretation work below.

### A2. Open the report as readable text

```bash
.venv/bin/python -m json.tool .local/audit-report.json
```

This command prints the report; it changes no data. A JSON object uses named keys;
a list uses square brackets.

Read these three top-level sections:

| Key | Expected content | What to do with it |
| --- | --- | --- |
| `live_client_events` | Five recorded query outcomes: analyst sales allowed, analyst masked denied, analyst raw denied, steward masked allowed, steward raw denied | Choose one allow and one denial; record role, object, result and source. |
| `simulated_incidents` | Three deterministic fixture findings shown below | Interpret them as simulated findings, not actual misconduct by a real user. |
| `limitation` | Client observations are not an independent server audit trail | State what stronger evidence would be needed. |

For each `live_client_events` entry, use this key:

| Field | Meaning |
| --- | --- |
| `actor` | Authenticated role used for that observed query |
| `object` | View the client attempted to read |
| `expected_allowed` | What the Lab 5 access policy expected |
| `sqlstate` | What the database client actually observed: `00000` = success, `42501` = permission denied |
| `observed_at` | When the live client observation was recorded; your timestamp will differ |
| `evidence_type` | Identifies the row as a live client observation |

**Important:** `expected_allowed` is the expected policy outcome. It is **not** by
itself execution evidence. The `sqlstate` is the observed database result. Compare
the two when explaining whether the observed outcome matched the policy.

For example, an entry with:

```text
expected_allowed = false
sqlstate = 42501
```

shows that the policy expected denial and the database client actually observed a
permission-denied result.

The runner checks **nine** access outcomes but records **five** query observations
in this report. The four remaining escalation checks are assertions, not extra
rows you must find.

Your live timestamps will reflect when you ran Lab 6. The simulated fixture uses
fixed January 2026 timestamps so the rule results are reproducible. The two sections
therefore are not expected to share the same dates or times.

Expected simulated rows; positions are **rule, fictional actor, event count**:

```json
[["REPEATED_DENIAL", "analyst_demo", 3],
 ["ROLE_SWITCH", "analyst_demo", 1],
 ["AFTER_HOURS_EXPORT", "steward_demo", 1]]
```

Read the positions as:

| Position | Meaning |
| --- | --- |
| 1 | Detection rule name |
| 2 | Fictional fixture actor |
| 3 | Number of matching fixture events |

These rows are simulated findings. They do not prove that a real analyst or steward
performed those actions.

**A2 checkpoint:** keep one live allowed-event excerpt, one live denied-event excerpt
and the three simulated finding names available for A3 and Part B. You do not need
to copy the entire report.

### A3. Explain one rule using its fixture

Read the event rows in [the fixture](00_prepare_audit_evidence.sql) and the
matching condition in [the report query](01_generate_audit_report.sql).

Choose **one** simulated finding:

```text
REPEATED_DENIAL
ROLE_SWITCH
AFTER_HOURS_EXPORT
```

Then answer these three questions in two or three sentences total:

1. **Fixture evidence:** Which event row or rows match this finding?
2. **Rule condition:** What condition in `01_generate_audit_report.sql` caused it to match?
3. **Interpretation:** What does the flag justify investigating, and what does it not prove?

The supplied query checks:

- three or more denial events for the same actor;
- any role-switch event;
- exports before `07:00` UTC or at/after `19:00` UTC.

Use this pattern:

```text
fixture event(s) → detection condition → generated finding → investigation needed → limitation
```

A flag is a reason to investigate. It is not proof that data was stolen, that the
actor had malicious intent or that a control failed.

> **Part A complete:** you have the Lab 6 PASS evidence, one live allowed event,
> one live denied event, and one simulated finding you can explain from fixture
> event to detection rule.

## Part B: Write an incident memo

Write these three short sections in your private submission. No SQL edit is needed.
A few sentences per section are enough.

### 1. Evidence

Include:

- one live allowed query from `live_client_events`;
- one live denied query from `live_client_events`;
- the simulated finding you explained in A3;
- the source of each item;
- what each item supports;
- what each item does **not** establish.

For the live denial, explain whether the evidence shows an attempted access, a
successful authorization denial or a demonstrated control failure. Base your answer
on the observed SQLSTATE.

### 2. Detection limits

Include:

- one plausible legitimate activity that could trigger one of the supplied rules
  even though it should not be treated as malicious; and
- one harmful activity the supplied rules could miss.

Explain why each scenario demonstrates a limitation of the rules.

You do not need to prove that either hypothetical scenario actually occurred.
These are reasoning examples used to evaluate rule coverage.

### 3. Response and ownership

Include:

- one follow-up investigation you would perform;
- one stronger server-side or managed-platform evidence source;
- which role should be permitted to read that evidence;
- who should control its retention;
- who should be allowed to alter or delete it; and
- why `.local/audit-report.json` alone is insufficient.

Use this sequence if helpful:

```text
What would I investigate next?
        ↓
What stronger evidence would I collect?
        ↓
Who may read it?
        ↓
Who controls retention?
        ↓
Who can alter/delete it?
        ↓
Why is that stronger than the local client report?
```

Optional [Lab 12](../../optional/lab12-server-audit/README.md) implements a
server-logging experiment; it is not required to finish this memo.

> **Part B complete:** your memo distinguishes observed client evidence from
> simulated fixture findings, explains one detection limitation and proposes a
> stronger evidence and ownership model.

## Submit

Use the [submission template](../../../submissions/template.md). Include:

- the Lab 6 command and relevant A1 PASS lines;
- one selected live allowed-event excerpt;
- one selected live denied-event excerpt;
- one simulated finding and your A3 explanation;
- the three-part incident memo;
- one evidence limitation;
- recovery notes if an unexpected error occurred;
- assistance disclosure following current course rules.

### How the shared submission template maps to Lab 6

| Shared template section | What to do for Lab 6 |
| --- | --- |
| 1. Lab and execution evidence | Include the Lab 6 command, relevant A1 PASS lines and the selected live/simulated excerpts requested above. |
| 2. Prediction or initial expectation | Write `Not required for this activity` unless your instructor asked you to record one. |
| 3. Observed result and explanation | Briefly identify what the selected live evidence establishes, or refer to the **Evidence** section of your memo if it already says the same thing. |
| 4. Investigation and independent transfer | Include or attach the three-part incident memo from Part B. |
| 5. Evidence limitations and questions | Refer to the limits already stated in the memo; add an unresolved question only if one remains. Do not rewrite the memo. |
| 6. Assistance and verification | State AI/tool assistance and how you checked the result, or `None`, following course rules. |

Do **not** paste the full JSON report unless your instructor specifically asks for it.
Narrow excerpts are sufficient.

Text output is sufficient; cropped screenshots are optional. Keep complete local
logs, personal terminal details, identities beyond the relevant course-role evidence
and secrets private. Submit through the LMS or retain locally for independent study.
Do not repeat the same explanation in a second essay.

Rubric: correct execution/evidence 25%; accurate interpretation 35%; transfer and
tradeoff reasoning 30%; clarity and evidence limitations 10%.

## Recovery

Use the [setup troubleshooting table](../../../docs/setup.md). Read errors before retrying;
never delete tests or change authentication to make a result pass. There is no
automatic destructive reset. For an isolated new start use a new DB/user pair.

If `.local/audit-report.json` is missing, rerun Lab 6 and resolve any reported error
before continuing. If the JSON cannot be parsed, do not manually edit it to make the
expected findings appear; rerun the lab after correcting the underlying problem.

[Back to all labs](../../README.md)

---

Author: [Isaac K. Nti](../../../AUTHORS.md). [Citation and reuse terms](../../../CITATION.md).
