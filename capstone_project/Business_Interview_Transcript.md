# Business Interview Transcript
## Retail Order & Sales System Modernization

This is a fictional stakeholder interview. It is authoritative for the business
requirements and beliefs expressed in this scenario, not for legal or regulatory
applicability. Treat legal claims as assumptions to investigate using primary
sources and stated jurisdiction, purpose and record categories. Record uncertainty
and recommend review rather than inventing legal authority.

**Stakeholders:**  
- Interviewer (Data Team)  
- Retail Operations Manager  

---

# I. Entity & Data Requirements

**Interviewer:**  
To establish a baseline for the new system, could you walk us through the lifecycle of a customer order?

**Stakeholder:**  
We operate an omnichannel model where customers shop online or in physical stores. Once they finalize their selection, which may include one or many products, they submit an order for processing.

We maintain **Customer Profiles**, including:

- Name  
- Email  
- Optional Phone  

Each order is assigned:

- A unique tracking number  
- A timestamp  
- Total value  
- Payment method  

Orders contain individual **line items**. For each product purchased, we store:

- Product identifier  
- Quantity  
- Price at the moment of sale  

Products in our catalog include:

- Unique Product ID  
- Name  
- Manufacturer’s Suggested Retail Price (MSRP)  
- Category (e.g., Electronics)

---

### Architect’s note: structural hint

The stakeholder emphasizes “one or many products.”

Students should consider how a **Line Item** entity acts as the structural bridge between:

- A static **Product**
- A specific **Order**

This relationship is foundational for resolving many-to-many relationships.

---

# II. Business Rules & Logic

**Interviewer:**  
Are there any constraints or rules that affect how this data behaves?

**Stakeholder:**  

Yes.

- Pricing is dynamic.
- We must **freeze the price at the time of purchase** within the order record.
- Once an order reaches a **“Completed”** status, it must become **immutable** (unchangeable) to prevent data drift.
- The system must support the addition of new product categories without breaking existing structures.

---

# III. Analytical Goals (KPIs & Reporting)

**Interviewer:**  
How is this data used for analysis and decision-making?

**Stakeholder:**  

Our primary focus is time-based analysis:

- Daily  
- Monthly  
- Quarterly  

We need visibility into:

- Revenue by Category  
- “Hero” products (top performers)  
- Customer Retention rates  

---

## Stakeholder Retention Policy Assertions

**Current policy as described by the stakeholder; legal basis not verified**

- We currently retain Order and Transaction data for **7 years** and attribute
  that period to tax requirements. The architecture team must verify the
  applicable jurisdiction, record categories and authority before describing
  this period as a legal obligation.
- Temporary logs of “In-Progress” orders may be purged after **90 days**.
- Monthly sales aggregates are **never deleted**.
- After 2 years, aggregates move to **Cold Storage**.

Record these as stakeholder policy assertions, including the indefinite aggregate
retention request. Review purpose, necessity, applicable obligations, approved
holds and exceptions before recommending a final schedule. Cold storage is a
storage choice; it does not itself determine how long records should be kept.

---

# IV. Data Governance & Ownership

**Interviewer:**  
Who is responsible for maintaining and governing this data?

**Stakeholder:**  

- **Sales Operations** owns order data.
- **Product Management** owns the product catalog.
- **Customer Data Team** manages customer profiles.
- **IT** provides infrastructure.

We require full **auditability**:

- Who changed what?
- When was it changed?

---

# Stakeholder Impact Estimates (Governance Input)

### Estimated confidentiality impact: High
**Customer Profiles (Email / Phone)**  
The stakeholder expects exposure could cause privacy harm and regulatory
consequences. Determine which frameworks, if any, apply before concluding that
a violation or fine follows.

### Estimated confidentiality impact: Medium
**Order History & Financial Totals**  
A leak exposes revenue trends and competitive intelligence.

### Estimated confidentiality impact: Low
**Product Catalog & Category Lists**  
The stakeholder describes the published catalog as public-facing with lower
confidentiality impact. Review unpublished pricing, contractual and intellectual-
property context before treating disclosure as risk-free.

---

# Purpose of This Document

Use this transcript as the source of fictional stakeholder requirements for:

- Phase 1 – Requirements Extraction  
- Phase 2 – Logical Data Model  
- Phase 3 – Workload Strategy  
- Phase 4 – Governance Overlay  
- Phase 5 – Evidence Validation  
- Phase 6 – Executive Defense  

Trace decisions to stakeholder requirements and identify assumptions, supporting
sources and justified revisions. The impact estimates above are not handling
classifications or determinations of legal applicability. In Phase 4, use the
course handling labels Public / Internal / Sensitive / Restricted and record
impact separately. You may challenge a stakeholder policy with evidence and
document the proposed revision; the interview does not override legal authority.

---

Author: [Isaac K. Nti](../AUTHORS.md). [Citation and reuse terms](../CITATION.md).
