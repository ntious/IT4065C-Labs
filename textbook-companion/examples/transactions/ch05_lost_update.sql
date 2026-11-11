-- Listing 5.3: read-then-write with the decision made outside the database (naive).
-- Variables: req (request id), iso (isolation level, e.g. 'READ COMMITTED').
-- The constant 0 is what the application computed from its earlier read (1 - 1).
BEGIN ISOLATION LEVEL :iso;
SELECT units_on_hand AS sees FROM ops.inventory WHERE product_id = 1;
SELECT pg_sleep(2);                                   -- "application work"
UPDATE ops.inventory SET units_on_hand = 0 WHERE product_id = 1;
INSERT INTO ops.sales_log VALUES (:'req', 1);         -- the sale is confirmed
COMMIT;
