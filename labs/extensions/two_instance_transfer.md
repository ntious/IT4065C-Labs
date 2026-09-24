# Optional Lab 13: Two-instance transfer and recovery

> **Completion:** Passing automated checks, where present, confirms technical behavior.
> Complete the independent task, explanation and evidence specified on this page.

**Connection:** SLOs 2–3; Modules 3 and 4. **Time:** 60–90 minutes.
Complete [Lab 4](../module_3/lab4/README.md) and the [infrastructure comparison](../../docs/module_learning_map.md). Read [optional setup](infrastructure_setup.md).

## Why this lab matters

An interrupted transfer should leave the last valid target batch intact. You will test this with two actual local instances, then interpret freshness and shared-host limits.

## Learning objectives

These instructor-developed objectives support the outcomes above. You will:

- Verify the source and target are distinct PostgreSQL instances.
- Explain target state during an outage and after an idempotent retry.
- Propose a freshness check and compare deployment responsibilities.

## Skills you will practice

Read recovery evidence, interpret measured durations, and diagram data copies.

## Part A: Run and inspect the supplied experiment

Predict whether the target should retain its last valid batch while the source is
unavailable, and whether retrying should duplicate records.

```bash
.venv/bin/python scripts/infrastructure_labs.py transfer
```

Expected: PASS, two stopped instances, and private evidence reporting two recovered
records totaling 30, one missing record during outage, and an idempotent retry.
Distinct PostgreSQL cluster identifiers are checked, not just distinct table names.

### Open your evidence

Run from the repository root in Ubuntu. On success the runner prints:

```text
Private run directory: .local/infrastructure/transfer-<unique suffix>
PASS: optional transfer assertions verified; teaching instances stopped. Read evidence.json and complete the reflection.
Read your results with:
.venv/bin/python -m json.tool .local/infrastructure/transfer-<unique suffix>/evidence.json
```

**Copy the complete evidence command from your own terminal**, where the actual
suffix is already filled in, and run it. The angle-bracket text above explains
where a generated value appears; do not paste it as a command. Each run gets a
new directory. Read the file from the run that just passed, not a previous run.
This command displays JSON without changing it; the experiment's servers have stopped.

| Field | Expected | Interpretation |
| --- | --- | --- |
| `distinct_cluster_ids` | `true` | Separate database instances, not two tables in one instance |
| `outage_preserved_target` | `true` | Failed copying did not erase the previous publication |
| `missing_records_during_outage` | `1` | One committed source record was absent from the target |
| `recovered_records` / `recovered_total` | `2` / `30` | Recovery copied both records |
| `retry_idempotent` | `true` | A repeat transfer did not duplicate them |
| Both `observed_..._seconds` fields | Non-negative numbers that vary | Measurements for your run, not required target values |

The fixture starts with one target record totaling 10; during the outage that
record remains; recovery produces two records totaling 30. The report summarizes
these assertions rather than printing every intermediate table. Label the initial
count as the fixture state checked by the runner, not a separate manual SELECT.

### Read the implementation

Read `transfer()` in the runner. A restricted source reader feeds a target identity
with rights only to its fixture table. Each publication is a transaction. The source
is stopped after a new record is committed; the failed transfer must leave the target
unchanged. Restart and another transfer recover the new record.

Inspect observed staleness and restart-plus-transfer durations. These are measured
for this run, including orchestration overhead, not guaranteed service objectives.
The interruption is an actual source shutdown, not a simulated network partition.
This is manual batch copying, not streaming replication or automatic failover.

## Part B: Explain and propose a different design

Write these responses in your private submission. No runner edits, extra accounts
or live infrastructure changes are required. Text diagrams/tables are sufficient.

Draw the two instances and identities. Label where credentials, committed records
and stale copies exist during interruption. Then propose how a reporting consumer
could distinguish a current result from a stale one. Describe the freshness metadata,
acceptance condition and behavior when the condition fails.

## Submit privately

Provide before/outage/recovery counts, measured durations and one interpretation
limitation. Compare cloud, on-premises and hybrid placement for connectivity,
identity, cost, operational ownership and failure domains. Both instances here share
one machine: this does not demonstrate independent hardware fault tolerance.
Explain why these measurements do not establish production RPO or RTO.

Rubric: evidence 30%; failure/recovery reasoning 30%; deployment comparison 25%;
limitations 15%. Follow [cleanup](infrastructure_setup.md) for both source and target.

Reference: [PostgreSQL server startup](https://www.postgresql.org/docs/16/server-start.html)
and [transactions](https://www.postgresql.org/docs/16/tutorial-transactions.html).

---

Author: [Isaac K. Nti](../../AUTHORS.md). [Citation](../../CITATION.md).
