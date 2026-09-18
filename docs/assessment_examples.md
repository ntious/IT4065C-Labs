# Assessment descriptors and worked reasoning

The core rubric applies to Labs 1–6. Lab 7 uses only the AI decision template's
specialized weights. These are activity rubrics, not official course grade weights.

| Criterion | Developing | Competent | Strong |
| --- | --- | --- | --- |
| Evidence, 25% | Outcome asserted with missing source or command | Relevant reproducible observation and correct expected result | Includes an appropriate negative check and clearly delimits the assertion |
| Interpretation, 35% | Describes output without explaining it | Explains the mechanism and relates it to the question | Tests an alternative explanation and identifies an important limitation |
| Transfer, 30% | Repeats the example unchanged | Applies the concept to the changed scenario with rationale | Evaluates a plausible competing choice and its consequences |
| Clarity and limits, 10% | Ambiguous claim or unqualified assurance | Organized evidence, attribution and explicit limits | Concise trace from claim to evidence to remaining verification |

Missing evidence should be recorded as missing, not inferred from polished writing.
These levels guide judgment rather than imposing an automatic numeric conversion.
Instructors calibrate numeric scoring privately before marking. Self-learners use
Competent as their initial target and revise after peer feedback.

## Worked example: a fictional library

Weak claim: "Our library database is secure because a query failed."

Improved claim: "Using the library reader login, UPDATE on the loan table was
denied while the approved summary SELECT succeeded. This demonstrates those two
permissions in the tested database. It does not test all roles, backups, network
transport or administrator access. Next I would test the separate archivist role."

Why stronger: it identifies actor, action, object, positive and negative evidence,
scope and a useful next check. It does not turn one denied query into a universal
security claim. This is an example of reasoning, not a solution to the retail labs.

## AI decision assessment

Use the [AI rubric](../labs/extensions/ai_decision_template.md). For each dimension,
Developing means an unsupported assertion or missing lifecycle connection;
Competent means a justified decision with relevant evidence and limitations;
Strong means a defensible tradeoff, competing stakeholder perspective and a
specific review/response condition. Rejecting deployment can earn full credit.
Metric parity alone cannot earn full credit for the ethics decision.

---

Author: [Isaac K. Nti](../AUTHORS.md).
