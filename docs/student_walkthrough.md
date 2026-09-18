# Student walkthrough and remaining challenges

Reviewed on 2026-09-18 from a new learner's perspective. This is an instructor-led
walkthrough of the files, links and commands, not evidence from an actual novice
participant or a replacement instructor. Human usability pilots remain necessary.

## Route checked

README → foundations → setup → Lab 1 → lab index → core lab guide → concept notes →
learning progression → practice → submission template → capstone portfolio.
Optional routes: lab index → extension guide → isolated setup → command → evidence
and reflection → recovery. External resources: platform guide → Alation/Snowflake,
with access limitations and a local route clearly stated.

The new infrastructure commands were executed on local PostgreSQL 17.11, including
negative controls and alternate identities. The existing published revision passed
Ubuntu CI; the added infrastructure workflow must pass after these changes are pushed.
A Windows development run does not replace an interactive Ubuntu/WSL setup pilot.

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

## Challenges that remain for real students

- Installing Ubuntu/WSL and using sudo can still need support. Provide a setup session;
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
