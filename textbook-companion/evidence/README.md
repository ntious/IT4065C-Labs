# Reference evidence

These summaries describe actual executions of synthetic examples. They contain no real account histories, personal machine paths, credentials or completed learner work. Raw local transcripts are not part of this public package.

| Evidence | Origin and scope |
| --- | --- |
| [Companion execution summary](companion-execution.json) | Fresh private-cluster execution of the four book-example suites; code hashes identify the executed files. |
| [Quality failure and restoration](quality-failure.md) | Observed before/failure/restored states from the separate baseline course engineering rehearsal. |
| [Machine-readable quality extract](quality-failure.json) | Resource counts and failed-test identifiers, without raw rows or identity logs. |

Reference environment: Ubuntu 24.04.4, PostgreSQL 16.15 and Python 3.12.3. The lifecycle suite uses psycopg2 2.9.10. The separate quality rehearsal used dbt Core 1.11.2 and dbt-postgres 1.10.0. These are tested versions, not a claim about every platform or the newest release.

The examples distinguish PostgreSQL execution, SQLite checks, in-memory models and arithmetic. Tests cover stated cases and selected deliberate defects. A previous PASS does not establish that your run succeeded or that a changed source still produces the same result.

The course baseline is `d860dd98256a8090ffc6bd3766c59cb15a553c12`. Companion hashes are recorded separately. Timing is local and variable; no learner-completion estimate, production benchmark, fresh-installation verification or independent disaster-recovery claim is inferred.

Use the [evidence guide](../EVIDENCE.md), reproduce examples through [SETUP.md](../SETUP.md), and retain your own results privately. Report contradictions or failures rather than copying the reference observation as your own.
