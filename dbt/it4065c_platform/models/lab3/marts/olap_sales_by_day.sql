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

select

    /*
    ---------------------------------------------------------------------------
    Time Dimension (Aggregation Key)
    ---------------------------------------------------------------------------
    We aggregate by order_date to create daily metrics.

    Note:
    - If order_date includes time (timestamp), a production model may need to
      cast or truncate to a date (e.g., DATE(order_date)).
    - This lab assumes order_date is already date-like or consistent enough.
    ---------------------------------------------------------------------------
    */
    o.order_date,

    /*
    ---------------------------------------------------------------------------
    Metric 1 — Orders per Day
    ---------------------------------------------------------------------------
    We count DISTINCT order_id because:
      - We are joining to line items
      - A single order can have multiple line items
      - Counting order_id without DISTINCT would inflate order counts
    ---------------------------------------------------------------------------
    */
    count(distinct o.order_id) as orders,

    /*
    ---------------------------------------------------------------------------
    Metric 2 — Gross Sales per Day
    ---------------------------------------------------------------------------
    We sum line_total (quantity × unit_price) from the line-item fact table.

    Why use line_total?
      - It represents item-level revenue before any advanced adjustments.
      - It aggregates cleanly across time, products, and customers.

    In real organizations, "sales" might be net of discounts/refunds and might
    exclude taxes/shipping depending on metric definitions.
    ---------------------------------------------------------------------------
    */
    sum(oi.line_total) as gross_sales

from {{ ref('fct_orders') }} o

/*
-------------------------------------------------------------------------------
 Join to Line Items
-------------------------------------------------------------------------------
 We join to fct_order_items because revenue is represented at the line level
 (quantity × unit_price). This provides the most accurate basis for summations.

 Relationship tests in dbt are expected to ensure:
 - Every line item references a valid order
-------------------------------------------------------------------------------
*/
join {{ ref('fct_order_items') }} oi
    using (order_id)

/*
-------------------------------------------------------------------------------
 Aggregation
-------------------------------------------------------------------------------
 Group by the time key (order_date) to produce one row per day.
-------------------------------------------------------------------------------
*/
group by 1

/*
-------------------------------------------------------------------------------
 Ordering
-------------------------------------------------------------------------------
 Ordering by date makes the output immediately readable for validation and
 plotting in dashboards.
-------------------------------------------------------------------------------
*/
order by 1;
-- File: dbt/it4065c_platform/models/lab3/marts/oltp_order_detail.sql