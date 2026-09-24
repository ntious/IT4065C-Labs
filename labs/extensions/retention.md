# Optional Lab 8: Retention and deletion

**Outcomes:** SLOs 2, 5. **Time:** 45–60 minutes.
Optional enrichment; no new required assessment. Synthetic data only.

## Why this lab matters

Deleting a live record does not prevent an older backup from restoring it. This temporary-table experiment connects expiry, legal holds and a deletion ledger.

## Learning objectives

These instructor-developed objectives support the outcomes above. You will:

- Predict which records survive expiry and legal-hold rules.
- Verify an added held record survives deletion and replay after restoration.
- Explain what a real backup and retention design still needs.

## Skills you will practice

Read boolean conditions, adapt a supplied assertion, and distinguish a simulation from production deletion.

## Before you begin

[Lab 4](../module_3/lab4/README.md) introduces downstream copies; [Lab 2](../module_2/M2_lab2_governance.md) introduces retention decisions.
Use the existing configured Ubuntu environment; do not repeat setup. New learners
start with [Student start here](../../STUDENT_START_HERE.md). Run each command
separately from the repository root. No prior SQL qualification is assumed.

## Part A: Run the unchanged example

### A1. Execute the supplied checks

```bash
.venv/bin/python scripts/course.py lab 8
```

Expected:

```text
PASS: connection, dedicated database, schemas and non-superuser builder.
PASS: retention, legal hold and deletion-ledger replay after simulated restoration.
LAB 8 COMPLETE: technical checks passed; review interpretation and deliverables in labs/README.md.
```

### A2. Read what was checked

Read [the supplied SQL](retention.sql). The initial records are:

| ID | Expired | Legal hold | Expected after deletion and after replay |
| --- | --- | --- | --- |
| 1 | true | false | Removed |
| 2 | true | true | Retained |
| 3 | false | false | Retained |

`true`/`false` are boolean values. The ledger records IDs approved for deletion.
Restoration temporarily brings ID 1 back; replay removes it again. The script uses
transaction-scoped temporary tables and finishes with `ROLLBACK`. It does not
perform actual backup restoration or remove course raw data.

## Part B: Adapt and explain the experiment

### B1. Copy the supplied SQL into your private workspace

Run separately:

```bash
mkdir -p .local
```

```bash
cp -i labs/extensions/retention.sql .local/retention-experiment.sql
```

```bash
nano .local/retention-experiment.sql
```

On a repeat attempt, answer **n** if asked to overwrite your private file.
The file already contains runnable SQL. Edit only this copy.

### B2. Add a held record and check both deletion stages

1. Replace the existing `INSERT INTO retention_records VALUES ...` line with:

   ```sql
   INSERT INTO retention_records VALUES (1,true,false),(2,true,true),(3,false,false),(4,true,true);
   ```

   The positions are **id, expired, legal_hold**. Record 4 is expired but held.
2. In the first assertion change `<> 2` to `<> 3`: IDs 2, 3 and 4 should remain.
   `<>` means "not equal"; an assertion raises an error if the result is wrong.
3. Paste this block **after each of the two `DELETE FROM retention_records ...;`
   statements**. Keep both original assertion blocks as well.

   ```sql
   DO $$ BEGIN
     IF NOT EXISTS (SELECT 1 FROM retention_records WHERE id=4 AND legal_hold)
     THEN RAISE EXCEPTION 'Held record 4 missing'; END IF;
   END $$;
   ```

   This checks the hold after the initial deletion and after restore/replay.
4. Keep the final `ROLLBACK;`. Save with **Ctrl+O**, **Enter**, **Ctrl+X**.

### B3. Execute and interpret your private experiment

```bash
.venv/bin/python scripts/query.py .local/retention-experiment.sql
```

Expected:

```text
PASS: connection, dedicated database, schemas and non-superuser builder.
[]
```

`[]` means the final statement returns no rows; it is not a list of surviving IDs.
The absence of a SQL error means the assertions completed. They check the conditions
you wrote; they do not prove every retention requirement. `ROLLBACK` removes the
temporary experiment's changes. Do not query the temporary tables in a new session.

Write the predicted survivors after deletion and after replay, explain the new
hold check, and identify what would fail if held record 4 were removed. No deliberate
failure injection is required.

### B4. Make your own lifecycle recommendation

Draw or describe live data, derived tables, exports, backups and model-training
copies. Choose one copy the experiment does not handle and propose its owner,
retention/review rule and verification evidence. Explain how a protected deletion
ledger and an actual backup policy differ from these temporary tables. This is a
proposal; do not delete real records or invent a legal retention period.

## Submit

Use the [submission template](../../submissions/template.md). Include:

- A1 completion output; the edited private SQL; B3 output and survivor explanation; and the B4 copy/retention recommendation.
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
