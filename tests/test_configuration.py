"""Configuration boundary tests; no database or administrator required."""
import importlib.util
import os
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch

SPEC = importlib.util.spec_from_file_location("course", Path(__file__).resolve().parents[1] / "scripts/course.py")
course = importlib.util.module_from_spec(SPEC)
SPEC.loader.exec_module(course)


class ConfigurationTests(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.root_patch = patch.object(course, "ROOT", self.root)
        self.env_patch = patch.dict(os.environ, {}, clear=True)
        self.root_patch.start()
        self.env_patch.start()
        self.addCleanup(self.root_patch.stop)
        self.addCleanup(self.env_patch.stop)
        course.configure()

    def test_generated_secrets_and_no_overwrite(self):
        cfg = course.settings()
        self.assertEqual(len({cfg[k] for k in course.PASSWORDS}), 3)
        self.assertTrue(all(len(cfg[k]) >= 32 for k in course.PASSWORDS))
        before = (self.root / ".env").read_bytes()
        with self.assertRaises(ValueError):
            course.configure()
        self.assertEqual(before, (self.root / ".env").read_bytes())

    def test_values_are_literal_not_shell_code(self):
        value = "$(touch never-execute);'`danger`"
        with (self.root / ".env").open("a") as stream:
            stream.write("# trailing comment allowed\n")
        os.environ[course.PASSWORDS[0]] = value
        self.assertEqual(course.settings()[course.PASSWORDS[0]], value)
        self.assertFalse((self.root / "never-execute").exists())

    def test_invalid_config_rejected(self):
        cases = {"IT4065C_DB_NAME": ["postgres", "template1", "bad;drop", "x" * 41],
                 "IT4065C_DB_SCHEMA": ["raw", "public", "pg_catalog"],
                 "IT4065C_DB_HOST": ["example.com", "0.0.0.0"],
                 "IT4065C_DB_PORT": ["0", "65536", "5432;true"],
                 "IT4065C_DB_USER": ["postgres", "it4065c_analyst"],
                 "IT4065C_DB_PASSWORD": ["short", "abcdefghijklmnop\nnext"]}
        for key, values in cases.items():
            for value in values:
                with self.subTest(key=key, value=value), patch.dict(os.environ, {key: value}):
                    with self.assertRaises(ValueError):
                        course.settings()

    def test_duplicate_and_unknown_file_keys_rejected(self):
        path = self.root / ".env"
        original = path.read_text()
        for line in ["IT4065C_DB_NAME=another", "UNEXPECTED=value"]:
            path.write_text(original + line + "\n")
            with self.assertRaises(ValueError):
                course.settings()

    def test_libpq_environment_isolation_restores_on_error(self):
        with patch.dict(os.environ, {"PGHOSTADDR": "192.0.2.1", "PGSERVICE": "unexpected"}):
            with self.assertRaises(RuntimeError):
                with course.isolated_libpq_environment():
                    self.assertFalse(any(key.startswith("PG") for key in os.environ))
                    raise RuntimeError("driver failure")
            self.assertEqual(os.environ["PGHOSTADDR"], "192.0.2.1")
            self.assertEqual(os.environ["PGSERVICE"], "unexpected")

    @unittest.skipIf(os.name == "nt", "POSIX mode enforcement")
    def test_public_readable_secrets_rejected(self):
        (self.root / ".env").chmod(0o644)
        with self.assertRaises(ValueError):
            course.settings()


if __name__ == "__main__":
    unittest.main()
