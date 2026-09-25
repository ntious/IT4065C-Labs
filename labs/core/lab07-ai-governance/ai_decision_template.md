# AI governance decision worksheet

Scenario: a retailer proposes AI-assisted support prioritization using the supplied
synthetic examples. Complete these **three deliverables once**. Use short answers;
rows and bullets are welcome. The suggested lengths help scope the work, not impose
extra grading rules. Mark controls you have not implemented as **proposed**.

## 1. Metric interpretation

Attach the baseline/mitigation values from Lab 7 and your group B false-negative
calculation. In about 100–150 words, compare selection, false-positive and
false-negative rates. Include group sizes, denominators, the cost of each error,
tiny-sample uncertainty, possible label bias and why parity does not prove fairness.
You can refer to the printed metric table instead of copying it twice.

Answer: [Write here]

## 2. Initial governance decision

### Dataset and lifecycle record

Complete each row with one or two sentences or concise bullets. This table is the
dataset card and lifecycle record together; do not produce a second dataset card.
Link to earlier Lab 2/4/5/6 artifacts where they answer a cell, adding any new AI-use
implication. If a fact is not established, say what evidence is needed.

| Lifecycle stage | Your decision, accountable role and evidence or gap |
| --- | --- |
| Collection and curation | [Origin and purpose; representativeness and label origin; sensitive/proxy attributes; justification for collecting group audit data; inclusion/exclusion choices] |
| Storage and access | [Who may read audit attributes versus model features; retention/holds; owner and downstream copies] |
| Preparation and evaluation | [Bias concern; evaluation owner; reference your metrics from section 1 rather than repeating them] |
| Use and disclosure | [Intended and prohibited uses; brief affected-person notice explaining purpose and limitations; human explanation/appeal route and owner] |
| Monitoring and change | [Monitoring and incident-response roles; a proposed review threshold/trigger; who approves a change and who can roll it back] |
| Retirement | [Accountable role; treatment of predictions, exports, backups and model copies; deletion/retraining evidence still needed] |

### Decision and framework rationale

In about 150–200 words, choose **approve, conditionally approve, defer or reject**.
Name one affected stakeholder and an alternative mitigation, justify the tradeoff,
and identify the approval role and next review date or trigger. Not deploying is
valid. Assign fictional roles rather than real people's names.

Map your reasoning to NIST AI RMF **1.0**: **Govern** (responsibility), **Map**
(context and harm), **Measure** (evidence and uncertainty), and **Manage**
(action and review). Four short labeled bullets can refer to the lifecycle rows;
do not rewrite them. The framework is voluntary guidance, not a certification.

Answer: [Write here]

## 3. Required change review

Now the retailer proposes using support-priority predictions to restrict refunds.
The incoming population differs from the small evaluation fixture. No new
performance or harm measurements are available.

Write an amendment of about 150–200 words covering:

- Changed purpose/stakeholders and which earlier evidence no longer supports use.
- Specific new evidence and accountable review/response roles.
- Revised notice and appeal route; whether to pause, restrict or continue use.
- What happens to old predictions and retained copies.

Refer to unchanged parts of section 2 rather than repeating them. Do not invent
new measurements. This is part of the same rubric, not an additional lab.

Answer: [Write here]

## Self-check and assessment

- All three deliverables are complete; no answer placeholders remain.
- Facts, proposed safeguards and unresolved evidence are distinguished.
- Lifecycle ownership, competing harms, transparency and accountability are explicit.
- I can explain why the changed purpose requires review.

Resources: [NIST AI RMF](https://www.nist.gov/itl/ai-risk-management-framework),
[Playbook](https://www.nist.gov/itl/ai-risk-management-framework/nist-ai-rmf-playbook).
Rubric unchanged: lifecycle 20%; bias analysis/limitations 25%; mitigation tradeoffs
20%; transparency 15%; accountability/framework application 20%.

---

Template author: Isaac K. Nti. Authorship and reuse information is in AUTHORS.md
and CITATION.md at the repository root. Responses belong to the learner.
