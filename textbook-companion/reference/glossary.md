# Glossary

Definitions follow the textbook and appendix references. Numbered section references identify book chapters; App. identifies an appendix section.

**Acceptance criterion**. An observable condition used to decide whether a requirement has been satisfied. It identifies the result, scope, and evaluation conditions; an acceptance criterion is not evidence that the result occurred. See §§ 2.6.

**Access control**. Controls governing which identities may perform which operations on resources under specified conditions. Correct authorization requires testing permitted operations as well as intended denials. See §§ 11.3, 11.7; App. H §H.3.

**Accountability**. Answerability for a decision or outcome, supported by appropriate authority and an obligation to explain it. Accountability differs from performing a task and from possessing a technical privilege. See §§ 1.4, 9.2; App. G §G.3.

**Accountable data system**. The book's organizing concept for a data system whose requirements, decisions, controls, evidence, limitations, and review responsibilities can be explained. It is not presented as a universally standardized product category. See §§ 1.4.

**Accuracy**. The degree to which data correctly represents the relevant real-world condition or event. A value can satisfy a type or range rule while remaining inaccurate; accuracy needs an appropriate reference or verification method. See §§ 4.4.

**ACID**. Atomicity, consistency, isolation, and durability: transaction properties concerning all-or-nothing change, preservation of defined invariants, concurrent behavior, and persistence of committed results under the system's guarantees. ACID does not establish complete business correctness. See §§ 5.5.

**Additive measure**. A measure that can be summed across the relevant dimensions without changing its meaning. The applicable dimensions, grain, units, and inclusion rules must still be specified. See §§ 6.6.

**ADR (architecture decision record)**. A durable record of an architectural decision's context, alternatives, rationale, consequences, authority, and verification needs. The book uses Proposed, Accepted, Superseded, and Deprecated as distinct ADR statuses. See §§ 2.9; App. G §G.5.

**Aggregation**. Combining detailed records into summaries at a coarser grain. Aggregation can support analysis and minimization, but it does not automatically prevent inference or make data suitable for public release. See §§ 6.6, 8.8.1.

**AI governance**. Decision rights and controls governing an AI-related use across its purpose, data, evaluation, deployment, monitoring, and retirement. A favorable metric alone does not authorize the use. See §§ 17.2, 17.10.

**Anonymization**. A context-dependent process intended to prevent identification of people from data, considering reasonably available means and applicable criteria. Removing names or hashing identifiers alone does not establish anonymity. See §§ 12.7.

**Appropriateness of evidence**. The quality of evidence, including its relevance and reliability for the claim being assessed. A large amount of evidence can remain inappropriate if it addresses the wrong operation, population, or period. See §§ 15.4.

**Assumption**. A proposition used in reasoning before it has been adequately confirmed. Record its source, uncertainty, consequence if false, responsible investigator, and review trigger. See §§ 2.4.3, 18.3.1.

**Atomicity**. The transaction property that its database changes are accepted together or rolled back together. Effects outside the database transaction, such as an external payment, need separate coordination. See §§ 5.5, 5.13.

**Attribute**. A named property used to describe an entity or relationship. Its domain and business meaning should be explicit; a column's physical type alone is not its full definition. See §§ 3.2.

**Audit**. A structured assessment against defined criteria using evidence within a stated scope. An audit conclusion depends on the evidence's quality, coverage, independence, and limitations; one test is not a general certification. See §§ 15.4, 15.8; App. H §H.2; App. H §H.4; App. H §H.5.

**Authentication**. Establishing an identity's claimed credentials or other authentication factors. Successful authentication does not determine which operations that identity is authorized to perform. See §§ 11.1.1.

**Authorization**. Determining whether an identity may perform a specified operation on a resource under applicable conditions. Authorization is distinct from authentication and from business approval for a new purpose. See §§ 11.1.1, 11.10.

**Availability**. The ability of authorized users or processes to obtain a required service when needed. A reachable service may still return stale or incorrect data. See §§ 13.3.

**Backup**. A retained copy or representation intended to support restoration. Its existence does not establish recoverability, appropriate protection, independence from the original failure domain, or successful service recovery. See §§ 14.1, 14.4.

**Batch processing**. Processing a bounded collection of records or work items together. A batch's completion time does not by itself establish coverage of all expected source deliveries. See §§ 7.10.3, 16.5.

**Business continuity**. Maintaining or restoring essential business activities through disruption, including people, communications, dependencies, and temporary procedures as well as technical recovery. See §§ 14.7, 14.8.

**Business rule**. A domain obligation or restriction that constrains permissible states or actions. Its representation in a requirement or diagram must be connected to an implementation, detection method, or explicitly unresolved gap. See §§ 2.4, 5.3.

**Candidate key**. A minimal set of attributes that uniquely identifies a row under the relation's rules. A relation may have several candidate keys; choosing a primary key does not eliminate the others. See §§ 3.6; App. F §F.3; App. F §F.4.

**Cardinality**. The permitted number of related instances, expressed with minimum and maximum participation in each direction. A one-to-many label alone may leave optionality unspecified. See §§ 3.3; App. F §F.2.

**Catalog**. An organized discovery and context mechanism for data assets and their metadata. A catalog entry can describe ownership, meaning, location, lineage, and access processes without itself granting access. See §§ 10.2.1.

**Chain of custody**. A documented history of evidence collection, possession, transfer, handling, and preservation. A checksum is useful within this history but does not replace it or prove the original assertion true. See §§ 15.6.

**CHECK constraint**. A database condition that rejects a row when its expression evaluates to false. In PostgreSQL, an unknown/null result does not fail a CHECK, so required presence may need a separate NOT NULL constraint. See §§ 3.7.

**Classification**. Assigning a resource to a defined handling category based on its content, context, purpose, and potential harm. The case uses Public, Internal, Sensitive, and Restricted; a label is not a technical control. See §§ 8.3, 8.6; App. G §G.4.

**Column lineage**. A description of how particular output columns depend on source columns or transformations. Its granularity differs from dataset-level lineage and does not automatically reveal every record's history. See §§ 10.3.1.

**Completeness**. The presence of required records or values within a defined population and scope. Non-null checks on received rows cannot establish that every expected source record was delivered. See §§ 4.4, 7.10.3.

**Concept drift**. A change in the relationship between inputs and the outcome of interest. It differs from a change in input distribution and may be hard to assess when outcomes arrive late or selectively. See §§ 17.10.

**Concurrency**. Overlapping work by multiple transactions or processes. Correctness requires attention to isolation, locks, conflicts, and retry behavior rather than assuming that individually correct statements remain correct together. See §§ 5.7.

**Conformed dimension**. A dimension defined consistently enough to support comparison or integration across relevant fact tables. A shared name or similar column structure alone does not establish conformance. See §§ 6.8.

**Consistency**. Agreement among representations or with defined rules under a stated context. Data-quality consistency differs from ACID consistency, which concerns transaction preservation of specified invariants. See §§ 4.4, 5.5.

**Constraint**. An explicit restriction on a design or permissible data state. A database constraint enforces specified conditions; requirements may also include organizational or platform constraints requiring other forms of verification. See §§ 2.4.3, 3.7; App. A §A.4; App. F §F.3.

**Control**. An activity or mechanism intended to manage a risk or meet an objective. Distinguish its design, implementation, and observed operation; a policy statement is not evidence that a control operated. See §§ 1.4.2, 15.3.

**Control objective**. The result a control is intended to achieve in relation to a requirement or risk. The objective should be distinct from the specific activity selected to achieve it. See §§ 15.2.

**Copy inventory**. A record of relevant copies, exports, backups, archives, and derived artifacts, including their locations, purposes, responsibilities, and lifecycle states. Dependency lineage alone does not provide this inventory. See §§ 10.7.

**Custodian**. A role responsible for technical care or operation of a resource under delegated authority. Custody does not automatically confer business authority to approve new uses, retention, or disclosure. See §§ 9.2.1.

**Data contract**. An agreed description of data expectations at a boundary, such as schema, meaning, grain, delivery, quality, ownership, and change handling. Its effectiveness depends on enforcement, detection, and response arrangements. See §§ 7.2, 7.9.

**Data dictionary**. A structured description of data elements, including their definitions, types, domains, and relevant rules. A dictionary is narrower than an enterprise catalog's broader discovery and governance functions. See §§ 10.2.1.

**Data lineage**. The relationships by which data is derived or transformed from sources to outputs. A declared dependency graph is evidence of those declarations, not necessarily complete runtime or copy history. See §§ 10.3.

**Data minimization**. Limiting collection, use, detail, access, and retention to what is justified for the specified purpose. Minimization is contextual and is not achieved merely by removing one identifying column. See §§ 12.4.

**Data product**. A maintained data output with an intended consumer, defined meaning and quality expectations, ownership, and change arrangements. A table or dashboard does not become a reliable product merely by being named one. See §§ 7.9, 16.10.

**Data quality**. The degree to which data is fit for a specified use, assessed through relevant dimensions and consequences. Integrity constraints address some conditions but do not establish all accuracy or suitability. See §§ 4.2, 4.3.

**Data warehouse**. An analytical data environment organized to support integrated reporting and analysis. Its usefulness depends on agreed meaning, grain, history, transformation and governance, not merely central storage. See §§ 6.2, 16.3.

**Database**. An organized collection of data managed for defined uses. It is one component of a data system, which also includes applications, processes, people, and dependencies. See §§ 1.3.

**DataOps**. Coordinated practices for developing, testing, releasing, observing, and revising data-related changes. Automation supports these practices but does not supply missing requirements, representative tests, or accountable approval. See §§ 16.9.

**DBMS (database management system)**. Software that manages database definition, storage, retrieval, updates, concurrency, and related controls. DBMS features require configuration and use consistent with the system's requirements. See §§ 1.3.

**dbt**. A transformation toolset that connects SQL models, dependency declarations, data tests, and documentation. In this book, dbt models are transformation resources, not machine-learning models or complete enterprise architecture models. See §§ 7.5, 10.3.3; App. D §D.1; App. D §D.3; App. D §D.6.

**De-identification**. Changing data to reduce identification risk. Its effectiveness depends on context, remaining attributes, linkage opportunities, and release conditions; it is not automatically equivalent to anonymization. See §§ 12.7.

**Deadlock**. A cycle of waiting in which transactions hold resources needed by one another. PostgreSQL can detect a deadlock and abort a transaction; the application still needs appropriate retry or failure handling. See §§ 5.11.

**Deletion ledger**. A record of deletion decisions or events used to support consistent removal, including after restoration. It helps address the risk that restored backups reintroduce previously deleted records. See §§ 10.9.3.

**Denormalization**. Deliberately introducing redundancy or combining structures for a justified purpose. It requires explicit consistency, update, and verification arrangements rather than an assumption that redundancy is harmless. See §§ 3.9.

**Design effectiveness**. Whether a control, if implemented and operated as intended, is capable of achieving its objective. This assessment is separate from whether it was actually deployed or worked over a period. See §§ 15.3.

**Dimension**. Descriptive context used to analyze facts, such as product, customer, or date. Historical dimension versions and business entity identities must be distinguished when assigning facts. See §§ 6.5, 6.11.

**Dimensional modeling**. Designing analytical structures around declared fact grain, measures, dimensions, and historical interpretation. It supports analysis but does not remove the need for reconciliation and source-quality assessment. See §§ 6.3, 6.5; App. F §F.5.

**Durability**. The property that committed transaction results persist under the system's specified guarantees. It does not replace backup, independent recovery, or a tested business-continuity plan. See §§ 5.5, 14.1.

**ELT**. Extract, load, transform: an arrangement that loads extracted data before performing the relevant transformations in the target processing environment. Loading raw data does not exempt it from governance or protection. See §§ 7.3, 7.16.

**ETL**. Extract, transform, load: an arrangement that performs the relevant transformations before loading the target. The label alone does not establish quality, lineage, reliability, or an appropriate architecture. See §§ 7.3.

**Evidence**. Information used to assess a claim. Its value depends on source, method, relevance, reliability, scope, and limitations; an expected result or proposed design is not an observed outcome. The book distinguishes external sources, authored material, inspected artifacts, observations, simulations, inferences and proposals; Appendix H defines their evidence codes. See §§ 1.4.1, 15.4; App. H §H.1; App. H §H.2; App. H §H.8.

**Evidence classification**. The book’s labels for the origin and status of support, including EXT-PRI, AUTH, AUTH-OBS and the R-prefixed repository categories. They distinguish kinds of support rather than rank credibility; use them with provenance and scope. See App. H §H.1.

**Fact table**. A table recording events or measurements at a declared grain. Join and aggregation rules must preserve that grain; an order-level amount can be duplicated when joined to multiple lines. See §§ 6.3, 6.5.

**Failure domain**. A set of components that may be affected by a common failure. Copies on the same host or under the same compromised credentials may not provide the independence required by a recovery objective. See §§ 14.4, 16.6.

**False-negative rate (FNR)**. The fraction of actual positive cases classified negative: FN/(TP + FN). State the positive outcome, group, population, and denominator; the rate is undefined when there are no actual positives. See §§ 17.8.1.

**False-positive rate (FPR)**. The fraction of actual negative cases classified positive: FP/(FP + TN). A reduction in one error rate can accompany an increase in another; examine the decision context and affected people. See §§ 17.8.1.

**Foreign key**. A constraint requiring referencing values to match an allowed key in the referenced relation, subject to its null and match rules. It does not automatically enforce minimum child counts or create a referencing-column index. See §§ 3.6, 3.7; App. A §A.4; App. F §F.2.

**Freshness**. How current data is relative to the required event, delivery, or availability time. A recent successful job is not proof that all expected recent source events were included. See §§ 7.7, 13.3.

**Functional dependency**. A rule that equal values of one attribute set imply equal values of another within a relation. Dependencies are semantic claims used in key and normalization reasoning, not causal relationships. See §§ 3.8.

**Governance**. Decision rights, responsibilities, policies, and review arrangements for directing and overseeing data-related choices. Governance must connect to operational work and evidence rather than remaining an organizational chart. See §§ 9.2, 9.7.

**Grain**. The precise meaning of one row in a dataset or model. Grain determines appropriate keys, joins, and aggregations and should be stated before choosing analytical measures. See §§ 3.4, 6.3; App. A §A.3; App. F §F.5.

**Hash**. A value computed from input by a specified algorithm. A cryptographic hash can support integrity comparison, but stable hashes of identifiers can preserve linkage and do not automatically anonymize people. See §§ 8.8.2, 15.6; App. B §B.2; App. H §H.7.

**High availability**. An architectural objective or arrangement intended to sustain service through specified failures. Redundancy and replication do not automatically provide protected historical recovery or complete business continuity. See §§ 14.6.

**Idempotency**. The property that repeating an operation under defined conditions has the same intended final effect as performing it once. Delivery identifiers, event identities, and deduplication boundaries must be specified. See §§ 7.10.1.

**Incident**. An event or situation assessed as requiring coordinated response because of its effect or risk. An anomalous signal or failed login does not by itself establish malicious activity. See §§ 13.5, 13.11.

**Index (database)**. An access structure that can support particular queries or constraints. Its benefit depends on workload and plan choices, and it carries storage and update costs. It is distinct from the book's subject index. See §§ 5.12, 13.12.

**Input drift**. A change in the distribution or characteristics of inputs relative to a reference population or period. It does not necessarily imply a changed relationship between inputs and outcomes. See §§ 17.10.

**Integrity**. Conformance to defined structural and business rules for permissible data states or changes. Integrity differs from factual accuracy and from fitness for a particular use. See §§ 3.13, 4.2.

**Isolation**. The transaction property governing what concurrent transactions can observe and how their operations interact. The chosen isolation level affects permitted anomalies and application handling requirements. See §§ 5.8, 5.9.

**Join fan-out**. Multiplication of rows when a row matches multiple rows in a joined relation. It can repeat a parent-level measure and produce an analytically incorrect total despite syntactically valid SQL. See §§ 6.4; App. A §A.3.

**Lakehouse**. An architectural approach combining data-lake storage with additional table-management and analytical capabilities. Specific guarantees depend on the implemented components, configuration, and operations. See §§ 16.4.

**Least privilege**. Granting only the permissions needed for a defined task and period. The principle requires checking effective privileges and changes over time, not merely minimizing the number of named roles. See §§ 11.3.

**Legal hold**. An authorized suspension of ordinary disposal for a defined scope because preservation is required. Record the authority, affected copies, start, review, and release conditions rather than treating every retention request as a hold. See §§ 10.8.2.

**Lifecycle**. The states and activities through which data and its copies pass, including creation, use, transformation, sharing, retention, and disposal. Different copies may occupy different states simultaneously. See §§ 1.8, 10.6.

**Logical deletion**. Removal from the application's or database's visible logical state. It does not necessarily erase physical remnants, backups, exports, replicas, or other retained copies. See §§ 10.9.1.

**Materialization**. The way a transformation result is represented or maintained, such as a view or table in dbt. Materialization choice affects execution and persistence but does not itself establish quality or approval. See §§ 7.5.

**Metadata**. Data describing the meaning, structure, origin, operation, or management of other data. Technical, business, and operational metadata answer different questions and need maintenance and accountability. See §§ 10.1.

**Metric**. A defined quantitative measure with a population, grain, units, time basis, inclusion rules, and intended interpretation. A familiar label such as “active customer” is not a complete specification. See §§ 9.6.1, 9.10.1.

**Model leakage**. Use of information in model development or evaluation that would not legitimately be available at the intended decision time or evaluation boundary. Time-aware provenance is essential to detect it. See §§ 17.3.1, 17.6.

**Natural key**. An identifier based on attributes meaningful in the domain. Its stability, uniqueness, scope, and change rules must be assessed rather than assumed. See §§ 3.6.

**Normalization**. Organizing relations according to dependencies to reduce specified redundancy and update, insertion, or deletion anomalies. Normalization does not guarantee accurate records or enforce every business rule. See §§ 3.8; App. F §F.4.

**Null**. A marker for missing or otherwise unspecified information under the schema's interpretation. SQL comparisons involving null can produce unknown; null is not automatically zero, false, or an empty string. See §§ 3.7, 4.5.

**OLAP**. Online analytical processing: analytical work concerned with summaries, comparisons, trends, and related decision support. It often uses structures and workload choices different from operational transaction processing. See §§ 1.6, 6.2.

**OLTP**. Online transaction processing: operational work recording and changing business events or states. Correctness, concurrency, latency requirements, and transaction boundaries depend on the workload. See §§ 1.6, 5.2.

**Operating effectiveness**. Whether a control operated as intended over the relevant population and period. A point-in-time configuration inspection or one successful test cannot alone establish this broader conclusion. See §§ 15.3, 15.5.

**Optionality**. Whether participation in a relationship may be absent. In a cardinality expression, optionality is reflected in a minimum of zero rather than one. See §§ 3.3.

**Owner (business)**. The role with defined business authority and accountability for decisions about a resource or domain. It differs from a technical object owner, steward, and custodian. See §§ 9.2.1, 11.2.

**Pipeline**. A connected sequence of data movement and transformation activities. Successful execution of selected steps does not by itself establish complete delivery, correct meaning, or safe downstream publication. See §§ 7.4, 7.10.

**Point-in-time recovery (PITR)**. Restoring a database to a selected recovery point using an appropriate base backup and required transaction-log history. Availability of the complete recovery chain and tested procedures matters. See §§ 14.5.

**Policy**. An authoritative statement directing decisions or behavior. Standards, procedures, and controls translate policy into more specific requirements and activities; the written statement is not proof of compliance. See §§ 9.4.

**Population (evidence)**. The full set of objects or events relevant to an assessment's defined scope. A sample can support conclusions only with a defensible selection method and explicit coverage limitations. See §§ 15.5.

**PostgreSQL**. The relational database management system used for the book's technical examples. Its role system, constraints, transactions, and administrative tools operate within specified versions and configurations. See §§ 5.9, 11.5; App. A §A.4; App. E §E.6.

**Primary key**. The candidate key selected to identify rows and enforced as unique and non-null. A primary key does not independently prove correct real-world entity resolution. See §§ 3.6.

**Privacy**. The appropriate treatment of information about people in its collection, use, sharing, and retention context. Privacy concerns can arise even when access is authorized and confidentiality controls work. See §§ 12.1, 12.6.

**Provenance**. Information about the origins and history of data or evidence, including relevant entities, activities, agents, and transformations. Provenance helps interpretation; it does not itself authorize a use. See §§ 10.4; App. H §H.1; App. H §H.7.

**Pseudonymization**. Replacing direct identifiers with substitutes while a relationship or means of re-identification may remain. Pseudonymized data can remain linkable or identifiable in context. See §§ 12.7.

**Purpose limitation**. Restricting use of data to specified, justified purposes and reviewing proposed changes. An existing permission or technical capability does not automatically authorize a new use. See §§ 12.3, 12.6.

**Quality gate**. A decision point that permits, blocks, or conditions further processing or publication based on stated checks. Define its coverage, failure handling, authority, and bypass conditions. See §§ 7.6, 7.10.4.

**RACI**. A responsibility matrix identifying Responsible, Accountable, Consulted, and Informed roles for a decision or activity. Define its conventions locally and connect it to actual authority and escalation. See §§ 9.11.

**RBAC (role-based access control)**. An access-control approach assigning permissions to roles and associating identities with those roles. Role membership and effective privileges require review; a role name alone does not establish appropriate access. See §§ 11.4.

**Reconciliation**. Comparing independently specified representations or totals under a common scope and explaining differences. Agreement supports the tested comparison but may conceal offsetting errors or shared source defects. See §§ 4.11, 6.12; App. A §A.3; App. H §H.4.

**Recovery**. Restoring the required service and data after disruption to an accepted state. Recovery includes validation and dependencies beyond simply copying files or starting a database. See §§ 14.1, 14.9; App. H §H.6.

**Reference observation**. An attributed result supplied from a specified earlier run. It can support a bounded comparison but is not evidence that the current reader executed the activity. See App. D §D.6; App. H §H.1; App. H §H.8.

**Referential integrity**. Consistency of references between relations as defined by foreign-key or equivalent rules. A periodically executed relationships test detects violations at test time but is not necessarily write-time enforcement. See §§ 3.7, 3.12.

**Release manifest**. A record identifying the files and hashes in a prepared companion edition. It supports comparison of content; it does not by itself demonstrate execution, publication or correctness. See App. C §C.5; App. H §H.1.

**Replication**. Maintaining another representation of data through propagation of changes. Replication can reproduce unwanted deletion or corruption and therefore is not a substitute for an appropriate backup strategy. See §§ 14.6.

**Requirement**. An agreed or proposed obligation, capability, property, or constraint with an identifiable source and acceptance conditions. Record its agreement status separately from implementation and verification status. See §§ 2.4, 2.10; App. G §G.2.

**Requirement-to-Evidence Trace**. The book's chain connecting stakeholder evidence, requirements, an ADR, implementation/control, evidence, limitations, and review/revision. Its purpose is to make the reasoning and its gaps inspectable. See §§ 2.7, 18.8; App. G §G.6.

**Retention schedule**. An authorized specification of what is retained, for how long, from which trigger, and under which authority and exceptions. It should address copies, holds, disposal, and verification. See §§ 10.8.1.

**Row-level security (RLS)**. Database policies restricting row access for applicable operations and roles. PostgreSQL bypass behavior depends on privilege and ownership conditions; a policy's existence does not establish effective coverage. See §§ 11.5.4.

**RPO (recovery point objective)**. The acceptable amount of data loss expressed as a time interval. It is an objective requiring an agreed reference point and evidence; a backup frequency is not automatic proof of achievement. See §§ 14.2.1; App. H §H.6.

**RTO (recovery time objective)**. The target time to restore the required service after a defined interruption. State what starts the clock and what constitutes usable recovery, including dependencies and acceptance. See §§ 14.2.2; App. H §H.6.

**Schema**. A defined structure of data, or in PostgreSQL a namespace containing database objects. Clarify the intended meaning; a schema name alone does not establish a security boundary. See §§ 3.5, 11.5.

**Selection rate**. The proportion of a defined population receiving a positive decision. It differs from error rates, which use actual positive or actual negative cases as denominators. See §§ 17.8.1.

**Semi-additive measure**. A measure that can be summed across some relevant dimensions but not others. A balance may be summed across accounts while requiring a different rule across successive dates. See §§ 6.6.

**Separation of duties**. Distributing incompatible activities or authorities to reduce inappropriate unilateral action. Distinct role names are insufficient if the same person or account can exercise all conflicting powers. See §§ 11.6.

**Slowly changing dimension (SCD)**. A method for handling changes in descriptive dimension attributes. Type 1 overwrites selected values; Type 2 preserves versions with explicit assignment and validity rules. State whether interval endpoints are inclusive or exclusive; conventions differ between examples. See §§ 6.11; App. F §F.5.

**SQL (Structured Query Language)**. A language for defining and working with relational data, including queries and changes. Valid syntax does not establish correct grain, complete populations, appropriate permissions, or a sound business interpretation. See §§ 3.11, 6.4; App. A §A.1; App. A §A.3; App. A §A.6.

**SQLSTATE**. A five-character code identifying a SQL outcome or error class and condition. It helps distinguish an intended authorization denial from unrelated failures such as missing objects or invalid syntax. See §§ 11.1.2, 11.7.2; App. A §A.4; App. E §E.5; App. H §H.3.

**Stakeholder**. A person or group affected by, influencing, or having an interest in a system or decision. Stakeholder interest and relevant knowledge do not automatically establish decision authority. See §§ 2.2.

**Star schema**. A dimensional structure with a fact table linked to descriptive dimensions. Correct interpretation still requires declared grain, key rules, measure semantics, and historical treatment. See §§ 6.7.

**Stewardship**. Ongoing work that maintains data definitions, quality, handling practices, and issue resolution under assigned authority. Stewardship requires routines, escalation, and succession rather than a title alone. See §§ 9.7; App. G §G.3.

**Sufficiency of evidence**. The amount of evidence needed to support a conclusion given its scope and risk. Quantity and quality interact; additional weak or irrelevant evidence does not necessarily strengthen the conclusion. See §§ 15.4.

**Surrogate key**. An introduced identifier without the same business meaning as a natural key. It can identify a dimension version or row while separate rules preserve business uniqueness and correct relationships. See §§ 3.6, 6.10.

**System boundary**. The stated scope of components, actors, and interfaces treated as part of a system. Claims and responsibilities should identify what lies inside, outside, and across that boundary. See §§ 1.7.

**Textbook companion**. The optional reader activities, executable examples, references and supplied evidence in the repository-root textbook-companion folder. It complements the book and existing labs without changing their numbering or assessment requirements. See App. E §E.6; App. G §G.8; App. H §H.8.

**Timeliness**. The degree to which data is available at the time required for its intended use. Define the relevant deadline and event or delivery basis rather than treating a recent processing timestamp as sufficient. See §§ 4.4, 4.8.

**Traceability**. The ability to follow relationships among requirements, decisions, implementation, evidence, and changes. It is broader than data lineage and supports both forward impact analysis and backward explanation. See §§ 2.7, 10.3.4.

**Transaction**. A unit of database work with a defined boundary for commit or rollback. Correct transaction design also requires appropriate invariants, isolation, error handling, and coordination with external effects. See §§ 5.4; App. A §A.4.

**Trust boundary**. A boundary across which authority, identity assumptions, or control expectations change. Crossing it requires explicit treatment of authentication, authorization, validation, and responsibility. See §§ 1.7.

**Uniqueness**. The absence of duplicates under a defined identity rule and scope. A unique technical row identifier does not establish that two rows do not refer to the same real-world entity. See §§ 4.4, 4.6.

**Validity (data quality)**. Conformance to specified formats, domains, ranges, or rules. A valid value can still be factually inaccurate or unsuitable for the intended decision. See §§ 4.4.

**View**. A named query presenting data from underlying relations. Its privilege behavior and exposed columns require inspection; a view is not inherently a safe disclosure mechanism. See §§ 11.5.2.

**Warrant**. The reasoning linking evidence to a claim. Making the warrant explicit reveals assumptions and helps a reader judge whether the conclusion exceeds the observation. See §§ 1.4.1.

**Write-ahead log (WAL)**. A transaction-log mechanism used by PostgreSQL for recovery and related replication capabilities. Its presence alone does not provide a complete, protected, tested recovery chain. See §§ 14.5.

