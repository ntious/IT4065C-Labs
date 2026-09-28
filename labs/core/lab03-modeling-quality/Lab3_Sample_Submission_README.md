# Lab 3 sample submission: Modeling and data quality

> **Student-facing example: format and level of detail only**
>
> This file demonstrates how to organize a concise Lab 3 submission using the
> course [submission template](../../../submissions/template.md). It is **not**
> a submission to copy. Use your own observed output, predictions, independent
> test, explanations, recovery notes and assistance disclosure.
>
> The independent-test example below intentionally uses the supplied
> `gross_sales` starter pattern to demonstrate **submission format without giving
> an answer to the required independent choice**. Your actual Lab 3 submission
> must contain the independent rule you designed in B2.2.

## How to use this sample

Keep your submission short and evidence-focused. Copy only the command/result
excerpts requested by the lab, not your full terminal history. One to three
sentences are normally enough for each reasoning item unless the lab asks for a
calculation or SQL block.

Readable text is sufficient. Screenshots are optional. If you use a screenshot,
remove usernames, hostnames, personal filesystem details, credentials and other
private information.

The values below show what an instructor walkthrough of the unchanged synthetic
fixture looked like. If your own observed values differ, submit your actual values
and investigate the difference rather than replacing them with this sample.

---

# 1. Lab and execution evidence

**Lab number and title:**  
Lab 3: Modeling and data quality

## Part A baseline build

**Command actually run:**

```bash
.venv/bin/python scripts/course.py lab 3
```

**Relevant result excerpt:**

```text
PASS: connection, dedicated database, schemas and non-superuser builder.
PASS: synthetic seed present (existing data preserved).
PASS: dbt build --selector course
PASS: 10 models and 37 data tests actually executed.
```

The completion banner confirms the selected technical checks ran successfully. It
does not by itself complete the interpretation or independent-test requirements.

## Part A daily-sales inspection

**Command actually run:**

```bash
.venv/bin/python scripts/query.py labs/practice/inspect_sales.sql
```

**Relevant result excerpt:**

```text
[
  ["2026-01-10", 2, "3", "129.97", "64.9850000000000000"],
  ["2026-01-11", 1, "2", "9.98", "9.9800000000000000"]
]
```

These rows show the daily completed-order reporting results used in the Part A
interpretation.

## Part B guided test

After adding the supplied guided test, the course runner showed:

```text
PASS: 10 models and 38 data tests actually executed.
```

## Part B final technical verification

After the independent test file was saved and corrected, the final Lab 3 run showed:

```text
PASS: connection, dedicated database, schemas and non-superuser builder.
PASS: synthetic seed present (existing data preserved).
PASS: dbt build --selector course
PASS: 10 models and 39 data tests actually executed.
```

The named-result checker then showed:

```text
lab3_guided_daily_orders status=pass failures=0
lab3_my_sales_rule status=pass failures=0
```

The named results are stronger evidence than the test count alone because they
identify the two Lab 3 student tests that executed.

---

# 2. Prediction or initial expectation

## Part A prediction

**Example level of detail:**

I expected a successful Lab 3 build to show that the supplied models and selected
data tests could execute successfully against the current synthetic fixture. I did
not expect that result to prove that every possible dataset is correct or that the
project is production-ready.

> If you ran the command before recording a prediction, say that honestly rather
> than inventing a prediction afterward.

## Part B guided-test prediction

I expected the guided daily-orders test to pass because the observed daily order
counts were `2` and `1`, both greater than zero.

## Part B independent-test prediction

Write your own prediction based on the field and violation rule you chose in B2.2.

**Example structure:**

> I expected my independent test to [pass/fail] because the A2 values for
> `[selected field]` were `[observed values]`, and neither/both matched my
> violation condition.

---

# 3. Observed result and explanation

## Part A interpretation

### 1. Repeated totals and what one daily row represents

Order 1 contains two item rows. If its order-level total of `79.98` were summed
once for each joined item row, it would be counted twice and incorrectly become
`159.96`. The model avoids that error by reducing the joined item rows to one row
per order before producing the daily result.

**One row in the daily sales output represents one day of completed-order reporting.**

### 2. January 11 explanation and total revenue calculation

January 11 reports one completed order with two units and `9.98` in revenue because
the `19.95` order is cancelled and therefore excluded from the completed-order
report.

```text
129.97 + 9.98 = 139.95
```

The overall completed-order revenue in the supplied fixture is therefore `139.95`.

### 3. Completed-order rule and the effect of including order 3

The condition:

```sql
where o.order_status='completed'
```

implements the reporting rule that only completed orders contribute to the daily
sales mart. For this fixture, including cancelled Order 3 would increase reported
revenue because its `19.95` amount would no longer be excluded.

## Part B observed result

The guided test and independent test both executed in the final run and were
reported by name as:

```text
lab3_guided_daily_orders status=pass failures=0
lab3_my_sales_rule status=pass failures=0
```

A passing dbt test means that the query returned no rows violating that specific
rule in that execution. It does not prove that the model or dataset is completely
correct.

## Recovery example

During the instructor walkthrough, the first attempt to run the independent test
caused dbt to stop:

```text
STOP: dbt failed. Read .local/dbt-last.log locally; redact paths before sharing.
```

The test file was reopened, corrected and saved. The next Lab 3 run completed with
10 models and 39 tests, and the named-result checker confirmed both Lab 3 tests
passed.

A student who encounters an error should briefly report the actual failure and
recovery rather than hiding the failed attempt or claiming the first run succeeded.

---

# 4. Investigation and independent transfer

## Guided-test reasoning

The guided test checks whether a reported day has a missing or non-positive
completed-order count. The observed daily counts were `2` and `1`, so the guided
rule found no violations.

## Independent-test artifact

Your actual submission must include the **complete SQL from your own saved**
`dbt/it4065c_platform/student_tests/lab3_my_sales_rule.sql`.

To demonstrate formatting without supplying the assessed independent answer, this
sample uses the **provided starter pattern**, which is not sufficient for the
student's independent submission:

```sql
select order_date, gross_sales
from {{ ref('olap_sales_by_day') }}
where gross_sales is null or gross_sales < 0
```

> **Do not submit the unchanged starter as your independent work.** In Lab 3 B2.2,
> choose the required independent field and justify your own rule.

For your actual independent test, include the following concise items.

**Rule / assumption:**  
State in one sentence what should be true about your selected field at the daily
grain.

**Valid example:**  
Give one value that should not be returned by the test.

**Hypothetical violating example:**  
Give one value that should be returned by the test. Do not insert the hypothetical
row into the database.

**Why the predicate catches it:**  
Explain in one sentence why your `WHERE` condition selects the violating example
and excludes the valid example.

**Prediction:**  
State whether you expected the current fixture to pass or fail and connect that
prediction to the values observed in A2.

**Named actual result:**  
Copy the named result for `lab3_my_sales_rule` from the supplied result checker.

**Comparison with the existing line-value check:**  
State one overlap or difference. A useful distinction to consider is the grain:
the existing line-value check operates at item level, while your Lab 3 rule operates
on the daily sales model.

---

# 5. Evidence limitations and questions

## Example limitation for the baseline

The successful build shows that the selected models and tests passed for this
execution against the current synthetic data. It does not establish production
performance, correctness for every possible input, or completeness of all business
rules.

## Independent-test limitation

State one thing your own rule does **not** establish.

**Example structure:**

> My test checks `[specific rule]`, but it does not verify `[different claim the
> rule cannot establish]`.

If your predicate does not test `NULL`, do not claim that it detects missing values.
If it tests only one aggregate field, do not claim that it proves the entire mart is
correct.

**Unresolved question:**  
If none remains, write `None`. Do not invent a question simply to fill the section.

---

# 6. Assistance and verification

Use your actual assistance history.

**Example disclosure when AI was used:**

> I used AI assistance to help interpret the Lab 3 instructions, compare my
> terminal output with the expected results, clarify the join/double-counting
> example, and review the structure of my independent test. I verified the
> guidance by rerunning Lab 3 and using the supplied named-result checker.

If you did not use AI assistance, write:

```text
None.
```

Follow the current course AI-use rules. Disclosure does not replace your own
verification or independent reasoning.

---

# Before submitting

Check that your private submission contains:

- your own Lab 3 baseline command and narrow PASS excerpt;
- your own two daily-sales rows;
- your three short A3 interpretations;
- your guided-test prediction and named result;
- the file name and complete SQL for **your own** independent test;
- your rule/assumption and prediction;
- one valid example and one hypothetical violating example;
- why your predicate catches the violation;
- one overlap or difference from the existing check;
- one limitation;
- a brief recovery note if an error occurred;
- your assistance disclosure and verification method.

Do **not** include:

- a full terminal transcript;
- usernames or hostnames from your shell prompt;
- personal filesystem details that are not needed as evidence;
- `.env` contents, passwords, tokens or connection strings;
- generated dbt logs or artifact directories;
- another student's work;
- the unchanged starter presented as your independent test.

Keep the filled submission private and submit it through the LMS or the instructor's
specified private channel. Do not commit a filled student submission to the public
repository.

---

## Instructor note about this example

This sample is intentionally more explicit than a student's final submission needs
to be. Its purpose is to demonstrate **scope, organization and evidence selection**
so students can focus their effort on interpretation and independent test design.

The baseline values and guided-test results shown here are derived from the supplied
synthetic fixture and are already documented in the Lab 3 instructions. The
independent-test answer is intentionally withheld: students must still design,
explain and verify their own B2.2 rule.

Author: [Isaac K. Nti](../../../AUTHORS.md). [Citation and reuse terms](../../../CITATION.md).
