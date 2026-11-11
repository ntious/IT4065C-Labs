# Foundations examples: Chapters 1–3

Run `foundations` using the [companion launcher](../../SETUP.md).

Predict whether a query answers the intended sales question and whether each proposed insert/update satisfies the stated relational rules. The suite executes a bounded sales example, keys and constraints, positive and negative enforcement tests, detection-versus-enforcement checks, and normalization anomalies.

The six SQL stages include assertion helpers and produce 25 explicit assertions in the reference run. Expected rejected writes are checked for the intended SQLSTATE. Successful statements and final rows are checked as well. Source files remain small enough to inspect beside the relevant chapter listings.

Record one rule, its implementation location, a valid case, an invalid case, the observed result and what the mechanism does not cover. Explain why a dbt relationship test and a PostgreSQL foreign key have different effects.

This suite uses textbook-created schemas, not the full course dbt model or a complete retailer application. Chapter 2's requirements discussion is handled through the chapter activity and public case material; no SQL run can establish stakeholder agreement. This launcher uses the SQL-only route: it does not claim automated equivalence with a particular printed manuscript edition.
