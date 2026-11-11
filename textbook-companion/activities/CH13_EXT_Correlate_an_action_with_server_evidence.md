# Hands-On Companion Activity: Correlate an action with server evidence

Chapter 13 — Monitoring, Logging, and Operational Health

**Companion resources**

- [EDS-LAB-012: Lab 12: Server-side audit investigation](https://github.com/ntious/IT4065C-Labs/blob/d860dd98256a8090ffc6bd3766c59cb15a553c12/labs/optional/lab12-server-audit/README.md) — `labs/optional/lab12-server-audit/README.md`.

**Before you begin:** Labs 5–6 and optional infrastructure setup; fresh isolated instances; private logs.

**Software:** Supported Ubuntu; Python; PostgreSQL server/client tools; openssl for TLS; canonical optional setup.

**Time:** Published whole-activity planning guidance: Lab 12: 60–90 minutes. Not measured novice completion; focused activity duration has not been measured.

## Why you are doing this

Define collection, custody, retention, and escalation requirements. The activity connects an inspectable result to a bounded architectural claim. Preserve the distinction between what is observed, inferred, proposed, and still unknown.

## Predict before execution or inspection

1. Will a client denial always have an independently retained server record?
2. Does reader log denial make the whole server tamper-proof?

Write a reason for each prediction. If you have already seen the result, say so rather than reconstructing a prediction afterward.

## Execute or inspect

Follow optional Lab 12. Inspect the correlated SELECT completion, denied UPDATE, and reader log-access denial. Preserve only a relevant excerpt with source, session, and timestamp. Use the canonical instructions linked above for commands, checkpoints, and recovery. Do not copy another learner’s results or treat a supplied expected output as your observation.

## Capture evidence

A client/server correlation record with custody limitations. Record the revision, date, relevant identity and scope. Keep personal data and credentials out of the shared extract.

| Claim or question | Expected / source basis | Observed or inspected fact | Evidence locator and type | Status / limitation |
| --- | --- | --- | --- | --- |
| [Your bounded claim] | [Prediction or criterion] | [Actual result; attribute supplied examples] | [File/section/run and date] | [Supported, contradicted, unresolved; why] |

## Interpret

1. Which fields correlate observations?
2. What does the SQLSTATE establish?
3. Who can still alter the log?
4. What independent custody/retention would strengthen the claim?

## Evidence critique

State what your evidence supports, what it does not establish, and which additional observation would most strengthen the conclusion. Actual student-owned server logging is not independent tamper-resistant auditing or period completeness.

## Architecture connection

Define collection, custody, retention, and escalation requirements. Identify the requirement, ADR, or control this observation informs. Explain what would change your conclusion.

## Reset / continue

Fresh instances per run; canonical runner stops them. Verify shutdown and use optional infrastructure recovery guide if interrupted. Reuse the existing private portfolio or submission record; this wrapper does not add a parallel workbook or an institutional submission rule.

## Return to the book

After §13.10; return to §13.11. Carry forward the artifact and its unresolved questions rather than only a success message.
