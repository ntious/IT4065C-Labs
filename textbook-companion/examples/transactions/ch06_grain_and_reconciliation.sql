-- Scratch database only: drops and recreates tables in schema raw.
CREATE SCHEMA IF NOT EXISTS raw;
DROP TABLE IF EXISTS raw.orders, raw.order_items CASCADE;
CREATE TABLE raw.orders (order_id integer PRIMARY KEY, customer_id integer NOT NULL,
 order_date timestamp NOT NULL, order_status text NOT NULL, total_amount numeric(10,2) NOT NULL,
 payment_method text NOT NULL);
INSERT INTO raw.orders VALUES (1,1,'2026-01-10','Completed',79.98,'Card'),
 (2,2,'2026-01-10','Completed',49.99,'Gift Card'),
 (3,3,'2026-01-11','Cancelled',19.95,'Store Credit'),
 (4,1,'2026-01-11','Completed',9.98,'Card');
CREATE TABLE raw.order_items (order_item_id integer PRIMARY KEY, order_id integer NOT NULL,
 product_id integer NOT NULL, quantity integer NOT NULL, price_at_purchase numeric(10,2) NOT NULL);
INSERT INTO raw.order_items VALUES (1,1,1,1,29.99),(2,1,2,1,49.99),
 (3,2,2,1,49.99),(4,3,3,1,19.95),(5,4,4,2,4.99);

\echo '--- Listing 6.1 incorrect (expect 219.93, 4)'
SELECT SUM(o.total_amount) AS revenue, COUNT(*) AS orders_counted
FROM raw.orders o JOIN raw.order_items i ON i.order_id = o.order_id
WHERE o.order_status = 'Completed';

\echo '--- valid derivation from item-grain rows (expect 4 rows, 3 distinct orders, 139.95)'
SELECT COUNT(*) AS item_rows, COUNT(DISTINCT o.order_id) AS orders_counted,
       SUM(i.quantity * i.price_at_purchase) AS revenue_from_lines
FROM raw.orders o JOIN raw.order_items i ON i.order_id = o.order_id
WHERE o.order_status = 'Completed';

\echo '--- Listing 6.2 aggregate to order grain first (expect 139.95, 139.95, 3)'
WITH order_level AS (
  SELECT o.order_id, o.total_amount,
         SUM(i.quantity * i.price_at_purchase) AS line_total
  FROM raw.orders o
  JOIN raw.order_items i ON i.order_id = o.order_id
  WHERE o.order_status = 'Completed'
  GROUP BY o.order_id, o.total_amount
)
SELECT SUM(total_amount) AS revenue_from_headers,
       SUM(line_total)   AS revenue_from_lines,
       COUNT(*)          AS orders_counted
FROM order_level;

\echo '--- Listing 6.3a header-preserving reconciliation exceptions'
\i ch06_listing_6_3.sql
\echo '--- Listing 6.3b orphan item lines (lines whose order header is missing)'
\i ch06_listing_6_3b.sql

\echo '--- Listing 6.4 control totals'
SELECT 'orders' AS source, COUNT(*) AS rows, SUM(total_amount) AS amount
FROM raw.orders WHERE order_status = 'Completed'
UNION ALL
SELECT 'order_items (completed orders)', COUNT(*), SUM(i.quantity * i.price_at_purchase)
FROM raw.order_items i JOIN raw.orders o USING (order_id)
WHERE o.order_status = 'Completed';

\echo '=== Counterexamples (expect: order 5 no lines, order 6 amount mismatch, item 99 orphan)'
INSERT INTO raw.orders VALUES (5,2,'2026-01-12','Completed',25.00,'Card'),
                              (6,3,'2026-01-12','Completed',30.00,'Card');
INSERT INTO raw.order_items VALUES (6,6,1,1,29.99), (99,42,2,1,49.99);
\i ch06_listing_6_3.sql
\i ch06_listing_6_3b.sql
\echo '--- original inner-join form on the same data (misses order 5)'
SELECT o.order_id FROM raw.orders o JOIN raw.order_items i ON i.order_id = o.order_id
GROUP BY o.order_id, o.total_amount
HAVING o.total_amount <> SUM(i.quantity * i.price_at_purchase);
