#!/usr/bin/env bash
: "${EDS_PRIVATE_RUN:?Use the companion run.py launcher}"
# textbook example harness for Chapter 5, Listings 5.3-5.6 and the basket analysis.
# Runs Session A, then Session B 0.5 s later, against a SCRATCH database, and reports
# the final inventory and the number of confirmed sales. Usage: ./run_concurrency.sh DBNAME
# Retry policy (where stated): on SQLSTATE 40001 or 40P01, rerun the whole script with the
# SAME request id, at most 3 attempts.
set -u
DB=${1:?scratch database name}
P="psql -X -q -d $DB -v VERBOSITY=verbose"
reset() { $P -c "TRUNCATE ops.sales_log; DELETE FROM ops.inventory; INSERT INTO ops.inventory VALUES $1;" >/dev/null; }
run() { # $1 req, $2 script, $3 retry(yes/no), rest: extra psql args
  local req=$1 f=$2 retry=$3; shift 3; local a=1
  while :; do
    out=$($P -v ON_ERROR_STOP=1 -v req="$req" "$@" -f "$f" 2>&1); rc=$?
    echo "  [$req attempt $a rc=$rc] $(echo "$out" | grep -Eo 'CONFIRMED.*|DECLINED.*|ERROR: +[0-9A-Z]{5}: .*' | head -2 | tr '\n' ' ')"
    if [ $rc -ne 0 ] && [ "$retry" = yes ] && echo "$out" | grep -Eq '40001|40P01' && [ $a -lt 3 ]; then a=$((a+1)); continue; fi
    break
  done
}
report() { $P -At -c "SELECT 'inventory=' || string_agg(product_id||':'||units_on_hand, ' ' ORDER BY product_id) FROM ops.inventory" -c "SELECT 'confirmed_sales=' || count(*) FROM ops.sales_log"; }
pair() { # title, inventory, A-args..., '--', B-args...
  echo "== $1"; reset "$2"; shift 2
  local A=() B=(); while [ "$1" != -- ]; do A+=("$1"); shift; done; shift; B=("$@")
  run "${A[@]}" & sleep 0.5; run "${B[@]}"; wait; report
}
pair "5.3 naive read-then-write, READ COMMITTED"     "(1,1)" A ch05_lost_update.sql no -v iso='READ COMMITTED' -- B ch05_lost_update.sql no -v iso='READ COMMITTED'
pair "5.3 naive, REPEATABLE READ, no retry"          "(1,1)" A ch05_lost_update.sql no -v iso='REPEATABLE READ' -- B ch05_lost_update.sql no -v iso='REPEATABLE READ'
pair "5.3 naive, REPEATABLE READ, literal retry"     "(1,1)" A ch05_lost_update.sql yes -v iso='REPEATABLE READ' -- B ch05_lost_update.sql yes -v iso='REPEATABLE READ'
pair "5.4 conditional update + decision"             "(1,1)" A ch05_conditional_update.sql no -- B ch05_conditional_update.sql no
pair "5.5 FOR UPDATE + decision"                     "(1,1)" A ch05_for_update.sql no -- B ch05_for_update.sql no
pair "5.5 FOR UPDATE, naive writer"                  "(1,1)" A ch05_for_update_naive.sql no -- B ch05_for_update_naive.sql no
pair "5.6 REPEATABLE READ + decision, retry"         "(1,1)" A ch05_repeatable_read_decision.sql yes -- B ch05_repeatable_read_decision.sql yes
pair "Basket, consistent order (both lock 1 then 2)" "(1,5),(2,1)" X ch05_basket.sql no -v items=1,2 -- Y ch05_basket.sql no -v items=1,2
pair "Basket, inconsistent order (Y locks 2 then 1)" "(1,5),(2,5)" X ch05_basket.sql no -v items=1,2 -- Y ch05_basket.sql no -v items=2,1
