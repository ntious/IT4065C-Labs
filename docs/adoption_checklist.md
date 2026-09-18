# Course adoption, pilot and release checklist

## Before adoption

- Select a tested commit and record it in the private course plan.
- Reconcile the module map with the official syllabus and actual teaching calendar.
- Confirm external platform names, access arrangements, activities and alternatives.
- Map the Spring 2026 practical outcomes to assessed catalog, workflow, encryption
  and monitoring evidence. Optional Labs 12–14 provide extension routes; optional
  availability does not establish that every student completed an outcome.
- Rehearse setup, core labs, selected optional labs and recovery on disposable Ubuntu.
- Prepare private grading calibration and the approved submission route.

## Two usability pilots

A novice learner should follow the README, setup and first three labs without a live
walkthrough. Record time to first successful check, confusing steps, help requests,
and ability to explain one independently changed example. Collect feedback privately.

A replacement instructor should prepare one class from the session guide, explain
expected results, diagnose a prepared failure and assess a fictional submission.
Record missing information and revise before inviting broad adoption. Neither pilot
has been completed merely because automated tests passed.

## Release gate

- Both Ubuntu workflow jobs pass at the intended executable revision.
- Local links, evidence labels and assessment instructions agree.
- Known limitations, supported platforms and dependency maintenance are documented.
- Owner reviews historical credential revocation and sensitive Git history separately.
- Pilot blockers are resolved or clearly listed with a usable workaround.
- Maintainer selects a version tag and publishes release notes linking exact test results.

A tag is a stable reference, not a guarantee that installations will remain identical
forever: distribution packages and external resources can change. Keep the tested
commit and supported environment visible. Do not create a release labeled fully
syllabus-complete while required practical gaps remain unresolved.

## Maintenance

Before each offering, review dependency advisories, external links, platform access,
synthetic fixtures and assessment consistency. Run the workflow after dependency or
execution changes. Preserve prior teaching releases so cohorts do not receive
unannounced changes mid-course. Record curriculum changes in the changelog.

---

Author: [Isaac K. Nti](../AUTHORS.md).
