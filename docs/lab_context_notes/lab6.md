# Lab 6: Monitoring Evidence and Compliance Reasoning

**Estimated Time:** 30–45 minutes  
**Environment:** PostgreSQL + Terminal  
**Focus:** Monitoring, audit reasoning, compliance evaluation  

---

# What Lab 6 Is Really About

Lab 6 is not a build lab.

It is not a modeling lab.

It is not a security configuration lab.

It is an **audit lab**.

In this final lab, you move from building systems to auditing them :contentReference[oaicite:1]{index=1}.

You are no longer:

- Designing models  
- Creating views  
- Assigning roles  

You are reviewing a **32-hour window of access logs** and determining:

- What is normal?
- What is suspicious?
- What requires action?

This lab marks the transition from:

> “I can build secure systems.”

to

> “I can evaluate whether they are working.”

That is professional maturity.

---

# Your Role in This Lab

You are a **Data Administrator** preparing a memo for a Governance Committee :contentReference[oaicite:2]{index=2}.

Your responsibility:

- Separate routine activity from suspicious behavior  
- Evaluate compliance posture  
- Determine whether controls are functioning  
- Recommend next steps  

You are not debugging.

You are investigating.

---

# What You Are Actually Learning

Lab 6 teaches five advanced professional skills:

---

## 1. Monitoring as a Governance Layer

Security does not end with RBAC.

Security requires:

- Monitoring
- Evidence collection
- Pattern recognition
- Documentation

You will run:

```bash
bash labs/module_6/lab6/run_lab6_audit_report.sh
````

(as described in Step 1 )

This generates structured audit evidence (Sections 0–8).

Monitoring converts logs into decision material.

---

## 2. Differentiating Normal vs Suspicious Behavior

You are told to look for three event categories :

1. **The Normal**

   * Routine SELECT queries
   * Business hours activity

2. **The Aggressive**

   * Repeated denials
   * Attempted role switching

3. **The Out-of-Bounds**

   * Unusual time access
   * Unexpected data exports

A great auditor does not just count errors.

They identify behavioral patterns.

---

## 3. Evaluating Least Privilege in Practice

When reviewing `analyst_02`, ask:

* Is the system stopping improper access?
* Or does the user have excessive privilege?

If access attempts are denied repeatedly:

That may indicate:

* Credential misuse
* Privilege probing
* Escalation attempts

But it may also show:

* The control is working

You must determine:

**Control failure or attempted violation?**

That distinction matters.

---

## 4. Contextual Risk Evaluation

Consider `steward_01` exporting masked data at 4:32 AM .

Is this:

* Malicious?
* Acceptable business usage?
* Policy violation?
* Emergency access?

You must explain:

What additional information would you need?

Real auditing requires contextual interpretation — not rigid assumptions.

---

## 5. Accountability Through Technical Evidence

You are asked to analyze:

* `client_ip`
* `app_name`

These fields provide:

* Device origin
* Application context
* Traceability

Usernames alone are weak identifiers.

IP + application + timestamps create accountability.

This is forensic awareness.

---

# Proper Use of Generative AI (If Used)

The lab permits use of GenAI tools as a “Security Consultant” .

However:

* You must verify all claims against your actual terminal output.
* You must write your final memo in your own words.
* AI does not know your organization’s internal governance rules.
* Human judgment is required.

AI can assist thinking.

It cannot replace accountability.

---

# What You Should Be Thinking About

While reviewing the audit output (Sections 0–8), ask:

* Are denials clustered around specific roles?
* Is there a pattern in timing?
* Are role switches correlated with failures?
* Does any event indicate actual data exposure?
* Are controls preventing or allowing violations?

Do not just list incidents.

Explain intent.

---

# Governance Reasoning Questions (Step 3)

You must address:

## 1. Principle of Least Privilege

Does `analyst_02` have too much access?
Or is the system successfully stopping improper behavior?

Support your conclusion using evidence from Section 7.

---

## 2. The Steward Dilemma

Should `steward_01`’s 4:32 AM export be flagged?

What additional data would you need?

Examples:

* Approved maintenance window?
* Incident response event?
* Supervisor authorization?

---

## 3. Accountability

How do `client_ip` and `app_name` strengthen enforcement?

Explain how they support:

* Traceability
* Investigations
* Non-repudiation

---

# The Audit Memo (Step 4)

Your final submission must be a professional memo.

It should include :

## Observed Activity

* Total events
* Total denials
* General behavior summary

## High-Risk Findings

* Address `analyst_02`
* Address `steward_01`

## Compliance Impact

Determine:

* Control Failure (system broke)
* Attempted Violation (system worked)

Be precise.

---

## Recommended Action

Suggest one follow-up action.

Examples:

* Reset password
* Review access policies
* Interview steward
* Conduct awareness training
* Enable enhanced monitoring

Your recommendation must match your analysis.

---

# What Strong Submissions Demonstrate

Strong submissions:

* Identify behavioral patterns
* Distinguish violation vs attempt
* Use evidence from Section 7
* Provide proportional recommendations
* Write in professional memo format

Weak submissions:

* List log entries without interpretation
* Assume malicious intent without evidence
* Copy terminal output verbatim
* Provide vague recommendations

---

# How This Lab Connects to the Entire Course

Lab 1 → Built infrastructure
Lab 2 → Classified data risk
Lab 3 → Built lifecycle architecture
Lab 4 → Interpreted lineage
Lab 5 → Enforced access controls
Lab 6 → Audited control effectiveness

This completes the governance cycle:

```
Design → Build → Protect → Monitor → Evaluate
```

You are now thinking like a full data administrator.

---


# Final Perspective

Lab 6 is where the course shifts from:

> “Can I configure governance controls?”

to

> “Can I evaluate whether governance is working?”

That difference defines senior-level thinking.

Anyone can read logs.

Professionals interpret patterns.

Anyone can enforce rules.

Professionals assess compliance impact.

A great auditor does not just find errors.

They find intent.

This is your final professional exercise.

```