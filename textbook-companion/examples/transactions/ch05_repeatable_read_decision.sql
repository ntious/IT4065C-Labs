-- Listing 5.6: repeatable read, with the decision inside the retried unit of work.
SELECT set_config('app.req', :'req', false);
BEGIN ISOLATION LEVEL REPEATABLE READ;
DO $$
DECLARE v integer;
BEGIN
  SELECT units_on_hand INTO v FROM ops.inventory WHERE product_id = 1;
  PERFORM pg_sleep(2);
  IF v >= 1 THEN
    UPDATE ops.inventory SET units_on_hand = v - 1 WHERE product_id = 1;
    INSERT INTO ops.sales_log VALUES (current_setting('app.req'), 1);
    RAISE NOTICE '% CONFIRMED (saw %)', current_setting('app.req'), v;
  ELSE
    RAISE NOTICE '% DECLINED (saw %)', current_setting('app.req'), v;
  END IF;
END $$;
COMMIT;
