# Module 5 – Lab 5: Enforcing Data Access Policies  
**Primary Course SLO:** Implement data access security and monitoring  

---

# What Lab 5 Is Really Doing

Lab 5 is not a scripting lab.

It is a **security architecture lab**.

In previous labs, you built data structures, pipelines, and analytical views.

In Lab 5, you become the **Security Administrator**.

You are no longer designing data.

You are controlling who is allowed to touch it.

This lab marks the transition from:

> “How is data structured?”

to

> “Who is allowed to see what — and why?”

That is the difference between engineering and governance enforcement.

---

# The Core Security Shift

Up to this point:

- Data exists  
- Pipelines run  
- Models are trusted  

But none of that matters if:

- Anyone can read raw PII  
- Analysts can bypass masking  
- Roles are undefined  
- Access boundaries do not exist  

Lab 5 introduces **active enforcement**.

You are implementing:

- Role-Based Access Control (RBAC)  
- Data masking via controlled views  
- Schema-level isolation  
- Least-privilege enforcement  
- Auditable privilege verification  

As shown in the lab instructions :contentReference[oaicite:1]{index=1}, your script:

- Creates roles  
- Builds masked views  
- Applies GRANT / REVOKE rules  
- Tests PASS / FAIL scenarios  

This is not theoretical security.

It is enforced security.

---

# What Lab 5 Is Actually Teaching

## 1. Security Is Layered (Defense in Depth)

Notice something subtle in the lab:

The analyst does not just fail at the table level.

They receive:

```

ERROR: permission denied for schema raw

```

This means:

- They cannot access the schema
- They cannot list objects
- They cannot even “see” into raw

This is **schema-level security**, not just table-level security.

Defense in depth means:

- Schema restriction
- View-level abstraction
- Role isolation
- Explicit privilege grants

Security is strongest when boundaries exist at multiple layers.

---

## 2. Roles Represent Responsibilities

You create three roles:

- `role_analyst`
- `role_steward`
- `role_admin`

These are not just login accounts.

They represent:

- Business responsibility
- Data trust levels
- Operational authority

Each role is intentionally constrained:

### Analyst
- Can query analytics views
- Cannot access raw tables
- Cannot access PII

Analysts consume insights, not raw intake.

### Steward
- Can see masked customer data
- Cannot access raw PII tables

Stewards manage governance — not unrestricted access.

### Admin
- Has full privileges (`arwdDxt`)
- Can create, modify, delete, alter

Admins must exist — but must be carefully controlled.

This lab teaches role design as architecture.

---

## 3. Masking Is Better Than Restricting

Why do we give the Steward a masked view instead of partial raw access?

Because:

- Raw tables contain sensitive fields
- Views expose only approved columns
- Masking transforms PII while preserving usability

A masked view is:

- Safer
- Auditable
- Intentional
- Reusable

Masking preserves analytical value while reducing exposure.

This is real-world privacy engineering.

---

## 4. Least Privilege Is a Design Principle

The script applies:

- GRANT only what is required
- REVOKE everything else

This models the principle of:

> “Default deny, explicit allow.”

In enterprise systems:

- Access is not assumed.
- Access is earned and defined.

Lab 5 makes this visible.

---

## 5. Security Must Be Verified, Not Assumed

The PASS / FAIL section in the script is intentional :contentReference[oaicite:2]{index=2}.

Some queries succeed.
Some queries fail on purpose.

Failure is proof of enforcement.

Security is working when:

- Analysts are blocked from raw
- Stewards cannot escalate privileges
- Admin has full access

If everything succeeds, security failed.

---

# How Lab 5 Connects to Earlier Labs

## Connection to Lab 2 (Classification)

In Lab 2, you asked:

> Which data is sensitive?

In Lab 5, you enforce:

> Who can see that sensitive data?

Classification → Enforcement.

This is governance continuity.

---

## Connection to Lab 3 (Architecture Layers)

Lab 3 built:

- raw
- staging
- core
- marts

Lab 5 controls:

- who can access which layer

Architecture without security is incomplete.

Lab 5 completes the architecture.

---

## Connection to Lab 4 (Lifecycle)

Lab 4 emphasized data lifecycle:

- ingestion
- transformation
- production analytics

Lab 5 adds:

- access lifecycle
- role enforcement
- audit visibility

Data lifecycle + Access lifecycle = full governance model.

---

# What You Should Focus On Mentally

This lab is not about memorizing GRANT syntax.

Focus on:

- Why deny schema access instead of table access?
- Why use views instead of column-level restriction?
- Why log failed attempts?
- Why is admin dangerous if misused?

Ask yourself:

What would happen in a real company if:

- An analyst accessed raw PII?
- Admin credentials leaked?
- 100 failed access attempts went unlogged?

This is professional threat modeling.

---

# Reflection Guidance (How to Think Like a Security Architect)

Strong answers:

- Reference defense in depth
- Mention least privilege
- Explain masking rationale
- Discuss audit logging importance
- Consider misuse scenarios

Weak answers:

- Describe commands
- Restate the prompt
- Focus only on syntax

You are being evaluated on security reasoning.

---

# Why Logging Failed Attempts Matters

Even though PostgreSQL blocks access 100 times in a row:

Those attempts must still be logged because:

- They may indicate probing behavior
- They may indicate credential misuse
- They may signal privilege escalation attempts
- They support forensic investigations

Security is not just prevention.

It is monitoring + accountability.

---

# Why This Lab Matters Professionally

Most data breaches occur because:

- Access was overly broad
- Roles were undefined
- Logs were ignored
- Privileges accumulated over time

Lab 5 simulates:

- Enterprise RBAC policy enforcement
- Privilege auditing
- Controlled exposure of PII
- Security boundary validation

These skills apply directly to:

- Cybersecurity engineering
- Cloud IAM configuration
- Enterprise database administration
- Compliance audits (HIPAA, GDPR, FERPA)
- SOC monitoring workflows

This is not academic SQL.

This is production security architecture.

---

# Final Perspective

Lab 5 is where the course shifts from:

> “I built a working data system.”

to

> “I built a secure data system.”

That distinction defines professional maturity.

Anyone can build tables.

Professionals enforce boundaries.

Take your time.
Observe the PASS / FAIL behavior.
Study the privilege matrix (`\dp`).

Security is invisible when it works —  
but obvious when it fails.

Lab 5 teaches you how to make it work.
```

---
