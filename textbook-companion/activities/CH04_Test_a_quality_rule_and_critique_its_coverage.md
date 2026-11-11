# Hands-On Companion Activity: Test a quality rule and critique its coverage

Chapter 4 — Data Quality, Ethics, and Responsible Use

**Companion resources**

- [EDS-LAB-003: Lab 3: Modeling and data quality](https://github.com/ntious/IT4065C-Labs/blob/d860dd98256a8090ffc6bd3766c59cb15a553c12/labs/core/lab03-modeling-quality/README.md) — `labs/core/lab03-modeling-quality/README.md`.

**Before you begin:** Chapter 3; Labs 1–2; configured PostgreSQL/dbt. Lab 3 Part B follows Part A.

**Software:** Supported Ubuntu; Python 3.10–3.12; PostgreSQL; pinned dbt Core/adapter through canonical course setup.

**Time:** Published whole-activity planning guidance: Lab 3: 60–90 minutes; allow additional time for installation and support.. Not measured novice completion; focused activity duration has not been measured.

## Why you are doing this

Decide whether the rule is adequate for the stated use and who owns remediation. The activity connects an inspectable result to a bounded architectural claim. Preserve the distinction between what is observed, inferred, proposed, and still unknown.

## Predict before execution or inspection

1. Which rows should a valid and a violating example return?
2. Does a passing rule establish suitability for a new personal-data use?

Write a reason for each prediction. If you have already seen the result, say so rather than reconstructing a prediction afterward.

## Execute or inspect

Follow canonical Lab 3 Parts A and B, including the guided test, your justified independent rule, and named-result verification. Separately inspect the [supplied quality-failure evidence](../evidence/quality-failure.md). Do not inject bad data into the ordinary learner database: the guide treats the hypothetical violating row as reasoning and reserves verify.py injection for disposable engineering rehearsal. Use the canonical instructions linked above for commands, checkpoints, and recovery. Do not copy another learner’s results or treat a supplied expected output as your observation.

## Capture evidence

Rule, hypothetical violation, named result, and a bounded quality/fitness critique. Record the revision, date, relevant identity and scope. Keep personal data and credentials out of the shared extract.

| Claim or question | Expected / source basis | Observed or inspected fact | Evidence locator and type | Status / limitation |
| --- | --- | --- | --- | --- |
| [Your bounded claim] | [Prediction or criterion] | [Actual result; attribute supplied examples] | [File/section/run and date] | [Supported, contradicted, unresolved; why] |

## Interpret

1. Did the named test execute or get skipped?
2. What precise condition does its predicate cover?
3. What does an observed failure show that a hypothetical example does not?
4. Why are validity, quality, and ethical suitability distinct?

## Evidence critique

State what your evidence supports, what it does not establish, and which additional observation would most strengthen the conclusion. The engineer observed actual failure/restoration; the ordinary student task does not authorize failure injection. Passing checks do not establish ethical suitability.

## Decide and connect to the architecture

Decide whether the rule is adequate for the stated use and who owns remediation. Identify the known requirement IDs where the book register supplies them. List at least two credible alternatives and a third where useful; separate mandatory constraints from preferences. Record the selected option, rationale, consequence, evidence needed, uncertainty, and review trigger. Use the existing ADR register, or mark an independent example EX-ADR; do not allocate a new case ID casually.

## Reset / continue

Preserve prior evidence and private work. Follow canonical Recovery/continue guidance; do not delete/reseed to force expected output. Lab 3 test additions remain private and explicit. Reuse the existing private portfolio or submission record; this wrapper does not add a parallel workbook or an institutional submission rule.

## Return to the book

After §4.9; return to §4.10. Carry forward the artifact and its unresolved questions rather than only a success message.

## Optional executable book example

For the related authored demonstration, use the [transactions suite](../examples/transactions/README.md) and its isolated launcher. This is optional book support, separate from the course activity above. Quality checks do not establish ethical suitability.
