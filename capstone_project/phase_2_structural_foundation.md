# Phase 2: Structural Foundation

## AI lifecycle checkpoint

Identify which proposed attributes serve operational use, evaluation or auditing.
Explain proxy risks and whether each attribute is necessary. Document proposed
access separation for sensitive audit attributes; a diagram does not enforce it.
Trace modeling changes to Phase 1 and record unresolved data-quality assumptions.

## Logical Data Model (LDM)

---

## Overview

In Phase 1, you identified the “ingredients” of the system:

- Entities (nouns)
- Relationships (verbs)
- Attributes
- Uncertainty points

In Phase 2, you write the recipe.

You are moving from discovery notes to a **Logical Data Model (LDM)**.

This phase requires you to specify structural requirements for:

- Data integrity
- Referential consistency
- Historical accuracy
- Proposed governance controls
- Business rule alignment

Discovery identified possibilities.

The logical model records intended rules. Database constraints must be implemented
and tested before you claim that a database enforces them. A dbt relationship
test checks data when run; it does not create a foreign-key constraint.

---

## The Architectural Mindset: Promoting Discovery

You are not re-listing entities.

You are hardening them into architecture.

Return to your Phase 1 portfolio and apply two principles:

### 1. Refine
Review each entity marked as “Low Confidence” and either:

- Confirmed and justified, or  
- Removed and explained, or
- Retained provisionally with an explicit assumption and follow-up question

If evidence is insufficient, mark the entity as provisional and record the
assumption and follow-up needed; do not invent confirmation.

---

### 2. Formalize
Convert business nouns into formalized table structures:

- Assign clear table names  
- Define Primary Keys  
- Establish referential relationships  
- Clarify ownership boundaries  

Discovery was exploratory.

Phase 2 is decisive.

---

## Your Task

Complete the **Phase_2_LDM** sheet in your portfolio template.

You must satisfy the following architectural requirements.

---

## 1. Define Primary Keys (PK)

Every entity must have a unique identifier.

Ask:

- What guarantees uniqueness?
- What remains stable over time?
- What prevents accidental duplication?

Example:

Should a Customer’s primary key be:
- Email?  
- Or a system-generated Customer_ID?

Explain your choice.

Primary keys define identity.

A proposed primary key identifies the intended uniqueness rule. Its implementation
and verification determine whether duplicate or missing identifiers are rejected.

---

## 2. Resolve Many-to-Many Relationships

For the relational design in this project, resolve each many-to-many relationship
through an associative/junction entity. A conceptual model may show an M:N
relationship directly before this refinement.

Example:

An Order can contain many Products.  
A Product can appear in many Orders.

Represent this relationship with a **junction entity**, proposed for implementation
as a table.

Example solution:

```

Order_Line_Item

```

This table:

- Bridges Orders and Products
- Stores transaction-level attributes (e.g., Price at Sale, Quantity)

You must:

- Identify all M:N relationships
- Create appropriate junction entities
- Document your logic in the “Junction Table Logic” column

Explain how the chosen grain and keys address duplicate or inconsistent records.

---

## 3. Specify Referential-Integrity Requirements

For each logical foreign-key relationship, annotate the existing ERD or rationale
with the child field, parent key, cardinality, intended delete/update behavior,
proposed enforcement and proposed verification. These notes belong in your
**Phase_2_LDM** section; no additional submission or database implementation is
required in this phase.

For example, in a different library scenario, `Loan.borrower_id` references
`Borrower.borrower_id`. One borrower may have many loans. The design proposes a
foreign key and rejection of borrower deletion while dependent loans remain.
A future verification would attempt an orphaned loan and a prohibited deletion,
and confirm that the database rejects both. Until implemented and checked,
label this control **proposed**, not demonstrated.

Ask what should happen when a referenced product is deleted or its identifier
changes. Justify the behavior against the business requirement; do not assume
that deleting history is appropriate. Tests of existing records and database
constraints preventing invalid writes provide different evidence.

---

## 4. The Architect’s Defense (Critical Component)

This is the most important part of Phase 2.

For every entity, you must justify its existence.

Prompt:

> If this entity were modeled incorrectly or removed, what specific business rule, report, or integrity guarantee would break?

Example:

Without a place to preserve the price at sale for each order item:

- A report that uses current product prices could rewrite historical revenue.
- The design needs another justified mechanism to preserve transaction history.
- An order-line entity is the proposed mechanism in this relational design.

This section demonstrates:

- Business awareness
- Governance thinking
- Structural maturity

You are not defending tables.

You are defending business continuity.

---

## Deliverable

Submit the updated portfolio template including:

- Completed Phase_2_LDM sheet
- Updated Phase_1_Requirements (if refined)
- Defined primary keys
- Resolved M:N relationships
- Completed Architect’s Defense column

Demonstrate architectural coherence in your submission.

---

## Evaluation Criteria

Phase 2 will be assessed on:

### Structural Integrity
Are primary keys clearly defined and defensible?

### Relationship Accuracy
Are Many-to-Many relationships properly resolved?

### Referential Discipline
Are logical relationships, delete/update behavior, proposed enforcement and
verification clearly distinguished?

### Architectural Justification
Does each entity have a clear business defense?

### Continuity
Does Phase 2 logically evolve from Phase 1?

Strong work demonstrates deliberate structural reasoning.

Weak work lists tables without defending them.

---

## Why This Phase Matters

Many system failures originate in poor structural modeling.

Common consequences of weak design:

- Duplicate customers
- Inconsistent pricing history
- Broken revenue reports
- Governance blind spots
- Compliance risk exposure

A Logical Data Model specifies requirements that support:

- Data accuracy
- Business reporting
- Audit defensibility
- Lifecycle stability

This phase trains you to think like a systems architect, not a query writer.

---

## Final Perspective

Discovery asked:

> What exists?

Phase 2 asks:

> Which integrity rules does the structure represent, and how will you enforce and test them?

Strong architecture is invisible when working correctly.

Weak architecture reveals itself in crisis.

You are building structural durability.

---

Author: [Isaac K. Nti](../AUTHORS.md). [Citation and reuse terms](../CITATION.md).
