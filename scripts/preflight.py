# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
"""Read-only installation diagnostics; uses only the Python standard library."""
import argparse
import os
from pathlib import Path
import shutil
import socket
import subprocess
import sys
import urllib.error
import urllib.request

ROOT = Path(__file__).resolve().parents[1]


def supported_os(path=Path('/etc/os-release')):
    try:
        values = dict(line.split('=', 1) for line in path.read_text().splitlines()
                      if '=' in line and not line.startswith('#'))
    except OSError:
        return False
    return values.get('ID', '').strip('"') == 'ubuntu' and values.get(
        'VERSION_ID', '').strip('"') in {'22.04', '24.04'}


def port_number(value):
    try:
        port = int(value)
    except ValueError:
        raise argparse.ArgumentTypeError('Port must be an integer from 1 to 65535.')
    if not 1 <= port <= 65535:
        raise argparse.ArgumentTypeError('Port must be an integer from 1 to 65535.')
    return port


def port_listening(port):
    try:
        with socket.create_connection(('127.0.0.1', port), timeout=1):
            return True
    except OSError:
        return False


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--port', type=port_number, default=5432,
                        help='Loopback PostgreSQL port to inspect; default 5432. Does not change .env.')
    parser.add_argument('--offline', action='store_true', help='Skip external HTTPS probes.')
    args = parser.parse_args(argv)
    failures = 0

    def report(level, message):
        nonlocal failures
        if level == 'FAIL':
            failures += 1
        print(f'{level}: {message}')

    report('PASS' if supported_os() else 'FAIL',
           'Supported installation target is Ubuntu 22.04/24.04; run inside Ubuntu, including on WSL.')
    report('PASS' if (3, 10) <= sys.version_info[:2] <= (3, 12) else 'FAIL',
           'Python 3.10–3.12 is the tested range.')
    if hasattr(os, 'geteuid') and os.geteuid() == 0:
        report('FAIL', 'Use an ordinary Ubuntu account; setup requests sudo only for administration.')
    for tool in ('sudo', 'apt-get', 'git'):
        report('PASS' if shutil.which(tool) else 'FAIL', f'{tool} is required for the installation route.')
    if shutil.which('sudo'):
        try:
            result = subprocess.run(['sudo', '-n', '-l'], capture_output=True, timeout=5)
            report('PASS' if result.returncode == 0 else 'WARN',
                   'Non-interactive sudo policy query ' + ('succeeded; setup may still request authentication.'
                   if result.returncode == 0 else 'could not confirm access. Ask your administrator; no password was requested.'))
        except (OSError, subprocess.TimeoutExpired):
            report('WARN', 'Could not inspect sudo policy. Confirm authorization with your administrator.')
    report('PASS' if os.access(ROOT, os.W_OK) else 'FAIL', 'Checkout must be writable by your Ubuntu account.')
    free = shutil.disk_usage(ROOT).free / 1024**3
    report('PASS' if free >= 4 else 'WARN',
           f'{free:.1f} GiB disk available; plan at least 4 GiB free, more for optional experiments.')
    if str(ROOT).startswith('/mnt/'):
        report('WARN', 'Use the Ubuntu home filesystem for reliable private-file permissions in WSL.')
    if port_listening(args.port):
        report('WARN', f'Port {args.port} accepts loopback connections. Identify its service before setup; see docs/setup.md.')
    else:
        report('PASS', f'No TCP listener observed on loopback port {args.port}; setup will start PostgreSQL.')
    report('WARN', 'Loopback probe is not a complete port reservation or PostgreSQL identity check.')
    if args.offline:
        report('WARN', 'Connectivity not checked (--offline). Initial installation requires downloads.')
    else:
        for url in ('https://pypi.org/simple/', 'https://archive.ubuntu.com/ubuntu/'):
            try:
                req = urllib.request.Request(url, method='HEAD')
                with urllib.request.urlopen(req, timeout=5):
                    pass
                report('PASS', 'HTTPS reachable: ' + url)
            except (OSError, urllib.error.URLError):
                report('WARN', 'HTTPS probe failed: ' + url + ' Check your approved network/proxy.')
        report('WARN', 'Probes do not verify every configured apt mirror or package download host.')
    print('Read docs/setup.md for WARN/FAIL recovery. No files, packages or services were changed.')
    return 1 if failures else 0


if __name__ == '__main__':
    raise SystemExit(main())
