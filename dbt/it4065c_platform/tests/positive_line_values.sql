select order_item_id from {{ ref('fct_order_items') }}
where quantity <= 0 or unit_price < 0 or line_total <> quantity * unit_price
