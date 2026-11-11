\set ON_ERROR_STOP on
-- Chapter 13 author experiment: a bounded index hypothesis on a synthetic table.
-- Workload: point lookups of one customer's recent orders. Not a production benchmark.
DROP TABLE IF EXISTS perf_orders;
CREATE TABLE perf_orders AS
SELECT g AS order_id, (g % 50000) + 1 AS customer_id,
       DATE '2025-01-01' + (g % 365) AS order_date,
       round((random() * 200)::numeric, 2) AS amount
FROM generate_series(1, 500000) AS g;
ALTER TABLE perf_orders ADD PRIMARY KEY (order_id);
ANALYZE perf_orders;
