# Appendix H
# Evidence and Audit Templates

These templates record what was inspected or observed and the conclusions it supports. Appendix G provides the planning and authority records to which they should link. Duplicate forms as needed, preserve raw outputs separately, and keep publication extracts sanitized. Empty cells mean incomplete recording; they do not mean a test passed.

## H.1 Evidence classification and provenance

The following evidence codes distinguish the origin and status of evidence. They are not a ranking of credibility. Use the code with a description and provenance; combine codes only when both meanings apply.

| Code | Meaning |
| --- | --- |
| EXT-PRI | Authoritative external source supporting the associated explanation. |
| AUTH | Textbook-created example, fixture, argument or design; authorship alone does not establish execution. |
| R-DOC | Repository artifact or document inspected. |
| R-OBS | Existing execution result already evidenced by repository validation. |
| R-SIM | Deliberately simulated repository condition. |
| R-INF | Inference supported by repository material. |
| R-PROP | Proposed or unimplemented design or control. |
| AUTH-OBS | Recorded execution or direct observation by an identified author or engineer; retain the method and conditions. |
| PEND | Verification incomplete. |

A newly executed author or engineering test is AUTH-OBS; it is not automatically historical R-OBS. Readers should identify their own observations explicitly. An authored example can be AUTH + AUTH-OBS when it has actually been executed, with its conditions recorded. A deliberately introduced failure can be R-SIM + AUTH-OBS. Chapter 18's portfolio labels—demonstrated, simulated, proposed, and untested—serve a different reporting purpose. Explain the relationship rather than treating the two vocabularies as interchangeable.

| Provenance field | Record |
| --- | --- |
| Identity | [Evidence ID; run ID; author/engineer; execution or inspection date.] |
| Baseline | [Repository URL; course fixture baseline; companion-containing commit, or manifest and uncommitted state; tracked changes and relevant untracked/configuration differences.] |
| Environment | [OS; PostgreSQL; dbt Core and adapter; Python; relevant package state; locale/timezone.] |
| Data | [Dataset/version; source; checksum method and value; relevant population.] |
| Activity | [Exact command/check; parameters excluding secrets; start/end timestamps; exit status.] |
| Classification and deviation | [Evidence code(s); deliberate changes; deviations from the baseline; cleanup evidence.] |
| Artifacts and custody | [Raw output location; sanitized derivative; custodian; access; retention; integrity check.] |

For the book's primary repository baseline, record `d860dd98256a8090ffc6bd3766c59cb15a553c12`. Keep later behavior separately identified. Use https://doi.org/10.5281/zenodo.24046602 for repository citation and https://github.com/ntious/IT4065C-Labs for direct access; the DOI does not replace the execution SHA. The course baseline predates the companion addition. For companion work, also retain `textbook-companion/release-manifest.json`, the relevant code/data hashes and the actual run identifier. A supplied reference result is not proof that the reader executed the example.

## H.2 Claim-to-evidence record

| Field | Record |
| --- | --- |
| Claim and criterion | [Exact assertion; requirement/control objective; authoritative criterion.] |
| Scope | [System/version; role; object; operation; population; period; exclusions.] |
| Method | [Inspection, execution, reperformance, inquiry, or analysis; why suitable.] |
| Expected | [Predefined result, including expected failure or denial; acceptance threshold.] |
| Observed | [Actual result and evidence IDs; errors/warnings; discrepancies; no retrospective rewriting.] |
| Evaluation | [Pass/fail/inconclusive/not executed, with reasons; relevance and reliability.] |
| Supports | [Narrow conclusion warranted by the evidence.] |
| Does not establish | [Untested paths, periods, populations, assumptions, and broader claims.] |
| Decision and follow-up | [Authorized conclusion; owner; action; due date; review trigger.] |

Separate control design, implementation, and operating effectiveness. A sound design may not be deployed; a deployed configuration may not have operated consistently throughout the review period. Sufficiency concerns the amount of evidence; appropriateness concerns its quality, including relevance and reliability. More irrelevant records do not repair a scope mismatch.

## H.3 Access-control test record

Record each intended allowance and denial as a separate case. Establish the identity in the same connection as the tested operation. A separate authenticated session is preferable when testing the experience of a login role; privileged role switching alone may leave important authentication conditions untested.

| Field | Record |
| --- | --- |
| Identity and environment | [Database; session_user; current_user; memberships; server version; relevant connection conditions.] |
| Target | [Qualified object; operation; policy/approval; effective period.] |
| Expected outcome | [Allowed or denied; expected rows/columns or SQLSTATE; reason.] |
| Observed outcome | [Result content or denial; actual SQLSTATE; client/server source; timestamp.] |
| Evidence and interpretation | [Raw artifact; sanitized extract; result; supports; limitations.] |

An expected privilege denial with SQLSTATE `42501` differs from a missing-object failure. Test the approved path as well as the forbidden path: a system that denies everything is not necessarily correctly configured. Note version-dependent behavior, such as PostgreSQL 15+ `security_invoker` views. One successful test supports the tested conditions at that time, not semester-long effectiveness or regulatory compliance.

## H.4 Population, sampling, and reconciliation record

| Field | Record |
| --- | --- |
| Population definition | [All relevant events/objects, inclusion rules, period, and authoritative population source.] |
| Completeness check | [How missing deliveries, failed runs, or omitted records were sought; denominator limitations.] |
| Selection | [Full population or sample; method; size; rationale; coverage limits.] |
| Reconciliation specification | [Source/target; grain; measure; unit/currency; time basis; status rules; nulls; returns; expected differences.] |
| Results | [Source value; target value; difference; record-level exceptions; unexplained differences.] |
| Conclusion | [What the comparison supports; possible offsetting errors; unresolved gaps.] |

Do not replace a failed sampled item with a passing one and call the sample complete. Preserve exceptions and their disposition. An operational log containing only successful runs cannot independently define all expected deliveries. Matching totals can conceal offsetting errors and cannot prove accurate source records.

## H.5 Finding, remediation, and closure

| Field | Record |
| --- | --- |
| Finding ID and criterion | [Applicable requirement, policy, or control objective; version and authority.] |
| Condition and evidence | [Observed departure; affected population and period; evidence IDs.] |
| Consequence and cause | [Supported impact; plausible risk; confirmed cause distinguished from hypothesis.] |
| Action | [Corrective action; accountable owner; due date; dependencies; interim measures.] |
| Retest | [New run ID; method; expected/observed results; positive and negative paths; regression scope.] |
| Closure decision | [Authority; date; evidence accepted; residual limitations; reopened or remaining issues.] |

“Fixed” is a claim requiring new evidence. Preserve the original failure, the change, and the retest as separate records. If the test covered only a header trigger, do not close a finding about order-line mutation. Where observations conflict, investigate identities, timing, versions, and sources rather than selecting the more convenient result.

## H.6 Recovery exercise record

| Field | Record |
| --- | --- |
| Scenario and boundary | [Local rebuild, same-host restore, controlled simulation, or independent recovery; failure assumed or induced.] |
| Objectives | [Approved RPO and RTO; business service scope; dependencies; acceptance authority.] |
| Timing | [Interruption/start definition; restoration milestones; usable-service acceptance time; clock/timezone.] |
| Data recovery | [Backup/reference point; last recoverable committed data; observed gap; independent comparison.] |
| Validation | [Objects, permissions, data, dependencies, and business functions checked; exceptions.] |
| Result and limitations | [Measured outcome versus objectives; untested failure domains; cleanup and follow-up.] |

RPO concerns acceptable data loss expressed as time; RTO concerns the target time to restore the required service. Define the measurement boundaries before testing. A completed backup is not a successful restore; a successful restore is not necessarily restored business service. Distinguish an actual same-host PostgreSQL restore from a transfer simulation and from independent-site recovery. The companion lifecycle suite performs actual local logical restoration and point-in-time recovery; the optional course transfer exercise demonstrates a different mechanism. Neither establishes independent-site disaster recovery. Record what was restored, the expected population, row-level reconciliation, excluded post-target data and remaining shared failure domains.

## H.7 Evidence preservation and publication checklist

Preserve original logs and test files without overwriting earlier runs. Record collection method, custody transfers, integrity checks, access, and retention. A checksum can detect a difference relative to a trusted reference but does not establish that the original content was truthful. Keep client output, server logs, dbt artifacts, synthetic events, alerts, and human interpretations identifiable as different sources.

Review publication extracts for credentials, personal data, private paths, tokens, internal URLs, and student information. Prefer selectable text and native tables over routine terminal screenshots. A reproduced panel should be labeled as a representation of evidence, not presented as an untouched capture. Retain the connection to the raw record in private evidence storage.

## H.8 Companion records and accepted results

Use `textbook-companion/reference/appendix-h.md` for a reusable blank copy and `textbook-companion/evidence/README.md` for supplied reference observations. An accepted result set can include corrected reruns from different run identifiers only when each included result and its code/data version are explicit. Preserve the original failure, the correction and the accepted rerun separately. Do not relabel a partly failed rehearsal as wholly successful. A checksum mismatch is evidence of changed bytes; investigate its cause before accepting the result.

## H.9 Use and sources

These forms synthesize Chapters 11, 13, 14, 15, and 18 and the book's repository evidence guidance. They support disciplined assessment; they are not a certification framework or a complete audit program. A blank form establishes no control effectiveness. Select and extend the forms to match the actual claim, scope, and review authority.
