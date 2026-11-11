#!/usr/bin/env bash
: "${EDS_PRIVATE_RUN:?Use the companion run.py launcher}"
# Part 3 harness. Usage: ./run_nonrepeatable.sh SCRATCH_DB
DB=${1:?scratch database}; P="psql -X -q -d $DB"
for iso in 'READ COMMITTED' 'REPEATABLE READ'; do
  echo "== $iso"; $P -c "DELETE FROM ops.inventory; INSERT INTO ops.inventory VALUES (1,10);"
  $P -At -v iso="$iso" -f ch05_nonrepeatable_read.sql | grep read & sleep 0.5; $P -f ch05_nonrepeatable_writer.sql; wait
done
