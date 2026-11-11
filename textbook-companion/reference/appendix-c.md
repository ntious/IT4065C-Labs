# Appendix C
# Git and GitHub Essentials

Git records versions of files; GitHub hosts repositories and supports collaboration around them. A local commit does not publish anything to GitHub. This appendix supports the reproducibility, change control, and portfolio practices in Chapters 2, 15, 16, and 18.

## C.1 Three places to distinguish

| Place | Meaning | Useful inspection |
| --- | --- | --- |
| Working tree | Files currently available for editing. | `git status --short` |
| Staging area | Content selected for the next commit. | `git diff --cached` |
| Commit history | Recorded snapshots and their relationships. | `git log --oneline -5` |

`git diff` shows unstaged changes to tracked files. It does not show the contents of untracked files. `git add path/to/file` stages that file's current content; later edits require staging again. A commit records the staged content, not every visible change in the folder. Inspect both status and the staged difference before committing.

## C.2 An isolated local exercise

This Bash exercise creates a new temporary repository and makes one local commit. It does not change the course checkout or connect to a remote service. The example identity is deliberately fictional and is configured only for this practice repository.

```bash
practice_repo=$(mktemp -d)
git init -b main "$practice_repo"
cd "$practice_repo"
git config user.name "Practice Author"
git config user.email "practice@example.invalid"
printf '# Evidence practice\n\nScope: local example only.\n' > README.md
git status --short
git add README.md
git diff --cached
git commit -m "Record practice scope"
git log --oneline -1
```

Before staging, status should show an untracked `README.md`; the staged difference should contain the heading and scope statement. After committing, the log should show one commit with the supplied message. The identifier and timestamp will vary. For real work, use your approved identity and follow the project's contribution rules.

## C.3 Make a reviewable change

Create a branch in the practice repository and amend the document:

```bash
git switch -c clarify-scope
printf '\nLimitation: no production behavior tested.\n' >> README.md
git diff
git add README.md
git diff --cached
git commit -m "State the evidence limitation"
```

A branch gives this work a named line of development. Small commits with clear purpose make review easier. On GitHub, a pull request proposes changes between branches and provides a place for discussion and checks. Opening a pull request, passing an automated check, and receiving authorized approval are distinct events; follow the repository's actual merge policy.

To unstage an already tracked file after a commit exists, use `git restore --staged README.md`. This leaves its working-tree content intact. In contrast, `git restore README.md` can discard unstaged edits. Review the command's scope before running it; do not treat all “undo” commands as equivalent.

## C.4 Protect evidence and secrets

An ignore rule helps keep matching untracked files out of routine staging. It does not remove a file already tracked or erase earlier commits. Review the actual staged content. Prefer explicitly named files over indiscriminate staging when private logs, credentials, or student information are nearby.

If a credential has been committed or published, removing it from the latest file is insufficient. Follow the project's incident process, revoke or rotate the credential, assess exposure, and coordinate any history cleanup. Do not place real secrets in an exercise to demonstrate this behavior.

Evidence logs and raw outputs may belong in private evidence storage rather than the public teaching repository. Preserve raw evidence separately from sanitized publication extracts. A Git commit records content history; it does not prove that a test ran or that a recorded assertion is true.

## C.5 Record a reproducible baseline

From the course repository root, these read-only commands identify the checked-out revision and visible changes:

```bash
git rev-parse HEAD
git status --short
git diff --stat
```

Record the full commit identifier, relevant modifications, dependency versions, dataset checksums, and execution conditions. A clean tracked working tree does not describe ignored configuration or external database state. For this book's repository baseline, the full identifier is `d860dd98256a8090ffc6bd3766c59cb15a553c12`. Treat later revisions as different evidence contexts.

The course baseline predates the addition of `textbook-companion/`. Record the course-derived fixture baseline separately from the revision containing the companion. Before a companion commit is available, record its `release-manifest.json` and relevant file hashes, together with the uncommitted state. After publication, record the actual companion-containing revision and any local changes. Do not attribute the new folder to the earlier course commit or treat a manifest checksum as proof of execution.

Use the repository DOI for citation and the GitHub address for direct access. The all-versions DOI resolves to the latest release; it does not replace the full commit identifier when reproducing a particular run.

## C.6 Sources and further reading

Git project. (n.d.). Git documentation: add; diff; restore; gitignore. https://git-scm.com/docs/git-add ; https://git-scm.com/docs/git-diff ; https://git-scm.com/docs/git-restore ; https://git-scm.com/docs/gitignore

GitHub. (n.d.). About pull requests. https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/about-pull-requests

Nti, I. K. (2026). IT4065C-Labs: Data Technologies Administration [Software and instructional materials]. https://doi.org/10.5281/zenodo.24046602 . Direct repository: https://github.com/ntious/IT4065C-Labs
