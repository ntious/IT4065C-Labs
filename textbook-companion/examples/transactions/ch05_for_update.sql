-- Listing 5.5 plus the application decision: lock, read, decide, then write.
SELECT set_config('app.req', :'req', false);
BEGIN;
DO $$
DECLARE v integer;
BEGIN
  SELECT units_on_hand INTO v FROM ops.inventory WHERE product_id = 1 FOR UPDATE;
  PERFORM pg_sleep(2);
  IF v >= 1 THEN
    UPDATE ops.inventory SET units_on_hand = units_on_hand - 1 WHERE product_id = 1;
    INSERT INTO ops.sales_log VALUES (current_setting('app.req'), 1);
    RAISE NOTICE '% CONFIRMED (saw %)', current_setting('app.req'), v;
  ELSE
    RAISE NOTICE '% DECLINED (saw %)', current_setting('app.req'), v;
  END IF;
END $$;
COMMIT;
