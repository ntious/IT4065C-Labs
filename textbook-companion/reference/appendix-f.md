# Appendix F
# Data Modeling Notation

This appendix is a reading key for Chapters 3 and 6 and the model-to-evidence trace in Chapter 18. A diagram expresses selected design claims. Its notation must make the grain, keys, relationship direction, and optionality explicit; an attractive diagram is not evidence that the database enforces those claims.

## F.1 Distinguish model levels

| Level | Main question | Typical content |
| --- | --- | --- |
| Conceptual | What things and relationships matter to the organization? | Customer, Order, Product, and business meanings. |
| Logical | How are attributes, keys, and relationships organized? | Relations, candidate keys, foreign keys, cardinality, and dependencies. |
| Physical | How is the design implemented on a platform? | PostgreSQL types, constraints, indexes, schemas, and storage choices. |

A conceptual entity is not automatically a table, and a table name does not define its grain. State “one row per …” before discussing joins or measures. For an order line, specify whether identity is `(order_id, line_no)` or a separately assigned line identifier and what uniqueness rule still applies.

## F.2 Read minimum and maximum cardinality

Use the following textual notation when a diagram's symbols may be unfamiliar or hard to reproduce in monochrome:

| Notation | Meaning for one instance at the other end |
| --- | --- |
| `0..1` | Zero or one related instance. |
| `1` or `1..1` | Exactly one related instance. |
| `0..*` | Zero, one, or many related instances. |
| `1..*` | One or more related instances. |

Read every relationship in both directions. “A customer may place zero or many orders” does not answer whether an order may have no customer. If the case requires every order to identify exactly one customer, record that second rule separately. In Crow's Foot notation, a circle expresses zero, a bar expresses one, and a crow's foot expresses many; include a legend and verify the convention used by the drawing tool.

A non-null foreign key from Order to Customer can enforce that each stored order refers to an existing customer. It does not force any customer to place an order. Likewise, an OrderLine foreign key cannot alone enforce a rule that every completed order has at least one line. Minimum-child requirements may need transaction logic or another carefully designed control.

## F.3 Read key and constraint labels

| Label | Meaning | Editorial check |
| --- | --- | --- |
| PK | Primary key: the chosen candidate key. | Composite keys must list every participating column. |
| CK | Candidate key: a minimal attribute set uniquely identifying a row. | State the meaning; CK can mean “check constraint” in some tools. |
| UQ | Uniqueness constraint. | Specify null semantics and all participating columns. |
| FK | Foreign key referencing a permitted key. | Show the referenced relation and matching columns. |
| NN | Not null. | Distinguish presence from valid or accurate content. |

A natural key derives from domain attributes; a surrogate key is introduced as an identifier. Neither choice removes the need to enforce appropriate business uniqueness. A generated identity value is not, by itself, a uniqueness constraint. A foreign key also does not automatically create an index on its referencing columns in PostgreSQL.

A many-to-many relationship is commonly represented through an associative relation. For example, OrderLine connects orders and products while holding quantity and price at sale. If the same product may occur on more than one line of an order, `(order_id, product_id)` is not automatically the correct key. Derive the key from the requirement, not the visual pattern.

## F.4 Interpret functional dependencies and normal forms

The notation `X → Y` means that equal values of attribute set X imply equal values of attribute set Y within the relation under the stated rules. X is a determinant. This is a semantic constraint, not a causal arrow or a claim inferred conclusively from a small sample.

| Form | Practical reading | Question for the reviewer |
| --- | --- | --- |
| First normal form (1NF) | Values conform to the relation's defined domains; repeating groups are not stored as separate numbered slots. | Is a single column being used to conceal a repeating collection that needs its own relation? |
| Second normal form (2NF) | In 1NF, with every non-prime attribute fully dependent on every candidate key. | Does an attribute depend on only part of a composite candidate key? |
| Third normal form (3NF) | For each nontrivial dependency X → A, X is a superkey or A is prime. | Are facts about different determinants mixed in a way that creates avoidable anomalies? |

A prime attribute belongs to at least one candidate key; a superkey uniquely identifies a row but need not be minimal. “Depends on the key, the whole key, and nothing but the key” is a useful teaching aid, not a substitute for checking all candidate keys and dependencies. Normalization reduces particular redundancy and anomaly risks; it does not guarantee accurate data or complete business controls.

## F.5 Read dimensional models at the declared grain

A fact table records measurements or events at a declared grain. Dimensions provide descriptive context. In a star schema, a fact table joins to its surrounding dimensions; a snowflake design further normalizes dimension structures. A diagram should name the fact grain and show the dimension keys, not merely arrange boxes around a center.

An additive measure can be summed across the relevant dimensions; a semi-additive measure can be summed across some but not all, such as a balance across accounts but not successive dates. A non-additive measure, such as a ratio, usually requires recomputation from appropriate components. These properties depend on the measure's definition and scope.

For a Type 2 slowly changing dimension, distinguish the business entity identifier from the dimension-version key. Define validity intervals and the rule assigning each fact to a version. With half-open intervals, a timestamp is included at `valid_from` and excluded at `valid_to`; adjacent versions then need not overlap. A surrogate key alone does not prevent overlapping intervals or establish historically correct assignment.

Interval notation is an example-specific contract. Chapter 7's day-granularity historical lookup uses inclusive endpoints; the approval-event example uses an inclusive start and exclusive end. Both require an explicit rule for the relevant domain. Do not copy one boundary convention into another example without changing and verifying the intended meaning. The companion reasoning suite checks selected missing, overlapping and boundary cases; it does not certify every possible temporal design.

## F.6 Modeling review checklist

Read the model alongside its requirements and SQL. Confirm the row meaning, candidate keys, minimum/maximum cardinality in both directions, nullable attributes, deletion behavior, and the location of each business rule. For an analytical model, also confirm measure units, aggregation rules, historical treatment, and reconciliation boundaries. Mark each rule as enforced, detected, proposed, or untested with evidence; do not infer implementation from notation.

## F.7 Sources and further reading

See Chapters 3 and 6 for the full modeling argument and references; Chapter 18 explains its connection to implementation evidence.

PostgreSQL Global Development Group. (n.d.). PostgreSQL 16 documentation: Constraints. https://www.postgresql.org/docs/16/ddl-constraints.html
