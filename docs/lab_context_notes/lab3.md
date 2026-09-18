# Lab 3: Grain, models and data quality

The pipeline separates raw source records, standardized staging views, core entities
and purpose-specific marts. In this teaching database, raw records are synthetic;
the core models are derived copies, not automatically an authoritative system of record.

State the grain before writing a join. An order has several items. Joining its total
to each item repeats that total, which can distort sums and averages. The sales mart
first aggregates items to one row per order, then aggregates completed orders by day.
Its cancelled-order policy is a business assumption that must be documented.

A dbt data test returns rows violating an expectation. Uniqueness, missing values,
relationships and amount reconciliation are different claims. A passing test does
not prove the entire dataset is correct. Tests run when invoked; they are not database
constraints that prevent every future invalid write. This fixture deliberately leaves
some relationships to dbt tests so learners can observe the distinction.

The detailed and aggregate marts illustrate workload differences. They do not establish
transaction throughput, dimensional completeness or production performance. Explain
which additional measurements would be needed for those claims.

**Check your understanding:** Why is an average over joined line items different from
average order value? Derive both denominators and design a test that catches the error.

[Run Lab 3](../../labs/module_2/lab3/README.md) · [Hands-on practice](../../labs/practice/README.md)

---

Author: [Isaac K. Nti](../../AUTHORS.md). [Citation and reuse terms](../../CITATION.md).
