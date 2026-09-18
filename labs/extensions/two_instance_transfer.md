# Optional Lab 13: Two-instance transfer and recovery

**Connection:** SLOs 2–3; Modules 2 and 4. **Time:** 60–90 minutes.
Complete Lab 4 and the infrastructure comparison. Read [optional setup](infrastructure_setup.md).

## Predict and run

Predict whether the target should retain its last valid batch while the source is
unavailable, and whether retrying should duplicate records.

```bash
.venv/bin/python scripts/infrastructure_labs.py transfer
```

Expected: PASS, two stopped instances, and private evidence reporting two recovered
records totaling 30, one missing record during outage, and an idempotent retry.
Distinct PostgreSQL cluster identifiers are checked, not just distinct table names.

## Guided investigation

Read `transfer()` in the runner. A restricted source reader feeds a target identity
with rights only to its fixture table. Each publication is a transaction. The source
is stopped after a new record is committed; the failed transfer must leave the target
unchanged. Restart and another transfer recover the new record.

Inspect observed staleness and restart-plus-transfer durations. These are measured
for this run, including orchestration overhead, not guaranteed service objectives.
The interruption is an actual source shutdown, not a simulated network partition.
This is manual batch copying, not streaming replication or automatic failover.

## Supported practice and independent transfer

Draw the two instances and identities. Label where credentials, committed records
and stale copies exist during interruption. Then propose how a reporting consumer
could distinguish a current result from a stale one. Describe the freshness metadata,
acceptance condition and behavior when the condition fails.

## Reflect and submit privately

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
