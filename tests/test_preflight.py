# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
import argparse
from contextlib import redirect_stdout
import importlib.util
import io
from pathlib import Path
import socket
import tempfile
import unittest
from unittest.mock import patch, Mock

spec = importlib.util.spec_from_file_location('preflight', Path(__file__).resolve().parents[1] / 'scripts/preflight.py')
preflight = importlib.util.module_from_spec(spec)
spec.loader.exec_module(preflight)


class PreflightTests(unittest.TestCase):
    def test_distribution_support(self):
        with tempfile.TemporaryDirectory() as directory:
            path = Path(directory) / 'os-release'
            for text, expected in [('ID=ubuntu\nVERSION_ID="24.04"', True),
                                   ('ID=ubuntu\nVERSION_ID="22.04"', True),
                                   ('ID=debian\nVERSION_ID="12"', False),
                                   ('ID=ubuntu\nVERSION_ID="20.04"', False)]:
                path.write_text(text)
                self.assertEqual(preflight.supported_os(path), expected)
            self.assertFalse(preflight.supported_os(Path(directory) / 'missing'))

    def test_port_bounds(self):
        for value in ('0', '-1', '65536', 'not-a-port'):
            with self.assertRaises(argparse.ArgumentTypeError):
                preflight.port_number(value)
        self.assertEqual(preflight.port_number('55432'), 55432)

    def test_listener_detection(self):
        with socket.socket() as listener:
            listener.bind(('127.0.0.1', 0))
            listener.listen(1)
            self.assertTrue(preflight.port_listening(listener.getsockname()[1]))

    def test_ready_host_with_existing_listener_is_warning_not_failure(self):
        output = io.StringIO()
        with patch.object(preflight, 'supported_os', return_value=True), \
             patch.object(preflight.os, 'geteuid', return_value=1000, create=True), \
             patch.object(preflight.shutil, 'which', return_value='/usr/bin/tool'), \
             patch.object(preflight.os, 'access', return_value=True), \
             patch.object(preflight.shutil, 'disk_usage', return_value=Mock(free=8 * 1024**3)), \
             patch.object(preflight, 'port_listening', return_value=True), \
             patch.object(preflight.subprocess, 'run', return_value=Mock(returncode=1)), \
             patch.object(preflight.urllib.request, 'urlopen') as network, redirect_stdout(output):
            self.assertEqual(preflight.main(['--offline']), 0)
            network.assert_not_called()
        self.assertIn('WARN: Port 5432', output.getvalue())
        self.assertIn('could not confirm access', output.getvalue())

    def test_unsupported_os_exits_unsuccessfully(self):
        with patch.object(preflight, 'supported_os', return_value=False), \
             patch.object(preflight.shutil, 'which', return_value=None), \
             patch.object(preflight, 'port_listening', return_value=False), \
             redirect_stdout(io.StringIO()):
            self.assertEqual(preflight.main(['--offline']), 1)


if __name__ == '__main__':
    unittest.main()
