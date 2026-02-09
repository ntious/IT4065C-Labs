# 🛠️ Lab 5 Troubleshooting & FAQ

Before posting to the discussion board, please review this guide. Most issues in Lab 5 are related to environment configuration or directory paths.

---

### ❓ 1. I ran the script, but I see "FAIL" messages. Is my lab broken?
**No.** In this lab, **FAIL is often a sign of success.** The script is testing your security enforcement. 
* Look for the phrase: `FAIL (expected)`. 
* This means the database successfully blocked an unauthorized user (like the Analyst) from touching sensitive raw data. 
* If every test says `PASS`, your security is **not** working correctly.

---

### ❓ 2. Error: `bash: labs/module_5/lab5/_run_all.sh: No such file or directory`
This occurs if your terminal is looking in the wrong place.
1.  **Check your location:** Run `pwd`. You should be in `/home/kofi/IT4065C-Labs` (or your equivalent root folder).
2.  **Fix:** Run `cd ~/IT4065C-Labs` and then retry the command.
3.  **Verify Files:** Run `ls labs/module_5/lab5/`. If the folder is empty, you missed **Step 0** (replacing placeholder files).

---

### ❓ 3. What do the weird codes like `arwdDxt` mean in Screenshot 2?
PostgreSQL uses shorthand to show what a user can do. When you run `\dp`, refer to this table:

| Symbol | Permission | What it allows |
| :---: | :--- | :--- |
| **r** | **SELECT** | Read data (Analyst & Steward need this) |
| **a** | **INSERT** | Add new rows (Usually Admin only) |
| **w** | **UPDATE** | Change existing data (Usually Admin only) |
| **d / D** | **DELETE / DROP** | Delete data or entire tables (High Risk!) |
| **t** | **TRUNCATE** | Wipe a table clean instantly |



---

### ❓ 4. Why does the Analyst get a "Schema" error instead of a "Table" error?
If your output shows `permission denied for schema raw`, this is a win for **Defense in Depth**. 
* Instead of just locking individual doors (tables), you have locked the front gate of the building (the schema). 
* This prevents unauthorized users from even seeing what tables exist inside that schema.

---

### ❓ 5. My `\dp` command output is empty.
This usually happens if you are in the wrong database or misspelled the schema.
1.  Ensure you connected using: `psql -d it4065c`.
2.  Ensure you typed the command exactly: `\dp student_kofi.*` (The `.*` is required to see the objects inside).

---

### ❓ 6. I get "Permission Denied" when trying to run the `.sh` script.
If your Ubuntu environment doesn't recognize the script as "executable," run this command:
```bash
chmod +x labs/module_5/lab5/_run_all.sh

```

Then try running the script again.

---

### 💡 Pro-Tip for Critical Thinking (Step 4)

When answering **Q1**, look closely at the results of your masked view. Note that the "shape" of the data remains the same (it still looks like an email or a string), but the "content" is hidden. This is the core difference between **Access Control** (who gets in) and **Data Privacy** (what they see once they are in).

```

