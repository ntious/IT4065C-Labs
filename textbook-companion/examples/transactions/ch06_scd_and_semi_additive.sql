-- Validity convention: DATE ranges are INCLUSIVE at both ends; the next version starts
-- the day after the previous one ends; the open-ended version ends 9999-12-31.
DROP SCHEMA IF EXISTS mart CASCADE; CREATE SCHEMA mart;
CREATE TABLE mart.dim_product (
  product_key  integer PRIMARY KEY,      -- analytical (surrogate) key
  product_id   integer NOT NULL,         -- operational key from the source
  product_name text    NOT NULL,
  category     text    NOT NULL,
  valid_from   date    NOT NULL,
  valid_to     date    NOT NULL DEFAULT '9999-12-31',
  is_current   boolean NOT NULL,
  UNIQUE (product_id, valid_from)
);
INSERT INTO mart.dim_product VALUES
 (1, 3, 'Water Bottle', 'Home Goods', '2026-01-01', '2026-01-31', false),
 (2, 3, 'Water Bottle', 'Outdoor',    '2026-02-01', '9999-12-31', true);
CREATE TABLE mart.fct_sales_line (
  order_item_id integer PRIMARY KEY,
  date_key      date    NOT NULL,
  product_key   integer NOT NULL REFERENCES mart.dim_product(product_key),
  quantity      integer NOT NULL,
  line_amount   numeric(12,2) NOT NULL
);
INSERT INTO mart.fct_sales_line VALUES
 (101, '2026-01-20', 1, 2, 39.90),
 (102, '2026-02-14', 2, 1, 19.95);

\echo '--- Listing 6.6 as was / as is (one implementation: self-join on the current row)'
SELECT d.category, SUM(f.line_amount) AS revenue
FROM mart.fct_sales_line f JOIN mart.dim_product d ON d.product_key = f.product_key
GROUP BY d.category ORDER BY d.category;
SELECT cur.category, SUM(f.line_amount) AS revenue
FROM mart.fct_sales_line f
JOIN mart.dim_product d   ON d.product_key = f.product_key
JOIN mart.dim_product cur ON cur.product_id = d.product_id AND cur.is_current
GROUP BY cur.category;

\echo '--- Listing 6.7 the version-lookup condition (incoming rows keyed by operational id)'
CREATE TABLE mart.stg_sales_line (order_item_id int, sale_date date, product_id int, line_amount numeric(12,2));
INSERT INTO mart.stg_sales_line VALUES (101,'2026-01-20',3,39.90),(102,'2026-02-14',3,19.95),
                                       (103,'2026-01-31',3,19.95);   -- boundary day
\echo '    wrong: join on operational key only (fans out)'
SELECT COUNT(*) AS rows_after_join, SUM(s.line_amount) AS revenue
FROM mart.stg_sales_line s JOIN mart.dim_product d ON d.product_id = s.product_id;
\echo '    right: operational key AND sale date within the inclusive validity range'
SELECT s.order_item_id, s.sale_date, d.product_key, d.category
FROM mart.stg_sales_line s
JOIN mart.dim_product d
  ON d.product_id = s.product_id
 AND s.sale_date BETWEEN d.valid_from AND d.valid_to
ORDER BY s.order_item_id;

\echo '--- Listing 6.8 dimension-history checks (each returns violations)'
CREATE TABLE mart.expected_products (product_id int PRIMARY KEY);   -- population that must have a current row
INSERT INTO mart.expected_products VALUES (3), (4);                  -- product 4 has no dimension row yet
\echo '    (a) more than one current row per operational key'
SELECT product_id, COUNT(*) FROM mart.dim_product WHERE is_current GROUP BY product_id HAVING COUNT(*) > 1;
\echo '    (b) expected products with no current row'
SELECT e.product_id FROM mart.expected_products e
WHERE NOT EXISTS (SELECT 1 FROM mart.dim_product d WHERE d.product_id = e.product_id AND d.is_current);
\echo '    (c) gaps or overlaps between consecutive versions'
SELECT product_id, valid_to AS prev_to, next_from
FROM (SELECT product_id, valid_to,
             LEAD(valid_from) OVER (PARTITION BY product_id ORDER BY valid_from) AS next_from
      FROM mart.dim_product) v
WHERE next_from IS NOT NULL AND next_from <> valid_to + 1;

\echo '--- Listing 6.9 a semi-additive balance, bounded by a reporting period'
CREATE TABLE mart.fct_inventory_snapshot (
  snapshot_date date, product_id integer, units_on_hand integer,
  PRIMARY KEY (snapshot_date, product_id));
INSERT INTO mart.fct_inventory_snapshot VALUES
 ('2026-01-29', 3, 40), ('2026-01-30', 3, 38), ('2026-01-31', 3, 35);
\echo '    wrong: sums a balance across days (expect 113)'
SELECT SUM(units_on_hand) AS units_summed_over_days FROM mart.fct_inventory_snapshot;
\set period_start '2026-01-01'
\set period_end   '2026-01-31'
\i ch06_listing_6_9.sql
\echo '=== Robustness: (1) add a February row'
INSERT INTO mart.fct_inventory_snapshot VALUES ('2026-02-01', 3, 100);
\i ch06_listing_6_9.sql
\echo '=== (2) remove the period-end row'
DELETE FROM mart.fct_inventory_snapshot WHERE snapshot_date = '2026-01-31';
\i ch06_listing_6_9.sql
\echo '=== (3) restore period end, remove an interior day'
INSERT INTO mart.fct_inventory_snapshot VALUES ('2026-01-31', 3, 35);
DELETE FROM mart.fct_inventory_snapshot WHERE snapshot_date = '2026-01-30';
\i ch06_listing_6_9.sql
