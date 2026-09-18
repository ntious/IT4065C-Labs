# Your hands-on investigation

Run each lab's verified baseline first. Then use the activity below to build your
own explanation and artifact. The runner proves a baseline works; your investigation
shows whether you can apply the concept to a changed situation.

## Execute your own SQL without managing passwords

From the repository root:

```bash
.venv/bin/python scripts/query.py labs/practice/inspect_register.sql
```

The helper uses the same private .env and non-administrator builder. It executes
SQL you supply, so read the file first and keep experiments inside this disposable
database. `{{schema}}` is replaced with your safely quoted configured schema.
It prints the final statement's rows as JSON. SQL errors show SQLSTATE codes without
printing connection details. Put personal drafts under ignored `.local/`.
For temporary experiments use `BEGIN; ... ROLLBACK;` in the same file.

## Lab 1 — Explain the boundary

Read `.env.example`, `profiles.yml` in the dbt project, and the `connect` method in
`scripts/course.py`. Draw how configuration reaches the client and server without
hardcoding a password. Explain why an Ubuntu sudo password and a database password
have different purposes. Do not put either password in your submission.

## Lab 2 — Classify an additional field

Inspect the register with the command above. Copy the insert example in
`labs/module_2/lab2_insert_templates.sql` to `.local/my-classification.sql`. Replace
the two worked entries with one new field from the synthetic raw dataset; provide
your own classification, rationale, owner, retention rule and AI-use restriction.
Execute your file with `scripts/query.py`, then inspect the register again. Rerun
Lab 2 and verify your row is preserved. Defend one plausible alternative classification.

## Lab 3 — Trace grain and test a hypothesis

```bash
.venv/bin/python scripts/query.py labs/practice/inspect_sales.sql
```

Trace each result to raw orders and items using the staging/core/mart SQL. Work out
the completed-order total of 139.95 independently. Explain why cancelled orders and
the number of line items affect naive calculations. Add one new dbt SQL test in
`dbt/it4065c_platform/tests/`, predicting pass/fail first, and rerun Lab 3. A test
returns rows that violate its rule. Submit your rule and reasoning, not copied
dbt debug logs. Instructors can use `scripts/verify.py` for a controlled bad-data
injection and restoration rehearsal on the unmodified fixture.

## Lab 4 — Use lineage to make a decision

Open the generated local documentation using `scripts/course.py docs`. Trace
`raw.orders` through staging and the fact table to both marts. Complete
`labs/module_3/lab4/_turnin_template.md`. Suppose retention removes a raw record:
which materialized downstream copies could persist, and what would you refresh?
Document the lineage path in text as an accessible alternative to a screenshot.

## Lab 5 — Predict, authenticate, compare

```bash
.venv/bin/python scripts/query.py labs/practice/read_sales.sql --role analyst
.venv/bin/python scripts/query.py labs/practice/read_masked.sql --role analyst
.venv/bin/python scripts/query.py labs/practice/read_masked.sql --role steward
```

Predict each result first. The middle command must exit unsuccessfully with 42501;
that is successful protection. These are different authenticated connections, not
an administrator pretending to be a reader. Explain what the masked values still
reveal. Propose a narrower view for a different legitimate business purpose.

## Lab 6 — Investigate evidence, not just alerts

Read `.local/audit-report.json` locally. For each flag, trace the rule in
`labs/module_6/lab6/01_generate_audit_report.sql` and the corresponding synthetic
fixture. Write one false-positive explanation and one possible missed incident.
Distinguish what the live client observed from what the fixture merely simulates.
Propose a server-side evidence source and who should control access to it.

## Lab 7 — Make an accountable AI decision

Open `.local/ai-evaluation.json` and `data/ai_predictions.csv`. Recalculate one
group's false-negative rate by hand; compare both policies. Complete
`labs/extensions/ai_decision_template.md`, including a decision, owner, review
trigger and appeal route. Explain whose interests a metric can fail to capture.
Use NIST AI RMF 1.0 as the named framework version for this exercise.

## Lab 8 — Challenge retention behavior

Read `labs/extensions/retention.sql` and predict the surviving IDs after each delete.
Copy it to `.local/retention-experiment.sql`, add an expired record under legal hold,
and add an assertion that the hold survives deletion and simulated restore. Keep
the final ROLLBACK; execute using `scripts/query.py`. Explain how a separately
protected deletion ledger and real backup policy would differ from temporary tables.

## Lab 9 — Discuss deployment implications

Read `labs/extensions/infrastructure.sql`; identify the exact point when the
snapshot becomes stale. Copy it locally and insert a third operational record;
update your predicted count and total assertions, then execute. Compare on-premises,
cloud and hybrid options for freshness, failure domains, identity, connectivity,
cost and operational ownership. This experiment tests snapshot logic; it does not
measure network replication, availability, RPO or RTO.
