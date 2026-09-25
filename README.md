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

Choose [Windows with WSL2 or native Ubuntu](docs/local_run.md), then follow the
single installation route there. Ubuntu 24.04 is recommended; 22.04 is also supported.
Other Linux distributions and macOS can use an Ubuntu VM; their native installation
routes are not verified. The [validation record](docs/validation.md) names tested environments.

Setup automatically performs Lab 1's technical checks. After installation, complete
its writing activity, then Labs 2–7 in order. Labs 8–15 are optional. Use the
[required course path](docs/course_checklist.md) for the required course path, including the
short discussions and capstone, or the [self-study guide](docs/self_study.md) to
choose a personal learning scope. You do not need to read every reference page first.

For help while learning, use the [foundations bridge](docs/foundations.md),
[glossary](docs/glossary.md), or [setup and recovery reference](docs/setup.md).
The [documentation index](docs/README.md) holds curricular and maintenance
references; these are not additional student assignments.


## What this environment demonstrates

Raw synthetic records flow through dbt staging, core and reporting models.
Separate database logins demonstrate allow/deny behavior. Lab 6 distinguishes
observed query outcomes from fabricated incident data. Core Lab 7 addresses AI
governance. Optional labs address retention/deletion and snapshot staleness. The snapshot exercise is
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
