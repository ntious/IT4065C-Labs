# Hands-On Companion Activity: Explain a wrong total produced by valid SQL

Chapter 6 — Analytical Systems and Dimensional Modeling

**Companion resources**

- [EDS-LAB-003: Lab 3: Modeling and data quality](https://github.com/ntious/IT4065C-Labs/blob/d860dd98256a8090ffc6bd3766c59cb15a553c12/labs/core/lab03-modeling-quality/README.md) — `labs/core/lab03-modeling-quality/README.md`.

**Before you begin:** Chapters 3–5 and Labs 1–2. Reuse a current Chapter 4/Lab 3 baseline rather than repeating unchanged work.

**Software:** Supported Ubuntu; Python 3.10–3.12; PostgreSQL; pinned dbt Core/adapter through canonical course setup.

**Time:** Published whole-activity planning guidance: Lab 3: 60–90 minutes; allow additional time for installation and support.. Not measured novice completion; focused activity duration has not been measured.

## Why you are doing this

Justify fact grain, measure aggregation, and a reporting acceptance condition. The activity connects an inspectable result to a bounded architectural claim. Preserve the distinction between what is observed, inferred, proposed, and still unknown.

## Predict before execution or inspection

1. Does joining a header to several lines repeat its amount?
2. Does excluding Cancelled orders change the total?

Write a reason for each prediction. If you have already seen the result, say so rather than reconstructing a prediction afterward.

## Execute or inspect

Follow canonical Lab 3 Part A: build, inspect sales, and answer A3 grain questions. Predict what summing order-header amounts after joining lines will do. Reconcile the completed-order result at order and line grains using the canonical model/query references. Use the canonical instructions linked above for commands, checkpoints, and recovery. Do not copy another learner’s results or treat a supplied expected output as your observation.

## Capture evidence

A reconciliation table with grain, inclusion rules, source/target values, difference, and limitation. Record the revision, date, relevant identity and scope. Keep personal data and credentials out of the shared extract.

| Claim or question | Expected / source basis | Observed or inspected fact | Evidence locator and type | Status / limitation |
| --- | --- | --- | --- | --- |
| [Your bounded claim] | [Prediction or criterion] | [Actual result; attribute supplied examples] | [File/section/run and date] | [Supported, contradicted, unresolved; why] |

## Interpret

1. What does each row mean before and after the join?
2. Why can valid SQL inflate the completed-order total?
3. Why is SUM(DISTINCT amount) not a general repair?
4. What missing-child or offsetting-error case could matching totals conceal?

## Evidence critique

State what your evidence supports, what it does not establish, and which additional observation would most strengthen the conclusion. Core 139.95 and optional 45.00 are different fixtures. Agreement does not prove source truth or complete delivery.

## Architecture connection

Justify fact grain, measure aggregation, and a reporting acceptance condition. Identify the requirement, ADR, or control this observation informs. Explain what would change your conclusion.

## Reset / continue

Preserve prior evidence and private work. Follow canonical Recovery/continue guidance; do not delete/reseed to force expected output. Lab 3 test additions remain private and explicit. Reuse the existing private portfolio or submission record; this wrapper does not add a parallel workbook or an institutional submission rule.

## Return to the book

After §6.4; return to §6.5. Carry forward the artifact and its unresolved questions rather than only a success message.

## Optional executable book example

For the related authored demonstration, use the [transactions suite](../examples/transactions/README.md) and its isolated launcher. This is optional book support, separate from the course activity above. Separate illustrative populations and interval conventions.
