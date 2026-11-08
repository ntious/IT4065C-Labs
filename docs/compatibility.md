# Resource compatibility register

Keep the current paths, lab numbering, runner commands and portfolio section IDs
stable during an offering. This is a public register of repository resources,
not a record of private Canvas links. Actual LMS usage is **not yet verified** here.
Copy the rows needed into an ignored `local-docs/` worksheet for instructor checks.
Never commit LMS URLs, participant records or completed submissions.

## Known September migration

The following moves are derived from Git rename records at commit
`0bf0708111ca13b18bebd93c626efd126c8f73b3`. They describe a past migration, not a proposed rename.
The list covers lab guide entry points and the renamed reporting model, not every
historical asset. Check linked SQL, images and wrappers individually when an old
Canvas link identifies one. Older layouts may need separate investigation.

| Resource | Current location | Previous location | Protection |
| --- | --- | --- | --- |
| lab3 | [dbt/it4065c_platform/models/marts/lab3/order_detail_mart.sql](../dbt/it4065c_platform/models/marts/lab3/order_detail_mart.sql) | `dbt/it4065c_platform/models/marts/lab3/oltp_order_detail.sql` | Preserve current path; verify prior LMS use privately |
| lab01-environment | [labs/core/lab01-environment/README.md](../labs/core/lab01-environment/README.md) | `labs/module1_preflight/README.md` | Preserve current path; verify prior LMS use privately |
| lab02-classification | [labs/core/lab02-classification/README.md](../labs/core/lab02-classification/README.md) | `labs/module_2/M2_lab2_governance.md` | Preserve current path; verify prior LMS use privately |
| lab03-modeling-quality | [labs/core/lab03-modeling-quality/README.md](../labs/core/lab03-modeling-quality/README.md) | `labs/module_2/lab3/README.md` | Preserve current path; verify prior LMS use privately |
| lab04-lineage-lifecycle | [labs/core/lab04-lineage-lifecycle/README.md](../labs/core/lab04-lineage-lifecycle/README.md) | `labs/module_3/lab4/README.md` | Preserve current path; verify prior LMS use privately |
| lab05-access-control | [labs/core/lab05-access-control/README.md](../labs/core/lab05-access-control/README.md) | `labs/module_5/lab5/README.md` | Preserve current path; verify prior LMS use privately |
| lab06-monitoring | [labs/core/lab06-monitoring/README.md](../labs/core/lab06-monitoring/README.md) | `labs/module_6/lab6/README.md` | Preserve current path; verify prior LMS use privately |
| lab07-ai-governance | [labs/core/lab07-ai-governance/README.md](../labs/core/lab07-ai-governance/README.md) | `labs/extensions/ai_governance.md` | Preserve current path; verify prior LMS use privately |
| lab08-retention | [labs/optional/lab08-retention/README.md](../labs/optional/lab08-retention/README.md) | `labs/extensions/retention.md` | Preserve current path; verify prior LMS use privately |
| lab09-infrastructure | [labs/optional/lab09-infrastructure/README.md](../labs/optional/lab09-infrastructure/README.md) | `labs/extensions/infrastructure.md` | Preserve current path; verify prior LMS use privately |
| lab10-catalog-ingestion | [labs/optional/lab10-catalog-ingestion/README.md](../labs/optional/lab10-catalog-ingestion/README.md) | `labs/extensions/catalog_ingestion.md` | Preserve current path; verify prior LMS use privately |
| lab11-quality-promotion | [labs/optional/lab11-quality-promotion/README.md](../labs/optional/lab11-quality-promotion/README.md) | `labs/extensions/quality_promotion.md` | Preserve current path; verify prior LMS use privately |
| lab12-server-audit | [labs/optional/lab12-server-audit/README.md](../labs/optional/lab12-server-audit/README.md) | `labs/extensions/server_audit.md` | Preserve current path; verify prior LMS use privately |
| lab13-transfer-recovery | [labs/optional/lab13-transfer-recovery/README.md](../labs/optional/lab13-transfer-recovery/README.md) | `labs/extensions/two_instance_transfer.md` | Preserve current path; verify prior LMS use privately |
| lab14-tls-rotation | [labs/optional/lab14-tls-rotation/README.md](../labs/optional/lab14-tls-rotation/README.md) | `labs/extensions/tls_rotation.md` | Preserve current path; verify prior LMS use privately |
| lab15-governance-case | [labs/optional/lab15-governance-case/README.md](../labs/optional/lab15-governance-case/README.md) | `labs/extensions/governance_case.md` | Preserve current path; verify prior LMS use privately |

## Other protected interfaces

| Resource | Current location / interface | Compatibility rule |
| --- | --- | --- |
| Student entry | [Student start](../STUDENT_START_HERE.md), [course checklist](course_checklist.md) | Preserve entry paths and sequencing |
| Setup | [Local installation](local_run.md), `bash scripts/setup.sh` | Preserve the supported route; no silent reinstall/reset |
| Lab execution | `scripts/course.py lab N`, `scripts/query.py` | Preserve arguments, separate reader identities and expected negative checks |
| Capstone | [Overview](../capstone_project/README.md), [portfolio](../capstone_project/portfolio_template.md) | Preserve phase links and existing section identifiers |
| Submissions | [Private submission guidance](../submissions/README.md) | Preserve public scaffolds; keep completed work ignored |
| Website | Existing GitHub Pages routes | Test built routes separately from repository links |

A Markdown pointer file is not an HTTP redirect. Do not add executable aliases or
mass-create legacy folders without verifying semantics and actual use. A future
migration needs an old-to-new map, fixed prior release, matching guides, tested
links, private-work preservation and an announced transition. Reverting a focused
maintenance PR must not move archive tags or rewrite Git history.

Author: [Isaac K. Nti](../AUTHORS.md).
