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

    select
        *
    from {{ source('raw', 'customers') }}

),

standardized as (

    select

        /* Primary identifier */
        cast(customer_id as integer)                                  as customer_id,

        /* Basic attributes */
        nullif(trim(first_name), '')                                  as first_name,
        nullif(trim(last_name), '')                                   as last_name,

        /* Potential PII: normalized for consistency (still sensitive) */
        lower(nullif(trim(email), ''))                                as email,
        nullif(regexp_replace(phone_number, '[^0-9]', '', 'g'), '')    as phone_number,

        /* Timestamp/date: cast defensively */
        cast(created_at as timestamp)                                 as created_at

    from src

)

select
    customer_id,
    first_name,
    last_name,
    email,
    phone_number,
    created_at
from standardized
