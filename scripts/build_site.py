# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
"""Stage public, tracked teaching documents for the course website.

Never copy the checkout wholesale: private work and generated lab evidence must
not be published. Run from any directory after staging new public files in Git.
"""
from pathlib import Path
import os
import re
import shutil
import subprocess
from urllib.parse import quote, unquote, urlsplit

ROOT = Path(__file__).resolve().parents[1]
DEST = ROOT / ".site-build/source"
REPO = "https://github.com/ntious/IT4065C-Labs/blob/main/"


def page_name(name):
    if name == "README.md":
        return "repository.md"
    p = Path(name)
    return str(p.with_name("index.md")) if p.name == "README.md" else name


def allowed(name):
    p = Path(name)
    if p.parts and p.parts[0] == "submissions" and name not in {"submissions/README.md", "submissions/template.md"}:
        return False
    if any(part in {"student_tests", "target", "logs", "dbt_packages"} for part in p.parts):
        return False
    return (not any(part.startswith(".") for part in p.parts)
            and p.suffix.lower() == ".md"
            and (len(p.parts) == 1 or p.parts[0] in {
                "docs", "labs", "capstone_project", "submissions", "scripts", "dbt", "data", "notebooks"}))


def rewrite(text, source, pages, assets):
    """Rewrite prose links only; leave runnable fenced examples intact."""
    def link(match):
        target = match[1]
        parsed = urlsplit(target.strip("<>"))
        if parsed.scheme or parsed.netloc or not parsed.path:
            return match[0]
        resolved = (ROOT / source).parent.joinpath(unquote(parsed.path)).resolve()
        try:
            name = resolved.relative_to(ROOT).as_posix()
        except ValueError:
            raise ValueError(f"Link outside repository: {source}: {target}")
        if name in pages or name in assets:
            dest = pages.get(name, name)
            url = Path(os.path.relpath(dest, Path(pages[source]).parent)).as_posix()
            url = quote(url, safe="/.-_")
        else:
            url = REPO + quote(name, safe="/.-_")
        if parsed.fragment:
            url += "#" + parsed.fragment
        return "](" + url + ")"
    output, fence = [], None
    for line in text.splitlines(keepends=True):
        mark = re.match(r"^ {0,3}(`{3,}|~{3,})(.*)$", line)
        if fence:
            if mark and mark[1][0] == fence[0] and len(mark[1]) >= fence[1] and not mark[2].strip():
                fence = None
            output.append(line)
        elif mark:
            fence = (mark[1][0], len(mark[1]))
            output.append(line)
        else:
            output.append(re.sub(r"\]\(([^)]+)\)", link, line))
    return "".join(output)


def main():
    tracked = subprocess.check_output(["git", "ls-files", "-z"], cwd=ROOT).decode().split("\0")
    pages = {name: page_name(name) for name in tracked if allowed(name)}
    assets = {name for name in tracked if name.startswith("sample_screenshots/")
              and Path(name).suffix.lower() in {".png", ".svg"}}
    if len(set(pages.values())) != len(pages):
        raise ValueError("Website page paths collide")
    if DEST.exists():
        shutil.rmtree(DEST)
    DEST.mkdir(parents=True)
    for name, dest in pages.items():
        target = DEST / dest
        target.parent.mkdir(parents=True, exist_ok=True)
        target.write_text(rewrite((ROOT / name).read_text(encoding="utf-8"), name, pages, assets), encoding="utf-8")
    for name in assets:
        target = DEST / name
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(ROOT / name, target)
    # These are reviewed website presentation files, not learner artifacts.
    for name in ("index.md", "stylesheets/course.css"):
        target = DEST / name
        target.parent.mkdir(parents=True, exist_ok=True)
        shutil.copyfile(ROOT / "website" / name, target)
    print(f"Staged {len(pages)} public documents and {len(assets)} instructional images.")


if __name__ == "__main__":
    main()
