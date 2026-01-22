with src as (
    select * from raw.customers
)
select
    customer_id,
    first_name,
    last_name,
    email,
    phone_number,
    created_at
from src
