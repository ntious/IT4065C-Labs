-- 02_build_safe_objects.sql
-- Purpose: Create safe, analytics-ready objects + masked views for PII.
-- Runs directly on raw.* so the lab does NOT depend on dbt/staging.

-- 1) Analytics-ready aggregate view (uses price_at_purchase from raw.order_items)
CREATE OR REPLACE VIEW student_kofi.v_sales_by_day AS
SELECT
  o.order_date::date AS sales_date,
  COUNT(DISTINCT o.order_id) AS orders,
  SUM(oi.quantity * oi.price_at_purchase)::numeric(12,2) AS sales_amount
FROM raw.orders o
JOIN raw.order_items oi ON oi.order_id = o.order_id
GROUP BY 1;

COMMENT ON VIEW student_kofi.v_sales_by_day IS
'Analytics-ready aggregate view (safe target for analyst access).';

-- 2) Masked customer view (PII protected)
CREATE OR REPLACE VIEW student_kofi.v_customers_masked AS
SELECT
  c.customer_id,
  c.first_name,
  c.last_name,
  CASE
    WHEN c.email IS NULL OR c.email = '' THEN NULL
    ELSE left(c.email, 2) || '***@' || split_part(c.email, '@', 2)
  END AS email_masked,
  CASE
    WHEN c.phone_number IS NULL OR c.phone_number = '' THEN NULL
    ELSE '***-***-' || right(c.phone_number, 4)
  END AS phone_masked
FROM raw.customers c;

COMMENT ON VIEW student_kofi.v_customers_masked IS
'Masked customer view: safe access to customer identity without raw PII exposure.';

-- 3) Sensitive raw PII view (intentionally restricted)
CREATE OR REPLACE VIEW student_kofi.v_customers_raw_pii AS
SELECT
  customer_id, first_name, last_name, email, phone_number
FROM raw.customers;

COMMENT ON VIEW student_kofi.v_customers_raw_pii IS
'INTENTIONALLY SENSITIVE: raw PII view used to test access denial.';
