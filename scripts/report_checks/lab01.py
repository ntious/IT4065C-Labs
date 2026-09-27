# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
#!/usr/bin/env python3
from __future__ import annotations
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[2]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))
from scripts.check_report import main

if __name__ == "__main__":
    raise SystemExit(main(["1", *sys.argv[1:]]))
