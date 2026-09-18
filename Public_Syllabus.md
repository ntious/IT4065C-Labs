# Public course framework

IT4065C: Data Technologies Administration. This edition uses an open, local Ubuntu,
PostgreSQL and dbt environment to teach governance, lifecycle, modeling, access
control and evidence-based decisions. SQL/Python foundations help; no institutional
account is required. Begin with the [setup guide](docs/setup.md).

## Institutional context

IT4065C is a University of Cincinnati School of Information Technology course.
This independently maintained repository supports instruction and is not an official
University syllabus or policy statement. University documents and course systems
control in the event of inconsistency. Read the full
[institutional context and instructional authorship notice](AUTHORS.md#institutional-context-and-instructional-authorship)
for attribution, ownership and licensing boundaries.

## Optional Python preparation

If you are new to Python or would like a refresher, start with Isaac K. Nti's
[Introduction to Python for Information Technology](https://github.com/ntious/python_foundation).
This beginner-friendly course includes 12 modules with guided notebooks and practice
in variables, conditionals, loops, lists, functions and interpreting errors.

Follow its [quick-start guide](https://github.com/ntious/python_foundation/blob/main/QUICKSTART.md).
New learners can work through the modules in order; returning learners can review
the topics they need. The course provides approximately 12 hours of guided instruction,
with additional time for independent practice. This is optional preparation, not a
formal prerequisite or an additional graded requirement for IT4065C. Use the local
[foundations bridge](docs/foundations.md) for this course's terminal, SQL and database
identity self-checks.

The academic sequence follows the Spring 2026 updated syllabus. SLOs 1–5 are
listed in that syllabus; SLO 6 incorporates the instructor’s subsequent AI governance
update. The official institutional syllabus and LMS govern course administration.

## Learning outcomes

1. Identify the types of data and data sources that fall under data governance.
2. Diagram the most common life cycle of data, from raw to production.
3. Discuss multiple-cluster infrastructure implementations and administration such
   as cloud, on premises, and hybrid.
4. Use a data lifecycle and a data modeling tool.
5. Implement data access security and monitoring.
6. Discuss the ethical implications and governance frameworks of AI development focusing on the challenges of bias mitigation transparency and accountability throughout the data lifecycle.

## Sequence and scope

Governance/classification → modeling → lifecycle → infrastructure comparison →
access security → monitoring → integrated governance/AI → capstone defense.
See the [lab map](labs/README.md) and [assessment map](docs/Assessment_Framework.md).
Lab 7 is required evidence for the added AI governance outcome. Labs 8–11 extend
retention, infrastructure, heterogeneous ingestion and quality-gated publication.
Optional Labs 12–15 extend server audit, two-instance batch recovery, TLS/rotation
and governance applicability. They do not change the seven-lab core.

The local toolchain provides open exercises alongside selected external learning.
The instructor uses Alation University’s Data Intelligence Project and the optional
Snowflake Data Warehousing Workshop (Module 4) as supplements;
see the [platform and access guide](docs/platforms.md). The local sequence does
not claim to assess product-specific Alation/Snowflake proficiency. Single-instance
snapshot and client-observed monitoring exercises have explicit limits. Module 4
emphasizes infrastructure administration, including residency, sovereignty
and cost. Instructors specify the assessed encryption, catalog and orchestration
activities for their offering; the public lab index identifies optional extensions.

Keep credentials, student work, attendance, accommodations, current deadlines and
institutional administration in the private course system. This public framework
does not replace the official current institutional syllabus.

Disclose AI assistance and independently verify results. Never upload secrets or
personal records to an AI service. Assessment emphasizes reasoning and demonstrated
understanding rather than an unverifiable percentage of AI-generated writing.

See the [detailed syllabus crosswalk](docs/syllabus_alignment.md) for module-level
coverage, optional extensions and assessment responsibilities.

---

Author: [Isaac K. Nti](AUTHORS.md). [Citation and reuse terms](CITATION.md).
