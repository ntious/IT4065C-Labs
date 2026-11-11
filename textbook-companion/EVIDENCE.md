# How to Evaluate Evidence in This Book

This book asks you to connect technical observations to accountable decisions. A query result, test report, diagram, or policy document can be useful evidence, but each answers a different question. Use the following sequence whenever you encounter a worked example or make a claim of your own.

## Claim
What are we saying? State the assertion precisely. “The analyst cannot select the raw table” is more testable than “the database is secure.” Identify the requirement or criterion that makes the assertion relevant.

## Evidence
What have we observed? Identify the source and method: inspected code, an executed test, a server record, an interview, or a deliberate simulation. Preserve the actual result, including failures. A proposed control and an expected output are not observations. Check whether the evidence is relevant, reliable, and sufficient for the claim.

## Scope
Under what conditions? Record the system version, dataset, identity, object, operation, and time. Define the population and period covered. A test of one role in one session is a point-in-time observation; it does not describe every user or every day.

## Limitation
What have we not demonstrated? Identify missing paths, untested assumptions, incomplete populations, and alternative explanations. Passing tests do not prove complete requirements coverage. Matching totals can conceal offsetting errors. A stored backup does not prove successful recovery.

## Decision
What can we reasonably conclude? Make the conclusion no broader than the evidence permits. State what may proceed, what remains conditional, who has authority, and what additional work is required. Revise the decision when conditions or evidence change.

## A bounded example
Suppose a separate analyst login can read an approved view but receives the expected privilege-denial code when selecting its underlying raw table. This supports the intended allowance and denial for those tested operations and conditions. It does not establish that all roles are correct, all copies are protected, or the control operated throughout a semester. A reasonable decision is to accept that specific test result and retain the remaining coverage work.

Keep three questions separate: Is the control well designed? Is it implemented? Has it operated effectively over the relevant period? The strongest conclusion is the one whose boundaries another reader can inspect. Chapters 1 and 15 develop this reasoning; Appendices G and H provide reusable records. Start online at the repository-root `textbook-companion/README.md`. Its supplied results describe attributed runs, not your own observations; record the companion revision or manifest separately from the course fixture baseline.
