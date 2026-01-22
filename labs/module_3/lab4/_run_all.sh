#!/usr/bin/env bash
set -euo pipefail

echo "=== Lab 4: Lifecycle Build + Test + Docs (Module 3) ==="

# Always run from repo root
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
cd "$REPO_ROOT"

# Activate venv
if [ -f "dbt-venv/bin/activate" ]; then
  # shellcheck disable=SC1091
  source dbt-venv/bin/activate
else
  echo "ERROR: dbt-venv not found. Complete Lab 1 first."
  exit 1
fi

# Go to dbt project
cd dbt/it4065c_platform

echo ""
echo "Step 1/4: dbt debug"
dbt debug

echo ""
echo "Step 2/4: Ensure raw tables exist (seed if missing)"
cd "$REPO_ROOT"
psql -h localhost -U postgres -d it4065c -f labs/module_3/lab4/_precheck.sql

echo ""
echo "Step 3/4: dbt build (Lab 3 models = staging->core->marts + tests)"
cd "$REPO_ROOT/dbt/it4065c_platform"
dbt build --select path:models/lab3

echo ""
echo "Step 4/4: dbt docs generate (for lineage + documentation)"
dbt docs generate --select path:models/lab3

echo ""
echo "DONE."
echo "Next: run 'dbt docs serve' and take lineage screenshots per README."
