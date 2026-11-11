#!/usr/bin/env bash
: "${EDS_PRIVATE_RUN:?Use the companion run.py launcher}"
# Chapters 10-14 textbook example runner (AUTH + AUTH-OBS).
#
# Builds its OWN private PostgreSQL cluster in a new temporary directory, runs every executed example
# with assertions, writes a transcript, then stops the servers it started and removes only the
# temporary directory it created. It never connects to, modifies, or deletes any pre-existing
# cluster, database, role, or directory.
#
# Usage:  bash run_all.sh [TRANSCRIPT_PATH]       (default: validation_transcript.txt beside this script)
# Needs:  PostgreSQL 16 server binaries (initdb, pg_ctl, postgres, psql, createdb, pg_dump, pg_restore,
#         pg_basebackup, pg_verifybackup); set PG_BIN to their directory if `pg_config --bindir` is
#         not right. python3 with psycopg2 (pip install psycopg2-binary). Run as a normal user
#         (initdb refuses root). Works from a path containing spaces.
# Env:    PG_BIN, TMPDIR (where the private directory is created), EDS_KEEP=1 (keep it for inspection).
# Exit:   0 all steps passed and the transcript was written; 1 a step or assertion failed;
#         2 refused to start (missing prerequisite, unusable transcript path).
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT="${1:-$HERE/validation_transcript.txt}"
refuse() { echo "refusing to start: $1" >&2; exit 2; }

# ---- Preflight (nothing is created before these pass) ----
PG_BIN="${PG_BIN:-$(pg_config --bindir 2>/dev/null || echo /usr/lib/postgresql/16/bin)}"
for b in initdb pg_ctl postgres psql createdb pg_dump pg_restore pg_basebackup pg_verifybackup; do
  [[ -x "$PG_BIN/$b" ]] || refuse "$PG_BIN/$b not found (set PG_BIN)"; done
"$PG_BIN/postgres" --version | grep -q ' 16\.' || echo "note: server is not PostgreSQL 16; results are recorded for the version found" >&2
[[ $(id -u) -ne 0 ]] || refuse "run as a non-root user (initdb refuses root)"
command -v python3 >/dev/null && python3 -c "import psycopg2" 2>/dev/null || refuse "python3 with psycopg2 is required"
for f in 00_assert_helpers.sql seed.sql ch10_lineage_copies.sql ch10_delete_trace.sql ch10_refresh.sql ch10_replay.sql \
         ch11_setup.sql ch11_tests.py ch11_review.sql ch11_schema_owner.sql ch11_view_change.sql ch11_rotation.py ch12_hash_linkage.sql \
         ch13_auth_failures.py ch13_index_experiment.sql ch13_explain.sql ch13_freshness.sql ch14_pitr.sh; do
  [[ -f "$HERE/$f" ]] || refuse "missing input $HERE/$f"; done
[[ ! -d "$OUT" ]] || refuse "transcript path '$OUT' is a directory"
[[ -d "$(dirname "$OUT")" ]] || refuse "transcript directory '$(dirname "$OUT")' does not exist"
TMP_OUT="$OUT.partial.$$"
( : > "$TMP_OUT" ) 2>/dev/null || refuse "cannot write in '$(dirname "$OUT")'"

WORK="$(mktemp -d "${TMPDIR:-/tmp}/eds_ch10_14.XXXXXX")" || { rm -f "$TMP_OUT"; refuse "cannot create a private directory"; }
DATA="$WORK/primary"; SOCK="$WORK/sock"; ARCH="$WORK/wal_archive"; mkdir -p "$SOCK" "$ARCH"
cleanup() {
  [[ -f "$DATA/postmaster.pid" ]] && "$PG_BIN/pg_ctl" -D "$DATA" stop -m fast -t 30 >/dev/null 2>&1
  rm -f "$TMP_OUT"
  if [[ "${EDS_KEEP:-0}" == 1 ]]; then echo "kept private directory $WORK"; else rm -rf -- "$WORK"; fi
}
trap cleanup EXIT
read PPORT SPORT RPORT < <(python3 -c "
import socket; s=[socket.socket() for _ in range(3)]
[x.bind(('127.0.0.1',0)) for x in s]; print(*[x.getsockname()[1] for x in s]); [x.close() for x in s]")

"$PG_BIN/initdb" -D "$DATA" -U admin --auth-local=trust --auth-host=scram-sha-256 >"$WORK/initdb.log" 2>&1 || { cat "$WORK/initdb.log"; exit 1; }
cat >> "$DATA/postgresql.conf" <<CONF
port = $PPORT
listen_addresses = '127.0.0.1'
unix_socket_directories = '$SOCK'
password_encryption = 'scram-sha-256'
logging_collector = on
log_destination = 'csvlog'
log_directory = 'log'
log_filename = 'pg'
log_connections = on
timezone = 'UTC'
log_timezone = 'UTC'
wal_level = replica
archive_mode = on
archive_command = 'test ! -f "$ARCH/%f" && cp "%p" "$ARCH/%f"'
max_wal_senders = 5
CONF
"$PG_BIN/pg_ctl" -D "$DATA" -l "$WORK/server.log" -w -t 60 start >/dev/null || { cat "$WORK/server.log"; exit 1; }

export PATH="$PG_BIN:$PATH" PGHOST="$SOCK" PGPORT="$PPORT" PGUSER=admin
A() { psql -X -q -v ON_ERROR_STOP=1 "$@"; }
FAILS=0; STEPS=0
step() { # step LABEL -- command...
  local label="$1"; shift; STEPS=$((STEPS+1))
  echo; echo "########## $label"
  if "$@" 2>&1; then echo "STEP RESULT: PASS"; else echo "STEP RESULT: FAIL"; FAILS=$((FAILS+1)); fi
}
expect_fail() { "$@" >/dev/null 2>&1; local rc=$?; if [[ $rc -eq 1 ]]; then echo "validator rejected the deliberate defect as required"; else echo "unexpected validator exit $rc (expected assertion failure 1)"; return 1; fi; }
eq() { if [[ "$2" == "$3" ]]; then echo "PASS [$1] $2"; else echo "FAIL [$1] got <$2> expected <$3>"; return 1; fi; }
ch10() {
  A -d template1 -f "$HERE/00_assert_helpers.sql" &&
  createdb ch10 && A -d ch10 -c "CREATE SCHEMA raw" -f "$HERE/seed.sql" -f "$HERE/ch10_lineage_copies.sql" &&
  A -d ch10 -c "COPY (SELECT customer_id, email FROM marts.customer_order_summary) TO STDOUT (FORMAT csv, HEADER)" > "$WORK/ch10_export.csv" &&
  pg_dump -Fc -f "$WORK/ch10_before.dump" ch10 &&
  A -d ch10 -f "$HERE/ch10_delete_trace.sql" &&
  eq "export file rows for carla" "$(grep -c carla "$WORK/ch10_export.csv")" 1 &&
  A -d ch10 -f "$HERE/ch10_refresh.sql" &&
  eq "backup rows for carla" "$(pg_restore -f - --data-only -t customers "$WORK/ch10_before.dump" | grep -c carla)" 1 &&
  createdb -T template0 ch10_restored && pg_restore -d ch10_restored "$WORK/ch10_before.dump" &&
  A -d ch10_restored -f "$HERE/ch10_replay.sql"
}
ch11() {
  createdb ch11 && A -d ch11 -c "CREATE SCHEMA raw" -f "$HERE/seed.sql" -f "$HERE/ch11_setup.sql" &&
  python3 "$HERE/ch11_tests.py" --port "$PPORT" --admin-socket "$SOCK" --out "$WORK/ch11_results.json" &&
  cp "$WORK/ch11_results.json" "$(dirname "$OUT")/ch11_results.json.partial.$$" &&
  echo "-- validator self-checks (each must make the checker fail):" &&
  expect_fail python3 "$HERE/ch11_tests.py" --port "$PPORT" --admin-socket "$SOCK" --out "$WORK/m1.json" --mutation missing_object &&
  expect_fail python3 "$HERE/ch11_tests.py" --port "$PPORT" --admin-socket "$SOCK" --out "$WORK/m2.json" --mutation extra_grant &&
  PGPASSWORD="$EDS_DEMO_AUDITOR_PASSWORD" psql -h 127.0.0.1 -p "$PPORT" -U demo_auditor -d ch11 -X -v ON_ERROR_STOP=1 -f "$HERE/ch11_review.sql" &&
  eq "information_schema rows visible to demo_auditor" "$(PGPASSWORD="$EDS_DEMO_AUDITOR_PASSWORD" psql -h 127.0.0.1 -p "$PPORT" -U demo_auditor -d ch11 -X -tAc "SELECT count(*) FROM information_schema.role_table_grants WHERE table_schema='reporting'")" 0 &&
  eq "steward sees masked view, no phone column" "$(PGPASSWORD="$EDS_DEMO_STEWARD_PASSWORD" psql -h 127.0.0.1 -p "$PPORT" -U demo_steward -d ch11 -X -tAc "SELECT count(*) FROM information_schema.columns WHERE table_name='v_customers_masked' AND column_name='phone_number'")" 0 &&
  INV1="$(PGPASSWORD="$EDS_DEMO_AUDITOR_PASSWORD" psql -h 127.0.0.1 -p "$PPORT" -U demo_auditor -d ch11 -X -tA -f "$HERE/ch11_review.sql")" &&
  A -d ch11 -f "$HERE/ch11_schema_owner.sql" &&
  A -d ch11 -f "$HERE/ch11_view_change.sql" &&
  INV2="$(PGPASSWORD="$EDS_DEMO_AUDITOR_PASSWORD" psql -h 127.0.0.1 -p "$PPORT" -U demo_auditor -d ch11 -X -tA -f "$HERE/ch11_review.sql")" &&
  eq "grant inventory unchanged by the view edit" "$([[ "$INV1" == "$INV2" ]] && echo same || echo different)" same &&
  eq "steward now sees unmasked synthetic phone values" "$(PGPASSWORD="$EDS_DEMO_STEWARD_PASSWORD" psql -h 127.0.0.1 -p "$PPORT" -U demo_steward -d ch11 -X -tAc "SELECT count(phone_number) FROM reporting.v_customers_masked")" 2 &&
  python3 "$HERE/ch11_rotation.py" --port "$PPORT" --admin-socket "$SOCK"
}
ch12() { A -d ch10_restored -f "$HERE/ch12_hash_linkage.sql"; }
ch13() {
  python3 "$HERE/ch13_auth_failures.py" --port "$PPORT" --log-csv "$DATA/log/pg.csv" &&
  createdb ch13 && A -d ch13 -f "$HERE/ch13_index_experiment.sql" &&
  echo "-- before index (five timed runs; one session; synthetic table; not a benchmark)" &&
  for i in 1 2 3 4 5; do A -d ch13 -f "$HERE/ch13_explain.sql" | grep "Execution Time"; done &&
  A -d ch13 -f "$HERE/ch13_explain.sql" &&
  A -d ch13 -c "CREATE INDEX perf_orders_customer_date ON perf_orders (customer_id, order_date DESC); ANALYZE perf_orders;" &&
  echo "-- after index" &&
  for i in 1 2 3 4 5; do A -d ch13 -f "$HERE/ch13_explain.sql" | grep "Execution Time"; done &&
  PLAN="$(A -d ch13 -f "$HERE/ch13_explain.sql")" && echo "$PLAN" &&
  eq "after-index plan uses the new index" "$(grep -c 'perf_orders_customer_date' <<<"$PLAN")" 1 &&
  A -d ch13 -tAc "select 'table='||pg_size_pretty(pg_relation_size('perf_orders'))||' index='||pg_size_pretty(pg_relation_size('perf_orders_customer_date'))" &&
  A -d ch13 -f "$HERE/ch13_freshness.sql"
}
ch14() { PG_BIN="$PG_BIN" WORK="$WORK" SOCK="$SOCK" PPORT="$PPORT" SPORT="$SPORT" RPORT="$RPORT" ARCH="$ARCH" bash "$HERE/ch14_pitr.sh"; }

{
  echo "# Chapters 10-14 textbook example transcript (AUTH + AUTH-OBS)"
  echo "# Server: $(psql -X -tA -d postgres -c 'select version()')"
  echo "# Private cluster created by this run in a new temporary directory; ports $PPORT/$SPORT/$RPORT; run at $(date -u +%FT%TZ)"
  echo "# Script checksums (sha256):"; (cd "$HERE" && sha256sum 00_assert_helpers.sql seed.sql ch1*.sql ch1*.py ch14_pitr.sh run_all.sh) | sed 's/^/#   /'
  step "Chapter 10: dependencies, copies, deletion, refresh, backup, restore, ledger replay" ch10
  step "Chapter 11: separate-login access tests, auditor scope, view change, rotation" ch11
  step "Chapter 12: SHA-256 candidate lookup" ch12
  step "Chapter 13: authentication failures, bounded index experiment, freshness states" ch13
  step "Chapter 14: base backup, standby, PITR, reconciliation" ch14
  echo
  echo "# Steps run: $STEPS   Steps failed: $FAILS   Assertions passed: $(grep -c '^ *PASS' "$TMP_OUT")"
  if [[ $FAILS -eq 0 ]]; then echo "# OVERALL: PASS"; else echo "# OVERALL: FAIL"; fi
} > "$TMP_OUT" 2>&1
got=$(grep -c '^STEP RESULT:' "$TMP_OUT"); grep -q '^# OVERALL:' "$TMP_OUT" && [[ $got -eq 5 ]] || { echo "transcript incomplete; run NOT validated" >&2; exit 1; }
[[ -f "$(dirname "$OUT")/ch11_results.json.partial.$$" ]] && mv -f "$(dirname "$OUT")/ch11_results.json.partial.$$" "$(dirname "$OUT")/ch11_results.json"
mv -f "$TMP_OUT" "$OUT" || { echo "could not write '$OUT'" >&2; exit 1; }
tail -n 2 "$OUT"; echo "wrote $OUT"
[[ $FAILS -eq 0 ]] || exit 1
