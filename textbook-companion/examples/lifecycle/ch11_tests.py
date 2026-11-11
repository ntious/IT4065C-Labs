import os
"""Chapter 11 textbook example: positive and negative authorization tests (AUTH + AUTH-OBS).

Each case opens a NEW authenticated TCP connection (SCRAM) as the identity whose access is claimed
and compares the EXACT SQLSTATE with the expected one. A denial counts only if it is the expected
authorization error (42501); any other error (missing object 42P01, syntax error, connection
failure) is a mismatch. Allowed cases must also return the expected content.
The run exits 1 if any case mismatches or is missing, and 2 if the setup/connection is unusable.

Usage: python3 ch11_tests.py --host 127.0.0.1 --port P --admin-socket DIR --out results.json
       [--mutation missing_object|extra_grant]   (validator self-checks; must make the run fail)
"""
import argparse, json, sys, threading, time, datetime
import psycopg2

ap = argparse.ArgumentParser()
ap.add_argument("--host", default="127.0.0.1"); ap.add_argument("--port", type=int, required=True)
ap.add_argument("--admin-socket", required=True); ap.add_argument("--db", default="ch11")
ap.add_argument("--out", required=True); ap.add_argument("--mutation", default=None)
a = ap.parse_args()
PW = {"demo_analyst": os.environ["EDS_DEMO_ANALYST_PASSWORD"], "demo_steward": os.environ["EDS_DEMO_STEWARD_PASSWORD"],
      "demo_auditor": os.environ["EDS_DEMO_AUDITOR_PASSWORD"], "svc_export": os.environ["EDS_DEMO_SERVICE_PASSWORD"]}
INVENTORY = ("SELECT c.relname, a.grantee::regrole::text, a.privilege_type "
             "FROM pg_class c, LATERAL aclexplode(c.relacl) a "
             "WHERE c.relnamespace = 'reporting'::regnamespace AND a.grantee <> c.relowner ORDER BY 1, 2, 3")
EXPECTED_INVENTORY = [["v_customers_masked", "customer_steward", "SELECT"],
                      ["v_sales_by_day", "customer_steward", "SELECT"],
                      ["v_sales_by_day", "sales_analyst", "SELECT"],
                      ["v_sales_by_day", "svc_export", "SELECT"]]
# (identity, statement, expected SQLSTATE, expected rows or None)
CASES = [
 ("demo_analyst", "SELECT count(*) FROM reporting.v_sales_by_day", "00000", [[2]]),
 ("demo_analyst", "SELECT count(*) FROM reporting.v_customers_masked", "42501", None),
 ("demo_analyst", "SELECT count(*) FROM raw.customers", "42501", None),
 ("demo_analyst", "SET ROLE retail_owner", "42501", None),
 ("demo_steward", "SELECT count(*) FROM reporting.v_customers_masked", "00000", [[4]]),
 ("demo_steward", "SELECT count(*) FROM raw.customers", "42501", None),
 ("demo_steward", "UPDATE raw.customers SET email = email WHERE false", "42501", None),
 ("svc_export", "SELECT count(*) FROM reporting.v_sales_by_day", "00000", [[2]]),
 ("svc_export", "SELECT count(*) FROM reporting.v_customers_masked", "42501", None),
 ("demo_auditor", "SELECT count(*) FROM reporting.v_sales_by_day", "42501", None),
 ("demo_auditor", INVENTORY, "00000", EXPECTED_INVENTORY),
]
if a.mutation == "missing_object":   # an expected denial replaced by a query against a missing table
    CASES[1] = ("demo_analyst", "SELECT count(*) FROM reporting.no_such_view", "42501", None)

def admin():
    c = psycopg2.connect(host=a.admin_socket, port=a.port, user="admin", dbname=a.db); c.autocommit = True; return c

def run(user, sql):
    try:
        conn = psycopg2.connect(host=a.host, port=a.port, dbname=a.db, user=user, password=PW[user])
    except psycopg2.Error as e:
        return "CONNECT_FAILED", str(e).strip().splitlines()[-1], None
    conn.autocommit = True
    try:
        with conn.cursor() as cur:
            cur.execute(sql)
            rows = [list(r) for r in cur.fetchall()] if cur.description else None
            return "00000", "", rows
    except psycopg2.Error as e:
        return e.pgcode, (e.pgerror or "").strip().splitlines()[0], None
    finally:
        conn.close()

try:
    adm = admin()
except psycopg2.Error as e:
    print("SETUP FAILURE: cannot open admin connection:", e); sys.exit(2)
if a.mutation == "extra_grant":      # an otherwise denied privilege granted behind the test's back
    adm.cursor().execute("GRANT SELECT ON reporting.v_customers_masked TO sales_analyst")

results, failures = [], 0
for user, sql, want_state, want_rows in CASES:
    state, msg, rows = run(user, sql)
    ok = state == want_state and (want_rows is None or rows == want_rows)
    failures += not ok
    results.append(dict(identity=user, statement=sql, expected_sqlstate=want_state, observed_sqlstate=state,
                        message=msg, expected_rows=want_rows, observed_rows=rows, matched=ok,
                        observed_at=datetime.datetime.now(datetime.timezone.utc).isoformat(timespec="seconds")))
    print(f"{user:<10} expect {want_state} got {state:<12} {'PASS' if ok else 'FAIL'}  {sql[:70]}")

# Query-text visibility: while an admin session runs a statement containing a synthetic literal,
def slow():
    c = admin(); c.cursor().execute("SELECT pg_sleep(3), 'zoe.synthetic@example.com' AS marker"); c.close()
t = threading.Thread(target=slow); t.start(); time.sleep(1.0)
state, msg, rows = run("demo_auditor", "SELECT count(*) FROM pg_stat_activity WHERE query LIKE '%zoe.synthetic%' AND usename = 'admin'")
t.join()
vis_ok = state == "00000" and rows == [[0]]
failures += not vis_ok
results.append(dict(identity="demo_auditor", statement="read another session's query text (pg_stat_activity)",
                    expected_sqlstate="00000", observed_sqlstate=state, expected_rows=[[0]], observed_rows=rows,
                    matched=vis_ok, message=msg))
print(f"demo_auditor        other session's query text visible rows={rows} {'PASS' if vis_ok else 'FAIL'} (expected 0: no pg_read_all_stats)")

if a.mutation == "extra_grant":
    adm.cursor().execute("REVOKE SELECT ON reporting.v_customers_masked FROM sales_analyst")
expected_cases = len(CASES) + 1
with open(a.out, "w") as fh:
    json.dump(results, fh, indent=2)
print(f"cases: {len(results)} of {expected_cases}; failures: {failures}")
sys.exit(1 if failures or len(results) != expected_cases else 0)
