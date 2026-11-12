# Companion Resource Identifiers (EDS)

This table maps every Companion Resource Identifier (EDS) used in *Enterprise Data Systems: Architecture, Governance, Security, and Administration* (first edition) to the resource it names. Identifiers are stable book navigation aliases. They do not rename course files or create new course activities, and they are never reused.

- **Evidence baseline** (course materials examined for the book): commit `d860dd98256a8090ffc6bd3766c59cb15a553c12`.
- **Companion revision** (the `textbook-companion/` folder was added here, without changing course materials): commit `36b4636bc4635b5a00a3f1fabb6ba37f0d00acdc`.
- Archived release cited in the book: version 2026.11.07.1, https://doi.org/10.5281/zenodo.24046603. Neither DOI identifies either commit.

Paths are relative to the repository root and are pinned to the commit shown. To open a file at that revision, use `https://github.com/ntious/IT4065C-Labs/blob/<commit>/<path>`.

| Identifier | Resource | Path | Pinned commit | Book chapters (first edition) | Status / alias notes |
|---|---|---|---|---|---|
| EDS-CAP-001 | Governed Retail Capstone Phase 1: Discovery | `capstone_project/phase_1_discovery.md` | `d860dd9` | Chs 2, 3, 18 | Approved (Registry v1.1) |
| EDS-CAP-002 | Governed Retail Capstone Phase 2: Structural foundation | `capstone_project/phase_2_structural_foundation.md` | `d860dd9` | Chs 3, 18 | Approved (Registry v1.1) |
| EDS-SUITE-001 | Executable examples: foundations | `textbook-companion/examples/foundations/` | `36b4636` | Chs 1, 3 | Approved (Registry v1.1) |
| EDS-SUITE-002 | Executable examples: transactions and analytics | `textbook-companion/examples/transactions/` | `36b4636` | Chs 2, 4–6 | Approved (Registry v1.1) |
| EDS-SUITE-003 | Executable examples: temporal and decision reasoning | `textbook-companion/examples/reasoning/` | `36b4636` | Chs 7–9, 15–18 | Approved (Registry v1.1) |
| EDS-SUITE-004 | Executable examples: lifecycle and recovery | `textbook-companion/examples/lifecycle/` | `36b4636` | Chs 10–14 | Approved (Registry v1.1) |
| EDS-LAB-001 | Lab 1: Environment readiness | `labs/core/lab01-environment/README.md` | `d860dd9` | see book | Approved alias (Registry v1.0/v1.1) |
| EDS-LAB-002 | Lab 2: Classification and stewardship | `labs/core/lab02-classification/README.md` | `d860dd9` | see book | Approved alias (Registry v1.0/v1.1) |
| EDS-LAB-003 | Lab 3: Modeling and data quality | `labs/core/lab03-modeling-quality/README.md` | `d860dd9` | see book | Approved alias (Registry v1.0/v1.1) |
| EDS-LAB-004 | Lab 4: Lineage and lifecycle | `labs/core/lab04-lineage-lifecycle/README.md` | `d860dd9` | see book | Approved alias (Registry v1.0/v1.1) |
| EDS-LAB-005 | Lab 5: Access control and masking | `labs/core/lab05-access-control/README.md` | `d860dd9` | see book | Approved alias (Registry v1.0/v1.1) |
| EDS-LAB-006 | Lab 6: Monitoring and evidence | `labs/core/lab06-monitoring/README.md` | `d860dd9` | see book | Approved alias (Registry v1.0/v1.1) |
| EDS-LAB-007 | Lab 7: AI governance | `labs/core/lab07-ai-governance/README.md` | `d860dd9` | see book | Approved alias (Registry v1.0/v1.1) |
| EDS-LAB-008 | Lab 8: Retention and deletion (optional) | `labs/optional/lab08-retention/README.md` | `d860dd9` | see book | Approved alias (Registry v1.0/v1.1) |
| EDS-LAB-009 | Lab 9: Infrastructure snapshot experiment (optional) | `labs/optional/lab09-infrastructure/README.md` | `d860dd9` | see book | Approved alias (Registry v1.0/v1.1) |
| EDS-LAB-010 | Lab 10: Catalog and curate mixed-format sources (optional) | `labs/optional/lab10-catalog-ingestion/README.md` | `d860dd9` | see book | Approved alias (Registry v1.0/v1.1) |
| EDS-LAB-011 | Lab 11: Quality-gated publication and a reconciled KPI (optional) | `labs/optional/lab11-quality-promotion/README.md` | `d860dd9` | see book | Approved alias (Registry v1.0/v1.1) |
| EDS-LAB-012 | Lab 12: Server-side audit investigation (optional) | `labs/optional/lab12-server-audit/README.md` | `d860dd9` | see book | Approved alias (Registry v1.0/v1.1) |
| EDS-LAB-013 | Lab 13: Two-instance transfer and recovery (optional) | `labs/optional/lab13-transfer-recovery/README.md` | `d860dd9` | see book | Approved alias (Registry v1.0/v1.1) |
| EDS-LAB-014 | Lab 14: Verified TLS and credential rotation (optional) | `labs/optional/lab14-tls-rotation/README.md` | `d860dd9` | see book | Approved alias (Registry v1.0/v1.1) |
| EDS-LAB-015 | Lab 15: Governance applicability and stewardship case (optional) | `labs/optional/lab15-governance-case/README.md` | `d860dd9` | see book | Approved alias (Registry v1.0/v1.1); shares its source with EDS-CASE-004 (one activity, one submission) |
| EDS-CASE-001 | Governed Retail stakeholder interview | `capstone_project/Business_Interview_Transcript.md` | `d860dd9` | Chs 2, 8, 9 and case sections | Approved alias |
| EDS-CASE-002 | Equipment-lending worked trace (all observations simulated) | `capstone_project/fictional_example.md` | `d860dd9` | Chs 5, 18 | Approved alias |
| EDS-CASE-003 | Library outreach AI decision (fictional transfer case) | `docs/ai_decision_example.md` | `d860dd9` | Ch 4 | Approved alias |
| EDS-CASE-004 | RetailBridge vendor/purpose-change scenario | `labs/optional/lab15-governance-case/README.md` | `d860dd9` | Companion CH12 activity (not used in print) | Scenario alias inside EDS-LAB-015: same source, not a second activity. The book cites the activity as EDS-LAB-015 |
| EDS-DATA-001 | Core retail SQL fixture | `labs/core/lab02-classification/lab2_seed.sql` | `d860dd9` | Chs 2, 5, 6 | Approved alias |
| EDS-DATA-002 | Synthetic evaluation-policy decisions (16 records) | `data/ai_predictions.csv` | `d860dd9` | Ch 17 | Approved alias; data under the repository MIT licence (data/README.md) |
| EDS-DATA-003 | Mixed-format CSV sales source | `data/ingestion/sales.csv` | `d860dd9` | Ch 7 | Approved alias |
| EDS-DATA-004 | Mixed-format JSON-lines source | `data/ingestion/events.jsonl` | `d860dd9` | Ch 7 | Approved alias |
| EDS-DATA-005 | Reporting-purpose document | `data/ingestion/purpose.txt` | `d860dd9` | Ch 7 | Approved alias |
| EDS-DECISION-001 | Lifecycle/retirement decision log template | `labs/core/lab04-lineage-lifecycle/_turnin_template.md` | `d860dd9` | — | Approved alias (not used in print) |
| EDS-DECISION-002 | AI lifecycle/changed-purpose decision template | `labs/core/lab07-ai-governance/ai_decision_template.md` | `d860dd9` | — | Approved alias (not used in print) |
| EDS-DECISION-003 | Claim and revision record (portfolio section) | `capstone_project/portfolio_template.md#claim-and-revision-record` | `d860dd9` | Ch 2 | Approved alias (section-level) |
| EDS-DECISION-004 | Integrated governance-operations record (module map section) | `docs/module_learning_map.md#integrated-governance-operations-record` | `d860dd9` | Ch 9 | Approved alias (section-level); production query PQ-01 asks the author to confirm use as printed |
| EDS-FIG-001 | Lineage interaction guide (adaptation source) | `sample_screenshots/lab4-order-lineage-guide.svg` | `d860dd9` | — | Registered; not used in print |
| EDS-FIG-002 | Access-result visual (adaptation source) | `sample_screenshots/lab5-access-results.png` | `d860dd9` | — | Registered; not used in print |
| EDS-FIG-003 | KPI reconciliation visual (adaptation source) | `sample_screenshots/lab11-kpi-results.png` | `d860dd9` | — | Registered; not used in print |

## Shared sources and aliases

- **EDS-LAB-015 and EDS-CASE-004** refer to the same file on purpose: EDS-LAB-015 is the optional activity, and EDS-CASE-004 is the RetailBridge scenario inside it. They are one activity with one submission. The book cites the activity (EDS-LAB-015); this companion's Chapter 12 activity cites the scenario (EDS-CASE-004).
- **Capstone phase 3 (workload strategy)** is cited in the book by name without an identifier (Sections 5.17.1 and 6.16.1). A registry decision on EDS-CAP-003 is pending.

## Evidence codes used in this companion

Companion execution records use the codes EXT-PRI, R-DOC, R-OBS, R-SIM, R-INF, R-PROP, AUTH, AUTH-OBS and PEND. They are provenance labels for navigation. Appendix H of the book maps them to its four evidence statuses (observed, simulated, inferred, proposed); they are not additional statuses.

*Source of record: EDS_Authoring_Registry v1.1 (approved 11 November 2026). This file is a reader-facing extract; it adds no identifiers.*
