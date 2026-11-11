# Copies, access, monitoring and recovery: Chapters 10–14

Run `lifecycle` using the [companion launcher](../../SETUP.md). The suite initializes its own temporary primary, and creates a standby and recovery instance for the final experiment. All share the same host.

| Chapter | Investigation and expected observation |
| --- | --- |
| 10 | A source deletion does not automatically remove materialized/exported/backup copies. A real logical backup is restored; ordered refresh and deletion-ledger replay affect the restored state. |
| 11 | Separate authenticated logins test intended allowances and exact authorization denials. A view edit can expose an additional field without changing its grants. Rotation blocks a new connection using the old credential while an already established session continues until explicitly terminated. |
| 12 | A small known-candidate lookup can recover values represented by unkeyed hashes. This is a synthetic linkage demonstration, not an anonymity guarantee or a population attack. |
| 13 | Actual failed-login server records are distinguished from client observations. A time-window rule expires old events. A small index experiment and freshness states demonstrate bounded operational observations. |
| 14 | A streaming standby applies a mistaken deletion. A separate same-host point-in-time recovery restores 1,100 orders, matches an independently generated expected relation in both directions, and excludes two orders committed after the target. |

Chapter 14's completed-order control total is **45,700.00**, from its separate generated fixture. It is not the course's 139.95 total or optional ingestion's 45.00. Recovery timings vary and are measured by stated endpoints; they are not production RPO/RTO results. Expected rows are independently generated logically but share the run's host and custody.

Purpose-based login names are synthetic. Passwords are generated for each run, supplied at runtime and destroyed with the clusters. No real account, customer, incident or operational log is included in the public package. The reference log from your execution stays private.

Record the source, observed state, mechanism, untested path and decision for one chapter. For recovery, include acceptance criteria and dependencies not recovered by this exercise. Same-host backup, archive and restoration do not demonstrate independent hardware fault tolerance, regional recovery or ransomware resilience.
