# Optional local report checker: Labs 1–7

Use this optional aid after writing your report and before submitting it. It looks
for familiar headings, text markers, unfinished prompts and common privacy patterns.
It does not grade answers, certify completeness or replace your lab's **Submit**
checklist. You do not need a passing checker result to submit. Keep your own wording;
review a flag in context rather than adding keywords or inventing evidence.

## Run a check

Save your private report as Markdown (`.md`), UTF-8 plain text (`.txt`) or Word
(`.docx`). Run from the repository root using the environment created by setup:

```bash
.venv/bin/python scripts/report_checks/lab05.py .local/lab5-report.md
```

Replace the filename with your actual report path. Quote paths containing spaces.
Use `lab01.py` through `lab07.py` for the matching lab. These commands read your
existing files; they do not create or submit your report, connect to the database,
execute student SQL, or send any report content over the network. No new dependency
is needed. If setup has not yet succeeded, `python3` can run this standalone aid.

For a Lab 4 decision log:

```bash
.venv/bin/python scripts/report_checks/lab04.py .local/lab4-decision-log.md
```

For Lab 7, supply both files when the worksheet is separate:

```bash
.venv/bin/python scripts/report_checks/lab07.py .local/lab7-submission.md .local/lab7-decision.md
```

A reference to another file does not load it automatically. Include each relevant
report file explicitly. Keep the file format your instructor requires for actual
submission; this checker does not change LMS requirements. PDFs and screenshot-only
reports are not supported. If needed, check a text copy without changing your final
submission format. DOCX reading covers body text and tables, not images, comments,
headers, footers or metadata. Reports and decompressed DOCX body XML are limited to
10 MiB; use a text-only copy if images make a document too large.

## Interpret feedback

| Label | Meaning and next action |
| --- | --- |
| `PASS` | A specific marker or artifact field was detected. It does not establish that an answer is correct or complete. |
| `WARN` | Inspect a possible omission, privacy pattern or unavailable artifact. Equivalent wording may already satisfy the lab. |
| `MISSING` | A common unfinished answer prompt was detected. Replace it if it is still an answer placeholder; a quoted example may be a false alarm. |
| `REVIEW` | A person must evaluate reasoning, evidence limits or content the checker cannot inspect. |

The final labels are deliberately advisory:

- `NO AUTOMATIC FLAGS`: supported checks found no flags; still use the lab checklist.
- `REVIEW SUGGESTIONS`: inspect warnings; they are not a grade or submission rejection.
- `CHECK FLAGGED ITEMS`: inspect remaining placeholder prompts before submitting.

For example, a report containing `[Write here]` can produce:

```text
MISSING Unfinished placeholders
STRUCTURAL STATUS: CHECK FLAGGED ITEMS
```

Other messages depend on your report and local files. An empty heading, copied
sample or unrelated mention can satisfy a keyword check. Conversely, a valid table,
paraphrase or screenshot may not be recognized. Do not claim the checker verified
reasoning or the authenticity of your execution evidence. Privacy scanning is
limited: inspect your document, screenshots and metadata yourself before sharing.
The output reports file basenames and warning categories, not matching secret text.
Keep checker output private too.

## Local artifact checks

| Lab | Optional cross-check | Limit |
| --- | --- | --- |
| 3 | Independent test file and named statuses in dbt manifest/run results | A failed recorded status produces a warning. No freshness, current-SQL binding or authenticity guarantee. |
| 5 | Allow/deny policy and SQLSTATE fields in `.local/access-evidence.json` | Does not prove the report describes that run or establish security beyond tested operations. |
| 6 | Expected keys in `.local/audit-report.json` | Does not validate the memo or establish real incidents. |
| 7 | Selected supplied-fixture metrics and default worksheet placeholders | Does not assess fairness, the governance decision or all worksheet answers. |

Artifact files may be stale or from another run. Use the lab's execution commands
and result-verification steps as the authority. Missing local artifacts are warnings,
not instructions to rerun setup. To check only report text, use:

```bash
.venv/bin/python scripts/check_report.py 5 .local/lab5-report.md --no-local-cross-check
```

## Optional output formats

```bash
.venv/bin/python scripts/check_report.py 5 .local/lab5-report.md --fix-guide
.venv/bin/python scripts/check_report.py 5 .local/lab5-report.md --json
.venv/bin/python scripts/check_report.py 5 .local/lab5-report.md --json-file .local/lab5-check.json
```

`--json-file` creates a new file and refuses to overwrite any existing file, including
a report or symlink target. Choose a new filename for a later check. File permissions
are requested as owner-only where the filesystem supports them. Exit codes: `0` for
no flags or advisory warnings, `1` for detected placeholder prompts, `2` for file or
usage errors. These codes are not grades. The checker does not modify report inputs.

## Maintenance and validation

The integrated checker was adapted from the supplied ZIP with SHA-256
`1a1085921285709f0df05d08bbe39264c15c10c9c9296dedb3bb3c5e1db66140`.
The original archive's validation and checksums describe that archive, not the
modified integration. The archive is ignored by Git. Run the integrated regression
suite from the repository root:

```bash
python3 -m unittest discover -s tests -p 'test_report_checker*.py' -v
```

The full repository CI discovers these tests too. When submission instructions
change, review `grading/specs.py` alongside the affected lab. Test alternate wording,
unfinished worksheets, malformed files, failed artifacts and output preservation;
never interpret a keyword match as instructor approval. This optional aid still
needs learner usability feedback and adds no assessed learning outcomes.

Author: [Isaac K. Nti](../AUTHORS.md). [Citation and reuse terms](../CITATION.md).
