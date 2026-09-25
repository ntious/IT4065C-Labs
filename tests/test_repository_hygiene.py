# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
"""Guard current-source packaging and documentation; not a full secrets scanner."""
from pathlib import Path
import json
import re
import subprocess
import unittest

from scripts.markdown_links import local_link_errors

ROOT = Path(__file__).resolve().parents[1]


class RepositoryHygieneTests(unittest.TestCase):
    def test_lab_sequence_has_one_guide_per_number(self):
        for group, numbers in (("core", range(1, 8)), ("optional", range(8, 16))):
            for number in numbers:
                guides = list((ROOT / "labs" / group).glob(f"lab{number:02d}-*/README.md"))
                self.assertEqual(len(guides), 1, f"Lab {number} needs one guide in {group}")

    def test_student_test_directory_is_discovered_and_ignored(self):
        import yaml
        project = yaml.safe_load((ROOT / "dbt/it4065c_platform/dbt_project.yml").read_text())
        self.assertIn("student_tests", project["test-paths"])
        result = subprocess.run(
            ["git", "check-ignore", "--no-index", "dbt/it4065c_platform/student_tests/example.sql"],
            cwd=ROOT, capture_output=True)
        self.assertEqual(result.returncode, 0)

    def test_private_paths_are_ignored_and_public_sources_are_not(self):
        private = [
            "submissions/lab5-my-work.md", "submissions/week1/evidence.json",
            ".local/pilot-record.md", ".local/report.docx", ".local/export.zip",
            ".env", ".env.backup", "dbt/it4065c_platform/target/manifest.json",
            "dbt/it4065c_platform/logs/dbt.log", "server.key", "ca.pem",
            "identity.p12", "identity.pfx", "trust.jks", "trust.keystore",
            "server.csr", "server.crt", "course.dump", "course.backup",
            "course.pgdump", "course.sqlite", "course.sqlite3",
        ]
        public = [
            ".env.example", "submissions/README.md", "submissions/template.md",
            "data/ai_predictions.csv", "data/ingestion/events.jsonl",
            "docs/pilot_record.md", "notebooks/MetaData_Lab_StepByStep.ipynb",
            "sample_screenshots/lab5-access-results.png",
        ]
        for expected, names in ((0, private), (1, public)):
            for name in names:
                with self.subTest(path=name):
                    result = subprocess.run(
                        ["git", "check-ignore", "--no-index", "--", name],
                        cwd=ROOT, capture_output=True)
                    self.assertEqual(result.returncode, expected)

    def test_no_ignored_files_are_tracked(self):
        tracked = subprocess.run(
            ["git", "ls-files", "-z"], cwd=ROOT, capture_output=True, check=True)
        result = subprocess.run(
            ["git", "check-ignore", "--no-index", "-z", "--stdin"],
            input=tracked.stdout, cwd=ROOT, capture_output=True)
        self.assertIn(result.returncode, (0, 1), result.stderr.decode())
        self.assertEqual(result.stdout, b"", "Ignored private/runtime files must not be force-added")

    def test_public_notebooks_have_no_execution_state(self):
        tracked = subprocess.run(
            ["git", "ls-files", "-z", "--", "*.ipynb"],
            cwd=ROOT, capture_output=True, check=True)
        for name in tracked.stdout.decode().split("\0"):
            if not name:
                continue
            notebook = json.loads((ROOT / name).read_text(encoding="utf-8"))
            for index, cell in enumerate(notebook["cells"]):
                with self.subTest(path=name, cell=index):
                    self.assertFalse(cell.get("attachments"), "Review embedded notebook attachments before publication")
                    if cell["cell_type"] == "code":
                        self.assertEqual(cell.get("outputs"), [], "Clear notebook outputs before committing")
                        self.assertIsNone(cell.get("execution_count"), "Clear notebook execution counts before committing")

    def test_current_source_and_local_links(self):
        command = ["git", "ls-files", "--cached", "--others", "--exclude-standard", "-z"]
        result = subprocess.run(command, cwd=ROOT, capture_output=True)
        if result.returncode:
            self.skipTest("Git inventory unavailable, for example a source ZIP without .git")
        names = {n for n in result.stdout.decode("utf-8").split("\0") if n}
        for name in names:
            path = ROOT / name
            if not path.is_file():
                continue
            with self.subTest(path=name):
                self.assertFalse(name == ".env" or name.startswith((".local/", ".venv/")))
                self.assertNotIn(path.suffix, {".pdf", ".xlsx", ".log"}, "Review binary/runtime assets before publishing")
                if name in {"sample_screenshots/lab4-open-lineage-guide.png",
                            "sample_screenshots/lab5-access-results.png",
                            "sample_screenshots/lab11-kpi-results.png"}:
                    self.assertTrue(path.read_bytes().startswith(b"\x89PNG\r\n\x1a\n"))
                    continue  # Reviewed instructional screenshot; text checks apply below.
                text = path.read_text(encoding="utf-8")
                self.assertIsNone(re.search(r"(?m)^(?:<{7}|={7}|>{7})(?: |$)", text), "Unresolved merge marker")
                self.assertIsNone(re.search(r"[A-Za-z]:[/\\]Users[/\\][^\s]+", text), "Personal Windows profile path")
                self.assertIsNone(re.search(r"gh[pousr]_[A-Za-z0-9]{30,}|-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----", text), "Possible credential")
                if path.suffix == ".md":
                    self.assertEqual(local_link_errors(path), [])



if __name__ == "__main__":
    unittest.main()
