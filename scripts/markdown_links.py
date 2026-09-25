# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
"""Check local inline Markdown links and GitHub-style heading fragments.

Supports the repository's ATX/Setext headings, duplicate headings and explicit
HTML anchors. Fenced code examples are excluded. Does not fetch external URLs
or claim to implement a complete Markdown renderer.
"""
import html
from pathlib import Path
import re
from urllib.parse import unquote, urlsplit


def prose(text):
    """Exclude fenced examples so example headings/links are not real targets."""
    result = []
    fence = None
    for line in text.splitlines():
        mark = re.match(r"^ {0,3}(`{3,}|~{3,})(.*)$", line)
        if fence:
            if mark and mark[1][0] == fence[0] and len(mark[1]) >= fence[1] and not mark[2].strip():
                fence = None
            result.append("")
        elif mark:
            fence = (mark[1][0], len(mark[1]))
            result.append("")
        else:
            result.append(line)
    return "\n".join(result)


def heading_anchors(text):
    text = prose(text)
    generated = set()
    lines = text.splitlines()
    for index, line in enumerate(lines):
        match = re.match(r"^ {0,3}#{1,6}\s+(.+?)\s*$", line)
        if match:
            title = re.sub(r"\s+#+\s*$", "", match[1])
        elif index and re.fullmatch(r" {0,3}(?:=+|-+)\s*", line) and lines[index - 1].strip():
            title = lines[index - 1].strip()
        else:
            continue
        title = re.sub(r"!?\[([^]]+)\]\([^)]*\)", r"\1", title)
        title = re.sub(r"<[^>]+>", "", title)
        title = re.sub(r"(?<!\w)_{1,2}(.+?)_{1,2}(?!\w)", r"\1", title)
        title = html.unescape(title).replace("`", "").replace("*", "").replace("~", "")
        base = re.sub(r"[^\w\s-]", "", title.lower())
        base = re.sub(r"\s", "-", base)
        slug, number = base, 0
        while slug in generated:
            number += 1
            slug = f"{base}-{number}"
        generated.add(slug)
    explicit = re.findall(r'<(?:a|h[1-6])\b[^>]*\b(?:id|name)=["\']([^"\']+)["\']', text, re.I)
    return generated | set(explicit)


def local_link_errors(path):
    """Return actionable failures for local file targets and Markdown anchors."""
    errors = []
    for target in re.findall(r"\]\(([^)]+)\)", prose(path.read_text(encoding="utf-8"))):
        target = target.strip()
        if target.startswith("<") and target.endswith(">"):
            target = target[1:-1]
        parsed = urlsplit(target)
        if parsed.scheme or parsed.netloc:
            continue
        destination = path.parent / unquote(parsed.path) if parsed.path else path
        if not destination.exists():
            errors.append(f"{path}: missing local target: {target}")
        elif parsed.fragment and destination.suffix.lower() == ".md":
            if unquote(parsed.fragment) not in heading_anchors(destination.read_text(encoding="utf-8")):
                errors.append(f"{path}: missing heading/anchor: {target}")
    return errors
