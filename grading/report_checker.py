# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
from __future__ import annotations

from dataclasses import dataclass, asdict
from datetime import datetime, timezone
import json
from pathlib import Path
import re
from typing import Iterable

from .readers import normalize_for_match, normalized_lines, read_report, ReportReadError
from .specs import LAB_SPECS, LAB2_ALLOWED_INDEPENDENT_FIELDS, CLASSIFICATION_TERMS


@dataclass
class CheckResult:
    status: str
    name: str
    detail: str = ""
    source: str = "report"

    def to_dict(self) -> dict:
        return asdict(self)


@dataclass
class ReportCheckSummary:
    lab: int
    title: str
    files: list[str]
    generated_at: str
    results: list[CheckResult]
    structural_status: str

    def counts(self) -> dict[str, int]:
        out = {"PASS": 0, "WARN": 0, "MISSING": 0, "REVIEW": 0}
        for item in self.results:
            out[item.status] = out.get(item.status, 0) + 1
        return out

    def to_dict(self) -> dict:
        return {
            "lab": self.lab,
            "title": self.title,
            "files": self.files,
            "generated_at": self.generated_at,
            "structural_status": self.structural_status,
            "counts": self.counts(),
            "results": [r.to_dict() for r in self.results],
        }


PLACEHOLDER_PATTERNS = [
    re.compile(r"\[\s*(?:write|paste|name|propose|briefly explain|if you used)\b[^\]]*\]", re.I),
    re.compile(r"\[\s*write here\s*\]", re.I),
    re.compile(r"\[\s*paste here[^\]]*\]", re.I),
    re.compile(r"\[\s*answer(?: here| question)?[^\]]*\]", re.I),
    re.compile(r"\[\s*blank\s*\d+\s*\]", re.I),
    re.compile(r"\[\s*replace[^\]]*\]", re.I),
    re.compile(r"(?<!\w)_{3,}(?!\w)"),
]

PRIVACY_PATTERNS = [
    ("Possible password assignment", re.compile(r"\b(?:password|passwd|pgpassword)\s*[:=]\s*\S+", re.I)),
    ("Possible password assignment", re.compile(r"\bIT4065C_[A-Z0-9_]*PASSWORD\s*=\s*\S+", re.I)),
    ("Possible credential-bearing PostgreSQL URL", re.compile(r"postgres(?:ql)?://[^\s:@/]+:[^\s@/]+@", re.I)),
    ("Possible personal Windows path", re.compile(r"[A-Za-z]:\\Users\\[^\\\s]+\\", re.I)),
    ("Possible personal Linux home path", re.compile(r"/home/[A-Za-z0-9._-]+/", re.I)),
    ("Possible shell prompt with username/hostname", re.compile(r"\b[A-Za-z0-9._-]+@[A-Za-z0-9._-]+:[^\n$]{0,120}\$")),
]


def _contains_any(text_norm: str, aliases: Iterable[str]) -> bool:
    return any(normalize_for_match(alias) in text_norm for alias in aliases)


def _section_present(lines_norm: list[str], aliases: Iterable[str]) -> bool:
    aliases_norm = [normalize_for_match(a) for a in aliases]
    for line in lines_norm:
        n = normalize_for_match(line)
        for alias in aliases_norm:
            if n == alias or n.startswith(alias + ":") or n.startswith(alias + " "):
                return True
            # Accept numbered section headings after Markdown/word-processing extraction.
            if re.match(r"^\d+(?:\.\d+)?\s+", n) and alias in n:
                return True
    return False


def _check_common(text: str) -> list[CheckResult]:
    results: list[CheckResult] = []
    placeholders = []
    # Ignore instructions that mention a placeholder literally in inline code.
    prompt_text = re.sub(r"`[^`\n]+`", "", text)
    for pattern in PLACEHOLDER_PATTERNS:
        placeholders.extend(pattern.findall(prompt_text))
    if placeholders:
        results.append(CheckResult("MISSING", "Unfinished placeholders", f"Found {len(placeholders)} unfinished placeholder(s). Replace them before submitting."))
    else:
        results.append(CheckResult("PASS", "Unfinished placeholders", "No common answer placeholders detected."))

    privacy_hits = []
    for label, pattern in PRIVACY_PATTERNS:
        if pattern.search(text):
            privacy_hits.append(label)
    if privacy_hits:
        results.append(CheckResult("WARN", "Privacy scan", "; ".join(privacy_hits) + ". Review and redact before submission."))
    else:
        results.append(CheckResult("PASS", "Privacy scan", "No supported privacy pattern detected in extracted text. Images, metadata and other secrets are not checked."))

    if len(text.strip()) < 120:
        results.append(CheckResult("WARN", "Report length", "The supplied text is very short; confirm that the correct completed report was selected."))
    else:
        results.append(CheckResult("PASS", "Report length", "Text-length threshold met; length does not establish completeness."))
    return results


def _lab2_two_fields(text_norm: str) -> CheckResult:
    found = sorted(field for field in LAB2_ALLOWED_INDEPENDENT_FIELDS if re.search(rf"\b{re.escape(field)}\b", text_norm))
    customer = any(f in found for f in ("first_name", "last_name", "phone_number")) or "customers.customer_id" in text_norm
    order = any(f in found for f in ("order_id", "order_date", "order_status", "payment_method")) or "orders.customer_id" in text_norm
    if customer and order:
        return CheckResult("PASS", "Two independent field decisions", "Field-name markers only; verify one customer and one order decision yourself: " + ", ".join(found[:5]))
    return CheckResult("WARN", "Two independent field decisions", "Could not recognize both a customer field and an order field. Check that you explain one customer field and one order field, including the table for each; this scan cannot establish that distinction.")


def _lab2_classification_terms(text_norm: str) -> CheckResult:
    found = sorted(term for term in CLASSIFICATION_TERMS if re.search(rf"\b{term}\b", text_norm))
    if len(found) >= 2:
        return CheckResult("PASS", "Classification choices", "Detected classification terminology: " + ", ".join(found))
    if len(found) == 1:
        return CheckResult("WARN", "Classification choices", f"Only one classification term was detected ({found[0]}). Confirm both field decisions and the alternative classification are present.")
    return CheckResult("WARN", "Classification choices", "No recognized classification labels were detected.")


def _lab6_simulated_not_observed(text: str) -> CheckResult:
    finding = r"(?:REPEATED_DENIAL|ROLE_SWITCH|AFTER_HOURS_EXPORT)"
    suspicious = (
        re.search(rf"\b(?:observed|actual|real)\s+{finding}\b", text, re.I)
        or re.search(rf"\b{finding}\b\s+(?:was|is)\s+(?:observed|actual|real)\b", text, re.I)
        or re.search(rf"\b{finding}\b\s+(?:came from|represents)\s+(?:a\s+)?real\b", text, re.I)
    )
    if suspicious:
        return CheckResult("WARN", "Simulated-versus-observed wording", "A named fixture finding appears to be described explicitly as observed/actual/real. Confirm the report labels it as simulated.")
    return CheckResult("PASS", "Simulated-versus-observed wording", "No explicit wording conflict detected for the named simulated findings.")


def _load_json(path: Path) -> dict | list | None:
    try:
        if path.stat().st_size > 20 * 1024 * 1024:
            return None
        return json.loads(path.read_text(encoding="utf-8"))
    except (OSError, UnicodeError, json.JSONDecodeError):
        return None


def _lab3_local_artifacts(root: Path) -> list[CheckResult]:
    results: list[CheckResult] = []
    test_file = root / "dbt/it4065c_platform/student_tests/lab3_my_sales_rule.sql"
    if test_file.exists():
        results.append(CheckResult("PASS", "Local independent test file", str(test_file.relative_to(root)), "local"))
    else:
        results.append(CheckResult("WARN", "Local independent test file", "dbt/it4065c_platform/student_tests/lab3_my_sales_rule.sql was not found. This may be expected if the report is being checked outside the student's working repository.", "local"))

    run_results = root / "dbt/it4065c_platform/target/run_results.json"
    manifest = root / "dbt/it4065c_platform/target/manifest.json"
    if not run_results.exists() or not manifest.exists():
        results.append(CheckResult("WARN", "Local dbt result cross-check", "Current dbt manifest/run_results files were not available for cross-checking.", "local"))
        return results
    rr = _load_json(run_results)
    mf = _load_json(manifest)
    if not isinstance(rr, dict) or not isinstance(mf, dict):
        results.append(CheckResult("WARN", "Local dbt result cross-check", "dbt result artifacts could not be parsed.", "local"))
        return results
    nodes = mf.get("nodes", {})
    if not isinstance(nodes, dict) or not isinstance(rr.get("results"), list):
        return results + [CheckResult("WARN", "Local dbt result cross-check", "Unexpected dbt artifact structure.", "local")]
    seen: dict[str, str] = {}
    for result in rr.get("results", []):
        if not isinstance(result, dict):
            continue
        uid = result.get("unique_id")
        if not isinstance(uid, str):
            continue
        node = nodes.get(uid, {})
        name = node.get("name") if isinstance(node, dict) else None
        if isinstance(name, str):
            seen[name] = str(result.get("status"))
    missing = [name for name in ("lab3_guided_daily_orders", "lab3_my_sales_rule") if name not in seen]
    if missing:
        results.append(CheckResult("WARN", "Local dbt result cross-check", "Named test(s) absent from the most recent run: " + ", ".join(missing), "local"))
    else:
        status = "PASS" if all(seen[n] == "pass" for n in ("lab3_guided_daily_orders", "lab3_my_sales_rule")) else "WARN"
        results.append(CheckResult(status, "Local dbt result cross-check", f"Recorded statuses: guided={seen['lab3_guided_daily_orders']}; independent={seen['lab3_my_sales_rule']}. This does not verify freshness or report provenance.", "local"))
    results.append(CheckResult("REVIEW", "Artifact freshness", "Local artifacts may be from an earlier run. Use the Lab 3 named-result checker after running your current tests; this report checker does not bind artifacts to current SQL or authenticate evidence.", "local"))
    return results


def _lab5_access_evidence(root: Path) -> list[CheckResult]:
    path = root / ".local/access-evidence.json"
    if not path.exists():
        return [CheckResult("WARN", "Local access evidence", ".local/access-evidence.json not found; report structure can still be checked.", "local")]
    data = _load_json(path)
    if not isinstance(data, list):
        return [CheckResult("WARN", "Local access evidence", "Access evidence JSON could not be parsed.", "local")]
    valid = [e for e in data if isinstance(e, dict) and e.get("evidence_type") == "live_client_observation"]
    allowed = any(e.get("expected_allowed") is True and e.get("sqlstate") == "00000" for e in valid)
    denied = any(e.get("expected_allowed") is False and e.get("sqlstate") == "42501" for e in valid)
    if allowed and denied:
        return [CheckResult("PASS", "Local access evidence", "Allow and denial fields are recorded in .local/access-evidence.json; authenticity and freshness are not verified.", "local")]
    return [CheckResult("WARN", "Local access evidence", "Expected allow/deny SQLSTATE evidence was not detected in the local JSON.", "local")]


def _lab6_audit_report(root: Path) -> list[CheckResult]:
    path = root / ".local/audit-report.json"
    if not path.exists():
        return [CheckResult("WARN", "Local audit report", ".local/audit-report.json not found; report structure can still be checked.", "local")]
    data = _load_json(path)
    if not isinstance(data, dict):
        return [CheckResult("WARN", "Local audit report", "Audit report JSON could not be parsed.", "local")]
    required = {"live_client_events", "simulated_incidents", "limitation"}
    missing = sorted(required - set(data))
    if missing:
        return [CheckResult("WARN", "Local audit report", "Missing expected JSON key(s): " + ", ".join(missing), "local")]
    return [CheckResult("PASS", "Local audit report", "Expected live, simulated, and limitation keys are present; their content, authenticity and freshness are not verified.", "local")]


def _lab7_ai_evaluation(root: Path) -> list[CheckResult]:
    path = root / ".local/ai-evaluation.json"
    if not path.exists():
        return [CheckResult("WARN", "Local AI evaluation", ".local/ai-evaluation.json not found; report structure can still be checked.", "local")]
    data = _load_json(path)
    try:
        baseline_b = data["baseline"]["B"]
        mitigated_b = data["mitigated"]["B"]
        ok = (
            abs(float(baseline_b["false_negative_rate"]) - 0.75) < 1e-9
            and abs(float(mitigated_b["false_negative_rate"]) - 0.25) < 1e-9
            and abs(float(mitigated_b["false_positive_rate"]) - 0.5) < 1e-9
        )
    except (TypeError, KeyError, ValueError, IndexError, OverflowError):
        ok = False
    if ok:
        return [CheckResult("PASS", "Local AI evaluation", "Key supplied-fixture Lab 7 metrics match the expected local report.", "local")]
    return [CheckResult("WARN", "Local AI evaluation", "Expected supplied-fixture Lab 7 metric values were not confirmed in the local JSON.", "local")]


def _lab7_default_worksheet(root: Path) -> list[CheckResult]:
    path = root / ".local/lab7-decision.md"
    if not path.exists():
        return [CheckResult("WARN", "Local Lab 7 worksheet", ".local/lab7-decision.md not found. If the worksheet is embedded in another submitted file, this warning can be ignored.", "local")]
    text = path.read_text(encoding="utf-8", errors="replace")
    if any(pattern.search(text) for pattern in PLACEHOLDER_PATTERNS):
        return [CheckResult("WARN", "Local Lab 7 worksheet", "The default worksheet still appears to contain unfinished placeholders.", "local")]
    return [CheckResult("PASS", "Local Lab 7 worksheet", "Default worksheet exists and no common placeholders were detected.", "local")]


CUSTOM_CHECKS = {
    "lab2_two_fields": lambda text, norm: [_lab2_two_fields(norm)],
    "lab2_classification_terms": lambda text, norm: [_lab2_classification_terms(norm)],
    "lab6_simulated_not_observed": lambda text, norm: [_lab6_simulated_not_observed(text)],
}

LOCAL_CHECKS = {
    "lab3_local_artifacts": _lab3_local_artifacts,
    "lab5_access_evidence": _lab5_access_evidence,
    "lab6_audit_report": _lab6_audit_report,
    "lab7_ai_evaluation": _lab7_ai_evaluation,
    "lab7_default_worksheet": _lab7_default_worksheet,
}


def find_repo_root(start: Path | None = None) -> Path | None:
    current = (start or Path.cwd()).resolve()
    for candidate in [current, *current.parents]:
        if (candidate / ".git").exists() and (candidate / "labs/core").exists():
            return candidate
    return None


def check_report(lab: int, files: list[str | Path], *, root: Path | None = None, local_cross_checks: bool = True) -> ReportCheckSummary:
    if lab not in LAB_SPECS:
        raise ValueError("Lab must be an integer from 1 through 7.")
    if not files:
        raise ValueError("At least one report file is required.")

    contents = []
    file_names = []
    for file in files:
        path = Path(file)
        contents.append(read_report(path))
        file_names.append(path.name)
    combined = "\n\n".join(contents)
    combined_norm = normalize_for_match(combined)
    lines_norm = normalized_lines(combined)

    spec = LAB_SPECS[lab]
    results: list[CheckResult] = []
    results.extend(_check_common(combined))

    for label, aliases in spec.get("sections", []):
        if _section_present(lines_norm, aliases):
            results.append(CheckResult("PASS", label, "Heading marker detected; this does not establish that its answer is complete."))
        else:
            results.append(CheckResult("WARN", label, "Heading marker not recognized. Check the lab guide; equivalent wording or an allowed table may already cover this. Do not duplicate an answer just to satisfy the checker."))

    for label, alternatives in spec.get("required_any", []):
        if _contains_any(combined_norm, alternatives):
            results.append(CheckResult("PASS", label, "Expected evidence/content marker detected."))
        else:
            results.append(CheckResult("WARN", label, "Marker not recognized. Check the lab submission checklist and your own evidence; images and alternative wording may not be readable by this checker."))

    for custom in spec.get("custom", []):
        results.extend(CUSTOM_CHECKS[custom](combined, combined_norm))

    results.append(CheckResult("REVIEW", "Coverage limits", "Only extracted body text is checked. Images, document metadata, equivalent wording and linked-only evidence require manual review. Empty answers or copied examples can contain matching markers.", "rubric"))
    repo_root = root or find_repo_root()
    if local_cross_checks:
        if repo_root is None:
            results.append(CheckResult("WARN", "Local artifact cross-checks", "Repository root was not detected; local evidence artifacts were not checked.", "local"))
        else:
            for local_check in spec.get("local_checks", []):
                results.extend(LOCAL_CHECKS[local_check](repo_root))

    for note in spec.get("review", []):
        results.append(CheckResult("REVIEW", "Academic review required", note, "rubric"))

    missing = sum(1 for r in results if r.status == "MISSING")
    warnings = sum(1 for r in results if r.status == "WARN")
    if missing:
        status = "CHECK FLAGGED ITEMS"
    elif warnings:
        status = "REVIEW SUGGESTIONS"
    else:
        status = "NO AUTOMATIC FLAGS"

    return ReportCheckSummary(
        lab=lab,
        title=spec["title"],
        files=file_names,
        generated_at=datetime.now(timezone.utc).isoformat(),
        results=results,
        structural_status=status,
    )


def format_summary(summary: ReportCheckSummary, *, fix_guide: bool = False) -> str:
    lines = []
    lines.append(f"IT4065C LAB {summary.lab} REPORT CHECK: {summary.title}")
    lines.append("=" * 72)
    lines.append("Files:")
    for file in summary.files:
        lines.append(f"  - {file}")
    lines.append("")
    for item in summary.results:
        lines.append(f"{item.status:<7} {item.name}")
        if item.detail:
            lines.append(f"        {item.detail}")
    counts = summary.counts()
    lines.append("")
    lines.append("-" * 72)
    lines.append(
        f"PASS: {counts.get('PASS', 0)}   WARN: {counts.get('WARN', 0)}   "
        f"MISSING: {counts.get('MISSING', 0)}   REVIEW: {counts.get('REVIEW', 0)}"
    )
    lines.append(f"STRUCTURAL STATUS: {summary.structural_status}")
    lines.append("This checker looks for text markers and selected local artifact fields; it cannot certify completeness.")
    lines.append("It does not grade reasoning or replace the lab submission checklist.")
    lines.append("Review flags in context; passing is not a submission requirement. No report is uploaded.")
    if fix_guide and (counts.get("MISSING", 0) or counts.get("WARN", 0)):
        lines.append("")
        lines.append("ITEMS TO CHECK")
        lines.append("-----------")
        for item in summary.results:
            if item.status in {"MISSING", "WARN"}:
                lines.append(f"- {item.name}: {item.detail}")
        lines.append(f"See labs/core/lab0{summary.lab}-*/README.md for the exact submission checklist.")
    return "\n".join(lines)
