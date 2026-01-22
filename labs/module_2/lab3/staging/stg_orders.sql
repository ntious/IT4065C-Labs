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

    /*
    ---------------------------------------------------------------------------
    Source Extraction
    ---------------------------------------------------------------------------
    Pull from the raw orders table without applying business logic.
    Staging models typically remain lightweight and predictable.
    ---------------------------------------------------------------------------
    */
    select
        *
    from raw.orders

)

select

    /*
    ---------------------------------------------------------------------------
    Column Selection & Standardization
    ---------------------------------------------------------------------------

    We explicitly select columns to:
      - Avoid schema drift (new raw columns won't auto-appear downstream)
      - Improve clarity and reviewability
      - Support governance review (which fields are used and why)

    Minimal transformations are used in this lab to reduce cognitive load.
    In a production setting, you might also:
      - cast order_date to DATE/TIMESTAMP
      - cast total_amount to NUMERIC/DECIMAL
      - standardize order_status values
      - validate that amounts are non-negative
    ---------------------------------------------------------------------------
    */

    /* Primary identifier for the order */
    order_id,

    /* Foreign key linking an order to a customer */
    customer_id,

    /* Date/time the order was placed (may require casting in real systems) */
    order_date,

    /* Operational state of the order (e.g., pending, shipped, completed) */
    order_status,

    /* Financial attribute: total amount of the order (may require casting) */
    total_amount,

    /* Payment metadata: often sensitive from a governance perspective */
    payment_method

from src;
