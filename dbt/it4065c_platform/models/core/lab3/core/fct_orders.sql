/*
===============================================================================
 Module 2 – Lab 3
 File: models/lab3/core/fct_orders.sql

 Model Type:
 -----------
 dbt CORE model (fact table) — transactional business events.

 Purpose:
 --------
 This model creates an ORDERS FACT table (`fct_orders`) from the standardized
 staging model `stg_orders`.

 Fact tables represent BUSINESS EVENTS or TRANSACTIONS.
 In this case, each row corresponds to a single order placed by a customer.

 The orders fact table is a central component of both:
   - Operational analysis (order status, payment method, customer activity)
   - Analytical workflows (sales metrics, trends, KPIs)

 Why "fct_"?
 -----------
 The prefix "fct_" is a common convention for FACT tables in analytical modeling.
 Fact tables typically:
   - Contain foreign keys to dimension tables
   - Store dates, statuses, and measurements
   - Grow quickly as transactions accumulate

 IMPORTANT SAFETY / GOVERNANCE NOTES:
 -----------------------------------
 - Orders often contain financially sensitive information.
 - Payment-related attributes may require access restrictions.
 - Order data is commonly subject to audit, retention, and monitoring policies.
 - This lab keeps the model simple and does NOT implement:
     * row-level security
     * masking
     * historical versioning
   These would be handled elsewhere in real systems.

 Student Expectations:
 ---------------------
 - You are NOT required to edit this file.
 - Focus on understanding why this table exists and how it is used.

 Data Lineage (Conceptual):
 --------------------------
 raw.orders  →  stg_orders  →  fct_orders  →  marts/views

===============================================================================
*/

select

    /*
    ---------------------------------------------------------------------------
    Fact Table Structure
    ---------------------------------------------------------------------------
    This fact table uses a 1-row-per-order grain.

    The "grain" of a fact table answers the question:
      → What does a single row represent?

    Here:
      - One row = one customer order

    This clarity is critical for:
      - Correct aggregations
      - Avoiding double-counting
      - Reliable analytics
    ---------------------------------------------------------------------------
    */

    /* Primary key for the order fact */
    order_id,

    /* Foreign key linking to the customer dimension */
    customer_id,

    /* Date/time of the order event */
    order_date,

    /* Operational state of the order */
    order_status,

    /* Financial measure: total order amount */
    total_amount,

    /* Payment metadata (often governance-sensitive) */
    payment_method

from {{ ref('stg_orders') }}
-- End of fct_orders.sql