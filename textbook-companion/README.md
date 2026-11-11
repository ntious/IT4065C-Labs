# Enterprise Data Systems: textbook companion

Companion to *Enterprise Data Systems: Architecture, Governance, Security, and Administration*.

Start with the [chapter guide](CHAPTER_GUIDE.md). Each chapter links to a focused activity, relevant course resources and, where available, an optional executable book example. The existing [course lab sequence](../labs/README.md) and [capstone](../capstone_project/README.md) remain their own learning routes. Book examples add no course submission or grading requirement.

## Choose your route

- **Reading and decisions:** use the chapter activities, [evidence guide](EVIDENCE.md), [terminology and scope](SCOPE_AND_TERMINOLOGY.md), and [blank records](reference/README.md). No database is required for an investigation or decision unless its instructions say otherwise.
- **Existing course labs:** follow their canonical instructions and prerequisites. Several chapters reuse the same lab; retain current evidence rather than duplicating submissions.
- **Optional executable book examples:** follow [SETUP.md](SETUP.md), then select one of the four suites below. The launcher creates temporary database clusters and copies of the scripts; it does not connect to the course database.

| Suite | Chapters | What it demonstrates |
| --- | --- | --- |
| [Foundations](examples/foundations/README.md) | 1–3 | Query scope, relational constraints, detection versus prevention and normalization anomalies |
| [Transactions and analytics](examples/transactions/README.md) | 4–6 | Quality exceptions, atomic rollback, controlled concurrency, grain, reconciliation and historical dimensions |
| [Lifecycle and recovery](examples/lifecycle/README.md) | 10–14 | Copies and restoration, access boundaries, credential rotation, hash linkage, monitoring and same-host PITR |
| [Temporal and decision examples](examples/reasoning/README.md) | 7–9, 15–18 | Temporal joins, bounded fixture calculations, approval matching, platform arithmetic and synthetic AI metrics |

Before execution, write a prediction. Afterward retain the relevant observation, explain it, state its limits and connect it to a requirement or decision. A supplied result is a reference observation, not evidence that your own run succeeded.

## Evidence and scope

[Reference evidence](evidence/README.md) identifies the tested environment and bounded results. [SOURCE_MAP.csv](SOURCE_MAP.csv) maps included files to their chapter purpose and hashes. Course-derived fixtures and functions are pinned to `d860dd98256a8090ffc6bd3766c59cb15a553c12`; the companion's own [release manifest](release-manifest.json) identifies its files separately. A later repository version can differ.

All demonstration records are synthetic. Purpose-based database roles and synthetic actors are instructional fixtures, not actual users or their activity histories. Credentials are generated during each isolated lifecycle run and are not published. Results generated on your machine remain private under `.local/textbook-companion/` by default. Keep personal paths, credentials and raw logs out of public submissions.

These demonstrations establish behavior under the stated local conditions. They do not establish enterprise security, regulatory compliance, representative AI performance, independent disaster recovery or the complete implementation of the fictional retailer.

## Citation and reuse

Original teaching material: Isaac K. Nti. The examples have been adapted for isolated, reproducible companion use; changes are described in [CHANGES.md](CHANGES.md). Covered code uses the repository [MIT license](../LICENSE); covered instructional text uses its [content license](../LICENSE-CONTENT.md). Retain attribution and applicable notices. Third-party full texts and student work are not included.

Repository citation: Nti, I. K. (2026). *IT4065C-Labs: Data Technologies Administration* [Software and instructional materials]. https://doi.org/10.5281/zenodo.24046602

Direct repository: https://github.com/ntious/IT4065C-Labs. The all-versions DOI resolves to the latest release; record the actual revision when reproducing an example.
