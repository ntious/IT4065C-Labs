# Repository Investigation: Locate the transaction boundary and invariant

Chapter 5 — Operational Data Systems and Transactions

**Resources:** [EDS-DATA-001](https://github.com/ntious/IT4065C-Labs/blob/d860dd98256a8090ffc6bd3766c59cb15a553c12/labs/core/lab02-classification/lab2_seed.sql); [EDS-LAB-008](https://github.com/ntious/IT4065C-Labs/blob/d860dd98256a8090ffc6bd3766c59cb15a553c12/labs/optional/lab08-retention/README.md). **Type:** INVESTIGATE. 

**Before you begin:** Chapter 3 and §§5.3–5.4. Reading SQL needs no installation; executing optional Lab 8 has separate prerequisites. Use a text viewer and the existing private record; no new workbook is required. **Time:** focused reading/decision time unmeasured; learner estimate pending a independent reader trial.

## Purpose and prediction

Choose a boundary for one invariant and identify external effects needing separate coordination. Before inspecting, record a reasoned prediction: Which temporary changes should survive ROLLBACK? Would database rollback reverse an external payment?

## Inspect and extract evidence

Inspect BEGIN/COMMIT in the seed and BEGIN/ROLLBACK in the retention SQL linked from Lab 8 (inspection only). Identify the included changes and why the retention experiment rolls them back. Do not rerun the seed manually into an existing database. Produce a transaction-boundary annotation and one proposed acceptance test. Attribute supplied observations; record your source revision and date.

| Claim/question | Source or observation | Scope and limitation |
| --- | --- | --- |
| [Your claim] | [Exact file/section or run; evidence type] | [What remains unknown] |

## Analyze

1. What marks each transaction boundary?
2. Which invariant is checked?
3. What must happen after a transaction error?
4. Which concurrency claim remains untested?

## Evidence limitation

Inspection and the executed single-session retention assertions do not establish a mature multi-session concurrency lab. State the most useful additional evidence.

## Connect and continue

After §5.4; return to §5.5. Carry the scoped finding into that discussion. Inspection needs no reset; any elected execution follows its canonical prerequisites and recovery route.

## Optional executable book example

For the related authored demonstration, use the [transactions suite](../examples/transactions/README.md) and its isolated launcher. This is optional book support, separate from the course activity above. Forced schedules; no all-interleaving or external-payment claim.
