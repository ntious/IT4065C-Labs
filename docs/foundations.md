# Foundations bridge

Use the part you need now. This is practice, not an admission test. You may read
the worked answers immediately, then try explaining them in your own words.

| When | Start here |
| --- | --- |
| Terminal commands are new | Part A, before installation |
| Lab 1 account names are confusing | Part B, after setup |
| You are about to start Lab 3 | Part C, before modeling |

## Part A: Before installation

A terminal accepts text commands. A folder is also called a directory.
In **Ubuntu Terminal**, enter one command at a time and press Enter:

```bash
pwd
```

This prints your current folder. Its path may include your private username.
You do not need to publish it. Next:

```bash
ls
```

This lists files and folders. Empty output can simply mean the folder is empty.
`cd` changes folders; `cd ~` takes you to your Ubuntu home folder, and `cd ..`
moves one level up. These commands do not delete files.

The [installation guide](local_run.md) will create `~/courses/IT4065C-Labs`.
After cloning, entering that folder and running `ls` should show `README.md`,
`labs` and `scripts`. That is the repository root used in lab instructions.

**Ready to continue:** you know where to type Ubuntu commands and how to identify
the repository folder. Continue with installation; SQL is not needed yet.

## Part B: After setup, before the Lab 1 worksheet

| Term | Plain-language meaning | Example responsibility |
| --- | --- | --- |
| Ubuntu account | Your identity for files and terminal commands | Saves your private draft; uses sudo for authorized setup |
| Database login | An identity PostgreSQL authenticates | Builder creates course objects; analyst reads approved views |
| Schema | A named group of database objects | Locates a table; knowing its name does not grant permission |
| Table | Rows and columns holding records | One order per row in the raw orders table |

Connection success means a login can connect; it does not mean every table is
readable. Lab 5 tests those permissions. You do not need to run that lab early.

**Self-check:** Which identity saves a file? Which checks database privileges?
Answer: the Ubuntu account controls file operations; PostgreSQL checks the
connected database login's privileges. Continue to the [Lab 1 worksheet](../labs/module1_preflight/README.md#hands-on-investigation).

## Part C: Before Lab 3, learn keys, joins and grain

A **key** identifies a row. **Grain** means what one row represents. A **join**
matches records between tables using related values. Read this fictional library example.

Loans: one row per loan; `loan_id` is the key.

| loan_id | borrower_id | loan_fee |
| --- | --- | --- |
| A | R1 | 6 |
| B | R1 | 3 |

Items: one row per borrowed item; `item_id` is the key and `loan_id` refers to a loan.

| item_id | loan_id |
| --- | --- |
| I1 | A |
| I2 | A |
| I3 | B |

Matching items to loans on `loan_id` produces:

| loan_id | item_id | loan_fee |
| --- | --- | --- |
| A | I1 | 6 |
| A | I2 | 6 |
| B | I3 | 3 |

The joined result has **item grain**: three rows. Loan A's fee is repeated, not
charged twice. Adding this fee column gives 6 + 6 + 3 = 15, but the actual
loan-level total is 6 + 3 = 9. Decide what one row represents before adding values.
The shared borrower R1 does not make A and B the same loan.

**Try:** If loan B had two items instead of one, how many joined rows would appear?
Would the actual loan-level fee total change?

<details>
<summary>Check your reasoning</summary>

Four joined rows; the actual loan-level total stays 9. Joining creates repeated
representations of a loan's fee, not additional loan fees.

</details>

Now continue to [Lab 3](../labs/module_2/lab3/README.md). Use the
[glossary](glossary.md) for unfamiliar words as they appear; memorization is not required.

---

Author: [Isaac K. Nti](../AUTHORS.md). [Citation and reuse terms](../CITATION.md).
