# Repository Investigation: Distinguish declared relationships from enforced integrity

Chapter 3 — Data Modeling and Integrity

**Resources:** [EDS-DATA-001](https://github.com/ntious/IT4065C-Labs/blob/d860dd98256a8090ffc6bd3766c59cb15a553c12/labs/core/lab02-classification/lab2_seed.sql); [EDS-LAB-003](https://github.com/ntious/IT4065C-Labs/blob/d860dd98256a8090ffc6bd3766c59cb15a553c12/labs/core/lab03-modeling-quality/README.md). **Type:** INVESTIGATE. 

**Before you begin:** Chapter 2 and §§3.2–3.7. Inspection needs public SQL/YAML only; executing Lab 3 requires Labs 1–2. Use a text viewer and the existing private record; no new workbook is required. **Time:** focused reading/decision time unmeasured; learner estimate pending a independent reader trial.

## Purpose and prediction

Decide where one invariant belongs and what acceptance test would establish its implementation. Before inspecting, record a reasoned prediction: Does a relationships test create a PostgreSQL foreign key? Does a child reference require every order to have a line?

## Inspect and extract evidence

Inspect the raw seed, stg_order_items, and Lab 3 model properties. Trace one order-item reference to an order. Separate primary-key constraints declared in SQL from relationships tests declared for dbt. Attribute supplied execution records unless you run the check yourself. Produce a rule / implementation location / enforcement-or-detection table. Attribute supplied observations; record your source revision and date.

| Claim/question | Source or observation | Scope and limitation |
| --- | --- | --- |
| [Your claim] | [Exact file/section or run; evidence type] | [What remains unknown] |

## Analyze

1. Which constraints actually appear in CREATE TABLE?
2. When does the dbt check detect a violation?
3. Which minimum-cardinality rule remains outside that mechanism?
4. What test would distinguish prevention from detection?

## Evidence limitation

The raw seed has primary keys but does not implement the complete chapter model or all foreign keys. An unperformed invalid insertion is not an observation. State the most useful additional evidence.

## Connect and continue

After §3.7; return to §3.12. Carry the scoped finding into that discussion. Inspection needs no reset; any elected execution follows its canonical prerequisites and recovery route.

## Optional executable book example

For the related authored demonstration, use the [foundations suite](../examples/foundations/README.md) and its isolated launcher. This is optional book support, separate from the course activity above. Small authored schema; not the complete course dbt architecture.
