# Hands-On Companion Activity: Predict and test the access boundary

Chapter 11 — Identity, Access Control, and Data Security

**Companion resources**

- [EDS-LAB-005: Lab 5: Access control and masking](https://github.com/ntious/IT4065C-Labs/blob/d860dd98256a8090ffc6bd3766c59cb15a553c12/labs/core/lab05-access-control/README.md) — `labs/core/lab05-access-control/README.md`.

**Before you begin:** Chapters 8–10; canonical Labs 1–4; dedicated synthetic environment and separate analyst/steward connections.

**Software:** Supported Ubuntu; Python 3.10–3.12; PostgreSQL; pinned dbt Core/adapter through canonical course setup.

**Time:** Published whole-activity planning guidance: Lab 5: 60–90 minutes; allow additional time for installation and support.. Not measured novice completion; focused activity duration has not been measured.

## Why you are doing this

Evaluate least privilege against an approved purpose and define retesting after role/view changes. The activity connects an inspectable result to a bounded architectural claim. Preserve the distinction between what is observed, inferred, proposed, and still unknown.

## Predict before execution or inspection

1. Should an analyst read sales?
2. Should the analyst read masked or raw customer data?
3. Will the steward have identical access?

Write a reason for each prediction. If you have already seen the result, say so rather than reconstructing a prediction afterward.

## Execute or inspect

Follow canonical Lab 5, including sales-view allowance, analyst denial on protected customer objects, and steward allowance on the masked view. Record predictions before execution, then identity, object, operation, returned fields or SQLSTATE. Do not substitute a superuser for the reader. Use the canonical instructions linked above for commands, checkpoints, and recovery. Do not copy another learner’s results or treat a supplied expected output as your observation.

## Capture evidence

An access matrix pairing predictions, identities, actual results, and limits. Record the revision, date, relevant identity and scope. Keep personal data and credentials out of the shared extract.

| Claim or question | Expected / source basis | Observed or inspected fact | Evidence locator and type | Status / limitation |
| --- | --- | --- | --- | --- |
| [Your bounded claim] | [Prediction or criterion] | [Actual result; attribute supplied examples] | [File/section/run and date] | [Supported, contradicted, unresolved; why] |

## Interpret

1. Which allowed and forbidden paths were tested?
2. Was denial 42501 or an unrelated error?
3. What information remains visible?
4. Which alternate path or membership was not tested?

## Evidence critique

State what your evidence supports, what it does not establish, and which additional observation would most strengthen the conclusion. Do not relabel every raw object Restricted: the register classifies particular fields. Tests do not establish all-user or semester-long effectiveness or appropriate authorized use.

## Architecture connection

Evaluate least privilege against an approved purpose and define retesting after role/view changes. Identify the requirement, ADR, or control this observation informs. Explain what would change your conclusion.

## Reset / continue

Preserve prior evidence and private work. Follow canonical Recovery/continue guidance; do not delete/reseed to force expected output. Lab 3 test additions remain private and explicit. Reuse the existing private portfolio or submission record; this wrapper does not add a parallel workbook or an institutional submission rule.

## Return to the book

After §11.7; return to §11.8. Carry forward the artifact and its unresolved questions rather than only a success message.

## Optional executable book example

For the related authored demonstration, use the [lifecycle suite](../examples/lifecycle/README.md) and its isolated launcher. This is optional book support, separate from the course activity above. Generated local credentials; bounded identities, objects and operations.
