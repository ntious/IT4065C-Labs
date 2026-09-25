# Reproducibility and security verification

## Capstone consistency and anchor validation: 2026-09-25

**CI-validated revision:** `af23876ea1b3c0bf6db50b40926dd16cdfbdd34e`.
[Workflow 36150294346](https://github.com/ntious/IT4065C-Labs/actions/runs/36150294346)
passed on Ubuntu 22.04 and 24.04. It includes all 33 repository tests, including
permanent checks for local Markdown heading fragments and regression cases for
renamed and duplicate headings, fenced examples and encoded fragments.

The workflow also completed fresh setup, repeated labs and recovery, named student
tests, optional experiments and non-default configuration. Capstone instructions,
portfolio fields and the fictional example now distinguish proposed controls,
impact and applicability. These results establish technical validation of the
named revision; they do not establish human comprehension or instructor readiness.

## Lab-path migration rehearsal: 2026-09-25

**CI-validated revision:** `da05a646d3f627e65150c523cf944149f2f19d19`.
[Workflow 36096732831](https://github.com/ntious/IT4065C-Labs/actions/runs/36096732831)
completed successfully on Ubuntu 22.04 and 24.04. It included fresh setup, 29
repository tests, repeated labs and recovery, the 39-test student-work rehearsal,
optional experiments and non-default database/user/schema configuration.

The local execution below was assistant-led technical rehearsal, separate from
the author's reported walkthrough. No independent human pilot is claimed.

The reorganized source was exercised in a private temporary copy using the
configured Ubuntu course environment. Labs 1–9 ran twice through `scripts/verify.py`,
including actual failing-data detection, restoration, reader privilege denials,
connection cleanup and notebook execution. Optional catalog ingestion passed;
quality promotion passed twice; isolated server audit, two-instance transfer and
TLS/credential-rotation experiments each passed twice and stopped their instances.

The relocated Lab 2 guided insert, practice queries, expected analyst denial,
Lab 3 named-test checker, Lab 4 documentation generation and Lab 10 teaching
contract also passed. The baseline executed 10 models and 37 tests; adding the two
student tests executed 39 tests with both named results passing. The generated
dbt manifest contains `order_detail_mart` under its new name.

All 555 local Markdown links and section anchors resolved during the migration
review. Lab 15 is a reading/decision exercise: its source links and instructions
were checked, not reported as an executed lab. Human learner and instructor pilots
remain separate validation gates. Fresh installation on both supported Ubuntu
versions is established by the exact workflow linked above, not inferred from this local run.

## Independent-review correction checks: 2026-09-24

The correction set was rehearsed in a temporary source copy against the dedicated
local Ubuntu course database. Lab 3 built 10 models and ran 37 baseline tests.
Adding the guided and sample independent tests in the ignored `student_tests`
directory produced 39 executed tests; both named results were `pass`, with zero
failures. The sample independent rule checked for missing or negative daily sales.
The temporary copy and its private configuration were removed after the run.

These checks validate test discovery and the revised runner handoff. They are not
a fresh-install rehearsal on both supported Ubuntu versions or a human novice
pilot. The published commit's CI result supplies its separate Ubuntu matrix record.

## Published Ubuntu result

Commit `71653bf77f881a62cda029f5ebc344e6702adb4a` passed on 2026-09-18
[workflow run 35360533985](https://github.com/ntious/IT4065C-Labs/actions/runs/35360533985)
on **Ubuntu 22.04 and 24.04**. Both jobs passed fresh setup, configuration checks,
nine labs twice with failure recovery, optional ingestion/publication, each isolated
infrastructure experiment twice, and a non-default database/user/schema rehearsal.

Local PostgreSQL 17.11/Python 3.12 checks also covered alternate experiment role names,
server shutdown and absence of generated passwords from saved evidence/logs. These
results establish the named assertions at the recorded revision. They do not certify
production deployment or replace an interactive learner pilot.

Optional Lab 15 is a human-assessed case, not an executable check. An instructor
walkthrough is documented separately and does not substitute for real student pilots.

## Ubuntu WSL instructional walkthrough: 2026-09-24

The walkthrough continued from the earlier Labs 1–3 rehearsal through Lab 15.
The final execution pass also reran Labs 1–9. Environment: Ubuntu 24.04.4 on WSL,
Python 3.12.3, PostgreSQL 16, dbt-core 1.11.2 and dbt-postgres 1.10.0. The local
source review includes revision `6752e75` plus the accompanying report-layout,
visual and verification-document changes. This is a local verification record,
not a new GitHub Actions result or a fresh-install test.

| Activity | Observed result |
| --- | --- |
| Labs 1–9, sequential final pass | All runners passed; modeling ran 10 models and 39 tests with the two saved Lab 3 student tests. |
| Lab 4 documentation | HTTP response and browser landing page verified; graph opened; `+stg_orders+` selection applied; clean Ctrl+C shutdown verified. |
| Lab 4 writing activity | Source/model paths, materializations, decision-log prompts and retention reasoning rehearsed without deleting source records. |
| Lab 5 queries | Analyst sales allowed, analyst masked data denied with 42501, steward masked data allowed; output columns and nulls checked. |
| Labs 6–7 interpretation | Five live client observations separated from three simulated incident rows; group rates and denominators reconciled; governance/change-review reasoning rehearsed. |
| Optional Labs 8–9 supported edits | Added held record survived both deletion stages; added snapshot record produced count 3 and total 35; assertions passed and transactions rolled back. |
| Optional Lab 10 | Catalog accepted 3 records, quarantined 2, total 45.00; supplied contract ran 2 passing tests; supported category extension ran 3 passing tests. |
| Optional Lab 11 | Duplicate batch rejected, prior publication preserved, retry stable; browser table and meters reconciled to 20.00 + 25.00 = 45.00. |
| Optional Labs 12–14 | Audit correlation and denied log access, distinct-instance transfer/recovery and retry, and all six TLS/rotation assertions passed; instances stopped automatically. Printed evidence-reading commands verified. |
| Optional Lab 15 | Scenario, two-row applicability matrix, change-of-purpose memo and source-reading route reviewed. This is human reasoning, not an executable compliance test. |

Final checks: all 26 repository unit/hygiene tests passed, 478 local Markdown
links and heading targets resolved, and `git diff --check` passed. New images
were visually inspected for readable labels and absence of personal details.

The revised guides separate guided execution from interpretation and transfer,
show commands for reading reports, and state the exact submission artifacts.
New Lab 5 and Lab 11 visuals contain synthetic results without personal prompts,
paths, bookmarks or credentials. Text alternatives remain in the guides.

Private practice files and detailed transcripts stayed outside the public source.
Existing student test files, local configuration and source data were preserved.
The rehearsal did not reinstall Ubuntu, repeat privileged provisioning, validate
paid-platform enrollment, certify production security, or constitute a novice or
replacement-instructor pilot. Those are separate from the tested local lab route.

## Reproduce the checks

Use a disposable individual Ubuntu machine and the unmodified synthetic fixture:

```bash
bash scripts/setup.sh
.venv/bin/python -m unittest discover -s tests -v
.venv/bin/python scripts/verify.py
.venv/bin/python scripts/optional_labs.py catalog
.venv/bin/python scripts/optional_labs.py promotion
```

The verifier runs all nine labs twice, checks reader write denials and connection
cleanup, injects an invalid quantity to require an actual dbt failure, restores the
original value, rebuilds successfully, and executes the metadata notebook from an
empty namespace. Do not use this fixture-specific verifier on your own dataset.
The invalid-data step intentionally prints one failed dbt checkpoint locally;
the verifier succeeds only when the expected data test fails and recovery passes.

`.github/workflows/course.yml` repeats installation and verification on Ubuntu
22.04 and 24.04, then provisions a second database with a different builder/schema
and executes every lab. See the associated commit's Actions results; the existence
of this workflow alone is not proof of a successful run.

## Reproduce optional infrastructure checks

Follow the [optional prerequisites](../labs/optional/infrastructure_setup.md), then:

```bash
.venv/bin/python scripts/infrastructure_labs.py audit
.venv/bin/python scripts/infrastructure_labs.py transfer
.venv/bin/python scripts/infrastructure_labs.py tls
```

Each uses fresh private instances and stops them. The same commands can be repeated
without resetting the core dataset. Save only redacted evidence excerpts privately.

## Local verification record

The local verification rehearsal used PostgreSQL 17.11, Python 3.12.14, dbt-core
1.11.2 and dbt-postgres 1.10.0 on a disposable Windows-hosted database bound to
loopback. All nine labs ran successfully, then the verifier completed both passes,
negative controls and restoration. Each modeling run executed ten models and
37 data tests. The notebook executed without an external dataset.

Configuration tests cover unique generated secrets, refusal to overwrite them,
literal parsing, invalid/duplicate settings, protected POSIX file permissions and
isolation from inherited libpq environment variables. The POSIX permission test
is skipped on Windows and must pass on Ubuntu. A separate authenticated rehearsal
tests the administrator and reader paths with conflicting PGHOSTADDR/PGSERVICE.

These checks prove the specific assertions, not arbitrary edits or every OS,
PostgreSQL release, network topology or institutional sandbox configuration.
Ubuntu package versions are supplied by the distribution; Python dependencies
are pinned with hashes. Initial installation needs internet and sudo access.

## Security remediation boundary

Old binary instructions/screenshots and workbook metadata were replaced by
accessible Markdown. Current examples use synthetic records and generated private
credentials. Private logs and dbt artifacts remain ignored because they may contain
local filesystem identities. The CI workflow does not upload those artifacts.

Owners must rotate or revoke any previously published credentials.
Deleting a file from a new revision cannot revoke a credential or erase prior Git
history, forks and downloads. Historical remediation is a separate owner action.

Lab 6 uses real client query outcomes plus labeled simulated incidents; it does
not establish tamper-resistant server auditing. Lab 9 is a single-instance
snapshot experiment, not a deployed cluster. AI metrics on the small synthetic
fixture cannot establish real-world fairness or regulatory compliance.

## Maintaining dependencies

Edit `requirements.in`, regenerate `requirements.lock` with a reviewed version of
uv (`uv pip compile requirements.in --generate-hashes --no-strip-extras --universal --python-version
3.10 --output-file requirements.lock`), and rerun both Ubuntu jobs before adopting
the update. Keep extras in the generated lock so older supported installers retain
the tested pin. Review advisories and dependency changes; pinning is reproducibility,
not a claim that a dependency has no vulnerabilities.

---

Author: [Isaac K. Nti](../AUTHORS.md). [Citation and reuse terms](../CITATION.md).
