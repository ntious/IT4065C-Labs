# Capstone: Governed Retail Data Architecture

Design, evaluate and defend a retail data system with explicit security,
lifecycle, governance and accountability decisions.

## Purpose and scope

You are an architecture team advising a fictional retailer with online and store
operations. Start with the [stakeholder interview](Business_Interview_Transcript.md).
Translate business needs into a model, workload strategy, governance controls and
an evidence-backed recommendation to a review board.

This professional simulation combines design with tested local lab behavior.
It does not require a production deployment, paid cloud account or real personal
data. Scalability, auditability and compliance are properties to investigate;
completion of the project does not certify them. Identify assumptions and missing
facts before drawing regulatory conclusions.

## Start here

1. Read the interview and record questions rather than inventing stakeholder facts.
2. Make a private copy of the [portfolio template](portfolio_template.md).
3. Complete the seven phases below, revising earlier decisions when evidence changes.
4. Use the course labs as a baseline and distinguish their results from your own implementation.

The default format is a small team for Phases 1–6 and individual reflection for
Phase 7. Independent learners can complete the same artifacts alone. Your instructor
sets team size, checkpoints, due dates and official grading in the LMS.

## Seven-phase journey

| Phase | Focus and required artifact | Course connection |
| --- | --- | --- |
| [1. Discovery](phase_1_discovery.md) | Requirements register: source, entity, relationship, uncertainty and follow-up question | SLO 1; Labs 1–2 |
| [2. Structural foundation](phase_2_structural_foundation.md) | Editable ERD with grain, keys, cardinality and justified revisions | SLO 4; Lab 3 |
| [3. Workload strategy](phase_3_workload_strategy.md) | OLTP/OLAP placement, lifecycle diagram and infrastructure comparison | SLOs 2–4; Labs 3–4; Lab 9 optional |
| [4. Governance overlay](phase_4_governance_overlay.md) | Owner, sensitivity, permitted use, retention, risk and control register | SLOs 1, 5–6; Labs 2, 5, 7 |
| [5. Integration and evidence](phase_5_integration_evidence.md) | Claim-to-evidence matrix, limitations, peer review and revision | SLOs 2, 4–6; Labs 3–7 |
| [6. Architecture defense](phase_6_architecture_defense.md) | Ten-slide recommendation and responses to review-board questions | SLOs 1–6 |
| [7. Individual reflection](phase_7_reflection.md) | One-page account of contribution, changed reasoning and next improvement | SLO 6 plus another selected outcome |

## AI governance across the lifecycle

Use the retailer support-prioritization scenario from [Lab 7](../labs/extensions/ai_governance.md)
as an explicit teaching extension to the interview, not a statement made by the
original stakeholder. A model-training project is not required.

Carry one decision through the phases: establish intended and prohibited use;
identify necessary data and proxy risks; separate evaluation access from operational
access; evaluate bias and mitigation tradeoffs; design transparency and appeal;
assign accountable reviewers; and define monitoring, rollback and retirement.
Use the [AI decision template](../labs/extensions/ai_decision_template.md), including
its purpose-change review. Rejecting or deferring deployment is a valid conclusion.

## Evidence and learning expectations

For every important claim record its requirement, decision, artifact, environment,
result and limitation. Use four labels consistently:

- **Demonstrated:** implemented and tested in the named environment.
- **Simulated:** illustrated through a model or fabricated scenario.
- **Proposed:** designed but not implemented.
- **Untested:** implemented or asserted without sufficient verification.

For example, a lab reader's denied UPDATE establishes that specific permission
boundary. It does not prove all capstone roles are secure. A dependency diagram
does not establish enforcement; a local snapshot does not establish multiple clusters.

The project assesses classification and curation, lifecycle reasoning, infrastructure
tradeoffs, modeling, access/monitoring and ethical AI governance. Assessment values
traceable evidence, reasoned alternatives, consistency and honest limits. Consult
[public performance descriptors](../docs/assessment_examples.md). Activity rubrics
support feedback; official capstone grade weights remain in the LMS.

## Final submission checklist

- Portfolio covering the seven phases and linked AI decision.
- Editable ERD plus a readable export or text description of relationships.
- Lifecycle diagram or equivalent structured text, including derived copies and retirement.
- Claim-to-evidence appendix with reproducible commands where applicable.
- [Peer review and response](../docs/peer_review.md), with accepted or deferred changes explained.
- Architecture defense and each student's individual reflection.

Submit privately using the instructor's approved route. Text evidence is accepted;
screenshots are optional and must be redacted. Do not publish credentials, student
identities, submissions or restricted platform materials. Cite external sources and
disclose assistance with an explanation of how results were independently checked.

## For instructors

Use the [adaptation guide](instructor_adaptation.md) to adjust industry context,
pace and tools while preserving outcomes. Alation University and the optional
Snowflake workshop are [supplements](../docs/platforms.md), not prerequisites for
this public capstone. Keep dates, institutional policies, private solutions and
student records in the course system.


---

Author: [Isaac K. Nti](../AUTHORS.md). [Citation and reuse terms](../CITATION.md).
