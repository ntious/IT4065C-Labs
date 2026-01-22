/*
===============================================================================
 Module 2 – Lab 3
 File: models/lab3/core/dim_customers.sql

 Model Type:
 -----------
 dbt CORE model (dimension) — trusted business entity representation.

 Purpose:
 --------
 This model creates a customer DIMENSION table (`dim_customers`) from the
 standardized staging model `stg_customers`.

 In a well-designed data platform, core entity models:
   - Serve as the trusted, documented version of key business entities
   - Provide consistent keys and attributes for joins across the project
   - Reduce dependence on raw source tables
   - Establish a clean contract for marts, dashboards, and analytics

 Why "dim_"?
 -----------
 The prefix "dim_" is a common convention for a DIMENSION table in analytical
 (OLAP / star schema) modeling:
   - Dimension tables store descriptive attributes (who/what/where)
   - Fact tables store events/transactions and measurements (orders, sales)

 Even if your organization uses different naming conventions, the concept is
 standard: create stable, trusted entities that many queries can rely on.

 IMPORTANT SAFETY / GOVERNANCE NOTES:
 -----------------------------------
 - Customer data commonly contains personally identifiable information (PII)
   such as email and phone number.
 - This lab does NOT mask or remove PII; it keeps the model simple for learning.
 - In a production environment, governance controls might include:
     * restricting access to PII columns (RBAC)
     * masking or tokenizing sensitive attributes
     * auditing queries against sensitive attributes
     * publishing a data classification tag in a data catalog

 Student Expectations:
 ---------------------
 - You are NOT required to edit this file.
 - Your job is to run dbt, validate outputs, and explain why this layer exists.

 Data Lineage (Conceptual):
 --------------------------
 raw.customers  →  stg_customers  →  dim_customers  →  marts/views

===============================================================================
*/

select

    /*
    ---------------------------------------------------------------------------
    Core Entity Selection
    ---------------------------------------------------------------------------
    For this lab, the core customer dimension is a direct pass-through from
    staging. This keeps complexity low so you can focus on the layering concept.

    In real implementations, core dimensions may also:
      - deduplicate records (one row per customer)
      - standardize name formatting
      - handle slowly changing dimensions (SCD Type 1/2)
      - apply row-level security or masking policies
    ---------------------------------------------------------------------------
    */

    customer_id,
    first_name,
    last_name,

    /* Potential PII */
    email,

    /* Potential PII */
    phone_number,

    created_at

from {{ ref('stg_customers') }}
