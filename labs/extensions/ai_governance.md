# Lab 7: AI ethics and governance

**Outcomes:** SLO 6. **Planning time:** two sessions of 45–75 minutes for a first attempt; this is a planning estimate, not a measured novice completion time.
**Environment:** your dedicated local course database. Synthetic data only.


## Why this lab matters

Improving one AI error rate can worsen another. You will calculate a small example, discuss who is affected, and make a governance decision that includes oversight and a changed purpose.

## Learning objectives

These instructor-developed objectives support the outcomes listed above. You will:

- Calculate and interpret group error rates with the correct denominators.
- Explain bias, transparency and accountability throughout the data lifecycle.
- Defend and revise a deployment decision using NIST AI RMF 1.0.

## Skills you will practice

Read metric evidence, check arithmetic, assess tradeoffs, assign accountable roles, and write a change review.

> **Completion:** Automation passing means the environment checks worked. Complete
> the independent investigation, interpretation and evidence below before submitting.

## Terms you need for this lab

| Term | Meaning here |
| --- | --- |
| Prediction / label | The supplied selection decision / the reference eligibility outcome. This lab evaluates existing predictions; it does not train AI. |
| Label bias / representativeness | Reference outcomes may contain systematic errors; a small fixture may not represent the intended population. |
| Proxy / audit group | A field indirectly associated with another characteristic / a grouping used to compare results. Auditing groups does not mean using them as prediction inputs. |

Use the [glossary](../../docs/glossary.md#ai-decisions) for more detail; this is reference support, not another assignment.

## Your route and deliverables

- [ ] Part A: metrics and one calculation, recorded in worksheet section 1.
- [ ] Part B: initial decision and lifecycle record, in worksheet section 2.
- [ ] Change review: amendment, in worksheet section 3.

You submit this one worksheet plus the relevant execution evidence. You do not
need separate essays for overlapping prompts. Read the
[fictional library decision](../../docs/ai_decision_example.md) if you need an
example of the expected depth; it is not a retail answer key.

## Before you begin

Complete [Labs 2–6](../README.md) for governance, lineage, access and monitoring
context. Use your existing Ubuntu environment; setup need not be repeated.
If needed, begin with [Student start here](../../STUDENT_START_HERE.md).
No AI programming experience, external account or model training is required.
All commands below run from the repository root.

## Part A: Follow the metric example

### A1. Calculate the supplied metrics

```bash
.venv/bin/python scripts/course.py lab 7
```

Expected:

```text
PASS: connection, dedicated database, schemas and non-superuser builder.
PASS: AI metrics calculated. Complete the governance decision; metric parity is not proof of fairness.
LAB 7 COMPLETE: technical checks passed; review interpretation and deliverables in labs/README.md.
```

### A2. Read the report

```bash
.venv/bin/python -m json.tool .local/ai-evaluation.json
```

Expected values for the unchanged synthetic fixture:

| Policy | Group | Records | Selection rate | False-negative rate | False-positive rate |
| --- | --- | --- | --- | --- | --- |
| Baseline | A | 8 | 0.500 | 0.25 | 0.25 |
| Baseline | B | 8 | 0.125 | 0.75 | 0.00 |
| Mitigated | A | 8 | 0.500 | 0.25 | 0.25 |
| Mitigated | B | 8 | 0.625 | 0.25 | 0.50 |

Selection rate is selected records divided by all records in the group.
A false negative is an eligible record not selected; divide false negatives by
**eligible records**, not all eight records. A false positive is an ineligible
record selected; divide by **ineligible records**. Here each group has four
eligible and four ineligible records. Rates are proportions: 0.25 means 25%.

### A3. Check one calculation

Open [the synthetic CSV](../../data/ai_predictions.csv) on GitHub or locally:

```bash
nano data/ai_predictions.csv
```

Read only; leave with **Ctrl+X** without saving changes. For baseline group A,
one of four eligible records was not selected, so FNR = 1 / 4 = 0.25.
Now calculate **baseline group B's FNR** yourself. Write the numerator,
denominator and result in your private response, and compare it with A2.
Explain the cost of the error in a support-priority decision. You do not need
to change the data or write Python.

## Part B: Make and revise a governance decision

### B1. Create your private writing worksheet

Run these commands one at a time:

```bash
mkdir -p .local
```

```bash
cp -i labs/extensions/ai_decision_template.md .local/lab7-decision.md
```

If asked to overwrite on a repeat attempt, answer **n** to preserve your answers.
Then open the worksheet:

```bash
nano .local/lab7-decision.md
```

It contains three deliverables, not code. Put Part A evidence and interpretation
in section 1, complete the combined lifecycle/decision record in section 2, then
write the change-review amendment in section 3. You may use a word processor instead. Use the metrics from
Part A to support your reasoning; do not submit the unchanged template.
Save in Nano with **Ctrl+O**, **Enter**, then **Ctrl+X**.

### B2. Complete the initial decision and change review

Use the [NIST AI RMF resources](ai_decision_template.md) for **version 1.0**.
Explain the mitigation's increased false-positive rate, small sample, possible
label bias, whose interests are missed, transparency/appeal arrangements and
accountable roles. Equal false-negative rates do not establish fairness.
Label safeguards you have not implemented as **proposed**.

**Safe stopping point:** after section 2, save your worksheet. Resume by reopening
that same file; you do not need to recalculate unchanged metrics.

Then complete the template's **Required change review**: the proposed use changes
from support priority to restricting refunds, with a changed population and no
new measurements. Write a short amendment explaining what evidence is missing,
who must review the change, and whether to pause, restrict or continue the use.
Do not invent performance results. Both the initial decision and amendment are
required; this is a writing task, not another script to execute.

## Submit

Use the [submission template](../../submissions/template.md). Attach the relevant
A1/A2 evidence, your A3 calculation and the completed private decision worksheet,
including the change review. Avoid repeating the worksheet in a second essay.
Text evidence is sufficient. Never include credentials or personal terminal details.
Submit privately through the LMS; independent learners keep the same record locally.

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
