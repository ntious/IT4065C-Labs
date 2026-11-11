-- Chapter 3 core model (textbook; AUTH). Scratch database only.
-- Drops and recreates schema ch03. Statements appear in the same order as the chapter's
-- listings, so the file can be read and run top to bottom.
DROP SCHEMA IF EXISTS ch03 CASCADE;
CREATE SCHEMA ch03;

-- Listing 3.2: customer, customer_address, product (no forward references)
CREATE TABLE ch03.customer (
  customer_id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  email       text NOT NULL UNIQUE,
  full_name   text NOT NULL,
  phone       text CHECK (phone ~ '^[0-9+() -]{7,20}$')
);

CREATE TABLE ch03.customer_address (
  customer_id  bigint  NOT NULL REFERENCES ch03.customer (customer_id) ON DELETE RESTRICT,
  address_no   integer NOT NULL CHECK (address_no > 0),
  line1        text    NOT NULL,
  city         text    NOT NULL,
  postal_code  text    NOT NULL,
  PRIMARY KEY (customer_id, address_no)
);

CREATE TABLE ch03.product (
  product_id   integer PRIMARY KEY,
  sku          text    NOT NULL UNIQUE,
  product_name text    NOT NULL,
  category     text    NOT NULL,
  list_price   numeric(10,2) NOT NULL CHECK (list_price >= 0)
);

-- Listing 3.3: orders and order_item (reference the Listing 3.2 tables)
CREATE TABLE ch03.orders (
  order_id         bigint  PRIMARY KEY,
  order_number     text    NOT NULL UNIQUE,
  customer_id      bigint  NOT NULL REFERENCES ch03.customer (customer_id) ON DELETE RESTRICT,
  order_status     text    NOT NULL DEFAULT 'pending'
                   CHECK (order_status IN ('pending','paid','completed','cancelled')),
  ordered_at       timestamptz NOT NULL,
  payment_method   text    NOT NULL,
  ship_address_no  integer,
  FOREIGN KEY (customer_id, ship_address_no)
    REFERENCES ch03.customer_address (customer_id, address_no) ON DELETE RESTRICT
);

CREATE TABLE ch03.order_item (
  order_id           bigint  NOT NULL REFERENCES ch03.orders (order_id) ON DELETE RESTRICT,
  line_no            integer NOT NULL CHECK (line_no > 0),
  product_id         integer NOT NULL REFERENCES ch03.product (product_id) ON DELETE RESTRICT,
  quantity           integer NOT NULL CHECK (quantity > 0),
  unit_price_at_sale numeric(10,2) NOT NULL CHECK (unit_price_at_sale >= 0),
  PRIMARY KEY (order_id, line_no)
);
-- PostgreSQL does not index referencing columns automatically.
CREATE INDEX order_item_product_idx ON ch03.order_item (product_id);

-- Listing 3.4: return_item (references order_item)
CREATE TABLE ch03.return_item (
  return_id          bigint  PRIMARY KEY,
  order_id           bigint  NOT NULL,
  line_no            integer NOT NULL,
  quantity_returned  integer NOT NULL CHECK (quantity_returned > 0),
  returned_at        timestamptz NOT NULL,
  FOREIGN KEY (order_id, line_no) REFERENCES ch03.order_item (order_id, line_no) ON DELETE RESTRICT
);

-- Sample data
INSERT INTO ch03.customer (email, full_name, phone) VALUES
  ('alice@example.com', 'Alice Example', '202-555-0101'),
  ('brian@example.com', 'Brian Example', NULL);
INSERT INTO ch03.customer_address VALUES
  (1, 1, '10 Main St', 'Cincinnati', '45221'),
  (1, 2, '22 Oak Ave', 'Cincinnati', '45219'),
  (2, 1, '5 Elm Rd',   'Dayton',     '45402');
INSERT INTO ch03.product VALUES
  (1, 'MSE-001', 'Wireless Mouse', 'Electronics', 29.99),
  (2, 'STD-002', 'Laptop Stand',   'Electronics', 49.99),
  (3, 'BTL-003', 'Water Bottle',   'Home Goods',  19.95);
INSERT INTO ch03.orders VALUES
  (1001, 'R-2026-1001', 1, 'completed', '2026-10-03 10:15-04', 'card', 2),
  (1002, 'R-2026-1002', 2, 'completed', '2026-10-09 14:02-04', 'gift card', NULL);
INSERT INTO ch03.order_item VALUES
  (1001, 1, 1, 2, 24.99),
  (1001, 2, 2, 1, 49.99),
  (1002, 1, 3, 1, 19.95);
