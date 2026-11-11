-- Listing 5.2 and Table 5.2: checkout as one transaction (run after ch05_schema.sql).
-- Client error policy: continue after errors (psql ON_ERROR_STOP off), so COMMIT is sent.
\set ON_ERROR_STOP off
BEGIN;
INSERT INTO ops.orders VALUES (5001, 1, 'pending');
INSERT INTO ops.order_items VALUES (5001, 1, 1, 2);
INSERT INTO ops.payments VALUES (5001, 59.98);
UPDATE ops.inventory SET units_on_hand = units_on_hand - 2
 WHERE product_id = 1;
INSERT INTO ops.shipment_requests VALUES (5001);
COMMIT;
\echo '--- Table 5.2: state for order 5001'
\set oid 5001
\i ch05_state.sql
