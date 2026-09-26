# AI governance decision worksheet

Scenario: a retailer proposes AI-assisted support prioritization using the supplied
synthetic examples.

Complete these **three deliverables once**:

1. metric interpretation;
2. initial governance decision and lifecycle record;
3. required changed-purpose review.

Use short answers. Bullets are welcome. Suggested word ranges help scope the work;
they are not extra grading rules. Mark any safeguard or control that has **not**
actually been implemented as **proposed**.

You do not need to produce a separate dataset card or repeat the same explanation
elsewhere in your submission.

## Before writing

Use the Lab 7 evidence you already generated:

- `.local/ai-evaluation.json`;
- your baseline group-B false-negative-rate calculation;
- the supplied `data/ai_predictions.csv`;
- relevant earlier Lab 2/4/5/6 evidence where it directly supports a lifecycle claim.

Keep this reasoning chain in mind:

```text
metric evidence
→ affected stakeholders
→ competing harms
→ evidence limitations
→ proposed safeguards
→ accountable roles
→ decision
→ review trigger
```

Groups `A` and `B` are synthetic audit groups. Do not infer a real demographic
attribute from those labels.

## 1. Metric interpretation

### Evidence to include

Record or refer to:

- baseline and mitigated selection rates;
- baseline and mitigated false-negative rates;
- baseline and mitigated false-positive rates;
- group size (`n = 8` for each group in the supplied fixture);
- your own baseline group-B FNR calculation.

Your checked calculation:

```text
Eligible group-B records: ___
Eligible group-B records missed by baseline: ___
FNR calculation: ___ / ___ = ___
Matches the Lab 7 report? ___
```

### Interpretation prompts

In about **100–150 words**, address these points without turning them into separate essays:

- What changed from baseline to mitigated for group B?
- What stayed unchanged for group A?
- Which error rate improved, and which worsened?
- What is the denominator for FNR? What is the denominator for FPR?
- What could a false negative mean in the support-priority scenario?
- What could a false positive mean in the support-priority scenario?
- Why does the small fixture limit confidence in the rates?
- Why is label quality a possible uncertainty rather than a proven bias finding?
- Why does equal FNR after mitigation not prove overall fairness?

You may refer to the Lab 7 metric table instead of copying every number twice.

**Answer:**

[Write here]

## 2. Initial governance decision

### 2A. Dataset and lifecycle record

Complete each labeled section with one or two sentences or concise bullets.

If an earlier lab already establishes a fact, refer to that evidence rather than
rewriting it. Add any new AI-use implication that matters here.

If a fact is not established, say what evidence would be needed.

### Collection and curation

**Address:**

- Where did the synthetic evaluation data come from, and what is its purpose here?
- What do you know or not know about representativeness?
- What do you know or not know about the origin and quality of the `eligible` labels?
- Are any sensitive, proxy or audit-group attributes involved?
- Why might audit-group data be collected for evaluation even if it should not be used as a prediction feature?
- What important inclusion/exclusion choices remain unknown?

**Decision / role / evidence or gap:**

[Write here]

### Storage and access

**Address:**

- Who should be allowed to read audit attributes?
- Who should be allowed to use model/prediction features?
- What retention or legal-hold assumptions apply?
- Who owns the data decision?
- Which downstream copies, exports or retained predictions may exist?

**Decision / role / evidence or gap:**

[Write here]

### Preparation and evaluation

**Address:**

- What bias, error-rate or representativeness concern is visible in the supplied evidence?
- Who owns evaluation and validation?
- What do the metrics support?
- What do they not establish?
- Refer to section 1 rather than repeating every number.

**Decision / role / evidence or gap:**

[Write here]

### Use and disclosure

**Address:**

- What is the intended use?
- What uses should be prohibited or require a new review?
- What should an affected person be told about the purpose and limitations?
- What human explanation, correction or appeal route should exist?
- Who owns that process?

**Decision / role / evidence or gap:**

[Write here]

### Monitoring and change

**Address:**

- Who monitors outcomes and incidents?
- What event or threshold should trigger review?
- Who can approve a material change in purpose, population or model behavior?
- Who can pause or roll back the use?

Label any threshold or safeguard that has not been implemented as **proposed**.

**Decision / role / evidence or gap:**

[Write here]

### Retirement

**Address:**

- Who owns retirement?
- What should happen to saved predictions, exports, backups and model copies?
- What deletion, retraining or downstream-removal evidence would still be needed?
- What must not be assumed merely because the active use stops?

**Decision / role / evidence or gap:**

[Write here]

### 2B. Decision and framework rationale

Choose one:

```text
approve
conditionally approve
defer
reject
```

Not deploying is a valid decision.

In about **150–200 words**, include:

- your decision and the evidence supporting it;
- one affected stakeholder;
- one alternative mitigation;
- the tradeoff created by your preferred approach;
- the fictional role responsible for approval;
- a next review date or a clear review trigger.

Assign fictional roles rather than real people's names.

Then map your decision to NIST AI RMF **1.0** using four short bullets:

- **Govern:** who is responsible and accountable?
- **Map:** what is the context, affected population and potential harm?
- **Measure:** what evidence exists, and what uncertainty remains?
- **Manage:** what action, mitigation, monitoring or review follows?

You do **not** need to summarize the entire NIST AI RMF or Playbook. Apply these
four functions to your decision. The framework is voluntary guidance, not a certification.

**Decision and rationale:**

[Write here]

**NIST AI RMF mapping:**

- **Govern:** [Write here]
- **Map:** [Write here]
- **Measure:** [Write here]
- **Manage:** [Write here]

## 3. Required change review

The retailer now proposes using the support-priority predictions to **restrict refunds**.

Two important conditions have changed:

- the purpose is different; and
- the incoming population differs from the small evaluation fixture.

No new performance or harm measurements are available.

Do not assume that evidence gathered for support prioritization automatically supports
refund restriction. Do not invent new measurements.

Use this sequence:

```text
What changed?
→ Which earlier evidence no longer answers the new question?
→ What new evidence is required?
→ Who must review and approve the change?
→ What happens while evidence is missing?
→ How should notice and appeal change?
→ What happens to old predictions and retained copies?
```

Write an amendment of about **150–200 words** covering:

- the changed purpose and stakeholders;
- which earlier evidence is no longer sufficient for the proposed use;
- specific new evidence that would be needed;
- accountable review and response roles;
- revised notice and appeal arrangements;
- whether to pause, restrict or continue the proposed use while evidence is missing;
- what happens to old predictions and retained copies.

Refer to unchanged parts of section 2 rather than repeating them.

**Amendment:**

[Write here]

## Self-check and assessment

Before submitting, confirm:

- [ ] Section 1 includes the checked group-B FNR calculation.
- [ ] I compared both error-rate tradeoffs rather than calling one policy simply “better.”
- [ ] I identified small-sample and label-quality uncertainty without claiming unsupported facts.
- [ ] All six lifecycle sections contain a decision, role and evidence or gap.
- [ ] Proposed safeguards are labeled **proposed**.
- [ ] My decision identifies an affected stakeholder, tradeoff, approval role and review trigger.
- [ ] My NIST mapping uses Govern, Map, Measure and Manage without rewriting the lifecycle sections.
- [ ] The change review explains why the new purpose requires fresh review.
- [ ] I did not invent new performance measurements.
- [ ] No `[Write here]` placeholders remain.

## Resources and rubric

Resources:

- [NIST AI RMF](https://www.nist.gov/itl/ai-risk-management-framework)
- [NIST AI RMF Playbook](https://www.nist.gov/itl/ai-risk-management-framework/nist-ai-rmf-playbook)

You do not need to summarize these resources. Use them to support the four requested
framework functions.

Rubric:

- lifecycle: 20%;
- bias analysis / limitations: 25%;
- mitigation tradeoffs: 20%;
- transparency: 15%;
- accountability / framework application: 20%.

---

Template author: Isaac K. Nti. Authorship and reuse information is in AUTHORS.md
and CITATION.md at the repository root. Responses belong to the learner.
