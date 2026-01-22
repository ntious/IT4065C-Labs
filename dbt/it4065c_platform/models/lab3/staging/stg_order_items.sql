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

    /*
    ---------------------------------------------------------------------------
    Source Extraction
    ---------------------------------------------------------------------------
    Select all columns from the raw order_items table.

    Best practice:
    - Keep staging logic lightweight
    - Avoid joins and aggregations
    - Preserve raw values while clarifying structure
    ---------------------------------------------------------------------------
    */
    select
        *
    from raw.order_items

)

select

    /*
    ---------------------------------------------------------------------------
    Column Selection & Standardization
    ---------------------------------------------------------------------------

    Explicit column selection helps:
      - Prevent schema drift
      - Make key relationships obvious
      - Support data governance and review

    In production systems, additional steps might include:
      - casting quantity to INTEGER
      - casting unit_price to NUMERIC/DECIMAL
      - validating non-negative quantities and prices
      - handling returns or refunds as separate records
    ---------------------------------------------------------------------------
    */

    /* Primary identifier for each order line item */
    order_item_id,

    /* Foreign key referencing the parent order */
    order_id,

    /* Foreign key referencing the purchased product */
    product_id,

    /* Number of units purchased for this product */
    quantity,

    /* Price per unit at time of purchase */
    price_at_purchase as unit_price


from src
