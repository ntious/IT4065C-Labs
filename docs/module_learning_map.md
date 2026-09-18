# Module learning map

Use this sequence with the official LMS calendar. Module and lab numbers differ.
Read each linked lab's concept notes before class. Required evidence below ensures
that optional lab selection does not remove a course learning outcome.

| Syllabus module | Preparation and guided work | Required independent evidence / discussion |
| --- | --- | --- |
| 1. Governance, sources and curation | Foundations bridge; Labs 1–2; glossary | Classify a new field; explain owner, permitted use and metadata. Identify a structured, semi-structured and unstructured source and a curation risk for each. |
| 2. Lifecycle | Lab 4; inspect lifecycle stages | Draw creation through deletion, including derived copies and backups. Explain a hold and how restoration could reintroduce deleted data. Lab 8 deepens this with execution. |
| 3. Modeling | Lab 3 and its concept notes | Create an editable ERD, state grain/cardinality, author a data test and explain a failed-test scenario. |
| 4. Infrastructure | Read Lab 9's deployment comparison prompt; execution optional. [Snowflake workshop](platforms.md#snowflake-university-supplement-module-4) offers optional cloud exploration | Compare cloud, on-premises and hybrid for identity, ownership, freshness, cost and failure domains; justify one choice. This assesses SLO 3 discussion, not multi-cluster operation. |
| 5. Access security | Lab 5 | Predict and test separate-login behavior; explain masking limits and propose a narrower access view. |
| 6. Monitoring | Lab 6 | Trace one observation and one simulated alert to their source; explain a false positive and missing server evidence. |
| 7. Integrated governance and AI | Required Lab 7; AI decision template | Defend a deployment decision across collection, evaluation, use, monitoring and retirement; complete the change-review activity. |
| 8. Capstone | Portfolio and architecture defense | Link requirements to model, controls and evidence; complete peer review, revision and individual reflection. |

## Short preparation readings

Read the local explanation before the corresponding lab. These are short concept
notes, not additional installations or paid reading requirements.

| Module | Preparation reading | Check before class |
| --- | --- | --- |
| 1 | [Foundations](foundations.md), [identity notes](lab_context_notes/lab1.md), [classification notes](lab_context_notes/lab2.md) | Explain one identity boundary and one contextual classification. |
| 2 | [Lifecycle notes](lab_context_notes/lab4.md) | Trace one derived copy after source deletion. |
| 3 | [Grain and modeling notes](lab_context_notes/lab3.md) | State the grain before joining tables. |
| 4 | [Infrastructure comparison](../labs/extensions/infrastructure.md), [platform bridge](platforms.md) | Name an ownership or failure-domain tradeoff. |
| 5 | [Access notes](lab_context_notes/lab5.md) | Predict one allowed and one denied action. |
| 6 | [Monitoring notes](lab_context_notes/lab6.md) | Distinguish a client observation from independent server evidence. |
| 7 | [AI decision and NIST resources](../labs/extensions/ai_decision_template.md) | Identify a harm that one metric misses. |
| 8 | [Capstone guide](../capstone_project/README.md), [evidence descriptors](assessment_examples.md) | Trace a claim to evidence and a limitation. |

## Required discussion case: governance applicability

A fictional organization proposes reusing purchase records for support prioritization.
It has not established jurisdiction, health-sector status, lawful authority or the
source of labels. List the facts needed before selecting a regulatory framework.
Using instructor-selected current primary sources, map one potentially applicable
obligation to an owner, control and evidence gap. Explain why sensitive data alone
does not establish that every privacy law applies. This is an academic analysis,
not a declaration of compliance. The instructor reviews source applicability.

## Enrichment without extra required installations

Labs 8–11 deepen retention, snapshot behavior, mixed-format curation and publication.
Select them for available time and student interest. Optional Labs 12–14 now provide isolated server logging, two-instance batch transfer
and verified TLS/rotation; Optional Lab 15 expands the governance case. These remain
optional. Production failover, independent audit storage and storage encryption are
not demonstrated. Consult the crosswalk before claiming stronger syllabus coverage.

Readings: use the existing per-lab concept notes and the AI template's NIST resources.
The instructor may assign syllabus textbook excerpts through authorized library access;
do not copy copyrighted chapters into this public repository.

---

Author: [Isaac K. Nti](../AUTHORS.md).
