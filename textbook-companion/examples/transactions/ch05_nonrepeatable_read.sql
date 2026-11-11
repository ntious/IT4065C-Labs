-- Part 3: Session A reads twice; Session B (ch05_nonrepeatable_writer.sql) commits 7 in between.
BEGIN ISOLATION LEVEL :iso;
SELECT 'first read'  AS read, units_on_hand FROM ops.inventory WHERE product_id = 1;
SELECT pg_sleep(2);
SELECT 'second read' AS read, units_on_hand FROM ops.inventory WHERE product_id = 1;
COMMIT;
