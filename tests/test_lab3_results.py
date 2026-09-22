# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
"""Exercise result verification without a database or student artifacts."""
import contextlib
import importlib.util
import io
import json
from pathlib import Path
import tempfile
import unittest

SCRIPT = Path(__file__).resolve().parents[1] / "labs/module_2/lab3/check_test_results.py"
spec = importlib.util.spec_from_file_location("lab3_results", SCRIPT)
checker = importlib.util.module_from_spec(spec)
spec.loader.exec_module(checker)


class ResultChecks(unittest.TestCase):
    def run_check(self, content):
        with tempfile.TemporaryDirectory() as folder:
            path = Path(folder) / "run_results.json"
            if content is not None:
                path.write_text(content, encoding="utf-8")
            out = io.StringIO()
            with contextlib.redirect_stdout(out):
                code = checker.check_results(path)
            return code, out.getvalue()

    def rows(self):
        return [{"unique_id": "test.it4065c_platform." + name,
                 "status": "pass", "failures": 0} for name in checker.NAMES]

    def test_success(self):
        code, out = self.run_check(json.dumps({"results": self.rows()}))
        self.assertEqual(code, 0)
        self.assertEqual(out.splitlines(), [name + " status=pass failures=0" for name in checker.NAMES])

    def test_missing_or_invalid_artifact(self):
        for value in (None, "broken", "[]", '{"results": null}', '{"results": [null]}'):
            with self.subTest(value=value):
                code, out = self.run_check(value)
                self.assertEqual(code, 1)
                self.assertNotIn("Traceback", out)

    def test_nonpassing_and_invalid_counts(self):
        for status, failures in (("fail", 1), ("error", None), ("skipped", None),
                                 ("warn", 1), ("pass", None), ("pass", True),
                                 ("pass", -1), ([], 0)):
            with self.subTest(status=status, failures=failures):
                rows = self.rows()
                rows[1].update(status=status, failures=failures)
                self.assertEqual(self.run_check(json.dumps({"results": rows}))[0], 1)

    def test_missing_duplicate_and_wrong_package(self):
        rows = self.rows()
        wrong = dict(rows[1], unique_id="test.other." + checker.NAMES[1])
        for entries in (rows[:1], rows + [rows[0]], [rows[0], wrong]):
            with self.subTest(entries=entries):
                self.assertEqual(self.run_check(json.dumps({"results": entries}))[0], 1)


if __name__ == "__main__":
    unittest.main()
