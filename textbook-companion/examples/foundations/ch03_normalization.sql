-- Chapter 3: anomalies in a wide order-line table (textbook; AUTH). Scratch database only.
-- Run with ON_ERROR_STOP=1 after 00_assert_helpers.sql; the expected insertion failure is asserted.
\pset footer off
DROP SCHEMA IF EXISTS ch03_wide CASCADE;
CREATE SCHEMA ch03_wide;
CREATE TABLE ch03_wide.order_line (
  order_id        integer NOT NULL,
  line_no         integer NOT NULL,
  ordered_on      date    NOT NULL,   -- depends on order_id only
  customer_id     integer NOT NULL,   -- depends on order_id only
  customer_email  text    NOT NULL,   -- depends on customer_id
  product_id      integer NOT NULL,
  product_name    text    NOT NULL,   -- depends on product_id
  category        text    NOT NULL,   -- depends on product_id
  quantity        integer NOT NULL,
  unit_price      numeric(10,2) NOT NULL,
  PRIMARY KEY (order_id, line_no)
);
INSERT INTO ch03_wide.order_line VALUES
 (1, 1, '2026-10-03', 1, 'alice@example.com', 1, 'Wireless Mouse', 'Electronics', 2, 24.99),
 (1, 2, '2026-10-03', 1, 'alice@example.com', 2, 'Laptop Stand',   'Electronics', 1, 49.99),
 (2, 1, '2026-10-09', 2, 'brian@example.com', 2, 'Laptop Stand',   'Electronics', 1, 49.99),
 (3, 1, '2026-10-11', 1, 'alice@example.com', 3, 'Water Bottle',   'Home Goods',  1, 19.95);
\echo '--- Update anomaly: change the email on one row only'
UPDATE ch03_wide.order_line SET customer_email = 'alice.new@example.com'
WHERE order_id = 3;
\echo '--- Listing 3.1 the table now contradicts itself'
SELECT customer_id, COUNT(DISTINCT customer_email) AS emails_on_file,
       string_agg(DISTINCT customer_email, ', ') AS values_found
FROM ch03_wide.order_line
GROUP BY customer_id
HAVING COUNT(DISTINCT customer_email) > 1;
SELECT eds_assert.expect_rows('Listing 3.1', $q$
SELECT customer_id, COUNT(DISTINCT customer_email) AS emails_on_file,
       string_agg(DISTINCT customer_email, ', ') AS values_found
FROM ch03_wide.order_line
GROUP BY customer_id
HAVING COUNT(DISTINCT customer_email) > 1
$q$, $e$(1,2,"alice.new@example.com, alice@example.com")$e$);
\echo '--- Insertion anomaly: a new product with no order yet cannot be recorded: expect 23502'
SELECT eds_assert.expect_error('Insertion anomaly', $s$INSERT INTO ch03_wide.order_line (order_id, line_no, ordered_on, customer_id, customer_email,
  product_id, product_name, category, quantity, unit_price)
VALUES (NULL, NULL, DATE '2026-11-01', 0, 'none', 4, 'Notebook', 'Office Supplies', 0, 4.99)$s$, '23502');
\echo '--- Deletion anomaly: cancel and delete order 3, and the only record of the Water Bottle disappears'
DELETE FROM ch03_wide.order_line WHERE order_id = 3;
SELECT COUNT(*) AS rows_describing_water_bottle
FROM ch03_wide.order_line WHERE product_id = 3;
SELECT eds_assert.expect_rows('Deletion anomaly', $q$SELECT COUNT(*) FROM ch03_wide.order_line WHERE product_id = 3$q$, $e$(0)$e$);
