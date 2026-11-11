#!/usr/bin/env bash
# Runs every Chapter 4-6 example in a NEW scratch database and writes validation_transcript.txt.
# Usage: ./run_all.sh  (needs createdb/dropdb rights; uses PGHOST/PGPORT/PGUSER from the environment)
# WARNING: never point this at the course database. It creates and drops database eds_ch4_6_scratch.
set -u
: "${EDS_PRIVATE_RUN:?Use the companion run.py launcher}"
DB=eds_ch4_6_scratch; OUT=validation_transcript.txt
createdb "$DB" || exit 1
trap 'dropdb --if-exists "$DB" >/dev/null 2>&1' EXIT
P="psql -X -q -d $DB"
{
  echo "# Textbook example transcript"
  echo "# Server: $($P -At -c 'show server_version')   Run at: $(date -u +%FT%TZ)"
  echo "# Script checksums (sha256):"; sha256sum *.sql *.sh | sed 's/^/#   /'
  for step in "Chapter 4|ch04_quality_examples.sql" "Chapter 6 grain|ch06_grain_and_reconciliation.sql" "Chapter 6 SCD and semi-additive|ch06_scd_and_semi_additive.sql"; do
    echo; echo "########## ${step%%|*}"; $P -f "${step#*|}" 2>&1
  done
  echo; echo "########## Chapter 5 Listing 5.2 / Table 5.2"; $P -f ch05_schema.sql >/dev/null 2>&1; $P -f ch05_atomicity.sql 2>&1
  echo; echo "########## Chapter 5 Table 5.3(a) autocommit, client stops at first error"; $P -f ch05_schema.sql >/dev/null 2>&1
  $P -v ON_ERROR_STOP=1 -f ch05_autocommit_stop_on_error.sql 2>&1; $P -v oid=5002 -f ch05_state.sql 2>&1
  echo; echo "########## Chapter 5 Table 5.3(b) autocommit, client continues after error"; $P -f ch05_schema.sql >/dev/null 2>&1; $P -f ch05_autocommit_continue_on_error.sql 2>&1
  echo; echo "########## Chapter 5 Listing 5.8 trigger"; $P -f ch05_schema.sql >/dev/null 2>&1; $P -f ch05_immutability_trigger.sql 2>&1
  echo; echo "########## Chapter 5 transfer case: exclusion constraint"; $P -f ch05_schema.sql >/dev/null 2>&1; $P -f ch05_exclusion_constraint.sql 2>&1
  echo; echo "########## Chapter 5 concurrency harness (Listings 5.3-5.7, basket analysis)"; $P -f ch05_schema.sql >/dev/null 2>&1; bash run_concurrency.sh "$DB" 2>&1
  echo; echo "########## Chapter 5 Part 3 nonrepeatable read"; bash run_nonrepeatable.sh "$DB" 2>&1
} > "$OUT"
dropdb "$DB"; echo "wrote $OUT"
# The transcript is an observation record, not an assertion suite. At minimum, refuse to report
# success if a step could not run at all (missing file, permission, or connection failure).
if grep -Eq 'Permission denied|No such file or directory|command not found|could not connect' "$OUT"; then
  echo "RUN INCOMPLETE: a step did not execute; see $OUT" >&2; exit 1
fi
