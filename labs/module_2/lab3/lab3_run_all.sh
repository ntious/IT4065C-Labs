#!/usr/bin/env bash
###############################################################################
# Module 2 – Lab 3
# File: labs/module_2/lab3/lab3_run_all.sh
#
# Purpose:
# --------
# This script provides a SAFE, ONE-COMMAND way to run the entire Lab 3 workflow:
#
#   1. Activate the Python virtual environment (dbt-venv)
#   2. Validate dbt configuration and database connectivity
#   3. Build ONLY the Lab 3 dbt models
#   4. Run dbt tests for keys and relationships
#   5. Execute SQL validation queries to inspect outputs
#
# This script is OPTIONAL for students but serves as:
#   - A safety net if something goes wrong
#   - A reference implementation of the correct execution order
#   - A TA/instructor troubleshooting shortcut
#
# IMPORTANT STUDENT NOTES:
# ------------------------
# - You are NOT required to edit this script.
# - You are NOT required to understand every line.
# - You should NOT add passwords, secrets, or credentials here.
# - This script does NOT modify any data manually; it only runs dbt and
#   read-only validation queries.
#
# BEST PRACTICE:
# --------------
# Scripts like this are common in professional data teams to:
#   - Standardize execution
#   - Reduce human error
#   - Support reproducibility
#
###############################################################################

# -----------------------------------------------------------------------------
# Safety Settings
# -----------------------------------------------------------------------------
# -e : Exit immediately if any command fails
# This prevents later steps from running on a broken state
# -----------------------------------------------------------------------------
set -e


# -----------------------------------------------------------------------------
# Step 1 — Navigate to the Course Repository
# -----------------------------------------------------------------------------
# Assumes the repo was cloned into the home directory as instructed in Lab 1
# -----------------------------------------------------------------------------
echo "▶ Navigating to course repository..."
cd ~/IT4065C-Labs


# -----------------------------------------------------------------------------
# Step 2 — Activate Python Virtual Environment
# -----------------------------------------------------------------------------
# dbt is installed inside a virtual environment to avoid system-wide conflicts
# -----------------------------------------------------------------------------
echo "▶ Activating dbt virtual environment..."
source dbt-venv/bin/activate


# -----------------------------------------------------------------------------
# Step 3 — Navigate to dbt Project Directory
# -----------------------------------------------------------------------------
echo "▶ Navigating to dbt project..."
cd dbt/it4065c_platform


# -----------------------------------------------------------------------------
# Step 4 — Verify dbt Configuration and Database Connectivity
# -----------------------------------------------------------------------------
# This checks:
#   - profiles.yml configuration
#   - database credentials
#   - ability to connect to PostgreSQL
#
# If this step fails, the lab should NOT continue.
# -----------------------------------------------------------------------------
echo "▶ Running dbt debug (configuration check)..."
dbt debug


# -----------------------------------------------------------------------------
# Step 5 — Build Lab 3 Models Only
# -----------------------------------------------------------------------------
# The --select path:models/lab3 flag ensures:
#   - Only Lab 3 models are built
#   - Other labs or experiments are not affected
#
# dbt automatically resolves dependencies between staging, core, and marts.
# -----------------------------------------------------------------------------
echo "▶ Building Lab 3 dbt models..."
dbt run --select path:models/lab3


# -----------------------------------------------------------------------------
# Step 6 — Run Data Quality Tests for Lab 3
# -----------------------------------------------------------------------------
# These tests validate:
#   - Primary keys are not null and unique
#   - Foreign keys reference valid parent records
#
# A failure here indicates a DATA QUALITY issue, not a scripting error.
# -----------------------------------------------------------------------------
echo "▶ Running dbt tests for Lab 3 models..."
dbt test --select path:models/lab3


# -----------------------------------------------------------------------------
# Step 7 — Run SQL Validation Queries
# -----------------------------------------------------------------------------
# These queries:
#   - Confirm tables exist and contain data
#   - Display OLAP aggregated results
#   - Show a sample of OLTP-style detail rows
#
# IMPORTANT:
# - These queries are READ-ONLY
# - They do NOT modify any data
# -----------------------------------------------------------------------------
echo "▶ Running SQL validation checks..."
cd ~/IT4065C-Labs

psql -h localhost -U postgres -d it4065c \
     -f labs/module_2/lab3/lab3_quick_checks.sql


# -----------------------------------------------------------------------------
# Completion Message
# -----------------------------------------------------------------------------
echo "✅ Lab 3 pipeline completed successfully."
echo "You may now review outputs and complete reflection questions."
###############################################################################
