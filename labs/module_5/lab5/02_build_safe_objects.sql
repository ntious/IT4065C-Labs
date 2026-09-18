BEGIN;
CREATE OR REPLACE VIEW {{schema}}.v_sales_by_day AS
 SELECT o.order_date::date AS sales_date,count(DISTINCT o.order_id) AS orders,
 sum(i.quantity*i.price_at_purchase)::numeric(12,2) AS sales_amount
 FROM raw.orders o JOIN raw.order_items i USING(order_id)
 WHERE lower(o.order_status)='completed' GROUP BY 1;
CREATE OR REPLACE VIEW {{schema}}.v_customers_masked AS
 SELECT customer_id,'***@' || split_part(email,'@',2) AS email_masked,
 CASE WHEN phone_number IS NULL THEN NULL ELSE '***' || right(phone_number,2) END AS phone_masked
 FROM raw.customers;
CREATE OR REPLACE VIEW {{schema}}.v_customers_raw_pii AS SELECT * FROM raw.customers;
COMMIT;
