/*
===============================================================================
 Module 2 – Lab 3
 File: models/lab3/staging/stg_orders.sql

 Model Type:
 -----------
 dbt STAGING model (stg_*) — standardizes raw source data for consistent use.

 Purpose:
 --------
 This staging model provides a clean, consistent representation of order data
 from the raw source table `raw.orders`.

 In practice, raw order data often arrives with:
   - Inconsistent column names (orderDate vs order_date)
   - Mixed data types (dates as strings, amounts as text)
   - Extra operational fields that are not relevant for analytics
   - Fields that require governance review (payment method, totals)

 The staging layer exists to create a stable foundation for downstream models,
 such as:
   - `fct_orders` (core fact table)
   - OLTP-style detail views
   - OLAP-style aggregated metrics for dashboards

 IMPORTANT SAFETY / GOVERNANCE NOTES:
 -----------------------------------
 - This model is READ-ONLY and does not change the raw data.
 - Financial-related fields (e.g., total_amount) should be treated as sensitive
   in many organizations, even if not strictly regulated PII.
 - Payment-related fields (e.g., payment_method) may require restricted access,
   monitoring, or masking depending on policy.

 Student Expectations:
 ---------------------
 - You are NOT required to edit this file.
 - Your job in Lab 3 is to run dbt, validate outputs, and reason about design.

 Data Lineage (Conceptual):
 --------------------------
 raw.orders  -->  stg_orders  -->  fct_orders  --> marts/views

===============================================================================
*/

with src as (

    select
        *
    from {{ source('raw', 'orders') }}

),

standardized as (

    select

        cast(order_id as integer)                         as order_id,
        cast(customer_id as integer)                      as customer_id,

        /* Dates: cast to date for consistent aggregation */
        cast(order_date as date)                          as order_date,

        /* Standardize status text */
        lower(nullif(trim(order_status), ''))             as order_status,

        /* Amounts: cast to numeric for safe analytics */
        cast(total_amount as numeric(12,2))               as total_amount,

        /* Governance-sensitive metadata */
        lower(nullif(trim(payment_method), ''))           as payment_method

    from src

)

select
    order_id,
    customer_id,
    order_date,
    order_status,
    total_amount,
    payment_method
from standardized
