#!/usr/bin/env bash
# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
set -euo pipefail
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"
echo 'Installing Ubuntu prerequisites (sudo may ask for your Linux password).'
sudo apt-get update
sudo apt-get install -y python3 python3-venv python3-pip postgresql postgresql-client
if command -v systemctl >/dev/null && [ "$(ps -p 1 -o comm=)" = systemd ]; then
  sudo systemctl start postgresql
else
  sudo service postgresql start
fi
python3 -m venv .venv
.venv/bin/python -m pip install --require-hashes -r requirements.lock
if [ ! -f .env ]; then .venv/bin/python scripts/course.py configure; fi
.venv/bin/python scripts/course.py bootstrap
.venv/bin/python scripts/course.py lab 1
echo 'Setup complete. Next: open labs/core/lab01-environment/README.md.'
echo 'Lab 1 technical checks passed. Use the output above; no rerun is needed.'
echo 'Complete the Lab 1 investigation and written evidence before starting Lab 2.'
