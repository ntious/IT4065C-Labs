-- Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
-- FIXTURE ONLY: intentionally fabricated events for incident interpretation.
CREATE TABLE IF NOT EXISTS {{schema}}.audit_access_events (
 event_id integer PRIMARY KEY,event_ts timestamptz NOT NULL,actor_user text NOT NULL,
 action text NOT NULL,object_name text NOT NULL,success boolean NOT NULL);
INSERT INTO {{schema}}.audit_access_events VALUES
 (1,'2026-01-10 09:00Z','analyst_demo','SELECT','v_sales_by_day',true),
 (2,'2026-01-10 10:00Z','steward_demo','SELECT','v_customers_masked',true),
 (3,'2026-01-11 01:00Z','analyst_demo','DENIED','v_customers_raw_pii',false),
 (4,'2026-01-11 01:02Z','analyst_demo','DENIED','v_customers_raw_pii',false),
 (5,'2026-01-11 01:05Z','analyst_demo','DENIED','v_customers_raw_pii',false),
 (6,'2026-01-11 01:08Z','analyst_demo','ROLE_SWITCH','owner',false),
 (7,'2026-01-11 04:32Z','steward_demo','EXPORT','v_customers_masked',true)
ON CONFLICT(event_id) DO NOTHING;
