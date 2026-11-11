-- Chapter 3 enforcement tests (textbook; AUTH). Run after 00_assert_helpers.sql and
-- ch03_schema.sql, with ON_ERROR_STOP=1. Writes that SHOULD be rejected are wrapped in
-- eds_assert.expect_error, which passes only on the expected SQLSTATE. Writes that SHOULD be
-- accepted are ordinary statements, so an unexpected rejection stops the run.
\pset footer off
\echo '--- T1 orphan order item (order 9999 does not exist): expect 23503'
SELECT eds_assert.expect_error('T1', $s$INSERT INTO ch03.order_item VALUES (9999, 1, 1, 1, 29.99)$s$, '23503');
\echo '--- T2 zero quantity: expect 23514'
SELECT eds_assert.expect_error('T2', $s$INSERT INTO ch03.order_item VALUES (1002, 2, 1, 0, 29.99)$s$, '23514');
\echo '--- T3 exact duplicate email: expect 23505'
SELECT eds_assert.expect_error('T3', $s$INSERT INTO ch03.customer (email, full_name) VALUES ('alice@example.com', 'A. Example')$s$, '23505');
\echo '--- T4 same string apart from capitalization: accepted (limitation of exact comparison)'
INSERT INTO ch03.customer (email, full_name) VALUES ('Alice@Example.com', 'ALICE EXAMPLE');
\echo '--- T5 explicit value for an ALWAYS identity column: expect 428C9'
SELECT eds_assert.expect_error('T5', $s$INSERT INTO ch03.customer (customer_id, email, full_name) VALUES (50, 'carla@example.com', 'Carla Example')$s$, '428C9');
\echo '--- T6 delete a product that order items reference: expect 23503 (RESTRICT)'
SELECT eds_assert.expect_error('T6', $s$DELETE FROM ch03.product WHERE product_id = 1$s$, '23503');
\echo '--- T7 ship to an address that belongs to a different customer: expect 23503'
SELECT eds_assert.expect_error('T7', $s$INSERT INTO ch03.orders VALUES (1003, 'R-2026-1003', 2, 'pending', '2026-10-12 09:00-04', 'card', 2)$s$, '23503');
\echo '--- T8 store purchase with no shipping address: accepted (optional relationship)'
INSERT INTO ch03.orders VALUES (1004, 'R-2026-1004', 2, 'pending', '2026-10-12 09:30-04', 'cash', NULL);
\echo '--- T9 customer with no phone: accepted (CHECK is satisfied by NULL)'
INSERT INTO ch03.customer (email, full_name, phone) VALUES ('dana@example.com', 'Dana Example', NULL);
\echo '--- T10 phone outside the permitted character pattern: expect 23514'
SELECT eds_assert.expect_error('T10', $s$INSERT INTO ch03.customer (email, full_name, phone) VALUES ('eli@example.com', 'Eli Example', 'call me')$s$, '23514');
\echo '--- T11 return more units than were sold: accepted (row-level CHECK cannot see the sale)'
INSERT INTO ch03.return_item VALUES (1, 1002, 1, 5, '2026-10-20 12:00-04');

\echo '--- State after T1-T11: the accepted writes (T4, T8, T9, T11) are present; no rejected write left a row'
SELECT eds_assert.expect_rows('T-state customers',
  $q$SELECT customer_id, email FROM ch03.customer$q$,
  $e$(1,alice@example.com); (2,brian@example.com); (4,Alice@Example.com); (5,dana@example.com)$e$);
SELECT eds_assert.expect_rows('T-state orders',
  $q$SELECT order_id, order_status, ship_address_no FROM ch03.orders$q$,
  $e$(1001,completed,2); (1002,completed,); (1004,pending,)$e$);

\echo '--- Listing 3.5 detection query for over-returns (returns violating rows)'
SELECT r.order_id, r.line_no, i.quantity AS sold, SUM(r.quantity_returned) AS returned
FROM ch03.return_item r
JOIN ch03.order_item i ON i.order_id = r.order_id AND i.line_no = r.line_no
GROUP BY r.order_id, r.line_no, i.quantity
HAVING SUM(r.quantity_returned) > i.quantity;
SELECT eds_assert.expect_rows('Listing 3.5', $q$
SELECT r.order_id, r.line_no, i.quantity AS sold, SUM(r.quantity_returned) AS returned
FROM ch03.return_item r
JOIN ch03.order_item i ON i.order_id = r.order_id AND i.line_no = r.line_no
GROUP BY r.order_id, r.line_no, i.quantity
HAVING SUM(r.quantity_returned) > i.quantity
$q$, $e$(1002,1,1,5)$e$);

\echo '--- Listing 3.6 price at sale vs current list price after a price change'
UPDATE ch03.product SET list_price = 34.99 WHERE product_id = 1;
SELECT SUM(i.quantity * i.unit_price_at_sale) AS revenue_recorded_at_sale,
       SUM(i.quantity * p.list_price)         AS revenue_recomputed_at_current_price
FROM ch03.order_item i
JOIN ch03.product p ON p.product_id = i.product_id
WHERE i.order_id = 1001;
SELECT eds_assert.expect_rows('Listing 3.6', $q$
SELECT SUM(i.quantity * i.unit_price_at_sale) AS revenue_recorded_at_sale,
       SUM(i.quantity * p.list_price)         AS revenue_recomputed_at_current_price
FROM ch03.order_item i
JOIN ch03.product p ON p.product_id = i.product_id
WHERE i.order_id = 1001
$q$, $e$(99.97,119.97)$e$);

\echo '--- T12 what can still change (1): the stored sale price of a completed order is not protected'
BEGIN;
UPDATE ch03.order_item SET unit_price_at_sale = 0 WHERE order_id = 1001 AND line_no = 1;
SELECT eds_assert.expect_rows('T12', $q$SELECT SUM(quantity * unit_price_at_sale) FROM ch03.order_item WHERE order_id = 1001$q$, $e$(49.99)$e$);
ROLLBACK;
\echo '--- T13 what can still change (2): editing the referenced address changes the address an old order joins to'
BEGIN;
UPDATE ch03.customer_address SET line1 = '99 Changed Rd' WHERE customer_id = 1 AND address_no = 2;
SELECT eds_assert.expect_rows('T13', $q$
SELECT a.line1 FROM ch03.orders AS o
JOIN ch03.customer_address AS a
  ON (a.customer_id, a.address_no) = (o.customer_id, o.ship_address_no)
WHERE o.order_id = 1001$q$, $e$("99 Changed Rd")$e$);
ROLLBACK;

\echo '--- final row counts'
SELECT eds_assert.expect_rows('final counts', $q$
SELECT (SELECT count(*) FROM ch03.customer) AS customers,
       (SELECT count(*) FROM ch03.orders) AS orders,
       (SELECT count(*) FROM ch03.order_item) AS order_items,
       (SELECT count(*) FROM ch03.return_item) AS return_items$q$, $e$(4,3,3,1)$e$);
