#!/usr/bin/env bash
set -euo pipefail

DB="it4065c"
HOST="localhost"
USER="postgres"
LAB_DIR="labs/module_6/lab6"

echo "============================================================"
echo " Module 6 – Lab 6: Monitoring Evidence & Compliance Reasoning"
echo "============================================================"
echo

echo "== Step 0: Prepare audit evidence (instructor-provided) =="
psql -h "$HOST" -U "$USER" -d "$DB" -f "$LAB_DIR/00_prepare_audit_evidence.sql"
echo

echo "== Step 1: Generate audit & monitoring report =="
psql -h "$HOST" -U "$USER" -d "$DB" -f "$LAB_DIR/01_generate_audit_report.sql"
echo

echo "============================================================"
echo " Completed."
echo " Use the report above as your provided audit evidence for analysis."
echo "============================================================"
