# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
from __future__ import annotations

import json
from pathlib import Path
import tempfile
import unittest
import zipfile

from grading.readers import read_report, ReportReadError
from grading.report_checker import check_report


SHARED_HEADINGS = """
# Lab and execution evidence
# Prediction or initial expectation
# Observed result and explanation
# Investigation and independent transfer
# Evidence limitations and questions
# Assistance and verification
"""


class ReaderTests(unittest.TestCase):
    def test_markdown_reader(self):
        with tempfile.TemporaryDirectory() as td:
            path = Path(td) / "report.md"
            path.write_text("# Heading\nBody\n", encoding="utf-8")
            self.assertIn("Heading", read_report(path))

    def test_docx_reader_without_external_dependency(self):
        with tempfile.TemporaryDirectory() as td:
            path = Path(td) / "report.docx"
            document_xml = b'''<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
  <w:body><w:p><w:r><w:t>Lab and execution evidence</w:t></w:r></w:p>
  <w:p><w:r><w:t>PASS: connection</w:t></w:r></w:p></w:body>
</w:document>'''
            with zipfile.ZipFile(path, "w") as zf:
                zf.writestr("word/document.xml", document_xml)
            text = read_report(path)
            self.assertIn("Lab and execution evidence", text)
            self.assertIn("PASS: connection", text)

    def test_rejects_unsupported_type(self):
        with tempfile.TemporaryDirectory() as td:
            path = Path(td) / "report.pdf"
            path.write_bytes(b"not a pdf")
            with self.assertRaises(ReportReadError):
                read_report(path)


class ReportCheckerTests(unittest.TestCase):
    def _write(self, td: str, name: str, text: str) -> Path:
        path = Path(td) / name
        path.write_text(text, encoding="utf-8")
        return path

    def test_lab1_ready_report(self):
        report = """
# Setup evidence
Command I actually ran: bash scripts/setup.sh
PASS: connection, dedicated database, schemas and non-superuser builder.
PASS: dbt debug

# Configuration path
The runner reads private .env configuration and supplies settings to the client.
The client connects to PostgreSQL, which checks the database login.

# Three short explanations
3.1 Ubuntu account and database login: The Ubuntu account manages files. PostgreSQL checks the database login.
3.2 Schema name and permission: A schema name does not grant SELECT privileges.
3.3 What dbt debug establishes and what it does not: It checks configuration and connection but does not prove later model data is correct.

# Assistance disclosure
None.
"""
        with tempfile.TemporaryDirectory() as td:
            path = self._write(td, "lab1.md", report)
            summary = check_report(1, [path], local_cross_checks=False)
            self.assertEqual(summary.structural_status, "NO AUTOMATIC FLAGS")
            self.assertFalse(any(r.status == "MISSING" for r in summary.results))

    def test_placeholder_makes_not_ready(self):
        with tempfile.TemporaryDirectory() as td:
            path = self._write(td, "lab1.md", "# Setup evidence\n[Write here]\n")
            summary = check_report(1, [path], local_cross_checks=False)
            self.assertEqual(summary.structural_status, "CHECK FLAGGED ITEMS")
            self.assertTrue(any(r.name == "Unfinished placeholders" and r.status == "MISSING" for r in summary.results))

    def test_privacy_warning(self):
        report = """
# Setup evidence
PASS: connection, dedicated database
PASS: dbt debug
IT4065C_DB_PASSWORD=supersecretvalue123456
# Configuration path
.env PostgreSQL
# Three short explanations
3.1 text
3.2 text
3.3 text
# Assistance disclosure
None
"""
        with tempfile.TemporaryDirectory() as td:
            path = self._write(td, "lab1.md", report)
            summary = check_report(1, [path], local_cross_checks=False)
            self.assertTrue(any(r.name == "Privacy scan" and r.status == "WARN" for r in summary.results))

    def test_lab2_detects_two_independent_fields_and_alternative(self):
        report = SHARED_HEADINGS + """
.venv/bin/python scripts/course.py lab 2
PASS: governance register.
Guided check: customers.created_at remained unchanged after rerun.
Field one: phone_number — Sensitive because of the stated contact purpose.
Field two: payment_method — Internal because it contains category labels in this fixture.
Alternative classification: payment_method could become Sensitive under a changed exposure assumption.
Evidence limitation: the register records policy but does not enforce access.
Assistance: None.
"""
        with tempfile.TemporaryDirectory() as td:
            path = self._write(td, "lab2.md", report)
            summary = check_report(2, [path], local_cross_checks=False)
            self.assertFalse(any(r.status == "MISSING" for r in summary.results), summary.to_dict())

    def test_lab3_local_named_tests_cross_check(self):
        report = SHARED_HEADINGS + """
.venv/bin/python scripts/course.py lab 3
PASS: 10 models and 39 data tests actually executed.
Revenue reconciles to 139.95; cancelled orders are excluded.
lab3_guided_daily_orders
lab3_my_sales_rule
Prediction recorded before execution. Limitation: a passing test does not prove all data is correct.
"""
        with tempfile.TemporaryDirectory() as td:
            root = Path(td)
            (root / ".git").mkdir()
            (root / "labs/core").mkdir(parents=True)
            tests_dir = root / "dbt/it4065c_platform/student_tests"
            tests_dir.mkdir(parents=True)
            (tests_dir / "lab3_my_sales_rule.sql").write_text("select 1 where false\n", encoding="utf-8")
            target = root / "dbt/it4065c_platform/target"
            target.mkdir(parents=True)
            manifest = {
                "nodes": {
                    "test.a": {"name": "lab3_guided_daily_orders"},
                    "test.b": {"name": "lab3_my_sales_rule"},
                }
            }
            results = {
                "results": [
                    {"unique_id": "test.a", "status": "pass"},
                    {"unique_id": "test.b", "status": "pass"},
                ]
            }
            (target / "manifest.json").write_text(json.dumps(manifest), encoding="utf-8")
            (target / "run_results.json").write_text(json.dumps(results), encoding="utf-8")
            report_path = self._write(td, "lab3.md", report)
            summary = check_report(3, [report_path], root=root, local_cross_checks=True)
            local = [r for r in summary.results if r.source == "local"]
            self.assertTrue(any(r.name == "Local independent test file" and r.status == "PASS" for r in local))
            self.assertTrue(any(r.name == "Local dbt result cross-check" and r.status == "PASS" for r in local))

    def test_lab4_ready_structure(self):
        report = """
# 0. Execution evidence and prediction
Command actually run and PASS evidence. Prediction compared with result.
# 1. Record the lineage you inspected
raw.orders -> stg_orders -> fct_orders -> olap_sales_by_day
raw.orders -> stg_orders -> fct_orders -> order_detail_mart
I inspected ref('fct_orders') in the daily mart.
# 2. Explain each lifecycle stage
## Staging: stg_orders
Completed transformation, quality check, permitted role, evidence and limitation.
## Core: fct_orders
Completed transformation, quality check, permitted role, evidence and limitation.
## Marts: olap_sales_by_day
Completed transformation, quality check, permitted role, evidence and limitation.
# 3. Reason about retention
Which copies could remain? Answered.
What would you refresh and verify? Answered.
What does the graph not prove or prevent? Answered.
# 4. Assistance disclosure
None.
"""
        with tempfile.TemporaryDirectory() as td:
            path = self._write(td, "lab4.md", report)
            summary = check_report(4, [path], local_cross_checks=False)
            self.assertFalse(any(r.status == "MISSING" for r in summary.results), summary.to_dict())

    def test_lab5_ready_structure(self):
        report = """
# A1: Technical evidence
.venv/bin/python scripts/course.py lab 5
PASS: nine access checks using separate authenticated connections.
# A2: Analyst sales
Allowed sales view result explained.
# A3: Analyst masked customers
SQLSTATE 42501 permission denied; this is expected authorization evidence.
# A4: Steward masked customers
Masked values observed and residual risk described.
# Authorization evidence
42501 differs from a wrong-password error.
# Proposed weekly-sales view
Status: Proposed. Purpose, grain, included fields, omitted fields, and remaining risk described.
# Remote-server discussion
Transport and credential-management controls discussed.
# Evidence limitation
These tested cases do not establish security of every object or future configuration.
# Recovery and assistance
None.
"""
        with tempfile.TemporaryDirectory() as td:
            path = self._write(td, "lab5.md", report)
            summary = check_report(5, [path], local_cross_checks=False)
            self.assertFalse(any(r.status == "MISSING" for r in summary.results), summary.to_dict())

    def test_lab6_flags_simulated_as_observed_wording(self):
        report = SHARED_HEADINGS + """
# Incident memo
## Evidence
scripts/course.py lab 6
live client allowed result SQLSTATE 00000 and live denied result SQLSTATE 42501.
I observed REPEATED_DENIAL in the real user activity.
## Detection limits
False-positive and missed-incident cases described.
## Response and ownership
Stronger evidence and ownership described.
Simulated fixture is discussed elsewhere.
"""
        with tempfile.TemporaryDirectory() as td:
            path = self._write(td, "lab6.md", report)
            summary = check_report(6, [path], local_cross_checks=False)
            self.assertTrue(any(r.name == "Simulated-versus-observed wording" and r.status == "WARN" for r in summary.results))

    def test_lab7_can_check_report_and_worksheet_together(self):
        report = SHARED_HEADINGS + """
scripts/course.py lab 7
PASS: AI metrics calculated.
Group B FNR calculation: 3 / 4 = 0.75.
The false negative rate and false positive rate create different tradeoffs.
The changed purpose is to restrict refunds.
"""
        worksheet = """
# Metric interpretation
Both FNR and FPR are discussed.
# Initial governance decision
Decision and rationale.
## Collection and curation
Completed.
## Storage and access
Completed.
## Preparation and evaluation
Completed.
## Use and disclosure
Completed.
## Monitoring and change
Completed.
## Retirement
Completed.
Govern: accountable role.
Map: context and affected population.
Measure: evidence and uncertainty.
Manage: action and review.
# Required change review
Refund restriction requires fresh evidence and review.
"""
        with tempfile.TemporaryDirectory() as td:
            p1 = self._write(td, "lab7-report.md", report)
            p2 = self._write(td, "lab7-decision.md", worksheet)
            summary = check_report(7, [p1, p2], local_cross_checks=False)
            self.assertFalse(any(r.status == "MISSING" for r in summary.results), summary.to_dict())


if __name__ == "__main__":
    unittest.main()
