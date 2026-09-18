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
        print(f"SQL stopped: SQLSTATE {error.pgcode}. 42501 means permission denied; inspect your SQL locally.", file=sys.stderr)
        return 1
    print(json.dumps(rows, indent=2, default=str))
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except Exception:
        print("STOP: check the SQL file, service and private configuration. No connection details printed.", file=sys.stderr)
        sys.exit(1)
