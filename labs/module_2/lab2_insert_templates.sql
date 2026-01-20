-- ============================================================
-- Lab 2: Governance Register INSERT Templates
-- Tables Covered: raw.customers, raw.orders
--
-- Instructions for Students:
-- 1. You must classify columns from TWO tables:
--      - raw.customers (choose 5 columns)
--      - raw.orders    (choose 5 columns)
-- 2. For each column:
--      - Copy ONE INSERT block
--      - Replace values inside < >
--      - Do NOT change SQL structure
-- 3. Execute each INSERT after editing
--
-- Focus on REASONING, not SQL syntax.
-- ============================================================


-- ============================================================
-- SECTION A: raw.customers
-- Candidate columns may include:
-- customer_id, first_name, last_name, email, phone_number, created_at
-- ============================================================

-- -------- INSERT TEMPLATE (copy per column) --------
INSERT INTO student_kofi.data_classification_register
(schema_name, table_name, column_name, data_type, classification, rationale, owner_role, retention_type)
VALUES
(
  'raw',                     -- schema_name (do not change)
  'customers',               -- table_name  (do not change)
  '<column_name>',           -- e.g., first_name
  '<data_type>',             -- e.g., text
  '<classification>',        -- Public | Internal | Sensitive | Restricted
  '<rationale>',             -- 1 clear sentence explaining WHY
  '<owner_role>',            -- Customer Data | Sales Ops | IT | Other
  '<retention_type>'         -- Short-term | Long-term | Both
);

-- Example (COMMENTED – DO NOT SUBMIT AS-IS)
-- ('raw','customers','email','text','Sensitive',
--  'Direct personal identifier used to contact a customer.',
--  'Customer Data','Long-term');


-- ============================================================
-- SECTION B: raw.orders
-- Candidate columns may include:
-- order_id, customer_id, order_date, order_status,
-- total_amount, payment_method
-- ============================================================

-- -------- INSERT TEMPLATE (copy per column) --------
INSERT INTO student_kofi.data_classification_register
(schema_name, table_name, column_name, data_type, classification, rationale, owner_role, retention_type)
VALUES
(
  'raw',                     -- schema_name (do not change)
  'orders',                  -- table_name  (do not change)
  '<column_name>',           -- e.g., total_amount
  '<data_type>',             -- e.g., numeric
  '<classification>',        -- Public | Internal | Sensitive | Restricted
  '<rationale>',             -- 1 clear sentence explaining WHY
  '<owner_role>',            -- Sales Ops | Finance | IT | Other
  '<retention_type>'         -- Short-term | Long-term | Both
);

-- Example (COMMENTED – DO NOT SUBMIT AS-IS)
-- ('raw','orders','total_amount','numeric','Sensitive',
--  'Represents financial transaction value used for reporting.',
--  'Sales Ops','Long-term');

-- ============================================================
-- END OF FILE
-- ============================================================
