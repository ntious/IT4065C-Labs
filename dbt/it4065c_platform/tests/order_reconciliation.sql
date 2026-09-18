-- Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
select o.order_id
from {{ ref('fct_orders') }} o
join {{ ref('fct_order_items') }} i on i.order_id=o.order_id
group by o.order_id,o.total_amount
having o.total_amount <> sum(i.line_total)
