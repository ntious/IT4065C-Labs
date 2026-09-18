-- Transaction-scoped experiment leaves the course dataset unchanged.
BEGIN;
CREATE TEMP TABLE retention_records (id integer PRIMARY KEY,expired boolean,legal_hold boolean);
INSERT INTO retention_records VALUES (1,true,false),(2,true,true),(3,false,false);
CREATE TEMP TABLE deletion_ledger (id integer PRIMARY KEY);
INSERT INTO deletion_ledger SELECT id FROM retention_records WHERE expired AND NOT legal_hold;
CREATE TEMP TABLE simulated_backup AS SELECT * FROM retention_records;
DELETE FROM retention_records WHERE id IN (SELECT id FROM deletion_ledger);
DO $$ BEGIN
 IF (SELECT count(*) FROM retention_records) <> 2 OR NOT EXISTS (SELECT 1 FROM retention_records WHERE id=2)
 THEN RAISE EXCEPTION 'Retention or legal hold failed'; END IF;
END $$;
-- Restore the snapshot, then replay the deletion ledger.
TRUNCATE retention_records;
INSERT INTO retention_records SELECT * FROM simulated_backup;
DELETE FROM retention_records WHERE id IN (SELECT id FROM deletion_ledger);
DO $$ BEGIN
 IF EXISTS (SELECT 1 FROM retention_records WHERE id=1) THEN RAISE EXCEPTION 'Deleted record resurrected'; END IF;
END $$;
ROLLBACK;
