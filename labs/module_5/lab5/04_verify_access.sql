-- 04_verify_access.sql
-- Purpose: Run PASS/FAIL checks by switching roles using SET ROLE.
-- Run this script as postgres (admin).

\echo
\echo '== Verification: Expected PASS/FAIL outcomes (RBAC + masking) =='
\echo 'Legend: PASS means allowed, FAIL means correctly denied.'
\echo

SELECT current_user AS connected_as, current_role AS current_role;

-- A) Analyst role
\echo '--- Role: role_analyst (should access analytics only) ---'
SET ROLE role_analyst;

\echo 'PASS: analyst can read v_sales_by_day'
SELECT COUNT(*) AS rows_from_sales_by_day FROM student_kofi.v_sales_by_day;

\echo 'FAIL (expected): analyst cannot read raw.customers'
SELECT COUNT(*) FROM raw.customers;

\echo 'FAIL (expected): analyst cannot read masked customer view (not granted)'
SELECT COUNT(*) FROM student_kofi.v_customers_masked;

\echo 'FAIL (expected): analyst cannot read raw PII view'
SELECT COUNT(*) FROM student_kofi.v_customers_raw_pii;

RESET ROLE;

-- B) Steward role
\echo
\echo '--- Role: role_steward (should access analytics + masked customers) ---'
SET ROLE role_steward;

\echo 'PASS: steward can read v_sales_by_day'
SELECT COUNT(*) AS rows_from_sales_by_day FROM student_kofi.v_sales_by_day;

\echo 'PASS: steward can read v_customers_masked'
SELECT COUNT(*) AS rows_from_customers_masked FROM student_kofi.v_customers_masked;

\echo 'FAIL (expected): steward cannot read raw.customers'
SELECT COUNT(*) FROM raw.customers;

\echo 'FAIL (expected): steward cannot read raw PII view'
SELECT COUNT(*) FROM student_kofi.v_customers_raw_pii;

RESET ROLE;

-- C) Admin role
\echo
\echo '--- Role: role_admin (should access everything) ---'
SET ROLE role_admin;

\echo 'PASS: admin can read raw.customers'
SELECT COUNT(*) AS rows_from_raw_customers FROM raw.customers;

\echo 'PASS: admin can read raw PII view'
SELECT COUNT(*) AS rows_from_raw_pii_view FROM student_kofi.v_customers_raw_pii;

\echo 'PASS: admin can read masked customers'
SELECT COUNT(*) AS rows_from_masked_view FROM student_kofi.v_customers_masked;

\echo 'PASS: admin can read analytics view'
SELECT COUNT(*) AS rows_from_sales_by_day FROM student_kofi.v_sales_by_day;

RESET ROLE;

\echo
\echo '== End verification =='
