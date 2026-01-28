/*
===============================================================================
 Module 2 – Lab 3
 File: models/lab3/core/fct_order_items.sql

 Model Type:
 -----------
 dbt CORE model (fact table) — line-item–level transactional events.

 Purpose:
 --------
 This model creates a LINE-ITEM FACT table (`fct_order_items`) from the
 standardized staging model `stg_order_items`.

 Unlike `fct_orders`, which has one row per order, this table operates at a
 finer grain:
   - One row = one product line item within an order

 This level of detail is essential for:
   - Product-level sales analysis
   - Revenue breakdowns
   - Quantity-based metrics
   - Accurate aggregation in OLAP models

 Why a separate line-item fact table?
 ------------------------------------
 Many analytical questions cannot be answered correctly at the order level,
 such as:
   - How many units of each product were sold?
   - Which products drive the most revenue?
   - How does pricing vary across products?

 Storing line items separately avoids:
   - Double counting
   - Over-aggregation
   - Loss of detail needed for audits and analysis

 IMPORTANT SAFETY / GOVERNANCE NOTES:
 -----------------------------------
 - Line-item data directly affects financial reporting.
 - Small errors at this level can scale into large reporting inaccuracies.
 - Referential integrity is critical:
     * Every order_item must reference a valid order
     * Every order_item must reference a valid product
 - These constraints are enforced later using dbt relationship tests.

 Student Expectations:
 ---------------------
 - You are NOT required to edit this file.
 - You should understand why the grain of this table differs from `fct_orders`.

 Data Lineage (Conceptual):
 --------------------------
 raw.order_items
        ↓
 stg_order_items
        ↓
 fct_order_items
        ↓
 marts (OLTP detail / OLAP aggregations)

===============================================================================
*/

select
    order_item_id,
    order_id,
    product_id,
    quantity,
    unit_price,

    (coalesce(quantity, 0) * coalesce(unit_price, 0))     as line_total

from {{ ref('stg_order_items') }}
