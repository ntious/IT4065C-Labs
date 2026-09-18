-- Roles are provisioned by local administrator, never dropped by a lab.
BEGIN;
REVOKE ALL ON SCHEMA raw FROM PUBLIC,{{analyst}},{{steward}};
REVOKE ALL ON SCHEMA {{schema}} FROM PUBLIC,{{analyst}},{{steward}};
REVOKE ALL ON ALL TABLES IN SCHEMA raw FROM PUBLIC,{{analyst}},{{steward}};
REVOKE ALL ON ALL TABLES IN SCHEMA {{schema}} FROM PUBLIC,{{analyst}},{{steward}};
GRANT USAGE ON SCHEMA {{schema}} TO {{analyst}},{{steward}};
GRANT SELECT ON {{schema}}.v_sales_by_day TO {{analyst}},{{steward}};
GRANT SELECT ON {{schema}}.v_customers_masked TO {{steward}};
COMMIT;
