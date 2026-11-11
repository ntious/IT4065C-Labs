-- Returning NEW (which is NULL for DELETE) would silently skip every allowed delete.
\set ON_ERROR_STOP off
CREATE FUNCTION ops.block_completed_order_change() RETURNS trigger
LANGUAGE plpgsql AS $$
BEGIN
  IF OLD.order_status = 'completed' THEN
    RAISE EXCEPTION 'order % is completed and cannot be changed', OLD.order_id
      USING ERRCODE = 'check_violation';
  END IF;
  IF TG_OP = 'DELETE' THEN
    RETURN OLD;   -- allow the delete to proceed
  END IF;
  RETURN NEW;     -- allow the update to proceed
END;
$$;
CREATE TRIGGER orders_completed_immutable
BEFORE UPDATE OR DELETE ON ops.orders
FOR EACH ROW EXECUTE FUNCTION ops.block_completed_order_change();

\echo '--- allowed: update a pending order'
INSERT INTO ops.orders VALUES (7002, 2, 'pending');
UPDATE ops.orders SET customer_id = 4 WHERE order_id = 7002;
\echo '--- allowed: delete a pending order that has no dependent rows'
INSERT INTO ops.orders VALUES (7003, 2, 'pending');
DELETE FROM ops.orders WHERE order_id = 7003;
\echo '--- allowed: paid -> completed'
INSERT INTO ops.orders VALUES (7001, 2, 'paid');
UPDATE ops.orders SET order_status = 'completed' WHERE order_id = 7001;
\echo '--- rejected: change or delete a completed order'
UPDATE ops.orders SET customer_id = 3 WHERE order_id = 7001;
DELETE FROM ops.orders WHERE order_id = 7001;
\echo '--- final row state (expect 7001 completed/customer 2; 7002 pending/customer 4; no 7003)'
SELECT order_id, customer_id, order_status FROM ops.orders
 WHERE order_id IN (7001, 7002, 7003) ORDER BY order_id;
