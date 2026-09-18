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

The complete Ubuntu 22.04/24.04 workflow passed at commit `71653bf`, including the
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

## Pin a tested baseline before adoption

The review baseline is commit `71653bf77f881a62cda029f5ebc344e6702adb4a`, whose
[workflow](https://github.com/ntious/IT4065C-Labs/actions/runs/35360533985) passed on
2026-09-18. For a fresh clone, `git checkout --detach 71653bf77f881a62cda029f5ebc344e6702adb4a`
selects that baseline. Do not switch an existing student checkout with unsaved work.
This commit predates the independent-review corrections; it is a reproducibility
reference, not a claim that the new corrections have passed Ubuntu CI.

After publishing changes, select the new commit only once its own workflow passes.
Complete and record both human pilots before describing a version as a pilot-tested
teaching release. The maintainer chooses the tag, release notes and adoption date.


---

Author: [Isaac K. Nti](../AUTHORS.md).
