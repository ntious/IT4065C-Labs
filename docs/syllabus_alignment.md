# Syllabus alignment and teaching scope

This is an **internal instructional mapping** developed by Isaac K. Nti for this
repository. It is not an official University of Cincinnati document, syllabus or
statement of University policy. Module descriptions and module-level outcomes are
instructor-developed, not University-issued course-level outcomes.

The mapping uses the Spring 2026 syllabus as a course reference and identifies the
instructor-supplied AI governance addition as SLO 6. SLO identifiers are used for
internal traceability; they do not establish University approval of this mapping or
the additional outcome. Consult the
[official UC course descriptions](https://www.cech.uc.edu/Academics/school-of-information-technology/course_descriptions.html)
for the official course description and course-level outcomes, and the
[institutional notice](../AUTHORS.md#institutional-context-and-instructional-authorship)
for ownership and licensing boundaries. Lab numbers identify activities, not modules.

## Evidence by module and outcome

| Instructor-developed module | Primary course evidence | Scope and assessment |
| --- | --- | --- |
| 1. Foundations of Data Governance and Data Classification | Lab 2 register, metadata notebook, Alation University supplement; Optional Lab 10 | SLOs 1,5: classify structure, sensitivity, ownership and use; product-specific catalog activity follows LMS access instructions |
| 2. Data Modeling for Operational and Analytical Systems | Lab 3 models/tests; capstone ERD and workload strategy | SLOs 2,4: assess grain, keys, relationships and OLTP/OLAP rationale; evaluate the student's own design separately from the baseline |
| 3. Data Lifecycle Design and Management | Lab 4 lineage; dbt workflow; optional retention, ingestion and publication Labs 8,10,11 | SLOs 2,4: diagram collection through retirement and explain controlled transitions; dbt dependency execution does not demonstrate a continuously scheduled orchestration service |
| 4. Infrastructure Models for Data Administration | Required deployment comparison; optional Snowflake workshop and Labs 9,13 | SLO 3 with support for 2,5: compare administrative responsibilities, residency, sovereignty, cost and monitoring; two-instance engineering is enrichment |
| 5. Data Access Control and Security Implementation | Lab 5 authenticated permissions/masking; Optional Lab 14 TLS and rotation | SLO 5: test access controls; TLS is executed in the optional route, while storage encryption is discussed as a proposed control |
| 6. Data Access Monitoring and Compliance Enforcement | Lab 6 observations/incident analysis; Optional Lab 12 server records and Lab 15 applicability case | SLOs 2,5 with support for 3: identify evidence sources, detect policy violations and report qualified conclusions; logs are not independently protected audit storage |
| 7. Integrated Data Governance Operations | Review/action/documentation record connecting Labs 2,4,5,6 and capstone; Lab 7 AI decision | SLOs 1,2,3,5 plus added SLO 6: assess ownership, remediation, verification and review responsibility across environments |
| 8. Capstone Project and Course Synthesis | Seven-phase portfolio, technical evidence, peer review, defense and reflection | Integrate SLOs 1–6; demonstrate feasibility within the named test environment and distinguish proposed deployment controls |

Module 4 emphasizes administrative decision-making and discussion of multi-cluster
implications. Its 2026 outcomes do not require students to engineer a production
cluster. Optional Lab 13 strengthens the comparison with actual local instances.

For Module 5's encryption application outcome, instructors must specify assessed
hands-on encryption evidence through their course delivery. Optional Lab 14 supplies
a local transport-encryption activity, but its availability alone does not prove
that every student completed that outcome. Storage encryption is not executed here.
Likewise, identify the assigned catalog and orchestration evidence when assessing
product-specific or continuously scheduled workflows.

## Teaching resources

The foundations bridge, module learning map, assessment descriptors, peer review,
session guide and adoption checklist support independent learning and instructor
handoff. Required lifecycle and infrastructure discussions have assessment routes independent
of optional lab execution. Lab 7 includes a purpose-change review. These curriculum additions
support the new optional server, transfer, TLS and governance activities below.

## Core and optional scope

Labs 1–7 form the core; Labs 8–15 provide optional enrichment. Instructors adopting
a syllabus with additional required practical outcomes must specify an assessed
activity for each outcome or obtain approval for a substitution. Optional availability
alone does not establish that every student completed a practical outcome.

The AI governance outcome is assessed through discussion, a decision memo and defense.
Another required machine-learning lab is unnecessary. Use this cross-lab evidence chain:
classification and permitted AI use (Lab 2); proxy/audit-field separation (Lab 3);
training/evaluation/retirement copies (Lab 4); restricted audit access (Lab 5);
drift and incident ownership (Lab 6); accountable deployment decision (Lab 7).
Where a link is a proposed design rather than an executed control, label it that way.

## Optional activities and evidence boundaries

| Activity | Implemented evidence | Limit |
| --- | --- | --- |
| [12. Server audit](../labs/extensions/server_audit.md) | Actual CSV query completion/denial correlated to a server session; reader denied server-file access | Student owns the server; no tamper-resistant external collector |
| [13. Two instances](../labs/extensions/two_instance_transfer.md) | Distinct cluster identities; batch transfer; source shutdown; preserved target; measured recovery and retry | No streaming replication, automatic failover or separate physical hosts |
| [14. TLS/rotation](../labs/extensions/tls_rotation.md) | Verified trust/hostname; wrong trust/hostname/plaintext rejected; old credential rejected after rotation | No storage/backup encryption or termination of existing sessions |
| [15. Governance case](../labs/extensions/governance_case.md) | Primary-source scope analysis, control/evidence matrix and stewardship decision | Human assessment; not legal certification |
| [External platforms](platforms.md) | Alation University and optional Snowflake workshop mappings with local alternatives | Restricted activities and student completion are not independently verified here |

The server experiments passed the Ubuntu 22.04 and 24.04 workflow at commit
`2f15cc9`, including two runs of each experiment. See [validation](validation.md)
for the exact evidence. Labs 12–15 are optional; required discussions and Lab 7
remain part of the core.

## Adoption and maintenance responsibilities

The course provides canonical setup, private environment configuration, unique
logins, deterministic fixtures, negative checks, repeatable experiments and public
assessment guidance. Use the [adoption checklist](adoption_checklist.md) to prepare
a specific offering and the [release guide](release_management.md) to select its version.

Human learner and instructor pilots, historical credential remediation, dependency
advisory review and comprehensive Git-history scanning have no recorded completion
in this repository. Track these explicitly during adoption; automated lab checks do
not establish their completion. Hash-pinning establishes dependency identity, not
freedom from known vulnerabilities. Independent audit storage, production failover
and storage encryption are outside the implemented demonstrations.

Private syllabus matters remain private: current dates, contact details, attendance,
accommodations, grades, credentials and resolution of conflicting administrative policies.
No institutional accounts or the full private syllabus are published here.

---

Author: [Isaac K. Nti](../AUTHORS.md). [Citation and reuse terms](../CITATION.md).
