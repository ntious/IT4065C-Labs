# Module 3 Lab 1 — Common Mistakes + Fixes (Troubleshooting Guide)

This guide lists the most common problems students run into during **M3 Lab 1: Data Lifecycle Design and Management**, along with quick, practical fixes.

---

## 0) Before You Start: Quick Health Check

### ✅ You should be in the repo root
**Symptom:** Commands can’t find files like `labs/module_3/lab4/_run_all.sh`  
**Fix:**
```bash
cd ~/IT4065C-Labs
pwd
````

Expected output ends with: `.../IT4065C-Labs`

### ✅ PostgreSQL must be running

**Symptom:** `psql: could not connect to server`
**Fix:**

```bash
sudo service postgresql status
sudo service postgresql start
```

---

## 1) Script Issues: `_run_all.sh` fails immediately

### Mistake 1.1 — Running the script from the wrong folder

**Symptom:** `No such file or directory` or relative paths break
**Fix (always run from repo root):**

```bash
cd ~/IT4065C-Labs
bash labs/module_3/lab4/_run_all.sh
```

### Mistake 1.2 — Script not executable (if using `./_run_all.sh`)

**Symptom:** `Permission denied`
**Fix:**

```bash
chmod +x labs/module_3/lab4/_run_all.sh
bash labs/module_3/lab4/_run_all.sh
```

### Mistake 1.3 — The venv isn’t found

**Symptom:** `ERROR: dbt-venv not found. Complete Lab 1 first.`
**Cause:** `dbt-venv` wasn’t created or you’re not in the repo root.
**Fix:**

* Confirm location:

```bash
ls -la ~/IT4065C-Labs/dbt-venv/bin/activate
```

* If missing, revisit **M2 Lab 1** setup instructions.

### Mistake 1.4 — `set -euo pipefail` causes “unbound variable”

**Symptom:** Script stops with something like `unbound variable`
**Cause:** A required environment variable or command output is missing.
**Fix:** Re-run step-by-step to see exactly where it fails:

```bash
source ~/IT4065C-Labs/dbt-venv/bin/activate
cd ~/IT4065C-Labs/dbt/it4065c_platform
dbt debug
```

---

## 2) Database / psql Precheck Problems

### Mistake 2.1 — Wrong password / wrong user

**Symptom:** `FATAL: password authentication failed for user "postgres"`
**Fix:**

* Use the same credentials from **M2 Lab 1** (do not change them).
* If you forgot them, check your notes / course setup instructions.

### Mistake 2.2 — `psql` command prompts for password and fails repeatedly

**Symptom:** Keeps asking password; then fails
**Fix:** Enter the correct password. If you don’t know it, stop and ask TA (don’t guess).

### Mistake 2.3 — Raw tables missing or wrong schema

**Symptom:** dbt runs but DAG is incomplete, or models fail with `relation "raw.orders" does not exist`
**Fix:**
Run the precheck directly:

```bash
cd ~/IT4065C-Labs
psql -h localhost -U postgres -d it4065c -f labs/module_3/lab4/_precheck.sql
```

Then verify schema exists:

```bash
psql -h localhost -U postgres -d it4065c -c "\dt raw.*"
```

---

## 3) dbt Build / Selector Problems

### Mistake 3.1 — Running dbt from the wrong directory

**Symptom:** `Not a dbt project` or dbt can’t find `dbt_project.yml`
**Fix:**

```bash
cd ~/IT4065C-Labs/dbt/it4065c_platform
dbt debug
```

### Mistake 3.2 — Wrong selection path

**Symptom:** `dbt build` runs but builds nothing / very few models
**Cause:** The selector `path:models/lab3` only includes models inside that folder.
**Fix:**

```bash
cd ~/IT4065C-Labs/dbt/it4065c_platform
dbt ls --select path:models/lab3
```

If expected models don’t appear, your Lab 3 models may not be located under `models/lab3`.

### Mistake 3.3 — dbt tests failing

**Symptom:** `FAIL` in tests, build stops
**What to do:**

1. Identify failing test:

```bash
dbt test --select path:models/lab3
```

2. Common causes:

   * Duplicate IDs in raw data
   * Null keys where `not_null` is required
3. If this happens, contact TA with the error + model name.

---

## 4) dbt Docs Doesn’t Open / Doesn’t Show Updates

### Mistake 4.1 — `dbt docs serve` runs but browser doesn’t load

**Symptom:** Browser can’t reach `http://localhost:8080`
**Fix checklist:**

* Confirm docs is running and port is correct:

```bash
dbt docs serve --port 8080
```

* If port is busy:

```bash
dbt docs serve --port 8081
```

Then open `http://localhost:8081`

### Mistake 4.2 — Student closes the terminal running docs

**Symptom:** Page stops loading / connection resets
**Fix:** Keep that terminal window open while using dbt Docs.

### Mistake 4.3 — Docs show old lineage (stale)

**Symptom:** You updated models but DAG looks unchanged
**Fix:**

```bash
cd ~/IT4065C-Labs/dbt/it4065c_platform
dbt docs generate --select path:models/lab3
dbt docs serve --port 8080
```

---

## 5) Lineage Graph (DAG) Confusion

### Mistake 5.1 — Expecting the full DAG immediately from a model page

**Symptom:** Graph only shows the model + 1–2 dependencies
**Cause:** dbt Docs often opens a *focused* lineage view first.
**Fix:** Click upstream nodes to expand, OR use the full project lineage in Step 3.4.

### Mistake 5.2 — Using `olap_sales_by_day` for Screenshot 1

**Symptom:** Screenshot shows only facts; no staging or raw visible
**Fix:** Screenshot 1 must be captured from **`oltp_order_detail` lineage view**, because it naturally reveals multiple layers.

### Mistake 5.3 — Clicking the wrong “graph” view

**Symptom:** Student opens a node details page, not lineage
**Fix:**

* In dbt Docs, open a model page and then click:

  * the **Lineage tab**, OR
  * the **green graph icon** (bottom-right)

---

## 6) Source Verification Mistakes (Screenshot 2)

### Mistake 6.1 — Looking for `from raw.orders` (old approach)

**Symptom:** Student can’t find `from raw.orders` in staging SQL
**Correct expectation:** It should now use dbt sources:

```sql
from {{ source('raw', 'orders') }}
```

### Mistake 6.2 — Using **Compiled** instead of **Source**

**Symptom:** Student sees long SQL with renamed relations; source call is missing
**Fix:** In Code tab, select **Source** (not Compiled).

### Mistake 6.3 — Opening the wrong staging model

**Symptom:** Screenshot shows `stg_order_items` or something else
**Fix:** Screenshot 2 must be from **`stg_orders`** and show:

* `Code → Source`
* `{{ source('raw', 'orders') }}`

---

## 7) Screenshot Submission Problems

### Mistake 7.1 — Screenshots are unreadable (too zoomed out)

**Symptom:** TA cannot read model names or arrows
**Fix tips:**

* Zoom browser to 110–125%
* Ensure model name and upstream nodes are visible
* Crop carefully (but don’t crop out labels)

### Mistake 7.2 — Missing required elements per screenshot

**Fix checklist:**

* **Screenshot 1 (Lifecycle via `oltp_order_detail`)** must show:

  * `oltp_order_detail`
  * at least one `fct_*` or `dim_*`
  * at least one `stg_*`
  * at least one `raw.*`
* **Screenshot 2 (Source verification)** must show:

  * `stg_orders`
  * Code → Source
  * `{{ source('raw', 'orders') }}`
* **Screenshot 3 (Full project lineage)** must show:

  * a broad graph view with raw, staging, core, and marts visible

### Mistake 7.3 — Submitting screenshots but no written lifecycle chain

**Fix:** Include one chain such as:

```text
raw.orders → stg_orders → fct_orders → olap_sales_by_day
```

---

## 8) Written Lifecycle Chain Errors

### Mistake 8.1 — Skipping lifecycle layers

**Symptom:** Student writes `raw.orders → fct_orders → olap_sales_by_day`
**Fix:** Must include all layers:

* raw → staging → core → mart

### Mistake 8.2 — Wrong model names / typos

**Symptom:** `stg_order` (missing s), `fact_orders`, `olap_sales_daily`
**Fix:** Copy model names exactly from dbt Docs.

### Mistake 8.3 — Mixing multiple paths into one chain

**Symptom:** One chain includes both customers + orders + products inconsistently
**Fix:** Choose **one clean path** and write it end-to-end.

---

## 9) When to Contact the TA (and what to send)

Contact your TA if:

* `_run_all.sh` fails and you cannot identify the failing step
* dbt build/test consistently fails after re-running
* dbt Docs won’t serve even after trying another port

When you contact the TA, include:

1. A screenshot of the error
2. The exact command you ran
3. Which step number you were on (Step 1 / 2 / 3.2 / 3.3 / 3.4)

---

## 10) Fast Recovery Commands (Most Common)

```bash
# Always start from repo root
cd ~/IT4065C-Labs

# Re-run full lifecycle
bash labs/module_3/lab4/_run_all.sh

# Re-generate docs + serve
source ~/IT4065C-Labs/dbt-venv/bin/activate
cd ~/IT4065C-Labs/dbt/it4065c_platform
dbt docs generate --select path:models/lab3
dbt docs serve --port 8080
```

```
```
