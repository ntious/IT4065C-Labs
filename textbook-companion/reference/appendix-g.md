# Appendix G
# Governance, Requirement, ADR, and Evidence Templates

These templates connect stakeholder statements to authorized decisions and planned verification. Use Appendix H to record observations and assess evidence after work is performed. A completed plan is not an executed control. Copy the relevant template for each record; expand its response cells as needed. Bracketed text is a completion prompt, not a case fact or an approved identifier.

## G.1 Record conventions

Use stable identifiers from the approved register. Requirement prefixes in the book are `BUS`, `DATA`, `FUNC`, `NFR`, `RULE`, `CON`, and `ASM`, followed by a hyphen and three digits. Do not recycle an identifier or encode a chapter number into it. Use `ADR-###` only through the case register; use an explicitly independent identifier such as `EX-ADR-001` for an unrelated teaching example. EDS labels such as `EDS-LAB-013` are book navigation aliases for linked course resources. They do not create new course lab numbers or command identifiers, and they are not requirement identifiers. The linked canonical path identifies the activity.

Keep four states separate: requirement agreement, architecture-decision status, implementation state, and evidence state. An accepted decision can still be unimplemented; an implemented control can remain untested. The ADR status vocabulary is Proposed, Accepted, Superseded, and Deprecated. Record dates and the authority for a change rather than silently rewriting history.

## G.2 Stakeholder evidence and requirement record

| Field | Response |
| --- | --- |
| Record identity | [Approved requirement ID; version; author; date.] |
| Source statement | [Quotation or faithful summary; source/person role; interview or artifact date; retrievable location.] |
| Interpretation | [What the statement means; ambiguities; distinction between stated fact, preference, assumption, and constraint.] |
| Requirement | [One testable obligation or outcome; affected population, operation, and conditions.] |
| Rationale and authority | [Why it matters; who may agree or reject it; stakeholders affected.] |
| Acceptance criteria | [Observable result; units; threshold; time window; allowed exceptions; who evaluates.] |
| Dependencies and conflicts | [Related IDs; conflicting needs; assumptions; unresolved definitions.] |
| Priority and agreement | [Priority with rationale; agreed/proposed/disputed status; decision date and evidence.] |
| Implementation and evidence | [Linked ADR/control; separate implementation state; planned or available evidence; limitations.] |
| Review trigger | [Date, change, incident, or assumption failure requiring review.] |

Avoid “the system shall be fast” or “data shall be secure.” Specify the workload or operation, relevant population, measurable acceptance condition, and authority that accepts the result. Do not invent a threshold merely to make a requirement look testable: retain the unresolved question and assign responsibility for resolving it.

## G.3 Decision rights and stewardship record

| Field | Response |
| --- | --- |
| Decision and scope | [Resource, purpose, population, and decision to be made.] |
| Accountable authority | [Business role with documented authority; source and limits of delegation.] |
| Responsible participants | [Who performs the work; named stewardship and technical custody duties.] |
| Consultation and notification | [Who must be consulted or informed; what evidence they need.] |
| Constraints | [Policy, contract, applicable obligations, and technical limits; source for each.] |
| Escalation | [Trigger, recipient, time limit, and action while unresolved.] |
| Review and succession | [Review date; replacement/delegation arrangements; retained record.] |

If a RACI matrix is used, define Responsible, Accountable, Consulted, and Informed in that context. The book's case convention of one accountable role per decision is a coordination choice, not a universal law. Technical ownership of a PostgreSQL object does not establish business accountability. Managing profiles or maintaining infrastructure does not automatically confer authority to approve new uses.

## G.4 Classification and handling decision

| Field | Response |
| --- | --- |
| Resource and version | [Dataset, view, extract, report, backup, or derived artifact; location; copy relationships.] |
| Purpose and content | [Intended use; people affected; fields; granularity; linkage possibilities.] |
| Proposed classification | [Public / Internal / Sensitive / Restricted, using the case definitions.] |
| Rationale and harm | [Plausible harm chain; disclosure, integrity, and availability considerations; uncertainty.] |
| Derivation | [Aggregation, hashing, suppression, or other transformation; residual inference and linkage risk.] |
| Access and sharing | [Permitted roles, operations, recipients, and conditions; approval authority.] |
| Retention and disposal | [Trigger event; duration; authoritative basis; holds; copies; disposal method and evidence.] |
| Decision and implementation | [Approver/date; policy version; implemented controls; validation references; remaining gaps.] |
| Review trigger | [New purpose, new recipient, changed linkage, incident, or scheduled review.] |

A label does not enforce access. Aggregation does not automatically make a dataset Public, and hashing does not automatically anonymize identifiers. A stakeholder's requested retention period is an input to review, not proof of a legal obligation. Do not convert the case's unverified seven-year assertion into a general rule.

## G.5 Architecture decision record

| Field | Response |
| --- | --- |
| ID, title, status, date | [Registered ID; decision in plain language; Proposed/Accepted/Superseded/Deprecated; dates.] |
| Context | [Requirements and source evidence; decision boundary; unresolved assumptions.] |
| Options | [Realistic alternatives, including retaining the current approach where meaningful.] |
| Decision | [Chosen option and exact scope; deferred elements.] |
| Rationale | [Criteria, evidence, tradeoffs; mandatory constraints distinguished from preferences.] |
| Consequences | [Benefits, costs, risks, dependencies, migration and operating responsibilities.] |
| Verification plan | [Claims; tests or inspections; expected outcomes; populations; limits; evidence custodian.] |
| Authority and review | [Approver; approval evidence; review triggers; superseding/superseded links.] |

Do not mark an option compliant merely because evidence is missing. A favorable weighted score cannot override an unmet mandatory constraint. Acceptance of an ADR records a decision; it does not supply the verification evidence promised in the record.

## G.6 Requirement-to-Evidence Trace

Use this vertical form when a wide matrix would become unreadable. Maintain links in both directions so that a changed requirement can lead to affected tests and an observed failure can lead back to the requirement.

| Trace element | Response |
| --- | --- |
| Stakeholder evidence | [Source, date, authority, and uncertainty.] |
| Requirement(s) | [Stable IDs, versions, and acceptance conditions.] |
| Architecture decision | [ADR ID, status, rationale, and dependencies.] |
| Implementation / control | [Actual object, procedure, configuration, owner, and version; or clearly labeled proposal.] |
| Evidence | [Planned method or actual evidence IDs; distinguish the two; use Appendix H for observations.] |
| Limitation | [Untested operations, populations, time periods, copies, or assumptions.] |
| Review / revision | [Trigger, accountable reviewer, action, due date, and revised links.] |

For example, a rule about completed-order immutability requires attention to both headers and lines. A header-update rejection alone cannot close a requirement covering line insertion, modification, and deletion. This is a method illustration, not a completed capstone solution.

## G.7 Exception and assumption records

| Field | Response |
| --- | --- |
| ID and type | [Registered assumption, exception, or change record; linked requirements.] |
| Statement and scope | [What is assumed or temporarily permitted; affected resources and period.] |
| Basis and uncertainty | [Source evidence; why unresolved; consequence if false.] |
| Authority and conditions | [Who can approve; compensating controls; explicit limits.] |
| Time boundary | [Effective-from and expiry timestamps with timezone; renewal conditions.] |
| Owner and action | [Responsible investigator; due date; evidence needed.] |
| Resolution | [Confirmed/rejected/expired/replaced outcome; evidence; impacted records updated.] |

An exception should not become permanent merely because nobody revisits it. For time-bound authorization, define how boundaries are interpreted—for example, effective at the start timestamp and expired at the end timestamp—and test operations on both sides of the boundary where relevant.

## G.8 Reusable companion records

Editable Markdown versions of these blank forms are available in the root-level `textbook-companion/reference/appendix-g.md`; observation and audit records are in `appendix-h.md` in the same folder. Begin with `textbook-companion/reference/README.md`. Keep the public templates blank and save completed records privately. Use the relevant existing portfolio record when one already serves the purpose; these forms introduce no additional course submission requirement.

## G.9 Use and sources

These blank forms synthesize Chapters 2, 8, 9, 15, and 18 and the book's shared terminology. They are designed for adaptation, not as institutional policy or legal advice. Keep completed records in an appropriate controlled location. Publish only reviewed, sanitized examples; do not expose credentials, personal records, or a complete student answer key.
