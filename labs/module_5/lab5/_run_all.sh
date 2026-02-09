#!/usr/bin/env bash
set -euo pipefail

DB="it4065c"
HOST="localhost"
USER="postgres"
LAB_DIR="labs/module_5/lab5"

echo "============================================================"
echo " Module 5 – Lab 5: Enforcing Data Access Policies (RBAC + Masking)"
echo "============================================================"
echo

echo "== Step 0: Precheck schemas =="
psql -h "$HOST" -U "$USER" -d "$DB" -f "$LAB_DIR/00_precheck.sql"
echo

echo "== Step 1: Seed raw dataset if missing =="
bash "$LAB_DIR/01_seed_if_missing.sh"
echo

echo "== Step 2: Build safe objects (views) =="
psql -h "$HOST" -U "$USER" -d "$DB" -f "$LAB_DIR/02_build_safe_objects.sql"
echo

echo "== Step 2b: Confirm required views exist =="
REQ=$(psql -h "$HOST" -U "$USER" -d "$DB" -tAc "SELECT COUNT(*) FROM pg_views WHERE schemaname='student_kofi' AND viewname IN ('v_sales_by_day','v_customers_masked','v_customers_raw_pii');")
if [[ "${REQ:-0}" -lt 3 ]]; then
  echo "ERROR: One or more required views were not created. Stop and fix Step 2 before continuing."
  exit 1
fi
echo "OK: required views exist."
echo

echo "== Step 3: Create roles + apply least-privilege grants =="
psql -h "$HOST" -U "$USER" -d "$DB" -f "$LAB_DIR/03_rbac_and_grants.sql"
echo

echo "== Step 4: Verify access behavior (PASS/FAIL) =="
psql -h "$HOST" -U "$USER" -d "$DB" -v ON_ERROR_STOP=0 -f "$LAB_DIR/04_verify_access.sql"
echo

echo "============================================================"
echo " Completed. Capture your screenshot of the verification section."
echo "============================================================"