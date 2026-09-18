# Course glossary and system overview

Use this as a reference when a term appears in an activity; memorization is not a
separate assignment. Vendor names are explained in the [platform guide](platforms.md).

| Term | Meaning in this course |
| --- | --- |
| Linux user | Operating-system account; its sudo permission is distinct from database permission. |
| Database login / role | PostgreSQL identity and privileges; a role can log in only when configured to do so. |
| Database | A separately named collection of database objects and access settings. |
| Schema | Namespace inside a database; its name alone does not enforce security. |
| Grain | What one row represents, such as one order or one order item. |
| Primary / foreign key | A row identifier / a reference to another relation's key; tests and enforced constraints differ. |
| ETL | Extract, transform and load data; transformation can also occur after loading. |
| Data curation | Selecting, documenting and preparing data for an intended use. |
| Metadata / catalog | Descriptions of data / an organized inventory of those descriptions. |
| Stewardship | Responsibility for definitions, quality, permitted use and issue resolution. |
| Lineage | Recorded dependencies and transformations; not proof of access enforcement. |
| DAG | Directed acyclic graph of dependencies; does not by itself schedule jobs or block bypass. |
| OLTP / OLAP | Transaction-oriented / analytical workloads, with different access and performance needs. |
| Masking | Limiting visible detail; does not automatically make data anonymous. |
| Audit trail | Recorded events used for investigation; source, completeness and resistance to alteration matter. |
| Retention / legal hold | A rule for keeping/deleting data / an authorized suspension of deletion. |
| RPO / RTO | Recovery point / time objectives; objectives require measurement before claiming achievement. |
| Bias mitigation | A change intended to reduce a specified harm; may introduce other tradeoffs. |
| Transparency / accountability | Explaining purpose and limits / assigning decisions, oversight and response responsibilities. |

## Follow one record

Synthetic files feed raw PostgreSQL tables. dbt reads raw data and builds staging,
core and reporting models. Tests check selected properties. Separate reader logins
exercise access boundaries. Students interpret outputs and connect them to their
capstone decisions. The AI exercise evaluates a separate synthetic prediction fixture.

Configuration flows from private `.env` to the runner and database clients.
Credentials do not belong in SQL, submissions or public issues. The local database
and temporary experiments are teaching environments, not a deployed enterprise platform.

---

Author: [Isaac K. Nti](../AUTHORS.md).
