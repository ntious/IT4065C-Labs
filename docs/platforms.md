# Course platforms and equivalent evidence

The runnable local course requires Ubuntu, PostgreSQL, Python and dbt. External
platforms support selected demonstrations and assigned exploration; students
do not need an external account for the local lab sequence.

The course uses **Alation University's Data Intelligence Project** to supplement
local labs. The course also introduces Snowflake
through an optional Data Warehousing Workshop in Module 4. Apache Airflow may
support selected activities; external platforms are not required for every local lab.

## Alation University supplement

Start at the [Alation Help Center](https://help.alation.com/s/) and use your
authorized account. Follow the instructor's current LMS directions to locate the
**Data Intelligence Project** in Alation University. Access and enrollment depend
on your account; the public course repository does not grant either. The instructor
provides course-specific enrollment directions privately when needed.

The project complements local classification, metadata, lineage and stewardship
work. Use the LMS for the selected exercises, enrollment directions and assessment
requirements. This public guide maps concepts to local labs; it does not reproduce
or verify the account-restricted training content.

After an assigned activity, record the concept, a permitted observation, its local
lab counterpart and one limitation. Submit that reflection privately; do not copy
restricted training materials, account details or completion records into this repo.
If you cannot access the project, complete the corresponding local activity and
comparison prompt, then ask the instructor about any assigned product-specific
requirement. Local work supports the concepts but does not certify Alation proficiency.

## Snowflake University supplement: Module 4

The optional [Data Warehousing Workshop (Badge 1)](https://learn.snowflake.com/en/courses/OD-ESS-DWW/)
introduces Snowflake and cloud data warehousing. It complements
Module 4's discussion of cloud, on-premises and hybrid infrastructure. Follow the
workshop page's enrollment and account-setup instructions; the course repository
does not provide a Snowflake account. Wait for the workshop's directions before
creating a trial account, and follow its current usage and cleanup guidance.

The public workshop description includes database fundamentals, loading and querying
data, semi-structured formats, hands-on activities and automated checks. It provides
an external cloud example to compare with the local PostgreSQL environment.
Consider who manages infrastructure, who controls data access, how compute is
provisioned, and how connectivity, cost and operational responsibilities differ.
A local single-server exercise does not represent every on-premises deployment,
and workshop completion does not demonstrate multi-cluster administration.

This is an optional learning resource, not an additional required repository lab.
Students without access can use the required infrastructure comparison in the
[module learning map](module_learning_map.md) and the local course materials;
that route does not earn a Snowflake badge or establish product-specific experience.
Any assigned completion threshold, reflection, evidence or grading belongs in the
current LMS. Keep learning transcripts, account details and submissions private.

The linked public page was reviewed on 2026-09-18; its enrolled exercises have not
been independently executed for this repository. Consult that page for current
content and duration. Its time estimates differ between sections, so the instructor
must set an explicit workload allowance for any assigned portion.

## Connections to local labs

| Course platform | Conceptual bridge from local work | What local work does not establish |
| --- | --- | --- |
| Alation | Lab 2 classification register, Lab 4 lineage and stewardship decisions | Product navigation, catalog administration, policy workflows or dashboard proficiency |
| Snowflake | Optional Module 4 workshop; cloud/on-premises comparison, SQL and data loading | Local checks do not verify workshop completion, warehouse administration or cloud operations |
| Apache Airflow | Ordered ingestion/transformation steps and dependency reasoning | Scheduling, retries, orchestration operations or Airflow access administration |

External activities supplement the self-contained local sequence. Students cloning
this repository can complete all local labs without institutional platform access.

## When the instructor assigns an external exploration

The LMS activity must specify the platform, authorized access route, expected time,
synthetic dataset, task, evidence and no-cost alternative. Record the version or
observation date. Do not publish tenant URLs, account details, screenshots with
identities, or service credentials. Do not create paid resources without explicit
course instructions covering costs and cleanup.

Use a short comparison: concept, local evidence, external observation, difference,
and limitation. A product demonstration is observation, not proof that the student
administered it. A documentation-only alternative can assess explanation but must
not be marked as equivalent to an executed product-specific skill.

---

Author: [Isaac K. Nti](../AUTHORS.md).
