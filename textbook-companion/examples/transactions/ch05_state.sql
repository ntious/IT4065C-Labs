SELECT (SELECT count(*) FROM ops.orders            WHERE order_id = :oid) AS orders,
       (SELECT count(*) FROM ops.order_items       WHERE order_id = :oid) AS order_items,
       (SELECT count(*) FROM ops.payments          WHERE order_id = :oid) AS payment_rows,
       (SELECT count(*) FROM ops.shipment_requests WHERE order_id = :oid) AS shipment_requests,
       (SELECT order_status FROM ops.orders        WHERE order_id = :oid) AS order_status,
       (SELECT units_on_hand FROM ops.inventory    WHERE product_id = 1)  AS units_on_hand;
