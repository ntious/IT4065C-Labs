DROP SCHEMA IF EXISTS crm CASCADE; CREATE SCHEMA crm;
CREATE TABLE crm.customers (
  customer_id   integer PRIMARY KEY,
  full_name     text NOT NULL,
  email         text NOT NULL CHECK (email LIKE '%_@_%'),
  postal_code   text,
  birth_year    integer CHECK (birth_year BETWEEN 1900 AND 2026),
  last_verified date
);
INSERT INTO crm.customers VALUES
 (1, 'Alice Example',  'alice@example.com',  '45221', 1988, '2026-03-02'),
 (2, 'Brian Example',  'brian@example.com',  NULL,   NULL, '2023-06-15'),
 (3, 'Carla Example',  'carla@example.com',  '45219', 1975, '2026-01-20'),
 (4, 'ALICE EXAMPLE',  ' Alice@Example.com', '45221-0001', NULL, '2024-11-30'),
 (5, 'David Example',  'david@example.com',  '4522',  2001, '2022-02-01');

\echo '--- Listing 4.1 profile (unknown verification counted separately; empty-safe percentages)'
\i ch04_listing_4_1.sql

\echo '--- Listing 4.2 candidate duplicates (detection, not resolution)'
SELECT lower(trim(email)) AS normalized_email,
       array_agg(customer_id ORDER BY customer_id) AS customer_ids,
       COUNT(*) AS records
FROM crm.customers
GROUP BY lower(trim(email))
HAVING COUNT(*) > 1;

\echo '--- Listing 4.3 representation validity of postal code'
SELECT customer_id, postal_code
FROM crm.customers
WHERE postal_code IS NOT NULL
  AND postal_code !~ '^[0-9]{5}(-[0-9]{4})?$';

CREATE TABLE crm.price_history (product_id int, list_price numeric(10,2), valid_from date, valid_to date);
INSERT INTO crm.price_history VALUES (2, 49.99, '2026-01-01', '2026-12-31');
CREATE TABLE crm.order_lines (order_item_id int PRIMARY KEY, product_id int, sold_on date,
  unit_price numeric(10,2) NOT NULL CHECK (unit_price >= 0));
INSERT INTO crm.order_lines VALUES (11, 2, '2026-03-05', 49.99), (12, 2, '2026-03-06', 4.99);
\echo '--- Listing 4.4 price differences against the approved price (exceptions to investigate)'
SELECT l.order_item_id, l.unit_price, p.list_price
FROM crm.order_lines l
JOIN crm.price_history p
  ON p.product_id = l.product_id
 AND l.sold_on BETWEEN p.valid_from AND p.valid_to
WHERE l.unit_price <> p.list_price;
\echo '--- Listing 4.4 prerequisites: sales with no applicable price, or more than one'
SELECT l.order_item_id, COUNT(p.product_id) AS applicable_prices
FROM crm.order_lines l
LEFT JOIN crm.price_history p
  ON p.product_id = l.product_id
 AND l.sold_on BETWEEN p.valid_from AND p.valid_to
GROUP BY l.order_item_id
HAVING COUNT(p.product_id) <> 1;

\echo '--- Listing 4.5 resolution evidence at the resolved-identity layer'
CREATE TABLE crm.customer_identity_link (
  source_customer_id   integer PRIMARY KEY REFERENCES crm.customers(customer_id),
  resolved_customer_id integer NOT NULL,
  decision             text NOT NULL CHECK (decision IN ('linked','reversed')),
  reviewed_by          text NOT NULL,
  reviewed_on          date NOT NULL
);
INSERT INTO crm.customer_identity_link VALUES
 (1, 1, 'linked', 'steward', '2026-11-05'), (2, 2, 'linked', 'steward', '2026-11-05'),
 (3, 3, 'linked', 'steward', '2026-11-05'), (4, 1, 'linked', 'steward', '2026-11-05'),
 (5, 5, 'linked', 'steward', '2026-11-05');
SELECT (SELECT COUNT(*) FROM crm.customers)                                   AS source_records,
       (SELECT COUNT(DISTINCT resolved_customer_id) FROM crm.customer_identity_link
         WHERE decision = 'linked')                                           AS resolved_customers,
       (SELECT COUNT(*) FROM crm.customers c WHERE NOT EXISTS
          (SELECT 1 FROM crm.customer_identity_link k
            WHERE k.source_customer_id = c.customer_id))                      AS unlinked_source_records;

\echo '=== Listing 4.1 robustness: on-threshold date and an unknown date, then an empty population'
INSERT INTO crm.customers VALUES (6, 'Erin Example', 'erin@example.com', '45220', 1990, '2024-11-01'),
                                 (7, 'Faye Example', 'faye@example.com', '45220', 1993, NULL);
\i ch04_listing_4_1.sql
DELETE FROM crm.customer_identity_link; DELETE FROM crm.customers;
\i ch04_listing_4_1.sql
