#!/usr/bin/env bash
set -euo pipefail

DB="it4065c"
HOST="localhost"
USER="postgres"

echo "== Step: Seed raw data only if missing =="

HAS_RAW_TABLES=$(psql -h "$HOST" -U "$USER" -d "$DB" -tAc "SELECT COUNT(*) FROM pg_tables WHERE schemaname='raw';" || true)

if [[ "${HAS_RAW_TABLES:-0}" -gt 0 ]]; then
  echo "Raw schema already has tables. Skipping seed."
  exit 0
fi

SEED_FILE="labs/module_2/lab2_seed.sql"

if [[ ! -f "$SEED_FILE" ]]; then
  echo "ERROR: Seed file not found at: $SEED_FILE"
  exit 1
fi

echo "No raw tables found. Running seed file: $SEED_FILE"
psql -h "$HOST" -U "$USER" -d "$DB" -f "$SEED_FILE"

echo "OK: Seed completed."
