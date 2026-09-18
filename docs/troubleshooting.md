# Troubleshooting by symptom

| Symptom | Check and safe next step |
| --- | --- |
| Setup unavailable on a managed computer | Use the instructor-managed VM route in [setup](setup.md#managed-computers); do not bypass restrictions. |
| Python or sudo missing | Run the preflight in Ubuntu, not PowerShell. Ask the VM administrator to provide the prerequisites. |
| Installation cannot download packages | Check approved network access; do not disable TLS verification or replace locked packages with unverified downloads. |
| Connection refused or wrong port | Follow [port diagnostics](setup.md#postgresql-port-and-existing-installations). Do not stop an unfamiliar service. |
| Lab 1 authenticates unsuccessfully | Check `.env` locally and rerun bootstrap only on your dedicated course server after a password change. |
| Lab 2 register row missing | Verify the configured schema and your insert file; rerun the inspection query. Do not paste secret configuration in a report. |
| Lab 3 test failure | Inspect the first failure in `.local/dbt-last.log`; trace the violating row and your SQL change. Preserve tests. |
| Lab 4 docs unavailable | Complete Lab 4, run `course.py docs`, and open localhost:8080 on the same host. Stop another owned docs process if needed. |
| Lab 5 analyst query returns 42501 | The masked-data query is intentionally denied; compare the role/action matrix. A denied permitted sales query needs investigation. |
| Lab 6 report interpreted as server log | Distinguish live client observations from the synthetic alert fixture; server evidence is Optional Lab 12. |
| Lab 7 fairness conclusion unclear | Recalculate denominators and compare error costs; equal rates alone do not establish fairness. |
| Optional server experiment fails | Follow [isolated setup and recovery](../labs/extensions/infrastructure_setup.md); do not reuse production databases. |

Send the lab number, command, expected result and a short redacted error to your
instructor's private support route. Never send `.env`, credentials, full logs or
uncropped screenshots. [Setup recovery](setup.md#restart-checks-and-recovery)
explains private evidence and fresh DB/user configuration.

Author: [Isaac K. Nti](../AUTHORS.md).
