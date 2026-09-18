# Phase 6: Architecture defense

Present an 8–12 minute, ten-slide defense of your design to a simulated review board.
Support decisions with evidence from your portfolio. Distinguish demonstrated,
simulated, proposed and untested claims throughout; confidence is not evidence.

| Slide | Required argument |
| --- | --- |
| 1. Purpose | Stakeholders, problem, intended use and success criteria |
| 2. Model | ERD, grain, keys, relationships and one justified modeling decision |
| 3. Workloads | OLTP/OLAP placement and tradeoffs; explain measurements needed before claiming scalability. Analytics placement depends on workload and isolation requirements. |
| 4. Lifecycle | Collection through retirement, derived copies, validation and refresh/deletion responsibilities |
| 5. Governance | Owners, permitted uses, sensitivity and retention; distinguish policy from enforcement |
| 6. Access | Tested role boundaries, masking limits, and proposed transport/storage protections |
| 7. Monitoring | Actual observations, simulated alerts, gaps in server evidence and response ownership |
| 8. AI and risk | Bias mitigation tradeoff, transparency, appeal, accountability and one harm scenario; state facts needed before making legal claims |
| 9. Infrastructure | Compare cloud, on-premises and hybrid; justify choice and acknowledge untested availability/recovery claims |
| 10. Decision | Recommend proceed, conditional proceed or defer; name conditions, next checks and unresolved risks |

Submit the presentation and portfolio privately. Text equivalents for visual diagrams
and readable tables are welcome. Use accessible text evidence; screenshots are optional.
Include the peer review response and individual reflection.

## Board questions

Be prepared to explain one alternative you rejected, one control not yet tested,
one stakeholder who bears risk, and one result that would change your recommendation.
A design decision should be connected to its requirement, implementation status,
evidence and limitations. Do not infer legal consequences or production readiness
from the synthetic exercise alone.

## Assessment

Assess architectural reasoning, evidence quality, cross-phase consistency,
tradeoffs, AI lifecycle accountability and clear communication. Use the
[public descriptors](../docs/assessment_examples.md); official grade weights remain
in the LMS. A justified decision to defer deployment can be strong work.

---

Author: [Isaac K. Nti](../AUTHORS.md).
