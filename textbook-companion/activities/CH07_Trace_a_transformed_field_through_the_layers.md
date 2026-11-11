# Hands-On Companion Activity: Trace a transformed field through the layers

Chapter 7 — Data Integration, Transformation, and Layered Architecture

**Companion resources**

- [EDS-LAB-003: Lab 3: Modeling and data quality](https://github.com/ntious/IT4065C-Labs/blob/d860dd98256a8090ffc6bd3766c59cb15a553c12/labs/core/lab03-modeling-quality/README.md) — `labs/core/lab03-modeling-quality/README.md`.
- [EDS-LAB-004: Lab 4: Lineage and lifecycle](https://github.com/ntious/IT4065C-Labs/blob/d860dd98256a8090ffc6bd3766c59cb15a553c12/labs/core/lab04-lineage-lifecycle/README.md) — `labs/core/lab04-lineage-lifecycle/README.md`.

**Before you begin:** Chapter 6; Labs 1–3. Lab 4 generates documentation from built models. Reuse current results if code/data are unchanged.

**Software:** Supported Ubuntu; Python 3.10–3.12; PostgreSQL; pinned dbt Core/adapter through canonical course setup.

**Time:** Published whole-activity planning guidance: Lab 3: 60–90 minutes; allow additional time for installation and support.; Lab 4: 60–90 minutes; allow additional time for documentation startup and support.. Not measured novice completion; focused activity duration has not been measured.

## Why you are doing this

Decide where to validate meaning, route failure, and assign consumer-contract responsibility. The activity connects an inspectable result to a bounded architectural claim. Preserve the distinction between what is observed, inferred, proposed, and still unknown.

## Predict before execution or inspection

1. Where does Completed become completed?
2. Where does price_at_purchase become unit_price?

Write a reason for each prediction. If you have already seen the result, say so rather than reconstructing a prediction afterward.

## Execute or inspect

Follow canonical Lab 3 source/model inspection and Lab 4 documentation-generation checkpoints. Trace order status or purchase-time price from raw source through staging, core, and a consumer mart. Use SQL and manifest relationships; a screenshot is unnecessary. Use the canonical instructions linked above for commands, checkpoints, and recovery. Do not copy another learner’s results or treat a supplied expected output as your observation.

## Capture evidence

A field trace recording source expression, output meaning, materialization, test, and gap. Record the revision, date, relevant identity and scope. Keep personal data and credentials out of the shared extract.

| Claim or question | Expected / source basis | Observed or inspected fact | Evidence locator and type | Status / limitation |
| --- | --- | --- | --- | --- |
| [Your bounded claim] | [Prediction or criterion] | [Actual result; attribute supplied examples] | [File/section/run and date] | [Supported, contradicted, unresolved; why] |

## Interpret

1. Which source/ref declarations establish dependencies?
2. Which layers are views and which are tables?
3. What can an upstream failing test cause downstream?
4. What would establish coverage of every expected source delivery?

## Evidence critique

State what your evidence supports, what it does not establish, and which additional observation would most strengthen the conclusion. The baseline has raw, staging, core, and mart resources; do not invent an implemented intermediate layer or treat declared dependencies as complete copy history.

## Architecture connection

Decide where to validate meaning, route failure, and assign consumer-contract responsibility. Identify the requirement, ADR, or control this observation informs. Explain what would change your conclusion.

## Reset / continue

Preserve prior evidence and private work. Follow canonical Recovery/continue guidance; do not delete/reseed to force expected output. Lab 3 test additions remain private and explicit. Reuse the existing private portfolio or submission record; this wrapper does not add a parallel workbook or an institutional submission rule.

## Return to the book

After §7.5; return to §7.6. Carry forward the artifact and its unresolved questions rather than only a success message.

## Optional executable book example

For the related authored demonstration, use the [reasoning suite](../examples/reasoning/README.md) and its isolated launcher. This is optional book support, separate from the course activity above. SQL substitution and in-memory publication distinguished from dbt/publisher execution.
