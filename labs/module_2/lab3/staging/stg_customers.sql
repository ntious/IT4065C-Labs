/*
===============================================================================
 Module 2 – Lab 3
 File: models/lab3/staging/stg_customers.sql

 Model Type:
 -----------
 dbt STAGING model (stg_*) — standardizes raw source data for consistent use.

 Purpose:
 --------
 This staging model provides a clean, consistent representation of the
 raw customer data from `raw.customers`.

 In professional data platforms, RAW tables often contain:
   - Inconsistent naming conventions
   - Mixed or unexpected data types
   - Extra columns that are not needed downstream
   - Values that require standard formatting (dates, strings, IDs)
   - Fields that may be sensitive (PII)

 The role of staging is to:
   1) Create a stable interface for downstream models (core entities, marts)
   2) Minimize repeated cleanup logic in multiple places
   3) Make data transformations predictable and reviewable
   4) Reduce risk of analysts querying raw data directly

 IMPORTANT SAFETY / GOVERNANCE NOTES:
 -----------------------------------
 - This model does NOT remove or mask PII. It only standardizes structure.
 - In a real organization, additional controls might include:
     * masking/obfuscation of PII in downstream layers
     * restricted access to PII fields (RBAC)
     * audit logging and monitoring for sensitive attribute queries
 - You should treat columns like email/phone as potentially sensitive.

 Student Expectations:
 ---------------------
 - You are NOT required to edit this file.
 - You are expected to run dbt and interpret results.
 - If you choose to examine it, focus on understanding:
     * why staging exists
     * how it supports downstream modeling

 Data Lineage (Conceptual):
 --------------------------
 raw.customers  -->  stg_customers  -->  dim_customers  --> marts/views

===============================================================================
*/

with src as (

    /*
    ---------------------------------------------------------------------------
    Source Extraction
    ---------------------------------------------------------------------------
    We select from the raw source table as-is.

    dbt best practice:
    - Staging models typically:
        * select from raw/source
        * rename / cast columns
        * standardize formats
        * avoid heavy business logic
    ---------------------------------------------------------------------------
    */
    select
        *
    from raw.customers

)

select

    /*
    ---------------------------------------------------------------------------
    Column Selection & Standardization
    ---------------------------------------------------------------------------

    We explicitly select columns instead of using `select *` downstream.
    Reasons:
      - Improves clarity: everyone sees which fields are "official"
      - Prevents schema drift: if raw adds a column, it won't silently appear
      - Supports governance: makes it easier to review sensitive fields

    NOTE:
    This lab keeps transformations minimal to reduce cognitive load.
    In advanced implementations, you may also:
      - cast data types (e.g., created_at::timestamp)
      - trim whitespace
      - standardize casing (lower(email))
      - validate ID formats
    ---------------------------------------------------------------------------
    */

    customer_id,
    first_name,
    last_name,

    /* Potential PII: email address */
    email,

    /* Potential PII: phone number */
    phone_number,

    /* Customer account creation timestamp/date (may require casting in real systems) */
    created_at

from src;
