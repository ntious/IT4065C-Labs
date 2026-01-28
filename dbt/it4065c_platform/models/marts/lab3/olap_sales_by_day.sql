/*
===============================================================================
 Module 2 – Lab 3
 File: models/lab3/marts/olap_sales_by_day.sql

 Model Type:
 -----------
 dbt MART model (OLAP-style aggregation) — analytics-oriented output.

 Purpose:
 --------
 This model produces a daily sales summary designed for ANALYTICAL (OLAP)
 workloads such as dashboards, reporting, and trend analysis.

 OLAP-style models typically:
   - Focus on aggregation (sum, count, average)
   - Reduce the number of joins required by end users
   - Provide stable, reusable business metrics
   - Support slicing and filtering by common dimensions (time, product, customer)

 In this lab, the model provides daily metrics:
   - number of unique orders per day
   - gross sales per day (sum of line totals)

 Key Concept: "Aggregation Level"
 -------------------------------
 The grain of this model is:
   → One row per day (order_date)

 This is intentionally less detailed than:
   - fct_orders (one row per order)
   - fct_order_items (one row per line item)
   - oltp_order_detail (one row per line item with descriptive joins)

 IMPORTANT SAFETY / GOVERNANCE NOTES:
 -----------------------------------
 - Aggregated metrics are often safer to share broadly than row-level customer
   data, because they typically do not contain PII.
 - However, aggregated financial reporting is still business-sensitive and may
   require:
     * access control
     * auditing
     * metric governance / definitions

 Metric Integrity Notes (Avoiding Common Mistakes):
 --------------------------------------------------
 - We count DISTINCT order_id to avoid double counting orders when joining to
   line items.
 - We sum line_total from fct_order_items, which is a standard approach to
   compute gross sales at the line level.
 - In real systems, revenue definitions may be more complex (discounts, refunds,
   taxes, shipping). This lab uses a simplified definition for learning.

 Student Expectations:
 ---------------------
 - You are NOT required to edit this file.
 - Focus on understanding why OLAP outputs are useful and how grain affects
   metric interpretation.

 Data Lineage (Conceptual):
 --------------------------
 fct_orders + fct_order_items  →  olap_sales_by_day (this model)

===============================================================================
*/

with daily as (

    select
        o.order_date,

        count(distinct o.order_id)                         as orders_count,
        sum(oi.quantity)                                   as items_sold,
        sum(oi.line_total)                                 as gross_sales,

        /* Helpful secondary metric */
        avg(o.total_amount)                                as avg_order_value

    from {{ ref('fct_orders') }} o
    join {{ ref('fct_order_items') }} oi
      on o.order_id = oi.order_id
    group by 1

)

select
    order_date,
    orders_count,
    items_sold,
    gross_sales,
    avg_order_value
from daily
order by order_date
