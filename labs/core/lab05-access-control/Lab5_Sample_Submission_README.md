# Lab 5 sample submission: Access control and masking

> **Optional example: structure, evidence selection and level of detail.**
> Follow the [Lab 5 instructions](README.md) and write one private submission.
> Use your own results, predictions, proposed design and assistance disclosure.
> This sample is not an additional assignment or a completed submission to copy.

## How to use this sample

The output excerpts below are from the instructor's shared Lab 5 walkthrough,
with personal terminal prompts removed and JSON whitespace condensed. They are
not evidence of a new execution. Explanations marked **Illustrative reasoning**
show how to connect those observations to the supplied SQL.

No advance predictions or independent manager proposal were supplied with the
walkthrough. This sample does not invent them. It demonstrates the guided access
checks while leaving the independent proposal to you. One to three clear
sentences per reasoning item are usually sufficient; screenshots are optional.

## A1: Technical evidence

**Command run:**

```bash
.venv/bin/python scripts/course.py lab 5
```

**Observed result:**

```text
PASS: connection, dedicated database, schemas and non-superuser builder.
PASS: synthetic seed present (existing data preserved).
PASS: nine access checks using separate authenticated connections, including escalation denials.
LAB 5 TECHNICAL CHECKS COMPLETE. Return to labs/core/lab05-access-control/README.md for interpretation and deliverables.
```

The runner performs nine checks. The next three queries are the representative
cases students investigate manually, not nine additional required commands.

## A2: Analyst sales

**Command and role:**

```bash
.venv/bin/python scripts/query.py labs/practice/read_sales.sql --role analyst
```

**Prediction:** not supplied with the walkthrough. In your own document, preserve
your actual advance prediction or state that you ran the query before recording one.

**Actual result:**

```text
PASS: connection, dedicated database, schemas and non-superuser builder.
[
  ["2026-01-10", 2, "129.97"],
  ["2026-01-11", 1, "9.98"]
]
```

**Permission explanation: illustrative reasoning.**
The [grants](03_rbac_and_grants.sql) give the analyst schema usage and SELECT on
`v_sales_by_day`. The returned rows show that this reader query was allowed.
The preceding builder PASS is the environment check, not the query's identity.

**Projection explanation: illustrative reasoning.**
The [view definition](02_build_safe_objects.sql) exposes `sales_date`, `orders`
and `sales_amount` for completed orders grouped by day. These are aggregate sales
columns, rather than individual customer contact fields or the five-column Lab 3 mart.

**Comparison:** no advance prediction was supplied, so this sample makes no
claim about whether one matched. Include that comparison if you recorded one.

## A3: Analyst masked customers

**Command and role:**

```bash
.venv/bin/python scripts/query.py labs/practice/read_masked.sql --role analyst
```

**Prediction:** use your actual recorded expectation or timing note.

**Actual result:**

```text
PASS: connection, dedicated database, schemas and non-superuser builder.
SQL stopped: SQLSTATE 42501. Permission denied. Check the role and the lab's expected allow/deny behavior.
```

**Permission explanation: illustrative reasoning.**
The supplied grants do not give the analyst SELECT on `v_customers_masked`.
The observed `42501` is the expected denial for this role and query. It should
be recorded rather than repaired by granting additional access.

**Projection explanation: illustrative reasoning.**
No customer rows were returned to the analyst. Reading the view's SQL describes
its intended projection, but is not evidence that the analyst received those fields.

**Comparison:** compare with your own prediction, if recorded.

## A4: Steward masked customers

**Command and role:**

```bash
.venv/bin/python scripts/query.py labs/practice/read_masked.sql --role steward
```

**Prediction:** use your actual recorded expectation or timing note.

**Actual result:**

```text
PASS: connection, dedicated database, schemas and non-superuser builder.
[
  [1, "***@example.com", "***01"],
  [2, "***@example.com", null],
  [3, "***@example.com", "***03"],
  [4, "***@example.com", null]
]
```

**Permission explanation: illustrative reasoning.**
The grants permit the steward to SELECT from `v_customers_masked`, and the
separate steward connection returned rows. This does not demonstrate direct
access to raw customer data.

**Projection and masking observation: illustrative reasoning.**
The view hides the email's local part and all but the last two phone digits.
It still exposes customer IDs, email domains, phone suffixes and whether phone
values are missing. These observations demonstrate partial masking, not anonymity.

**Comparison:** compare with your own prediction, if recorded.

## Authorization evidence

**Illustrative reasoning:**
The analyst's `42501` identifies a permission denial for the requested operation.
A syntax error would instead indicate an invalid SQL statement and would not show
that this same access boundary was enforced. This is a written comparison; no
syntax error was deliberately executed in the supplied walkthrough.

## Proposed weekly-sales view

Write your own six brief responses using the B3 prompts: **Purpose**, **Grain**,
**Fields included**, **Fields omitted**, **Remaining risk**, and **Status**.
This is an independent design decision, so a completed weekly-sales answer is
not supplied here.

For the expected level of detail, consider this separate fictional example:

> **Purpose:** a library coordinator needs monthly borrowing volume.
> **Grain:** one row per calendar month.
> **Fields included:** month and total loans for trend comparison.
> **Fields omitted:** patron identifiers and contact details, which are unnecessary
> for that question.
> **Remaining risk:** a very small monthly count could reveal activity when
> combined with outside knowledge.
> **Status:** Proposed; neither a view nor its access controls were implemented.

Use the course's manager and weekly-sales scenario in your submission, not the
library example. No new SQL or grant changes are required.

## Remote-server discussion

Give your own two- or three-sentence response naming one connection protection
and one identity or access-management improvement. Explain why they address
different problems. Do not describe a proposed remote configuration as tested
by these local queries.

## Evidence limitation

**Illustrative reasoning:**
These observations show the specified access outcomes for this local configuration.
They do not establish that masked data cannot be reidentified or that readers
cannot export information they are allowed to see.

## Recovery and assistance

The supplied A1–A4 output contains no unexpected error. The expected A3 denial
requires no recovery. Describe any unexpected problem you actually encountered;
do not invent a recovery story.

Use your actual assistance history. An example disclosure, only if accurate:

> I used AI assistance to interpret the repeated builder PASS and the permission
> denial. I checked the explanation against the supplied grants and view definitions
> and compared it with my actual query results.

If no AI assistance was used, write `None`. Follow the course's AI-use rules.

## Before submitting

Check that your one document includes A1 evidence, all three access responses,
the authorization-error comparison, your own proposed weekly-sales view, remote
server discussion, one limitation and recovery/assistance notes. Refer to the
[submission checklist](README.md#submit); do not repeat the same explanation.

Use your own narrow output excerpts. Omit credentials, `.env`, full logs and
personal terminal details. Submit privately through the LMS or retain locally
for self-study. Do not publish a filled student submission.

---

Author: [Isaac K. Nti](../../../AUTHORS.md). [Citation and reuse terms](../../../CITATION.md).
