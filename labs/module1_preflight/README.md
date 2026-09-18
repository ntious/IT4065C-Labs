# Lab 1: Environment readiness

**Outcomes:** SLOs 3,4. **Estimated time:** 30–60 minutes first setup; allow additional time for installation and support.
**Environment:** your dedicated local course database. Synthetic data only.

## Concept

A client sends a query; PostgreSQL authenticates the login and checks its privileges.
The Ubuntu account controls files and can use sudo when permitted. Database accounts
have separate passwords and privileges. A successful sudo command says nothing about
a database login’s authorization.

Setup is the one administrative phase. The builder subsequently owns only the
course database objects and cannot create databases or roles. Analyst and steward
are separate logins so permission checks include authentication. Never submit .env.
The environment file is configuration data, not a shell script.

**Check your understanding:** Why can `dbt debug` pass while a later model fails?
Connectivity, SQL correctness and data quality are separate checks. Identify one
failure in each category and the evidence you would seek before changing anything.

**Transfer:** Explain how the design would change on a shared remote server:
verified transport, centrally managed credentials, scoped provisioning and access
reviews would need a separate deployment design. This local lab does not configure them.

> **Completion:** Automation passing means the environment checks worked. Complete
> the independent investigation, interpretation and evidence below before submitting.

## Before you begin

Start with the [foundations bridge](../../docs/foundations.md) if needed, then complete
[setup](../../docs/setup.md). No earlier lab is required.
The runner checks its required state and reports missing prerequisites.

## Review your setup result

Setup completes the technical-check portion of Lab 1 automatically. If setup
succeeded, **do not run the check again**. Use its PASS lines as your execution
evidence and continue to **Hands-on investigation** below.

Expected evidence: connection, dedicated database, schemas and non-superuser
builder checks pass, followed by `PASS: dbt debug` and `LAB 1 CHECKS PASSED`.
Older checkouts print `LAB 1 COMPLETE`; that message also refers only to the
technical checks. The investigation and written evidence complete the lab activity.

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

Use the [submission template](../../submissions/template.md). Record
`bash scripts/setup.sh` as your execution command when using the setup result
(or the Lab 1 command if you reran it). Include the
relevant PASS lines or accessible text evidence, your interpretation, one limitation,
and your transfer-task response. A screenshot is optional; crop/redact identities
and never include configuration secrets. Submit privately through your course system;
independent learners keep their work locally. Execution success alone does not
complete the reasoning task.

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
