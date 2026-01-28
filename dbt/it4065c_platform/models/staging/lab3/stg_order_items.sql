/*
===============================================================================
 Module 2 – Lab 3
 File: models/lab3/staging/stg_order_items.sql

 Model Type:
 -----------
 dbt STAGING model (stg_*) — standardizes raw source data for consistent use.

 Purpose:
 --------
 This staging model provides a clean, consistent representation of order
 line-item data from the raw source table `raw.order_items`.

 Line-item data sits at the most granular transactional level and is critical
 for:
   - Revenue calculations
   - Product-level analysis
   - Order reconciliation
   - Auditing and troubleshooting

 Because of this, order item tables often:
   - Contain large row counts
   - Reference multiple parent entities (orders, products)
   - Include numeric fields that must be interpreted carefully (quantity, price)

 The staging layer ensures that this granular data is:
   1) Structurally consistent
   2) Easy to reason about
   3) Safe to reuse across multiple downstream models

 IMPORTANT SAFETY / GOVERNANCE NOTES:
 -----------------------------------
 - Quantity and pricing fields directly affect financial reporting.
 - Errors at the line-item level can be amplified when aggregated.
 - Referential integrity (valid order_id and product_id values) is critical and
   will be enforced later using dbt relationship tests.
 - This model does NOT perform financial calculations beyond standardization.

 Student Expectations:
 ---------------------
 - You are NOT required to edit this file.
 - You should understand why line-item data is staged separately from orders.

 Data Lineage (Conceptual):
 --------------------------
 raw.order_items
        ↓
 stg_order_items
        ↓
 fct_order_items
        ↓
 marts (OLTP / OLAP views)

===============================================================================
*/

with src as (

    select
        *
    from {{ source('raw', 'order_items') }}

),

standardized as (

    select

        cast(order_item_id as integer)                    as order_item_id,
        cast(order_id as integer)                         as order_id,
        cast(product_id as integer)                       as product_id,

        cast(quantity as integer)                         as quantity,
        cast(unit_price as numeric(12,2))                 as unit_price

    from src

)

select
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price
from standardized
