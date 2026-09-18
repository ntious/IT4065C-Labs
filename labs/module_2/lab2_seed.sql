-- Synthetic fixtures. Only called for an empty four-table raw dataset.
-- No DROP/CASCADE; failure rolls the whole seed transaction back.
BEGIN;
CREATE TABLE raw.customers (customer_id integer PRIMARY KEY, first_name text NOT NULL,
 last_name text NOT NULL, email text NOT NULL, phone_number text, created_at timestamp NOT NULL);
INSERT INTO raw.customers VALUES
 (1,'Alice','Example','alice@example.com','202-555-0101','2026-01-01'),
 (2,'Brian','Example','brian@example.com',NULL,'2026-01-01'),
 (3,'Carla','Example','carla@example.com','202-555-0103','2026-01-01'),
 (4,'David','Example','david@example.com',NULL,'2026-01-01');
CREATE TABLE raw.products (product_id integer PRIMARY KEY,product_name text NOT NULL,
 category text NOT NULL,standard_price numeric(10,2) NOT NULL);
INSERT INTO raw.products VALUES (1,'Wireless Mouse','Electronics',29.99),
 (2,'Laptop Stand','Electronics',49.99),(3,'Water Bottle','Home Goods',19.95),
 (4,'Notebook','Office Supplies',4.99);
CREATE TABLE raw.orders (order_id integer PRIMARY KEY,customer_id integer NOT NULL,
 order_date timestamp NOT NULL,order_status text NOT NULL,total_amount numeric(10,2) NOT NULL,payment_method text NOT NULL);
INSERT INTO raw.orders VALUES (1,1,'2026-01-10','Completed',79.98,'Card'),
 (2,2,'2026-01-10','Completed',49.99,'Gift Card'),
 (3,3,'2026-01-11','Cancelled',19.95,'Store Credit'),
 (4,1,'2026-01-11','Completed',9.98,'Card');
CREATE TABLE raw.order_items (order_item_id integer PRIMARY KEY,order_id integer NOT NULL,
 product_id integer NOT NULL,quantity integer NOT NULL,price_at_purchase numeric(10,2) NOT NULL);
INSERT INTO raw.order_items VALUES (1,1,1,1,29.99),(2,1,2,1,49.99),
 (3,2,2,1,49.99),(4,3,3,1,19.95),(5,4,4,2,4.99);
COMMIT;
