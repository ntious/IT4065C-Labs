# Syllabus alignment and remaining work

Reviewed against the supplied Spring 2025 syllabus and the subsequently added AI
outcome. This is a public academic crosswalk, not a replacement institutional syllabus.
Lab numbering is a teaching sequence; it does not equal the syllabus's module numbering.

## Evidence by outcome and module

| Syllabus area | Current evidence | Remaining limitation |
|---|---|---|
| SLO 1 / Module 1: types, sources, curation and metadata | Lab 2 register, metadata notebook, optional Lab 10 CSV/JSON/text catalog and curation | Alation University Data Intelligence Project supplements local work; assigned product activities require authorized access |
| SLO 2 / Module 2: creation-to-deletion lifecycle and ETL | Lab 4 lineage/lifecycle decisions, optional Lab 8 deletion-ledger simulation, optional Labs 10–11 ingestion/publication | Real backup restore and scheduled enterprise orchestration remain extensions |
| SLO 3 / Module 4: cloud/on-premises/hybrid and multiple clusters | Lab 9 snapshot experiment and required infrastructure comparison; optional Snowflake University workshop; capstone architecture decision | Optional Lab 13 adds distinct local instances, source outage and measured batch recovery; no automatic failover or independent hardware failure domains |
| SLO 4 / Module 3: lifecycle/modeling tools and ERDs | dbt models/tests, capstone editable ERD, Lab 3 student-authored test, optional Lab 11 model/KPI | Independent student model implementation needs instructor assessment; optional ERD is not auto-graded |
| SLO 5 / Modules 5–6: security and monitoring | Separate-login allow/deny tests, masking, live client observations and simulated incident rules | Optional Labs 12/14 add actual server CSV records and verified local TLS/rotation; no independently protected log collector or storage encryption demonstration |
| Module 7: integrated governance | Register, controls, quality tests and capstone evidence classifications | Alation University supplements the concepts; Optional Lab 15 adds primary-source applicability analysis; product-specific evidence follows LMS assignments |
| Module 8 / project: integration, analytics, visualization and peer review | Seven-phase capstone, defense/reflection; optional Lab 11 executable pipeline and reconciled report | A team's own architecture still needs its own implementation evidence and peer review |
| Added SLO 6: AI ethics and governance across the lifecycle | Required Lab 7: bias rates, mitigation tradeoff, dataset card, transparency, appeal, accountable owners, NIST AI RMF decision | Small supplied predictions illustrate governance reasoning, not production fairness or model-training proficiency |

The course-level SLO 3 says **discuss**, but Module 4 also promises hands-on
multi-cluster administration. The comparison activity supports the discussion outcome;
it does not alone fulfill that stronger practical module claim. Optional Lab 13
adds two-instance administration; Optional Lab 12 adds server observations. Because
these remain optional, they cannot establish that every student met a required
practical outcome unless the instructor assigns an appropriate assessed route.

## Teaching support added

The foundations bridge, module learning map, assessment descriptors, peer review,
session guide and adoption checklist support independent learning and instructor
handoff. Required lifecycle/infrastructure discussions no longer depend on taking
optional labs. Lab 7 includes a purpose-change review. These curriculum additions
support the new optional server, transfer, TLS and governance activities below.

## Keep the revised core manageable

Labs 1–7 are the revised core. Labs 8–15 are optional enrichment. If an instructor
uses the unchanged official syllabus's stronger practical promises, the corresponding
missing activities must become required or the substitution must be approved through
the appropriate course process. Calling them optional does not erase the gap.

The new AI outcome is assessed through discussion, a decision memo and defense.
Another required machine-learning lab is unnecessary. Use this cross-lab evidence chain:
classification and permitted AI use (Lab 2); proxy/audit-field separation (Lab 3);
training/evaluation/retirement copies (Lab 4); restricted audit access (Lab 5);
drift and incident ownership (Lab 6); accountable deployment decision (Lab 7).
Where a link is a proposed design rather than an executed control, label it that way.

## Added optional activities and limits

| Activity | Implemented evidence | Limit |
| --- | --- | --- |
| [12. Server audit](../labs/extensions/server_audit.md) | Actual CSV query completion/denial correlated to a server session; reader denied server-file access | Student owns the server; no tamper-resistant external collector |
| [13. Two instances](../labs/extensions/two_instance_transfer.md) | Distinct cluster identities; batch transfer; source shutdown; preserved target; measured recovery and retry | No streaming replication, automatic failover or separate physical hosts |
| [14. TLS/rotation](../labs/extensions/tls_rotation.md) | Verified trust/hostname; wrong trust/hostname/plaintext rejected; old credential rejected after rotation | No storage/backup encryption or termination of existing sessions |
| [15. Governance case](../labs/extensions/governance_case.md) | Primary-source scope analysis, control/evidence matrix and stewardship decision | Human assessment; not legal certification |
| [External platforms](platforms.md) | Alation University and optional Snowflake workshop mappings with local alternatives | Restricted activities and student completion are not independently verified here |

New server experiments have local execution evidence; their expanded Ubuntu CI runs
are pending publication of these changes. See [validation](validation.md). All newly
added labs are optional. Required short discussions and Lab 7 remain in the core.

## Earlier review: what remains

Implemented: canonical setup, environment variables, unique logins, fail-fast checks,
correct models/selection/grain, deterministic fixtures, actual denial assertions,
safe reruns, templates, instructor notes, AI outcome and current-tree asset cleanup.

Still open: historical credential revocation and history review; novice and replacement-
instructor pilots; an immutable release/tag after all CI checks pass; dependency advisory
review and comprehensive secret/history scanning beyond the new baseline hygiene checks; expanded Ubuntu validation, independent audit storage, production failover and storage-encryption demonstrations.
Hash-pinning dependencies does not prove they have no known vulnerabilities.

Private syllabus matters remain private: current dates, contact details, attendance,
accommodations, grades, credentials and resolution of conflicting administrative policies.
No institutional accounts or the full private syllabus are published here.

---

Author: [Isaac K. Nti](../AUTHORS.md). [Citation and reuse terms](../CITATION.md).
