# Release management

Use this guide to choose a reproducible revision and record its adoption status.
The repository contains the core lab sequence (1–7) and optional Labs 8–15.

## Validated revisions and adoption status

| Status | Revision and evidence | Meaning |
| --- | --- | --- |
| Historical reproducibility baseline | `71653bf77f881a62cda029f5ebc344e6702adb4a`; [September 18 workflow](https://github.com/ntious/IT4065C-Labs/actions/runs/35360533985) | Earlier layout; retain as historical evidence, not the starting point for the migrated guides |
| CI-validated migration candidate | `da05a646d3f627e65150c523cf944149f2f19d19`; [successful Ubuntu matrix](https://github.com/ntious/IT4065C-Labs/actions/runs/36096732831) | Migrated folders/model; fresh installation and full workflow passed on Ubuntu 22.04 and 24.04 |
| Human-pilot-tested teaching release | Not yet established | Requires recorded novice and replacement-instructor pilots, a selected revision and a release tag |

The named candidate is a reproducible technical baseline, not a claim of human
usability validation. Later commits need their own validation record; success at
one revision does not automatically validate subsequent edits.

## Framework maintenance

Lab 7 uses NIST AI RMF 1.0 as the course's selected reference version. As checked
on 2026-09-24, [NIST reports that the framework is being revised](https://www.nist.gov/itl/ai-risk-management-framework).
Before each offering, check that source, record the selected version in release
notes, and review prompts and rubric references together if changing versions.
A successor's publication does not silently change an existing course assignment.

## Release record

Record the selected tag and full commit SHA, passing Ubuntu workflow URL,
tested Python/dbt/PostgreSQL versions, validated activities, known limits, and
separate novice and replacement-instructor pilot statuses. Use the historical
validation below as evidence for its named revision only. Do not describe a
new revision as recommended or pilot-tested until its own gates are complete.

The lab directories follow the student sequence under `labs/core` (1–7) and
`labs/optional` (8–15). The detailed reporting model is `order_detail_mart`.
When updating an existing instructor checkout, use current guide paths and
regenerate dbt documentation with Lab 4. Previously generated local documentation
belongs to its earlier revision; do not use it as evidence for the updated model.

## Included changes

- Optional server CSV audit investigation with positive/negative query evidence.
- Optional transfer across two independent local PostgreSQL instances, actual source
  shutdown, preserved target, recovery timing and safe retry.
- Optional verified TLS, wrong-trust/hostname/plaintext rejection and credential rotation.
- Optional primary-source governance case with control mapping and stewardship memo.
- Explicit student/core and instructor/rehearsal routes, private configuration and recovery.

## Verification and publication

The migration candidate above passed the complete Ubuntu 22.04/24.04 workflow,
including student-test discovery and isolated infrastructure experiments. See
[validation](validation.md#lab-path-migration-rehearsal-2026-09-25) for its scope.

For a versioned release, select the intended commit, confirm its workflow result,
record learner/instructor pilot status and historical credential-review status,
then publish a tag and release notes. Clearly identify any adoption work without
recorded completion. Optional activities do not by themselves establish that all
students met every practical outcome in an adopting institution's syllabus.

## Updating an instructor rehearsal checkout

Fresh student clones use the ignored `dbt/it4065c_platform/student_tests` directory.
For an existing rehearsal checkout, preserve any learner-created
`lab3_guided_daily_orders.sql` and `lab3_my_sales_rule.sql` files before switching
revisions. Move those two files from `tests` to `student_tests` after updating;
keep only one copy of each test name inside dbt's configured test paths. Do not
move the supplied repository tests. Rerun Lab 3 and its named-results checker.
Do not force-add ignored student work to Git.

## Limits to retain in release notes

Batch transfer is not automatic failover or streaming replication. Same-host instances
share a failure domain. Student-owned server logs are not independently protected
audit records. TLS protects transport, not files/backups. Password rotation does not
terminate established sessions. The governance activity is educational analysis.
Keep these boundaries visible when other instructors adapt the course.

## Pin a tested baseline before adoption

For a new instructor rehearsal, the CI-validated migration candidate can be
selected with:

```bash
git checkout --detach da05a646d3f627e65150c523cf944149f2f19d19
```

Run this only in a fresh rehearsal clone, not a checkout with unsaved work.
This selects the exact tested migration revision. If adopting later corrections,
select their exact commit after verifying that commit's workflow instead.
Record the chosen revision and use its matching guides for the entire rehearsal.

Complete and record both human pilots before describing a version as a pilot-tested
teaching release. Record automated/assistant-led execution separately from a human
instructor walkthrough; neither establishes independent novice or replacement-
instructor readiness. The maintainer chooses the tag and adoption date.


---

Author: [Isaac K. Nti](../AUTHORS.md).
