-- ============================================================
-- Lab 2: Governance Register Verification Script
-- Purpose:
--   1. Confirm classification entries exist
--   2. Review distribution by table and classification
--   3. Spot missing or unexpected entries
--
-- Instructions:
--   Run this script after completing your INSERTs.
--   Review the output carefully.
-- ============================================================


-- ------------------------------------------------------------
-- Check 1: How many columns were classified per table?
-- ------------------------------------------------------------
SELECT
  table_name,
  COUNT(*) AS classified_columns
FROM student_kofi.data_classification_register
GROUP BY table_name
ORDER BY table_name;


-- ------------------------------------------------------------
-- Check 2: Review all classification entries
-- ------------------------------------------------------------
SELECT
  schema_name,
  table_name,
  column_name,
  classification,
  owner_role,
  retention_type,
  rationale
FROM student_kofi.data_classification_register
ORDER BY table_name, column_name;


-- ------------------------------------------------------------
-- Check 3 (Optional): Distribution by classification level
-- ------------------------------------------------------------
SELECT
  classification,
  COUNT(*) AS column_count
FROM student_kofi.data_classification_register
GROUP BY classification
ORDER BY column_count DESC;

-- ============================================================
-- End of verification script
-- ============================================================
