# Course glossary and system overview

Use this reference when a term appears in an activity. Memorization is not a
separate assignment. Start with the short terms table in your lab; return here
only when you need more detail. Vendor names appear in the [platform guide](platforms.md).

## Course and environment

| Term | Meaning and example in this course |
| --- | --- |
| SLO | Student learning outcome: what learning an activity supports. Here it does not mean a service-level objective. |
| Core / optional | Core labs form the main learning sequence. Optional labs extend it; consult the course instructions for assigned work. |
| Capstone | A final project connecting several course skills into an architecture and evidence-based explanation. |
| Terminal / command | A text interface / an instruction entered there. Run the displayed commands without copying the prompt that precedes them. |
| Repository root | The top folder of this checkout, containing `scripts`, `labs` and `docs`. Relative command paths start here. |
| WSL / VM | Windows Subsystem for Linux runs a Linux environment on Windows. A virtual machine (VM) provides a separate operating-system environment. Native Ubuntu needs neither route. |
| Python virtual environment | A project-specific collection of Python packages, stored here in `.venv`. It is not an Ubuntu VM or a separate operating system. |
| Client / server | A client requests work; a server handles it. `scripts/query.py` is a database client; PostgreSQL is the database server. |
| Localhost / port | Localhost means the computer or network environment making the connection. A port identifies a service endpoint; this course normally uses 5432 for PostgreSQL and 8080 for documentation. WSL and Windows can involve different networking environments. |
| Linux user / sudo | An operating-system account / permission to run a command with another account's authority, usually administrator authority. This does not grant database login privileges automatically. |
| Environment variable / `.env` | A named setting supplied to a process / this course's private configuration file. The runner reads `.env` as configuration data, not as a shell script. Never submit it. |

## Data and transformations

| Term | Meaning and example in this course |
| --- | --- |
| Database / schema | A database contains related database objects. A schema groups named objects inside it: `raw.orders` means the `orders` table in the `raw` schema. Names alone do not enforce access restrictions. |
| Grain | What one row represents: one order item in a detailed report, or one day in daily sales. |
| Primary / foreign key | A primary key identifies a row. A foreign key constraint enforces a reference to another table's key. A logical relationship or a passing dbt test is not itself an enforced foreign key constraint. |
| dbt / model | dbt builds and tests data transformations. A dbt model is a saved SQL transformation producing a relation such as a table or view; it is not an AI prediction model. |
| Raw / staging / core / mart | Source records / cleaned source fields / reusable business entities / reporting results. An order moves from `raw.orders` through `stg_orders` and `fct_orders` into `olap_sales_by_day`. |
| View / table / materialization | A regular view stores a query definition; a table stores rows. Materialization is the strategy used to create a model's database representation. This course uses staging views and core/mart tables; a materialized view is a different object that also stores results. |
| Refresh / rebuild | Recompute stored results from their inputs. Deleting a source row does not automatically rebuild a downstream reporting table. |
| ETL / ELT | Extract-transform-load transforms data before loading it into the target. Extract-load-transform loads first and transforms there, as the course's raw-to-dbt workflow does. |
| OLTP / OLAP | Transaction-oriented work, such as recording an order / analytical work, such as summarizing daily sales. The `order_detail_mart` table supports detailed reporting; it is not an OLTP transaction-processing system. |
| Structured / semi-structured / unstructured | Consistent fields such as CSV columns / flexible labeled fields such as JSON / content such as prose without a fixed record layout. |
| Metadata / catalog / provenance | Descriptions of data / an inventory of those descriptions / information about where data came from and how it was handled. |
| Data curation | Selecting, documenting and preparing data for an intended use. |
| Lineage / DAG | Recorded dependencies / a directed acyclic graph showing dependency directions without loops. A graph helps trace impact but does not itself enforce permissions or schedule work. |

## Governance and access

These classification labels are teaching categories, not universal legal categories
or an official University classification policy. Justify a label for the stated purpose.

| Term | Meaning and example in this course |
| --- | --- |
| Public | Approved for public disclosure; absence of a password does not establish this approval. |
| Internal | Intended for use within the organization; not approved for public release. |
| Sensitive | Needs controlled access because disclosure or misuse could cause harm, such as a customer contact field. |
| Restricted | Needs especially limited access under the scenario's highest restrictions. Explain why ordinary sensitive-data controls would be insufficient. |
| Data owner / steward | The business role accountable for decisions / the role maintaining definitions, quality and handling practices. Organizations allocate these duties differently. Neither automatically means the PostgreSQL object owner. |
| Policy / enforcement | A stated rule / a mechanism applying it. Recording a retention rule in a register does not run a deletion job. |
| Authentication / authorization | Establishing which identity connects / deciding what that identity may do. A valid password can still lead to a denied query. |
| Database role / least privilege | A PostgreSQL identity or privilege grouping / granting only access needed for a task. A role can log in only when configured for login. |
| Masking | Reducing visible detail. A masked value is not automatically anonymous or safe to publish. |
| Retention / legal hold | A rule for keeping or deleting data / an authorized suspension of deletion. Lab rules are fictional decisions, not legal advice or proof of compliance. |
| Allowlist / quarantine | An explicit list of accepted inputs / setting aside rejected inputs for review. The catalog lab records rejected references and reasons; do not assume it creates a secure storage facility for rejected files. |
| Hash | A computed fingerprint useful for detecting changes. Matching a stored hash does not establish that the data is accurate or that its source is trustworthy. |

## Tests and operational evidence

| Term | Meaning and example in this course |
| --- | --- |
| Fixture / baseline | Prepared example data / the initial result used for comparison. Synthetic retail records are a fixture, not observations from a real retailer. |
| Assertion / negative test | A check of a stated expectation / a check that disallowed or invalid behavior is rejected. An expected permission denial can mean a test passed. |
| Quality gate | A check that must pass before data is promoted for use. Passing checks only supports the properties actually checked. |
| Transaction / rollback | A group of database operations treated as a unit / undoing uncommitted operations. A rollback does not undo an earlier committed transaction. |
| Idempotency | Repeating an operation has the same intended effect as doing it once, such as avoiding duplicate records on a retry. |
| KPI | Key performance indicator: a measure selected for a purpose. Define its units, time period and grain before interpreting it. |
| Event / alert / incident | An observed action / a signal that deserves review / an occurrence assessed as requiring a response. An alert alone is not proof of misconduct. |
| False positive / false negative | Flagging a case that does not meet the reference condition / missing one that does. Specify the condition; monitoring alerts and AI predictions use different contexts. |
| Audit trail / correlation | Records used to investigate actions / linking records using shared identifiers or times. Client output and server logs provide different evidence; neither is automatically complete or resistant to alteration. |

## AI decisions

| Term | Meaning and example in this course |
| --- | --- |
| Prediction / label | A system's proposed result / the reference outcome used to evaluate it. Lab 7 reads supplied predictions; it does not train a model. Here prediction 1 selects someone for support. |
| Label bias | A systematic problem in reference outcomes, such as historical decisions reflecting unequal access. A label is not automatically an unquestionable truth. |
| Proxy attribute | A field that can indirectly reveal another characteristic, such as a location correlated with group membership. Removing a group field does not necessarily remove such information. |
| Representativeness | How well the evaluated data covers the people and situations of intended use. A small balanced fixture cannot establish this for a real deployment. |
| Audit group / model feature | A grouping used to compare outcomes / an input used to make predictions. Using groups in an evaluation does not establish that the prediction system used them as inputs. |
| Bias mitigation | A change intended to reduce a specified harm. It can improve one error rate while worsening another. |
| Transparency / accountability | Explaining purpose, operation and limits / assigning decision, oversight and response responsibilities. Metric parity alone establishes neither. |

## Infrastructure and recovery

| Term | Meaning and example in this course |
| --- | --- |
| Instance / PostgreSQL cluster | A running database server / the collection of databases managed by a PostgreSQL server using a data directory. Here a cluster does not mean a group of computers. |
| Batch transfer / replication / failover | Copying data at selected times / maintaining copies through a defined replication mechanism / switching service to another system after a failure. Lab 13's manual batch transfer does not demonstrate automatic replication or failover. |
| Failure domain | Resources that can fail together. Two database instances on one laptop share that laptop as a failure domain. |
| RPO / RTO | Recovery point objective: maximum tolerable data loss expressed as time, such as 15 minutes. Recovery time objective: target time to restore service, such as one hour. Targets are not proof of achieved recovery. |
| Data residency / sovereignty | Where data is stored or processed / the jurisdictional authority and obligations that may apply. Location alone does not establish compliance. |
| TLS / CA / certificate | Transport Layer Security protects data in transit. A certificate authority (CA) signs certificates; a trusted certificate and matching server name help a client verify server identity. This does not grant SQL privileges or encrypt stored database files. |
| Credential rotation | Replacing a secret and verifying the replacement works. Rejecting an old password on new connections does not necessarily terminate already connected sessions. |

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
