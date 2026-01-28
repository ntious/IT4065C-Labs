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
    /* Order header */
    o.order_id,
    o.order_date,
    o.order_status,
    o.total_amount,
    o.payment_method,

    /* Customer */
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email_masked,
    c.phone_masked,
    c.email_hash,
    c.phone_hash,

    /* Line items */
    oi.order_item_id,
    oi.product_id,
    p.product_name,
    p.category,
    oi.quantity,
    oi.unit_price,
    oi.line_total

from {{ ref('fct_orders') }} o
join {{ ref('dim_customers') }} c
  on o.customer_id = c.customer_id
join {{ ref('fct_order_items') }} oi
  on o.order_id = oi.order_id
join {{ ref('dim_products') }} p
  on oi.product_id = p.product_id
