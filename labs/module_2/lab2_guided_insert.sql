-- Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
-- Guided practice: a complete example, not the independent assessment answer.
-- Prerequisite: run Lab 2 to create the register and its two baseline examples.
-- Run through scripts/query.py so {{schema}} is replaced safely.
-- Values below correspond to the seven named columns, in the same order.
-- Scenario assumptions: internal account administration and aggregate reporting.
-- The retention and AI-use text documents proposed policy; it does not enforce it.
-- Keep {{schema}}, quotes and SQL punctuation unchanged for the guided run.
-- ON CONFLICT skips an existing pair; it does not revise the stored decision.
-- For independent work, choose a different field and justify your own values.

INSERT INTO {{schema}}.data_classification_register
    (table_name, column_name, classification, rationale,
     owner_role, retention_rule, ai_use)
VALUES (
    'customers',
    'created_at',
    'Internal',
    'Supports account-age reporting; linked timestamps can reveal customer activity.',
    'Customer Data Steward',
    'Retain while needed for account administration; review before deletion and honor approved holds.',
    'Aggregate account-age reporting only; individual profiling requires a separate purpose review.'
)
ON CONFLICT (table_name, column_name) DO NOTHING;
