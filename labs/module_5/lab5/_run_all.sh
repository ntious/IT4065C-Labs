#!/usr/bin/env bash
# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && pwd)"
exec "$ROOT/.venv/bin/python" "$ROOT/scripts/course.py" lab 5
