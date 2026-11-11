-- Table 5.3, column (a): the same four steps WITHOUT BEGIN/COMMIT (autocommit).
-- Client error policy: STOP at the first error (psql -v ON_ERROR_STOP=1), as a crashed
-- or error-aborting client would. The shipment INSERT is therefore never sent.
-- Run: psql -v ON_ERROR_STOP=1 -f ch05_autocommit_stop_on_error.sql ; then
--      psql -v oid=5002 -f ch05_state.sql
INSERT INTO ops.orders VALUES (5002, 1, 'pending');
INSERT INTO ops.order_items VALUES (5002, 1, 1, 2);
INSERT INTO ops.payments VALUES (5002, 59.98);
UPDATE ops.inventory SET units_on_hand = units_on_hand - 2
 WHERE product_id = 1;
INSERT INTO ops.shipment_requests VALUES (5002);
