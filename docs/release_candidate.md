# Teaching release candidate

This working revision adds Optional Labs 12–15, guided learning progression and a
student walkthrough. It is a release candidate, not a published version tag.

## Included changes

- Optional server CSV audit investigation with positive/negative query evidence.
- Optional transfer across two independent local PostgreSQL instances, actual source
  shutdown, preserved target, recovery timing and safe retry.
- Optional verified TLS, wrong-trust/hostname/plaintext rejection and credential rotation.
- Optional primary-source governance case with control mapping and stewardship memo.
- Explicit student/core and instructor/rehearsal routes, private configuration and recovery.

## Verified and pending

The published base commit `527559b6502dbdd12eca6e2d3b3bee7e63baf04c` passed
[Ubuntu workflow 35352357594](https://github.com/ntious/IT4065C-Labs/actions/runs/35352357594).
New infrastructure experiments passed locally with PostgreSQL 17.11, first with default
roles and then with alternate roles. Negative controls, stopped instances and absence
of generated passwords from saved logs/evidence were checked. See validation for scope.

Before publishing a stable release: push these changes, require the expanded Ubuntu
22.04/24.04 matrix to pass, complete human pilots or document their outstanding status,
and review historical credential remediation. The maintainer then chooses the version
and creates a tag pointing to the tested commit. Do not label the course fully
syllabus-complete solely because optional activities exist.

## Limits to retain in release notes

Batch transfer is not automatic failover or streaming replication. Same-host instances
share a failure domain. Student-owned server logs are not independently protected
audit records. TLS protects transport, not files/backups. Password rotation does not
terminate established sessions. The governance activity is educational analysis.
These boundaries should remain visible when other instructors adapt the course.

---

Author: [Isaac K. Nti](../AUTHORS.md).
