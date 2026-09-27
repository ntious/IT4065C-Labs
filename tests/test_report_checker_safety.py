# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
"""Regression coverage for advisory feedback, private inputs and safe output."""
import contextlib
import io
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest
from unittest.mock import patch
import zipfile

from grading.readers import read_report, ReportReadError
from grading.report_checker import check_report, _lab3_local_artifacts, _lab5_access_evidence
from scripts.check_report import main

ROOT = Path(__file__).resolve().parents[1]


class CheckerSafetyTests(unittest.TestCase):
    def test_actual_blank_worksheets_are_flagged(self):
        for lab, name in ((4, 'lab04-lineage-lifecycle/_turnin_template.md'),
                          (7, 'lab07-ai-governance/ai_decision_template.md')):
            with self.subTest(lab=lab):
                report = check_report(lab, [ROOT / 'labs/core' / name], local_cross_checks=False)
                self.assertEqual(report.structural_status, 'CHECK FLAGGED ITEMS')

    def test_underscores_and_multiline_prompts(self):
        for text in ('FNR: ___ / ___ = ___', '[If you used AI assistance,\nexplain it here.]', '[Write the command you used.]'):
            with tempfile.TemporaryDirectory() as td:
                p = Path(td) / 'report.txt'; p.write_text(text)
                r = check_report(1, [p], local_cross_checks=False)
                self.assertTrue(any(x.status == 'MISSING' for x in r.results))

    def test_alternative_wording_does_not_prohibit_submission(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td) / 'report.txt'; p.write_text('An alternative structure with explanation. ' * 10)
            r = check_report(5, [p], local_cross_checks=False)
            self.assertEqual(r.structural_status, 'REVIEW SUGGESTIONS')
            self.assertFalse(any(x.status == 'MISSING' for x in r.results))

    def test_two_customer_fields_do_not_pass_lab2_pair_check(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td) / 'report.txt'; p.write_text('first_name last_name')
            r = check_report(2, [p], local_cross_checks=False)
            self.assertEqual(next(x.status for x in r.results if x.name == 'Two independent field decisions'), 'WARN')

    def test_output_preserves_report_and_symlink_target(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td) / 'report.md'; p.write_text('Private report text')
            link = Path(td) / 'result.json'; link.symlink_to(p)
            for out in (p, link):
                with contextlib.redirect_stderr(io.StringIO()):
                    self.assertEqual(main(['1', str(p), '--no-local-cross-check', '--json-file', str(out)]), 2)
                self.assertEqual(p.read_text(), 'Private report text')

    def test_json_output_does_not_echo_paths_or_secrets(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td) / 'report.md'; p.write_text('password=synthetic-test-value\n')
            out = Path(td) / 'result.json'
            buffer = io.StringIO()
            with contextlib.redirect_stdout(buffer):
                main(['1', str(p), '--no-local-cross-check', '--json', '--json-file', str(out)])
            payload = json.loads(buffer.getvalue())
            self.assertEqual(payload, json.loads(out.read_text()))
            self.assertNotIn(td, buffer.getvalue())
            self.assertNotIn('synthetic-test-value', buffer.getvalue())
            self.assertEqual(payload['files'], ['report.md'])

    def test_unreadable_and_bad_inputs_have_clean_errors(self):
        with tempfile.TemporaryDirectory() as td:
            for filename, data in (('bad.docx', b'not zip'), ('bad.txt', b'\xff')):
                p = Path(td) / filename; p.write_bytes(data)
                with contextlib.redirect_stderr(io.StringIO()):
                    self.assertEqual(main(['1', str(p)]), 2)

    def test_docx_resource_and_entity_limits(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td) / 'report.docx'
            with zipfile.ZipFile(p, 'w', compression=zipfile.ZIP_DEFLATED) as z:
                z.writestr('word/document.xml', b'x' * 2000)
            with patch('grading.readers.MAX_REPORT_BYTES', 1000):
                with self.assertRaises(ReportReadError): read_report(p)
            with zipfile.ZipFile(p, 'w') as z:
                z.writestr('word/document.xml', '<!DOCTYPE x [<!ENTITY x "x">]><x/>')
            with self.assertRaises(ReportReadError): read_report(p)

    def test_failed_dbt_tests_never_receive_pass(self):
        with tempfile.TemporaryDirectory() as td:
            root = Path(td); target = root / 'dbt/it4065c_platform/target'; target.mkdir(parents=True)
            names = ['lab3_guided_daily_orders', 'lab3_my_sales_rule']
            (target / 'manifest.json').write_text(json.dumps({'nodes': {n: {'name': n} for n in names}}))
            for status in ('fail', 'error', 'skipped'):
                (target / 'run_results.json').write_text(json.dumps({'results': [{'unique_id': n, 'status': status} for n in names]}))
                r = _lab3_local_artifacts(root)
                self.assertEqual(next(x.status for x in r if x.name == 'Local dbt result cross-check'), 'WARN')

    def test_malformed_local_artifacts_do_not_crash(self):
        with tempfile.TemporaryDirectory() as td:
            root = Path(td); target = root / 'dbt/it4065c_platform/target'; target.mkdir(parents=True)
            (target / 'manifest.json').write_text('{"nodes": {}}')
            for value in (None, {}, [None, {'unique_id': []}]):
                (target / 'run_results.json').write_text(json.dumps({'results': value}))
                self.assertTrue(any(x.status == 'WARN' for x in _lab3_local_artifacts(root)))

    def test_access_crosscheck_uses_event_fields_not_arbitrary_text(self):
        with tempfile.TemporaryDirectory() as td:
            root = Path(td); (root / '.local').mkdir()
            p = root / '.local/access-evidence.json'
            p.write_text('["00000", "42501"]')
            self.assertEqual(_lab5_access_evidence(root)[0].status, 'WARN')
            p.write_text(json.dumps([{'expected_allowed': a, 'sqlstate': s, 'evidence_type': 'live_client_observation'} for a, s in ((True, '00000'), (False, '42501'))]))
            self.assertEqual(_lab5_access_evidence(root)[0].status, 'PASS')

    def test_all_wrappers_accept_json_from_outside_repo(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td) / 'report.txt'; p.write_text('Some independently written report text. ' * 5)
            for lab in range(1, 8):
                run = subprocess.run([sys.executable, str(ROOT / f'scripts/report_checks/lab{lab:02}.py'), str(p), '--json', '--no-local-cross-check'], cwd=td, capture_output=True, text=True)
                self.assertEqual(run.returncode, 0, run.stderr)
                self.assertEqual(json.loads(run.stdout)['lab'], lab)
