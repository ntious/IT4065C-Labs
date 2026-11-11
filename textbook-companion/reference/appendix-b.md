# Appendix B
# Linux and Command-Line Essentials

The course uses an Ubuntu shell, either directly, in a virtual machine, or through Windows Subsystem for Linux (WSL). This appendix supports environment work in Chapters 1 and 5 and evidence handling in Chapters 13 and 15. Commands shown here are Bash commands. A shell prompt such as `$` is not part of a command.

## B.1 Locate yourself before changing anything

| Command | Meaning | Reading habit |
| --- | --- | --- |
| `pwd` | Print the current directory. | Confirm the project before running a script. |
| `ls -la` | List entries, including dotfiles. | A listed file is not necessarily safe to publish. |
| `cd "folder name"` | Change directory. | Quote paths containing spaces. |
| `cd ..` | Move to the parent directory. | Relative paths depend on the current directory. |
| `whoami` | Show the effective operating-system user. | This does not identify the connected database role. |
| `command -v python3` | Locate the selected command. | Different interpreters may have different packages. |

An absolute Linux path begins with `/`. A relative path is resolved from the current directory. `~` denotes your home directory when the shell expands it. Linux filenames are generally case-sensitive. Keep the course checkout in the Ubuntu home filesystem as directed in Appendix E; do not assume Windows file permissions behave like native Linux permissions.

Single quotes preserve literal characters; double quotes allow expansions such as variables while keeping the expanded value together. Quote paths and variable expansions unless word splitting is intentional. Do not copy the typographic quotation marks used in ordinary prose into commands.

## B.2 A small practice session

The following exercise creates a new temporary directory. Run the commands in one Bash session:

```bash
practice_dir=$(mktemp -d)
cd "$practice_dir"
printf 'order_id,status\n1,completed\n2,cancelled\n' > sample.csv
head -n 3 sample.csv
wc -l sample.csv
sha256sum sample.csv
```

Expected observations: the header and two records are printed; the line count is 3, including the header; and a SHA-256 digest is reported. A line count is not always a CSV record count because quoted CSV fields may contain newlines. A digest supports comparison with a trusted earlier digest; by itself it proves neither authorship nor truth. The practice directory remains available for inspection.

## B.3 Read output and failures

| Operator or command | Effect | Caution |
| --- | --- | --- |
| `>` | Redirect standard output, replacing the destination. | Check the filename before overwriting. |
| `>>` | Append standard output. | Appending several runs can obscure their boundaries. |
| `2>` | Redirect standard error. | Error output may contain sensitive configuration. |
| `|` | Send standard output to the next command. | A successful last command need not mean earlier commands succeeded. |
| `echo "$?"` | Show the immediately preceding command's exit status. | Another command replaces that status. |
| Ctrl+C | Request interruption of the foreground process. | Verify what completed before interruption. |

For evidence, preserve the command, start and end times, exit status, relevant output, and interpretation. Record UTC or an explicit timezone. A zero exit status is a program's success signal, not proof that a business requirement has been satisfied. Avoid sharing complete logs without reviewing their contents.

## B.4 Permissions and private files

Linux permissions distinguish owner, group, and other users; read, write, and execute have different meanings for files and directories. On a directory, execute permits traversal. Do not solve a permission problem by granting everyone full access. First check ownership, the required operation, and the intended user.

`chmod 600 private-file` gives its owner read/write permission and removes ordinary group/other permissions on a regular file. It is not encryption, does not constrain a sufficiently privileged administrator, and may behave differently on mounted Windows filesystems. Restrictive permissions complement appropriate storage and sharing decisions.

The course `.env` is private configuration. Do not display it in screenshots, commit it, or run `source .env`. The course parser expects literal `KEY=value` entries, not a shell program. Put passwords only in the supported private configuration workflow; command-line arguments and shell history are poor places for secrets.

## B.5 Diagnose before escalating

Start with `command --help` or `man command`, when available. Check the current directory, interpreter path, filename case, and exit status before using administrator privileges. `sudo` changes operating-system authority; it does not automatically establish the intended database identity. Use the repository's supported service and setup commands rather than improvising permissions or deleting unfamiliar files.

For a failed course operation, record the command and a redacted error excerpt, then consult Appendix E. Keep destructive recovery, bulk deletion, and system-wide package changes outside ordinary troubleshooting unless the affected scope is understood and authorized.

## B.6 Companion runs and private evidence

The repository-root `textbook-companion/` contains optional book examples. Read its `SETUP.md` before execution. Shell commands for the launcher run from the repository root, using the configured interpreter; they are not SQL commands. The companion's default output is a new private directory under `.local/textbook-companion/`, separate from the public `textbook-companion/evidence/` reference extracts.

Keep each run's summary, relevant output and interpretation together. A custom output directory must not already exist. Record an interruption or failure before retrying; do not overwrite the earlier evidence or publish a complete unreviewed transcript. Normal completion and handled failures stop the created servers; after forced termination, establish which processes and temporary files belong to that run before cleanup.

## B.7 Sources and further reading

Free Software Foundation. (n.d.). Bash reference manual. https://www.gnu.org/software/bash/manual/ . See quoting, redirections, pipelines, and exit status.

Free Software Foundation. (n.d.). GNU Coreutils manual. https://www.gnu.org/software/coreutils/manual/ . See file permissions, mktemp, wc, and sha256sum.

Microsoft. (n.d.). Working across Windows and Linux file systems. https://learn.microsoft.com/en-us/windows/wsl/filesystems

Nti, I. K. (2026). IT4065C-Labs: Data Technologies Administration [Software and instructional materials]. https://doi.org/10.5281/zenodo.24046602 . Repository: https://github.com/ntious/IT4065C-Labs . Checked against commit d860dd98256a8090ffc6bd3766c59cb15a553c12.
