# Quality, transactions and analytics: Chapters 4–6

Run `transactions` using the [companion launcher](../../SETUP.md). All schema resets occur inside a newly created private cluster. Never run these SQL files against a course or production database.

Before running, predict the difference between a rollback and an autocommit sequence, and whether two transactions can each confirm the last unit of stock. Then inspect the examples and the recorded final states.

| Example | Expected bounded observation |
| --- | --- |
| Quality profile | Missing/invalid representations and duplicate candidates are identified; an empty population has undefined percentages rather than an invented perfect score. |
| Atomicity versus autocommit | A failed transaction leaves no partial checkout; autocommit can retain partial work, with consequences depending on the client's error policy. |
| Naive read-then-write | Two confirmations can occur under the forced read-committed schedule. |
| Repeatable read and retry | A serialization conflict is detected; replaying stale constants can still implement the wrong decision. |
| Conditional update / row lock | The tested decision-aware paths preserve one sale for one unit; a constraint rejects a deliberately naive writer. |
| Lock order | Opposing order can cause a deadlock; one transaction is aborted. |
| Repeated reads | Read committed observes 10 then 7; repeatable read observes 10 twice in the tested schedule. |
| Join grain | The incorrect header-after-line join returns 219.93; the completed-order amount is 139.95. |
| Reconciliation | Missing children, amount mismatch and orphan lines require different checks. |
| Historical dimensions | Version selection, overlapping histories and semi-additive balances require explicit temporal and aggregation rules. |

The original SQL is intentionally allowed to produce some errors, so the launcher also checks material observed outcomes. Interpret SQLSTATE and final data together. Expected figures are supplied reference values; record your actual values separately.

The concurrency harness uses delays to force selected schedules. It is a mechanism demonstration, not exhaustive concurrency verification, a load test or proof of production availability. Database payment rows are not external payment-provider charges. A completed-order trigger demonstrates a local rule, not the retailer's full state machine.

Produce a compact prediction/result table and explain one counterexample that a successful test still would not exclude. Connect it to the invariant, grain or transaction boundary that the architecture must protect.
