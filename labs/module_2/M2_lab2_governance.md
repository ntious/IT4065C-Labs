# Lab 2: Classification and stewardship

**Outcomes:** SLOs 1,5. **Estimated time:** 45–60 minutes; allow additional time for installation and support.
**Environment:** your dedicated local course database. Synthetic data only.

## Concept

Classification connects a data field to an intended use, accountable owner and
control. A label alone does not restrict a query. The register records your reasoning;
Lab 5 implements selected controls through database grants and views.

Use the field’s meaning, context and plausible harm to justify its class. A customer
email is a contact identifier even if its SQL type is merely text. Aggregation can
reduce exposure but small groups and joins may reveal information. Classification
can change when data is combined or repurposed for AI.

Worked entries demonstrate the format, not an organization-wide policy. Retention
periods must come from an approved purpose and applicable requirements; do not invent
a universal legal retention duration. Record unresolved assumptions explicitly.

**Check your understanding:** Two teams classify an amount differently. What business
context would resolve the disagreement? What evidence would show that their chosen
control actually operates? Add a field with your own rationale using the investigation below.

> **Completion:** Automation passing means the environment checks worked. Complete
> the independent investigation, interpretation and evidence below before submitting.

## Before you begin

Complete [setup](../../docs/setup.md) and Lab 1. No university service or hidden download is needed.
The runner checks its required state and reports missing prerequisites.

## Predict and run

Read the expected result below and predict what would fail with the wrong identity or missing input.
From the repository root in your Ubuntu terminal:

```bash
.venv/bin/python scripts/course.py lab 2
```

### Expected terminal output

A successful run prints these summary checks:

```text
PASS: connection, dedicated database, schemas and non-superuser builder.
PASS: synthetic seed present (existing data preserved).
PASS: governance register. Add your own rationale in the submission template.
```

A completion message follows. Older checkouts may show a garbled separator after
`LAB 2 COMPLETE`; that does not change the check results. Use the three PASS lines
as evidence, not the exact punctuation of the completion message.

| Check | What it establishes | What you still need to investigate |
| --- | --- | --- |
| Connection and builder | The same environment checks used in Lab 1 pass. | This is not a new test of all analyst/steward permissions. |
| Synthetic seed | The runner creates the four source tables on first use and checks the expected table presence and that customers are present. Existing data are preserved. | This is not a complete data-quality check; later modeling tests examine additional rules. |
| Governance register | The register setup and worked-example inserts succeed, and the register contains at least two entries. | The runner does not grade your rationale, validate every classification, or enforce retention and AI-use rules. |

On a fresh course database there are two worked register entries: `customers.email`
and `orders.total_amount`. Reruns can show more entries because your additions are
preserved. **The lab command does not print the table contents or register rows.**
Use the inspection command below to see those rows. No extra installation is needed.

## Hands-on investigation

1. Inspect the register from the repository root:

   ```bash
   .venv/bin/python scripts/query.py labs/practice/inspect_register.sql
   ```

   This prints register rows as JSON, including classification, rationale, owner,
   retention rule and AI use. Read the two worked examples before choosing new fields.
2. Choose one additional customer field and one additional order field from the
   synthetic source definitions in `labs/module_2/lab2_seed.sql`. Do not reuse the
   two worked fields. Classify both in your written submission; include sensitivity,
   purpose, rationale, owner, retention assumptions and permitted AI use.
3. Insert **one of your two chosen fields** into the register. Create a private draft:

   ```bash
   cp labs/module_2/lab2_insert_templates.sql .local/my-classification.sql
   nano .local/my-classification.sql
   ```

   Replace the two example value tuples with one tuple for your selected field.
   Keep the seven-column order and `{{schema}}` placeholder, remove the comma that
   separated the original tuples, and retain `ON CONFLICT ... DO NOTHING;`.
   Use your own rationale and fictional owner role, not personal details.
   Execute the saved file and inspect the result:

   ```bash
   .venv/bin/python scripts/query.py .local/my-classification.sql
   .venv/bin/python scripts/query.py labs/practice/inspect_register.sql
   ```

   An INSERT need not print the inserted row; the inspection query supplies the
   evidence. The conflict clause skips an existing table/column pair, so repeating
   an insert does not revise that entry. Choose a genuinely new field for this task.
4. Test preservation by rerunning the baseline and inspecting again:

   ```bash
   .venv/bin/python scripts/course.py lab 2
   .venv/bin/python scripts/query.py labs/practice/inspect_register.sql
   ```

   Confirm your selected row and its rationale remain. This repeat has a specific
   purpose: testing preservation after your edit. Do not claim preservation from
   the baseline PASS message alone; compare the observed row before and after.

For custom SQL, use the [query helper instructions](../practice/README.md#execute-your-own-sql-without-managing-passwords).

## Interpret and transfer

Use the two fields you selected above; no third field is required. Defend one
plausible alternative classification and explain which business context would change
your decision. Compare with a peer if available; independent learners can write the
alternative perspective themselves. Explain why a register label alone does not
prevent an unauthorized query.

## Submit

Create a private Lab 2 submission using the [shared template](../../submissions/template.md).
Leave the repository template unchanged. Include:

1. **Command and baseline evidence:** `.venv/bin/python scripts/course.py lab 2`
   and the three PASS lines from your own run. Do not submit your full terminal
   history, personal shell prompt or private configuration.
2. **Prediction:** your recorded expectation before the baseline run. If you already
   ran it without recording one, say so honestly; do not invent a prior prediction.
   Before the preservation experiment, predict whether your new row will survive.
3. **Observed register evidence:** the inspection command and the JSON excerpt for
   your inserted field before and after rerunning Lab 2. Describe the comparison.
4. **Your classifications:** the two written field classifications and your edited
   INSERT statement for one of them. This reasoning is your work, not runner output.
5. **Interpretation and transfer:** the alternative classification and the distinction
   between recording a policy and enforcing it. State one limitation of these checks.
6. **Assistance disclosure:** complete the common template's assistance section.

Readable text evidence is sufficient; screenshots are optional. Submit privately
through the course system, or retain the work locally for independent study.
A successful baseline run alone does not complete this lab.

Rubric: correct execution/evidence 25%; accurate interpretation 35%; transfer and
tradeoff reasoning 30%; clarity and evidence limitations 10%.

## Recovery

Use the [setup troubleshooting table](../../docs/setup.md). Read errors before retrying;
never delete tests or change authentication to make a result pass. There is no
automatic destructive reset. For an isolated new start use a new DB/user pair.

[Back to all labs](../../labs/README.md)

---

Author: [Isaac K. Nti](../../AUTHORS.md). [Citation and reuse terms](../../CITATION.md).
