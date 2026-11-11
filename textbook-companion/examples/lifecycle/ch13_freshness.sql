\set ON_ERROR_STOP on
-- Chapter 13 textbook example (AUTH + AUTH-OBS): freshness over an expected-product inventory.
-- Fixture (textbook teaching tables; the dates follow the chapter's Friday-to-Monday timeline):
--   Fri 6 Nov data published Sat 7 Nov; Sat data blocked Sun 8 Nov; Sun data blocked Mon 9 Nov.
-- Case assumptions: business time zone UTC; prior-day coverage required by 08:00.
CREATE TEMP TABLE expected_product (product text PRIMARY KEY, deadline time NOT NULL);
CREATE TEMP TABLE publication_log (
  publication_id int PRIMARY KEY, product text NOT NULL, attempt_at timestamptz NOT NULL,
  status text NOT NULL CHECK (status IN ('published','blocked_by_gate','withdrawn')), covers_through date);
-- The publication currently served to consumers (maintained by the publishing step; one row per product).
CREATE TEMP TABLE active_publication (
  product text PRIMARY KEY, publication_id int NOT NULL REFERENCES publication_log, covers_through date);

INSERT INTO expected_product VALUES
 ('daily_sales','08:00'), ('store_inventory','08:00'), ('returns_summary','08:00'),
 ('loyalty_extract','08:00'), ('promo_calendar','08:00'), ('margin_report','08:00');
INSERT INTO publication_log VALUES
 -- daily_sales: the chapter's scenario
 (1,'daily_sales','2026-11-07 06:00+00','published',DATE '2026-11-06'),
 (2,'daily_sales','2026-11-08 07:40+00','blocked_by_gate',NULL),
 (3,'daily_sales','2026-11-09 07:39+00','blocked_by_gate',NULL),
 -- store_inventory: fresh
 (4,'store_inventory','2026-11-09 06:10+00','published',DATE '2026-11-08'),
 -- returns_summary: a Nov 8 publication was withdrawn; consumers are served the older Nov 6 one
 (5,'returns_summary','2026-11-07 06:05+00','published',DATE '2026-11-06'),
 (6,'returns_summary','2026-11-09 06:20+00','published',DATE '2026-11-08'),
 (7,'returns_summary','2026-11-09 07:05+00','withdrawn',NULL),
 -- loyalty_extract: never published; its only attempt was blocked
 (8,'loyalty_extract','2026-11-09 07:30+00','blocked_by_gate',NULL),
 -- margin_report: served publication has no recorded coverage
 (9,'margin_report','2026-11-09 06:45+00','published',NULL);
 -- promo_calendar: expected, but no attempt at all
INSERT INTO active_publication VALUES
 ('daily_sales',1,DATE '2026-11-06'), ('store_inventory',4,DATE '2026-11-08'),
 ('returns_summary',5,DATE '2026-11-06'), ('margin_report',9,NULL);

-- Listing 13.1
\set evaluated_at '2026-11-09 08:20+00'
WITH params AS (
  SELECT :'evaluated_at'::timestamptz AS evaluated_at),
last_attempt AS (
  SELECT DISTINCT ON (product) product, attempt_at, status
  FROM publication_log
  ORDER BY product, attempt_at DESC),
required AS (
  SELECT e.product,
         CASE WHEN p.evaluated_at::time >= e.deadline
              THEN p.evaluated_at::date - 1
              ELSE p.evaluated_at::date - 2 END AS required_through,
         p.evaluated_at::date AS evaluation_date
  FROM expected_product e CROSS JOIN params p)
SELECT r.product, a.attempt_at AS last_attempt, a.status AS last_status,
       s.covers_through AS served_through, r.required_through,
       r.evaluation_date - s.covers_through AS data_age_days,
       r.required_through - s.covers_through AS days_late,
       CASE WHEN a.product IS NULL THEN 'NO_ATTEMPT'
            WHEN s.product IS NULL THEN 'NO_PUBLICATION'
            WHEN s.covers_through IS NULL THEN 'UNKNOWN'
            WHEN s.covers_through >= r.required_through THEN 'FRESH'
            ELSE 'STALE' END AS freshness
FROM required r
LEFT JOIN last_attempt a USING (product)
LEFT JOIN active_publication s USING (product)
ORDER BY r.product;

-- The same logic as a function of the evaluation time, so expected outcomes can be asserted.
CREATE FUNCTION pg_temp.freshness_at(evaluated_at timestamptz)
RETURNS TABLE(product text, data_age_days int, days_late int, freshness text) LANGUAGE sql AS $f$
WITH last_attempt AS (SELECT DISTINCT ON (product) product, attempt_at, status FROM publication_log ORDER BY product, attempt_at DESC),
required AS (SELECT e.product, CASE WHEN evaluated_at::time >= e.deadline THEN evaluated_at::date - 1 ELSE evaluated_at::date - 2 END AS required_through,
                    evaluated_at::date AS evaluation_date FROM expected_product e)
SELECT r.product, r.evaluation_date - s.covers_through, r.required_through - s.covers_through,
       CASE WHEN a.product IS NULL THEN 'NO_ATTEMPT' WHEN s.product IS NULL THEN 'NO_PUBLICATION' WHEN s.covers_through IS NULL THEN 'UNKNOWN'
            WHEN s.covers_through >= r.required_through THEN 'FRESH' ELSE 'STALE' END
FROM required r LEFT JOIN last_attempt a USING (product) LEFT JOIN active_publication s USING (product) $f$;
SELECT eds_assert.expect_rows('Listing 13.1 at 08:20 Monday: each expected product once, every state distinct',
 $q$SELECT * FROM pg_temp.freshness_at('2026-11-09 08:20+00')$q$,
 $e$(daily_sales,3,2,STALE); (loyalty_extract,,,NO_PUBLICATION); (margin_report,,,UNKNOWN); (promo_calendar,,,NO_ATTEMPT); (returns_summary,3,2,STALE); (store_inventory,1,0,FRESH)$e$);
SELECT eds_assert.expect_rows('before the 08:00 deadline, Sunday coverage is not yet required',
 $q$SELECT * FROM pg_temp.freshness_at('2026-11-09 07:30+00') WHERE product IN ('daily_sales','store_inventory')$q$,
 $e$(daily_sales,3,1,STALE); (store_inventory,1,-1,FRESH)$e$);
-- that is Nov 8 (it would have reported FRESH) although consumers are served the Nov 6 publication.
SELECT eds_assert.expect_rows('historical maximum differs from served publication', $q$
SELECT max(covers_through) FROM publication_log WHERE product = 'returns_summary' AND status = 'published'$q$, $e$(2026-11-08)$e$);
