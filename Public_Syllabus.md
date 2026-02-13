# IT4065C: Data Technologies Administration  
## Public Course Framework Overview

---

## Course Description

This course examines modern enterprise practices in data governance, lifecycle management, infrastructure administration, security enforcement, compliance monitoring, and analytics architecture.

Rather than treating data as a purely technical artifact, the course approaches data as a managed enterprise asset requiring accountability, traceability, and protection. Students engage in hands-on, lifecycle-oriented learning that integrates modeling, governance, infrastructure decisions, and security implementation into a unified architectural framework.

The course is structured to mirror how professional data administrators and data architects design, operate, and secure organizational data platforms.

---

## Course Learning Outcomes (SLOs)

Upon completion of this course, students will be able to:

**SLO 1:** Identify the types of data and data sources that fall under data governance.  
**SLO 2:** Diagram the most common lifecycle of data, from raw ingestion to production and archival.  
**SLO 3:** Discuss multi-cluster infrastructure implementations (cloud, on-premises, hybrid) and their administrative implications.  
**SLO 4:** Apply data lifecycle and modeling tools to design structured, governance-ready systems.  
**SLO 5:** Implement data access security and monitoring mechanisms aligned with governance policies.

---

## Pedagogical Design Philosophy

The course follows a governance-first progression:

```

Governance → Schema → Flow → Infrastructure → Security → Monitoring → Integration

```

This progression reduces procedural ambiguity while preserving intellectual rigor. Students move from classification and modeling to lifecycle orchestration, workload separation, access control, monitoring, and executive-level defense of architectural decisions.

The emphasis is on architectural reasoning rather than isolated tool execution.

---

## Module Structure

### Module 1: Foundations of Data Governance & Classification
Students classify data assets across structural, sensitivity, regulatory, and ownership dimensions. Emphasis is placed on how classification decisions influence lifecycle, access control, and compliance enforcement.

Supports: SLO 1, SLO 5

---

### Module 2: Data Modeling for Operational & Analytical Systems
Students develop logical data models and entity-relationship diagrams that support governance, lifecycle integrity, and analytics readiness.

Supports: SLO 2, SLO 4

---

### Module 3: Data Lifecycle Design & Management
Students design controlled transformation workflows from raw ingestion to production-ready assets. Lifecycle traceability and observability are emphasized.

Supports: SLO 2, SLO 4

---

### Module 4: Infrastructure Models for Data Administration
Students analyze cloud, on-premises, and hybrid infrastructure models and evaluate how deployment decisions impact governance enforcement and lifecycle execution.

Supports: SLO 3

---

### Module 5: Data Access Control & Security Implementation
Students implement role-based access control (RBAC), least-privilege policies, encryption, and masking strategies to enforce governance classifications.

Supports: SLO 5

---

### Module 6: Data Access Monitoring & Compliance Enforcement
Students analyze audit logs, detect anomalous behavior, and evaluate compliance readiness through monitoring mechanisms.

Supports: SLO 2, SLO 5

---

### Module 7: Integrated Data Governance Operations
Students examine governance as a continuous operational workflow, integrating classification, lifecycle management, infrastructure administration, access enforcement, and monitoring.

Supports: SLO 1, SLO 2, SLO 3, SLO 5

---

### Module 8: Capstone Project & Course Synthesis
Students synthesize all course concepts in a semester-long architecture simulation.

Supports: All SLOs

---

## Semester-Long Capstone  
### Simulated Governed Enterprise Data Architecture

The capstone project places students in the role of professional data architects designing a governed retail data system under real-world technical and compliance constraints.

Students progress through structured phases:

1. Requirements extraction from stakeholder interviews  
2. Logical data model design  
3. Workload strategy (OLTP vs. OLAP separation)  
4. Governance overlay (ownership, sensitivity, retention, risk)  
5. Technical enforcement validation through lab artifacts  
6. Executive-level architecture defense  
7. Individual professional reflection  

The project emphasizes:

- Governance integration  
- Lifecycle traceability  
- Security enforcement  
- Compliance validation  
- Risk reasoning  
- Executive communication  

This capstone moves beyond database construction toward enterprise system design and accountability.

---

# SLO-to-Lab Alignment Matrix

The table below maps Course Learning Outcomes (SLOs) to the structured lab sequence.

This alignment demonstrates how technical implementation supports governance-centered competencies.

| Course Learning Outcome | Lab 1 | Lab 2 | Lab 3 | Lab 4 | Lab 5 | Lab 6 |
|--------------------------|:-----:|:-----:|:-----:|:-----:|:-----:|:-----:|
| **SLO 1** – Identify types of data and data sources under governance |  | ✔ | ✔ | ✔ | ✔ | ✔ |
| **SLO 2** – Diagram the data lifecycle from raw to production | ✔ |  | ✔ | ✔ |  | ✔ |
| **SLO 3** – Discuss multi-cluster infrastructure administration | ✔ |  |  | ✔ | ✔ | ✔ |
| **SLO 4** – Use data lifecycle and modeling tools | ✔ |  | ✔ | ✔ |  |  |
| **SLO 5** – Implement data access security and monitoring |  | ✔ | ✔ |  | ✔ | ✔ |

---

## Interpretation of Alignment

### Lab 1 – Infrastructure & Environment Governance
- Establishes lifecycle tooling and controlled schema boundaries (SLO 2, SLO 3, SLO 4)

### Lab 2 – Data Classification & Stewardship
- Develops governance reasoning and risk awareness (SLO 1, SLO 5)

### Lab 3 – Layered Modeling Architecture
- Implements raw → staging → core → marts structure (SLO 1, SLO 2, SLO 4, SLO 5)

### Lab 4 – Lifecycle & Lineage Validation
- Traces dependencies across the pipeline (SLO 2, SLO 3, SLO 4)

### Lab 5 – Access Control Enforcement
- Applies RBAC and least-privilege principles (SLO 1, SLO 3, SLO 5)

### Lab 6 – Monitoring & Compliance Evaluation
- Analyzes logs, detects violations, and evaluates governance enforcement (SLO 1, SLO 2, SLO 3, SLO 5)

---

This matrix illustrates that learning outcomes are reinforced across multiple lifecycle stages rather than assessed in isolation.


---

## Technical Environment

Students work within a structured, hands-on environment using:

- Linux/Ubuntu
- PostgreSQL
- dbt (data build tool)
- Role-Based Access Control (RBAC)
- Audit log monitoring tools

The toolchain supports lifecycle-aware modeling, governance enforcement, and monitoring validation.

---

## Professional Competencies Developed

By completing this course, students gain experience in:

- Enterprise data modeling  
- Lifecycle architecture design  
- Governance strategy integration  
- Workload separation (OLTP vs. OLAP)  
- Security enforcement reasoning  
- Compliance monitoring  
- Risk assessment  
- Executive-level architectural communication  
- Professional reflection and accountability  

The course prepares students to treat data as a managed enterprise asset rather than a collection of technical tables.

---

## Note on Public Version

This public syllabus outlines the academic and architectural framework of the course. Institutional policies, grading mechanics, and university-specific administrative details are maintained within the official course management system and are not included here.
```

---
