# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
"""Read the two Lab 3 test results without connecting to or changing the database."""
import json
from pathlib import Path

NAMES = ("lab3_guided_daily_orders", "lab3_my_sales_rule")
ROOT = Path(__file__).resolve().parents[3]
RESULTS = ROOT / "dbt/it4065c_platform/target/run_results.json"


def check_results(path: Path = RESULTS) -> int:
    """Return zero only when both named course tests passed with zero failures."""
    try:
        document = json.loads(path.read_text(encoding="utf-8"))
    except FileNotFoundError:
        print("Results not found. Run .venv/bin/python scripts/course.py lab 3 first, then retry.")
        return 1
    except (OSError, UnicodeError, ValueError):
        print("Results could not be read. Rerun Lab 3 to regenerate the results, then retry.")
        return 1
    if not isinstance(document, dict) or not isinstance(document.get("results"), list):
        print("Unexpected results format. Rerun Lab 3, then retry.")
        return 1

    matches = {name: [] for name in NAMES}
    for result in document["results"]:
        if not isinstance(result, dict):
            print("Unexpected test entry. Rerun Lab 3, then retry.")
            return 1
        for name in NAMES:
            if result.get("unique_id") == f"test.it4065c_platform.{name}":
                matches[name].append(result)

    passed = True
    for name in NAMES:
        rows = matches[name]
        if not rows:
            print(f"Missing test: {name}. Complete B1/B2, save the exact filename, and rerun Lab 3.")
            passed = False
            continue
        if len(rows) != 1:
            print(f"Duplicate result for {name}. Rerun Lab 3 to regenerate results.")
            passed = False
            continue
        status, failures = rows[0].get("status"), rows[0].get("failures")
        if not isinstance(status, str) or status not in {"pass", "fail", "warn", "error", "skipped"}:
            print(f"Unexpected status for {name}. Rerun Lab 3, then retry.")
            passed = False
            continue
        if failures is not None and (type(failures) is not int or failures < 0):
            print(f"Unexpected failure count for {name}. Rerun Lab 3, then retry.")
            passed = False
            continue
        print(f"{name} status={status} failures={failures}")
        if status != "pass" or type(failures) is not int or failures != 0:
            passed = False
    if not passed:
        print("Check incomplete: review the messages and Lab 3 Recovery; do not claim both tests passed.")
    return 0 if passed else 1


if __name__ == "__main__":
    raise SystemExit(check_results())
