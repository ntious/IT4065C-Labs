# Syllabus alignment and remaining work

Reviewed against the supplied Spring 2025 syllabus and the subsequently added AI
outcome. This is a public academic crosswalk, not a replacement institutional syllabus.
Lab numbering is a teaching sequence; it does not equal the syllabus's module numbering.

## Evidence by outcome and module

| Syllabus area | Current evidence | Remaining limitation |
|---|---|---|
| SLO 1 / Module 1: types, sources, curation and metadata | Lab 2 register, metadata notebook, optional Lab 10 CSV/JSON/text catalog and curation | Alation University Data Intelligence Project supplements local work; assigned product activities require authorized access |
| SLO 2 / Module 2: creation-to-deletion lifecycle and ETL | Lab 4 lineage/lifecycle decisions, optional Lab 8 deletion-ledger simulation, optional Labs 10–11 ingestion/publication | Real backup restore and scheduled enterprise orchestration remain extensions |
| SLO 3 / Module 4: cloud/on-premises/hybrid and multiple clusters | Lab 9 snapshot experiment and infrastructure comparison; capstone architecture decision | No actual second instance, link interruption, lag measurement or failover |
| SLO 4 / Module 3: lifecycle/modeling tools and ERDs | dbt models/tests, capstone editable ERD, Lab 3 student-authored test, optional Lab 11 model/KPI | Independent student model implementation needs instructor assessment; optional ERD is not auto-graded |
| SLO 5 / Modules 5–6: security and monitoring | Separate-login allow/deny tests, masking, live client observations and simulated incident rules | No independent server audit capture, verified remote TLS exercise or storage encryption demonstration |
| Module 7: integrated governance | Register, controls, quality tests and capstone evidence classifications | Alation University supplements the concepts; product-specific evidence follows LMS assignments, and formal regulatory analysis remains limited |
| Module 8 / project: integration, analytics, visualization and peer review | Seven-phase capstone, defense/reflection; optional Lab 11 executable pipeline and reconciled report | A team's own architecture still needs its own implementation evidence and peer review |
| Added SLO 6: AI ethics and governance across the lifecycle | Required Lab 7: bias rates, mitigation tradeoff, dataset card, transparency, appeal, accountable owners, NIST AI RMF decision | Small supplied predictions illustrate governance reasoning, not production fairness or model-training proficiency |

The course-level SLO 3 says **discuss**, but Module 4 also promises hands-on
multi-cluster administration. The comparison activity supports the discussion outcome;
it does not fulfill that stronger practical module claim. Likewise, client-side
permission observations do not fully substitute for the syllabus's server monitoring.

## Teaching support added

The foundations bridge, module learning map, assessment descriptors, peer review,
session guide and adoption checklist support independent learning and instructor
handoff. Required lifecycle/infrastructure discussions no longer depend on taking
optional labs. Lab 7 includes a purpose-change review. These curriculum additions
do not close the practical audit, multi-instance or encryption gaps below.

## Keep the revised core manageable

Labs 1–7 are the revised core. Labs 8–11 are optional enrichment. If an instructor
uses the unchanged official syllabus's stronger practical promises, the corresponding
missing activities must become required or the substitution must be approved through
the appropriate course process. Calling them optional does not erase the gap.

The new AI outcome is assessed through discussion, a decision memo and defense.
Another required machine-learning lab is unnecessary. Use this cross-lab evidence chain:
classification and permitted AI use (Lab 2); proxy/audit-field separation (Lab 3);
training/evaluation/retirement copies (Lab 4); restricted audit access (Lab 5);
drift and incident ownership (Lab 6); accountable deployment decision (Lab 7).
Where a link is a proposed design rather than an executed control, label it that way.

## Prioritized optional work still to develop

| Priority | Proposed extension | Acceptance evidence before claiming completion |
|---|---|---|
| 1 | Real PostgreSQL server audit collection | Isolated administrator-managed server; capture actual allowed/denied queries; correlate login/time/object/result; document log access, omissions and retention |
| 2 | Two-instance data transfer and recovery | Distinct PostgreSQL instances; scoped identities; interrupt transfer; measure staleness/recovery; compare cloud/on-premises/hybrid ownership |
| 3 | TLS and credential lifecycle | Local test CA; verify identity; reject wrong trust/hostname; rotate a reader credential and prove old-password failure; explain storage encryption separately |
| 4 | Regulatory and stewardship case | Fictional scenario; determine applicability from authoritative sources; map obligations to concrete controls/evidence/gaps; record approval and exceptions; do not certify compliance |
| 5 | Approved institutional-tool bridge | Map local artifacts to Alation/Snowflake/Airflow using authorized accounts, equivalent evidence and a no-cost alternative |

These are proposals, not runnable labs yet. Develop and test them before advertising
them as supported. An institution may prioritize the first two because its syllabus
already contains the stronger practical expectations.

## Earlier review: what remains

Implemented: canonical setup, environment variables, unique logins, fail-fast checks,
correct models/selection/grain, deterministic fixtures, actual denial assertions,
safe reruns, templates, instructor notes, AI outcome and current-tree asset cleanup.

Still open: historical credential revocation and history review; novice and replacement-
instructor pilots; an immutable release/tag after all CI checks pass; dependency advisory
review and comprehensive secret/history scanning beyond the new baseline hygiene checks; real audit/multi-instance/TLS demonstrations.
Hash-pinning dependencies does not prove they have no known vulnerabilities.

Private syllabus matters remain private: current dates, contact details, attendance,
accommodations, grades, credentials and resolution of conflicting administrative policies.
No institutional accounts or the full private syllabus are published here.

---

Author: [Isaac K. Nti](../AUTHORS.md). [Citation and reuse terms](../CITATION.md).
