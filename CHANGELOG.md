# Changes

## 2026-11-10: Stop setup after failed installation diagnostics

- Run offline preflight inside setup before package installation, service changes,
  virtual-environment creation or database provisioning.
- Report the detected Python version and clarify the supported Ubuntu 22.04/24.04
  route, including recovery from unsupported Ubuntu 26.04/Python 3.14 installations.
- Add process-level tests proving rejected preflight cannot reach administration
  or create course configuration; retain the passing installation route.
- Ignore private diagnostic attachments and the local implementation plan, with
  regression checks for those publication boundaries.

This change does not add native Ubuntu 26.04 support or change dependency pins,
lab paths, datasets, learning objectives or assessment requirements.

## 2026-11-08: Focused maintenance and adoption guidance

- Distinguish archival snapshots, CI-validated revisions and offering approval;
  replace stale candidate-publication instructions with verified release records.
- Record known historical resource moves without changing current lab paths.
- Extend blank pilot guidance with accessibility checks; keep completed records,
  Canvas checks and local planning documents offline under ignored directories.
- Add a future-author template and a fictional end-to-end capstone trace without
  changing learning outcomes, rubrics or submission requirements.
- Add scheduled external-link monitoring for public tracked Markdown; existing
  local-link checks and course/website validation remain separate.

## 2026-11-07: Archival metadata correction 2026.11.07.1

- Add explicit Zenodo metadata because its citation importer does not accept the
  multiple-license list supported by CFF. Zenodo reads `.zenodo.json` in preference
  to `CITATION.cff`; keep their title, author and version synchronized.
- Use the archive label Other (Open) with explicit component-specific licensing:
  MIT for original code and CC BY 4.0 for original instructional content. Existing
  University and third-party exclusions remain unchanged.
- Preserve the original release tag; this correction does not change lab behavior.

## 2026-11-07: Archival release 2026.11.07

- Prepare the current course repository and website for a citable Zenodo archive.
- Update Material for MkDocs to 9.7.7, addressing the reported search-suggestion XSS.
- Update citation version and release date; preserve code/content licensing boundaries.
- Preserve existing learning outcomes, lab commands and assessment requirements.

This archival version records the technical teaching resource. It does not certify
completion of the independent novice or replacement-instructor pilots.

## 2026-09-25: Align capstone reasoning and adoption evidence

- Distinguish logical relationships, proposed enforcement and executed checks in Phase 2.
- Mark interview retention/legal assertions as stakeholder inputs requiring validation.
- Align Phase 4 and the portfolio around handling classification, impact and applicability.
- Separate historical validation, the CI-validated candidate and human-pilot release status.
- Check local heading anchors in CI, including duplicate headings and renamed targets.

Learning outcomes and assessment weights are unchanged. Clarified fields belong
in the existing phase entries; no separate reports are added.


## 2026-09-25: Match lab paths to the learning sequence

- Place required Labs 1–7 under `labs/core` and optional Labs 8–15 under `labs/optional`.
- Rename the detailed reporting model to `order_detail_mart` and update dbt metadata.
- Update commands, relative links, templates, wrappers and annotated references together.
- Add a CI rehearsal for student test discovery in the ignored directory.
- Rehearse all executable labs, negative checks and recovery after the migration.

This changes file paths. Start from the current student guide when using a fresh
clone; instructors updating a rehearsal checkout should follow release management.


## Independent review corrections

- Align AI outcome attribution with the institutional notice and date public-source limits.
- Add student/instructor entry pages, core/optional indexes and canonical lab investigations.
- Add read-only installation preflight, port recovery and managed-device guidance.
- Clarify licensing scope and contributor attribution; add a provenance inventory.
- Add a fictional capstone example, delivery plan and human pilot record.
- Pin the reviewed baseline to its actual successful workflow; new changes require their own CI run.


## AI outcome attribution

- Clarified that the AI governance course-level outcome was added by the University after the repository’s initial development.
- Distinguished University outcome authorship from the instructor-developed learning activities.
- Referenced its official wording instead of reproducing it in the public syllabus.


## Editorial consistency and Spring 2026 alignment

- Aligned academic mappings to the updated Spring 2026 syllabus and separately identified added SLO 6.
- Updated full Ubuntu verification evidence, including Optional Labs 12–14.
- Replaced obsolete progress labels with course scope and release-management guidance.
- Standardized direct instructions, evidence boundaries and heading punctuation.
- Added explicit residency/sovereignty analysis and integrated governance operations evidence.


## Optional infrastructure and teaching completion

- Added Optional Labs 12–15: server logging, two-instance recovery, TLS/rotation and governance case.
- Added isolated runner, credential boundary tests and expanded Ubuntu CI.
- Added scaffolded core practice, student walkthrough and release guidance.
- Preserved seven required labs and explicit production/validation limitations.


## Teaching guidance and assessment consistency

- Added foundations support, module map, glossary and external-platform boundaries.
- Added rubric descriptors, fictional reasoning example, peer review and instructor sessions.
- Unified the AI rubric and added a required lifecycle change-review discussion.
- Corrected Lab 1 prerequisites and capstone evidence/accessibility requirements.
- Updated published validation evidence for both Ubuntu versions.
- Added adoption, pilot and release gates; practical deployment gaps remain explicit.

## Syllabus alignment and optional enrichment

- Confirmed the pushed Ubuntu 24.04 workflow passes all original nine labs.
- Corrected the Ubuntu 22.04 hash-installation extras pin; both Ubuntu jobs passed at f7b01ce, including optional labs.
- Added optional mixed-format curation and transactional publication/KPI labs.
- Added a module-level syllabus crosswalk and explicit demonstration boundaries.
- Added a Windows/Ubuntu run guide and strengthened lifecycle links for AI governance.
- Updated valid citation metadata and made Isaac K. Nti's author credit visible.

## Reproducible local edition

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
