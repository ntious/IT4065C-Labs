\echo '--- Checking raw schema tables ---'
\dt raw.*

\echo '--- If you do NOT see raw tables above, run this from repo root:'
\echo 'psql -h localhost -U postgres -d it4065c -f labs/module_2/lab2_seed.sql'
\echo '--- Then re-run lab4_run_all.sh ---'
\echo '--- Checking staging schema tables ---'