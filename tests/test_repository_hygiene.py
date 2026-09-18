# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
"""Guard current-source packaging and documentation; not a full secrets scanner."""
from pathlib import Path
import re
import subprocess
import unittest

ROOT = Path(__file__).resolve().parents[1]


class RepositoryHygieneTests(unittest.TestCase):
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
                if name in {"labs/module_2/images/lab2-nano-guide.png",
                            "labs/module_2/images/lab2-placeholder-guide.png"}:
                    self.assertTrue(path.read_bytes().startswith(b"\x89PNG\r\n\x1a\n"))
                    continue  # Reviewed instructional screenshot; text checks apply below.
                text = path.read_text(encoding="utf-8")
                self.assertIsNone(re.search(r"(?m)^(?:<{7}|={7}|>{7})(?: |$)", text), "Unresolved merge marker")
                self.assertIsNone(re.search(r"[A-Za-z]:[/\\]Users[/\\][^\s]+", text), "Personal Windows profile path")
                self.assertIsNone(re.search(r"gh[pousr]_[A-Za-z0-9]{30,}|-----BEGIN (?:RSA |EC |OPENSSH )?PRIVATE KEY-----", text), "Possible credential")
                if path.suffix == ".md":
                    for link in re.findall(r"\]\(([^)]+)\)", text):
                        target = link.split("#")[0]
                        if target and ":" not in target and not target.startswith("//"):
                            self.assertTrue((path.parent / target).exists(), "Broken local link: " + target)


if __name__ == "__main__":
    unittest.main()
