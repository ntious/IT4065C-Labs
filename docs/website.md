# Course website maintenance

The GitHub Pages website presents the existing teaching documents with search and
mobile navigation. Edit lab instructions in their original repository locations;
do not edit generated pages. The required course checklist remains the canonical
learning route. Website tooling is separate from the student lab environment.

## Preview a change

From the repository root, create an isolated website environment:

```bash
python3 -m venv .site-build/venv
.site-build/venv/bin/pip install -r requirements-site.txt
python3 scripts/build_site.py
.site-build/venv/bin/mkdocs serve --dev-addr 127.0.0.1:8000
```

Open `http://127.0.0.1:8000/IT4065C-Labs/` in your browser. Stop the preview with
Ctrl+C. When editing teaching Markdown, rerun the staging command to refresh its
website copy. New public documents must be staged in Git before the build can
include them. Never stage private learner work.

## Publication boundary

The staging script uses Git's tracked-file inventory and a restricted selection
of Markdown directories and reviewed instructional images. It does not copy
`.env`, `.local`, student tests, database exports, or runtime evidence. Links to
SQL and other source files open their GitHub source rather than executing them.
The homepage and stylesheet live in `website/`; navigation lives in `mkdocs.yml`.

The Pages workflow builds and checks pull requests. Only a successful build on
`main` deploys through the GitHub Pages environment. Repository Settings → Pages
must use **GitHub Actions** as its source. Lab CI remains separate and must also
pass before merging. A website build does not demonstrate successful lab execution.

To check the production build locally:

```bash
python3 scripts/build_site.py
.site-build/venv/bin/mkdocs build --strict
```

The generated output stays under ignored `.site-build/` directories. The website
publishes public instructional content; official semester administration and
student submissions remain in the institution's course systems.
