# Reproducibility and security verification

## Published Ubuntu result

The published base commit `527559b6502dbdd12eca6e2d3b3bee7e63baf04c` passed
[workflow run 35352357594](https://github.com/ntious/IT4065C-Labs/actions/runs/35352357594)
on **Ubuntu 22.04 and 24.04**: setup, configuration tests, nine labs twice with
failure recovery, optional ingestion/publication, and a non-default configuration.

New Optional Labs 12–14 passed local PostgreSQL 17.11/Python 3.12 executions with
default and alternate role names. Checks included server CSV correlation, actual
source shutdown/recovery, TLS negative controls and password rotation. Generated
passwords were checked absent from saved logs/evidence. Teaching servers stopped.
The expanded Ubuntu workflow executes these experiments twice after publication;
that new workflow has not yet run. Local tests do not establish Ubuntu/WSL behavior.

Optional Lab 15 is a human-assessed case, not an executable check. An instructor
walkthrough is documented separately and does not substitute for real student pilots.

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

Follow the [optional prerequisites](../labs/extensions/infrastructure_setup.md), then:

```bash
.venv/bin/python scripts/infrastructure_labs.py audit
.venv/bin/python scripts/infrastructure_labs.py transfer
.venv/bin/python scripts/infrastructure_labs.py tls
```

Each uses fresh private instances and stops them. The same commands can be repeated
without resetting the core dataset. Save only redacted evidence excerpts privately.

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
