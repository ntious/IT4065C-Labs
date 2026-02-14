# Data Technologies Administration  
## Labs 1–6: Enterprise Data Governance & Architecture Sequence

Welcome to the lab sequence for **Data Technologies Administration**.

These labs are not isolated technical exercises.  
They are a structured progression through the lifecycle of modern enterprise data systems.

By completing Labs 1–6, you will move from:

> Setting up infrastructure  
> to architecting governed pipelines  
> to enforcing access control  
> to auditing compliance effectiveness  

This sequence mirrors how real organizations build, secure, and monitor data platforms.

---

# 🔷 Lab Architecture Overview

The labs are intentionally cumulative.

Each lab builds on the previous one and represents a distinct governance layer.

```

Lab 1 → Infrastructure
Lab 2 → Data Classification
Lab 3 → Modeling Architecture
Lab 4 → Lifecycle & Lineage
Lab 5 → Access Control Enforcement
Lab 6 → Monitoring & Audit Reasoning

```

Together, they represent a complete governance lifecycle:

```

Design → Classify → Model → Execute → Protect → Monitor → Evaluate

```

---

# 🧱 Lab 1: Building Your Personal Data Platform

**Focus:** Infrastructure & Environment Governance

In Lab 1, you construct your personal enterprise data environment:

- Ubuntu VM (compute layer)
- PostgreSQL (database engine)
- Schema isolation (ownership boundary)
- dbt configuration (lifecycle tooling)
- Connection verification (system integrity)

This lab establishes:

- Data ownership boundaries  
- Controlled namespaces  
- Lifecycle-aware tooling  
- Professional environment discipline  

Without Lab 1, all later modeling and governance work would remain theoretical.

---

# 🗂 Lab 2: Raw Data Exploration & Data Classification

**Focus:** Governance Reasoning & Stewardship Thinking

In Lab 2, you evaluate raw data and document:

- Sensitivity level (Public / Internal / Sensitive / Restricted)
- Ownership considerations
- Risk exposure
- Accountability implications

You create a governance register.

This lab develops:

- Data awareness  
- Risk evaluation skills  
- Classification reasoning  
- Documentation discipline  

Classification informs every architectural and security decision that follows.

---

# 🏗 Lab 3: Structured Modeling (Staging → Core → Marts)

**Focus:** Layered Enterprise Architecture

In Lab 3, you build a professional layered data platform:

```

raw → staging → core → marts

```

Each layer serves a governance purpose:

- **Raw** = preserved intake  
- **Staging** = standardization  
- **Core** = business integrity  
- **Marts** = analytics-ready output  

You also implement:

- dbt tests  
- Model dependencies  
- Structured transformation logic  

This lab introduces production-grade architecture thinking.

---

# 🔄 Lab 4: Lifecycle Execution & Lineage Analysis

**Focus:** Understanding System Flow

In Lab 4, you do not build new models.

You:

- Execute the full pipeline  
- Generate dbt documentation  
- Explore the lineage graph (DAG)  
- Trace dependencies across layers  

You must demonstrate one full lifecycle chain:

```

raw.* → stg_* → fct_/dim_* → olap_/oltp_*

```

This lab develops:

- Architectural awareness  
- Dependency reasoning  
- Governance traceability  
- Layer separation understanding  

If you cannot explain the lineage, you do not fully understand the system.

---

# 🔐 Lab 5: Enforcing Data Access Policies

**Focus:** Role-Based Access Control & Data Masking

In Lab 5, you assume the role of Security Administrator.

You implement:

- Role-Based Access Control (RBAC)  
- Schema-level isolation  
- Masked views for PII  
- Least-privilege enforcement  
- PASS/FAIL verification  

You create three roles:

- `role_analyst`
- `role_steward`
- `role_admin`

This lab enforces:

- Defense-in-depth  
- Explicit privilege grants  
- Access boundary integrity  
- Auditable privilege matrices (`\dp`)  

Security is validated by denial behavior.

If everything succeeds, governance has failed.

---

# 📊 Lab 6: Monitoring Evidence & Compliance Reasoning

**Focus:** Audit & Compliance Evaluation

In the final lab, you move from building systems to auditing them.

You:

- Generate a 32-hour audit window  
- Review structured access logs  
- Identify behavioral patterns  
- Separate routine activity from suspicious behavior  
- Write a professional audit memo  

You evaluate:

- Least privilege enforcement  
- Attempted violations  
- Role-switching behavior  
- After-hours activity  
- Accountability via IP and application metadata  

You must determine whether events represent:

- **Control Failure** (the system broke), or  
- **Attempted Violation** (the system worked as intended)

This lab completes the governance cycle.

---

# 🧠 What This Lab Sequence Teaches

By the end of Labs 1–6, you will understand:

### Infrastructure Governance  
Environment design defines ownership.

### Data Stewardship  
Classification drives protection decisions.

### Architectural Design  
Layered modeling protects system integrity.

### Lifecycle Awareness  
Lineage ensures traceability.

### Security Enforcement  
Least privilege protects data exposure.

### Monitoring & Compliance  
Logs must be interpreted — not just stored.

---

# 📁 Directory Structure

```

labs/
│
├── module_2/
│   ├── lab1/
│   ├── lab2/
│   └── lab3/
│
├── module_3/
│   └── lab4/
│
├── module_5/
│   └── lab5/
│
├── module_6/
│   └── lab6/
│
└── README.md

```

Each lab directory contains:

- Shell scripts  
- SQL files  
- Execution helpers  
- Verification logic  

Do not rename files unless explicitly instructed.

---

# ⚠️ Expectations

- Follow instructions exactly.  
- Do not modify provided script names.  
- Use the credentials configured in Lab 1.  
- Read error messages carefully.  
- Reflect before writing final responses.  
- Maintain professional documentation standards.  

These labs simulate enterprise environments.

Precision matters.

---

# 🎓 Professional Takeaway

These labs are not about memorizing commands.

They are about developing professional habits:

- Architectural thinking  
- Governance reasoning  
- Security discipline  
- Audit interpretation  
- Accountability awareness  

Anyone can build tables.

Professionals design, protect, and evaluate systems.

---

# 🏁 Final Perspective

If you complete Labs 1–6 thoughtfully, you will understand:

```

How data enters a system.
How it is structured.
How it is protected.
How access is enforced.
How activity is monitored.
How compliance is evaluated.

```

## Educational Design Philosophy

These labs are intentionally structured to develop competencies in:

- Data governance and classification  
- Lifecycle-aware architecture  
- Access control enforcement  
- Monitoring and compliance evaluation  
- Enterprise data administration practices  

The sequence aligns with course-level learning objectives and industry-relevant competencies in modern data platform administration.

That is enterprise data administration.

Welcome to the full lifecycle.
```
