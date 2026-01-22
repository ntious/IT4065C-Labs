/*
===============================================================================
 Module 2 – Lab 3
 File: lab3_quick_checks.sql

 Purpose:
 --------
 This script provides a set of READ-ONLY validation queries used to verify that
 the dbt models built in Lab 3 were created successfully and behave as expected.

 IMPORTANT:
 ----------
 - Students are NOT required to edit this file.
 - Students are NOT required to write any SQL for this lab.
 - This file exists to:
     1. Build confidence that the pipeline worked
     2. Make dbt outputs observable
     3. Demonstrate how professionals validate data models

 If you choose to examine this file, treat it as a learning reference rather
 than something you are expected to memorize or modify.
===============================================================================
*/


/*
-------------------------------------------------------------------------------
 SECTION 1 — Basic Row Count Validation
-------------------------------------------------------------------------------

 Why this matters:
 -----------------
 After dbt builds models, a common first validation step is to check that the
 tables actually contain data and that row counts look reasonable.

 This does NOT mean the counts must match raw tables exactly.
 Instead, we want to confirm:
   - The tables exist
   - They are populated
   - They roughly reflect the expected data volume

 These checks help detect:
   - Models that failed silently
   - Incorrect schema references
   - Accidental filtering that removed all rows
-------------------------------------------------------------------------------
*/

SELECT
    COUNT(*) AS customer_count
FROM student_kofi.dim_customers;

SELECT
    COUNT(*) AS product_count
FROM student_kofi.dim_products;

SELECT
    COUNT(*) AS order_count
FROM student_kofi.fct_orders;

SELECT
    COUNT(*) AS order_item_count
FROM student_kofi.fct_order_items;


/*
-------------------------------------------------------------------------------
 SECTION 2 — OLAP Model Validation (Aggregated Analytics View)
-------------------------------------------------------------------------------

 Model:
 ------
 student_kofi.olap_sales_by_day

 Purpose of this model:
 ----------------------
 This model is designed for ANALYTICAL workloads (OLAP).
 It aggregates transactional data to produce business metrics that are:
   - Easy to query
   - Easy to visualize
   - Suitable for dashboards and reports

 What we are checking:
 ---------------------
 - Does the model return aggregated results?
 - Are dates grouped correctly?
 - Do numeric values (orders, sales) appear reasonable?

 We do NOT need to manually verify calculations line-by-line here.
 We are checking that the model structure supports analytics use cases.
-------------------------------------------------------------------------------
*/

SELECT
    *
FROM student_kofi.olap_sales_by_day
ORDER BY order_date;


/*
-------------------------------------------------------------------------------
 SECTION 3 — OLTP Model Validation (Detailed Transactional View)
-------------------------------------------------------------------------------

 Model:
 ------
 student_kofi.oltp_order_detail

 Purpose of this model:
 ----------------------
 This model is closer to an OPERATIONAL (OLTP-style) view.
 It combines multiple entities (orders, customers, products, line items)
 into a detailed, row-level representation.

 This type of model is useful for:
   - Investigating individual transactions
   - Debugging data issues
   - Supporting application-level queries

 Why we use LIMIT:
 -----------------
 OLTP-style models can be very large.
 We intentionally limit output to avoid overwhelming the screen.

 What we are checking:
 ---------------------
 - Are joins working correctly?
 - Do rows include both identifying and descriptive fields?
 - Does the data look coherent at a transactional level?
-------------------------------------------------------------------------------
*/

SELECT
    *
FROM student_kofi.oltp_order_detail
LIMIT 10;


/*
-------------------------------------------------------------------------------
 FINAL NOTES FOR STUDENTS
-------------------------------------------------------------------------------

 1. This script does NOT change any data.
    It only reads from models created by dbt.

 2. In professional environments, scripts like this are often:
    - Used by analysts to sanity-check pipelines
    - Used by data engineers during deployments
    - Automated as part of monitoring workflows

 3. You are not expected to understand every line of SQL here.
    Focus instead on:
      - What each section is trying to verify
      - Why different models exist for different workloads

 If you are curious, this script is a great place to start learning how
 professionals "trust but verify" data pipelines.
===============================================================================
*/
