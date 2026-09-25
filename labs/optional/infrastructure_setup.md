# Optional infrastructure lab setup and recovery

Labs 12–14 run isolated PostgreSQL instances created solely for each experiment.
They do not connect to the main course database or read its `.env`. Each run has
new credentials, a fresh directory and automatically selected loopback ports.
Run them in your individual Ubuntu VM or WSL environment as a normal user.

## Prepare once

Complete the standard course setup. Then install the optional certificate utility:

```bash
sudo apt-get install -y openssl
```

The core setup already installs PostgreSQL. If the runner cannot locate its server
tools, locate the installed version with `ls /usr/lib/postgresql` and set the
following to the actual installed version (16 is an example):

```bash
export IT4065C_PG_BIN=/usr/lib/postgresql/16/bin
```

Run commands from the repository root, using `.venv/bin/python`. Do not run the
Python runner with sudo. Budget roughly 100 MB per instance plus private logs;
each rerun retains another fresh directory. Each experiment typically takes seconds
to a few minutes; allow the lab's full estimated time for interpretation.

## Configuration without shared passwords

Defaults need no edits. These optional **environment variables** override the
experiment settings; they are separate from the core `.env` parser:

| Variable | Default / purpose |
| --- | --- |
| IT4065C_PG_BIN | Discover installed PostgreSQL tools; override with the installed binary directory |
| IT4065C_OPENSSL | Discover openssl on PATH; override with the executable path |
| IT4065C_EXPERIMENT_ADMIN | experiment_admin, owner of only the disposable instances |
| IT4065C_EXPERIMENT_READER | experiment_reader, restricted query identity |
| IT4065C_EXPERIMENT_ADMIN_PASSWORD | Unique generated value held in memory |
| IT4065C_EXPERIMENT_READER_PASSWORD | Different generated value held in memory |
| IT4065C_EXPERIMENT_ROTATED_PASSWORD | New generated value for Lab 14 |

Names must be distinct lowercase identifiers, at most 40 characters, not beginning
with pg_. Custom passwords must be distinct, at least 24 characters, on one line.
To supply one without putting it in shell history, use Bash's hidden prompt:

```bash
read -r -s -p 'Experiment reader password: ' IT4065C_EXPERIMENT_READER_PASSWORD
printf '\n'
export IT4065C_EXPERIMENT_READER_PASSWORD
```

Unset overrides when finished, for example `unset IT4065C_EXPERIMENT_READER_PASSWORD`.
For most learners, leave all passwords generated. No credential is printed, passed
on a command line or saved as an evidence field. A private bootstrap password file
is deleted after initialization. PostgreSQL retains password verifiers, and Lab 14
retains private test certificate keys in the private run directory.

## Evidence and safe recovery

The runner prints a relative directory such as `.local/infrastructure/audit-...`.
After PASS, copy and run the exact JSON-reading command printed by the runner.
It includes that run's directory, so no filename substitution is needed. Server logs and data remain private and
ignored by Git. The runner stops all its instances on normal completion or a handled
failure. A forced terminal closure or power failure can prevent cleanup.

For an interrupted run, substitute the exact printed directory in these commands;
use `source` and `target` for Lab 13, or `server` for Labs 12 and 14:

```bash
"$IT4065C_PG_BIN/pg_ctl" -D .local/infrastructure/YOUR-RUN/server/data status
"$IT4065C_PG_BIN/pg_ctl" -D .local/infrastructure/YOUR-RUN/server/data -m fast -w stop
```

Set IT4065C_PG_BIN first as shown above. Only stop the instance whose data directory
belongs to your run. Never substitute the system PostgreSQL data directory.
After confirming all instances stopped, delete only that specific run folder using
your file manager if you no longer need it. No recursive deletion is automated.
Run the experiment again to obtain a new clean instance; expired test certificates
are replaced in the new run. Do not remove authentication to troubleshoot failures.

A port can become occupied between selection and startup. If startup fails, inspect
the private startup log and rerun after verifying shutdown. Linux permissions
protect directories from other OS users; Windows permissions depend on the parent
folder's ACL. The supported student route remains Ubuntu. No public network listener,
paid service, real data or shared university server is involved.

---

Author: [Isaac K. Nti](../../AUTHORS.md). [Citation](../../CITATION.md).
