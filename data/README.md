# Synthetic data
Every record is fabricated for teaching. No dataset describes actual customers or demographic groups.
The retail seed has four customers, four products, four orders and five line items.
Completed order revenue is 139.95; cancelled orders are excluded. Dates are fixed in UTC.
AI groups A/B are arbitrary scenario labels. Sixteen observations illustrate calculations,
not statistical evidence about any population. Baseline/mitigated decisions are supplied
policy examples, not learned models. The mitigation improves recall for B but raises its
false-positive rate. Explain the tradeoff rather than declaring the system fair.
Data are included under the repository MIT code license; no external download is required.
# Optional ingestion fixture

`ingestion/` contains authored synthetic CSV, JSON-lines and plain-text examples.
Contact fields use reserved example.com addresses. Two malformed records are
intentional rejection cases. The approved three-record batch totals 45.00.
This fixture is separate from the core retail dataset and is not evidence about
real customers. See optional Labs 10–11 for permitted use and expected results.

---

Author: [Isaac K. Nti](../AUTHORS.md). [Citation and reuse terms](../CITATION.md).
