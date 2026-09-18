-- Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
-- Synthetic customer dimension; names and masked contacts remain identifying.
-- This is partial masking, NOT anonymization. No unkeyed linkage hashes.
select customer_id, first_name, last_name,
       case when email is null then null else '***@' || split_part(email,'@',2) end as email_masked,
       case when phone_number is null then null else '***' || right(phone_number,2) end as phone_masked
from {{ ref('stg_customers') }}
