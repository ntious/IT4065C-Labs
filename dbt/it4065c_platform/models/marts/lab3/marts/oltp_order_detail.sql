/*
===============================================================================
 Module 2 – Lab 3
 File: models/lab3/marts/oltp_order_detail.sql

 Model Type:
 -----------
 dbt MART model (OLTP-style view) — detailed, transaction-oriented output.

 Purpose:
 --------
 This model produces an "order detail" view that resembles how data is commonly
 consumed in OPERATIONAL (OLTP-style) workflows.

 While dbt is frequently used for analytics (OLAP), organizations also build
 OLTP-style views for:
   - Customer support investigations
   - Order troubleshooting and reconciliation
   - Operational reporting (e.g., "show me the exact items in this order")
   - Debugging joins and verifying referential integrity

 This model joins together:
   - Orders (transaction header)          → fct_orders
   - Customers (descriptive entity)       → dim_customers
   - Order items (transaction line items) → fct_order_items
   - Products (descriptive entity)        → dim_products

 Key Concept: "Grain"
 -------------------
 The grain of this model is:
   → One row per order line item (order_item_id)

 That means:
   - A single order_id can appear multiple times (one per product line)
   - This is expected and correct for order-detail inspection
   - Aggregations should be done carefully to avoid double counting

 IMPORTANT SAFETY / GOVERNANCE NOTES:
 -----------------------------------
 - This view can expose customer attributes (potential PII), such as:
     * names
     * email
     * phone numbers
 - In real systems, OLTP-style views like this are often:
     * access-restricted (RBAC)
     * monitored/audited
     * split into "safe" and "sensitive" variants

 Student Expectations:
 ---------------------
 - You are NOT required to edit this file.
 - Your task is to run dbt and reason about why this model exists.
 - When validating output, use LIMIT to avoid overwhelming your terminal.

 Data Lineage (Conceptual):
 --------------------------
 dim_customers   fct_orders   fct_order_items   dim_products
        \            |              |               /
         \           |              |              /
          \          |              |             /
                 oltp_order_detail (this model)

===============================================================================
*/

select

    /*
    ---------------------------------------------------------------------------
    Order Header Fields (from fct_orders)
    ---------------------------------------------------------------------------
    These fields describe the order as a whole (the "header"):
      - order_id, order_date, status, payment method, total amount
    ---------------------------------------------------------------------------
    */
    o.order_id,
    o.order_date,
    o.order_status,
    o.total_amount,
    o.payment_method,

    /*
    ---------------------------------------------------------------------------
    Customer Fields (from dim_customers)
    ---------------------------------------------------------------------------
    These fields describe WHO placed the order.
    Note: email and phone are potential PII.
    ---------------------------------------------------------------------------
    */
    o.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.phone_number,

    /*
    ---------------------------------------------------------------------------
    Line Item Fields (from fct_order_items)
    ---------------------------------------------------------------------------
    These fields describe WHAT was purchased and in what quantity.
    Grain reminder: one row per order_item_id.
    ---------------------------------------------------------------------------
    */
    oi.order_item_id,
    oi.product_id,
    oi.quantity,
    oi.unit_price,
    oi.line_total,

    /*
    ---------------------------------------------------------------------------
    Product Fields (from dim_products)
    ---------------------------------------------------------------------------
    These fields describe the purchased product.
    ---------------------------------------------------------------------------
    */
    p.product_name,
    p.category,
    p.price

from {{ ref('fct_orders') }} o

/*
-------------------------------------------------------------------------------
 Join Strategy
-------------------------------------------------------------------------------
 We use inner joins because:
   - In a clean, integrity-enforced model, orders should have valid customers
   - Order items should have valid orders and products

 If any join reduces row counts unexpectedly, that may indicate:
   - orphaned foreign keys in the source data
   - missing dimension records
   - data quality issues

 dbt relationship tests (in _lab3_models.yml) are designed to detect these
 conditions proactively.
-------------------------------------------------------------------------------
*/
join {{ ref('dim_customers') }} c
    using (customer_id)

join {{ ref('fct_order_items') }} oi
    using (order_id)

join {{ ref('dim_products') }} p
    using (product_id)
