# Appendix A
# SQL and PostgreSQL Essentials

This appendix supports Chapters 3, 5, 6, 11, and 13. It is a compact reference for interpreting SQL and checking small examples, not a substitute for the course installation instructions. Use Appendix E to prepare the course environment. The examples below use PostgreSQL 16 syntax and deliberately small, synthetic data.

## A.1 Know which interpreter receives a command

SQL statements run in a database session. Bash commands run in an operating-system shell. Commands beginning with a backslash, such as `\conninfo`, are instructions to the PostgreSQL `psql` client; they are not SQL. Do not paste shell commands into a SQL editor or send `psql` commands through the course Python query client.

Before interpreting a result, establish the connection and identities. Run this SQL in the intended practice database:

```sql
SELECT current_database() AS database_name,
       session_user AS login_role,
       current_user AS effective_role,
       current_schema() AS first_schema;
```

The result identifies the database, authenticated session role, effective role, and first existing schema in the search path. These may differ from the operating-system account. A database role name does not establish business ownership or authority. In `psql`, `\conninfo` provides additional connection information; do not publish credentials or sensitive host details.

## A.2 Read a query in terms of rows and meaning

| Construct | Question to ask | Common mistake |
| --- | --- | --- |
| SELECT | Which values should each output row contain? | Assuming column selection changes the underlying grain. |
| FROM / JOIN | What does one input row represent, and how many matches are possible? | Repeating a parent amount across several child rows. |
| WHERE | Which individual rows qualify? | Using `= NULL` instead of `IS NULL`. |
| GROUP BY / HAVING | What defines one group, and which groups qualify? | Mixing row-level and aggregate conditions. |
| ORDER BY | What ordering is required? | Assuming storage order is a guaranteed result order. |

SQL normally preserves duplicates unless the query removes them. `COUNT(*)` counts rows; `COUNT(column_name)` counts non-null values of that expression. A missing value is not automatically zero, an empty string, or “not applicable.” Choose a treatment that matches the business meaning. `COALESCE` can replace a null for a calculation, but it does not recover a missing observation.

## A.3 A complete, reversible practice example

Use a disposable practice database in which your role may create temporary tables. Run the following blocks in order in the same session. They create session-local tables inside a transaction; the final rollback removes the exercise. The amounts are illustrative units, not the repository's retail fixture.

```sql
BEGIN;
CREATE TEMP TABLE example_orders (
    order_id integer PRIMARY KEY,
    order_status text NOT NULL
        CHECK (order_status IN ('completed', 'cancelled')),
    total_amount numeric(12,2) NOT NULL
        CHECK (total_amount >= 0)
);
CREATE TEMP TABLE example_lines (
    order_id integer REFERENCES example_orders(order_id),
    line_no integer,
    quantity integer NOT NULL CHECK (quantity > 0),
    unit_price numeric(12,2) NOT NULL CHECK (unit_price >= 0),
    PRIMARY KEY (order_id, line_no)
);
INSERT INTO example_orders VALUES
    (1, 'completed', 25.00),
    (2, 'completed', 15.00),
    (3, 'cancelled', 8.00);
INSERT INTO example_lines VALUES
    (1, 1, 2, 10.00), (1, 2, 1, 5.00),
    (2, 1, 1, 15.00), (3, 1, 1, 8.00);
```

The header grain is one row per order. The line grain is one row per order and line number. The composite primary key makes both key columns non-null. The foreign key rejects a line referring to a nonexistent order; it does not require every order to have a line.

Compare three calculations:

```sql
SELECT SUM(total_amount) AS header_total
FROM example_orders
WHERE order_status = 'completed';

SELECT SUM(o.total_amount) AS repeated_header_total
FROM example_orders AS o
JOIN example_lines AS l USING (order_id)
WHERE o.order_status = 'completed';

SELECT SUM(l.quantity * l.unit_price) AS line_total
FROM example_orders AS o
JOIN example_lines AS l USING (order_id)
WHERE o.order_status = 'completed';
```

Expected results are 40.00, 65.00, and 40.00, respectively. The middle query repeats order 1's header amount because that order has two lines. It is valid SQL with the wrong analytical meaning. `SUM(DISTINCT total_amount)` is not a general repair: two different orders can legitimately have the same amount. Chapter 6 applies the same reasoning to the repository's separate 139.95 completed-sales fixture.

To expose missing children as well as unequal totals, start from headers and retain unmatched orders:

```sql
SELECT o.order_id, o.total_amount,
       COUNT(l.line_no) AS line_count,
       SUM(l.quantity * l.unit_price) AS line_total
FROM example_orders AS o
LEFT JOIN example_lines AS l USING (order_id)
WHERE o.order_status = 'completed'
GROUP BY o.order_id, o.total_amount
HAVING COUNT(l.line_no) = 0
    OR o.total_amount <> SUM(l.quantity * l.unit_price);
```

Expected result: no rows for this fixture. That supports agreement between these headers and lines under this query. It does not establish accurate prices, complete source delivery, correct currency treatment, or absence of offsetting errors. Finish the exercise:

```sql
ROLLBACK;
```

## A.4 Constraints, transactions, and failures

| Mechanism | What it contributes | Boundary |
| --- | --- | --- |
| PRIMARY KEY | Unique, non-null row identifier. | Does not establish real-world identity. |
| FOREIGN KEY | Referenced-key existence, subject to null and match rules. | Does not enforce every cross-row business rule. |
| NOT NULL | Rejects null in a column. | Does not reject an empty string or inaccurate value. |
| CHECK | Rejects a row when its expression is false. | An unknown/null result passes; combine with NOT NULL where required. |
| UNIQUE | Enforces uniqueness under its defined null treatment. | PostgreSQL ordinarily permits multiple nulls; choose semantics deliberately. |

`BEGIN` starts a transaction; `COMMIT` accepts its changes; `ROLLBACK` discards them. After an error inside a PostgreSQL transaction, subsequent work is normally rejected until rollback or rollback to an appropriate savepoint. Do not continue interpreting later messages as independent tests of the original operation. PostgreSQL sequences can advance despite rollback, so gaps are not proof of deleted rows.

Record SQLSTATE alongside the message. Examples include `23505` (unique violation), `23503` (foreign-key violation), `23514` (check violation), and `42501` (insufficient privilege). A permission test that instead fails because an object does not exist has not demonstrated the intended access restriction.

## A.5 Use the course client and plans appropriately

The repository's `scripts/query.py` reads a SQL file and uses the course connection configuration. From the repository root, after setup, its invocation has this form:

```bash
.venv/bin/python scripts/query.py path/to/query.sql --role owner
```

Replace the illustrative path with your own file. The supported role options are `owner`, `analyst`, and `steward`. The client substitutes `{{schema}}` in course SQL; ordinary PostgreSQL does not understand that placeholder. Prefer one result-producing statement per evidence file so the recorded output has a clear relationship to the claim.

`EXPLAIN` describes a plan and estimates. `EXPLAIN ANALYZE` executes the statement and reports observations. It can perform writes or invoke functions with effects. Do not use it casually on production statements. Performance conclusions require a defined workload, repeated measurements, environment details, and a comparison—not the mere presence of an index or a small estimated cost.

## A.6 Related companion examples

The optional book examples are in `textbook-companion/` at the repository root. Start with `textbook-companion/README.md` and follow its setup instructions before selecting `foundations` for relational integrity or `transactions` for atomicity, controlled concurrency and analytical grain. Use the companion launcher; do not send its low-level scripts to the course database.

Keep each fixture's population and expected result separate. This appendix's temporary-table exercise yields 40.00, 65.00 and 40.00. The course completed-sales example yields 139.95 and a deliberately incorrect 219.93 header join. The lifecycle suite's generated recovery fixture has a separate completed-order total of 45,700.00. Different amounts do not imply a contradiction when the datasets and claims differ.

## A.7 Sources and further reading

PostgreSQL Global Development Group. (n.d.). PostgreSQL 16 documentation: Tutorial; constraints; transactions; aggregate functions; EXPLAIN. https://www.postgresql.org/docs/16/tutorial.html ; https://www.postgresql.org/docs/16/ddl-constraints.html ; https://www.postgresql.org/docs/16/tutorial-transactions.html ; https://www.postgresql.org/docs/16/functions-aggregate.html ; https://www.postgresql.org/docs/16/sql-explain.html

Nti, I. K. (2026). IT4065C-Labs: Data Technologies Administration [Software and instructional materials]. https://doi.org/10.5281/zenodo.24046602 . Repository: https://github.com/ntious/IT4065C-Labs . Repository-specific instructions were checked against commit d860dd98256a8090ffc6bd3766c59cb15a553c12.
