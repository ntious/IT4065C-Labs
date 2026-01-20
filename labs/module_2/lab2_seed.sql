-- ============================================================
-- Lab 2 Seed Script
-- Module 1: Data Governance & Classification
-- Scenario: Retail Order & Sales System
-- Schema: raw
-- ============================================================

BEGIN;

-- Ensure raw schema exists
CREATE SCHEMA IF NOT EXISTS raw;

-- ------------------------------------------------------------
-- CUSTOMERS
-- ------------------------------------------------------------
DROP TABLE IF EXISTS raw.customers CASCADE;

CREATE TABLE raw.customers (
    customer_id     SERIAL PRIMARY KEY,
    first_name      TEXT NOT NULL,
    last_name       TEXT NOT NULL,
    email           TEXT NOT NULL,
    phone_number    TEXT,
    created_at      TIMESTAMP DEFAULT NOW()
);

INSERT INTO raw.customers (first_name, last_name, email, phone_number) VALUES
('Alice', 'Johnson', 'alice.johnson@email.com', '513-555-1023'),
('Brian', 'Smith', 'brian.smith@email.com', NULL),
('Carla', 'Nguyen', 'carla.nguyen@email.com', '513-555-7781'),
('David', 'Brown', 'david.brown@email.com', NULL);

-- ------------------------------------------------------------
-- PRODUCTS
-- ------------------------------------------------------------
DROP TABLE IF EXISTS raw.products CASCADE;

CREATE TABLE raw.products (
    product_id      SERIAL PRIMARY KEY,
    product_name    TEXT NOT NULL,
    category        TEXT NOT NULL,
    standard_price  NUMERIC(10,2) NOT NULL,
    created_at      TIMESTAMP DEFAULT NOW()
);

INSERT INTO raw.products (product_name, category, standard_price) VALUES
('Wireless Mouse', 'Electronics', 29.99),
('Laptop Stand', 'Electronics', 49.99),
('Water Bottle', 'Home Goods', 19.95),
('Notebook', 'Office Supplies', 4.99);

-- ------------------------------------------------------------
-- ORDERS
-- ------------------------------------------------------------
DROP TABLE IF EXISTS raw.orders CASCADE;

CREATE TABLE raw.orders (
    order_id        SERIAL PRIMARY KEY,
    customer_id     INT NOT NULL,
    order_date      TIMESTAMP DEFAULT NOW(),
    order_status    TEXT NOT NULL,
    total_amount    NUMERIC(10,2) NOT NULL,
    payment_method  TEXT NOT NULL
);

INSERT INTO raw.orders (customer_id, order_status, total_amount, payment_method) VALUES
(1, 'Completed', 79.98, 'Credit Card'),
(2, 'Completed', 49.99, 'Gift Card'),
(3, 'Cancelled', 19.95, 'Store Credit'),
(1, 'Completed', 34.98, 'Credit Card');

-- ------------------------------------------------------------
-- ORDER ITEMS (LINE ITEMS)
-- ------------------------------------------------------------
DROP TABLE IF EXISTS raw.order_items CASCADE;

CREATE TABLE raw.order_items (
    order_item_id       SERIAL PRIMARY KEY,
    order_id            INT NOT NULL,
    product_id          INT NOT NULL,
    quantity            INT NOT NULL,
    price_at_purchase   NUMERIC(10,2) NOT NULL
);

INSERT INTO raw.order_items (order_id, product_id, quantity, price_at_purchase) VALUES
(1, 1, 1, 29.99),
(1, 2, 1, 49.99),
(2, 2, 1, 49.99),
(3, 3, 1, 19.95),
(4, 4, 2, 4.99);

COMMIT;
