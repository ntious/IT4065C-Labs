DROP SCHEMA IF EXISTS ops CASCADE; CREATE SCHEMA ops;
CREATE TABLE ops.inventory (
  product_id    integer PRIMARY KEY,
  units_on_hand integer NOT NULL CHECK (units_on_hand >= 0)
);
CREATE TABLE ops.orders (
  order_id     integer PRIMARY KEY,
  customer_id  integer NOT NULL,
  order_status text NOT NULL CHECK (order_status IN ('pending','paid','completed','cancelled'))
);
CREATE TABLE ops.order_items (
  order_id   integer NOT NULL REFERENCES ops.orders(order_id),
  line_no    integer NOT NULL,
  product_id integer NOT NULL REFERENCES ops.inventory(product_id),
  quantity   integer NOT NULL CHECK (quantity > 0),
  PRIMARY KEY (order_id, line_no)
);
CREATE TABLE ops.payments (
  order_id integer PRIMARY KEY REFERENCES ops.orders(order_id),
  amount   numeric(10,2) NOT NULL CHECK (amount > 0)
);
CREATE TABLE ops.shipment_requests (
  order_id integer PRIMARY KEY REFERENCES ops.orders(order_id)
);
INSERT INTO ops.inventory VALUES (1, 1);
-- Scratch table for counting confirmed sales in the concurrency harness.
-- request_id is the checkout request identity; the key makes a retry unable to confirm twice.
CREATE TABLE ops.sales_log (
  request_id text PRIMARY KEY,
  product_id integer NOT NULL
);
