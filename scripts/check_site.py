# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
"""Verify generated local HTML links, images and heading anchors before upload."""
from html.parser import HTMLParser
from functools import lru_cache
from pathlib import Path
from urllib.parse import urlsplit, unquote

ROOT = Path(__file__).resolve().parents[1] / '.site-build/output'
PREFIX = '/IT4065C-Labs/'


class Page(HTMLParser):
    def __init__(self, text):
        super().__init__()
        self.ids, self.links = set(), []
        self.feed(text)

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if 'id' in attrs:
            self.ids.add(attrs['id'])
        key = 'href' if tag in {'a', 'link'} else 'src'
        if attrs.get(key):
            self.links.append(attrs[key])


@lru_cache(maxsize=None)
def destination(path):
    return (path / "index.html" if path.is_dir() else path).resolve()


def main():
    pages = {p.resolve(): Page(p.read_text(encoding='utf-8')) for p in ROOT.rglob('*.html')}
    if not pages or (ROOT / 'index.html').resolve() not in pages:
        raise SystemExit('Missing built website; run the staging and MkDocs build commands first.')
    existing = {p.resolve() for p in ROOT.rglob('*') if p.is_file()}
    errors = []
    for path, page in pages.items():
        for link in page.links:
            url = urlsplit(link)
            if url.scheme or url.netloc:
                continue
            name = unquote(url.path)
            if name.startswith(PREFIX):
                dest = ROOT / name[len(PREFIX):]
            elif name.startswith('/'):
                errors.append(f'{path.relative_to(ROOT)}: unexpected root link {link}')
                continue
            else:
                dest = path.parent / name if name else path
            dest = destination(dest)
            if not dest.is_relative_to(ROOT.resolve()) or dest not in existing:
                errors.append(f'{path.relative_to(ROOT)}: missing {link}')
            elif url.fragment and dest in pages and unquote(url.fragment) not in pages[dest].ids:
                errors.append(f'{path.relative_to(ROOT)}: missing anchor {link}')
    if errors:
        raise SystemExit('\n'.join(errors))
    print(f'PASS: internal links, images and anchors across {len(pages)} generated HTML pages.')


if __name__ == '__main__':
    main()
