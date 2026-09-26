# Lab 2 sample submission: Classification and stewardship

> **Student-facing example — format and level of detail only**
>
> This file demonstrates how to organize a concise Lab 2 submission using the
> course [submission template](../../../submissions/template.md). It is **not**
> a submission to copy. Use your own observed register rows, predictions,
> independent field choices, governance reasoning, recovery notes and assistance
> disclosure.
>
> The guided `customers.created_at` example below is already supplied by the lab.
> The independent classification answer is intentionally **not** provided here.
> Your actual submission must contain the two field decisions you made in B1 and
> the complete SQL for the one independent field you inserted.

## How to use this sample

Keep your submission evidence-focused. Copy only the commands and narrow output
excerpts requested by Part C rather than your full terminal history.

For governance reasoning, a short answer is sufficient when it forms a consistent
chain:

**actual field → purpose → potential harm → classification → accountable role → retention → permitted use**

A more restrictive label is not automatically a better answer. Your explanation
should fit what the field actually contains and the purpose you are assuming.

Readable text is sufficient. Screenshots are optional. If you use screenshots,
remove usernames, hostnames, personal filesystem details, credentials and other
private information.

This sample also demonstrates a **repeat-run case**. In the instructor walkthrough,
`customers.created_at` was already present before the guided INSERT was executed,
and an additional prior-practice register row was also present. That is acceptable.
Use the named table/column pairs and actual row values rather than deleting data
to reproduce an exact row count.

---

# 1. Lab and execution evidence

**Lab number and title:**  
Lab 2: Classification and stewardship

## Part A baseline

**Command actually run:**

```bash
.venv/bin/python scripts/course.py lab 2
```

**Relevant result excerpt:**

```text
PASS: connection, dedicated database, schemas and non-superuser builder.
PASS: synthetic seed present (existing data preserved).
PASS: governance register. Add your own rationale in the submission template.
```

These lines establish that the Lab 2 technical checks completed. They do not grade
the student's governance reasoning.

## Part A guided INSERT

**Command actually run:**

```bash
.venv/bin/python scripts/query.py .local/worked-classification.sql
```

**Observed result:**

```text
PASS: connection, dedicated database, schemas and non-superuser builder.
[]
```

The empty JSON list does **not** mean the governance register is empty. The INSERT
does not use a `RETURNING` clause, so a successful INSERT can display `[]`. A
duplicate skipped by `ON CONFLICT ... DO NOTHING` can display the same thing.

## Part A guided-entry evidence

In the instructor walkthrough, `customers.created_at` was already present before
the guided INSERT. The correct response was therefore to report that it **already
existed** and then verify that its seven values remained unchanged.

**Before the preservation rerun:**

```json
[
  "customers",
  "created_at",
  "Internal",
  "Supports account-age reporting; linked timestamps can reveal customer activity.",
  "Customer Data Steward",
  "Retain while needed for account administration; review before deletion and honor approved holds.",
  "Aggregate account-age reporting only; individual profiling requires a separate purpose review."
]
```

After rerunning:

```bash
.venv/bin/python scripts/course.py lab 2
.venv/bin/python scripts/query.py labs/practice/inspect_register.sql
```

the same `customers.created_at` row remained present with the same seven values.

> On a first-time database, this row may first appear after A4. On a reused
> database, it may already exist. Submit what you actually observed.

## Part B independent work

The instructor walkthrough also added and preserved one independent register entry.
For a public sample, the exact independent classification decision is intentionally
withheld so that students still perform B1 and B2 themselves.

Your submission should include:

- the two fields you selected in B1;
- the complete written governance decision for both;
- the complete SQL for the one field you inserted;
- the actual independent row before the rerun;
- the same row after the rerun.

A narrow independent-row excerpt should look like this structurally:

```text
[
  "<table_name>",
  "<column_name>",
  "<classification>",
  "<your rationale>",
  "<owner/steward role>",
  "<retention rule>",
  "<AI or analytical-use statement>"
]
```

Do not replace your own evidence with this placeholder.

---

# 2. Prediction or initial expectation

## A1 identity prediction

Lab 2 asks what should happen if the configured database identity is wrong.

**Example level of detail:**

> I expected the environment check to stop rather than continue successfully if
> the configured database identity was not the required course identity.

If you had already run A1 before recording this prediction, write that honestly
instead of inventing a prior prediction.

## A4 guided-entry prediction

On a first run, a student might predict that the guided entry will bring the
register to three teaching entries.

In a repeat-run environment, use the evidence you already have. If the named pair
already exists, `ON CONFLICT ... DO NOTHING` should preserve the stored row rather
than create a duplicate or overwrite it.

## B5 preservation prediction

For your own independent row, record whether you expect it to remain after the
baseline rerun.

**Example structure:**

> I expected my independent register row to remain unchanged after rerunning
> `scripts/course.py lab 2` because the lab rerun preserves existing register
> entries rather than replacing them.

---

# 3. Observed result and explanation

## Part A: why the guided INSERT prints `[]`

The guided SQL inserts metadata into the governance register but does not include
a `RETURNING` clause. Therefore, the query helper can display:

```text
[]
```

even when the statement executes successfully.

In a repeat-run case, the same output can also occur because:

```sql
ON CONFLICT (table_name, column_name) DO NOTHING;
```

skips an already stored table/column pair. The output alone cannot tell which case
occurred. The register inspection is the evidence that shows whether the row is
present.

## Part A: what remained unchanged

In this walkthrough, `customers.created_at` already existed before A4. After the
guided SQL and the A5 rerun, the same table/column pair and all seven governance
values remained unchanged.

This is a valid repeat-run result. It would be incorrect to claim that A4 inserted
a new row if the row was already present beforehand.

## Part A: why repeated execution does not create another entry

The register uses the table/column pair as the conflict target. Repeating the
guided INSERT for `customers.created_at` therefore does not create another copy
of that same pair. With `DO NOTHING`, the existing row is preserved rather than
updated.

---

# 4. Investigation and independent transfer

## B1: written decision for field 1

Use your actual field.

**Table and column:**  
`<your customer or order field>`

**What the field actually contains:**  
Describe the value stored in the column itself. Do not describe data that might
exist in another system.

**Legitimate purpose:**  
State the business use you are assuming.

**Potential harm or misuse:**  
State a plausible consequence based on that actual value and context.

**Classification and why:**  
Choose exactly `Public`, `Internal`, `Sensitive` or `Restricted` and explain why
that label fits the purpose and potential harm.

**Accountable owner/steward:**  
Name a fictional business role connected to the purpose.

**Retention:**  
State a proposed retention rule and any assumption. Do not present an unsupported
legal requirement as established fact.

**AI or analytical use:**  
State a permitted use, restriction or review condition that actually fits this
field.

## B1: written decision for field 2

Repeat the same compact structure for your second field.

A student does **not** need to insert this second decision into the register. It
is written analysis only.

## B2: independent SQL artifact

Your actual submission must include the complete SQL from your saved:

```text
.local/my-classification.sql
```

To demonstrate the required structure without supplying an independent answer:

```sql
INSERT INTO {{schema}}.data_classification_register
    (table_name, column_name, classification, rationale,
     owner_role, retention_rule, ai_use)
VALUES (
    '<your table>',
    '<your column>',
    '<Public | Internal | Sensitive | Restricted>',
    '<your rationale>',
    '<your accountable role>',
    '<your proposed retention rule>',
    '<your permitted or restricted AI/analytical use>'
)
ON CONFLICT (table_name, column_name) DO NOTHING;
```

Do **not** submit these placeholders. Replace them with your actual saved SQL.

## B3/B4: independent insertion and inspection

After executing your independent file:

```bash
.venv/bin/python scripts/query.py .local/my-classification.sql
```

an environment PASS followed by `[]` can be normal. The required evidence is the
actual independent row found by:

```bash
.venv/bin/python scripts/query.py labs/practice/inspect_register.sql
```

Copy only your row, not the entire register.

## B5: preservation evidence

After rerunning:

```bash
.venv/bin/python scripts/course.py lab 2
.venv/bin/python scripts/query.py labs/practice/inspect_register.sql
```

copy your independent row again and compare it with B4.

A concise comparison is enough:

> The table/column pair and all seven stored values were unchanged after the
> baseline rerun.

## Test your reasoning before submitting

For **both** independent written decisions, verify that you can trace:

```text
actual field
→ legitimate purpose
→ plausible harm
→ classification
→ accountable role
→ retention
→ permitted use
```

A technically successful INSERT does not establish that this reasoning is sound.

### Avoid copied guided wording that does not fit

The guided `customers.created_at` example discusses account-age reporting. Do not
reuse phrases such as "aggregate account-age reporting" for an unrelated field
unless that use genuinely applies.

For example, if a field stores a category such as a payment method label, reason
from that stored category itself. Do not silently treat it as though the column
contains a full card number, bank-account number or other value not shown in the
field.

---

# 5. Interpretation, transfer, limitations and questions

## Alternative classification

Lab 2 asks you to defend one alternative classification for a chosen field.

A concise response can use this structure:

> I classified `<field>` as `<original classification>` because `<reason>`.
> A defensible alternative would be `<different classification>` if the assumed
> purpose or exposure changed to `<different assumption>`. Under that alternative,
> `<brief consequence for handling>`.

The goal is not to claim that two labels are equally correct. The goal is to show
that classification depends on the stated purpose, context and plausible harm.

## Why a recorded rule is not enforcement

The governance register documents a decision. Storing a classification, retention
rule or AI-use restriction does not itself:

- prevent a database user from reading the field;
- automatically delete data when retention expires;
- technically block a model from using the field;
- prove that downstream systems follow the recorded policy.

Those controls require separate technical or operational mechanisms.

## Evidence limitation

A useful Lab 2 limitation is:

> The successful INSERT and preservation check prove that the governance metadata
> was stored and remained present in this database. They do not prove that the
> classification is substantively correct or that the recorded restrictions are
> technically enforced.

## Unresolved questions

If none remain, write:

```text
None.
```

Do not invent a question simply to fill the section.

---

# 6. Recovery and assistance

## Recovery

If your Lab 2 work produced no error, it is acceptable to write:

```text
No execution error required recovery.
```

If an error occurred, report the actual error code or message, what you corrected
and the successful retry. Do not replace the failed attempt with an invented clean
history.

Examples from the lab's recovery guidance include:

- `23514`: invalid classification label;
- `42601`: SQL syntax problem;
- `42501`: permission denied.

A later PASS is not, by itself, an explanation of what was fixed.

## Assistance and verification

Use your actual assistance history.

**Example disclosure when AI was used:**

> I used AI assistance to help interpret the Lab 2 submission requirements,
> distinguish technical success from governance reasoning, and review whether my
> rationale, retention statement and permitted-use statement matched the field I
> selected. I verified the technical result by inspecting my actual register row
> before and after rerunning Lab 2 and checked the final reasoning against the
> seven decision elements required in B1.

If you did not use AI assistance, write:

```text
None.
```

Follow the current course AI-use rules. Disclosure does not replace your own
reasoning or verification.

---

# Before submitting

Check that your private submission contains:

- the Lab 2 baseline command and three relevant PASS lines;
- the actual `customers.created_at` row before/after the A5 preservation check;
- a brief explanation of `[]`;
- a brief explanation of why repeating the guided INSERT does not create another
  entry;
- two independent written field classifications from B1;
- complete SQL for the one independent field you inserted;
- your independent row before and after B5;
- your recorded predictions, or an honest note where one was not recorded first;
- one alternative classification and its assumption;
- an explanation of why the register records policy but does not enforce it;
- one limitation of the evidence;
- recovery information if an error occurred;
- your assistance disclosure and verification method.

Do **not** include:

- the full governance register when only one row is required;
- a full terminal transcript;
- usernames or hostnames from your shell prompt;
- `.env`, passwords, tokens or full connection strings;
- unrelated prior-practice rows merely to reproduce an exact count;
- the guided `customers.created_at` decision presented as your independent work;
- copied governance wording that does not fit your selected field.

Keep the filled submission private and submit it through the LMS or the instructor's
specified private channel. Do not commit a filled student submission to the public
repository.

---

## Instructor note about this example

This exemplar intentionally demonstrates the **repeat-run case** encountered during
the instructor walkthrough: `customers.created_at` was already present before the
guided INSERT, `[]` was observed when the guided SQL ran, and the row remained
unchanged after the preservation rerun. An additional prior-practice row was also
present, illustrating why students should verify named fields rather than force an
exact register count.

The public exemplar does not publish the instructor's exact independent
classification answer. That preserves B1/B2 as genuine student decision-making
while still showing the expected submission structure, evidence selection,
brevity and reasoning standard.

Author: [Isaac K. Nti](../../../AUTHORS.md). [Citation and reuse terms](../../../CITATION.md).
