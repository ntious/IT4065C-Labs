# Foundations bridge

Start here before Lab 1 if terminal commands, SQL or database terminology are new.
This is a supportive self-check, not an admission requirement or graded exam.
Allow 30–60 minutes; ask for help whenever a step is unclear.

## Locate your work

In your Ubuntu terminal, run `pwd`, then `ls`. Explain which directory you are in
and identify `README.md` after entering the cloned course directory. Use `cd ..`
to move up one directory and `cd IT4065C-Labs` to return. Do not paste Ubuntu
commands into PowerShell. Run the [setup guide](setup.md) when ready.

## Predict before calculating

A fictional library has two loans: loan A has two item rows; loan B has one.
A borrower identifier appears in both a borrower table and each loan.

1. Which field should uniquely identify one loan? What does the borrower reference do?
2. After joining loans to items, how many rows should you expect?
3. If loan A has a fee of 6 and loan B a fee of 3, why is summing loan fees after
   the join incorrect? Predict the correct total and the incorrect joined total.
4. Does successfully connecting to a database prove permission to read every table?
5. Explain how a Linux user, database login, schema and table differ.

Self-check: a loan key identifies one loan; the borrower reference links to a
borrower. The join has three rows. Correct fees total 9; repeating loan A's fee
produces 15. Connection permission does not grant every table privilege. See the
[glossary](glossary.md) for identity and namespace definitions.

## Read a command and an error

After setup, run `.venv/bin/python scripts/course.py check` from the repository
root. Identify the interpreter, script and command argument. Copy only a short,
redacted error excerpt into your private help request if it fails. Explain the
expected result, observed result and what you already tried. Never include `.env`.

Read `labs/practice/inspect_sales.sql` after Lab 3. Locate a SELECT, its source
relation and any grouping. Use the helper in the [practice guide](../labs/practice/README.md)
to execute it. Change a copy only after you can explain the original query.

## Choose your next step

- Ready: explain all five answers in your own words, then continue to Lab 1.
- Need SQL practice: review the library example with a peer and draw its tables.
- Need environment help: use setup troubleshooting before attempting later labs.

Instructors: use these answers to plan support, not to exclude students. Revisit
one question after Lab 3 to check learning rather than recall.

---

Author: [Isaac K. Nti](../AUTHORS.md).
