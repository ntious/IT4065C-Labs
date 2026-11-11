WITH line_totals AS (
  SELECT order_id,
         COUNT(*)                              AS line_count,
         SUM(quantity * price_at_purchase)     AS line_total
  FROM raw.order_items
  GROUP BY order_id
)
SELECT o.order_id, o.total_amount, l.line_count, l.line_total,
       CASE WHEN l.order_id IS NULL             THEN 'no lines'
            WHEN l.line_total <> o.total_amount THEN 'amount mismatch'
       END AS exception
FROM raw.orders o
LEFT JOIN line_totals l ON l.order_id = o.order_id
WHERE l.order_id IS NULL
   OR l.line_total <> o.total_amount
ORDER BY o.order_id;
