-- Chapter 1 worked example (textbook; AUTH). Scratch database only.
-- Drops and recreates schema ch01.
DROP SCHEMA IF EXISTS ch01 CASCADE;
CREATE SCHEMA ch01;
CREATE TABLE ch01.products (
  product_id   integer PRIMARY KEY,
  product_name text NOT NULL,
  list_price   numeric(10,2) NOT NULL          -- current catalog price
);
CREATE TABLE ch01.orders (
  order_id     integer PRIMARY KEY,
  channel      text NOT NULL CHECK (channel IN ('online','store')),
  order_status text NOT NULL CHECK (order_status IN ('pending','paid','completed','cancelled')),
  order_date   date NOT NULL
);
CREATE TABLE ch01.order_items (
  order_id           integer NOT NULL REFERENCES ch01.orders(order_id),
  line_no            integer NOT NULL,
  product_id         integer NOT NULL REFERENCES ch01.products(product_id),
  quantity           integer NOT NULL CHECK (quantity > 0),
  unit_price_at_sale numeric(10,2) NOT NULL CHECK (unit_price_at_sale >= 0),
  PRIMARY KEY (order_id, line_no)
);
CREATE TABLE ch01.returns (
  return_id         integer PRIMARY KEY,
  order_id          integer NOT NULL,
  line_no           integer NOT NULL,
  quantity_returned integer NOT NULL CHECK (quantity_returned > 0),
  return_date       date NOT NULL,
  FOREIGN KEY (order_id, line_no) REFERENCES ch01.order_items(order_id, line_no)
);
INSERT INTO ch01.products VALUES (1,'Wireless Mouse',29.99),(2,'Laptop Stand',49.99);
INSERT INTO ch01.orders VALUES
 (101,'online','completed','2026-10-03'),
 (102,'store', 'completed','2026-10-09'),
 (103,'online','cancelled','2026-10-12'),
 (104,'online','completed','2026-10-30'),
 (105,'store', 'completed','2026-09-28');
INSERT INTO ch01.order_items VALUES
 (101,1,1,2,24.99),   -- promotional price at the time of sale
 (101,2,2,1,49.99),
 (102,1,1,1,29.99),
 (103,1,2,2,49.99),   -- cancelled order
 (104,1,1,1,29.99),
 (105,1,2,1,49.99);   -- September sale
INSERT INTO ch01.returns VALUES
 (1,104,1,1,'2026-11-04'),  -- October sale returned in November
 (2,105,1,1,'2026-10-02');  -- September sale returned in October

\echo '--- Listing 1.1 the first query (runs without error)'
SELECT p.product_name,
       SUM(i.quantity)                AS units,
       SUM(i.quantity * p.list_price) AS revenue
FROM ch01.order_items i
JOIN ch01.orders   o ON o.order_id   = i.order_id
JOIN ch01.products p ON p.product_id = i.product_id
WHERE o.order_date >= DATE '2026-10-01'
  AND o.order_date <  DATE '2026-11-01'
GROUP BY p.product_name
ORDER BY p.product_name;

\echo '--- Listing 1.2 definition A: completed October orders, price at sale, gross'
SELECT p.product_name,
       SUM(i.quantity)                        AS units,
       SUM(i.quantity * i.unit_price_at_sale) AS revenue
FROM ch01.order_items i
JOIN ch01.orders   o ON o.order_id   = i.order_id
JOIN ch01.products p ON p.product_id = i.product_id
WHERE o.order_status = 'completed'
  AND o.order_date >= DATE '2026-10-01'
  AND o.order_date <  DATE '2026-11-01'
GROUP BY p.product_name
ORDER BY p.product_name;

\echo '--- Listing 1.3 definition B: as A, net of all returns against those orders'
WITH returned AS (
  SELECT order_id, line_no, SUM(quantity_returned) AS qty
  FROM ch01.returns GROUP BY order_id, line_no
)
SELECT p.product_name,
       SUM(i.quantity - COALESCE(r.qty,0))                        AS net_units,
       SUM((i.quantity - COALESCE(r.qty,0)) * i.unit_price_at_sale) AS net_revenue
FROM ch01.order_items i
JOIN ch01.orders   o ON o.order_id   = i.order_id
JOIN ch01.products p ON p.product_id = i.product_id
LEFT JOIN returned r ON r.order_id = i.order_id AND r.line_no = i.line_no
WHERE o.order_status = 'completed'
  AND o.order_date >= DATE '2026-10-01'
  AND o.order_date <  DATE '2026-11-01'
GROUP BY p.product_name
ORDER BY p.product_name;

\echo '--- Listing 1.4 definition C: October sales minus returns processed in October'
WITH activity AS (
  SELECT i.product_id, i.quantity AS qty, i.quantity * i.unit_price_at_sale AS amount
  FROM ch01.order_items i JOIN ch01.orders o ON o.order_id = i.order_id
  WHERE o.order_status = 'completed'
    AND o.order_date >= DATE '2026-10-01' AND o.order_date < DATE '2026-11-01'
  UNION ALL
  SELECT i.product_id, -r.quantity_returned, -r.quantity_returned * i.unit_price_at_sale
  FROM ch01.returns r JOIN ch01.order_items i ON i.order_id = r.order_id AND i.line_no = r.line_no
  WHERE r.return_date >= DATE '2026-10-01' AND r.return_date < DATE '2026-11-01'
)
SELECT p.product_name, SUM(a.qty) AS net_units, SUM(a.amount) AS net_revenue
FROM activity a JOIN ch01.products p ON p.product_id = a.product_id
GROUP BY p.product_name
ORDER BY p.product_name;

\echo '--- Assertions: each listing returns the values reported in Table 1.3'
SELECT eds_assert.expect_rows('Listing 1.1', $q$
SELECT p.product_name,
       SUM(i.quantity)                AS units,
       SUM(i.quantity * p.list_price) AS revenue
FROM ch01.order_items i
JOIN ch01.orders   o ON o.order_id   = i.order_id
JOIN ch01.products p ON p.product_id = i.product_id
WHERE o.order_date >= DATE '2026-10-01'
  AND o.order_date <  DATE '2026-11-01'
GROUP BY p.product_name
$q$, $e$("Laptop Stand",3,149.97); ("Wireless Mouse",4,119.96)$e$);
SELECT eds_assert.expect_rows('Listing 1.2', $q$
SELECT p.product_name,
       SUM(i.quantity)                        AS units,
       SUM(i.quantity * i.unit_price_at_sale) AS revenue
FROM ch01.order_items i
JOIN ch01.orders   o ON o.order_id   = i.order_id
JOIN ch01.products p ON p.product_id = i.product_id
WHERE o.order_status = 'completed'
  AND o.order_date >= DATE '2026-10-01'
  AND o.order_date <  DATE '2026-11-01'
GROUP BY p.product_name
$q$, $e$("Laptop Stand",1,49.99); ("Wireless Mouse",4,109.96)$e$);
SELECT eds_assert.expect_rows('Listing 1.3', $q$
WITH returned AS (
  SELECT order_id, line_no, SUM(quantity_returned) AS qty
  FROM ch01.returns GROUP BY order_id, line_no
)
SELECT p.product_name,
       SUM(i.quantity - COALESCE(r.qty,0))                        AS net_units,
       SUM((i.quantity - COALESCE(r.qty,0)) * i.unit_price_at_sale) AS net_revenue
FROM ch01.order_items i
JOIN ch01.orders   o ON o.order_id   = i.order_id
JOIN ch01.products p ON p.product_id = i.product_id
LEFT JOIN returned r ON r.order_id = i.order_id AND r.line_no = i.line_no
WHERE o.order_status = 'completed'
  AND o.order_date >= DATE '2026-10-01'
  AND o.order_date <  DATE '2026-11-01'
GROUP BY p.product_name
$q$, $e$("Laptop Stand",1,49.99); ("Wireless Mouse",3,79.97)$e$);
SELECT eds_assert.expect_rows('Listing 1.4', $q$
WITH activity AS (
  SELECT i.product_id, i.quantity AS qty, i.quantity * i.unit_price_at_sale AS amount
  FROM ch01.order_items i JOIN ch01.orders o ON o.order_id = i.order_id
  WHERE o.order_status = 'completed'
    AND o.order_date >= DATE '2026-10-01' AND o.order_date < DATE '2026-11-01'
  UNION ALL
  SELECT i.product_id, -r.quantity_returned, -r.quantity_returned * i.unit_price_at_sale
  FROM ch01.returns r JOIN ch01.order_items i ON i.order_id = r.order_id AND i.line_no = r.line_no
  WHERE r.return_date >= DATE '2026-10-01' AND r.return_date < DATE '2026-11-01'
)
SELECT p.product_name, SUM(a.qty) AS net_units, SUM(a.amount) AS net_revenue
FROM activity a JOIN ch01.products p ON p.product_id = a.product_id
GROUP BY p.product_name
$q$, $e$("Laptop Stand",0,0.00); ("Wireless Mouse",4,109.96)$e$);
