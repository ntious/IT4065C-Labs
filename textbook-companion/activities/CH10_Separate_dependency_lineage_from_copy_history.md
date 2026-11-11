# Hands-On Companion Activity: Separate dependency lineage from copy history

Chapter 10 — Metadata, Lineage, and Data Lifecycle

**Companion resources**

- [EDS-LAB-004: Lab 4: Lineage and lifecycle](https://github.com/ntious/IT4065C-Labs/blob/d860dd98256a8090ffc6bd3766c59cb15a553c12/labs/core/lab04-lineage-lifecycle/README.md) — `labs/core/lab04-lineage-lifecycle/README.md`.
- [EDS-DECISION-001: Lifecycle/retirement decision log](https://github.com/ntious/IT4065C-Labs/blob/d860dd98256a8090ffc6bd3766c59cb15a553c12/labs/core/lab04-lineage-lifecycle/_turnin_template.md) — `labs/core/lab04-lineage-lifecycle/_turnin_template.md`.

**Before you begin:** Chapter 7; Labs 1–3; Lab 4 decision template. Source/ref and manifest inspection can replace the optional visual graph.

**Software:** Supported Ubuntu; Python 3.10–3.12; PostgreSQL; pinned dbt Core/adapter through canonical course setup.

**Time:** Published whole-activity planning guidance: Lab 4: 60–90 minutes; allow additional time for documentation startup and support.. Not measured novice completion; focused activity duration has not been measured.

## Why you are doing this

Use both representations for change impact, retention, and disposal planning. The activity connects an inspectable result to a bounded architectural claim. Preserve the distinction between what is observed, inferred, proposed, and still unknown.

## Predict before execution or inspection

1. Does the graph list every backup/export?
2. Does deleting a current table prove all copies disposed of?

Write a reason for each prediction. If you have already seen the result, say so rather than reconstructing a prediction afterward.

## Execute or inspect

Follow Lab 4 generation and lineage investigation. Trace a metric to raw input. Separately use the lifecycle log to list known objects and possible exports, backups, archives, and disposal decisions. Mark unobserved copies unknown. Use the canonical instructions linked above for commands, checkpoints, and recovery. Do not copy another learner’s results or treat a supplied expected output as your observation.

## Capture evidence

Two linked artifacts: dependency trace and copy/lifecycle uncertainty record. Record the revision, date, relevant identity and scope. Keep personal data and credentials out of the shared extract.

| Claim or question | Expected / source basis | Observed or inspected fact | Evidence locator and type | Status / limitation |
| --- | --- | --- | --- | --- |
| [Your bounded claim] | [Prediction or criterion] | [Actual result; attribute supplied examples] | [File/section/run and date] | [Supported, contradicted, unresolved; why] |

## Interpret

1. What lineage granularity did you inspect?
2. Which edge is explicit?
3. What is missing from copy history?
4. Who authorizes retirement and what verifies it?

## Evidence critique

State what your evidence supports, what it does not establish, and which additional observation would most strengthen the conclusion. Documentation generation and dependency assertions were executed; browser interaction and enterprise copy inventories were not.

## Architecture connection

Use both representations for change impact, retention, and disposal planning. Identify the requirement, ADR, or control this observation informs. Explain what would change your conclusion.

## Reset / continue

Preserve prior evidence and private work. Follow canonical Recovery/continue guidance; do not delete/reseed to force expected output. Lab 3 test additions remain private and explicit. Reuse the existing private portfolio or submission record; this wrapper does not add a parallel workbook or an institutional submission rule.

## Return to the book

After §10.3; return to §10.7. Carry forward the artifact and its unresolved questions rather than only a success message.

## Optional executable book example

For the related authored demonstration, use the [lifecycle suite](../examples/lifecycle/README.md) and its isolated launcher. This is optional book support, separate from the course activity above. No complete enterprise copy inventory or legal deletion finding.
