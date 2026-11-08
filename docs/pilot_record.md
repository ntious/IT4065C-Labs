# Learner and instructor pilot record

Use a private copy for each volunteer. This is a blank protocol, not a completed
pilot. Do not publish names, device identifiers, credentials, grades or raw logs.

Keep completed copies under ignored `local-docs/pilots/` or `.local/`; keep this
public blank protocol unchanged. Use one copy per participant. No completion or
accessibility certification is implied by the existence of this form.

## Common record

- Participant role: novice learner or replacement instructor; no public identity.
- Date, exact commit, Ubuntu/Python/PostgreSQL versions and permitted access route.
- Starting preparation and accessibility needs, recorded only with permission.
- Start/end times, active work versus download/wait time, outcome and assistance.
- Each obstacle: page/step, expected action, observation, intervention, time lost,
  severity, proposed correction and retest result.

## Novice route

Follow Student Start Here and Labs 1–3 without an initial live walkthrough. Record
time to setup, first successful check and independent explanation. Ask the learner
to find the submission requirements, distinguish a PASS from completion, and show
which account controls which boundary. Provide help when needed; record it rather
than withholding support to preserve a "clean" result.

## Replacement-instructor route

Prepare one session from Instructor Start Here, diagnose a safe prepared failure,
and assess the fictional capstone paragraph using the rubric. Record preparation
time, missing context, discrepancies in interpretation and assessment rationale.

## Private observation worksheet

Copy these fields into a private document for each pilot. Use a participant code,
not a name. Participation and recording should follow institutional requirements;
collect only information needed to improve the materials.

- Pilot type and exact repository revision:
- Selected lab/session and starting experience:
- Environment and access route (no device identifiers):
- Task attempted and page/step:
- What the participant expected:
- What they did or observed:
- Assistance requested and supplied:
- What they explained independently afterward:
- Outcome: completed independently / completed with help / stopped:
- Finding: blocking / workaround available / improvement:
- Proposed correction, owner and retest result:

For the novice, record whether they can find the next step and submission route,
and distinguish technical success from the explanation they must submit. For the
replacement instructor, record whether they can prepare a session, explain an
expected denial, recover from a safe prepared failure, and justify feedback using
the existing rubric. Use a disposable environment for failure rehearsal; do not
introduce failures into a participant's only working checkout.

## Workload record

Use one copy of this table per lab or session, with one row per activity category.
Minutes are approximate, not a speed assessment. Record active work under only
one category. Put download or other waiting time in the matching row’s Wait
minutes column; exclude it from active minutes. Record breaks separately below
the table. Leave unknown values blank rather than entering zero.

| Activity / phase | Active minutes | Wait minutes | Help or obstacle |
| --- | --- | --- | --- |
| Setup (record separately from lab work) | | | |
| Guided practical work | | | |
| Independent investigation or edits | | | |
| Reading and interpretation | | | |
| Writing and packaging evidence | | | |
| Troubleshooting and recovery | | | |

Lab/session identifier: __________. Break minutes (excluded from work totals): __________.
For an instructor pilot, add rows for session preparation, failure rehearsal and
submission calibration as needed; do not also count those minutes in another row.

Record unfinished work and assistance alongside totals. Keep lab time estimates
as planning estimates until learner observations support a revision. When updating
them, report the number of participants, their preparation, completion status and
range of observed times; do not generalize a small pilot to every learner. Keep
individual records private and publish only appropriately anonymized summaries.

## Focused accessibility worksheet

Complete privately alongside both routes. Record browser/assistive-tool versions
only as needed, with permission; do not publish disability or participant details.

| Task | Check | Result / barrier / equivalent route / retest |
| --- | --- | --- |
| Student start and installation | Keyboard navigation, visible focus, descriptive link names, heading order and zoom/reflow | |
| Labs 1–3 commands | Copy commands without prompts; distinguish terminal from written work; interpret text output | |
| Lab 3 models and tables | Explain grain from text; navigate table headers and code with a screen reader | |
| Lab 4 lineage | Reach and understand dependencies with keyboard/assistive tools; compare source/model text if graph interaction is inaccessible | |
| Lab 5 access evidence | Understand allow/deny without color or screenshot; use supplied textual results | |
| Submission and feedback | Produce equivalent text/diagram evidence without mandatory screenshots; find private submission route | |

For each row record pass / barrier / not tested, tools and task, assistance,
severity, owner, correction and retest. A text alternative must support the same
learning and assessment criterion; merely omitting the activity is not equivalent.
Review screenshot alt text, heading hierarchy and link names in changed pages.
Do not describe a route as tested when only its HTML or source was inspected.

## Exit and follow-up

Classify each finding as blocking, workaround available or improvement. Retest
blocking corrections with the participant when possible. Summarize only anonymous,
consented observations in release notes. A documented workaround must be usable
by a new learner. Two successful pilots provide initial usability evidence, not
proof that every learner or institution will have the same experience.

Author: [Isaac K. Nti](../AUTHORS.md).
