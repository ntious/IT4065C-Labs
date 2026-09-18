# Contributing Guide (CONTRIBUTING.md)

Thank you for your interest in contributing to **Data Technologies Administration**.

This repository is an open educational framework built to teach **enterprise data governance and architecture** through a progressive lab sequence and a structured capstone simulation. Contributions must preserve the instructional design goals of the course:

- **Architecture before tools**
- **Governance as an operational discipline**
- **Evidence-based reasoning**
- **Traceability from requirements → design → controls → monitoring**

This curriculum supports evidence-based instruction, professional practice and adoption by other educators.

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

Contributions must improve clarity, reproducibility or architectural integrity and remain aligned with the course outcomes.

---

## Types of Contributions Welcome

### High-value contributions
- **Clarity improvements**: wording, reorganization, diagrams, and student-friendly explanations
- **Error fixes**: typos, broken paths, inaccurate instructions, inconsistent terminology
- **Reproducibility enhancements**: verification steps, troubleshooting, environment compatibility notes
- **Accessibility improvements**: readability, navigation, and inclusive course framing
- **Assessment alignment** (public-safe): rubric *summaries* or evaluation principles (not grade keys)
- **Security hygiene**: safer defaults, clearer RBAC examples, improved masking guidance
- **Architecture diagrams**: Mermaid diagrams that clarify lifecycle, lineage, and control boundaries
- **Instructor support**: educator notes, adaptation guidance, implementation tips

### Contributions that require discussion first
Please open an Issue before starting work on:
- Major restructuring of labs or capstone phases
- Toolchain swaps (e.g., replacing dbt/PostgreSQL)
- New datasets or significant changes to the case study
- Adding new “modules” that change course scope

### Excluded contributions
- Uploading **student work** (even anonymized unless explicitly approved and scrubbed)
- Any **credentials**, keys, or private endpoints
- Material that violates copyright or includes proprietary content
- Content that encourages unsafe behavior in real environments (e.g., misuse of security tools)

---

## Repository standards

### 1) Traceability
- Capstone decisions must remain grounded in stakeholder requirements
- Support governance claims with evidence and state their scope

### 2) Minimal extraneous cognitive load
- Keep instructions clear and stepwise
- Prefer consistent file structure and naming
- Add verification gates when possible

### 3) Tool-agnostic principles (with tool-specific implementation)
- The repo uses a specific stack, but the learning objectives remain transferable:
  - governance → lifecycle → enforcement → monitoring → evaluation

### 4) Professional tone
- Write for students, TAs, and educators
- Avoid “gotcha” language; emphasize reasoning and accountability

---

## How to Contribute

### Step 1: Open an Issue (recommended)
Before a pull request, open an Issue describing:
- What you observed
- Why it matters (student confusion, reproducibility, alignment, etc.)
- Proposed fix and affected files

Use these **issue labels**:
- `bug` (broken steps / scripts)
- `clarity` (confusing or ambiguous instructions)
- `reproducibility` (environment-specific fixes)
- `pedagogy` (learning design improvements)
- `docs` (documentation)
- `security` (RBAC/masking/monitoring improvements)

### Step 2: Make a Focused Pull Request
Keep PRs scoped. Prefer:
- One improvement theme per PR
- Clear commit messages
- Short explanations of why the change improves learning or reliability

### Step 3: Verification Expectations
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

## Editorial voice

Write in a clear instructor voice. State the purpose, required action, expected
evidence and assessment criterion directly. Use a colon to separate a heading's
number or topic from its description. Explain unfamiliar terms and offer a concrete
next step when a learner encounters an error.

Use accurate scope statements: name what was tested, where and at which revision.
Keep release administration in the maintainer guides. Replace obsolete status notes
when verification changes. Preserve uncertainty when it is part of a scenario,
privacy risk or evidence limitation; do not turn it into an unsupported assurance.
Distinguish hypothetical student proposals from implemented course features.

## File/Directory Conventions

Please do not rename or relocate files without discussion, especially inside:

- `labs/`
- `capstone_project/`
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

Follow the private reporting route in [SECURITY.md](SECURITY.md). Never post credentials in an issue.

---

## Thank You

Contributions help this repository remain a high-quality, reusable framework for teaching **enterprise data governance and architecture**.

If you are an educator adapting this course, I’d love to hear:
- what you changed,
- what worked well,
- and what students struggled with.

That feedback improves the framework and advances open, rigorous, professional data administration education.

## Preserve authorship and attribution

Retain Isaac K. Nti’s original author credit and copyright notices. Follow
[CITATION.md](CITATION.md) when reusing curriculum or code. Credit third-party
material accurately and describe adaptations without implying endorsement.

## Student project showcase

To propose an entry for [the showcase](docs/student_projects.md), supply:

- A project URL and the team's preferred attribution. Public links are preferred;
  private links must carry a prominent restricted-access notice and a summary
  suitable for public sharing. Private project access must not be required for labs.
- A concise problem statement and the course concepts demonstrated.
- Links to specific implementation, documentation or evidence supporting the description.
- The course term only when confirmed, and a commit or release for a stable example.

Confirm the team's agreement to the featured description and credit. Link to its
repository rather than copying student work into this one. Preserve the students'
authorship and their project's license terms; the course's license does not apply
automatically to external projects. Do not publish grades or private submission records.
Record whether claims come from project documentation or independent execution.

---

Author: [Isaac K. Nti](AUTHORS.md). [Citation and reuse terms](CITATION.md).
