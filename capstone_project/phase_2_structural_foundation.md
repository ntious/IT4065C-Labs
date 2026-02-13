# Phase 2 – Structural Foundation  
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

This phase requires you to make structural decisions that ensure:

- Data integrity
- Referential consistency
- Historical accuracy
- Governance enforceability
- Business rule alignment

Discovery identified possibilities.

Structure enforces reality.

---

## The Architectural Mindset: Promoting Discovery

You are not re-listing entities.

You are hardening them into architecture.

Return to your Phase 1 workbook and apply two principles:

### 1. Refine
Any entity marked as “Low Confidence” must now be:

- Confirmed and justified, or  
- Removed and explained  

Ambiguity cannot remain in structural design.

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

Complete the **Phase_2_LDM** sheet in your Master Portfolio Workbook (V2).

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

Identity defines integrity.

---

## 2. Resolve Many-to-Many Relationships

You cannot directly link two entities in a Many-to-Many relationship.

Example:

An Order can contain many Products.  
A Product can appear in many Orders.

This requires a **junction table**.

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

Structural shortcuts lead to data corruption.

---

## 3. Enforce Referential Integrity

Every foreign key must:

- Reference a valid parent entity
- Support business rules
- Protect against orphaned records

Ask:

- What happens if a Product is deleted?
- Should Orders remain?
- Should deletion be restricted?

Structural decisions have business consequences.

---

## 4. The Architect’s Defense (Critical Component)

This is the most important part of Phase 2.

For every entity, you must justify its existence.

Prompt:

> If this entity were modeled incorrectly or removed, what specific business rule, report, or integrity guarantee would break?

Example:

Without an `Order_Line_Item` table:

- The system cannot freeze “Price at Sale”
- Historical revenue would change whenever product pricing updates
- Financial reporting becomes unreliable

This section demonstrates:

- Business awareness
- Governance thinking
- Structural maturity

You are not defending tables.

You are defending business continuity.

---

## Deliverable

Submit the updated Master Portfolio Workbook including:

- Completed Phase_2_LDM sheet
- Updated Phase_1_Requirements (if refined)
- Defined primary keys
- Resolved M:N relationships
- Completed Architect’s Defense column

Your submission should demonstrate architectural coherence.

---

## Evaluation Criteria

Phase 2 will be assessed on:

### Structural Integrity
Are primary keys clearly defined and defensible?

### Relationship Accuracy
Are Many-to-Many relationships properly resolved?

### Referential Discipline
Are foreign key dependencies logical and complete?

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

A Logical Data Model protects:

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

> How must it be structured so it cannot break?

Strong architecture is invisible when working correctly.

Weak architecture reveals itself in crisis.

You are building structural durability.
```


