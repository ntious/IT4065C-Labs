# Lab 7: AI ethics and governance

**Outcomes:** SLO 6. **Planning time:** two sessions of 45–75 minutes for a first attempt; this is a planning estimate, not a measured novice completion time.  
**Environment:** your dedicated local course database. Synthetic data only.

## At a glance

| Before starting | Labs 1–6 |
| --- | --- |
| You will run | Calculate the supplied prediction metrics and inspect the synthetic evaluation records. |
| You will write | One worksheet containing metric interpretation, an initial governance decision and a required change review. |
| Done when | The technical evidence, one checked calculation and all three worksheet sections are complete. |
| Safe stopping point | After a completed section; save your draft before closing the editor. |
| Submission format | Use the shared template plus the completed decision worksheet; refer to worksheet sections instead of duplicating them. |

Follow the steps below in order. Keep configuration, generated logs and submissions private.
Return to the [required course path](../../../docs/course_checklist.md) when this lab is complete.

## Why this lab matters

Improving one AI error rate can worsen another. A model or policy can look better on
one metric while creating a different cost for another group or stakeholder.

In this lab, you inspect a small synthetic evaluation fixture, check one error-rate
calculation yourself, then make and revise a governance decision. The second decision
changes the proposed purpose, so you must decide whether the earlier evidence is still
sufficient rather than assume that one evaluation supports every future use.

## Learning objectives

These instructor-developed objectives support the outcomes listed above. You will:

- Calculate and interpret group error rates with the correct denominators.
- Explain bias, transparency and accountability throughout the data lifecycle.
- Distinguish metric improvement from a complete fairness conclusion.
- Defend and revise a deployment decision using NIST AI RMF 1.0.

## Skills you will practice

Read metric evidence, interpret a small CSV fixture, check arithmetic, assess
tradeoffs, distinguish evidence from uncertainty, assign accountable roles and
write a short change review.

> **Completion:** Automation passing means the technical calculation completed.
> The governance decision, lifecycle reasoning and change review remain required.

## Terms you need for this lab

| Term | Meaning here |
| --- | --- |
| Prediction / label | The supplied selection decision / the reference eligibility outcome. This lab evaluates existing predictions; it does not train AI. |
| Selected | For this exercise, a prediction value of `1` means the record is selected for support priority; `0` means it is not selected. |
| False negative | A record whose reference outcome is eligible (`eligible = 1`) but whose prediction is not selected (`0`). |
| False positive | A record whose reference outcome is ineligible (`eligible = 0`) but whose prediction is selected (`1`). |
| Label bias / representativeness | Reference outcomes may contain systematic errors; a small fixture may not represent the intended population. |
| Proxy / audit group | A field indirectly associated with another characteristic / a grouping used to compare results. Auditing groups does not mean using them as prediction inputs. |
| Metric parity | Two groups having the same value on one metric. Parity on one metric does not establish overall fairness. |

Groups `A` and `B` are **synthetic audit groups**. Do not infer a real demographic
attribute such as race, sex, disability or another protected characteristic from
these labels.

Use the [glossary](../../../docs/glossary.md#ai-decisions) for more detail; this is
reference support, not another assignment.

## Your route and deliverables

- [ ] **Part A:** run the metric calculation, read the report and verify one group-B false-negative-rate calculation.
- [ ] **Worksheet section 1:** interpret the metrics and their limitations.
- [ ] **Worksheet section 2:** complete the lifecycle record and make an initial governance decision.
- [ ] **Worksheet section 3:** complete the required changed-purpose review.
- [ ] **Submission:** include narrow technical evidence plus the completed worksheet; do not write a duplicate essay.

You submit this one worksheet plus the relevant execution evidence. Read the
[fictional library decision](../../../docs/ai_decision_example.md) if you need an
example of the expected depth. It demonstrates structure and scope; it is not a
retail answer key.

## Before you begin

Complete [Labs 2–6](../../README.md) for governance, lineage, access and monitoring
context. Use your existing Ubuntu environment; setup need not be repeated.

If needed, begin with [Student start here](../../../STUDENT_START_HERE.md).
No AI programming experience, external account or model training is required.
All commands below run from the repository root.

## Part A: Follow the metric example

### A1. Calculate the supplied metrics

Run:

```bash
.venv/bin/python scripts/course.py lab 7
```

Expected:

```text
PASS: connection, dedicated database, schemas and non-superuser builder.
PASS: AI metrics calculated. Complete the governance decision; metric parity is not proof of fairness.
LAB 7 TECHNICAL CHECKS COMPLETE. Return to labs/core/lab07-ai-governance/README.md for interpretation and deliverables.
```

This command reads the supplied synthetic prediction file, calculates the four
group/policy metric sets and writes:

```text
.local/ai-evaluation.json
```

It does **not** train a model or make a new prediction.

**Checkpoint:** retain the command and the two relevant PASS/completion lines
privately. Technical completion does not complete the written task.

### A2. Read the report

Run:

```bash
.venv/bin/python -m json.tool .local/ai-evaluation.json
```

This command only prints the saved JSON report in a readable format.

The report is nested in this order:

```text
policy
→ audit group
→ metric
```

Use this key:

| JSON field | Meaning |
| --- | --- |
| `baseline` | The original supplied prediction policy |
| `mitigated` | The supplied alternative prediction policy |
| `A`, `B` | Synthetic audit groups |
| `n` | Number of records in the group |
| `selection_rate` | Selected records divided by all records in that group |
| `false_negative_rate` | Eligible records not selected divided by eligible records |
| `false_positive_rate` | Ineligible records selected divided by ineligible records |

Expected values for the unchanged synthetic fixture:

| Policy | Group | Records | Selection rate | False-negative rate | False-positive rate |
| --- | --- | ---: | ---: | ---: | ---: |
| Baseline | A | 8 | 0.500 | 0.25 | 0.25 |
| Baseline | B | 8 | 0.125 | 0.75 | 0.00 |
| Mitigated | A | 8 | 0.500 | 0.25 | 0.25 |
| Mitigated | B | 8 | 0.625 | 0.25 | 0.50 |

Rates are proportions: `0.25` means 25%.

#### Read the denominators correctly

Selection rate uses **all records in the group**.

False-negative rate uses only **eligible records**:

```text
eligible records not selected
-----------------------------
all eligible records
```

False-positive rate uses only **ineligible records**:

```text
ineligible records selected
---------------------------
all ineligible records
```

In this fixture, each group contains:

```text
8 total records
4 eligible records
4 ineligible records
```

Therefore, one record changes an FNR or FPR by:

```text
1 / 4 = 0.25
```

This is one reason the fixture should be treated as a small teaching example, not
strong population evidence.

#### What to notice before moving on

- Group A's reported metrics are unchanged between baseline and mitigated. That is expected for this fixture.
- Group B's false-negative rate decreases from `0.75` to `0.25`.
- Group B's false-positive rate increases from `0.00` to `0.50`.
- After mitigation, groups A and B both have an FNR of `0.25`, but that is parity on **one metric only**.
- Equal FNR does not prove fairness: FPR still differs, the sample is tiny, reference labels may have limitations and other harms or affected groups are not measured.

Do not describe the mitigated policy simply as “better.” Explain the tradeoff.

### A3. Check one calculation against the source records

Open [the synthetic CSV](../../../data/ai_predictions.csv) on GitHub or locally:

```bash
nano data/ai_predictions.csv
```

Read only. Leave Nano with **Ctrl+X** without saving changes.

#### How to read the CSV

Each row is one synthetic evaluation record.

| Column | Meaning |
| --- | --- |
| `id` | Synthetic record identifier |
| `group` | Synthetic audit group `A` or `B` |
| `eligible` | `1` = reference outcome says eligible for support priority; `0` = ineligible |
| `baseline` | `1` = baseline selected the record; `0` = baseline did not |
| `mitigated` | `1` = mitigated policy selected the record; `0` = mitigated policy did not |

The `eligible` column is the **reference outcome used for this exercise**. The
fixture does not establish how those labels were originally produced or whether
they are unbiased. You are not expected to prove label bias. Treat label quality
as a possible limitation and state what further evidence would be needed.

#### Worked example: baseline group A

For baseline group A, four records are eligible. One of those four eligible records
was not selected:

```text
FNR = 1 / 4 = 0.25
```

#### Your calculation: baseline group B

Calculate baseline group B's FNR yourself.

Record these five items in your worksheet notes:

```text
Eligible group-B records: ___
Eligible group-B records missed by baseline: ___
FNR calculation: ___ / ___ = ___
Does the result match A2? ___
What could this error mean in the support-priority scenario? ___
```

For the final question, reason from the scenario:

```text
eligible + not selected = false negative
ineligible + selected   = false positive
```

Explain a plausible cost of the error. You do not need to change the data or write Python.

> **Part A complete:** you have the Lab 7 execution evidence, the expected metric
> comparison and one calculation you verified directly from the CSV.

## Part B: Make and revise a governance decision

### B1. Create your private writing worksheet

Run these commands one at a time:

```bash
mkdir -p .local
```

```bash
cp -i labs/core/lab07-ai-governance/ai_decision_template.md .local/lab7-decision.md
```

If asked to overwrite on a repeat attempt, answer **n** to preserve your answers.

Then open the worksheet:

```bash
nano .local/lab7-decision.md
```

It contains three deliverables, not code:

1. metric interpretation;
2. initial governance decision and lifecycle record;
3. required changed-purpose review.

Use short answers. Bullets are acceptable. You may also use a word processor if
that is easier than editing in Nano.

The worksheet uses **vertically labeled lifecycle sections** rather than a wide
Markdown table so that it is easier to edit in a terminal.

Put your Part A calculation and interpretation in section 1. Complete the lifecycle
and decision record in section 2. Complete the change-review amendment in section 3.

Save in Nano with **Ctrl+O**, **Enter**, then **Ctrl+X**.

### B2. Complete the initial decision

Use the metrics from Part A as evidence. Your reasoning should address:

```text
metric evidence
→ affected stakeholders
→ competing error costs
→ evidence limitations
→ proposed safeguards
→ accountable roles
→ decision
→ review trigger
```

Discuss:

- the mitigation's increased false-positive rate;
- the small sample;
- possible label-quality or representativeness limits;
- whose interests or harms may not be captured by the measured rates;
- transparency and appeal arrangements;
- accountable roles;
- which safeguards are observed versus merely proposed.

Label safeguards you have not implemented as **proposed**.

#### NIST AI RMF scope for this lab

Use NIST AI RMF **1.0** only at the level requested by the worksheet:

- **Govern** — who is responsible and accountable?
- **Map** — what is the context, affected population and potential harm?
- **Measure** — what evidence exists, and what uncertainty remains?
- **Manage** — what action, mitigation, monitoring or review follows?

You do **not** need to summarize the entire NIST AI RMF or Playbook. Four short
labeled bullets applying these functions to your decision are sufficient. The linked
resources are reference material, not an additional reading assignment.

**Safe stopping point:** after section 2, save your worksheet. Resume by reopening
the same file; you do not need to recalculate unchanged metrics.

### B3. Complete the required change review

The proposed use now changes:

```text
original purpose: support prioritization
changed purpose:  restricting refunds
```

The incoming population is also different, and no new performance or harm
measurements are supplied.

Do not assume that the earlier support-priority evaluation automatically supports
the new refund-restriction purpose.

Use this sequence:

```text
What changed?
→ Which earlier evidence no longer answers the new question?
→ What new evidence is required?
→ Who must review and approve the change?
→ What happens while the evidence is missing?
→ How should notice and appeal change?
→ What happens to old predictions and retained copies?
```

Write the amendment requested in worksheet section 3. Do not invent performance
results. Both the initial decision and the amendment are required; this is a writing
task, not another script to execute.

## Submit

Optional: use the [local report checker](../../../docs/report_checker.md) after
writing your submission. Replace the path below with your actual private report
filename. Include both files if your worksheet is separate; omit the second path
if it is embedded in your report. Warnings are suggestions, not grades or new
submission requirements.

```bash
.venv/bin/python scripts/report_checks/lab07.py .local/lab7-report.md .local/lab7-decision.md
```

Use the [submission template](../../../submissions/template.md), but do **not**
duplicate the completed worksheet in a second essay.

Your Lab 7 submission should contain:

- the Lab 7 command and relevant A1 PASS/completion lines;
- the relevant A2 metric evidence, either as a narrow excerpt or a reference to the printed values;
- your A3 baseline-group-B FNR calculation;
- the completed private `lab7-decision.md` worksheet, including sections 1–3;
- recovery notes if an unexpected error occurred;
- your assistance disclosure and how you verified your work.

### How the shared submission template maps to Lab 7

| Shared template section | What to do for Lab 7 |
| --- | --- |
| 1. Lab and execution evidence | Include the Lab 7 command, relevant PASS lines and narrow A2 metric evidence. |
| 2. Prediction or initial expectation | Write `Not required for this activity` unless you actually recorded a prediction requested by your instructor. |
| 3. Observed result and explanation | Include your A3 calculation or refer to worksheet section 1 if it already contains the same explanation. |
| 4. Investigation and independent transfer | Attach or refer to the completed `lab7-decision.md` worksheet, sections 1–3. |
| 5. Evidence limitations and questions | Refer to limitations already stated in the worksheet; do not rewrite them unless something remains unresolved. |
| 6. Assistance and verification | State AI/tool assistance and how you checked the result, or `None`, following course rules. |

Text evidence is sufficient. Screenshots are optional. Never include `.env`,
credentials, tokens, full connection strings or personal terminal details.

Submit privately through the LMS; independent learners keep the same record locally.

## Assessment

Assessment uses only the [AI decision rubric](ai_decision_template.md):

- lifecycle: 20%;
- bias analysis / limitations: 25%;
- mitigation tradeoffs: 20%;
- transparency: 15%;
- accountability / framework application: 20%.

The general core-lab rubric does not apply.

The suggested word ranges in the worksheet help scope the work. They are not a
requirement to fill space. Concise answers that address the requested evidence and
reasoning are sufficient.

## Recovery

Use the [setup troubleshooting table](../../../docs/setup.md). Read errors before retrying;
never delete tests or change authentication to make a result pass. There is no
automatic destructive reset. For an isolated new start use a new DB/user pair.

If `.local/ai-evaluation.json` is missing, rerun Lab 7 and resolve any reported
error before continuing. Do not manually edit the JSON to force the expected values.

If you accidentally modify `data/ai_predictions.csv`, stop and restore the repository
version before using it as evidence. Do not change fixture values merely to reproduce
an expected metric.

[Back to all labs](../../README.md)

---

Author: [Isaac K. Nti](../../../AUTHORS.md). [Citation and reuse terms](../../../CITATION.md).
