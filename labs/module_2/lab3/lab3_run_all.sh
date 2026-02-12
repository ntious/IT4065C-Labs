#!/usr/bin/env bash
###############################################################################
# Module 2 – Lab 3
# File: labs/module_2/lab3/lab3_run_all.sh
#
# Purpose:
#   SAFE, ONE-COMMAND execution of the Lab 3 workflow:
#     1) Activate dbt virtual environment (dbt-venv)
#     2) Validate dbt configuration + DB connectivity (dbt debug)
#     3) Build ONLY Lab 3 dbt models (staging → core → marts)
#     4) Run ONLY Lab 3 tests (PK/FK integrity + not-null/unique)
#     5) Run read-only SQL quick checks
#
# Student notes:
#   - Do NOT add passwords/secrets here.
#   - This script runs dbt + read-only validation queries only.
###############################################################################

set -euo pipefail

# -----------------------------------------------------------------------------
# Helpers
# -----------------------------------------------------------------------------
banner() { echo -e "\n============================================================\n$1\n============================================================"; }
step()   { echo -e "\n▶ $1"; }
die()    { echo -e "\n❌ ERROR: $1\n"; exit 1; }

# Trap unexpected failures with a clearer message
trap 'echo -e "\n❌ Script stopped due to an error. Review the output above.\n"; exit 1' ERR

# -----------------------------------------------------------------------------
# Config (paths)
# -----------------------------------------------------------------------------
REPO_DIR="${HOME}/IT4065C-Labs"
DBT_PROJECT_DIR="${REPO_DIR}/dbt/it4065c_platform"
VENV_ACTIVATE="${REPO_DIR}/dbt-venv/bin/activate"
QUICK_CHECKS_SQL="${REPO_DIR}/labs/module_2/lab3/lab3_quick_checks.sql"

# Lab 3 selection (models live here; tests live under models/lab3)
LAB3_MODEL_SELECTORS=(
  "path:models/staging/lab3"
  "path:models/core/lab3"
  "path:models/marts/lab3"
)
LAB3_TEST_SELECTOR="path:models/lab3"

# -----------------------------------------------------------------------------
# Pre-flight checks (student-proofing)
# -----------------------------------------------------------------------------
banner "Module 2 – Lab 3: Run All (Build + Test + Validate)"

step "Checking repository and required files..."
[[ -d "${REPO_DIR}" ]] || die "Course repo not found at: ${REPO_DIR}. Did you complete Lab 1 (clone repo)?"


[[ -f "${VENV_ACTIVATE}" ]] || die "Virtual environment not found: ${VENV_ACTIVATE}. Did you complete Lab 1 setup?"
[[ -d "${DBT_PROJECT_DIR}" ]] || die "dbt project directory not found: ${DBT_PROJECT_DIR}"
[[ -f "${QUICK_CHECKS_SQL}" ]] || die "Quick checks SQL not found: ${QUICK_CHECKS_SQL}"

command -v dbt  >/dev/null 2>&1 || true
command -v psql >/dev/null 2>&1 || die "psql not found. Ensure PostgreSQL client is installed (per Lab 1)."

# -----------------------------------------------------------------------------
# Step 1 — Go to repo root
# -----------------------------------------------------------------------------
step "Navigating to course repository..."
cd "${REPO_DIR}"

# -----------------------------------------------------------------------------
# Step 2 — Activate venv
# -----------------------------------------------------------------------------
step "Activating dbt virtual environment..."
# shellcheck disable=SC1090
source "${VENV_ACTIVATE}"

# -----------------------------------------------------------------------------
# Step 3 — Go to dbt project
# -----------------------------------------------------------------------------
step "Navigating to dbt project..."
cd "${DBT_PROJECT_DIR}"

# -----------------------------------------------------------------------------
# Step 4 — dbt debug (connectivity + profiles)
# -----------------------------------------------------------------------------
step "Running dbt debug (configuration + database connectivity)..."
dbt debug

# -----------------------------------------------------------------------------
# Step 5 — Build Lab 3 models only (staging → core → marts)
# -----------------------------------------------------------------------------
step "Building Lab 3 dbt models (staging → core → marts)..."
dbt run --select \
  "${LAB3_MODEL_SELECTORS[0]}" \
  "${LAB3_MODEL_SELECTORS[1]}" \
  "${LAB3_MODEL_SELECTORS[2]}"

# -----------------------------------------------------------------------------
# Step 6 — Run Lab 3 tests only (IMPORTANT: do NOT run all project tests)
# -----------------------------------------------------------------------------
step "Running Lab 3 dbt tests (PK/FK integrity, not-null, unique)..."
dbt test --select "${LAB3_TEST_SELECTOR}"

# -----------------------------------------------------------------------------
# Step 7 — SQL validation quick checks (read-only)
# -----------------------------------------------------------------------------
step "Running SQL validation checks (read-only)..."
cd "${REPO_DIR}"

# NOTE:
# - If your local PostgreSQL requires a password for -U postgres, psql may prompt.
# - This is expected. Do NOT hardcode passwords into this script.
psql -h localhost -U postgres -d it4065c -f "${QUICK_CHECKS_SQL}"

# -----------------------------------------------------------------------------
# Completion
# -----------------------------------------------------------------------------
banner "✅ Lab 3 pipeline completed successfully"
echo "Next:"
echo "  • Review your dbt run/test output"
echo "  • Capture required screenshots"
echo "  • Complete the reflection questions"
