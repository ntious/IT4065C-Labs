# From a worked example to independent reasoning

For each core lab, first run its baseline and read its concept notes. Use the middle
column with a peer or instructor, then complete the independent practice in your own
words. Keep drafts private. You do not need to complete optional labs for this sequence.

| Lab | Guided example to inspect | Partially supported task | Independent transfer and self-check |
| --- | --- | --- | --- |
| 1 | Setup checks a dedicated builder connection | Draw OS user → runner → database role; fill in which boundary each identity controls | Explain why knowing a schema name grants no privilege. Name an actual permission check rather than claiming connection proves access. |
| 2 | Existing classification register entry | Fill in: field → purpose → sensitivity → owner → retention → allowed AI use; compare two plausible classifications | Add a different synthetic field using the practice guide. Defend classification and verify the row survives rerun. |
| 3 | Staging/core/mart path and worked library join in the foundations bridge | Write the grain beside each relation; identify where an order total repeats after joining items | Author a new dbt test, predict its result and explain the violating rows it would return. Do not simply copy a baseline test. |
| 4 | Generated lineage from raw orders to both marts | Trace one deletion through source → derived table → report → backup, marking proposed actions | Decide how to retire a different derived copy and identify what the DAG cannot enforce. Include an owner and evidence needed. |
| 5 | Analyst sales access and denied masked-data access | Fill in a role/action/object/expected-result table before running the practice queries | Propose a narrower view for another legitimate purpose; identify a privacy risk that masking leaves. |
| 6 | One live client observation and one synthetic alert | Label source, rule, observation, possible alternative explanation and missing event | Design one additional detection question, its evidence source and a plausible false positive. Distinguish a proposed rule from an executed rule. |
| 7 | Baseline and mitigation metrics | Recalculate one group's rate using its denominator; identify the cost of each error | Complete the AI decision and purpose-change review. Include an affected stakeholder, accountable owner and reason to revisit the decision. |

## Three short fictional reasoning examples

**Modeling:** "The join returned three rows" is an observation. "The library loan
has item grain after joining, so repeating a loan-level fee overcounts it" explains
the mechanism. A stronger response gives the expected total and a test condition.

**Infrastructure:** "Cloud is always more scalable" is unsupported. "This proposal
could resize compute, but we have not measured throughput, cost or recovery under
load" distinguishes a design option from evidence. Name the experiment needed.

**AI:** "Both groups have the same selection rate, so the model is fair" is too broad.
"Selection rates match in this small fixture; error costs, label quality and affected
people's ability to appeal remain unresolved" supports a bounded governance decision.

Use [assessment descriptors](assessment_examples.md) to review your explanation.
A PASS establishes the runner's assertions, not completion of your independent work.
If stuck, return to the supported task, name the missing concept and use the glossary
or ask for help with a short redacted example.

---

Author: [Isaac K. Nti](../AUTHORS.md).
