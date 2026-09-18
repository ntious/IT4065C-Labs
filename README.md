# IT4065C: Data Technologies Administration

**Author:** [Isaac K. Nti](AUTHORS.md). [Cite this repository](CITATION.md).

Learn to classify, model, protect and evaluate a synthetic retail data platform.
All required repository materials for the local labs are included. Installation
requires internet access, Ubuntu/WSL, sudo permission and the packages described
in the setup guide. No institutional account or paid service is required.

[![Course checks](https://github.com/ntious/IT4065C-Labs/actions/workflows/course.yml/badge.svg?branch=main)](https://github.com/ntious/IT4065C-Labs/actions/workflows/course.yml)

## Start here

- **Students:** [Student start here](STUDENT_START_HERE.md).
- **Instructors:** [Instructor start here](INSTRUCTOR_START_HERE.md).

Use an **individual Ubuntu 24.04 VM or Ubuntu 24.04 in WSL2**. See the [dated validation record](docs/validation.md) for the exact tested commit. Open its Ubuntu terminal:

```bash
git clone https://github.com/ntious/IT4065C-Labs.git
cd IT4065C-Labs
bash scripts/setup.sh
```

Setup installs PostgreSQL and a private Python environment, generates unique local
passwords, provisions a dedicated database, and checks Lab 1. It asks for your
Linux sudo password; it never asks for university credentials. Read the
[setup guide](docs/setup.md) for prerequisites, custom settings and recovery.

Then run one lab at a time:

```bash
.venv/bin/python scripts/course.py lab 2
```

Use numbers **1–7** for the revised core course, including AI governance, and
**8–9** for additional lifecycle/infrastructure experiments. Optional Labs **10–15**
use the separate commands or reading activities in the [lab index](labs/README.md). A `PASS` message
means an actual check passed. No manual password exports or dbt profile edits are
needed. Instructors can use `.venv/bin/python scripts/course.py all` to rehearse Labs 1–9;
this includes optional 8–9 and does not run the newer optional activities.

| Where to go | Purpose |
|---|---|
| [Foundations bridge](docs/foundations.md) | Supportive terminal, SQL and identity self-check |
| [Module learning map](docs/module_learning_map.md) | Preparation, required evidence and optional enrichment |
| [Learning progression](docs/learning_progression.md) | Worked examples, supported practice and independent tasks |
| [Glossary and system overview](docs/glossary.md) | Plain-language terms and the path through the platform |
| [Course platforms](docs/platforms.md) | Local requirements and occasional external exploration |
| [Lab sequence](labs/README.md) | Commands, expected results, estimated time and deliverables |
| [Configuration and setup](docs/setup.md) | One private .env, restart and troubleshooting |
| [Instructor-developed public course framework](Public_Syllabus.md) | Outcomes, module map and public/private boundary |
| [Capstone](capstone_project/README.md) | Stakeholder case, architecture and evidence portfolio |
| [Student project showcase](docs/student_projects.md) | Student-created final projects and questions for exploring their work |
| [Instructor runbook](docs/instructor.md) | Preparation, pacing, assessments and verification |
| [Security](SECURITY.md) | Safe use and private reporting |
| [Validation](docs/validation.md) | Verified environments, checks and demonstration boundaries |
| [Changes](CHANGELOG.md) | Migration from the older course edition |

## What this environment demonstrates

Raw synthetic records flow through dbt staging, core and reporting models.
Separate database logins demonstrate allow/deny behavior. Lab 6 distinguishes
observed query outcomes from fabricated incident data. Extensions address AI
governance, retention/deletion and snapshot staleness. The snapshot exercise is
explicitly single-instance; it is not a multi-cluster deployment.

The supported setup is disposable and local. It is not a production deployment
or a shared university database. Do not import real student/customer data.
Submissions and generated logs stay private; do not open public issues with them.

Original code: [MIT](LICENSE). Original curriculum: [CC BY 4.0](LICENSE-CONTENT.md).
These licenses exclude University and third-party materials unless expressly stated
otherwise; see the [ownership and licensing notice](AUTHORS.md).

## Institutional context and instructional authorship

IT4065C is offered by the University of Cincinnati School of Information Technology;
consult its [official course descriptions](https://www.cech.uc.edu/Academics/school-of-information-technology/course_descriptions.html)
for public institutional information. This independently maintained teaching
repository contains instructional materials developed by Isaac K. Nti; see
[AUTHORS.md](AUTHORS.md#institutional-context-and-instructional-authorship) for the
full institutional, authorship and licensing notice.
