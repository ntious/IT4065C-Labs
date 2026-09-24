# Optional Lab 12: Server-side audit investigation

> **Completion:** Passing automated checks, where present, confirms technical behavior.
> Complete the independent task, explanation and evidence specified on this page.

**Connection:** SLO 5; Modules 5–6. **Time:** 60–90 minutes.
Complete [Lab 5](../module_5/lab5/README.md) and [Lab 6](../module_6/lab6/README.md) and the [optional setup](infrastructure_setup.md).

## Why this lab matters

Server records can corroborate client observations, but they also need access protection and interpretation.

## Learning objectives

These instructor-developed objectives support the outcomes above. You will:

- Correlate an allowed query and a denied query by session and role.
- Distinguish server evidence from client observations and its integrity limits.
- Propose a testable access rule and audit-record policy.

## Skills you will practice

Read evidence fields, identify SQLSTATE 42501 and specify audit ownership.

## Part A: Run and inspect the supplied experiment

Predict what a completed SELECT, denied UPDATE and denied server-file read should
look like. Then run:

```bash
.venv/bin/python scripts/infrastructure_labs.py audit
```

Expected: PASS for audit and automatic server shutdown. The private evidence file
contains a completed SELECT and an UPDATE denial with SQLSTATE 42501, correlated
to the same server session and reader. The reader is also denied server-file access.

### Open your evidence

Run from the repository root in Ubuntu. On success the runner prints:

```text
Private run directory: .local/infrastructure/audit-<unique suffix>
PASS: optional audit assertions verified; teaching instances stopped. Read evidence.json and complete the reflection.
Read your results with:
.venv/bin/python -m json.tool .local/infrastructure/audit-<unique suffix>/evidence.json
```

**Copy the complete evidence command from your own terminal**, where the actual
suffix is already filled in, and run it. The angle-bracket text above explains
where a generated value appears; do not paste it as a command. Each run gets a
new directory. Read the file from the run that just passed, not a previous run.
This command displays JSON without changing it; the experiment's servers have stopped.

| Field | Expected | Interpretation |
| --- | --- | --- |
| `allow.result` | `SELECT completed` | A completion record, not merely statement start |
| `deny.sqlstate` | `42501` | The UPDATE was denied |
| `allow.session` / `deny.session` | Same value | Both records correlate to one session |
| `allow.role` / `deny.role` | Same configured reader | Both actions used the restricted identity |
| `reader_log_access_denied` | `true` | The reader could not read the server log file |

Timestamps and session identifiers vary. Read the timezone printed in the timestamp;
do not assume it is UTC. The file-read denial is a boolean assertion here, not a
third selected CSV record. Your table should identify that difference in source.

### Read the implementation

Read `audit()` in `scripts/infrastructure_labs.py`. It enables query-duration logging
for the disposable reader only. PostgreSQL CSV logs contain the server-side evidence;
the client separately checks query results and denials. A statement-start record
alone does not prove successful completion. Compare timestamps, role and session
with the selected records in `evidence.json`. Inspect the private CSV only locally.

## Part B: Explain and propose a different design

Write these responses in your private submission. No runner edits, extra accounts
or live infrastructure changes are required. Text diagrams/tables are sufficient.

Build a table with actor, action, object, result and evidence source for the three
operations. Then propose an additional access rule for a fictional library. Explain
which allowed and denied operations would test it and what log records you need.
Do not change global logging on the main course database.

## Submit privately

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
