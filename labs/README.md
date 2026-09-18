# Lab sequence

Complete Labs 1–7 in order for the revised course. Lab 7 addresses the added AI
ethics/governance outcome and is part of that core sequence. Labs 8–9 provide
additional lifecycle/infrastructure experiments. None require paid services.

| Lab | Outcome | Time estimate |
|---|---|---|
| [1. Environment readiness](module1_preflight/README.md) | SLOs 3,4 | 30–60 minutes first setup |
| [2. Classification and stewardship](module_2/M2_lab2_governance.md) | SLOs 1,5 | 45–60 minutes |
| [3. Modeling and data quality](module_2/lab3/README.md) | SLO 4 | 60–90 minutes |
| [4. Lifecycle and lineage](module_3/lab4/README.md) | SLOs 2,4 | 45–60 minutes |
| [5. Access control and masking](module_5/lab5/README.md) | SLO 5 | 60–90 minutes |
| [6. Monitoring and evidence](module_6/lab6/README.md) | SLO 5 | 60–90 minutes |
| [7. AI ethics and governance](extensions/ai_governance.md) | SLO 6 | 60–90 minutes |
| [8. Retention and deletion](extensions/retention.md) | SLOs 2,5 | 45–60 minutes |
| [9. Infrastructure snapshot experiment](extensions/infrastructure.md) | SLO 3 | 45–60 minutes |

## Run the technical rehearsal

```bash
.venv/bin/python scripts/course.py all
```

This runs the executable parts; written reasoning, ERDs and defenses still need human assessment.
