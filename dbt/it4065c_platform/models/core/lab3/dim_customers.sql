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

/*
===============================================================================
 Module 2 – Lab 3
 File: models/lab3/core/dim_customers.sql

 ENHANCEMENT (secure-by-default for PII)
 --------------------------------------
 - Keeps original columns for learning and compatibility.
 - Adds masked + hashed fields to model secure analytics practices.
 - Downstream marts will use masked values by default.
===============================================================================
*/

with stg as (

    select
        *
    from {{ ref('stg_customers') }}

),

final as (

    select

        customer_id,
        first_name,
        last_name,

        /*
          PII NOTE (Educational):
          We keep raw email/phone here for learning, BUT also provide safer fields.
          In production, many teams would remove raw PII from dimensional layers.
        */
        email,
        phone_number,

        /* Privacy-preserving linkage */
        md5(coalesce(email, ''))                          as email_hash,
        md5(coalesce(phone_number, ''))                   as phone_hash,

        /* Display-safe masking */
        case
            when email is null then null
            when position('@' in email) > 2
                then left(email, 2) || '***' || substring(email from position('@' in email))
            else '***'
        end                                               as email_masked,

        case
            when phone_number is null then null
            when length(phone_number) >= 4
                then '***-***-' || right(phone_number, 4)
            else '***'
        end                                               as phone_masked,

        created_at

    from stg

)

select
    customer_id,
    first_name,
    last_name,
    email,
    phone_number,
    email_hash,
    phone_hash,
    email_masked,
    phone_masked,
    created_at
from final
