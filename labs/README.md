# Lab sequence

Complete Labs 1–7 in order. Lab 7 addresses the added AI
ethics/governance outcome and is part of that core sequence. Labs 8–11 provide
additional lifecycle, infrastructure, ingestion and publication experiments. Optional
Labs 12–14 add isolated server experiments; Optional Lab 15 is a governance case.
None require paid services. Use this index to navigate the activities. The folders follow lab numbers: `core/lab01` through `core/lab07`, and
`optional/lab08` through `optional/lab15`, with topic names appended.
Syllabus modules are mapped separately in the required course path.

For the complete course, use the [required course path](../docs/course_checklist.md),
which includes the companion discussions and capstone. For labs alone, follow
the core sequence below.

## Core labs

Labs 1–7 form the required sequence.

| Lab | Outcome | Time estimate |
|---|---|---|
| [1. Environment readiness](core/lab01-environment/README.md) | SLOs 3,4 | 30–60 minutes first setup |
| [2. Classification and stewardship](core/lab02-classification/README.md) | SLOs 1,5 | 45–60 minutes |
| [3. Modeling and data quality](core/lab03-modeling-quality/README.md) | SLO 4 | 60–90 minutes |
| [4. Lifecycle and lineage](core/lab04-lineage-lifecycle/README.md) | SLOs 2,4 | 45–60 minutes |
| [5. Access control and masking](core/lab05-access-control/README.md) | SLO 5 | 60–90 minutes |
| [6. Monitoring and evidence](core/lab06-monitoring/README.md) | SLO 5 | 60–90 minutes |
| [7. AI ethics and governance](core/lab07-ai-governance/README.md) | SLO 6 | Two 45–75-minute sessions; planning estimate |

## Optional labs 8–11

| Optional lab | Outcome | Time estimate |
|---|---|---|
| [8. Retention and deletion](optional/lab08-retention/README.md) | SLOs 2,5 | 45–60 minutes |
| [9. Infrastructure snapshot experiment](optional/lab09-infrastructure/README.md) | SLO 3 | 45–60 minutes |
| [10. Mixed-format catalog and ingestion](optional/lab10-catalog-ingestion/README.md) | SLOs 1,2,4 | 60–90 minutes; optional |
| [11. Quality-gated publication and KPI](optional/lab11-quality-promotion/README.md) | SLOs 2,4 | 60–90 minutes; optional |

Use the [module learning map](../docs/module_learning_map.md) for required discussion
and capstone evidence. Start with the [foundations bridge](../docs/foundations.md)
when SQL or terminal use is new.

## Optional extensions 12–15

| Optional lab | Outcome | Estimated time |
| --- | --- | --- |
| [12. Server-side audit investigation](optional/lab12-server-audit/README.md) | SLO 5 | 60–90 minutes |
| [13. Two-instance transfer and recovery](optional/lab13-transfer-recovery/README.md) | SLOs 2–3 | 60–90 minutes |
| [14. Verified TLS and credential rotation](optional/lab14-tls-rotation/README.md) | SLO 5 | 60–90 minutes |
| [15. Governance applicability case](optional/lab15-governance-case/README.md) | SLOs 1,2,5,6 | 60–90 minutes |

Complete the [optional setup](optional/infrastructure_setup.md) before Labs 12–14.
Lab 15 is a reading/reflection activity. These additions do not change the seven-lab
core, official grade weights or the required short governance discussion.

## Run the technical rehearsal

```bash
.venv/bin/python scripts/course.py all
```

This runs the executable parts; instructors assess written reasoning, ERDs and defenses separately.

`all` is an instructor rehearsal of Labs 1–9, including optional 8–9; it does not
mean that all nine are required student work. For the core, run labs 1 through 7
individually. Optional Labs 10–11 use:

```bash
.venv/bin/python scripts/optional_labs.py catalog
.venv/bin/python scripts/optional_labs.py promotion
```

Optional Labs 12–14 use separate commands, each creating fresh instances:

```bash
.venv/bin/python scripts/infrastructure_labs.py audit
.venv/bin/python scripts/infrastructure_labs.py transfer
.venv/bin/python scripts/infrastructure_labs.py tls
```

Do not run every command just to start the course. Choose optional activities for
your learning interests or the instructor's designated enrichment route.

---

Author: [Isaac K. Nti](../AUTHORS.md). [Citation and reuse terms](../CITATION.md).
