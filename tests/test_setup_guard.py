# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
"""Exercise setup as a process with stubbed diagnostics/admin commands; no installs."""
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]


class SetupGuardTests(unittest.TestCase):
    def run_setup(self, preflight_status):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            scripts = root / 'scripts'
            scripts.mkdir()
            shutil.copyfile(ROOT / 'scripts/setup.sh', scripts / 'setup.sh')
            binary = root / 'bin'
            binary.mkdir()
            python = binary / 'python3'
            python.write_text('#!/bin/sh\nprintf "%s\\n" "$*" >> "$TEST_RECORD/preflight"\n'
                              f'exit {preflight_status}\n')
            sudo = binary / 'sudo'
            sudo.write_text('#!/bin/sh\nprintf "%s\\n" "$*" >> "$TEST_RECORD/admin"\nexit 37\n')
            python.chmod(0o755)
            sudo.chmod(0o755)
            env = dict(os.environ, PATH=str(binary) + os.pathsep + os.environ['PATH'],
                       TEST_RECORD=str(root))
            result = subprocess.run(['bash', str(scripts / 'setup.sh')], env=env,
                                    cwd=root, text=True, capture_output=True)
            preflight = (root / 'preflight').read_text()
            admin = (root / 'admin').read_text() if (root / 'admin').exists() else ''
            state_created = (root / '.venv').exists() or (root / '.env').exists()
            return result, preflight, admin, state_created

    def test_failed_preflight_stops_before_any_admin_or_environment_changes(self):
        result, preflight, admin, state = self.run_setup(1)
        self.assertEqual(result.returncode, 1)
        self.assertEqual(preflight.strip(), 'scripts/preflight.py --offline')
        self.assertEqual(admin, '')
        self.assertFalse(state)
        self.assertIn('Setup stopped before installation', result.stderr)
        self.assertNotIn('Installing Ubuntu prerequisites', result.stdout)

    def test_passing_preflight_reaches_existing_install_route(self):
        result, preflight, admin, state = self.run_setup(0)
        self.assertEqual(preflight.strip(), 'scripts/preflight.py --offline')
        self.assertEqual(admin.strip(), 'apt-get update')
        self.assertEqual(result.returncode, 37)  # Stub stops before any real install.
        self.assertFalse(state)
        self.assertIn('Installing Ubuntu prerequisites', result.stdout)


if __name__ == '__main__':
    unittest.main()
