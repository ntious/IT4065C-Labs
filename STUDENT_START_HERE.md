# Student start here

Follow this page once, then use the [core lab index](labs/README.md#core-labs).
The public course materials are instructor-developed; your current LMS supplies
dates, assigned activities, official weights and the private submission route.

1. Use an individual Ubuntu 22.04/24.04 VM or Ubuntu in WSL2. Windows users follow
   [the Windows/Ubuntu guide](docs/local_run.md). Work in the Ubuntu home directory.
   On a managed computer, request an instructor-managed individual Ubuntu VM with
   the same setup; do not bypass device restrictions. See [managed access](docs/setup.md#managed-computers).
2. Open the Ubuntu terminal and obtain the materials:

   ```bash
   git clone https://github.com/ntious/IT4065C-Labs.git
   cd IT4065C-Labs
   python3 scripts/preflight.py
   ```

   Resolve FAIL results using [setup](docs/setup.md); review WARN results before
   continuing. The preflight installs nothing and does not read passwords.
3. Run `bash scripts/setup.sh`. It asks for your Linux sudo password, creates private
   configuration and runs Lab 1. Allow time for downloads. Do not share `.env`.
4. Open [Lab 1](labs/module1_preflight/README.md), predict the result and rerun its
   technical check, then complete its investigation and written evidence. Setup's
   automatic check confirms installation; it does not complete the lab activity.
   Then complete Labs 2–7 in
   order. The lab page contains the task, expected result and submission checklist.
5. Submit privately through the LMS; independent learners retain their evidence
   locally. A PASS or COMPLETE message confirms technical checks, not assignment
   completion. Include your independent work and explanation.

On returning, open the same Ubuntu terminal, `cd IT4065C-Labs`, and run the next
lab's command. No environment activation or password export is needed.

If terminology is new, use the [foundations bridge](docs/foundations.md) and
[glossary](docs/glossary.md). For an error, use [troubleshooting](docs/troubleshooting.md).
Labs 8–15 are optional enrichment. Folder names preserve older links; they do not
define the syllabus module order. Lab 7 is core even though its path says `extensions`.

Author: [Isaac K. Nti](AUTHORS.md).
