# Lab 6: Monitoring and the strength of evidence

The access runner records what its client observed during live queries. Those records
are useful for demonstrating tested allow/deny outcomes, but a client can alter or
omit them. They are not an independent, tamper-resistant PostgreSQL audit trail.

The incident table is a separate, deterministic simulation. It deliberately includes
repeated denials, a role-switch event and an after-hours export. The SQL rules return
one row per rule/actor so one incident classification does not hide another.

An alert is a hypothesis requiring investigation. A legitimate shift worker may export
after hours; a single authorized query can still misuse data without triggering these
rules. UTC timestamps make this exercise reproducible but do not define every team’s
business hours. Distinguish event time, observation time and the clock/time-zone assumption.

An operational design also needs coverage, retention, access restrictions, integrity,
review ownership and an incident response process. A server audit extension or managed
platform log is a candidate evidence source, not something this client fixture has enabled.

**Check your understanding:** For each finding, label its source, what it supports,
what it cannot establish and a follow-up investigation. Include one false positive
and one missed-incident scenario in your memo.

[Run Lab 6](../../labs/module_6/lab6/README.md) · [Hands-on practice](../../labs/practice/README.md)

---

Author: [Isaac K. Nti](../../AUTHORS.md). [Citation and reuse terms](../../CITATION.md).
