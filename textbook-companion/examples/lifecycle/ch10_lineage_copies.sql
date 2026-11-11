-- Chapter 10 textbook example: dependency metadata versus copy state.
-- Run by run_all.sh in the run's private cluster, against a database that already contains the course seed (raw.*).
\set ON_ERROR_STOP on
CREATE SCHEMA staging; CREATE SCHEMA core; CREATE SCHEMA marts;

-- Staging: a view (reads current raw data when queried)
CREATE VIEW staging.stg_customers AS
  SELECT customer_id, lower(email) AS email, created_at FROM raw.customers;
CREATE VIEW staging.stg_orders AS
  SELECT order_id, customer_id, order_date::date AS order_date,
         lower(order_status) AS order_status FROM raw.orders;

-- Core: a stored table (a copy until rebuilt)
CREATE TABLE core.dim_customer AS SELECT * FROM staging.stg_customers;
-- Mart: a materialized view (a persisted result until refreshed)
CREATE MATERIALIZED VIEW marts.customer_order_summary AS
  SELECT c.customer_id, c.email, count(o.order_id) AS completed_orders
  FROM core.dim_customer c
  LEFT JOIN staging.stg_orders o
    ON o.customer_id = c.customer_id AND o.order_status = 'completed'
  GROUP BY c.customer_id, c.email;

-- Business metadata recorded inside the database
COMMENT ON COLUMN core.dim_customer.email IS
  'Customer contact email (lower-cased). Owner: Customer Data (proposed). Classification: Sensitive (case label).';

-- Listing 10.1: what the catalog knows about dependencies of the mart
SELECT DISTINCT d.refobjid::regclass AS depends_on
FROM pg_depend d
JOIN pg_rewrite r ON r.oid = d.objid
WHERE d.classid = 'pg_rewrite'::regclass
  AND d.refclassid = 'pg_class'::regclass
  AND r.ev_class = 'marts.customer_order_summary'::regclass
  AND d.refobjid <> 'marts.customer_order_summary'::regclass
ORDER BY 1;
SELECT eds_assert.expect_rows('Listing 10.1', $q$
SELECT DISTINCT d.refobjid::regclass::text AS depends_on
FROM pg_depend d JOIN pg_rewrite r ON r.oid = d.objid
WHERE d.classid = 'pg_rewrite'::regclass AND d.refclassid = 'pg_class'::regclass
  AND r.ev_class = 'marts.customer_order_summary'::regclass
  AND d.refobjid <> 'marts.customer_order_summary'::regclass$q$,
  $e$(core.dim_customer); (staging.stg_orders)$e$);

-- Business description recorded as a comment
SELECT col_description('core.dim_customer'::regclass, 2) AS email_comment;

-- An export (a file outside the database) is written by run_all.sh with:
--   COPY (SELECT customer_id, email FROM marts.customer_order_summary) TO STDOUT (FORMAT csv, HEADER)
-- redirected to a file in the run's private directory.
