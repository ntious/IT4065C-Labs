\set ON_ERROR_STOP on
-- Listing 11.4: a definition change, with no GRANT statement, widens what readers see
SET ROLE retail_owner;
CREATE OR REPLACE VIEW reporting.v_customers_masked AS
  SELECT customer_id, '***@' || split_part(email, '@', 2) AS email_masked,
         phone_number                       -- added for a "quick fix"
  FROM raw.customers;
RESET ROLE;
