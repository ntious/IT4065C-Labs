# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
"""Check docs-only interruption handling without a database or server."""
import contextlib
import importlib.util
import io
from pathlib import Path
import unittest
from unittest.mock import patch

spec = importlib.util.spec_from_file_location("course_docs_test", Path(__file__).resolve().parents[1] / "scripts/course.py")
course = importlib.util.module_from_spec(spec)
spec.loader.exec_module(course)


class DocsLifecycleTests(unittest.TestCase):
    def test_lab_handoff_names_existing_guide(self):
        for number in range(2, 10):
            with self.subTest(lab=number):
                runner = course.Course.__new__(course.Course)
                out = io.StringIO()
                with patch.object(runner, "preflight"), patch.object(runner, f"lab{number}"), contextlib.redirect_stdout(out):
                    runner.run(number)
                guide = course.LAB_GUIDES[number]
                self.assertTrue((course.ROOT / guide).is_file())
                self.assertIn("TECHNICAL CHECKS COMPLETE", out.getvalue())
                self.assertIn(guide, out.getvalue())
                self.assertNotIn("deliverables in labs/README.md", out.getvalue())

    def test_docs_interrupt_is_clean_and_instructions_precede_server(self):
        out = io.StringIO()
        def interrupt(*args):
            self.assertIn("http://127.0.0.1:8080", out.getvalue())
            self.assertIn("Press Ctrl+C", out.getvalue())
            raise KeyboardInterrupt
        with patch.object(course, "Course") as factory, patch("sys.argv", ["course.py", "docs"]), contextlib.redirect_stdout(out):
            factory.return_value.dbt.side_effect = interrupt
            course.main()
            factory.return_value.preflight.assert_called_once()
            factory.return_value.dbt.assert_called_once_with("docs", "serve", "--host", "127.0.0.1", "--port", "8080", "--no-browser")
        self.assertIn("Documentation server stopped.", out.getvalue())
        self.assertNotIn("Traceback", out.getvalue())

    def test_real_server_failure_is_not_swallowed(self):
        with patch.object(course, "Course") as factory, patch("sys.argv", ["course.py", "docs"]), contextlib.redirect_stdout(io.StringIO()):
            factory.return_value.dbt.side_effect = ValueError("dbt failed")
            with self.assertRaises(ValueError):
                course.main()

    def test_lab_interrupt_is_not_reported_as_docs_shutdown(self):
        with patch.object(course, "Course") as factory, patch("sys.argv", ["course.py", "lab", "4"]):
            factory.return_value.run.side_effect = KeyboardInterrupt
            with self.assertRaises(KeyboardInterrupt):
                course.main()


if __name__ == "__main__":
    unittest.main()
