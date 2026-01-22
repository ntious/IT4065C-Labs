\echo '=== Lab 4 Quick Checks: Lifecycle Layer Presence ==='

\echo ''
\echo '1) Raw tables'
\dt raw.*

\echo ''
\echo '2) Staging models (should exist as views/tables in your target schema)'
\dt student_kofi.stg_*

\echo ''
\echo '3) Core entities'
\dt student_kofi.dim_*
\dt student_kofi.fct_*

\echo ''
\echo '4) Marts'
\dt student_kofi.oltp_*
\dt student_kofi.olap_*

\echo ''
\echo '5) Row-count sanity (non-zero expected)'
SELECT 'raw.customers' AS table, COUNT(*) AS rows FROM raw.customers
UNION ALL SELECT 'raw.orders', COUNT(*) FROM raw.orders
UNION ALL SELECT 'stg_customers', COUNT(*) FROM student_kofi.stg_customers
UNION ALL SELECT 'dim_customers', COUNT(*) FROM student_kofi.dim_customers
UNION ALL SELECT 'fct_orders', COUNT(*) FROM student_kofi.fct_orders
UNION ALL SELECT 'olap_sales_by_day', COUNT(*) FROM student_kofi.olap_sales_by_day
ORDER BY table;

\echo ''
\echo 'If counts are zero for downstream layers, your build may not have run or your schema target is incorrect.'
