\set ON_ERROR_STOP on
-- Listing 10.5 (run in the restored copy): resurrection check, then ledger replay
SELECT count(*) AS customer_3_after_restore FROM raw.customers WHERE customer_id = 3;
SELECT to_regclass('raw.deletion_ledger') AS ledger_in_restored_copy;
-- The subject reference below stands in for an independently held ledger supplied from outside the
-- backup. It is a mechanism demonstration, not an implemented durable, authenticated ledger service.
CREATE TEMP TABLE replay_ledger (subject_ref text PRIMARY KEY);
INSERT INTO replay_ledger VALUES ('customer:3');
DELETE FROM raw.customers c USING replay_ledger l
 WHERE l.subject_ref = 'customer:' || c.customer_id;
SELECT count(*) AS customer_3_after_replay FROM raw.customers WHERE customer_id = 3;
SELECT count(*) AS dim_customer_rows_for_3_before_rebuild FROM core.dim_customer WHERE customer_id = 3;
SELECT eds_assert.expect_rows('Listing 10.4 replay', $q$
SELECT (SELECT count(*) FROM raw.customers WHERE customer_id = 3) AS source_after_replay,
       (SELECT count(*) FROM core.dim_customer WHERE customer_id = 3) AS restored_core_still,
       to_regclass('raw.deletion_ledger') IS NULL AS ledger_absent_in_restore$q$,
  $e$(0,1,t)$e$);
