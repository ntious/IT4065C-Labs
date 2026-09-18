# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
"""Optional experiments by Isaac K. Nti: ingestion and quality-gated publication."""
import argparse
from contextlib import closing
import csv
from datetime import date
from decimal import Decimal, InvalidOperation
import hashlib
import json
import re
import sys
from course import Course, ROOT, require


class QualityGateError(ValueError):
    pass


def curate(source=ROOT / "data/ingestion"):
    """Allowlist approved fields; quarantine locations/reasons, not raw personal data."""
    catalog, accepted, rejected = [], [], []
    for name, kind in (("sales.csv", "structured"), ("events.jsonl", "semi-structured"), ("purpose.txt", "unstructured")):
        path = source / name
        catalog.append({"source": name, "type": kind, "sha256": hashlib.sha256(path.read_bytes()).hexdigest(),
                        "owner": "Retail Data Steward", "purpose": "Daily aggregate reporting",
                        "ai_use": "Individual profiling not approved"})
        if kind == "unstructured":
            continue
        with path.open(encoding="utf-8", newline="") as stream:
            records = list(csv.DictReader(stream)) if kind == "structured" else list(stream)
        for index, raw in enumerate(records, 1):
            try:
                row = json.loads(raw) if isinstance(raw, str) else raw
                require(isinstance(row, dict), "Record must be an object")
                identifier = row.get("record_id", "")
                require(isinstance(identifier, str) and re.fullmatch(r"[a-z]+-[0-9]+", identifier), "Invalid or missing identifier")
                day = date.fromisoformat(row["event_date"])
                amount = Decimal(row["amount"])
                require(amount.is_finite() and Decimal("0") < amount <= Decimal("1000000"), "Invalid amount")
                require(amount == amount.quantize(Decimal("0.01")), "Amount needs at most two decimal places")
                accepted.append({"record_id": identifier, "event_date": day.isoformat(), "amount": str(amount), "source": name})
            except (ValueError, TypeError, KeyError, InvalidOperation):
                rejected.append({"source": name, "record_number": index, "reason": "Schema or value validation failed"})
    return {"catalog": catalog, "accepted": accepted, "quarantine": rejected}


def catalog_lab():
    result = curate()
    require(len(result["accepted"]) == 3 and len(result["quarantine"]) == 2, "Original fixture counts changed; inspect your experiment.")
    require(sum(Decimal(r["amount"]) for r in result["accepted"]) == Decimal("45.00"), "Curated total changed.")
    private = ROOT / ".local"
    private.mkdir(mode=0o700, exist_ok=True)
    (private / "ingestion-evidence.json").write_text(json.dumps(result, indent=2), encoding="utf-8")
    print("PASS: three source types cataloged; three approved records; two quarantined; total 45.00.")
    print("Contact fields and free text excluded. Evidence: .local/ingestion-evidence.json")
    return result


def publish(course, records):
    """Atomically replace only the optional lab's derived fixture summary."""
    ident = course.sql.Identifier(course.schema)
    with closing(course.connect()) as conn:
        conn.autocommit = False
        try:
            with conn.cursor() as cur:
                cur.execute("CREATE TEMP TABLE incoming_sales(record_id text,event_date date,amount numeric) ON COMMIT DROP")
                cur.executemany("INSERT INTO incoming_sales VALUES (%s,%s,%s)",
                                [(r["record_id"], r["event_date"], r["amount"]) for r in records])
                cur.execute("SELECT count(*)=count(DISTINCT record_id) AND count(*)>0 AND bool_and(record_id IS NOT NULL AND event_date IS NOT NULL AND amount IS NOT NULL AND amount>0) FROM incoming_sales")
                if cur.fetchone()[0] is not True:
                    raise QualityGateError("Quality gate blocked publication")
                cur.execute(course.sql.SQL("CREATE TABLE IF NOT EXISTS {}.optional_daily_sales(event_date date PRIMARY KEY, records integer NOT NULL, amount numeric NOT NULL)").format(ident))
                cur.execute(course.sql.SQL("DELETE FROM {}.optional_daily_sales").format(ident))
                cur.execute(course.sql.SQL("INSERT INTO {}.optional_daily_sales SELECT event_date,count(*),sum(amount) FROM incoming_sales GROUP BY event_date").format(ident))
            conn.commit()
        except Exception:
            conn.rollback()
            raise


def snapshot(course):
    return course.execute(course.sql.SQL("SELECT event_date,records,amount FROM {}.optional_daily_sales ORDER BY event_date").format(course.sql.Identifier(course.schema)))


def promotion_lab():
    course = Course()
    course.preflight()
    records = catalog_lab()["accepted"]
    publish(course, records)
    before = snapshot(course)
    try:
        publish(course, records + [records[0]])
    except QualityGateError:
        pass
    else:
        raise AssertionError("Duplicate data unexpectedly published")
    require(snapshot(course) == before, "Failed batch changed published data")
    publish(course, records)
    after = snapshot(course)
    require(after == before and sum(r[2] for r in after) == Decimal("45.00"), "Retry duplicated or changed published data")
    evidence = {"invalid_batch_blocked": True, "previous_publication_preserved": True,
                "retry_idempotent": True, "daily_sales": after, "total": "45.00",
                "limitation": "Local transactional batch; no distributed scheduler or actual regulatory certification."}
    (course.private / "promotion-evidence.json").write_text(json.dumps(evidence, indent=2, default=str), encoding="utf-8")
    # Static accessible report; all plotted values derive from the asserted query.
    rows = "".join(f"<tr><td>{day.isoformat()}</td><td>{count}</td><td>{amount:.2f}</td></tr>" for day, count, amount in after)
    bars = "".join(f'<div>{day.isoformat()} <meter min="0" max="45" value="{amount}">{amount:.2f}</meter> {amount:.2f}</div>' for day, _, amount in after)
    report = ('<!doctype html><html lang="en"><meta charset="utf-8"><title>Optional sales KPI</title>'
              '<h1>Governed daily sales</h1><p>Author: Isaac K. Nti. Synthetic fixture; total 45.00.</p>'
              '<table><caption>Accessible source values</caption><tr><th>Date</th><th>Records</th><th>Amount</th></tr>'
              + rows + '</table><h2>Daily comparison</h2>' + bars +
              '<p>The bad duplicate batch was blocked, the prior result preserved, and retry produced no duplicates.</p></html>')
    (course.private / "optional-kpi.html").write_text(report, encoding="utf-8")
    print("PASS: duplicate batch blocked; prior publication preserved; retry idempotent; KPI total 45.00.")
    print("Open .local/optional-kpi.html and interpret .local/promotion-evidence.json.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("lab", choices=("catalog", "promotion"))
    args = parser.parse_args()
    try:
        catalog_lab() if args.lab == "catalog" else promotion_lab()
    except Exception:
        print("STOP: optional lab failed. Check setup and the unmodified synthetic fixture; do not share secrets.", file=sys.stderr)
        sys.exit(1)
