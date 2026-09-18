# Optional Lab 11: Quality-gated publication and a reconciled KPI

> **Completion:** Passing automated checks, where present, confirms technical behavior.
> Complete the independent task, explanation and evidence specified on this page.

**Author:** Isaac K. Nti. **Outcomes:** SLOs 2, 4; supports advanced governance.
**Time:** 60–90 minutes. Optional enrichment.

## Purpose and prerequisites

Complete setup, Lab 3 and optional Lab 10. A reporting pipeline must preserve its last
good publication when a new batch fails. The experiment uses the dedicated course
database and the same private configuration; no new account is needed.

Vocabulary: staging, quality gate, transaction, rollback, idempotency, KPI grain.

## Predict and run

1. Predict the two daily totals and the number of approved records from Lab 10.
   Predict what a duplicated identifier would do to an unguarded revenue total.
2. Run:

   ```bash
   .venv/bin/python scripts/optional_labs.py promotion
   ```

3. The runner publishes the valid batch, attempts an intentionally duplicated batch,
   asserts that publication is blocked and the previous result preserved, then
   retries the valid batch and asserts that it has not created duplicates.
4. Read `.local/promotion-evidence.json` and open `.local/optional-kpi.html` in your
   browser. The accessible table and visual comparison must reconcile to **45.00**:
   20.00 on January 10 and 25.00 on January 11, 2026.
5. Repeat the command. Expect the same publication and the same negative-control result.

## Investigate and transfer

Inspect `publish` in `scripts/optional_labs.py`. Identify the transaction boundary,
staging table, quality checks, publication statements and rollback path. Explain
why moving deletion outside the transaction could destroy the last good result.

Draw an editable ERD for the incoming records and published daily summary, labeling
keys and grain. Design a second KPI and state its denominator, exclusions and
reconciliation rule. Explain which additional checks would be needed for currency,
late arrivals, duplicate batches with changed values and legitimate refunds.

## Evidence and assessment

Submit an ERD source file, predicted/observed totals, the blocked-publication evidence,
a short failure/recovery explanation and your proposed KPI contract. Suggested rubric:
correct evidence 25%, transaction/quality reasoning 35%, model/KPI transfer 30%,
limitations 10%. The report is evidence for this miniature pipeline, not automatic
proof that a different capstone architecture has been implemented.

## Recovery and limits

This runner replaces only `<configured schema>.optional_daily_sales`, a derived table
reserved for this optional fixture, and its own `.local` reports. Do not store your
independent data in that table. Core raw, dbt and governance-register data are preserved.
Rerun with the original fixture after investigating an error; do not remove quality gates.

This is a synchronous local batch with PostgreSQL transaction guarantees. It does not
deploy Airflow, schedule jobs, replicate data or prove regulatory compliance.

[All labs](../README.md) · [Attribution](../../CITATION.md)

---

Author: [Isaac K. Nti](../../AUTHORS.md). [Citation and reuse terms](../../CITATION.md).
