# Lab 1: Environment readiness

**Outcomes:** SLOs 3,4. **Estimated time:** 30–60 minutes first setup; allow additional time for installation and support.
**Environment:** your dedicated local course database. Synthetic data only.

## Why this lab matters

A working environment lets you concentrate on the course concepts. You will read
setup's checks and distinguish the identities involved before editing any SQL.

## Learning objectives and skills

These instructor-developed objectives support SLOs 3 and 4. You will identify the
configuration-to-database path, distinguish an Ubuntu account from a database
login, and explain the limits of a connection check. You will practice reading
short output and recording a supported explanation. No Python or YAML reading is
required for this first activity.

## Your route

- [ ] Review the two setup PASS lines below.
- [ ] Complete the three blanks and three short answers in the worksheet.
- [ ] Save your evidence and move to Lab 2.

## Terms you need for this lab

| Term | Meaning here |
| --- | --- |
| Client / server | The course script requests work; PostgreSQL handles it. |
| Localhost / port | The local network endpoint and service number used to connect. |
| Python virtual environment | The `.venv` folder holds Python packages; it is not a separate Ubuntu machine. |

Use the [glossary](../../docs/glossary.md#course-and-environment) for more detail; this is reference support, not another assignment.

## Concept

Lab 1 checks whether your local environment is ready for the course. Setup performs
these checks automatically and prints a short summary. Read the two PASS lines as
follows:

| Output you see | What the check establishes | What it does not establish |
| --- | --- | --- |
| `PASS: connection, dedicated database, schemas and non-superuser builder.` | The runner connects as the expected builder, finds the course database marker and required schemas, and checks that the builder lacks the administrative role attributes tested by the runner and that course roles have no unexpected memberships. | It does not test every user's access to every table or prove that the entire system is secure. |
| `PASS: dbt debug` | dbt's configuration and connection checks succeed for this local project. | It does not build the models or test the quality of their data. Those checks come later. |

### Understand the accounts

Your **Ubuntu account** runs commands and manages local files. With permission,
`sudo` lets it perform administrative setup tasks such as installing PostgreSQL.
Your **database logins** have separate credentials and database permissions.
Being able to run `sudo` does not demonstrate what a database login is allowed to do.

Setup creates a **builder**, **analyst** and **steward** login. The builder creates
course objects without superuser, database-creation or role-creation privileges.
The analyst and steward are separate identities whose allowed and denied queries
are investigated in Lab 5. Creating these logins during setup is different from
checking their later access behavior.

The private `.env` file stores configuration that the runner reads as data. It is
not a shell script. Use `.env.example` when discussing the settings; never submit
`.env` or any password.

A connection check, a model check and a data-quality check answer different questions:

| Check | Example problem it could reveal |
| --- | --- |
| Can the client connect? | The local database service is stopped. |
| Can the SQL run? | A query uses a column name that does not exist. |
| Are the records suitable? | A required identifier is missing even though the query runs. |

Read these as examples; do not introduce failures into your database. Later labs
investigate SQL, data quality and access restrictions directly.

> **Completion:** The PASS lines provide your technical evidence. Complete the
> investigation and written responses below to finish Lab 1. No repeat check is
> required after successful setup.

## Before you begin

Follow the [single installation route](../../docs/local_run.md). Use
[Foundations Part B](../../docs/foundations.md#part-b-after-setup-before-the-lab-1-worksheet)
if the identity terms below are new. No earlier lab is required.
The runner checks its required state and reports missing prerequisites.

## Review your setup result

Setup completes the technical-check portion of Lab 1 automatically. If setup
succeeded, **do not run the check again**. Use its PASS lines as your execution
evidence and continue to **Hands-on investigation** below.

Near the end of a successful setup, look for these two lines:

```text
PASS: connection, dedicated database, schemas and non-superuser builder.
PASS: dbt debug
```

These are the required terminal results for Lab 1. Installation and provisioning
messages give context but are not additional required submission evidence.
The completion banner begins with `LAB 1 CHECKS PASSED`. The investigation and
written evidence below complete the lab activity.

If setup failed, follow the recovery guidance before continuing. You do not need
to reinstall packages or regenerate credentials after a successful setup.

### Optional: rerun the technical check

Use this only after fixing an error, changing configuration, or if you need to
recapture the check output. From the repository root in your Ubuntu terminal:

```bash
.venv/bin/python scripts/course.py lab 1
```

Rerunning is safe and preserves existing raw and governance data. It is not an
additional required step after successful setup.

## Hands-on investigation

This is a writing task. Use a private document or a copy of the
[submission template](../../submissions/template.md); do not type answers into the terminal.

### 1. Complete the configuration path

The Ubuntu account starts the runner. The runner reads private configuration as
data and passes the connection settings to the database client. PostgreSQL checks
the database login and its privileges.

Copy this text flow and replace its three blanks using **PostgreSQL**, **Ubuntu
account**, and **private .env configuration**. No actual names or passwords belong here.

```text
[Blank 1] starts the course runner.
The runner reads [Blank 2] and supplies settings to the client.
The client connects to [Blank 3], which checks the database login.
```

The supplied example is enough to complete this task. You do not need to draw a
new diagram or inspect implementation code.

### 2. Write three short explanations

Use two or three sentences per answer. The concept table and
[identity definitions](../../docs/foundations.md#part-b-after-setup-before-the-lab-1-worksheet)
provide the information you need.

1. Which account saves a file and uses sudo for authorized installation? Which
   identity does PostgreSQL check? Explain why their passwords serve different purposes.
2. The builder creates course objects; the analyst later reads approved views.
   A schema is a named group of objects. Why would knowing a schema name alone
   not give the analyst permission to read a table inside it?
3. Why does `dbt debug` passing not guarantee that a later SQL model or its data
   is correct? Use one example from the concept table and state one limit of the
   setup evidence. You are explaining a hypothetical, not reporting a failure you ran.

These are the complete interpretation and transfer responses for this lab. Remote
server design is discussed after access control in Lab 5; you do not need to design
it before learning the local identities.

<details>
<summary>Optional deeper reading: how the implementation connects</summary>

Read the public [.env example](../../.env.example),
[dbt profile](../../dbt/it4065c_platform/profiles.yml) and the `connect` method in
[the runner](../../scripts/course.py). Trace where the settings are read.
This is optional implementation reading, not additional submission evidence.
Use the public example rather than publishing your private configuration.

</details>

## Submit

Keep one private record containing:

- Lab number and the setup command you actually ran.
- Your own two relevant PASS lines from setup.
- The completed three-blank flow and three short answers above.
- The assistance disclosure from the shared template, including `None` when applicable.

For the prediction field, write `Not required for this activity` unless you
actually recorded an expectation before setup. Do not invent one afterward.
The third answer already contains your limitation; do not repeat it in another essay.
Text evidence is sufficient. Submit via the LMS when enrolled, or retain privately
for self-study. Omit credentials and personal terminal details.

**Safe stopping point:** save this record; installation is finished. Next time,
follow [stop and resume](../../docs/local_run.md#stop-and-resume), then begin Lab 2.

Rubric: correct execution/evidence 25%; accurate interpretation 35%; transfer and
tradeoff reasoning 30%; clarity and evidence limitations 10%.

## Recovery

Use the [setup troubleshooting table](../../docs/setup.md). Read errors before retrying;
never delete tests or change authentication to make a result pass. There is no
automatic destructive reset. For an isolated new start use a new DB/user pair.

[Back to all labs](../../labs/README.md)

## Next lab

After completing this lab's technical check and written evidence, continue to
[Lab 2: Classification and stewardship](../module_2/M2_lab2_governance.md).

---

Author: [Isaac K. Nti](../../AUTHORS.md). [Citation and reuse terms](../../CITATION.md).
