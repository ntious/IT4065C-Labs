# Lab 4: Lineage and the full lifecycle

Lineage records dependencies: changing a raw source can affect several downstream
models. dbt’s manifest and local documentation expose these relationships. A dependency
edge describes transformation structure; it does not prove authorization or retention.

Views read underlying data when queried. Materialized tables hold copies until rebuilt
or changed. Deleting a source record therefore does not imply deletion from every
materialized downstream model, export, backup or AI training set. Trace each copy,
its owner, refresh behavior and evidence of deletion in the lifecycle decision log.

Separate acquisition, validation, transformation, permitted use, sharing, retention
and retirement. At each transition ask who approves the change and what evidence
would demonstrate it. Do not label a proposed control as implemented because it
appears in a diagram.

**Check your understanding:** A raw email is removed while a downstream table still
contains a derived identifier. What is your evidence of propagation, and what remains
unknown? Lab 8 extends this reasoning to a simulated restore and deletion ledger.

[Run Lab 4](../../labs/module_3/lab4/README.md) · [Hands-on practice](../../labs/practice/README.md)
