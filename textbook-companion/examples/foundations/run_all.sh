#!/usr/bin/env bash
# Optional textbook SQL examples; use run.py to supply a fresh private cluster.
set -euo pipefail
: "${EDS_PRIVATE_RUN:?Use the companion run.py launcher}"
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT=${1:?private transcript path}
DB="eds_foundations_$$_${RANDOM}"
FILES=(00_assert_helpers.sql ch01_sales_question.sql ch03_schema.sql ch03_enforcement_tests.sql ch03_detect_vs_enforce.sql ch03_normalization.sql)
for f in "${FILES[@]}"; do [[ -f "$HERE/$f" ]] || { echo "missing input $f" >&2; exit 2; }; done
createdb "$DB"
trap 'dropdb --if-exists "$DB" >/dev/null 2>&1' EXIT
{
  echo '# Foundations SQL example transcript'
  psql -X -tA -d "$DB" -c 'show server_version'
  for f in "${FILES[@]}"; do
    echo "########## $f"
    psql -X -q -v ON_ERROR_STOP=1 -d "$DB" -f "$HERE/$f"
    echo 'STEP RESULT: PASS'
  done
  echo '# OVERALL: PASS (SQL-ONLY: textbook listing equivalence is a separate check)'
} > "$OUT" 2>&1
echo "# Assertions passed: $(grep -c '^ *PASS \[' "$OUT")" >> "$OUT"
tail -n 2 "$OUT"
