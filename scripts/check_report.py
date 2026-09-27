# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import os
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
if str(ROOT) not in sys.path:
    sys.path.insert(0, str(ROOT))

from grading.report_checker import check_report, format_summary, find_repo_root  # noqa: E402
from grading.readers import ReportReadError  # noqa: E402


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        description="Check an IT4065C Lab 1–7 report for structural readiness before submission."
    )
    parser.add_argument("lab", type=int, choices=range(1, 8), help="Lab number, 1 through 7")
    parser.add_argument("files", nargs="+", help="Report file(s): .md, .txt, or .docx")
    parser.add_argument("--json", action="store_true", dest="json_output", help="Print machine-readable JSON instead of the checklist")
    parser.add_argument("--json-file", metavar="PATH", help="Also save the result as JSON")
    parser.add_argument("--fix-guide", action="store_true", help="Print a compact list of flags to review")
    parser.add_argument("--no-local-cross-check", action="store_true", help="Skip checks of local lab artifacts such as dbt/JSON evidence")
    return parser


def main(argv: list[str] | None = None) -> int:
    args = build_parser().parse_args(argv)
    repo_root = find_repo_root()
    try:
        summary = check_report(
            args.lab,
            args.files,
            root=repo_root,
            local_cross_checks=not args.no_local_cross_check,
        )
    except (ValueError, OSError, ReportReadError) as exc:
        print("ERROR: " + (str(exc) if isinstance(exc, ValueError) else "Could not read input; check file access."), file=sys.stderr)
        return 2

    payload = summary.to_dict()
    if args.json_file:
        out = Path(args.json_file)
        try:
            # Exclusive creation protects reports, artifacts and symlink targets.
            out.parent.mkdir(parents=True, exist_ok=True)
            fd = os.open(out, os.O_WRONLY | os.O_CREAT | os.O_EXCL, 0o600)
            with os.fdopen(fd, "w", encoding="utf-8") as stream:
                stream.write(json.dumps(payload, indent=2) + "\n")
        except OSError:
            print("ERROR: Could not create JSON output. Choose a new private filename; existing files are never overwritten.", file=sys.stderr)
            return 2

    if args.json_output:
        print(json.dumps(payload, indent=2))
    else:
        print(format_summary(summary, fix_guide=args.fix_guide))

    return 1 if summary.structural_status == "CHECK FLAGGED ITEMS" else 0


if __name__ == "__main__":
    raise SystemExit(main())
