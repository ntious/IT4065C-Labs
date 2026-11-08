# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
"""Report public HTTP(S) links in tracked Markdown; never scan private work.

Inline links and autolinks outside fences are supported, not all Markdown syntax.
Fragments are not validated remotely. Authentication/rate limiting needs review.
"""
from concurrent.futures import ThreadPoolExecutor
from pathlib import Path
import re
import subprocess
import time
from urllib.error import HTTPError, URLError
from urllib.parse import urldefrag, urlsplit
from urllib.request import Request, urlopen

from scripts.markdown_links import prose

ROOT = Path(__file__).resolve().parents[1]
REVIEW_CODES = {401, 403, 429}


def public_markdown(name):
    path = Path(name)
    return (path.suffix.lower() == '.md'
            and not any(part.startswith('.') for part in path.parts)
            and (len(path.parts) == 1 or path.parts[0] in {
                'docs', 'labs', 'capstone_project', 'scripts', 'data',
                'dbt', 'notebooks', 'sample_screenshots'})
            or name in {'submissions/README.md', 'submissions/template.md'})


def links(text):
    """Omit credential/query URLs so monitoring does not send private parameters."""
    text = prose(text)
    candidates = re.findall(r'\]\(<?(https?://[^\s)>]+)', text)
    candidates += re.findall(r'<(https?://[^\s<>]+)>', text)
    result = set()
    for url in candidates:
        url = urldefrag(url)[0]
        parsed = urlsplit(url)
        if parsed.hostname and not (parsed.username or parsed.password or parsed.query):
            result.add(url)
    return result


def check(url, opener=urlopen, sleep=time.sleep):
    """GET avoids HEAD-only failures; close without reading response bodies."""
    for attempt in range(3):
        try:
            request = Request(url, headers={'User-Agent': 'IT4065C-public-link-check/1.0'})
            with opener(request, timeout=12) as response:
                code = response.status
            if 200 <= code < 400:
                return 'ok', str(code)
        except HTTPError as error:
            code = error.code
            error.close()
        except (URLError, OSError, TimeoutError):
            code = None
        if code is not None and code < 500 and code != 429:
            break
        if attempt < 2:
            sleep(attempt + 1)
    if code in REVIEW_CODES:
        return 'review', str(code)
    return 'problem', str(code) if code is not None else 'network/timeout'


def main():
    names = subprocess.check_output(['git', 'ls-files', '-z'], cwd=ROOT).decode().split('\0')
    sources = {}
    for name in names:
        if public_markdown(name):
            for url in links((ROOT / name).read_text(encoding='utf-8')):
                sources.setdefault(url, set()).add(name)
    ordered = sorted(sources)
    with ThreadPoolExecutor(max_workers=4) as pool:
        results = list(pool.map(check, ordered))
    print('# Public external-link report\n')
    print('Tracked public Markdown only; inline links/autolinks outside fences. '
          'Query/credential URLs and remote fragments are not checked. '
          'No private records or response bodies are included.\n')
    counts = {kind: sum(result[0] == kind for result in results)
              for kind in ('ok', 'review', 'problem')}
    print(f'Checked {len(ordered)} unique URLs: {counts["ok"]} reachable, '
          f'{counts["review"]} need access/rate-limit review, {counts["problem"]} potential problems.\n')
    for url, (kind, detail) in zip(ordered, results):
        if kind != 'ok':
            # Escape Markdown delimiters; all sources come from tracked public files.
            safe = url.replace('<', '%3C').replace('>', '%3E').replace('|', '%7C')
            print(f'- {kind}: <{safe}> ({detail}); sources: '
                  + ', '.join(sorted(sources[url])))
    print('\nReview findings before editing links. Authentication, bot protection and '
          'temporary network failures do not establish a dead resource.')
    # Report-only: third-party uptime must not block teaching changes.
    return 0


if __name__ == '__main__':
    raise SystemExit(main())
