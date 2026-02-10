-- =====================================================================
-- 01_generate_audit_report.sql
-- Module 6 – Lab 6: Monitoring Evidence & Compliance Reasoning
--
-- Purpose (Student-facing):
--   Generate a clean, readable "audit & monitoring report" from the
--   instructor-provided evidence table:
--     student_kofi.audit_access_events
--
-- Design goals:
--   - Student-readable sections (clear headings + short tables)
--   - Explainable heuristics (no ML, no complex tooling)
--   - Output is directly usable as Step 1 "provided audit evidence"
--   - Highlights likely incidents students can analyze in Steps 2–4
-- =====================================================================

\pset pager off
\pset footer off
\pset null '(null)'
\set ON_ERROR_STOP on

\echo
\echo '============================================================'
\echo 'MODULE 6 — LAB 6: AUDIT & MONITORING REPORT'
\echo '============================================================'
\echo

-- ---------------------------------------------------------------------
-- SECTION 0 — PRECHECK (make sure evidence exists)
-- ---------------------------------------------------------------------
\echo 'SECTION 0 — Precheck'
\echo 'What this checks: the audit evidence table exists and has rows.'
\echo

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1
    FROM information_schema.tables
    WHERE table_schema='student_kofi' AND table_name='audit_access_events'
  ) THEN
    RAISE EXCEPTION
      'Audit evidence table student_kofi.audit_access_events not found. Run 00_prepare_audit_evidence.sql first.';
  END IF;

  IF (SELECT count(*) FROM student_kofi.audit_access_events) = 0 THEN
    RAISE EXCEPTION
      'Audit evidence table is empty. Run 00_prepare_audit_evidence.sql to seed incident data.';
  END IF;
END $$;

\echo '✅ Precheck passed: evidence table is present and non-empty.'
\echo

-- ---------------------------------------------------------------------
-- SECTION 1 — EVIDENCE OVERVIEW (context)
-- ---------------------------------------------------------------------
\echo 'SECTION 1 — Evidence Overview'
\echo 'Goal: understand the size and time range of the evidence.'
\echo

SELECT
  current_database()                                 AS database,
  'student_kofi.audit_access_events'                 AS evidence_source,
  count(*)                                           AS total_events,
  min(event_ts)                                      AS first_event_ts,
  max(event_ts)                                      AS last_event_ts,
  round(extract(epoch from (max(event_ts)-min(event_ts))) / 3600.0, 2)
                                                     AS hours_covered
FROM student_kofi.audit_access_events;

\echo
\echo 'SECTION 1b — Events by Action'
\echo 'Goal: see what types of activity occurred (SELECT, DENIED, EXPORT, etc.).'
\echo

SELECT
  action,
  count(*) AS events
FROM student_kofi.audit_access_events
GROUP BY action
ORDER BY events DESC, action;

\echo
\echo 'SECTION 1c — Events by Actor (Who is most active?)'
\echo

SELECT
  actor_user,
  actor_role,
  count(*) AS events
FROM student_kofi.audit_access_events
GROUP BY actor_user, actor_role
ORDER BY events DESC, actor_user;

\echo
\echo 'SECTION 1d — Events by Object (What was accessed most?)'
\echo

SELECT
  object_schema || '.' || object_name AS object,
  count(*) AS events
FROM student_kofi.audit_access_events
GROUP BY object_schema, object_name
ORDER BY events DESC, object;

\echo
\echo '------------------------------------------------------------'
\echo 'NOTE: Everything below this point is "monitoring analysis."'
\echo 'These sections help you spot suspicious behavior and write findings.'
\echo '------------------------------------------------------------'
\echo

-- ---------------------------------------------------------------------
-- SECTION 2 — HIGH-SIGNAL: FAILED / DENIED ACCESS
-- ---------------------------------------------------------------------
\echo 'SECTION 2 — Failed or Denied Access Attempts (High Signal)'
\echo 'Why this matters: repeated denied access often indicates probing or misuse.'
\echo

SELECT
  actor_user,
  actor_role,
  object_schema || '.' || object_name AS object,
  count(*)                            AS denied_attempts,
  min(event_ts)                       AS first_seen,
  max(event_ts)                       AS last_seen
FROM student_kofi.audit_access_events
WHERE success = false OR action = 'DENIED'
GROUP BY actor_user, actor_role, object_schema, object_name
ORDER BY denied_attempts DESC, last_seen DESC;

\echo
\echo 'SECTION 2b — Denied Access Timeline (Most recent first)'
\echo

SELECT
  event_ts,
  actor_user,
  actor_role,
  action,
  object_schema || '.' || object_name AS object,
  success,
  client_ip,
  app_name,
  notes
FROM student_kofi.audit_access_events
WHERE success = false OR action = 'DENIED'
ORDER BY event_ts DESC;

-- ---------------------------------------------------------------------
-- SECTION 3 — ROLE SWITCH ATTEMPTS (privilege escalation behavior)
-- ---------------------------------------------------------------------
\echo
\echo 'SECTION 3 — Role Switch Attempts'
\echo 'Why this matters: role switching can be legitimate for admins,'
\echo 'but suspicious if done by non-admin accounts.'
\echo

SELECT
  event_ts,
  actor_user,
  actor_role,
  action,
  object_schema || '.' || object_name AS object,
  success,
  client_ip,
  app_name,
  notes
FROM student_kofi.audit_access_events
WHERE action = 'ROLE_SWITCH'
ORDER BY event_ts DESC;

-- ---------------------------------------------------------------------
-- SECTION 4 — AFTER-HOURS ACTIVITY (simple anomaly rule)
-- ---------------------------------------------------------------------
\echo
\echo 'SECTION 4 — After-Hours Activity'
\echo 'Rule used: flag events outside typical business hours (07:00–19:00).'
\echo 'Why this matters: unusual timing can indicate misuse or account compromise.'
\echo

SELECT
  event_ts,
  actor_user,
  actor_role,
  action,
  object_schema || '.' || object_name AS object,
  success,
  client_ip,
  app_name,
  notes
FROM student_kofi.audit_access_events
WHERE EXTRACT(HOUR FROM event_ts) < 7 OR EXTRACT(HOUR FROM event_ts) > 19
ORDER BY event_ts DESC;

-- ---------------------------------------------------------------------
-- SECTION 5 — SENSITIVE OBJECT FOCUS (course-aligned)
-- ---------------------------------------------------------------------
\echo
\echo 'SECTION 5 — Sensitive Object Focus'
\echo 'In this course, objects related to customers/PII are treated as sensitive.'
\echo 'This section filters events involving likely-sensitive objects.'
\echo

SELECT
  event_ts,
  actor_user,
  actor_role,
  action,
  object_schema || '.' || object_name AS object,
  success,
  app_name,
  notes
FROM student_kofi.audit_access_events
WHERE lower(object_name) LIKE '%customer%'
   OR lower(object_name) LIKE '%pii%'
   OR lower(object_name) LIKE '%raw%'
ORDER BY event_ts DESC;

-- ---------------------------------------------------------------------
-- SECTION 6 — EXPORT ACTIVITY (compliance / data handling)
-- ---------------------------------------------------------------------
\echo
\echo 'SECTION 6 — Export Activity (Handling & Compliance)'
\echo 'Why this matters: exports create data copies outside the platform.'
\echo 'Admins typically require justification, ticketing, or approval.'
\echo

SELECT
  event_ts,
  actor_user,
  actor_role,
  action,
  object_schema || '.' || object_name AS object,
  success,
  client_ip,
  app_name,
  notes
FROM student_kofi.audit_access_events
WHERE action = 'EXPORT'
ORDER BY event_ts DESC;

-- ---------------------------------------------------------------------
-- SECTION 7 — CANDIDATE INCIDENTS (ready-to-analyze list)
-- ---------------------------------------------------------------------
\echo
\echo 'SECTION 7 — Candidate Incidents (Ready for Your Findings)'
\echo 'This section applies simple, explainable rules to flag events that'
\echo 'are worth writing about in your report.'
\echo
\echo 'Incident rules used:'
\echo '  A) REPEATED_DENIED_ACCESS: denied attempts >= 3 to same object'
\echo '  B) ROLE_SWITCH_ATTEMPT: any ROLE_SWITCH event (especially by non-admin)'
\echo '  C) AFTER_HOURS_SENSITIVE_ACCESS: after-hours access to sensitive objects'
\echo

WITH denied_counts AS (
  SELECT
    actor_user,
    object_schema,
    object_name,
    count(*) AS denied_attempts
  FROM student_kofi.audit_access_events
  WHERE action = 'DENIED' OR success = false
  GROUP BY actor_user, object_schema, object_name
),
flagged AS (
  SELECT
    e.event_ts,
    e.actor_user,
    e.actor_role,
    e.action,
    (e.object_schema || '.' || e.object_name) AS object,
    e.success,
    COALESCE(d.denied_attempts, 0) AS denied_attempts_for_object,
    CASE
      WHEN COALESCE(d.denied_attempts, 0) >= 3 THEN 'REPEATED_DENIED_ACCESS'
      WHEN e.action = 'ROLE_SWITCH' THEN 'ROLE_SWITCH_ATTEMPT'
      WHEN (EXTRACT(HOUR FROM e.event_ts) < 7 OR EXTRACT(HOUR FROM e.event_ts) > 19)
        AND (lower(e.object_name) LIKE '%customer%'
          OR lower(e.object_name) LIKE '%pii%'
          OR lower(e.object_name) LIKE '%raw%')
        THEN 'AFTER_HOURS_SENSITIVE_ACCESS'
      ELSE NULL
    END AS incident_flag,
    e.client_ip,
    e.app_name,
    e.notes
  FROM student_kofi.audit_access_events e
  LEFT JOIN denied_counts d
    ON d.actor_user = e.actor_user
   AND d.object_schema = e.object_schema
   AND d.object_name = e.object_name
)
SELECT
  event_ts,
  actor_user,
  actor_role,
  action,
  object,
  success,
  denied_attempts_for_object,
  incident_flag,
  client_ip,
  app_name,
  notes
FROM flagged
WHERE incident_flag IS NOT NULL
ORDER BY event_ts DESC;

-- ---------------------------------------------------------------------
-- SECTION 8 — AUDIT EVIDENCE CHECKLIST (helps student writing)
-- ---------------------------------------------------------------------
\echo
\echo 'SECTION 8 — Audit Evidence Checklist (Use in Your Write-up)'
\echo 'When writing your Lab 6 summary, strong audit answers include:'
\echo '  - WHO: actor_user and actor_role'
\echo '  - WHAT: object accessed (schema.object)'
\echo '  - WHEN: timestamps (event_ts)'
\echo '  - RESULT: success/denied'
\echo '  - WHY IT MATTERS: policy/compliance impact'
\echo '  - NEXT ACTION: reasonable administrative follow-up'
\echo

\echo '============================================================'
\echo 'END OF REPORT'
\echo 'Use the sections above as your "provided audit evidence" for Lab 6.'
\echo '============================================================'
\echo
