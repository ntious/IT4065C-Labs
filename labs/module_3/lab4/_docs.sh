#!/usr/bin/env bash
set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"

source "$REPO_ROOT/dbt-venv/bin/activate"
cd "$REPO_ROOT/dbt/it4065c_platform"

dbt docs serve --port 8080
