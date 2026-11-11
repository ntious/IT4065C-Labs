```sql
SELECT event_date, COUNT(*) AS accepted_events,
       SUM(amount) AS amount
FROM {{ ref('approved_sales_events') }}
GROUP BY event_date
```

```sql
WITH candidates AS (
  SELECT s.sale_id, d.product_key
  FROM incoming_sales s
  LEFT JOIN product_map m
    ON m.source_system = s.source_system
   AND m.source_product_id = s.source_product_id
  LEFT JOIN product_versions d
    ON d.product_id = m.product_id
   AND s.sold_on BETWEEN d.valid_from AND d.valid_to
)
SELECT sale_id, COUNT(product_key) AS matching_versions
FROM candidates
GROUP BY sale_id
HAVING COUNT(product_key) <> 1;
```
