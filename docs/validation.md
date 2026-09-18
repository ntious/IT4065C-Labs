# Reproducibility and security verification

## Published Ubuntu result

At commit `1f69e9090791a7a4895dbd03d5f83acb3bd67280`,
[workflow run 35343609278](https://github.com/ntious/IT4065C-Labs/actions/runs/35343609278)
passed every step on **Ubuntu 24.04**: fresh setup, configuration tests, nine labs
twice with failure recovery, and a non-default database/user/schema rehearsal.
Ubuntu 22.04 failed during hash-checked installation because its older pip resolver
did not bind a transitive `mashumaro[msgpack]` request to the base-package pin.

The correction explicitly pins the extra as `mashumaro[msgpack]==3.14` without
changing the package version or removing hashes. A Python 3.10/pip 22.0.2 local
download and installation passed with this lock. The corrected Ubuntu 22.04 job
must still be rerun after publication. Optional Labs 10–11 are newly added and
have their own CI step; a previous green job does not validate those new changes.

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

## Development evidence

The local development rehearsal used PostgreSQL 17.11, Python 3.12.14, dbt-core
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

Previously published credentials must still be rotated/revoked by their owner.
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
