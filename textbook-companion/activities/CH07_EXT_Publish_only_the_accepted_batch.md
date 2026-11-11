# Hands-On Companion Activity: Publish only the accepted batch

Chapter 7 — Data Integration, Transformation, and Layered Architecture

**Companion resources**

- [EDS-LAB-010: Lab 10: Catalog and curate mixed-format sources](https://github.com/ntious/IT4065C-Labs/blob/d860dd98256a8090ffc6bd3766c59cb15a553c12/labs/optional/lab10-catalog-ingestion/README.md) — `labs/optional/lab10-catalog-ingestion/README.md`.
- [EDS-LAB-011: Lab 11: Quality-gated publication and a reconciled KPI](https://github.com/ntious/IT4065C-Labs/blob/d860dd98256a8090ffc6bd3766c59cb15a553c12/labs/optional/lab11-quality-promotion/README.md) — `labs/optional/lab11-quality-promotion/README.md`.

**Before you begin:** Lab 2 for optional Lab 10; Lab 3 and optional Lab 10 for optional Lab 11; Chapter 6 grain reasoning.

**Software:** Supported Ubuntu; Python 3.10–3.12; PostgreSQL; pinned dbt Core/adapter through canonical course setup.

**Time:** Published whole-activity planning guidance: Lab 10: 60–90 minutes.; Lab 11: 60–90 minutes. Optional enrichment.. Not measured novice completion; focused activity duration has not been measured.

## Why you are doing this

Decide the quality gate, failure route, and consumer-contract owner. The activity connects an inspectable result to a bounded architectural claim. Preserve the distinction between what is observed, inferred, proposed, and still unknown.

## Predict before execution or inspection

1. Should an invalid batch erase the last approved publication?
2. Should retry duplicate its contribution?

Write a reason for each prediction. If you have already seen the result, say so rather than reconstructing a prediction afterward.

## Execute or inspect

Follow optional Labs 10 and 11 in order. Inspect accepted/quarantined records, then publication and retry evidence. Record prior publication, failed-batch consequence, corrected result, and approved total. Use the canonical instructions linked above for commands, checkpoints, and recovery. Do not copy another learner’s results or treat a supplied expected output as your observation.

## Capture evidence

Acceptance/quarantine table and before/failure/after publication record. Record the revision, date, relevant identity and scope. Keep personal data and credentials out of the shared extract.

| Claim or question | Expected / source basis | Observed or inspected fact | Evidence locator and type | Status / limitation |
| --- | --- | --- | --- | --- |
| [Your bounded claim] | [Prediction or criterion] | [Actual result; attribute supplied examples] | [File/section/run and date] | [Supported, contradicted, unresolved; why] |

## Interpret

1. Which records were excluded?
2. How does 45.00 reconcile to 20.00 and 25.00?
3. Which transaction protects publication?
4. What delivery or distributed behavior remains untested?

## Evidence critique

State what your evidence supports, what it does not establish, and which additional observation would most strengthen the conclusion. This three-record optional fixture is separate from core 139.95; local transactions are not distributed orchestration.

## Architecture connection

Decide the quality gate, failure route, and consumer-contract owner. Identify the requirement, ADR, or control this observation informs. Explain what would change your conclusion.

## Reset / continue

Preserve prior evidence and private work. Follow canonical Recovery/continue guidance; do not delete/reseed to force expected output. Lab 3 test additions remain private and explicit. Reuse the existing private portfolio or submission record; this wrapper does not add a parallel workbook or an institutional submission rule.

## Return to the book

After §7.12; return to §7.13. Carry forward the artifact and its unresolved questions rather than only a success message.
