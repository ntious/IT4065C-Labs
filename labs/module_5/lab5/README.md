# Module 5 – Lab 5  
## Enforcing Data Access Policies in PostgreSQL (RBAC + Masking)

**Course:** IT4065C – Data Technologies Administration  
**Module:** Module 5 – Data Access Control and Security Implementation  
**Primary SLO:** SLO 5  
**Recommended Mode:** 🧪 Hands-On (Required)  
**Estimated Time:** 60–90 minutes  
**Risk Level:** Moderate (permission changes)  
**Environment Stress:** Low–Moderate (Postgres + psql only)

---

## 🎯 Purpose (Read First)
In earlier modules, you classified data sensitivity and designed data layers. In this lab, you take the final administrative step: **Enforcement.** You will transition from "knowing" what is sensitive to "blocking" unauthorized access using:
1.  **Role-Based Access Control (RBAC):** Creating distinct roles (`analyst`, `steward`, `admin`) with specific permissions.
2.  **Data Masking:** Creating views that obfuscate PII (Personally Identifiable Information) so data remains useful but private.


✅ **Turning governance decisions into enforceable controls** (who can access what, and how).

This lab is designed to **minimize cognitive load**:
- You will **not write SQL from scratch**
- You will run **provided scripts**
- Your main work is **verification + reasoning**

---

## What you will do
You will implement three real-world controls in PostgreSQL:

1) **Role-Based Access Control (RBAC)**  
2) **Least-Privilege Grants**  
3) **Masking via Views** (safe access to PII fields)

Then you will **verify** the controls with test queries that should either **PASS** or **FAIL**.

---

## What you are given (do not edit)
All scripts are provided in this folder:

- `00_precheck.sql` – creates required schemas (safe / idempotent)  
- `01_seed_if_missing.sh` – loads raw dataset **only if** it is missing  
- `02_build_safe_objects.sql` – creates analytics views and masked views  
- `03_rbac_and_grants.sql` – creates roles and applies least-privilege permissions  
- `04_verify_access.sql` – runs PASS/FAIL checks using `SET ROLE` (no passwords needed)  
- `_run_all.sh` – runs everything in the correct order

---

## Before you begin
1) Start your Ubuntu VM
2) Ensure PostgreSQL is running:
```bash
sudo systemctl status postgresql
```

---

## 🛠 Step 0: Replace Placeholder Files (Required)
The `lab5` folder in your repository currently contains empty placeholder files. You must replace them with the functional logic provided on Canvas.

1.  **Download:** `Lab5_Source.zip` from Canvas.
2.  **Navigate:** Open your terminal and go to:  
    `~/IT4065C-Labs/labs/module_5/lab5/`
3.  **Replace:** Delete the existing files and copy the new ones here.
4.  **Verify:** Run `ls`. You should see `_run_all.sh`, `01_roles.sql`, and `02_views.sql`.

---

## 🔑 Step 1: Establish your Session
To avoid repeated password prompts during the automation, set your PostgreSQL password for this terminal session:

```bash
export PGPASSWORD='Pa$$w0rd123!'

```

*(Note: If you used a different password in Lab 1, use that value here.)*

---

## 🚀 Step 2: Run Policy Enforcement

Run the master script. This script acts as a "Policy-as-Code" deployment. It creates the roles, establishes the views, and applies `GRANT/REVOKE` commands.

```bash
cd ~/IT4065C-Labs
bash labs/module_5/lab5/_run_all.sh

```

### 📸 Screenshot 1: Validation

Scroll to the **Step 4: Verify access behavior** section in your terminal. You are looking for the Pass/Fail tests.

* **Role Analyst:** Should result in `PASS` for views but `ERROR: permission denied` for raw tables.
* **Role Steward:** Should result in `PASS` for masked views but `FAIL` for raw PII.
* **Capture a screenshot** showing these PASS/FAIL results.

---

## 🔍 Step 3: Audit the "Privilege Matrix"

Now, we will verify how PostgreSQL stores these permissions internally using the system catalog.

1. **Enter Postgres:**
```bash
psql -h localhost -U postgres -d it4065c

```


2. **Run the Audit Command:**
```sql
\dp student_kofi.*

```



### 💡 Decoder Ring for Output

Check the **Access privileges** column for these specific objects:

| Object | Expected Permission | Code Meaning |
| --- | --- | --- |
| `v_sales_by_day` | `role_analyst=r` | **r** = SELECT (Read only) |
| `v_customers_masked` | `role_steward=r` | **r** = SELECT (Read only) |
| `dim_customers` | `role_admin=arwdDxt` | Full permissions (All privileges) |

### 📸 Screenshot 2: The Audit Trail

* **Capture a screenshot** of the `\dp` output. Ensure the `role_analyst` and `role_steward` lines are visible.
* Exit PostgreSQL: `\q`

---

## 🧠 Step 4: Critical Thinking

*Answer each question in 4–7 sentences.*

**Q1: From Classification to Control** Identify two columns in `raw.customers` that you previously classified as "Sensitive" or "Restricted." Explain how the **Masking View** (`v_customers_masked`) protects these columns differently than the **RBAC** settings on the raw table.

**Q2: Interpreting Errors** In your script output, the analyst received an `ERROR: permission denied for schema raw`. Even though the analyst has a role, they cannot even access the schema level. Why is **Schema-level** security a better "defense in depth" strategy than just protecting individual tables?

**Q3: The Administrative Risk** Your `\dp` output shows `role_admin` has `arwdDxt` (All Privileges). If a user accidentally uses the `admin` role for a daily reporting dashboard instead of the `analyst` role, what specific security risks are introduced to the data lifecycle?

**Q4: Monitoring Beyond Access** If an unauthorized user tries to run `SELECT * FROM raw.customers` and is blocked by the system, the data is safe. Why is it still critical for a Security Administrator to monitor and log these **failed** access attempts in a production environment?

---

## 📥 Deliverables

Submit a single PDF or Word document containing:

1. **Screenshot 1:** The PASS/FAIL verification terminal output.
2. **Screenshot 2:** The `\dp student_kofi.*` privilege table.
3. **Written Responses:** Thorough answers to Questions 1–4.

```