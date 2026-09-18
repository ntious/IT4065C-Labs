# Phase 5: Integration and evidence

Evaluate which parts of your proposed architecture have supporting evidence.
A successful course lab demonstrates behavior in its own environment; it does not
validate a different capstone deployment automatically.

## Required deliverables

Complete Phase_5_Evaluation and Phase_6_Evidence in the
[portfolio](portfolio_template.md). These are portfolio section identifiers;
Phase_6_Evidence is an appendix, not the architecture defense presentation.

For each claim record: requirement, design decision, evidence source, environment,
command or observation, result, limitation and next verification step. Label it:

- **Demonstrated:** implemented and tested within the stated environment.
- **Simulated:** behavior illustrated with a model or fabricated scenario.
- **Proposed:** design or control not yet implemented.
- **Untested:** implementation or claim lacks sufficient verification.

Use accessible text output, SQL, a small table, a textual lineage path or an annotated
diagram. Screenshots are optional. Redact identities and secrets; submit privately.

## Evidence categories

| Category | Relevant baseline | What to explain |
| --- | --- | --- |
| Lifecycle | Labs 3–4 models and lineage | Dependencies and transformation behavior; a DAG alone does not prevent bypass. Identify additional enforcement needed. |
| Access | Lab 5 authenticated allow/deny checks | Actor, action, object and result; masking limits and untested roles. Generic lab results do not prove your own deployment. |
| Monitoring | Lab 6 client observations and simulated incidents | Label each source; discuss false positives, missed events and the absence of independent server audit collection. |
| AI governance | Lab 7 decision and lifecycle artifacts | Harm tradeoffs, transparency, accountable owner, review trigger and retirement implications. |

Example: "This DAG records dependencies. A separate permission check is needed to
show that a reporting identity cannot bypass the intended access boundary."

## Review and assessment

Complete [peer review and revision](../docs/peer_review.md) before the defense.
Assessment considers accurate evidence classification, reasoning, traceability,
clarity and recognition of limits using the [assessment descriptors](../docs/assessment_examples.md).
An honest proposed control with a sound verification plan is preferable to claiming
that an untested control already works. Keep reference solutions and grading private.

---

Author: [Isaac K. Nti](../AUTHORS.md).
