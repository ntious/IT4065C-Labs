-- ============================================================
-- Lab 2: Governance Classification Register
-- Purpose: Store data classification and ownership decisions
-- Schema: student workspace
-- ============================================================

CREATE TABLE IF NOT EXISTS student_kofi.data_classification_register (
  schema_name     TEXT NOT NULL,
  table_name      TEXT NOT NULL,
  column_name     TEXT NOT NULL,
  data_type       TEXT NOT NULL,
  classification  TEXT NOT NULL,
  rationale       TEXT NOT NULL,
  owner_role      TEXT NOT NULL,
  retention_type  TEXT NOT NULL,
  created_at      TIMESTAMP DEFAULT NOW()
);
