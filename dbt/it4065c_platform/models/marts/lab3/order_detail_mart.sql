-- Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
/*
===============================================================================
 Module 2 – Lab 3
 File: models/marts/lab3/order_detail_mart.sql

 Model Type:
 -----------
 Detailed reporting mart, materialized as a table by dbt_project.yml.

 Purpose:
 --------
 This model contains one row per order line item. It supports customer support
 investigations, reconciliation and operational-style reporting questions.
 It is not an OLTP transaction-processing system: detailed rows alone do not
 demonstrate transaction writes, concurrency or operational state management.

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
   - Check aggregation grain to avoid double counting

 IMPORTANT SAFETY / GOVERNANCE NOTES:
 -----------------------------------
 - This table contains customer attributes, including masked contact fields:
     * names
     * masked email
     * masked phone numbers
 - In real systems, detail reporting tables like this should be:
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
                 order_detail_mart (this model)

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
