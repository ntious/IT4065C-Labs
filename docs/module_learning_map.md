# Module learning map

The module descriptions, module-level outcomes and learning activities in this map
were developed by Isaac K. Nti. They are instructional guidance, not the University
of Cincinnati’s official course-level learning outcomes. The map supports the Spring
2026 course sequence.

The AI ethics and governance course-level outcome, identified here as SLO 6,
was added by the University of Cincinnati after the repository's initial development.
Isaac K. Nti developed the repository activities addressing it, not the outcome.
As checked on 2026-09-18, the public UC course-description page lists the earlier
five outcomes and does not yet display this addition. Consult the current official
course materials for the authoritative outcome wording and applicable offering.

See the [institutional notice](../AUTHORS.md#institutional-context-and-instructional-authorship)
and [official UC course descriptions](https://www.cech.uc.edu/Academics/school-of-information-technology/course_descriptions.html).

Follow the [course checklist](course_checklist.md) for the ordered learner route
and a single list of artifacts. Use the official LMS calendar for dates. Module and lab numbers differ.
Read each lab page's introductory explanation before the activity. The required evidence connects
instructor-developed activities to the course's assessment plan.

| Instructor-developed module | Preparation and guided work | Required independent evidence / discussion |
| --- | --- | --- |
| 1. Foundations of Data Governance and Data Classification | Foundations bridge; Labs 1–2; glossary | Classify a new field; explain owner, permitted use and metadata. Identify a structured, semi-structured and unstructured source and a curation risk for each. |
| 2. Data Modeling for Operational and Analytical Systems | Lab 3 and its concept notes | Create an editable ERD, state grain/cardinality, author a data test and explain a failed-test scenario. |
| 3. Data Lifecycle Design and Management | Lab 4; inspect lifecycle stages | Draw creation through deletion, including derived copies and backups. Explain a hold and how restoration could reintroduce deleted data. Lab 8 deepens this with execution. |
| 4. Infrastructure Models for Data Administration | Read Lab 9's deployment comparison prompt; execution optional. [Snowflake workshop](platforms.md#snowflake-university-supplement-module-4) offers optional cloud exploration | Compare cloud, on-premises and hybrid for identity, ownership, freshness, cost, data residency, sovereignty and failure domains; justify one choice. This assesses SLO 3 discussion, not multi-cluster operation. |
| 5. Data Access Control and Security Implementation | Lab 5 | Predict and test separate-login behavior; explain masking limits and propose a narrower access view. |
| 6. Data Access Monitoring and Compliance Enforcement | Lab 6 | Trace one observation and one simulated alert to their source; explain a false positive and missing server evidence. |
| 7. Integrated Data Governance Operations and added AI outcome | Required Lab 7; AI decision template | Record a review → action → documentation cycle using earlier lab evidence. Defend the AI lifecycle decision and complete its change review. |
| 8. Capstone Project and Course Synthesis | Portfolio and architecture defense | Link requirements to model, controls and evidence; complete peer review, revision and individual reflection. |

## Short preparation readings

Read the local explanation before the corresponding lab. These are short concept
notes, not additional installations or paid reading requirements.

| Module | Preparation reading | Check before class |
| --- | --- | --- |
| 1 | [Foundations](foundations.md), [identity notes](lab_context_notes/lab1.md), [classification notes](lab_context_notes/lab2.md) | Explain one identity boundary and one contextual classification. |
| 2 | [Grain and modeling notes](lab_context_notes/lab3.md) | State the grain before joining tables. |
| 3 | [Lifecycle notes](lab_context_notes/lab4.md) | Trace one derived copy after source deletion. |
| 4 | [Infrastructure comparison](../labs/extensions/infrastructure.md), [platform bridge](platforms.md) | Name an ownership or failure-domain tradeoff. |
| 5 | [Access notes](lab_context_notes/lab5.md) | Predict one allowed and one denied action. |
| 6 | [Monitoring notes](lab_context_notes/lab6.md) | Distinguish a client observation from independent server evidence. |
| 7 | [AI decision and NIST resources](../labs/extensions/ai_decision_template.md) | Identify a harm that one metric misses. |
| 8 | [Capstone guide](../capstone_project/README.md), [evidence descriptors](assessment_examples.md) | Trace a claim to evidence and a limitation. |

## Integrated governance operations record

For Module 7, select one access or quality observation from Labs 3, 5 or 6. Record
its evidence source, the policy or requirement, a fictional accountable role, the
review decision, corrective action, verification result and next review trigger.
Identify an ownership gap or bottleneck and explain how cloud or hybrid placement
changes responsibility. Mark actions proposed when they have not been executed.
This connects existing lab work; it is not an additional required technical lab.

## Required discussion case: governance applicability

A fictional organization proposes reusing purchase records for support prioritization.
It has not established jurisdiction, health-sector status, lawful authority or the
source of labels. List the facts needed before selecting a regulatory framework.
Use the [primary-source reading list](../labs/extensions/governance_case.md#read-primary-sources),
or current sources assigned in the LMS. Reading the list does not require completing
optional Lab 15. Map one potentially applicable
obligation to an owner, control and evidence gap. Explain why sensitive data alone
does not establish that every privacy law applies. This is an academic analysis,
not a declaration of compliance. Enrolled students discuss source applicability with the instructor; independent
learners state their scope assumptions and unresolved facts explicitly.

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
