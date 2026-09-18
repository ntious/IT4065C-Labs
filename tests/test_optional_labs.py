# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
"""Tests for optional ingestion: reject invalid values and minimize exposed fields."""
from pathlib import Path
import json
import sys
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "scripts"))
from optional_labs import curate


class IngestionTests(unittest.TestCase):
    def test_fixture_and_minimization(self):
        result = curate()
        self.assertEqual(len(result["accepted"]), 3)
        self.assertEqual(len(result["quarantine"]), 2)
        self.assertEqual({r["type"] for r in result["catalog"]}, {"structured", "semi-structured", "unstructured"})
        serialized = json.dumps(result)
        self.assertNotIn("@example.com", serialized)
        self.assertNotIn("customer_email", serialized)
        self.assertNotIn("notes", serialized)

    def test_nonfinite_values_malformed_json_and_schema_rejected(self):
        with tempfile.TemporaryDirectory() as name:
            root = Path(name)
            (root / "sales.csv").write_text("record_id,event_date,amount\ncsv-1,2026-01-10,NaN\ncsv-2,2026-01-10,Infinity\ncsv-3,2026-01-10,1.001\ncsv-4,invalid,2.00\n")
            (root / "events.jsonl").write_text('{broken\n[]\n{"record_id":"json-1","event_date":"2026-01-10","amount":"2.00","notes":"exclude me"}\n')
            (root / "purpose.txt").write_text("Synthetic test policy")
            result = curate(root)
            self.assertEqual(len(result["quarantine"]), 6)
            self.assertEqual(len(result["accepted"]), 1)
            self.assertNotIn("exclude me", json.dumps(result))


if __name__ == "__main__":
    unittest.main()
