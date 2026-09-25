# Required course path

Use this as your navigation and progress record. **Core lab sequence** means Labs
1–7. **Required course path** also includes the companion activities below and
the capstone. This checklist consolidates existing requirements from the
[module map](module_learning_map.md); it does not introduce new learning outcomes.
Your LMS controls assigned work, dates and official grading when enrolled.

Independent learners may choose either scope using [self-study guidance](self_study.md).
Keep one copy of each artifact and refer to it again; do not rewrite it for each page.

## Follow the required course path

- [ ] [Install once](local_run.md): choose Windows/WSL or native Ubuntu.
- [ ] [Lab 1](../labs/module1_preflight/README.md): setup evidence and account/configuration worksheet.
- [ ] [Lab 2](../labs/module_2/M2_lab2_governance.md): guided entry, two written classifications and one independent inserted entry.
- [ ] **Module 1 companion:** name a structured, semi-structured and unstructured source; write one curation risk for each. Three short rows are enough; no additional installation.
- [ ] [Lab 3](../labs/module_2/lab3/README.md): three explanations and the named independent data test.
- [ ] **Module 2 companion:** make an editable ERD of the retail source tables; label keys, relationships and grain. Use the guidance below. Reuse it in the capstone where applicable.
- [ ] [Lab 4](../labs/module_3/lab4/README.md): lineage paths and lifecycle decision log.
- [ ] **Module 3 companion:** extend that log with a text path from creation to deletion, including exports/backups; explain a legal hold and restoration risk. Do not repeat answers already in the log. Execution of Lab 8 is optional.
- [ ] **Module 4 companion:** complete the [deployment comparison prompt](../labs/extensions/infrastructure.md#b4-compare-deployment-choices) without running Lab 9. Include data residency (where records are stored) and sovereignty (which jurisdictions may govern them), alongside its other criteria. No cloud account is required.
- [ ] [Lab 5](../labs/module_5/lab5/README.md): access results and a proposed narrower view, including the remote-server discussion.
- [ ] [Lab 6](../labs/module_6/lab6/README.md): evidence excerpts and incident memo.
- [ ] **Governance companion:** complete the [short applicability discussion](module_learning_map.md#required-discussion-case-governance-applicability). Use the linked primary sources; one justified obligation/control/owner/evidence row is sufficient.
- [ ] [Lab 7](../labs/extensions/ai_governance.md): metric interpretation, initial decision and change review.
- [ ] **Module 7 companion:** complete the [operations record](module_learning_map.md#integrated-governance-operations-record). One row is enough; link to your earlier lab observation and the relevant decision rather than writing another essay.
- [ ] [Capstone](../capstone_project/README.md): follow its seven phases, portfolio and final checklist. Independent learners use its solo route.

## Help with the ERD companion

An ERD shows tables and relationships. Read the `CREATE TABLE` portions of
[the retail seed](../labs/module_2/lab2_seed.sql). `PRIMARY KEY` identifies a row.
This fixture does not declare SQL `REFERENCES` constraints: distinguish logical
relationships from database-enforced foreign keys. For example, an order's
`customer_id` links logically to a customer's `customer_id`. List customers,
orders, order_items and products; use their ID fields and the joins in the
[detailed order model](../dbt/it4065c_platform/models/marts/lab3/oltp_order_detail.sql)
to identify the remaining relationships. Label each table's grain and whether
one record can relate to many records in the other table (cardinality). Mark
foreign-key links as logical unless you have separate enforcement evidence.

An editable text source is acceptable. For example, in a **different library
scenario**, `BORROWER (borrower_id PK) 1 -> many LOAN (loan_id PK, borrower_id FK)`
means one borrower may have several loans. Use that pattern for the retail tables;
do not submit this library example as the retail model. You may also use Mermaid
or a diagramming tool that retains an editable source. No new database commands
are required. Keep the model in your private submission.

## Optional enrichment

Labs [8–15](../labs/README.md#optional-labs-811) deepen selected topics. Choose by
interest or instructor assignment. Completing a companion discussion does not
require executing its related optional lab. Alation and Snowflake activities are
separate [platform supplements](platforms.md); access and course assignments are
set through the LMS.

## When to move on

Use each lab's own submission checklist. A technical PASS plus the requested
explanation/artifact completes that lab. Keep questions you could not resolve in
your notes and use [self-check and help](self_study.md); do not invent evidence.

---

Author: [Isaac K. Nti](../AUTHORS.md). [Citation and reuse terms](../CITATION.md).
