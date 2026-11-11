EXPLAIN (ANALYZE, BUFFERS, COSTS OFF, SUMMARY ON)
SELECT order_id, order_date, amount FROM perf_orders
WHERE customer_id = 4242 ORDER BY order_date DESC LIMIT 10;
