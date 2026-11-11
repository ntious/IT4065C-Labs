# Run an optional book example

The supplied launcher targets Linux/WSL, a non-root account, Python 3.12 and PostgreSQL 16 server/client tools. The recorded acceptance environment is Ubuntu 24.04.4 with PostgreSQL 16.15. Other environments require their own verification. No cloud account or Docker engine is needed for this route.

Use the repository's [supported setup instructions](../docs/setup.md) to obtain the course Python environment. The lifecycle suite needs `psycopg2-binary==2.9.10`, already in the repository's dependency lock. PostgreSQL must include `initdb`, `pg_ctl`, `psql`, `createdb`, `dropdb`, `pg_dump`, `pg_restore`, `pg_basebackup`, `pg_verifybackup` and the `btree_gist` extension. Bash is required. Installing these dependencies on a fresh OS was not part of the recorded companion run.

From the repository root, select a suite:

```bash
.venv/bin/python textbook-companion/run.py foundations
.venv/bin/python textbook-companion/run.py transactions
.venv/bin/python textbook-companion/run.py lifecycle
.venv/bin/python textbook-companion/run.py reasoning
```

Run one relevant suite rather than all four merely to begin reading. For a complete technical rehearsal:

```bash
.venv/bin/python textbook-companion/run.py all
```

If the server binaries are elsewhere, add `--pg-bin /path/to/postgresql/16/bin`. Use the executable's `--help` for options. The launcher ignores inherited database-target settings, creates new private clusters, and removes its temporary working directories after stopping the servers. The lifecycle suite uses authenticated loopback connections to test login behavior; the other database suites use private Unix sockets.

The launcher reports PASS or FAIL per suite and writes private `summary.json`, execution logs, source hashes and supporting results to a new directory under `.local/textbook-companion/`. A custom `--output` directory must not already exist, so previous evidence is preserved. Do not run low-level SQL or harness scripts directly against a course or production database; several intentionally reset their teaching schemas.

## Read the result

1. Check every selected suite's status in `summary.json`.
2. Inspect the relevant observed rows or assertion results in its transcript.
3. Compare them with the suite's expected results and your prediction.
4. Record the claim, evidence locator, scope, limitation and decision.

Expected SQL errors are deliberate negative controls in several examples. They count as evidence only when the intended condition and final state match. An unrelated connection or syntax error is not a successful denial. The foundations suite validates SQL assertions; it does not compare against a private manuscript file. Execution times are technical observations, not learner-completion estimates.

## Recovery and troubleshooting

| Symptom | Action |
| --- | --- |
| Missing PostgreSQL tool or wrong major version | Check the installation and `--pg-bin`; no cluster is created before this preflight passes. |
| Missing Python dependency | Use the configured course interpreter and unchanged dependency lock. |
| Result directory exists | Choose a new directory; preserve the earlier results. |
| A suite fails | Read its private log and the expected outcome. Preserve the failure before correcting prerequisites or code. |
| A concurrency outcome differs | Record the schedule and load; these examples force particular timing and do not prove all interleavings. |
| Process was forcibly killed | Its temporary directory can remain. Verify that any remaining process belongs to this run before stopping it. Never remove an unrelated database directory. |

Normal completion and handled failures stop the created servers. An operating-system crash or forced kill is outside that cleanup guarantee. Do not change assertion expectations simply to obtain PASS.
