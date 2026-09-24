# Optional Lab 9: Infrastructure snapshot experiment

**Outcomes:** SLO 3. **Time:** 45–60 minutes.
Optional enrichment; no new required assessment. Synthetic data only.

## Why this lab matters

A report can remain available while its data is stale. You will identify that gap, verify a refresh, and compare who would operate the same process in different deployment settings.

## Learning objectives

These instructor-developed objectives support the outcomes above. You will:

- Locate when a snapshot becomes stale.
- Verify refreshed record count and amount after adding a source record.
- Compare cloud, on-premises and hybrid responsibilities without claiming failover.

## Skills you will practice

Read a snapshot query, adapt count/total assertions, and write a deployment comparison.

## Terms you need for this lab

| Term | Meaning here |
| --- | --- |
| RPO / RTO | Targets for tolerable data loss measured in time / time to restore service. A target is not an observed result. |
| Failure domain / residency | Resources that can fail together / where data is stored or processed. Two instances on one laptop share a failure domain. |

Use the [glossary](../../docs/glossary.md#infrastructure-and-recovery) for more detail; this is reference support, not another assignment.

## Before you begin

[Lab 3](../module_2/lab3/README.md) introduces reporting models; [Lab 4](../module_3/lab4/README.md) introduces stored copies.
Use the existing configured Ubuntu environment; do not repeat setup. New learners
start with [Student start here](../../STUDENT_START_HERE.md). Run each command
separately from the repository root. No prior SQL qualification is assumed.

## Part A: Run the unchanged example

### A1. Execute the supplied checks

```bash
.venv/bin/python scripts/course.py lab 9
```

Expected:

```text
PASS: connection, dedicated database, schemas and non-superuser builder.
PASS: snapshot refresh and stale-data detection. This single-instance simulation does not prove multi-cluster administration.
LAB 9 COMPLETE: technical checks passed; review interpretation and deliverables in labs/README.md.
```

### A2. Read what was checked

Read [the supplied SQL](infrastructure.sql). One source row `(1,10)` is copied
into a snapshot. Row `(2,20)` is then added only to the source. At that point the
source has two rows and the snapshot has one. Refresh copies both rows: count 2,
total 30. Assertions check the stale count gap and refreshed total.
The temporary-table transaction ends with `ROLLBACK`; no persistent replica is created.

## Part B: Adapt and explain the experiment

### B1. Make a private SQL copy

Run separately:

```bash
mkdir -p .local
```

```bash
cp -i labs/extensions/infrastructure.sql .local/snapshot-experiment.sql
```

```bash
nano .local/snapshot-experiment.sql
```

On a repeat attempt, answer **n** to preserve your work if asked to overwrite.

### B2. Add one source record and update the checks

1. Replace `INSERT INTO operational VALUES (2,20);` with:

   ```sql
   INSERT INTO operational VALUES (2,20),(3,5);
   ```

   Positions are **id, amount**. These rows arrive after the snapshot was copied.
2. Change the stale-count comparison from `<> 1` to `<> 2`: operational data
   now has three rows while the snapshot still has one.
3. Replace the final `DO $$ ... END $$;` block, immediately before `ROLLBACK`, with:

   ```sql
   DO $$ BEGIN
     IF (SELECT count(*) FROM analytics_snapshot) <> 3
        OR (SELECT sum(amount) FROM analytics_snapshot) <> 35
     THEN RAISE EXCEPTION 'Refresh failed'; END IF;
   END $$;
   ```

   This checks both count and total after refresh. Keep the first assertion.
4. Keep the final `ROLLBACK;`. Save with **Ctrl+O**, **Enter**, **Ctrl+X**.

### B3. Run and explain the result

```bash
.venv/bin/python scripts/query.py .local/snapshot-experiment.sql
```

Expected:

```text
PASS: connection, dedicated database, schemas and non-superuser builder.
[]
```

The empty list means the final statement returns no rows. Assertions raise an
error if their conditions fail; success is not a printed table of snapshot data.
The transaction is rolled back, leaving course data unchanged.

In your notes, record operational/snapshot counts before refresh and snapshot
count/total after refresh. Explain why a readable snapshot can still be stale.

### B4. Compare deployment choices

Write one short row per placement: **on-premises, cloud, hybrid**. For each, name
who operates it and one consideration for **freshness, failure domains, identity,
connectivity and cost**. Then recommend one placement for a fictional small retailer
and state an assumption that could change your choice. No cloud account is needed.
The experiment measures neither network replication nor production RPO/RTO.

## Submit

Use the [submission template](../../submissions/template.md). Include:

- A1 completion output; your private SQL; B3 output with the before/after explanation; and the B4 comparison and recommendation.
- One explicit limitation distinguishing the temporary-table experiment from a deployed system.

Text evidence is sufficient; screenshots are optional. Submit privately through
the LMS or retain locally for independent study. Never include `.env` or personal
terminal details. The automated completion line does not replace Part B.

Rubric: correct execution/evidence 25%; accurate interpretation 35%; transfer and
tradeoff reasoning 30%; clarity and evidence limitations 10%.

## Recovery

If an assertion fails, compare your private edits with B2 and read the error before
retrying. Do not remove assertions to obtain success. Keep `ROLLBACK` and use only
the temporary tables in the example. The [query helper](../practice/README.md#execute-your-own-sql-without-managing-passwords)
explains SQL errors; the [setup guide](../../docs/setup.md) covers connection problems.

[All labs](../README.md)

---

Author: [Isaac K. Nti](../../AUTHORS.md). [Citation and reuse terms](../../CITATION.md).
