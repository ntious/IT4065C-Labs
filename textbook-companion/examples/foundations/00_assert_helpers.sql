-- Assertion helpers for the Chapters 1-3 validation package (textbook; AUTH).
-- Loaded first by run_all.sh into the run's own disposable database.
-- expect_error: runs one statement that SHOULD be rejected. Passes only if it fails with the
--   expected SQLSTATE; the statement's effects are rolled back either way. A statement that is
--   accepted, or that fails with a different SQLSTATE, raises an error and stops the run.
-- expect_rows: runs a query and compares its rows (as text, sorted) with the expected value.
DROP SCHEMA IF EXISTS eds_assert CASCADE;
CREATE SCHEMA eds_assert;

CREATE FUNCTION eds_assert.expect_error(label text, stmt text, expected_state text)
RETURNS text LANGUAGE plpgsql AS $$
DECLARE got_state text; got_msg text;
BEGIN
  BEGIN
    EXECUTE stmt;
  EXCEPTION WHEN OTHERS THEN
    GET STACKED DIAGNOSTICS got_state = RETURNED_SQLSTATE, got_msg = MESSAGE_TEXT;
  END;
  IF got_state IS NULL THEN
    RAISE EXCEPTION 'ASSERTION FAILED [%]: statement was accepted; expected SQLSTATE %', label, expected_state;
  ELSIF got_state <> expected_state THEN
    RAISE EXCEPTION 'ASSERTION FAILED [%]: got SQLSTATE % (%); expected %', label, got_state, got_msg, expected_state;
  END IF;
  RETURN format('PASS [%s] rejected as expected: %s %s', label, got_state, got_msg);
END $$;

CREATE FUNCTION eds_assert.rows_as_text(q text)
RETURNS text LANGUAGE plpgsql AS $$
DECLARE r text;
BEGIN
  EXECUTE format('SELECT coalesce(string_agg(t::text, %L ORDER BY t::text), %L) FROM (%s) AS t', '; ', '(no rows)', q)
    INTO r;
  RETURN r;
END $$;

CREATE FUNCTION eds_assert.expect_rows(label text, q text, expected text)
RETURNS text LANGUAGE plpgsql AS $$
DECLARE got text := eds_assert.rows_as_text(q);
BEGIN
  IF got IS DISTINCT FROM expected THEN
    RAISE EXCEPTION 'ASSERTION FAILED [%]: got <%>; expected <%>', label, got, expected;
  END IF;
  RETURN format('PASS [%s] %s', label, got);
END $$;
