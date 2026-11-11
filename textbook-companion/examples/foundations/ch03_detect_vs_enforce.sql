-- Chapter 3: detection versus enforcement (textbook; AUTH). Scratch database only.
-- Mirrors the structure of a raw layer that declares keys but not foreign keys.
-- Run with ON_ERROR_STOP=1 after 00_assert_helpers.sql; expected rejections are asserted.
\pset footer off
DROP SCHEMA IF EXISTS ch03_raw CASCADE;
CREATE SCHEMA ch03_raw;
CREATE TABLE ch03_raw.orders (
  order_id    integer PRIMARY KEY,
  customer_id integer NOT NULL
);
CREATE TABLE ch03_raw.order_items (
  order_item_id integer PRIMARY KEY,
  order_id      integer NOT NULL,          -- no REFERENCES clause
  quantity      integer NOT NULL
);
INSERT INTO ch03_raw.orders VALUES (1, 1), (2, 2);
\echo '--- Step 1: load an orphan line item (order 7 does not exist): accepted'
INSERT INTO ch03_raw.order_items VALUES (10, 1, 1), (11, 2, 1), (12, 7, 3);
\echo '--- Listing 3.7 Step 2: a violation-returning relationship check, run after the load'
SELECT i.order_item_id, i.order_id
FROM ch03_raw.order_items i
LEFT JOIN ch03_raw.orders o ON o.order_id = i.order_id
WHERE i.order_id IS NOT NULL
  AND o.order_id IS NULL;
SELECT eds_assert.expect_rows('Listing 3.7 (step 2)', $q$
SELECT i.order_item_id, i.order_id
FROM ch03_raw.order_items i
LEFT JOIN ch03_raw.orders o ON o.order_id = i.order_id
WHERE i.order_id IS NOT NULL
  AND o.order_id IS NULL
$q$, $e$(12,7)$e$);
\echo '--- Step 3: try to add the foreign key while the orphan exists: expect 23503'
SELECT eds_assert.expect_error('Step 3', $s$ALTER TABLE ch03_raw.order_items
  ADD CONSTRAINT order_items_order_fk FOREIGN KEY (order_id) REFERENCES ch03_raw.orders (order_id)$s$, '23503');
\echo '--- Step 4: resolve the orphan (here, by deleting it), then add the constraint'
DELETE FROM ch03_raw.order_items WHERE order_item_id = 12;
ALTER TABLE ch03_raw.order_items
  ADD CONSTRAINT order_items_order_fk FOREIGN KEY (order_id) REFERENCES ch03_raw.orders (order_id);
\echo '--- Step 5: the same orphan write is now rejected: expect 23503'
SELECT eds_assert.expect_error('Step 5', $s$INSERT INTO ch03_raw.order_items VALUES (12, 7, 3)$s$, '23503');
\echo '--- Step 6: the detection query still runs and now returns no rows'
SELECT i.order_item_id, i.order_id
FROM ch03_raw.order_items i
LEFT JOIN ch03_raw.orders o ON o.order_id = i.order_id
WHERE i.order_id IS NOT NULL
  AND o.order_id IS NULL;
SELECT eds_assert.expect_rows('Listing 3.7 (step 6)', $q$
SELECT i.order_item_id, i.order_id
FROM ch03_raw.order_items i
LEFT JOIN ch03_raw.orders o ON o.order_id = i.order_id
WHERE i.order_id IS NOT NULL
  AND o.order_id IS NULL
$q$, $e$(no rows)$e$);
