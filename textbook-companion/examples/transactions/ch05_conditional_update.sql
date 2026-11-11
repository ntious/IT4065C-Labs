-- Listing 5.4 plus the application decision around it.
-- The DO block stands in for application code: confirm only if a row was updated.
SELECT set_config('app.req', :'req', false);
BEGIN;
DO $$
DECLARE n integer;
BEGIN
  UPDATE ops.inventory
     SET units_on_hand = units_on_hand - 1
   WHERE product_id = 1 AND units_on_hand >= 1;
  GET DIAGNOSTICS n = ROW_COUNT;
  PERFORM pg_sleep(2);          -- hold the row lock to force the other session to wait
  IF n = 1 THEN
    INSERT INTO ops.sales_log VALUES (current_setting('app.req'), 1);
    RAISE NOTICE '% CONFIRMED', current_setting('app.req');
  ELSE
    RAISE NOTICE '% DECLINED (no row updated)', current_setting('app.req');
  END IF;
END $$;
COMMIT;
