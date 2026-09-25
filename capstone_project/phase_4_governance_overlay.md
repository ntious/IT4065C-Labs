# Phase 4: Governance Overlay

## AI lifecycle checkpoint

Use the AI decision template to assign data stewardship, approval, evaluation,
monitoring, appeal and retirement roles. Define permitted/prohibited uses,
transparency to affected people, a harm-review trigger and a response owner.
Explain one mitigation tradeoff; mark these controls proposed unless tested.
Stakeholder statements are inputs to investigation, not legal authority. State
missing applicability facts and cite primary sources before asserting obligations.

## Translating Architecture into Accountability

---

## Overview

In Phases 1–3, you built a technical architecture.

In Phase 4, you overlay governance.

You are no longer designing how data flows.

You are designing how the organization survives risk.

For each table, assess potential:

- Legal exposure  
- Financial liability  
- Ethical responsibility  
- Reputational impact  

Integrate governance decisions into the architecture.

This phase converts structure into accountability.

---

## The Mindset: From Engineer to Risk Officer

Systems do not fail only when they crash.

They fail when:

- Customer data leaks  
- Compliance rules are ignored  
- Retention policies are unclear  
- Ownership is undefined  

This phase simulates a governance review board.

Start with stakeholder policies, then investigate their purpose, applicability
and limitations. Distinguish stated requirements from your proposed revisions.

Professional architects do not create arbitrary rules.

They translate stakeholder needs into proposed controls, with named owners
and a plan to verify implementation.

---

## Evidence Requirement: Transcript Grounding

Trace governance decisions to the interview or the explicit AI scenario extension.
Support legal applicability claims with primary sources and identify missing facts.

If asked:

> “Where did this policy come from?”

You must be able to reference:

- A specific statement  
- An implied operational requirement  
- A compliance constraint  
- A business objective  

A justified recommendation may challenge a stakeholder assertion. Preserve the
original statement and explain the evidence, uncertainty and approval needed
for your proposed change.

This phase measures your ability to translate messy business language into structured governance architecture.

---

## Your Task

Complete the **Phase_4_Governance** section of your portfolio.

Governance must be applied to the entities already defined in Phases 1–3.

If governance review requires a model change, revise the earlier artifacts and
record its reason. Apply controls to identified entities; label new structures as
proposed until implemented.

Governance overlays architecture.

It does not replace it.

---

## The Four Pillars of Governance

You must evaluate each entity using four pillars:

1. Ownership (Accountability)  
2. Handling classification, confidentiality impact and regulatory applicability
3. Retention  
4. Protection (Risk Consequence)  

---

## 1. Ownership (Accountability)

Every entity must have an accountable business owner.

Ownership answers:

- Who is responsible if this data is misused?
- Who approves retention decisions?
- Who responds to regulatory inquiries?

Undefined ownership equals unmanaged risk.

Ownership must be defensible using transcript evidence.

---

## 2. Handling Classification and Impact

Use the same teaching categories as [Lab 2](../labs/core/lab02-classification/README.md)
and the [glossary](../docs/glossary.md#governance-and-access):

| Handling classification | Meaning in this scenario |
| --- | --- |
| Public | Approved for public disclosure |
| Internal | Intended for organizational use, not approved for public release |
| Sensitive | Controlled access because disclosure or misuse could cause harm |
| Restricted | Especially limited access under the scenario's highest handling restrictions |

In the existing **Phase_4_Governance** section, record these three distinctions:

- **Handling classification:** Public / Internal / Sensitive / Restricted, with rationale.
- **Confidentiality impact:** Low / Medium / High, explaining the consequences of disclosure.
- **Regulatory applicability:** the supported conclusion or the facts and sources still needed.

There is no automatic conversion between these fields. Restricted does not prove
that a regulation applies, and low confidentiality impact does not mean no risk.
Public data can still have significant integrity or availability requirements.
Use the interview's impact estimates as stakeholder inputs, not a classification
answer key. Explain departures from those estimates where justified.

For example, a proposed record can be **Restricted**, have **High** confidentiality
impact, and have **regulatory applicability undetermined** pending a jurisdiction
and purpose review. Record these within your existing governance entry; no
separate classification report is required.

---

## 3. Retention Strategy

For each entity, distinguish:

- **Retention:** the proposed duration or review/deletion trigger, purpose,
  claimed authority, holds and unresolved exceptions.
- **Storage tier:** operational/hot, analytical/cold or both. A tier is not
  a retention period.

Retention must align with:

- Business needs  
- Compliance constraints  
- Analytical value  
- Legal mandates  

The interview supplies proposed policy inputs, not verified legal periods.
Record unresolved authority and recommend review where necessary, including for
indefinite retention. Do not invent a universal legal schedule.

---

## 4. Governance Risk Statement (Protection)

For each entity, write a precise 1–2 sentence risk consequence statement:

> If this table leaked publicly, what plausible legal, financial, or ethical consequences could follow, and
> what facts would determine them?

Weak example:

“This would be bad.”

Strong example:

“Exposure of customer emails could enable targeted phishing and create privacy harm.
Legal obligations and consequences depend on jurisdiction, applicable rules and the
facts of the incident; these require further assessment.”

Executives act on consequences, not abstractions.

Your risk statement must:

- Be retail-specific  
- Reflect realistic consequences  
- Explain the relationship between handling classification and impact
- Match the business context  

If your risk statement could apply to any company in any industry, it is insufficient.

Governance is contextual.

---

## Internal Consistency Requirement

Your governance decisions must align across pillars.

For example:

- A handling classification and impact estimate should each have a clear rationale;
  explain their relationship instead of applying an automatic mapping.
- Long-term retention of regulated data must be justified.
- Ownership assignments must reflect operational responsibility.

Resolve inconsistencies by reviewing the source requirement and documenting the decision.

---

## Evaluation Criteria

Phase 4 will be evaluated on:

### Transcript-Grounded Reasoning
Are decisions traceable to business context?

### Realistic Ownership Mapping
Do owners reflect operational accountability?

### Classification and Impact Reasoning
Are handling category, impact and regulatory applicability distinguished and justified?

### Risk Precision
Are consequence statements specific and defensible?

### Cross-Phase Consistency
Do governance decisions align with your model and workload strategy?

Strong governance architecture reads like a defensible policy framework.

Weak governance reads like generic compliance filler.

---

## Why This Phase Matters

Many data breaches occur not because systems were poorly coded —  
but because governance was poorly defined.

Common governance failures:

- No retention enforcement  
- No assigned owner  
- Underestimated sensitivity  
- Vague risk acknowledgment  

Governance protects:

- Customers  
- Brand reputation  
- Legal compliance  
- Executive credibility  

This phase develops traceable governance decisions for review.

---

## Final Perspective

Phases 1–3 asked:

> Can the system function?

Phase 4 asks:

> Can the organization defend it?

Architecture without governance is fragile.

Governance transforms structure into accountability.

This is where technical design becomes institutional responsibility.

---

Author: [Isaac K. Nti](../AUTHORS.md). [Citation and reuse terms](../CITATION.md).
