/*
===============================================================================
 Module 2 – Lab 3
 File: models/lab3/core/dim_products.sql

 Model Type:
 -----------
 dbt CORE model (dimension) — trusted business entity representation.

 Purpose:
 --------
 This model creates a product DIMENSION table (`dim_products`) from the
 standardized staging model `stg_products`.

 The product dimension provides a stable, reusable representation of product
 attributes that can be joined to fact tables (orders, order_items) and used
 consistently across analytical queries and dashboards.

 Why "dim_"?
 -----------
 In OLAP/star-schema modeling, a DIMENSION table stores descriptive attributes
 such as:
   - product name
   - category
   - other classifications used for filtering and grouping

 Fact tables store measurements and events, such as sales totals and quantities.

 Even if you are not building a complete star schema in this lab, the
 dimension/fact separation helps reinforce best practices for analytics-ready
 design.

 IMPORTANT SAFETY / GOVERNANCE NOTES:
 -----------------------------------
 - Product attributes are usually not personal data, but they can still be
   business-sensitive (especially pricing).
 - Pricing fields may require governance controls in real organizations, such as:
     * restricted access (RBAC) for pricing data
     * auditing of pricing queries
     * separating public product catalogs from internal cost/pricing models

 Student Expectations:
 ---------------------
 - You are NOT required to edit this file.
 - This lab keeps transformations minimal to focus on model layers and integrity.

 Data Lineage (Conceptual):
 --------------------------
 raw.products  →  stg_products  →  dim_products  →  marts/views

===============================================================================
*/

select

    /*
    ---------------------------------------------------------------------------
    Core Entity Selection
    ---------------------------------------------------------------------------
    For this lab, `dim_products` is a direct pass-through from staging.

    In production systems, this model might also:
      - standardize product names and categories
      - handle discontinued/inactive products
      - manage product versioning or category hierarchies
      - integrate with multiple source systems
    ---------------------------------------------------------------------------
    */

    product_id,
    product_name,
    category,

    /* Business-sensitive attribute in many organizations */
    price

from {{ ref('stg_products') }}