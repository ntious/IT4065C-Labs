# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
"""Configuration boundaries for the isolated optional server experiments."""
import os
from pathlib import Path
import sys
import tempfile
import unittest
from unittest.mock import patch

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "scripts"))
import infrastructure_labs as lab


class InfrastructureConfigurationTests(unittest.TestCase):
    def test_generated_passwords_are_distinct_and_long(self):
        with patch.dict(os.environ, {}, clear=True):
            first = lab.password_setting("IT4065C_EXPERIMENT_READER_PASSWORD")
            second = lab.password_setting("IT4065C_EXPERIMENT_READER_PASSWORD")
        self.assertGreaterEqual(len(first), 24)
        self.assertNotEqual(first, second)

    def test_invalid_password_override_fails(self):
        for value in ("short", "a" * 30 + "\n", "a" * 30 + "\x00"):
            with self.subTest(value_length=len(value)), patch.object(lab.os, "environ", {"TEST_PASSWORD": value}):
                with self.assertRaises(ValueError):
                    lab.password_setting("TEST_PASSWORD")

    def test_private_write_refuses_overwrite(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / "private"
            lab.private_write(path, "original")
            with self.assertRaises(FileExistsError):
                lab.private_write(path, "replacement")
            self.assertEqual(path.read_text(), "original")
            if os.name != "nt":
                self.assertEqual(path.stat().st_mode & 0o077, 0)

    def test_invalid_roles_never_start_server(self):
        with tempfile.TemporaryDirectory() as directory:
            with patch.dict(os.environ, {"IT4065C_EXPERIMENT_READER": "pg_admin"}), patch.object(lab, "run") as run:
                with self.assertRaises(ValueError):
                    lab.Instance(Path(directory), "invalid")
                run.assert_not_called()

    def test_shared_credentials_never_initialize_cluster(self):
        with tempfile.TemporaryDirectory() as directory:
            values = {"IT4065C_EXPERIMENT_ADMIN_PASSWORD": "x" * 30,
                      "IT4065C_EXPERIMENT_READER_PASSWORD": "x" * 30}
            with patch.dict(os.environ, values), patch.object(lab, "run") as run:
                with self.assertRaises(ValueError):
                    lab.Instance(Path(directory), "invalid")
                run.assert_not_called()


if __name__ == "__main__":
    unittest.main()
