-- Grain: one row per day, completed orders only.
-- Average order value uses one row per order, avoiding join multiplication.
with order_totals as (
 select o.order_id, o.order_date, o.total_amount,
        sum(i.quantity) as items_sold, sum(i.line_total) as line_sales
 from {{ ref('fct_orders') }} o
 join {{ ref('fct_order_items') }} i on o.order_id=i.order_id
 where o.order_status='completed'
 group by o.order_id,o.order_date,o.total_amount
)
select order_date, count(*) as orders_count, sum(items_sold) as items_sold,
       sum(line_sales) as gross_sales, avg(total_amount) as avg_order_value
from order_totals group by order_date
