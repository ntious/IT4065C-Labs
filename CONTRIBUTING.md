```md
# Contributing Guide (CONTRIBUTING.md)

Thank you for your interest in contributing to **Data Technologies Administration**.

This repository is an open educational framework built to teach **enterprise data governance and architecture** through a progressive lab sequence and a structured capstone simulation. Contributions are welcome—but they should preserve the instructional design goals of the course:

- **Architecture before tools**
- **Governance as an operational discipline**
- **Evidence-based reasoning**
- **Traceability from requirements → design → controls → monitoring**

My long-term vision is for this repository to remain a high-quality, reusable curriculum artifact that is academically credible, professionally aligned, and easy for educators to adopt.

---

## What This Repo Is (and Isn’t)

### This repo is:
- A governance-centered curriculum with labs and a capstone that simulate enterprise data administration practice
- Designed for **diverse student preparation levels**
- Focused on **reasoning, accountability, and defensible design decisions**

### This repo is not:
- A generic SQL tutorial
- A “tool of the week” sandbox
- A production SaaS or a framework optimized for broad software feature velocity

Contributions should *increase clarity, reproducibility, and architectural integrity*—not expand scope without purpose.

---

## Types of Contributions Welcome

### ✅ High-value contributions
- **Clarity improvements**: wording, reorganization, diagrams, and student-friendly explanations
- **Error fixes**: typos, broken paths, inaccurate instructions, inconsistent terminology
- **Reproducibility enhancements**: verification steps, troubleshooting, environment compatibility notes
- **Accessibility improvements**: readability, navigation, and inclusive course framing
- **Assessment alignment** (public-safe): rubric *summaries* or evaluation principles (not grade keys)
- **Security hygiene**: safer defaults, clearer RBAC examples, improved masking guidance
- **Architecture diagrams**: Mermaid diagrams that clarify lifecycle, lineage, and control boundaries
- **Instructor support**: educator notes, adaptation guidance, implementation tips

### ⚠️ Contributions that require discussion first
Please open an Issue before starting work on:
- Major restructuring of labs or capstone phases
- Toolchain swaps (e.g., replacing dbt/PostgreSQL)
- New datasets or significant changes to the case study
- Adding new “modules” that change course scope

### 🚫 Contributions we do not accept
- Uploading **student work** (even anonymized unless explicitly approved and scrubbed)
- Any **credentials**, keys, or private endpoints
- Material that violates copyright or includes proprietary content
- Content that encourages unsafe behavior in real environments (e.g., misuse of security tools)

---

## Repository Standards (What We Optimize For)

### 1) Traceability
- Capstone decisions must remain grounded in stakeholder requirements
- Governance claims should remain evidence-based and defensible

### 2) Minimal extraneous cognitive load
- Keep instructions clear and stepwise
- Prefer consistent file structure and naming
- Add verification gates when possible

### 3) Tool-agnostic principles (with tool-specific implementation)
- The repo uses a specific stack, but the learning objectives should remain portable:
  - governance → lifecycle → enforcement → monitoring → evaluation

### 4) Professional tone
- Write for students, TAs, and educators
- Avoid “gotcha” language; emphasize reasoning and accountability

---

## How to Contribute

### Step 1 — Open an Issue (recommended)
Before a pull request, open an Issue describing:
- What you observed
- Why it matters (student confusion, reproducibility, alignment, etc.)
- Proposed fix and affected files

**Issue labels** we encourage:
- `bug` (broken steps / scripts)
- `clarity` (confusing or ambiguous instructions)
- `reproducibility` (environment-specific fixes)
- `pedagogy` (learning design improvements)
- `docs` (documentation)
- `security` (RBAC/masking/monitoring improvements)

### Step 2 — Make a Focused Pull Request
Keep PRs scoped. Prefer:
- One improvement theme per PR
- Clear commit messages
- Short explanations of why the change improves learning or reliability

### Step 3 — Verification Expectations
If your change touches execution:
- Include the command(s) used to validate
- Include expected outputs or verification checks
- Note the environment you tested (WSL / Linux / Sandbox)

---

## Documentation Style Guide

To keep the curriculum consistent:

- Use short headers and clear sections
- Prefer “purpose → steps → verification → troubleshooting”
- Use consistent terms:
  - **raw → staging → core → marts**
  - **OLTP vs OLAP**
  - **RBAC / least privilege**
  - **monitoring / auditability**
- Use fenced code blocks for commands
- Avoid long paragraphs when a short list is clearer
- If adding diagrams, prefer **Mermaid** for GitHub-native rendering

---

## File/Directory Conventions

Please do not rename or relocate files without discussion, especially inside:

- `labs/`
- `capstone/`
- `dbt/`

The directory structure is part of the learning design and is referenced in instructional materials.

---

## Privacy, Academic Integrity, and Safety

This repository is public. Please follow these rules:

- **Do not include student submissions** or screenshots showing identifying info
- Remove or redact any personal data (names, emails, IDs)
- Do not include real credentials, access tokens, or private infrastructure details
- Keep security demonstrations educational and bounded to the lab environment

If you discover a security-sensitive issue (e.g., accidental credential exposure), please report it responsibly (see below).

---

## Licensing and Attribution

This repository uses a dual-license structure:

- **Code** (SQL, shell scripts, dbt models) is licensed under the **MIT License**
- **Curriculum text and documentation** are licensed under **CC BY 4.0**

By contributing, you agree your contributions may be distributed under the repository’s license terms.

If you adapt content from elsewhere:
- Ensure it is compatible with these licenses
- Provide clear attribution in the PR description and/or file header comments

---

## How Decisions Are Made

As the maintainer and course author, I prioritize changes that:
- improve student success and clarity
- strengthen governance traceability
- increase reproducibility across environments
- preserve course coherence and learning outcomes

Not every suggestion will be merged, but all well-scoped, well-justified contributions are welcome and will be reviewed in good faith.

---

## Reporting Sensitive Issues

If you find:
- exposed credentials
- a path that could unintentionally damage systems outside the lab
- instructions that create unsafe behavior

Please do **not** open a public issue with the full details.

Instead, open an Issue with a minimal description such as:
> “Potential security-sensitive issue found. Please advise preferred disclosure method.”

(If you provide a contact email elsewhere in the repo, you may also use that.)

---

## Thank You

Contributions help this repository remain a high-quality, reusable framework for teaching **enterprise data governance and architecture**.

If you are an educator adapting this course, I’d love to hear:
- what you changed,
- what worked well,
- and what students struggled with.

That feedback improves the framework and advances open, rigorous, professional data administration education.
```
