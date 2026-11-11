\set ON_ERROR_STOP on
-- Listing 10.2: an approved deletion is recorded, then applied to the source only
CREATE TABLE IF NOT EXISTS raw.deletion_ledger (
  subject_ref text PRIMARY KEY, approved_on date NOT NULL, authority text NOT NULL);
INSERT INTO raw.deletion_ledger VALUES ('customer:3', DATE '2026-02-01', 'Customer Data owner (case role)');
DELETE FROM raw.customers WHERE customer_id = 3;

-- Listing 10.3: where does customer 3 still appear?
SELECT 'staging.stg_customers (view)' AS object, count(*) AS rows_for_customer_3
  FROM staging.stg_customers WHERE customer_id = 3
UNION ALL SELECT 'core.dim_customer (table)', count(*) FROM core.dim_customer WHERE customer_id = 3
UNION ALL SELECT 'marts.customer_order_summary (matview)', count(*) FROM marts.customer_order_summary WHERE customer_id = 3;
SELECT eds_assert.expect_rows('Listing 10.2 copies', $q$
SELECT 'view' AS obj, count(*) FROM staging.stg_customers WHERE customer_id = 3
UNION ALL SELECT 'table', count(*) FROM core.dim_customer WHERE customer_id = 3
UNION ALL SELECT 'matview', count(*) FROM marts.customer_order_summary WHERE customer_id = 3$q$,
  $e$(matview,1); (table,1); (view,0)$e$);
