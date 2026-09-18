# Instructor adoption runbook

Use the [session guide](teaching_sessions.md), [module map](module_learning_map.md),
[assessment examples](assessment_examples.md) and [adoption checklist](adoption_checklist.md).

## Before teaching

Use a fresh individual Ubuntu environment. Run setup, all labs twice, and the
verification command in [validation](validation.md). Test a non-default database,
username and schema. Do not distribute your .env or a VM image containing passwords.
No live university credentials or Canvas source ZIP is required.

Suggested pacing: setup/prerequisite bridge; classification; modeling/quality;
lineage; infrastructure discussion; security; monitoring; retention; AI governance;
capstone workshops and defense. Fit this into your actual calendar rather than
copying the old syllabus's overlapping 18 weeks. Keep the official schedule in LMS.

For each session: 10-minute concept/prediction, 25-minute guided run, 20-minute
interpretation/transfer, 10-minute pair review and questions. Times are adaptable.
Diagnose shell/SQL basics early. Allow accessible text evidence instead of screenshots.

## External learning supplement

Use the [Alation University platform guide](platforms.md) when assigning the Data
Intelligence Project. Specify the selected activity, access route, reflection and
local alternative in the LMS. Keep enrollment details and training records private.
Use the optional [Snowflake workshop supplement](platforms.md#snowflake-university-supplement-module-4)
for the Module 4 cloud/on-premises comparison. Set workload and any submission
requirements in the LMS. Airflow activities may be selected when useful; no
external account is required for the local lab sequence.

## Expected technical results

Four customers, four products, four orders, five items; completed revenue 139.95.
Lab 3 must build ten models and at least thirty tests. Lab 5 requires nine
access assertions. Lab 6 separates five saved live client observations from a fixed
synthetic incident fixture. Lab 7 exposes a mitigation tradeoff. Labs 8–9 roll back
their temporary-table experiments, leaving the course records unchanged.

## Common misconceptions to challenge

- A DAG is not an authorization boundary.
- A masked identifier is not necessarily anonymous.
- A passed test only establishes its specific assertion.
- A denied query can be evidence of successful protection.
- Client observations are not an independent server audit trail.
- Two tables or snapshots on one server do not demonstrate multiple clusters.
- One fairness metric does not establish ethical acceptability.

Reference solutions and private grading calibration can live in a separate private
repository. A folder name does not make public content private. Use the public
rubric and assess evidence limitations explicitly. Rehearse recovery without
destroying student databases. Keep administrator-only server logging and real
multi-instance deployment as supervised extensions until independently verified.

---

Author: [Isaac K. Nti](../AUTHORS.md). [Citation and reuse terms](../CITATION.md).
