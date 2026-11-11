import os
"""Chapter 11 textbook example: credential rotation versus established sessions (AUTH + AUTH-OBS).
Usage: python3 ch11_rotation.py --host 127.0.0.1 --port P --admin-socket DIR.  Exits 1 on any unexpected result."""
import argparse, sys, psycopg2
ap = argparse.ArgumentParser(); ap.add_argument("--host", default="127.0.0.1"); ap.add_argument("--port", type=int, required=True)
ap.add_argument("--admin-socket", required=True); a = ap.parse_args()
OLD, NEW = os.environ["EDS_DEMO_ANALYST_PASSWORD"], os.environ["EDS_DEMO_ROTATED_PASSWORD"]
def connect(pw):
    c = psycopg2.connect(host=a.host, port=a.port, dbname="ch11", user="demo_analyst", password=pw); c.autocommit = True; return c
fail = 0
def check(label, cond, detail=""):
    global fail; fail += not cond; print(f"{'PASS' if cond else 'FAIL'} {label} {detail}")
established = connect(OLD)
admin = psycopg2.connect(host=a.admin_socket, port=a.port, dbname="ch11", user="admin"); admin.autocommit = True
try:
    admin.cursor().execute("ALTER ROLE demo_analyst PASSWORD %s", (NEW,))
    cur = established.cursor(); cur.execute("SELECT count(*) FROM reporting.v_sales_by_day")
    check("established session still works after rotation", cur.fetchone()[0] == 2)
    try:
        connect(OLD); check("new connection with old password rejected", False)
    except psycopg2.OperationalError as e:
        check("new connection with old password rejected", "password authentication failed" in str(e))
    connect(NEW).close(); check("new connection with new password accepted", True)
    c2 = admin.cursor(); c2.execute("SELECT count(*) FROM pg_stat_activity WHERE usename='demo_analyst'")
    check("established session still open", c2.fetchone()[0] == 1)
    c2.execute("SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE usename='demo_analyst'")
    check("established session terminated", c2.rowcount == 1)
finally:
    admin.cursor().execute("ALTER ROLE demo_analyst PASSWORD %s", (OLD,))   # restore fixture state
sys.exit(1 if fail else 0)
