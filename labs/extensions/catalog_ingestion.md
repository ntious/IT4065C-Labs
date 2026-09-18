# Optional Lab 10: Catalog and curate mixed-format sources

> **Completion:** Passing automated checks, where present, confirms technical behavior.
> Complete the independent task, explanation and evidence specified on this page.

**Author:** Isaac K. Nti. **Outcomes:** SLOs 1, 2, 4. **Time:** 60–90 minutes.
Optional enrichment; does not add a required assessment to the core course.

## Purpose and prerequisites

Complete setup and Lab 2. A retailer provides CSV transactions, JSON events and a
plain-text purpose statement. Decide which data may enter an analytical pipeline.
All inputs in `data/ingestion/` are synthetic. There is no download or paid service.

Vocabulary: structured, semi-structured, unstructured, provenance, allowlist, quarantine.
The text document is cataloged, not automatically transformed into trustworthy facts.

## Predict and run

1. Inspect all three files in `data/ingestion/`. Predict which two records will fail
   validation and which fields must be excluded from the approved records.
2. Run from the repository root in Ubuntu:

   ```bash
   .venv/bin/python scripts/optional_labs.py catalog
   ```

3. Read `.local/ingestion-evidence.json` locally. Expect three catalog entries,
   three accepted records, two quarantine references and an accepted total of 45.00.
4. Trace the allowlisted output fields and validation checks in `curate` in
   `scripts/optional_labs.py`. Explain the difference between excluding a field
   here and deleting it from the original source.

## Investigate and transfer

Explain how each source hash supports provenance but does not prove accuracy or
permission to use data. The quarantine stores record locations and generic reasons,
not the rejected contact information. Identify what a steward needs to investigate.

Design an ingestion contract for an unfamiliar support-ticket JSON object. Specify
permitted fields, required types, prohibited free text, owner, purpose, retention and
AI-use constraints. Do not infer permission to train an AI system from availability.
Add a focused unit test for one new rejection rule and explain its expected result.

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
