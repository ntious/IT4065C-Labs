-- Table 5.3, column (b): the same four steps without BEGIN/COMMIT, but the client
-- CONTINUES after the failed UPDATE (psql ON_ERROR_STOP off).
\set ON_ERROR_STOP off
INSERT INTO ops.orders VALUES (5003, 1, 'pending');
INSERT INTO ops.order_items VALUES (5003, 1, 1, 2);
INSERT INTO ops.payments VALUES (5003, 59.98);
UPDATE ops.inventory SET units_on_hand = units_on_hand - 2
 WHERE product_id = 1;
INSERT INTO ops.shipment_requests VALUES (5003);
\set oid 5003
\i ch05_state.sql
