\getenv eds_demo_analyst_password EDS_DEMO_ANALYST_PASSWORD
\getenv eds_demo_steward_password EDS_DEMO_STEWARD_PASSWORD
\getenv eds_demo_auditor_password EDS_DEMO_AUDITOR_PASSWORD
\getenv eds_demo_service_password EDS_DEMO_SERVICE_PASSWORD
\set ON_ERROR_STOP on
-- Chapter 11 textbook example: roles, grants, and controlled views.
-- Group roles (NOLOGIN) carry privileges; login roles inherit through membership.
CREATE ROLE retail_owner NOLOGIN;
CREATE ROLE sales_analyst NOLOGIN;
CREATE ROLE customer_steward NOLOGIN;
CREATE ROLE access_auditor NOLOGIN;
CREATE ROLE demo_analyst LOGIN PASSWORD :'eds_demo_analyst_password' IN ROLE sales_analyst;
CREATE ROLE demo_steward LOGIN PASSWORD :'eds_demo_steward_password' IN ROLE customer_steward;
CREATE ROLE demo_auditor LOGIN PASSWORD :'eds_demo_auditor_password' IN ROLE access_auditor;
CREATE ROLE svc_export LOGIN PASSWORD :'eds_demo_service_password';

CREATE SCHEMA reporting AUTHORIZATION retail_owner;
ALTER SCHEMA raw OWNER TO retail_owner;
ALTER TABLE raw.customers OWNER TO retail_owner;
ALTER TABLE raw.orders OWNER TO retail_owner;
ALTER TABLE raw.order_items OWNER TO retail_owner;
ALTER TABLE raw.products OWNER TO retail_owner;

SET ROLE retail_owner;
CREATE VIEW reporting.v_sales_by_day AS
  SELECT o.order_date::date AS sales_date, count(DISTINCT o.order_id) AS orders,
         sum(i.quantity * i.price_at_purchase)::numeric(12,2) AS sales_amount
  FROM raw.orders o JOIN raw.order_items i USING (order_id)
  WHERE lower(o.order_status) = 'completed' GROUP BY 1;
CREATE VIEW reporting.v_customers_masked AS
  SELECT customer_id, '***@' || split_part(email, '@', 2) AS email_masked
  FROM raw.customers;
RESET ROLE;

-- Listing 11.1: least-privilege grants
REVOKE ALL ON SCHEMA raw FROM PUBLIC;
REVOKE ALL ON SCHEMA reporting FROM PUBLIC;
GRANT USAGE ON SCHEMA reporting TO sales_analyst, customer_steward, svc_export;
GRANT SELECT ON reporting.v_sales_by_day TO sales_analyst, customer_steward, svc_export;
GRANT SELECT ON reporting.v_customers_masked TO customer_steward;
-- The auditor role receives no grants at all. The privilege inventory in Listing 11.2 reads
-- pg_read_all_stats, which is not needed for the inventory and exposes other sessions' activity,
-- are separate capabilities that would need their own authorization, handling rules, and tests.
