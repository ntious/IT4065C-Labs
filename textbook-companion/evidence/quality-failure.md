# Quality failure and restoration: supplied evidence

This is an attributed reference observation from a disposable engineering rehearsal on 10 November 2026, not a learner submission or historical production incident. The source was the pinned course revision `d860dd98256a8090ffc6bd3766c59cb15a553c12`, PostgreSQL 16.15, dbt Core 1.11.2 and dbt-postgres 1.10.0.

| State | Observed resource outcomes |
| --- | --- |
| before | success: 10, pass: 37 |
| controlled_failure | success: 8, pass: 30, fail: 2, skipped: 7 |
| restored | success: 10, pass: 37 |

A controlled order-item quantity of zero caused both `positive_line_values` and `order_reconciliation` to fail. Downstream skips are separate from passed or failed resources. The original value was restored and the original ten models/37 tests completed successfully.

Inspect the [machine-readable extract](quality-failure.json). Predict which claims the failure supports, explain why two assertions can fail from one defect, and identify rules that these tests do not cover. A passing restored build does not establish complete source delivery or suitability for a new purpose.

The ordinary Lab 3 task uses a hypothetical violating example and a named test result; it does not assign this failure injection. Follow canonical [Lab 3](https://github.com/ntious/IT4065C-Labs/blob/d860dd98256a8090ffc6bd3766c59cb15a553c12/labs/core/lab03-modeling-quality/README.md). The automated rehearsal is implemented in the baseline `scripts/verify.py`; use its documented disposable verification route when conducting a separate engineering rehearsal.
