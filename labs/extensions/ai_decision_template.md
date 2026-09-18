# AI governance decision

Scenario: a retailer proposes AI-assisted support prioritization using synthetic examples.

1. Dataset card: origin, purpose, representativeness, label limitations, prohibited use,
   sensitive/proxy attributes, retention and downstream copies.
2. Compare baseline/mitigation group sample sizes, selection rates, false-positive
   and false-negative rates. Explain uncertainty and the cost of each error.
3. Record one stakeholder harmed by either policy and an alternative mitigation.
4. Transparency: user-facing purpose/limitations notice, explanation and appeal route.
5. Accountability: name roles for data stewardship, evaluation, approval, monitoring,
   incident response, rollback and retirement (use fictional roles, not real people).
6. Map your decisions to NIST AI RMF 1.0 Govern, Map, Measure and Manage. These interact;
   the framework is voluntary guidance, not a certificate or proof of legal compliance.
7. Approve / conditionally approve / reject, with evidence, monitoring thresholds,
   review date and rollback trigger. Not deploying is a valid conclusion.

## Connect the decision to the data lifecycle

| Stage | Evidence to attach or explicitly propose |
|---|---|
| Collection and curation | Source/purpose, label origin, inclusion/exclusion decisions, group-data audit justification |
| Storage and access | Data steward, retention/hold rule, who may read audit attributes versus ordinary features |
| Preparation and evaluation | Proxy/label-bias concern, separate evaluation use, metric denominator and sample-size limitations |
| Use and disclosure | Intended/prohibited use, affected-person notice, explanation and human appeal route |
| Monitoring and change | Drift or harm signal, trigger, reviewer, version/change record and rollback decision |
| Retirement | Which derived copies remain, deletion/retention evidence, unresolved backup or model-retraining implications |

Link your Lab 2/4/5/6 artifacts where relevant. Mark unimplemented controls as
proposed. A data file being available does not establish permission for a new AI use.
An analysis of group rates does not determine whether collecting a sensitive audit
attribute is ethically justified; explain the purpose, necessity and access boundary.

## Required change review

After your initial decision, assume the retailer proposes using support-priority
predictions to restrict refunds, and the incoming population differs from the
small evaluation fixture. No new performance or harm measurements are available.

Write a short amendment: identify the changed purpose and affected stakeholders;
state which previous evidence no longer supports the decision; request specific
new evidence; revise the user notice and appeal route; assign review and response
roles; and decide whether to pause, restrict or continue use. Explain what happens
to old predictions and retained copies. Do not invent new measurements. This is
part of the same AI rubric, not an additional lab or new grade category.

Resources: [NIST AI RMF](https://www.nist.gov/itl/ai-risk-management-framework),
[Playbook](https://www.nist.gov/itl/ai-risk-management-framework/nist-ai-rmf-playbook).
Rubric: lifecycle 20%; bias analysis/limitations 25%; mitigation tradeoffs 20%;
transparency 15%; accountability/framework application 20%.

---

Author: [Isaac K. Nti](../../AUTHORS.md). [Citation and reuse terms](../../CITATION.md).
