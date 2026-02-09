-- 03_rbac_and_grants.sql
-- Purpose: Create roles and implement least-privilege access.
-- Re-runnable: cleans up prior privileges (DROP OWNED BY) before dropping roles.

DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'role_analyst') THEN
    EXECUTE 'DROP OWNED BY role_analyst';
    EXECUTE 'REVOKE ALL ON SCHEMA student_kofi FROM role_analyst';
    EXECUTE 'REVOKE ALL ON SCHEMA raw FROM role_analyst';
    EXECUTE 'DROP ROLE role_analyst';
  END IF;

  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'role_steward') THEN
    EXECUTE 'DROP OWNED BY role_steward';
    EXECUTE 'REVOKE ALL ON SCHEMA student_kofi FROM role_steward';
    EXECUTE 'REVOKE ALL ON SCHEMA raw FROM role_steward';
    EXECUTE 'DROP ROLE role_steward';
  END IF;

  IF EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'role_admin') THEN
    EXECUTE 'DROP OWNED BY role_admin';
    EXECUTE 'REVOKE ALL ON SCHEMA student_kofi FROM role_admin';
    EXECUTE 'REVOKE ALL ON SCHEMA raw FROM role_admin';
    EXECUTE 'DROP ROLE role_admin';
  END IF;
END $$;

CREATE ROLE role_analyst NOLOGIN;
CREATE ROLE role_steward NOLOGIN;
CREATE ROLE role_admin   NOLOGIN;

REVOKE ALL ON SCHEMA raw FROM PUBLIC;
REVOKE ALL ON SCHEMA student_kofi FROM PUBLIC;

GRANT USAGE ON SCHEMA student_kofi TO role_analyst, role_steward, role_admin;
GRANT USAGE ON SCHEMA raw TO role_admin;

GRANT SELECT ON student_kofi.v_sales_by_day TO role_analyst;

GRANT SELECT ON student_kofi.v_sales_by_day TO role_steward;
GRANT SELECT ON student_kofi.v_customers_masked TO role_steward;

GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA raw TO role_admin;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA student_kofi TO role_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA raw TO role_admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA student_kofi TO role_admin;

REVOKE ALL ON student_kofi.v_customers_raw_pii FROM role_analyst;
REVOKE ALL ON student_kofi.v_customers_raw_pii FROM role_steward;

SELECT 'OK: roles created + grants applied.' AS status;