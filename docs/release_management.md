# Release management

Use this guide to publish a versioned teaching release and preserve its validation
record. The repository contains the seven-lab core and Optional Labs 8–15. No
version tag is recorded as of 2026-09-18; use a verified commit when adopting it.

## Included changes

- Optional server CSV audit investigation with positive/negative query evidence.
- Optional transfer across two independent local PostgreSQL instances, actual source
  shutdown, preserved target, recovery timing and safe retry.
- Optional verified TLS, wrong-trust/hostname/plaintext rejection and credential rotation.
- Optional primary-source governance case with control mapping and stewardship memo.
- Explicit student/core and instructor/rehearsal routes, private configuration and recovery.

## Verification and publication

The complete Ubuntu 22.04/24.04 workflow passed at commit `2f15cc9`, including the
isolated infrastructure experiments. See [validation](validation.md) for the full
commit, run link and assertion scope.

For a versioned release, select the intended commit, confirm its workflow result,
record learner/instructor pilot status and historical credential-review status,
then publish a tag and release notes. Clearly identify any adoption work without
recorded completion. Optional activities do not by themselves establish that all
students met every practical outcome in an adopting institution's syllabus.

## Limits to retain in release notes

Batch transfer is not automatic failover or streaming replication. Same-host instances
share a failure domain. Student-owned server logs are not independently protected
audit records. TLS protects transport, not files/backups. Password rotation does not
terminate established sessions. The governance activity is educational analysis.
Keep these boundaries visible when other instructors adapt the course.

---

Author: [Isaac K. Nti](../AUTHORS.md).
