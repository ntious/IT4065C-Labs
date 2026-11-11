\set ON_ERROR_STOP on
-- Chapter 11 textbook example (AUTH + AUTH-OBS): owning the SCHEMA is not owning the VIEW.
-- A role that owns the reporting schema, but not the view, tries the opening scenario's replacement.
-- It is given USAGE on raw and SELECT on raw.customers so that the only missing right is ownership
-- of the view; the assertion checks both the SQLSTATE and that the message names view ownership.
CREATE ROLE schema_owner_only NOLOGIN;
ALTER SCHEMA reporting OWNER TO schema_owner_only;
GRANT USAGE ON SCHEMA raw TO schema_owner_only;
GRANT SELECT ON raw.customers TO schema_owner_only;
SET ROLE schema_owner_only;
CREATE FUNCTION pg_temp.try_replace() RETURNS text LANGUAGE plpgsql AS $f$
DECLARE st text; msg text;
BEGIN
  BEGIN
    EXECUTE $s$CREATE OR REPLACE VIEW reporting.v_customers_masked AS
      SELECT customer_id, '***@' || split_part(email, '@', 2) AS email_masked, phone_number
      FROM raw.customers$s$;
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS st = RETURNED_SQLSTATE, msg = MESSAGE_TEXT;
    IF st = '42501' AND msg LIKE 'must be owner of view%' THEN
      RETURN format('PASS [schema owner replaces a view it does not own] rejected as expected: %s %s', st, msg);
    END IF;
    RAISE EXCEPTION 'ASSERTION FAILED [schema owner replaces a view it does not own]: got % (%); expected 42501 must be owner of view', st, msg;
  END;
  RAISE EXCEPTION 'ASSERTION FAILED [schema owner replaces a view it does not own]: statement was accepted';
END $f$;
SELECT pg_temp.try_replace();
DROP FUNCTION pg_temp.try_replace();
RESET ROLE;
REVOKE SELECT ON raw.customers FROM schema_owner_only;
REVOKE USAGE ON SCHEMA raw FROM schema_owner_only;
ALTER SCHEMA reporting OWNER TO retail_owner;
DROP ROLE schema_owner_only;
