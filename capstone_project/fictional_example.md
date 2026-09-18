# Fictional capstone example: Community equipment lending

This miniature example illustrates reasoning and traceability in a different
domain. It is instructional fiction, not a tested system, student submission,
complete model or solution to the retail project. All observations below are
simulated example evidence; do not report them as your own lab results.

## From a stakeholder request to a decision

A community workshop lends tools. Its coordinator asks: "Volunteers need to know
which tools are overdue, but only coordinators should see borrower contact details."
Requirement R1: a volunteer can see an overdue tool and loan identifier without
contact details. R2: a coordinator can contact the borrower. Clarify whether a loan
can contain several tools and when contact records should be removed.

An initial model uses Borrower, Tool, Loan and LoanItem. LoanItem has one row per
tool on a loan; counting joined rows is not the number of loans. Operational tables
support lending and returns; a proposed daily aggregate supports demand planning.
The retention decision remains unresolved until the owner specifies purpose and
applicable obligations. Do not invent a legal retention period.

## Traceable claim and evidence matrix

| Requirement | Proposed control / owner | Illustrative evidence | Status and limit |
| --- | --- | --- | --- |
| R1 | Volunteer view excludes contact columns; platform administrator | E1: SELECT view returns loan/tool identifiers; E2: SELECT contact table denied with 42501 under separate volunteer login | Simulated example observations; an actual submission must supply its own executed records and test both allow and deny. |
| R2 | Coordinator-only contact view; service owner approves access | E3: separate coordinator query returns the needed contact field | Simulated; does not prove periodic access review or prevent authorized misuse. |
| R3: review overdue trends | Daily aggregate with refresh owner | Proposed reconciliation of count to source grain | Proposed; freshness and concurrency are untested. |
| R4: protect communications | Verified TLS | No executed TLS evidence supplied | Untested; cannot claim transport protection. |

For real evidence, record revision, date, environment, identity role, command,
expected/actual result and relevant redacted excerpt. Link the artifact privately.
Use **demonstrated** only for an actually executed assertion in the named environment.

## Weak claim, revision and recommendation

Weak: "Our database is secure and compliant because the view works."

Improved: "The simulated E1–E2 example illustrates how separate-login allow/deny
checks could support R1. It does not establish transport protection, independent
audit retention, legal compliance or protection from administrators. We recommend
the restricted volunteer view, subject to actual negative testing and owner approval."

Tradeoff: removing borrower detail reduces exposure but requires volunteers to
escalate contact requests. The service owner should measure response delays and
review access each term. Before production, test TLS and denial behavior and resolve
retention obligations with the responsible institutional role.

## AI change review

If someone proposes predicting borrower reliability from late returns, pause the
new use. The original lending purpose does not itself authorize profiling. Identify
affected borrowers, errors, uneven access to transport, transparency, appeal and the
accountable decision owner. Recommend against deployment until purpose and impact
are assessed; no predictive model or fairness evaluation has been demonstrated here.

## Assessment calibration

Developing: repeats the weak claim with no source or evidence label. Competent:
links R1 to positive and negative evidence and states a limit. Strong: also explains
the workflow cost, missing evidence, accountable owner and explicit review trigger.
Have two instructors assess the same fictional paragraph, compare their rationale
against the [descriptors](../docs/assessment_examples.md), and resolve differences
before applying the rubric to private student work. The example has no official grade.

[Capstone guide](README.md) · [Authorship](../AUTHORS.md)
