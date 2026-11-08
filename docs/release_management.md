# Release management

Use this guide to choose a reproducible revision and record its adoption status.
The repository contains the core lab sequence (1–7) and optional Labs 8–15.

## Release meanings and current evidence

These are separate records; they need not identify the same commit:

| Record | Meaning | Verified reference as of 2026-11-08 |
| --- | --- | --- |
| Archival release | Fixed scholarly snapshot for citation; preserve its tag and DOI | [v2026.11.07.1](https://github.com/ntious/IT4065C-Labs/releases/tag/v2026.11.07.1), commit `c24e088154cfca35c91dd6f5d80c7ea3617ef920`; use [citation guidance](../CITATION.md) |
| Validated executable revision | Exact source revision with successful automated course evidence | `5068af8664b12317cd0494ea2660515452d63390`, [course workflow 42436042190](https://github.com/ntious/IT4065C-Labs/actions/runs/42436042190); [website workflow 42436042199](https://github.com/ntious/IT4065C-Labs/actions/runs/42436042199) passed separately |
| Teaching release | Revision approved by the instructor for a named offering, with known limits and support arrangements | Approval belongs in the private offering record; no offering approval is inferred from an archive or CI pass |

The archival commit also passed [course workflow 42435781924](https://github.com/ntious/IT4065C-Labs/actions/runs/42435781924).
Neither automated result establishes human usability. Independent novice and
replacement-instructor pilot results remain unrecorded in the public evidence.
A teaching release may be approved with explicitly recorded limitations; describe
it as **pilot-tested** only after the separate pilots and retests are documented.

For a new technical rehearsal, use a fresh clone and select the validated revision:

```bash
git checkout --detach 5068af8664b12317cd0494ea2660515452d63390
```

Use that revision's matching guides throughout. This is a recorded technical
baseline, not an instruction to switch an active cohort. Later maintenance changes
need their own workflow evidence before adoption. Record the offering's selected
SHA/tag, approval date, assigned activities, known limits, support arrangements and
pilot status privately. Keep dates, LMS URLs and participant records offline.
Before changing paths, consult the [compatibility register](compatibility.md).

## History cleanup: 2026-09-25

Two historical literal credentials were removed from published branches and tags.
The current course file tree was unchanged by the rewrite. Pre-cleanup commit IDs
and workflow records below are historical evidence, not fresh checkout targets.

The cleaned baseline is `c768edb67279b8d370132ceb567c0d2a5ca0b141`, validated by
[workflow 36178628941](https://github.com/ntious/IT4065C-Labs/actions/runs/36178628941)
on Ubuntu 22.04 and 24.04. The subsequently published candidate is recorded below.

Replace old clones with fresh clones, preserving private work separately. Never
merge or push old history. RC1 was rewritten from `9a75f787e0153577aeefb20e116f226fc350cbe8` to
`4997bd928a851dd6961291bfac4b64fdb4527f0b`, preserving its course content.
Its reachable history was included in the clean-mirror and fresh-clone scans; RC2 supersedes it for new rehearsals. Rewriting refs
does not erase outside copies or GitHub cached/PR objects. Credential revocation
and server-side removal remain separate checks.

## Validated revisions and adoption status

| Status | Revision and evidence | Meaning |
| --- | --- | --- |
| Historical reproducibility baseline | `71653bf77f881a62cda029f5ebc344e6702adb4a`; [September 18 workflow](https://github.com/ntious/IT4065C-Labs/actions/runs/35360533985) | Earlier layout; retain as historical evidence, not the starting point for the migrated guides |
| Previous CI-validated migration | `da05a646d3f627e65150c523cf944149f2f19d19`; [successful Ubuntu matrix](https://github.com/ntious/IT4065C-Labs/actions/runs/36096732831) | Migrated folders/model; fresh installation and full workflow passed on Ubuntu 22.04 and 24.04 |
| Historical pre-cleanup CI baseline | `2fb0ccb7e92499584d5bfe2fba241699d1a3c29f`; [successful Ubuntu matrix](https://github.com/ntious/IT4065C-Labs/actions/runs/36154605293) | Includes capstone consistency corrections and automated heading-anchor validation; Ubuntu 22.04 and 24.04 passed |
| Human-pilot-tested status | Not yet established in public evidence | Separate from offering approval; requires recorded novice and replacement-instructor pilots and retests |

The named baseline is a reproducible technical baseline, not a claim of human
usability validation. Later commits need their own validation record; success at
one revision does not automatically validate subsequent edits.

<a id="frozen-release-candidate"></a>

## Published rehearsal candidate

`teaching-2026-09-rc2` was published on September 26, 2026. Its fixed commit is
`709e7862d947c5fa0c84d4409afa106205b99e11`; the
[release record](https://github.com/ntious/IT4065C-Labs/releases/tag/teaching-2026-09-rc2)
links [passing Ubuntu workflow 36242017725](https://github.com/ntious/IT4065C-Labs/actions/runs/36242017725).
It remains historical rehearsal material, with independent human pilots pending.
Use its matching guides if reproducing that candidate. Do not move its tag.

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

The recorded baseline above passed the complete Ubuntu 22.04/24.04 workflow,
including student-test discovery and isolated infrastructure experiments. See
[validation](validation.md#capstone-summary-validation-2026-09-25) for its scope.

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

<a id="pin-a-tested-baseline-before-adoption"></a>

## Reproduce the historical cleaned baseline

For a historical rehearsal, the cleaned CI-validated baseline can be selected with:

```bash
git checkout --detach c768edb67279b8d370132ceb567c0d2a5ca0b141
```

Run this only in a fresh rehearsal clone, not a checkout with unsaved work.
This selects the exact tested history-cleanup baseline. If adopting later corrections,
select their exact commit after verifying that commit's workflow instead.
Record the chosen revision and use its matching guides for the entire rehearsal.

Complete and record both human pilots before describing a version as a pilot-tested
teaching release. Record automated/assistant-led execution separately from a human
instructor walkthrough; neither establishes independent novice or replacement-
instructor readiness. The maintainer chooses the tag and adoption date.


---

Author: [Isaac K. Nti](../AUTHORS.md).
