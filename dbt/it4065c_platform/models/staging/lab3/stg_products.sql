/*
===============================================================================
 Module 2 – Lab 3
 File: models/lab3/staging/stg_products.sql

 Model Type:
 -----------
 dbt STAGING model (stg_*) — standardizes raw source data for consistent use.

 Purpose:
 --------
 This staging model provides a clean, consistent representation of product data
 from the raw source table `raw.products`.

 Product data is commonly shared across many systems (sales, inventory,
 analytics, reporting). As a result, raw product tables may include:
   - Inconsistent naming conventions
   - Optional or sparsely populated attributes
   - Attributes used differently across teams
   - Pricing fields that require careful handling

 The staging layer establishes a predictable, reviewed structure that downstream
 models can safely depend on.

 IMPORTANT SAFETY / GOVERNANCE NOTES:
 -----------------------------------
 - This model does NOT calculate discounts, margins, or business rules.
 - Price-related fields can be business-sensitive and may require:
     * role-based access control (RBAC)
     * audit logging
     * separation between operational and analytical views
 - Staging focuses on structure, not policy enforcement.

 Student Expectations:
 ---------------------
 - You are NOT required to edit this file.
 - Your task is to understand what role it plays in the modeling pipeline.

 Data Lineage (Conceptual):
 --------------------------
 raw.products  -->  stg_products  -->  dim_products  --> marts/views

===============================================================================
*/


with src as (

    select
        *
    from {{ source('raw', 'products') }}

),

standardized as (

    select

        cast(product_id as integer)                       as product_id,
        nullif(trim(product_name), '')                    as product_name,
        nullif(trim(category), '')                        as category,
        cast(standard_price as numeric(12,2))                      as price

    from src

)

select
    product_id,
    product_name,
    category,
    price
from standardized
