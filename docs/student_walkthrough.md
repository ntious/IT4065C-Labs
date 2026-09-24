# Student navigation and learning support

Editorial review on 2026-09-18, extended by an Ubuntu WSL instructor rehearsal on
2026-09-24. This editorial walkthrough
covers files, links and commands. It records navigation checks and support needs;
no novice-learner or replacement-instructor pilot results are recorded.

## Route checked

README → foundations → setup → Lab 1 → lab index → core lab guide → concept notes →
learning progression → practice → submission template → capstone portfolio.
Optional routes: lab index → extension guide → isolated setup → command → evidence
and reflection → recovery. External resources: platform guide → Alation/Snowflake,
with access limitations and a local route clearly stated.

Infrastructure commands passed local PostgreSQL checks with negative controls and
alternate identities, and the complete Ubuntu 22.04/24.04 workflow passed at commit
`2f15cc9`. See [validation](validation.md). Automated checks and this walkthrough
serve different purposes from an interactive Ubuntu/WSL learner pilot.

## Challenges found and addressed

| Student question | Adjustment |
| --- | --- |
| Do I need to run all fifteen labs? | Core remains 1–7. Every new lab is labeled Optional; the index separates the extension route. |
| Does `all` mean required work? | Clarified that it rehearses 1–9 for instructors; students follow individual core commands. |
| How do I move beyond copying commands? | Added guided example, supported practice and independent transfer for each core lab. |
| Where are the optional server credentials? | Generated privately by default; separate environment overrides are documented without shared values. |
| Will the extension change my existing course database? | Separate fresh directories, instances and ports; runner never connects to the core database. |
| What does a failed connection prove? | TLS tests check the expected error reason; a random connection failure is not a successful security test. |
| Where do I find evidence, and when am I done? | Each run prints its private directory; PASS confirms checks, then students complete the reflection rubric. |
| What if I close the terminal or the run fails? | Exact per-instance status/stop guidance and fresh-run recovery, with no automatic recursive deletion. |
| Do I need external badges/accounts? | Optional Snowflake and assigned Alation supplements are separate from the self-contained local labs. |

## Findings from the Ubuntu WSL rehearsal

| Point of confusion | Applied clarification |
| --- | --- |
| Does a technical COMPLETE line mean I can submit? | Part A execution, Part B reasoning and per-lab submission checklists are separate. |
| Is an empty `[]` a failed retention experiment? | The guides explain no-result statements and assertion success; students record predicted states separately. |
| Why are there five audit records after nine checks? | Five client query observations are logged; four escalation assertions are checked separately. |
| What exactly do I edit in the optional SQL? | Exact private filenames, replacement statements, assertion positions, save keys and execution commands are supplied. |
| How do I write a contract test without starting from nothing? | Lab 10 supplies a two-test starter and a supported third-test example with indentation guidance. |
| Which randomly named evidence file belongs to this run? | Each successful infrastructure run prints its exact copyable reading command. |
| Do true rejection flags mean the security test failed? | Lab 14 explains that true means the unsafe connection was correctly rejected. |
| How do I distinguish KPI columns? | The generated HTML now spaces and separates headings and values; an annotated browser view and JSON alternative are supplied. |

Actual command results and scope are recorded in [validation](validation.md#ubuntu-wsl-instructional-walkthrough-2026-09-24).
From a student perspective, the remaining learning challenges are interpreting
SQL grain, distinguishing observations from proposals, and explaining governance
tradeoffs. These require reasoning and feedback rather than more commands.
The foundations guide, worked examples and text alternatives support that work.

## Independent-learner review: navigation and workload revisions

The follow-up editorial review addressed eight usability concerns without changing
the course learning outcomes or rubric weights:

- One installation page branches for Windows/WSL and native Ubuntu, then joins
  common commands and a consistent return path. Other Linux distributions use an
  Ubuntu VM rather than an unverified native route.
- Foundations are separated by when needed, with visible library tables before
  join/grain self-checks.
- Lab 1 uses a supplied configuration flow and three short explanations; source
  code reading is optional. Remote-server reasoning follows access control in Lab 5.
- A course checklist exposes companion discussions, modeling work and capstone
  alongside the seven-lab route, preventing hidden requirements.
- Lab 7 uses three deliverables with suggested lengths and one combined dataset/
  lifecycle record. Its revised time allowance is a planning estimate, not pilot data.
- Lab 3 demonstrates valid versus violating rows before the independent predicate.
- Labs 2–3 have linked progress lists, stopping points and expandable recovery.
- Independent learners have a self-check target, alternate-scenario examples and
  a sanitized issue route with no promise of grading or individual tutoring.

These changes reduce avoidable navigation and duplication. They do not establish
that every learner will find the work easy; a novice pilot remains a separate check.

## Learning support priorities

- Provide a setup session for Ubuntu/WSL installation and sudo use;
  an institution-managed device may require its IT team.
- SQL grain and identity boundaries require reasoning practice even when installation
  works. Use the foundations self-check and scaffolded practice before independent tasks.
- Log files can be dense. Begin with the filtered evidence JSON, then inspect only the
  relevant private CSV records. Do not share full logs for troubleshooting.
- A governance case supports multiple defensible conclusions. The instructor must
  assess facts, primary sources and uncertainty, not reward agreement with one answer.
- Optional server runs retain data and logs. Confirm shutdown and periodically remove
  only run folders no longer needed. The documented cleanup is intentionally explicit.
- Cloud workshop interfaces and account access change. The LMS must identify current
  assigned activities and workload; public links are not enrollment guarantees.

## Human pilot record

Before a stable teaching release, ask a novice to follow the route without a live
walkthrough. Record time to first check, unclear instructions, help requests and
one independently explained transfer task. Ask another instructor to teach and
assess one session from the materials. Keep names and responses private; publish
only consented aggregate improvements. Do not mark these pilots complete in advance.

---

Author: [Isaac K. Nti](../AUTHORS.md).
