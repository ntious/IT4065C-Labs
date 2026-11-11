-- Transfer case (Chapter 5): an exclusion constraint forbidding overlapping reservations of one kit.
-- Requires the btree_gist extension (shipped with PostgreSQL contrib) for the integer equality part.
\set ON_ERROR_STOP off
CREATE EXTENSION IF NOT EXISTS btree_gist;
DROP TABLE IF EXISTS ops.kit_reservation;
CREATE TABLE ops.kit_reservation (
  kit_id integer NOT NULL,
  during tsrange NOT NULL,
  EXCLUDE USING gist (kit_id WITH =, during WITH &&)
);
INSERT INTO ops.kit_reservation VALUES (1, '[2026-11-10 09:00, 2026-11-10 12:00)');  -- accepted
INSERT INTO ops.kit_reservation VALUES (1, '[2026-11-10 11:00, 2026-11-10 13:00)');  -- overlaps: rejected
INSERT INTO ops.kit_reservation VALUES (1, '[2026-11-10 12:00, 2026-11-10 13:00)');  -- touches end: accepted
SELECT kit_id, during FROM ops.kit_reservation ORDER BY during;
