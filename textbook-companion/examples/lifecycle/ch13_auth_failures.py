import os
"""Chapter 13 textbook example: failed authentication as recorded by the server (AUTH + AUTH-OBS).

Generates five failed logins for one identity, then reads the server's CSV log and applies the rule
"five or more failures for one identity in the ten minutes before the evaluation time".
- Only log records written at or after --since are counted, so earlier runs do not inflate the count.
- The rule is evaluated at an explicit evaluation time (default: now). An old burst does not stay
  "current" when the script is rerun later; with --evaluated-at it can be evaluated retrospectively.
- Empty input is handled: no failures means the rule does not fire.
- No client/server timestamp comparison is made: the client's observations and the server's records
  are not matched one-to-one here, so a per-event offset is not claimed .
Usage: python3 ch13_auth_failures.py --host 127.0.0.1 --port P --log-csv FILE [--evaluated-at ISO]
Exits 1 if the expected five server records are not found or the rule result is unexpected.
"""
import argparse, csv, datetime as dt, sys, time
import psycopg2
ap = argparse.ArgumentParser(); ap.add_argument("--host", default="127.0.0.1"); ap.add_argument("--port", type=int, required=True)
ap.add_argument("--log-csv", required=True); ap.add_argument("--evaluated-at", default=None); a = ap.parse_args()
UTC = dt.timezone.utc
since = dt.datetime.now(UTC).replace(microsecond=0) - dt.timedelta(seconds=1)
rejections = 0
for i in range(5):
    try:
        psycopg2.connect(host=a.host, port=a.port, dbname="ch11", user="svc_export", password="wrong-%d" % i).close()
    except psycopg2.OperationalError:
        rejections += 1
time.sleep(1.5)  # let the logging collector write
def parse(ts):  # csvlog log_time, e.g. "2026-11-09 13:07:34.702 UTC"
    return dt.datetime.strptime(ts[:23], "%Y-%m-%d %H:%M:%S.%f").replace(tzinfo=UTC)
with open(a.log_csv, newline="") as fh:
    rows = list(csv.reader(fh))
# csvlog columns: 0 log_time, 1 user_name, 2 database_name, ..., 12 sql_state_code, 13 message
fails = [r for r in rows if len(r) > 13 and r[12] == "28P01" and parse(r[0]) >= since]
svc = sorted(parse(r[0]) for r in fails if r[1] == "svc_export")
evaluated_at = dt.datetime.fromisoformat(a.evaluated_at) if a.evaluated_at else dt.datetime.now(UTC)
def fires(times, at):
    window = [t for t in times if dt.timedelta(0) <= at - t <= dt.timedelta(minutes=10)]
    return len(window) >= 5, len(window)
now_fires, now_count = fires(svc, evaluated_at)
later_fires, later_count = fires(svc, evaluated_at + dt.timedelta(hours=1))
empty_fires, _ = fires([], evaluated_at)
print(f"client observed rejections: {rejections}")
print(f"server 28P01 records for svc_export since {since.isoformat()}: {len(svc)}")
if fails:
    r = [x for x in fails if x[1] == "svc_export"][-1]
    print(f"example server record: time={r[0]} user={r[1]} db={r[2]} from={r[4]} sqlstate={r[12]} msg={r[13]}")
print(f"rule at evaluation time {evaluated_at.isoformat(timespec='seconds')}: fires={now_fires} (count in window={now_count})")
print(f"same records evaluated one hour later: fires={later_fires} (count in window={later_count})")
print(f"rule on empty input: fires={empty_fires}")
ok = rejections == 5 and len(svc) == 5 and now_fires and not later_fires and not empty_fires
print("RESULT:", "PASS" if ok else "FAIL")
sys.exit(0 if ok else 1)
