# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
"""Execute a learner's local SQL file using course configuration, never admin credentials."""
import argparse
import json
from pathlib import Path
import sys
from course import Course, require


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("file", type=Path, help="Local SQL file; {{schema}} is safely replaced")
    parser.add_argument("--role", choices=("owner", "analyst", "steward"), default="owner")
    args = parser.parse_args()
    require(args.file.suffix == ".sql" and args.file.is_file(), "Supply an existing .sql file.")
    course = Course()
    course.preflight()
    try:
        rows = course.execute(course.template(args.file.resolve()), role=args.role)
    except course.pg.Error as error:
        hints = {
            "23514": "Check constraint failed. For Lab 2, use Public, Internal, Sensitive or Restricted; replace all template placeholders.",
            "42501": "Permission denied. Check the role and the lab's expected allow/deny behavior.",
            "42601": "SQL syntax error. Check quotes, commas and parentheses in your local file.",
        }
        hint = hints.get(error.pgcode, "Inspect your SQL locally; see the lab recovery guidance.")
        print(f"SQL stopped: SQLSTATE {error.pgcode}. {hint}", file=sys.stderr)
        return 1
    print(json.dumps(rows, indent=2, default=str))
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception:
        print("STOP: check the SQL file, service and private configuration. No connection details printed.", file=sys.stderr)
        sys.exit(1)
