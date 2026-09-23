# Lab 1: Environment readiness

**Outcomes:** SLOs 3,4. **Estimated time:** 30–60 minutes first setup; allow additional time for installation and support.
**Environment:** your dedicated local course database. Synthetic data only.

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

**Check your understanding:** Explain why a successful connection does not guarantee
that a later model will run or its data will be correct. Give one possible connection
failure, one SQL/model failure and one data-quality failure, and identify the evidence
you would inspect for each. These are hypothetical examples for your explanation;
you do not need to cause failures in your working environment.

**Transfer:** Consider moving this local exercise to a shared remote server. Identify
one change needed to protect connections and one change needed to manage credentials
or access. Explain why each matters. This is a written proposal, not an additional
installation task; Lab 1 does not demonstrate those remote controls.

> **Completion:** The PASS lines provide your technical evidence. Complete the
> investigation and written responses below to finish Lab 1. No repeat check is
> required after successful setup.

## Before you begin

Start with the [foundations bridge](../../docs/foundations.md) if needed, then complete
[setup](../../docs/setup.md). No earlier lab is required.
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

Read `.env.example`, `dbt/it4065c_platform/profiles.yml`, and the `connect` method in
`scripts/course.py`. Draw how configuration reaches the client and server without
hardcoding a password. Explain why an Ubuntu sudo password and a database password
have different purposes. Do not put either password in your submission.

For custom SQL, use the [query helper instructions](../practice/README.md#execute-your-own-sql-without-managing-passwords).

## Interpret and transfer

Explain the difference between your Linux account, builder login, analyst login and schema. Why does a schema name alone not enforce access?

## Submit

Create a private Lab 1 submission using the [shared template](../../submissions/template.md).
Leave the repository template unchanged. Include the following required evidence
and written work; the written work is not printed by setup:

1. **Execution evidence:** record `bash scripts/setup.sh` (or the standalone Lab 1
   command if that is what you ran). Copy these two lines **from your own output**:

   ```text
   PASS: connection, dedicated database, schemas and non-superuser builder.
   PASS: dbt debug
   ```

   This is an example of the expected excerpt, not evidence to copy without running
   setup. No package download list, full terminal transcript or screenshot is needed.
   The completion message may differ across repository versions; the PASS checks
   above are the relevant evidence.
2. **Prediction field:** if you did not record a prediction before automatic setup,
   write "Not recorded before automatic setup checks." Do not invent one afterward.
3. **Investigation artifact:** provide a diagram or text flow showing how private
   configuration reaches the client and database. Label roles without including
   actual passwords or personal account names. Use the public example file and
   source references listed above, not a copy of your private `.env`.
4. **Your explanation:** distinguish the Linux account, builder login, analyst login
   and schema; explain why knowing a schema name grants no privilege. Explain the
   different purposes of the sudo and database passwords. Address the concept
   question about connectivity, SQL correctness and data quality.
5. **Transfer and limitation:** explain what would need to change on a shared remote
   server, and identify one claim that the local checks do not establish. These are
   reasoned proposals, not additional infrastructure you must install in Lab 1.
6. **Assistance disclosure:** complete the template's assistance field, including
   "None" when applicable.

Items 3–6 are written by you; they are not generated by setup. Submit privately
through the course system, or keep your work locally for independent study. Remove
personal shell prompts and never include configuration secrets.

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
