# Security Policy

## Supported Version

Security fixes are applied to the current `main` branch and current course
edition. Archived semester materials may not receive updates.

## System and Scope

IT4065C-Labs is a public educational framework for PostgreSQL, dbt, data
governance, access control, and audit exercises. Covered components include
executable scripts, SQL, dbt configuration, setup instructions, notebooks,
automation, and dependency manifests.

The repository must use synthetic or appropriately sanitized data. It is not
a production data platform.

## Reporting a Vulnerability

Use GitHub's private vulnerability reporting feature under **Security →
Advisories → Report a vulnerability**. Do not publish suspected
vulnerabilities, credentials, or student data in a public issue.

Provide the affected path, realistic attack path, impact, and reproduction
conditions without including live secrets.

## Threat Model and Trust Boundaries

Potentially untrusted inputs include environment variables, SQL, dbt model
content, datasets, file paths, dependency updates, and pull requests.
Important boundaries include PostgreSQL roles and schemas, the host shell,
student workspaces, local credentials, and GitHub automation.

## Security Invariants

- Database credentials must come from local environment variables or an
  approved secret store and must never be committed.
- Instructions must use dedicated least-privilege course roles rather than
  shared superuser credentials.
- Setup scripts must not permit command injection or destructive operations
  outside the documented lab scope.
- Examples must not expose real personal, institutional, or regulated data.
- Access-control and audit exercises must preserve role and schema boundaries.
- Automation must use least privilege and immutable external action
  references.

## Reportable Findings and Severity Context

Report exposed credentials, privilege escalation, cross-schema access,
command injection, unsafe deserialization, unintended data disclosure,
destructive operations beyond the selected lab, and practical supply-chain or
CI compromise.

Severity depends on whether a finding can escape the student's authorized
local environment or compromise another user, system, credential, or dataset.

## Out of Scope

Pedagogical disagreements, grading issues, architecture hypotheticals without
an executable path, and expected administration of a user's own disposable
database are not security findings.

## Known Limitations

Course exercises simplify enterprise deployment. PostgreSQL, dbt, operating
system, and hosting controls remain external dependencies and require secure
local configuration.
