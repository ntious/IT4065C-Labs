-- Multi-product basket using conditional updates in one transaction.
-- Variables: req, items (comma-separated product ids, in the order they will be locked).
-- Any failed reservation raises an error, so the whole transaction rolls back.
SELECT set_config('app.req', :'req', false), set_config('app.items', :'items', false);
BEGIN;
DO $$
DECLARE pid integer; n integer;
BEGIN
  FOREACH pid IN ARRAY string_to_array(current_setting('app.items'), ',')::int[] LOOP
    UPDATE ops.inventory SET units_on_hand = units_on_hand - 1
     WHERE product_id = pid AND units_on_hand >= 1;
    GET DIAGNOSTICS n = ROW_COUNT;
    IF n = 0 THEN
      RAISE EXCEPTION '% DECLINED: product % unavailable', current_setting('app.req'), pid;
    END IF;
    PERFORM pg_sleep(1);
  END LOOP;
  INSERT INTO ops.sales_log VALUES (current_setting('app.req'), 0);
  RAISE NOTICE '% CONFIRMED basket %', current_setting('app.req'), current_setting('app.items');
END $$;
COMMIT;
