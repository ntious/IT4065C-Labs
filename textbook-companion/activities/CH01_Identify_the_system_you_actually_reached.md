# Hands-On Companion Activity: Identify the system you actually reached

Chapter 1 — From Databases to Accountable Data Systems

**Companion resources**

- [EDS-LAB-001: Lab 1: Environment readiness](https://github.com/ntious/IT4065C-Labs/blob/d860dd98256a8090ffc6bd3766c59cb15a553c12/labs/core/lab01-environment/README.md) — `labs/core/lab01-environment/README.md`.

**Before you begin:** Appendix E and canonical setup; no earlier lab. Distinguish shell commands from SQL.

**Software:** Supported Ubuntu; Python 3.10–3.12; PostgreSQL; pinned dbt Core/adapter through canonical course setup.

**Time:** Published whole-activity planning guidance: Lab 1: 30–60 minutes first setup; allow additional time for installation and support.. Not measured novice completion; focused activity duration has not been measured.

## Why you are doing this

Use the evidence to define system/trust boundaries and prerequisites for later claims. The activity connects an inspectable result to a bounded architectural claim. Preserve the distinction between what is observed, inferred, proposed, and still unknown.

## Predict before execution or inspection

1. Will OS and database identities necessarily match?
2. Does successful connection establish correct business reporting?

Write a reason for each prediction. If you have already seen the result, say so rather than reconstructing a prediction afterward.

## Execute or inspect

Open Lab 1 and follow its canonical environment and boundary investigation. At the dedicated-database and dbt checkpoints, record the operating-system account, database login, connected database, and configuration scope. Keep credentials out of the record. Use the canonical instructions linked above for commands, checkpoints, and recovery. Do not copy another learner’s results or treat a supplied expected output as your observation.

## Capture evidence

An environment/identity table with a supported claim and two limitations. Record the revision, date, relevant identity and scope. Keep personal data and credentials out of the shared extract.

| Claim or question | Expected / source basis | Observed or inspected fact | Evidence locator and type | Status / limitation |
| --- | --- | --- | --- | --- |
| [Your bounded claim] | [Prediction or criterion] | [Actual result; attribute supplied examples] | [File/section/run and date] | [Supported, contradicted, unresolved; why] |

## Interpret

1. Which identity was authenticated?
2. Which conditions did the checks test?
3. What lies outside the tested boundary?
4. What further observation would support reporting correctness?

## Evidence critique

State what your evidence supports, what it does not establish, and which additional observation would most strengthen the conclusion. Existing Ubuntu plus a new private cluster was verified; fresh setup.sh installation and novice usability remain unverified.

## Architecture connection

Use the evidence to define system/trust boundaries and prerequisites for later claims. Identify the requirement, ADR, or control this observation informs. Explain what would change your conclusion.

## Reset / continue

Preserve prior evidence and private work. Follow canonical Recovery/continue guidance; do not delete/reseed to force expected output. Lab 3 test additions remain private and explicit. Reuse the existing private portfolio or submission record; this wrapper does not add a parallel workbook or an institutional submission rule.

## Return to the book

After §1.7; return to §1.8. Carry forward the artifact and its unresolved questions rather than only a success message.

## Optional executable book example

For the related authored demonstration, use the [foundations suite](../examples/foundations/README.md) and its isolated launcher. This is optional book support, separate from the course activity above. No claim of full organizational accountability or fresh OS setup.
