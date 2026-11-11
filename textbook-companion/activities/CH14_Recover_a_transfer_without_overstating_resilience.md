# Hands-On Companion Activity: Recover a transfer without overstating resilience

Chapter 14 — Recovery, Resilience, and Business Continuity

**Companion resources**

- [EDS-LAB-013: Lab 13: Two-instance transfer and recovery](https://github.com/ntious/IT4065C-Labs/blob/d860dd98256a8090ffc6bd3766c59cb15a553c12/labs/optional/lab13-transfer-recovery/README.md) — `labs/optional/lab13-transfer-recovery/README.md`.

**Before you begin:** Chapter 14; Lab 4, infrastructure comparison, and optional setup; PostgreSQL server tools; normal user; no paid cloud.

**Software:** Supported Ubuntu; Python; PostgreSQL server/client tools; openssl for TLS; canonical optional setup.

**Time:** Published whole-activity planning guidance: Lab 13: 60–90 minutes. Not measured novice completion; focused activity duration has not been measured.

## Why you are doing this

Decide whether the evidence supports the reporting continuity arrangement and name the next independent recovery test. The activity connects an inspectable result to a bounded architectural claim. Preserve the distinction between what is observed, inferred, proposed, and still unknown.

## Predict before execution or inspection

1. Should source failure erase the last target publication?
2. Should retry duplicate rows?

Write a reason for each prediction. If you have already seen the result, say so rather than reconstructing a prediction afterward.

## Execute or inspect

Follow optional Lab 13. Read the newly generated evidence file and record distinct instances, target state during source shutdown, recovered count/total, retry, and measured durations. Follow canonical cleanup verification. Use the canonical instructions linked above for commands, checkpoints, and recovery. Do not copy another learner’s results or treat a supplied expected output as your observation.

## Capture evidence

A recovery record separating objective, observed duration, validation, and limitation. Record the revision, date, relevant identity and scope. Keep personal data and credentials out of the shared extract.

| Claim or question | Expected / source basis | Observed or inspected fact | Evidence locator and type | Status / limitation |
| --- | --- | --- | --- | --- |
| [Your bounded claim] | [Prediction or criterion] | [Actual result; attribute supplied examples] | [File/section/run and date] | [Supported, contradicted, unresolved; why] |

## Interpret

1. What failed and what remained?
2. Which interval was measured?
3. What service objective needs additional acceptance criteria?
4. Which shared-host failure could affect both instances?

## Evidence critique

State what your evidence supports, what it does not establish, and which additional observation would most strengthen the conclusion. Same-host manual transfer is not streaming replication, automatic failover, independent-site disaster recovery, or production RPO/RTO.

## Architecture connection

Decide whether the evidence supports the reporting continuity arrangement and name the next independent recovery test. Identify the requirement, ADR, or control this observation informs. Explain what would change your conclusion.

## Reset / continue

Fresh instances per run; canonical runner stops them. Verify shutdown and use optional infrastructure recovery guide if interrupted. Reuse the existing private portfolio or submission record; this wrapper does not add a parallel workbook or an institutional submission rule.

## Return to the book

After §14.9; return to §14.10. Carry forward the artifact and its unresolved questions rather than only a success message.

## Optional executable book example

For the related authored demonstration, use the [lifecycle suite](../examples/lifecycle/README.md) and its isolated launcher. This is optional book support, separate from the course activity above. Same host/custody; no independent disaster recovery or production RPO/RTO.
