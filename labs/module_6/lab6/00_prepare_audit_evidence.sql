-- =====================================================================
-- 00_prepare_audit_evidence.sql
-- Module 6 – Lab 6: Monitoring Evidence & Compliance Reasoning
--
-- Purpose (Instructor-provided):
--   Create and seed a lightweight audit evidence table that is
--   *fully tied to Lab 5 objects* in schema: student_kofi
--
-- Design goals:
--   - Idempotent (safe to run multiple times)
--   - No logging configuration required
--   - Evidence is realistic and interpretable (for critical thinking)
--   - Tied to Lab 5 views:
--       student_kofi.v_sales_by_day
--       student_kofi.v_customers_masked
--       student_kofi.v_customers_raw_pii
-- =====================================================================

\pset pager off
\pset footer off
\set ON_ERROR_STOP on

\echo
\echo '============================================================'
\echo 'Module 6 Lab 6 — Step 0: Prepare Instructor-Provided Audit Evidence'
\echo 'Target schema: student_kofi'
\echo '============================================================'
\echo

-- ---------------------------------------------------------------------
-- 0) Pre-flight: Ensure Lab 5 "safe objects" exist
-- ---------------------------------------------------------------------
DO $$
DECLARE
  missing integer := 0;
BEGIN
  -- Ensure the schema exists (Lab 5 should have created it, but we guard anyway)
  IF NOT EXISTS (SELECT 1 FROM pg_namespace WHERE nspname = 'student_kofi') THEN
    RAISE EXCEPTION
      'Schema student_kofi not found. Complete Module 5 Lab 5 before running Lab 6.';
  END IF;

  -- Verify required Lab 5 views exist
  IF NOT EXISTS (
    SELECT 1
    FROM pg_views
    WHERE schemaname = 'student_kofi' AND viewname = 'v_sales_by_day'
  ) THEN missing := missing + 1; END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM pg_views
    WHERE schemaname = 'student_kofi' AND viewname = 'v_customers_masked'
  ) THEN missing := missing + 1; END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM pg_views
    WHERE schemaname = 'student_kofi' AND viewname = 'v_customers_raw_pii'
  ) THEN missing := missing + 1; END IF;

  IF missing > 0 THEN
    RAISE EXCEPTION
      'One or more Lab 5 required views are missing in student_kofi. Run Module 5 Lab 5 Step 2 first (build safe objects). Missing count=%',
      missing;
  END IF;
END $$;

\echo 'OK: Lab 5 views found (v_sales_by_day, v_customers_masked, v_customers_raw_pii).'
\echo

-- ---------------------------------------------------------------------
-- 1) Create the audit evidence table (lightweight, explainable)
--    NOTE: This is NOT a full logging system. It is "instructor-provided"
--          audit evidence for analysis.
-- ---------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS student_kofi.audit_access_events (
  event_id           bigserial PRIMARY KEY,
  event_ts           timestamptz NOT NULL DEFAULT now(),

  -- Who did it (simulated actors aligned to RBAC roles from Lab 5)
  actor_user         text        NOT NULL,  -- e.g., analyst_01, steward_01, admin_01
  actor_role         text        NOT NULL,  -- e.g., role_analyst, role_steward, role_admin

  -- What happened
  action             text        NOT NULL,  -- SELECT / DENIED / ROLE_SWITCH / EXPORT
  object_schema      text        NOT NULL,  -- student_kofi
  object_name        text        NOT NULL,  -- v_sales_by_day / v_customers_masked / v_customers_raw_pii
  success            boolean     NOT NULL,  -- true/false

  -- Context
  client_ip          text        NULL,
  app_name           text        NULL,      -- e.g., psql, dashboard, notebook
  query_fingerprint  text        NULL,      -- short label to group similar activity
  notes              text        NULL
);

-- Helpful indexes (small but practical)
CREATE INDEX IF NOT EXISTS ix_audit_access_events_ts
  ON student_kofi.audit_access_events (event_ts);

CREATE INDEX IF NOT EXISTS ix_audit_access_events_actor
  ON student_kofi.audit_access_events (actor_user, actor_role);

CREATE INDEX IF NOT EXISTS ix_audit_access_events_object
  ON student_kofi.audit_access_events (object_schema, object_name);

\echo 'OK: audit table ensured (student_kofi.audit_access_events).'
\echo

-- ---------------------------------------------------------------------
-- 2) Seed evidence only if empty (idempotent)
--    Evidence is tied to Lab 5 objects and typical governed behavior:
--      - Analysts: allowed to read sales + masked customers
--      - Analysts: denied from raw PII view
--      - Role-switch attempt: suspicious
--      - After-hours access: suspicious
--      - Export activity: review required
-- ---------------------------------------------------------------------
DO $$
DECLARE
  n bigint;
BEGIN
  SELECT count(*) INTO n FROM student_kofi.audit_access_events;

  IF n = 0 THEN
    INSERT INTO student_kofi.audit_access_events
      (event_ts, actor_user, actor_role, action, object_schema, object_name, success, client_ip, app_name, query_fingerprint, notes)
    VALUES
      -- ---------------------------
      -- Normal / expected activity
      -- ---------------------------
      (now() - interval '2 days' + interval '10 hours',
        'analyst_01','role_analyst','SELECT','student_kofi','v_sales_by_day', true,
        '10.10.1.20','dashboard','fp_sales_001','Routine dashboard refresh'),

      (now() - interval '2 days' + interval '11 hours',
        'analyst_02','role_analyst','SELECT','student_kofi','v_sales_by_day', true,
        '10.10.1.21','dashboard','fp_sales_001','Routine dashboard refresh'),

      (now() - interval '2 days' + interval '12 hours',
        'analyst_01','role_analyst','SELECT','student_kofi','v_customers_masked', true,
        '10.10.1.20','notebook','fp_cust_mask_001','Masked customer review for analytics'),

      -- ---------------------------
      -- Suspicious: repeated denied attempts on raw PII view
      -- (tied directly to Lab 5 object v_customers_raw_pii)
      -- ---------------------------
      (now() - interval '1 day' + interval '01 hours',
        'analyst_02','role_analyst','DENIED','student_kofi','v_customers_raw_pii', false,
        '10.10.1.21','psql','fp_pii_009','Attempted access to raw PII (should be restricted)'),

      (now() - interval '1 day' + interval '01 hours' + interval '2 minutes',
        'analyst_02','role_analyst','DENIED','student_kofi','v_customers_raw_pii', false,
        '10.10.1.21','psql','fp_pii_009','Repeated denied attempt'),

      (now() - interval '1 day' + interval '01 hours' + interval '5 minutes',
        'analyst_02','role_analyst','DENIED','student_kofi','v_customers_raw_pii', false,
        '10.10.1.21','psql','fp_pii_009','Repeated denied attempt'),

      -- ---------------------------
      -- Suspicious: role-switch attempt (privilege escalation behavior)
      -- ---------------------------
      (now() - interval '1 day' + interval '01 hours' + interval '8 minutes',
        'analyst_02','role_analyst','ROLE_SWITCH','student_kofi','v_customers_raw_pii', false,
        '10.10.1.21','psql','fp_role_002','Tried SET ROLE role_admin to reach raw PII'),

      -- ---------------------------
      -- Review-needed: export from masked view (may be OK, but should be justified)
      -- ---------------------------
      (now() - interval '20 hours',
        'steward_01','role_steward','EXPORT','student_kofi','v_customers_masked', true,
        '10.10.2.10','notebook','fp_export_010','Exported masked customer data for quality review'),

      -- ---------------------------
      -- Benign admin verification (expected)
      -- ---------------------------
      (now() - interval '6 hours',
        'admin_01','role_admin','SELECT','student_kofi','v_customers_raw_pii', true,
        '10.10.9.9','psql','fp_admin_001','Admin verification query (authorized)');

  END IF;
END $$;

\echo 'OK: evidence seeded (only if table was empty).'
\echo

-- ---------------------------------------------------------------------
-- 3) Quick confirmation for instructors/students
-- ---------------------------------------------------------------------
\echo '--- Evidence Snapshot (latest 10 events) ---'
SELECT
  event_ts,
  actor_user,
  actor_role,
  action,
  (object_schema || '.' || object_name) AS object,
  success,
  client_ip,
  app_name,
  notes
FROM student_kofi.audit_access_events
ORDER BY event_ts DESC
LIMIT 10;

\echo
\echo '============================================================'
\echo 'Step 0 complete. Students will use this as "provided audit evidence".'
\echo '============================================================'
\echo