# Phase 3 – Workload Strategy  
## Designing the Boundary Between OLTP and OLAP

---

## Overview

In Phase 2, you designed a Logical Data Model that enforces business structure.

In Phase 3, you decide how that structure behaves under real workloads.

Professional data architects do not allow operational and analytical workloads to collide.

If they do:

- Performance degrades  
- Concurrency conflicts increase  
- Reporting becomes fragile  
- Revenue-impacting slowdowns occur  

This phase transforms your model from a database into a platform.

---

## The Architectural Mindset: Promote Structure Into Strategy

You are no longer just modeling entities.

You are deciding:

- Where operational pressure belongs  
- Where analytical pressure belongs  
- How to prevent workload collisions  
- How to protect business continuity  

If analytics run directly on production tables, you risk:

- Slowing down live transactions  
- Lock contention during reporting spikes  
- Query plans breaking after schema changes  
- Inconsistent executive reporting  

Scalable systems require workload boundaries.

Your responsibility is to design that boundary.

---

## Core Architectural Principle

Separate:

**OLTP (Online Transaction Processing)**  
Fast writes. High concurrency. Strict integrity. Day-to-day operations.

From:

**OLAP (Online Analytical Processing)**  
Fast reads. Aggregations. Historical analysis. Executive reporting.

Production tables are optimized for transactions.

Analytical tables are optimized for insight.

They should not be the same physical design.

---

## Your Task

Complete the **Phase_3_OLTP_vs_OLAP** section of your portfolio workbook.

You must define how each entity behaves under operational and analytical workloads.

---

## Part A – Entity Workload Classification

For each entity from Phase 2, determine:

- Is it used in OLTP?
- Is it used in OLAP?
- If used in OLAP, is it:
  - Fact  
  - Dimension  
  - Not Used  

You must justify every classification decision.

If an entity exists in both OLTP and OLAP, explain:

- What transformation occurs
- Whether a snapshot is created
- Whether a curated or denormalized version exists
- Whether aggregation changes grain

Architecture requires explicit transformation logic.

---

## Part B – Facts vs Dimensions

Your OLAP layer must include:

- At least **one Fact table**
- At least **four Dimension tables**

### Facts

Facts represent measurable business events.

Examples in a retail system:

- Order transactions
- Payment events
- Returns
- Shipments

A strong architectural test:

> One row in my Fact table represents ______.

If you cannot clearly define grain, your analytical model is unstable.

Grain defines everything.

---

### Dimensions

Dimensions provide reporting context.

Examples:

- Customer
- Product
- Store
- Date
- Promotion

Dimensions must:

- Be descriptive
- Be stable
- Support slicing and filtering
- Remain independent from transactional volatility

If executives must query production tables to generate reports, your OLAP layer is incomplete.

---

## Part C – Workload Defense Memo

Write a concise (100–150 words) architectural memo explaining:

Why is a Star Schema superior to reporting directly from production tables for this system?

Your memo must include at least two technical arguments such as:

- Reduced join complexity
- Read/write workload separation
- Indexing advantages
- Concurrency isolation
- Resilience to OLTP schema evolution
- Predictable query performance

Avoid vague statements.

This is an architectural defense, not an opinion.

---

## Evaluation Criteria

Your Phase 3 work should demonstrate:

### Classification Accuracy
Do OLTP vs OLAP decisions reflect realistic system behavior?

### Fact/Dimension Correctness
Are measurable events properly separated from descriptive context?

### Architectural Coherence
Can the analytical layer operate independently from production tables?

### Technical Precision
Does the defense memo include clear, technically grounded arguments?

Strong architecture prevents collisions before they happen.

---

## Why This Phase Matters

Many organizations fail at scale because:

- Reporting runs on production systems
- Analytical queries block transactional writes
- Schema changes break executive dashboards
- Performance tuning becomes reactive

Separating OLTP from OLAP:

- Improves scalability
- Protects revenue operations
- Stabilizes reporting
- Enables performance tuning
- Supports data warehouse evolution

This phase trains you to design for scale — not just correctness.

---

## Final Perspective

Phase 2 asked:

> Is the structure valid?

Phase 3 asks:

> Can the structure survive real-world pressure?

Architectural maturity means anticipating workload stress.

A well-designed system does not just work.

It scales.
```
