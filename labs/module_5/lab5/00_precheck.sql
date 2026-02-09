-- 00_precheck.sql
-- Purpose: Ensure the minimum database structure exists for this lab.
-- Safe to run multiple times.

DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_namespace WHERE nspname = 'raw') THEN
    EXECUTE 'CREATE SCHEMA raw';
  END IF;

  IF NOT EXISTS (SELECT 1 FROM pg_namespace WHERE nspname = 'student_kofi') THEN
    EXECUTE 'CREATE SCHEMA student_kofi';
  END IF;
END $$;

SELECT 'OK: schemas raw + student_kofi are present.' AS status;
