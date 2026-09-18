# Instructor session guide

Use alongside the module learning map and each lab's own guide. Plan approximately
10 minutes for prediction, 25 for a guided run, 20 for independent work and 10 for
review. These are planning estimates; the first pilot should record actual times.
Longer setup and capstone workshops need separate sessions.

Before each class, rehearse on the tested course revision and identify the expected
result. Provide a text alternative to any visual demonstration. Keep solution and
calibration notes in an access-controlled private location.

| Session | Prepare / demonstrate | Ask / independent checkpoint | Misconception and recovery |
| --- | --- | --- | --- |
| Foundations / Lab 1 | Fresh setup; locate root; run check | Explain OS user versus database role; complete bridge self-check | Connection is not universal authorization. Resolve setup failures before advancing. |
| Lab 2 | Inspect register; show one existing classification | Student inserts a different field with owner, retention and use rationale | Classification is contextual. Inspect the inserted row and preserve student additions on rerun. |
| Lab 3 | Trace order to items to mart; inspect one test | Student explains 139.95 total and authors a test | Join grain can duplicate totals. Inspect failed test rows; do not delete the test to pass. |
| Lab 4 | Trace a model dependency | Student traces downstream copies and proposes retirement actions | Lineage is not enforcement. Use a text dependency path if the visualization is unavailable. |
| Infrastructure discussion | Compare ownership and failure domains | Student justifies one deployment choice across six criteria | One-instance snapshots are not clusters. Lab 9 is optional; the comparison is required. |
| Lab 5 | Use separate authenticated readers | Predict one denial, then explain the actual result | A denial may be successful protection. Do not weaken authentication or use administrator credentials. |
| Lab 6 | Separate live observations from fixture incidents | Trace one flag and propose a missed-event scenario | Client evidence is not server audit. Verify source labels before interpreting alerts. |
| Lab 7 | Recalculate one group metric from the fixture | Defend a decision and respond to the change-review prompt | Metric parity alone is not fairness. Check sample sizes and competing harms. |
| Capstone workshop | Trace one requirement to evidence | Peer review, revise, then defend one uncertain claim | Baseline labs do not prove another deployment. Use the four evidence labels. |

## Feedback and calibration

Before marking, independently assess two fictional or authorized anonymized examples
using the public descriptors. Discuss disagreements and record criterion-specific
expectations privately. Do not infer understanding from a green runner or attractive
presentation. Ask students to explain one changed condition verbally or in text.

After each session, record common difficulties and time spent without student names.
Use that record to improve instructions. Students may need different forms of evidence;
assess the same concept rather than requiring screenshots.

## Optional workshops

Labs 8–11 extend the main work. Inspect their prerequisites and deliverables before
assigning them. External platform exploration follows the platform guide and LMS
instructions. Server audit, TLS and multi-instance exercises are not yet supported
runnable activities; do not improvise them on shared university infrastructure.

---

Author: [Isaac K. Nti](../AUTHORS.md).
