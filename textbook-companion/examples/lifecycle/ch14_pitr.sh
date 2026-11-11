#!/usr/bin/env bash
# Chapter 14 textbook example (AUTH + AUTH-OBS): base backup + WAL archive + point-in-time recovery,
# and a streaming standby that faithfully replicates a mistaken DELETE.
# Same host, same disk, one private cluster created by run_all.sh: this demonstrates mechanism,
# not independent recovery capability.
#
# Called by run_all.sh with: PG_BIN WORK SOCK PPORT SPORT RPORT ARCH (all inside the run's own
# private temporary directory). It creates only WORK/ch14_* paths and stops only servers it started.
# Exits nonzero on any failed step or assertion. Timings are labeled by their actual endpoints.
set -euo pipefail
: "${PG_BIN:?}" "${WORK:?}" "${SOCK:?}" "${PPORT:?}" "${SPORT:?}" "${RPORT:?}" "${ARCH:?}"
export PATH="$PG_BIN:$PATH"
BK="$WORK/ch14_base_bk"; RS="$WORK/ch14_restored"; SB="$WORK/ch14_standby"
for d in "$BK" "$RS" "$SB"; do [[ ! -e "$d" ]] || { echo "refusing: $d already exists"; exit 2; }; done
STARTED=()
stop_started() { for d in "${STARTED[@]:-}"; do [[ -n "$d" ]] && pg_ctl -D "$d" stop -m fast -t 30 >/dev/null 2>&1 || true; done; }
trap stop_started EXIT
P()  { psql -h "$SOCK" -p "$PPORT" -U admin -X -q -tA -v ON_ERROR_STOP=1 "$@"; }
S()  { psql -h "$SOCK" -p "$SPORT" -U admin -X -q -tA -v ON_ERROR_STOP=1 -d ch14 "$@"; }
R()  { psql -h "$SOCK" -p "$RPORT" -U admin -X -q -tA -v ON_ERROR_STOP=1 -d ch14 "$@"; }
FAILS=0
check() { if [[ "$2" == "$3" ]]; then echo "PASS [$1] $2"; else echo "FAIL [$1] got <$2> expected <$3>"; FAILS=$((FAILS+1)); fi; }
wait_for() { local i; for i in $(seq 1 150); do if eval "$1"; then return 0; fi; sleep 0.2; done; echo "timeout waiting for: $1"; return 1; }
now() { date +%s.%N; }
secs() { python3 -c "print(f'{$2-$1:.3f}')"; }

createdb -h "$SOCK" -p "$PPORT" -U admin ch14
P -d ch14 -c "CREATE TABLE orders(order_id int PRIMARY KEY, customer_id int NOT NULL, status text NOT NULL,
  amount numeric(10,2) NOT NULL, created_at timestamptz NOT NULL DEFAULT clock_timestamp());
INSERT INTO orders(order_id,customer_id,status,amount)
  SELECT g, (g%400)+1, CASE WHEN g%10=0 THEN 'cancelled' ELSE 'completed' END, (g%97)+0.99 FROM generate_series(1,1000) g;"
echo "== base backup (to a separate directory on the same disk)"
t0=$(now); pg_basebackup -h "$SOCK" -p "$PPORT" -U admin -D "$BK" -Fp -X stream -c fast; t1=$(now)
echo "base_backup_seconds=$(secs "$t0" "$t1")"
pg_verifybackup "$BK" >/dev/null && echo "PASS [pg_verifybackup] ok"
echo "== streaming standby, for comparison"
pg_basebackup -h "$SOCK" -p "$PPORT" -U admin -D "$SB" -Fp -X stream -R -c fast
cat >> "$SB/postgresql.conf" <<CONF
port=$SPORT
archive_mode=off
log_directory='log'
CONF
pg_ctl -D "$SB" -l "$WORK/ch14_standby.log" -w -t 60 start >/dev/null; STARTED+=("$SB")
echo "== business activity after the backup"
P -d ch14 -c "INSERT INTO orders(order_id,customer_id,status,amount) SELECT g,(g%400)+1,'completed',25.00 FROM generate_series(1001,1100) g;"
sleep 1
T_GOOD=$(P -d ch14 -c "SELECT clock_timestamp()"); echo "chosen_recovery_target=$T_GOOD"
sleep 1
echo "== accidental deletion (intended: cancelled orders only; predicate missing)"
T_BAD=$(P -d ch14 -c "SELECT clock_timestamp()"); P -d ch14 -c "DELETE FROM orders;"
echo "delete_issued_after=$T_BAD"
sleep 1
P -d ch14 -c "INSERT INTO orders(order_id,customer_id,status,amount) VALUES (5001,7,'completed',40.00),(5002,8,'completed',15.50);"
T_DETECT=$(P -d ch14 -c "SELECT clock_timestamp()"); echo "detected_at=$T_DETECT"
echo "test condition: a WAL segment switch is forced so the archive receives the segment holding these commits"
SEG=$(P -d postgres -c "SELECT pg_walfile_name(pg_current_wal_lsn())")
P -d ch14 -c "SELECT pg_switch_wal();" >/dev/null
wait_for "[[ -f \"$ARCH/$SEG\" ]]" && echo "PASS [segment $SEG archived]"
check "primary rows after the mistake" "$(P -d ch14 -c 'SELECT count(*) FROM orders')" "2"
OBS=$(P -d postgres -c "SELECT clock_timestamp()")
wait_for "[[ \$(S -c 'SELECT count(*) FROM orders') == 2 ]]"
echo "standby observed at or after $OBS: rows=$(S -c 'SELECT count(*) FROM orders') (the standby had applied the DELETE by this observation; replication lag was not measured)"
check "standby replicated the mistake" "$(S -c 'SELECT count(*) FROM orders')" "2"
echo "== point-in-time recovery to the chosen target, in a separate data directory"
c0=$(now); cp -a "$BK" "$RS"; c1=$(now)
cat >> "$RS/postgresql.conf" <<CONF
port=$RPORT
archive_mode=off
log_directory='log'
restore_command='cp "$ARCH/%f" "%p"'
recovery_target_time='$T_GOOD'
recovery_target_action='promote'
CONF
touch "$RS/recovery.signal"
r0=$(now); pg_ctl -D "$RS" -l "$WORK/ch14_restored.log" -w -t 120 start >/dev/null; STARTED+=("$RS")
wait_for "[[ \$(psql -h \"$SOCK\" -p \"$RPORT\" -U admin -X -tA -d postgres -c 'select not pg_is_in_recovery()' 2>/dev/null) == t ]]"
r1=$(now)
echo "file_copy_seconds=$(secs "$c0" "$c1") (copying the base backup into place)"
echo "startup_through_promotion_seconds=$(secs "$r0" "$r1") (server start, WAL replay to the target, promotion; excludes the copy)"
echo "copy_plus_startup_seconds=$(secs "$c0" "$r1")"
echo "== reconciliation"
check "recovered row count" "$(R -c 'SELECT count(*) FROM orders')" "1100"
check "recovered completed amount (control total)" "$(R -c "SELECT sum(amount) FROM orders WHERE status='completed'")" "45700.00"
check "recovered max order_id" "$(R -c 'SELECT max(order_id) FROM orders')" "1100"
check "orders 5001/5002 absent (entered after the target)" "$(R -c 'SELECT count(*) FROM orders WHERE order_id IN (5001,5002)')" "0"
# Expected relation built independently from the generator's stated rules (not copied from any server),
# then compared row by row in both directions on every business column (created_at is excluded:
# it records insertion time and cannot be predicted).
EXPECTED="SELECT g AS order_id, (g%400)+1 AS customer_id, CASE WHEN g%10=0 THEN 'cancelled' ELSE 'completed' END AS status, ((g%97)+0.99)::numeric(10,2) AS amount FROM generate_series(1,1000) g
          UNION ALL SELECT g, (g%400)+1, 'completed', 25.00 FROM generate_series(1001,1100) g"
check "rows in recovered copy but not expected" "$(R -c "SELECT count(*) FROM (SELECT order_id,customer_id,status,amount FROM orders EXCEPT SELECT * FROM ($EXPECTED) e) x")" "0"
check "rows expected but missing from recovered copy" "$(R -c "SELECT count(*) FROM (SELECT * FROM ($EXPECTED) e EXCEPT SELECT order_id,customer_id,status,amount FROM orders) x")" "0"
check "independent expected completed total" "$(R -c "SELECT sum(amount) FROM ($EXPECTED) e WHERE status='completed'")" "45700.00"
echo "recovery log lines:"
grep -h -E "recovery stopping|last completed transaction" "$RS"/log/*.csv 2>/dev/null | cut -d, -f14 | head -3 || true
echo "same-host limitation: backup, archive, primary, standby and restored copy share one machine and disk."
[[ $FAILS -eq 0 ]] || { echo "CH14 RESULT: FAIL ($FAILS)"; exit 1; }
echo "CH14 RESULT: PASS"
