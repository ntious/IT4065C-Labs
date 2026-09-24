# Optional Lab 10: Catalog and curate mixed-format sources

> **Completion:** Passing automated checks, where present, confirms technical behavior.
> Complete the independent task, explanation and evidence specified on this page.

**Author:** Isaac K. Nti. **Outcomes:** SLOs 1, 2, 4. **Time:** 60–90 minutes.
Optional enrichment; does not add a required assessment to the core course.

## Why this lab matters

Available data is not automatically fit or approved for reuse. You will examine three formats, follow curation decisions, and test a small contract for another source.

## Learning objectives

These instructor-developed objectives support the outcomes above. You will:

- Classify sources and explain accepted versus quarantined records.
- Distinguish a source fingerprint from accuracy or permission.
- Specify and test a rejection rule for a synthetic ticket contract.

## Skills you will practice

Read a catalog, reconcile accepted amounts, inspect an allowlist and adapt a supplied Python unit test.

## Purpose and prerequisites

Complete [Lab 2](../module_2/M2_lab2_governance.md) and use the same configured Ubuntu environment. Run commands from the repository root. A retailer provides CSV transactions, JSON events and a
plain-text purpose statement. Decide which data may enter an analytical pipeline.
All inputs in `data/ingestion/` are synthetic. There is no download or paid service.

Vocabulary: structured, semi-structured, unstructured, provenance, allowlist, quarantine.
The text document is cataloged, not automatically transformed into trustworthy facts.

## Part A: Follow the supplied catalog example

1. Inspect all three files in `data/ingestion/`. Predict which two records will fail
   validation and which fields must be excluded from the approved records.
2. Run from the repository root in Ubuntu:

   ```bash
   .venv/bin/python scripts/optional_labs.py catalog
   ```

3. Expect:

   ```text
   PASS: three source types cataloged; three approved records; two quarantined; total 45.00.
   Contact fields and free text excluded. Evidence: .local/ingestion-evidence.json
   ```

   Open the report:

   ```bash
   .venv/bin/python -m json.tool .local/ingestion-evidence.json
   ```

   `catalog` describes sources, `accepted` contains the approved records, and
   `quarantine` gives source/record-number references with generic reasons.
   Read these locally. Expect three catalog entries,
   three accepted records, two quarantine references and an accepted total of 45.00.
4. Trace the allowlisted output fields and validation checks in `curate` in
   `scripts/optional_labs.py`. Explain the difference between excluding a field
   here and deleting it from the original source.

## Part B: Design and test another source contract

Explain how each source hash supports provenance but does not prove accuracy or
permission to use data. The quarantine stores record locations and generic reasons,
not the rejected contact information. Identify what a steward needs to investigate.

Design an ingestion contract for an unfamiliar support-ticket JSON object. Specify
permitted fields, required types, prohibited free text, owner, purpose, retention and
AI-use constraints. Do not infer permission to train an AI system from availability.
Use the following steps to add a focused test. This miniature contract is separate
from the retail ingestion pipeline; it does not modify the course dataset.

### B1. Run the supplied ticket example

```bash
.venv/bin/python labs/extensions/catalog_contract_example.py
```

Expected: `test_accepts_minimal_ticket` and `test_rejects_free_text` both end in
`ok`, followed by `Ran 2 tests` and `OK`. The elapsed time varies. The script permits
only non-empty `ticket_id` and `category` strings. Rejecting an extra `message`
field illustrates a free-text restriction; it does not detect all sensitive content.

### B2. Make your private copy

Run separately:

```bash
mkdir -p .local
```

```bash
cp -i labs/extensions/catalog_contract_example.py .local/my-ticket-contract.py
```

```bash
nano .local/my-ticket-contract.py
```

On a repeat attempt, answer **n** if asked to overwrite. The file contains working
code. Keep the two supplied tests. You will add a rule inside `validate_ticket`
and a matching method inside `TicketContractTests`.

### B3. Add one justified rejection rule

A supported example is to permit only the categories `delivery` and `billing`.
If this matches your proposed contract, insert the following at the comment
`Add your justified category rule here`, **before** `return record`, using four
spaces of indentation:

```python
    if record["category"] not in {"delivery", "billing"}:
        raise ValueError("Category is not approved")
```

Inside the test class, below the existing methods and **before**
`if __name__ == "__main__":`, add:

```python
    def test_rejects_unapproved_category(self):
        with self.assertRaises(ValueError):
            validate_ticket({"ticket_id": "demo-2", "category": "other"})
```

`assertRaises` checks that the rejected input raises the intended error. The
allowed ticket test must still pass. You may use this rule unchanged, but explain
why the permitted categories suit your scenario, who approves them, and a
limitation. Alternatively implement a different justified rule with its own test.
Save with **Ctrl+O**, **Enter**, **Ctrl+X**.

### B4. Run your contract test

```bash
.venv/bin/python .local/my-ticket-contract.py
```

For the supported example, expect **three tests**, each `ok`, then `OK`.
If Python reports an indentation error, compare the spaces with B3. A test failure
means the rule and expectation disagree; inspect both rather than deleting the test.
Submit your private script and this result alongside the written source contract.
No programming from a blank file is required.

## Evidence and assessment

Submit your predictions, catalog interpretation, one test and the new contract using
the common private submission template. Suggested rubric: source classification 25%,
curation/minimization 30%, provenance and purpose 25%, transfer/limitations 20%.

## Recovery and limits

Rerunning replaces only `.local/ingestion-evidence.json`; source fixtures stay unchanged.
The baseline command asserts the supplied fixture counts. Keep experiments in your
own fixture and test rather than weakening these assertions. This lab does not
demonstrate a commercial catalog, unstructured-text extraction or enterprise ETL.

[All labs](../README.md) · [Attribution](../../CITATION.md)

---

Author: [Isaac K. Nti](../../AUTHORS.md). [Citation and reuse terms](../../CITATION.md).
