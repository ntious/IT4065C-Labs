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

For the proposed borrower contact record, the team selects **Sensitive** handling
and estimates **High** confidentiality impact because unwanted disclosure could
expose contact details. Regulatory applicability remains **undetermined** until
jurisdiction and purpose are established. These are separate judgments; the
classification is not proof of a legal obligation.

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

## Complete worked trace: restricted volunteer reporting

The following is an illustrative design trace for this fictional lending case,
not a solution to the retail capstone. No new implementation or execution is claimed.
The existing retail Lab 5 artifacts illustrate the same mechanism; they do not
prove that the proposed lending system implements it.

| Trace step | Worked example and evidence boundary |
| --- | --- |
| Stakeholder statement | The coordinator asks volunteers to identify overdue tools while reserving contact details for coordinators. This is an interview assertion requiring scope confirmation. |
| Requirement R1 | Volunteers may read loan/tool identifiers needed for overdue follow-up; they must not retrieve borrower contacts. Clarify dates, permitted use and approval owner. |
| Decision D1 and alternative | Propose a restricted owner-controlled reporting view and separate volunteer login. Reject broad SELECT on borrower tables because it exposes unnecessary contacts. Escalating contact requests costs coordinator time. |
| Data/model decision | LoanItem has tool-on-loan grain; join Loan, Tool and LoanItem for overdue status. Exclude Borrower contact columns. Counting joined rows counts loan items, not distinct loans. A proposed dbt aggregate would require separate grain, reconciliation and freshness checks. |
| PostgreSQL mechanism | The proposed view projects only approved fields; revoke direct raw access and grant SELECT on the restricted view. The repository's [Lab 5 views](../labs/core/lab05-access-control/02_build_safe_objects.sql) and [grants](../labs/core/lab05-access-control/03_rbac_and_grants.sql) illustrate this mechanism using retail roles and data. They are not lending implementation files. |
| Control and owner | Service owner approves purpose/fields; platform administrator configures separate logins and grants. Verify that role membership and alternate objects cannot bypass the intended boundary. |
| Evidence plan | With separate authenticated logins, query the restricted view (expected allow), then request contact/raw data as volunteer (expected SQLSTATE 42501). Record revision, role, command, expected/actual result and redacted excerpt privately. Wrong password or missing table is not authorization evidence. |
| Illustrative evidence | E1/E2 above are **simulated**. The lending control remains **proposed** until implemented and tested. The [Lab 5 guide](../labs/core/lab05-access-control/README.md) supplies a real retail exercise for learning this verification pattern; do not relabel its output as lending evidence. |
| Limitation and next check | These cases would not establish administrator protection, TLS, independent audit retention, legal compliance or all possible access paths. Review the full view definition after changes and retest negative access. |
| Executive justification | Recommend D1 subject to owner approval and actual testing: it reduces routine contact exposure while preserving overdue follow-up. Review coordinator delay and access after a role, field or purpose change. |

Use the existing [portfolio claim/revision record](portfolio_template.md#claim-and-revision-record)
for your own trace. This example adds no report or assessment requirement.

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
