# Changes

## Optional infrastructure and teaching completion (development)

- Added Optional Labs 12–15: server logging, two-instance recovery, TLS/rotation and governance case.
- Added isolated runner, credential boundary tests and expanded Ubuntu CI.
- Added scaffolded core practice, student walkthrough and release-candidate notes.
- Preserved seven required labs and explicit production/validation limitations.


## Teaching guidance and assessment consistency (development)

- Added foundations support, module map, glossary and external-platform boundaries.
- Added rubric descriptors, fictional reasoning example, peer review and instructor sessions.
- Unified the AI rubric and added a required lifecycle change-review discussion.
- Corrected Lab 1 prerequisites and capstone evidence/accessibility requirements.
- Updated published validation evidence for both Ubuntu versions.
- Added adoption, pilot and release gates; practical deployment gaps remain explicit.

## Syllabus alignment and optional enrichment (development)

- Confirmed the pushed Ubuntu 24.04 workflow passes all original nine labs.
- Corrected the Ubuntu 22.04 hash-installation extras pin; both Ubuntu jobs passed at f7b01ce, including optional labs.
- Added optional mixed-format curation and transactional publication/KPI labs.
- Added a module-level syllabus crosswalk and explicit remaining practical gaps.
- Added a Windows/Ubuntu run guide and strengthened lifecycle links for AI governance.
- Updated valid citation metadata and made Isaac K. Nti's author credit visible.

## Reproducible local edition (development)

- One private literal .env and one runner; unique generated credentials.
- Dedicated non-superuser builder and separate reader logins; no shared passwords.
- Fixed duplicate SQL, model selectors, schema drift, relationship tests and sales grain.
- Deterministic synthetic data; safe reruns with no automatic destructive reseed.
- Real permission assertions and clearly labeled client/simulated audit evidence.
- Added AI governance, retention and snapshot experiments with explicit limitations.
- Canonical Markdown replaces obsolete PDF screenshots/instructions and workbook metadata.
- Public outcome/evidence map, instructor runbook, submission templates and checks.

Migration: use a fresh database and new usernames through .env, preserving old
student work. Do not run the new bootstrap against a previous unmarked database.
Old published credentials must still be rotated/revoked by their owner where
applicable. This change cannot remove old clones or Git history.

---

Author: [Isaac K. Nti](AUTHORS.md). [Citation and reuse terms](CITATION.md).
