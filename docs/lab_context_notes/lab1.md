# Lab 1: Building Your Personal Data Platform

## What Lab 1 Is Really Doing

Lab 1 is not a coding lab.

It is an **environment lab** where you build your own governed data workspace.

By the end of this lab, you have:

- A personal Ubuntu data workstation  
- A local PostgreSQL database  
- A governed schema you own  
- A dbt analytics environment  
- A verified data pipeline connection  

---

## Major Components You Create

### 🔹 Infrastructure Layer  
**Ubuntu VM** = your personal data platform  

This simulates the compute layer organizations provision for data teams.

---

### 🔹 Database Layer  
**PostgreSQL** = governed storage engine  

This is where structured data lives and where access rules are enforced.

---

### 🔹 Governance Layer  
**Schema isolation (`student_kofi`)**  
→ Simulates enterprise ownership boundaries  

Your schema represents:

- data ownership  
- accountability  
- stewardship  
- boundary enforcement  

This is not just a naming convention.  
It models how enterprises prevent cross-team interference.

---

### 🔹 Workflow Layer  
**dbt** = lifecycle orchestration tool  

dbt manages:

- transformation logic  
- model dependencies  
- testing rules  
- deployment structure  

This introduces lifecycle-aware data engineering.

---

### 🔹 Verification Layer  
**dbt debug + SQL validation**  
→ Proves system integrity  

You are confirming:

- database connectivity  
- credential correctness  
- schema isolation  
- pipeline readiness  

Verification is not optional in enterprise systems.  
It is required before trust.

---

## Key Idea

You are not installing tools.

You are constructing a **miniature enterprise data architecture**.

This mirrors how real organizations onboard:

- data engineers  
- analytics engineers  
- data administrators  

Environment design is the first governance decision.

---

# Why Lab 1 Matters for What We’ve Learned

## How Lab 1 Connects to Modules 1 & 2

Lab 1 operationalizes concepts from Modules 1 & 2.

---

## From Module 1: Data Governance

You practiced governance principles by:

- Creating schema ownership boundaries  
- Isolating your data environment  
- Simulating stewardship responsibility  
- Enforcing controlled access spaces  

Your schema = your governed domain.

This models:

- Data ownership  
- Accountability  
- Stewardship  
- Boundary enforcement  

You are acting as a **data administrator**, not just a student.

---

## From Module 2: Data Modeling Foundations

Before modeling data, professionals must have:

- a stable platform  
- a controlled database  
- a defined namespace  
- lifecycle tooling  

Lab 1 creates the infrastructure required for:

- raw → structured → production pipelines  
- modeling with dbt  
- lifecycle-aware transformations  

Without Lab 1, modeling is theoretical.  
With Lab 1, modeling becomes operational.

---

## Big Takeaway

Governance is not paperwork.

Governance starts with **environment design**.

Lab 1 is your first real governance decision:

> Who owns what data space?

That question defines every enterprise data system.
```