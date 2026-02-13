# Business Interview Transcript  
## Retail Order & Sales System Modernization  

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

### 📌 Architect’s Sidebar (Structural Hint)

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

## 📂 Internal Compliance Requirements

**Retention Policy**

- All Order and Transaction data must be retained for **7 years** (tax law compliance).
- Temporary logs of “In-Progress” orders may be purged after **90 days**.
- Monthly sales aggregates are **never deleted**.
- After 2 years, aggregates move to **Cold Storage**.

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

# 🛡 Risk & Sensitivity Memo (Governance Input)

### Classification – HIGH (Red)
**Customer Profiles (Email / Phone)**  
A leak results in GDPR/privacy violations and legal fines.

### Classification – MEDIUM (Yellow)
**Order History & Financial Totals**  
A leak exposes revenue trends and competitive intelligence.

### Classification – LOW (Green)
**Product Catalog & Category Lists**  
Public-facing information. No legal risk if exposed.

---

# Purpose of This Document

This transcript serves as the authoritative source for:

- Phase 1 – Requirements Extraction  
- Phase 2 – Logical Data Model  
- Phase 3 – Workload Strategy  
- Phase 4 – Governance Overlay  
- Phase 5 – Evidence Validation  
- Phase 6 – Executive Defense  

All architectural and governance decisions must be traceable to this interview.