# Hands-On Companion Activity: Distinguish observations from simulated incidents

Chapter 13 — Monitoring, Logging, and Operational Health

**Companion resources**

- [EDS-LAB-006: Lab 6: Monitoring and evidence](https://github.com/ntious/IT4065C-Labs/blob/d860dd98256a8090ffc6bd3766c59cb15a553c12/labs/core/lab06-monitoring/README.md) — `labs/core/lab06-monitoring/README.md`.

**Before you begin:** Chapter 11; canonical Labs 1–5; keep generated client reports private.

**Software:** Supported Ubuntu; Python 3.10–3.12; PostgreSQL; pinned dbt Core/adapter through canonical course setup.

**Time:** Published whole-activity planning guidance: Lab 6: 60–90 minutes; allow additional time for installation and support.. Not measured novice completion; focused activity duration has not been measured.

## Why you are doing this

Define a monitoring requirement with a signal, owner, threshold, and response. The activity connects an inspectable result to a bounded architectural claim. Preserve the distinction between what is observed, inferred, proposed, and still unknown.

## Predict before execution or inspection

1. Does a failed SELECT identify malice?
2. Do simulated incident rows prove a real attack occurred?

Write a reason for each prediction. If you have already seen the result, say so rather than reconstructing a prediction afterward.

## Execute or inspect

Follow Lab 6 and inspect its audit report. Separate live client outcomes from deterministic simulated incident rows. Record each source and timestamp meaning before interpreting an incident. Optional server audit has a separate activity and prerequisites. Use the canonical instructions linked above for commands, checkpoints, and recovery. Do not copy another learner’s results or treat a supplied expected output as your observation.

## Capture evidence

An event/source matrix and a bounded operational interpretation. Record the revision, date, relevant identity and scope. Keep personal data and credentials out of the shared extract.

| Claim or question | Expected / source basis | Observed or inspected fact | Evidence locator and type | Status / limitation |
| --- | --- | --- | --- | --- |
| [Your bounded claim] | [Prediction or criterion] | [Actual result; attribute supplied examples] | [File/section/run and date] | [Supported, contradicted, unresolved; why] |

## Interpret

1. Which record came from a live connection?
2. Which came from the supplied scenario?
3. What corroboration would strengthen the interpretation?
4. Who receives the signal and acts?

## Evidence critique

State what your evidence supports, what it does not establish, and which additional observation would most strengthen the conclusion. Core Lab 6 does not establish tamper-proof server audit logging. Client output, synthetic event, alert, and interpretation differ.

## Architecture connection

Define a monitoring requirement with a signal, owner, threshold, and response. Identify the requirement, ADR, or control this observation informs. Explain what would change your conclusion.

## Reset / continue

Preserve prior evidence and private work. Follow canonical Recovery/continue guidance; do not delete/reseed to force expected output. Lab 3 test additions remain private and explicit. Reuse the existing private portfolio or submission record; this wrapper does not add a parallel workbook or an institutional submission rule.

## Return to the book

After §13.8; return to §13.9. Carry forward the artifact and its unresolved questions rather than only a success message.

## Optional executable book example

For the related authored demonstration, use the [lifecycle suite](../examples/lifecycle/README.md) and its isolated launcher. This is optional book support, separate from the course activity above. Synthetic events; no malice inference or production performance benchmark.
