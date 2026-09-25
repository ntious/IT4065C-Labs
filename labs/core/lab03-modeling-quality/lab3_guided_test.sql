-- Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
-- Teaching example: each reported day has at least one completed order.
-- Copy into the dbt tests directory as instructed; execute with course.py lab 3.
-- A dbt data test returns violating rows. No rows means this rule passes.
select order_date, orders_count
from {{ ref('olap_sales_by_day') }}
where orders_count is null or orders_count <= 0
