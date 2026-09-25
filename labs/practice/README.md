# Your hands-on investigation

Run each lab's verified baseline first. Then use the activity below to build your
own explanation and artifact. The runner proves a baseline works; your investigation
shows whether you can apply the concept to a changed situation.

Before independent work, use the [guided-to-independent progression](../../docs/learning_progression.md)
for your lab. It provides a worked starting point and a supported intermediate task.

## Execute your own SQL without managing passwords

From the repository root:

```bash
.venv/bin/python scripts/query.py labs/practice/inspect_register.sql
```

The helper uses the same private .env and non-administrator builder. It executes
SQL you supply, so read the file first and keep experiments inside this disposable
database. `{{schema}}` is replaced with your safely quoted configured schema.
It prints the final statement's rows as JSON. SQL errors show SQLSTATE codes without
printing connection details. Put personal drafts under ignored `.local/`.
For temporary experiments use `BEGIN; ... ROLLBACK;` in the same file.

## Lab 1: Explain the boundary

Follow [the canonical lab page](../core/lab01-environment/README.md) for the concept, investigation and completion requirements.

## Lab 2: Classify an additional field

Follow [the canonical lab page](../core/lab02-classification/README.md) for the concept, investigation and completion requirements.

## Lab 3: Trace grain and test a hypothesis

Follow [the canonical lab page](../core/lab03-modeling-quality/README.md) for the concept, investigation and completion requirements.

## Lab 4: Use lineage to make a decision

Follow [the canonical lab page](../core/lab04-lineage-lifecycle/README.md) for the concept, investigation and completion requirements.

## Lab 5: Predict, authenticate, compare

Follow [the canonical lab page](../core/lab05-access-control/README.md) for the concept, investigation and completion requirements.

## Lab 6: Investigate evidence, not just alerts

Follow [the canonical lab page](../core/lab06-monitoring/README.md) for the concept, investigation and completion requirements.

## Lab 7: Make an accountable AI decision

Follow [the canonical lab page](../core/lab07-ai-governance/README.md) for the concept, investigation and completion requirements.

## Lab 8: Challenge retention behavior

Follow [the canonical lab page](../optional/lab08-retention/README.md) for the concept, investigation and completion requirements.

## Lab 9: Discuss deployment implications

Follow [the canonical lab page](../optional/lab09-infrastructure/README.md) for the concept, investigation and completion requirements.

Author: [Isaac K. Nti](../../AUTHORS.md).
