-- Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
-- Fixed seed contract. Learner extensions should version their own expectation.
select 1 where (select sum(gross_sales) from {{ ref('olap_sales_by_day') }}) <> 139.95
