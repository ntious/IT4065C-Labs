SELECT i.order_item_id, i.order_id
FROM raw.order_items i
WHERE NOT EXISTS (SELECT 1 FROM raw.orders o WHERE o.order_id = i.order_id);
