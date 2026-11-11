\set ON_ERROR_STOP on
-- Listing 10.4: proposed refresh in dependency order, then re-check
BEGIN;
TRUNCATE core.dim_customer;
INSERT INTO core.dim_customer SELECT * FROM staging.stg_customers;
COMMIT;
REFRESH MATERIALIZED VIEW marts.customer_order_summary;
SELECT 'core.dim_customer (table)' AS object, count(*) AS rows_for_customer_3 FROM core.dim_customer WHERE customer_id = 3
UNION ALL SELECT 'marts.customer_order_summary (matview)', count(*) FROM marts.customer_order_summary WHERE customer_id = 3;
SELECT eds_assert.expect_rows('Listing 10.3 after refresh', $q$
SELECT 'table' AS obj, count(*) FROM core.dim_customer WHERE customer_id = 3
UNION ALL SELECT 'matview', count(*) FROM marts.customer_order_summary WHERE customer_id = 3$q$,
  $e$(matview,0); (table,0)$e$);
