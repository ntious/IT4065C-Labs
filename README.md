# IT4065C: Data Technologies Administration

**Author:** [Isaac K. Nti](AUTHORS.md). [Cite this repository](CITATION.md).

Learn to classify, model, protect and evaluate a synthetic retail data platform.
This public edition includes everything needed for the local labs; no university
sandbox account, Canvas download, paid service or shared password is required.

## Start here

Use an **individual Ubuntu 24.04 VM or Ubuntu 24.04 in WSL2**. This version passed the full CI workflow. Open its Ubuntu terminal:

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
**8–9** for additional lifecycle/infrastructure experiments. Optional Labs **10–11**
use the separate commands in the [lab index](labs/README.md). A `PASS` message
means an actual check passed. No manual password exports or dbt profile edits are
needed. Use `.venv/bin/python scripts/course.py all` to rehearse the full sequence.

| Where to go | Purpose |
|---|---|
| [Foundations bridge](docs/foundations.md) | Supportive terminal, SQL and identity self-check |
| [Module learning map](docs/module_learning_map.md) | Preparation, required evidence and optional enrichment |
| [Glossary and system overview](docs/glossary.md) | Plain-language terms and the path through the platform |
| [Course platforms](docs/platforms.md) | Local requirements and occasional external exploration |
| [Lab sequence](labs/README.md) | Commands, expected results, estimated time and deliverables |
| [Configuration and setup](docs/setup.md) | One private .env, restart and troubleshooting |
| [Public syllabus](Public_Syllabus.md) | Outcomes, module map and public/private boundary |
| [Capstone](capstone_project/README.md) | Stakeholder case, architecture and evidence portfolio |
| [Student project showcase](docs/student_projects.md) | Student-created final projects and questions for exploring their work |
| [Instructor runbook](docs/instructor.md) | Preparation, pacing, assessments and verification |
| [Security](SECURITY.md) | Safe use and private reporting |
| [Validation](docs/validation.md) | What has actually been tested and remaining limits |
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

Code: [MIT](LICENSE). Curriculum: [CC BY 4.0](LICENSE-CONTENT.md).

## Author and citation

**Isaac K. Nti** is the original author and maintainer. Please [cite this repository](CITATION.md)
when using or adapting it. Curriculum reuse requires attribution under CC BY 4.0;
code redistribution must retain the MIT copyright and permission notice.

See the [syllabus crosswalk and remaining work](docs/syllabus_alignment.md) and
[Windows/Ubuntu local run guide](docs/local_run.md).
