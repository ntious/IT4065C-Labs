-- Variant of Listing 5.5 in which the application ignores what it read and writes anyway.
BEGIN;
SELECT units_on_hand AS sees FROM ops.inventory WHERE product_id = 1 FOR UPDATE;
SELECT pg_sleep(2);
UPDATE ops.inventory SET units_on_hand = units_on_hand - 1 WHERE product_id = 1;
INSERT INTO ops.sales_log VALUES (:'req', 1);
COMMIT;
