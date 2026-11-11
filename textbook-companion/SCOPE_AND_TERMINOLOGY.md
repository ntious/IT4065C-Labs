# Scope and terminology

The textbook explains general principles, applies them to a fictional Governed Retail case, and uses selected local experiments to inspect mechanisms. These are different forms of support. A useful discussion may rely on authoritative references and explicit reasoning without requiring a new executable lab.

| Term | Use in this companion |
| --- | --- |
| Requirement | A stated need or constraint with source, scope, authority and acceptance conditions. An unconfirmed stakeholder assertion remains an assumption to investigate. |
| ADR | A decision record containing context, alternatives, rationale, consequences, status and review trigger. A proposed ADR is not approval evidence. |
| Data owner | Accountable business authority for a stated data scope. Database object ownership is a different technical mechanism. |
| Steward / custodian | Stewardship coordinates defined data responsibilities; custody operates technical arrangements. Neither automatically confers every business approval right. |
| Classification | Public, Internal, Sensitive and Restricted are the case's handling categories. Classification labels do not themselves change database privileges. |
| Grain | What one row represents. Compare measures only after reconciling populations, grain, time and inclusion rules. |
| Lineage / copy inventory | Dependencies describe derivation; a copy inventory records relevant stored, exported, backed-up or archived instances. Neither implies the other is complete. |
| Data test / database constraint | A test detects conditions when executed; a constraint can prevent covered invalid writes. Their scope and timing differ. |
| Recovery objective / observation | RPO and RTO express accepted targets. A measured local duration does not automatically demonstrate either target for a business service. |
| Technical success / fitness for use | Successful execution supports a bounded mechanism claim; suitability, authority and acceptable harm need additional reasoning and evidence. |

Use the [glossary](reference/glossary.md) for fuller definitions. Date-interval conventions are stated per example: Chapter 7's day-granularity lookup uses inclusive endpoints, whereas the approval example uses an inclusive start and exclusive end. Do not transfer one convention silently into another example.

## Reading the evidence labels

| Label | Meaning |
| --- | --- |
| EXT-PRI | An authoritative external source supporting the associated explanation. |
| R-DOC | Inspected repository content. Source code alone does not show a run completed. |
| R-OBS | An attributed recorded repository observation; retain its original conditions and date. |
| R-SIM | A repository-provided simulation or synthetic scenario. Executing it does not make the scenario a historical incident. |
| R-INF | An inference drawn from repository material; distinguish it from a direct observation. |
| R-PROP | A proposed repository-related design or extension. |
| AUTH | A textbook-created example, fixture, argument or design. |
| AUTH-OBS | Recorded execution or direct observation by an identified author or engineer; retain the method and conditions. |
| PEND | Evidence or a decision is pending; it is not a pass. |

The reference results describe executed synthetic examples, not real user histories. Inspection, execution, inference and proposal remain separate even when they appear in the same activity.

## Resource labels

Labels such as `EDS-LAB-013` are book navigation aliases. They do not create new course lab numbers or command identifiers. The linked repository path and its canonical lab instructions identify the actual activity.
