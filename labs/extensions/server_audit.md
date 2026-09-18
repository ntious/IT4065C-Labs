# Optional Lab 12: Server-side audit investigation

**Connection:** SLO 5; Modules 5–6. **Time:** 60–90 minutes.
Complete Labs 5–6 and the [optional setup](infrastructure_setup.md).

## Predict and run

Predict what a completed SELECT, denied UPDATE and denied server-file read should
look like. Then run:

```bash
.venv/bin/python scripts/infrastructure_labs.py audit
```

Expected: PASS for audit and automatic server shutdown. The private evidence file
contains a completed SELECT and an UPDATE denial with SQLSTATE 42501, correlated
to the same server session and reader. The reader is also denied server-file access.

## Guided investigation

Read `audit()` in `scripts/infrastructure_labs.py`. It enables query-duration logging
for the disposable reader only. PostgreSQL CSV logs contain the server-side evidence;
the client separately checks query results and denials. A statement-start record
alone does not prove successful completion. Compare timestamps, role and session
with the selected records in `evidence.json`. Inspect the private CSV only locally.

## Supported practice and independent transfer

Build a table with actor, action, object, result and evidence source for the three
operations. Then propose an additional access rule for a fictional library. Explain
which allowed and denied operations would test it and what log records you need.
Do not change global logging on the main course database.

## Reflect and submit privately

Submit the table, a short redacted evidence excerpt, one false-negative scenario,
and a retention/access policy for audit records. Identify who could alter the logs.
This student owns the OS process and administrator role, so these records are not
independent or tamper-resistant. Logging can contain sensitive SQL; the experiment
uses only synthetic data and does not enable blanket credential-statement logging.
Explain how an independent collector, protected storage and tested retention would
change the assurance. This is native server logging, not a complete audit product.

Rubric: evidence accuracy 30%; correlation and interpretation 30%; access/retention
reasoning 25%; limitations 15%. No changes to core grade weights.

Reference: [PostgreSQL logging and CSV fields](https://www.postgresql.org/docs/16/runtime-config-logging.html).
Recovery and cleanup: [optional setup guide](infrastructure_setup.md).

---

Author: [Isaac K. Nti](../../AUTHORS.md). [Citation](../../CITATION.md).
