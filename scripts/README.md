# Course commands

`preflight.py` checks installation prerequisites without changing files or services.
Run `python3 scripts/preflight.py` before setup; see its `--help`.

`setup.sh` installs the Ubuntu environment. `course.py` is the shared configuration,
provisioning and lab runner. Run `.venv/bin/python scripts/course.py --help`. SQL templates
with `{{schema}}` are executed by the runner, not pasted directly into psql.

`query.py` executes your own local SQL file using the same configuration and a
selected non-administrator role. Follow the [practice guide](../labs/practice/README.md).
`verify.py` rehearses every lab twice and tests failure recovery on the original
synthetic fixture. See [validation](../docs/validation.md) before running it.

`infrastructure_labs.py` runs Optional Labs 12–14 on newly created, loopback-only
instances, stopping them after each run. Follow the [optional setup](../labs/optional/infrastructure_setup.md).
It never connects to the core database.

---

Author: [Isaac K. Nti](../AUTHORS.md). [Citation and reuse terms](../CITATION.md).

## Public external-link monitoring

Run `python3 -m scripts.check_external_links` from the repository root. The weekly
and manually dispatched workflow writes a report to its Actions job summary.
It checks only tracked public Markdown inline links/autolinks outside fences,
retries transient failures and marks authentication/rate limits for review.
Query/credential URLs and remote fragments are excluded. No private files are
scanned and no learner logs are uploaded. Potential failures are advisory: verify
in a browser before changing a source link. Local file/anchor checks remain in
the mandatory repository tests. Keep any local reports in an ignored directory.
