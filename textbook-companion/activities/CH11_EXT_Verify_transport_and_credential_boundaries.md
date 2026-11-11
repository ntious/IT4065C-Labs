# Hands-On Companion Activity: Verify transport and credential boundaries

Chapter 11 — Identity, Access Control, and Data Security

**Companion resources**

- [EDS-LAB-014: Lab 14: Verified TLS and credential rotation](https://github.com/ntious/IT4065C-Labs/blob/d860dd98256a8090ffc6bd3766c59cb15a553c12/labs/optional/lab14-tls-rotation/README.md) — `labs/optional/lab14-tls-rotation/README.md`.

**Before you begin:** Lab 5; optional infrastructure setup; PostgreSQL tools and openssl; normal-user isolated environment.

**Software:** Supported Ubuntu; Python; PostgreSQL server/client tools; openssl for TLS; canonical optional setup.

**Time:** Published whole-activity planning guidance: Lab 14: 60–90 minutes. Not measured novice completion; focused activity duration has not been measured.

## Why you are doing this

Separate authentication, authorization, transport verification, and credential-lifecycle requirements. The activity connects an inspectable result to a bounded architectural claim. Preserve the distinction between what is observed, inferred, proposed, and still unknown.

## Predict before execution or inspection

1. Does encryption alone establish the intended server?
2. Does rotation terminate established sessions?

Write a reason for each prediction. If you have already seen the result, say so rather than reconstructing a prediction afterward.

## Execute or inspect

Follow optional Lab 14 and inspect the new evidence file. Pair verified TLS with wrong-CA, wrong-hostname, and plaintext controls; compare fresh connections using old and rotated credentials without recording passwords. Use the canonical instructions linked above for commands, checkpoints, and recovery. Do not copy another learner’s results or treat a supplied expected output as your observation.

## Capture evidence

A connection-control matrix with expected/observed outcomes and scope. Record the revision, date, relevant identity and scope. Keep personal data and credentials out of the shared extract.

| Claim or question | Expected / source basis | Observed or inspected fact | Evidence locator and type | Status / limitation |
| --- | --- | --- | --- | --- |
| [Your bounded claim] | [Prediction or criterion] | [Actual result; attribute supplied examples] | [File/section/run and date] | [Supported, contradicted, unresolved; why] |

## Interpret

1. What property does each negative control challenge?
2. Did it fail for the intended reason?
3. What fresh-session behavior changed?
4. What at-rest or established-session claim remains untested?

## Evidence critique

State what your evidence supports, what it does not establish, and which additional observation would most strengthen the conclusion. Fresh connections only; no production PKI, existing-session termination, encryption-at-rest, or security certification.

## Architecture connection

Separate authentication, authorization, transport verification, and credential-lifecycle requirements. Identify the requirement, ADR, or control this observation informs. Explain what would change your conclusion.

## Reset / continue

Fresh instances per run; canonical runner stops them. Verify shutdown and use optional infrastructure recovery guide if interrupted. Reuse the existing private portfolio or submission record; this wrapper does not add a parallel workbook or an institutional submission rule.

## Return to the book

After §11.9; return to §11.10. Carry forward the artifact and its unresolved questions rather than only a success message.
