-- Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
-- SINGLE-INSTANCE simulation: snapshot staleness, not replication/failover.
BEGIN;
CREATE TEMP TABLE operational (id integer PRIMARY KEY,amount integer);
INSERT INTO operational VALUES (1,10);
CREATE TEMP TABLE analytics_snapshot AS SELECT * FROM operational;
INSERT INTO operational VALUES (2,20);
DO $$ BEGIN
 IF (SELECT count(*) FROM operational) - (SELECT count(*) FROM analytics_snapshot) <> 1
 THEN RAISE EXCEPTION 'Expected stale snapshot'; END IF;
END $$;
TRUNCATE analytics_snapshot;
INSERT INTO analytics_snapshot SELECT * FROM operational;
DO $$ BEGIN
 IF (SELECT sum(amount) FROM analytics_snapshot) <> 30 THEN RAISE EXCEPTION 'Refresh failed'; END IF;
END $$;
ROLLBACK;
