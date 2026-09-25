# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
"""Regression cases for student navigation and heading changes."""
from pathlib import Path
import tempfile
import unittest

from scripts.markdown_links import heading_anchors, local_link_errors


class MarkdownLinkTests(unittest.TestCase):
    def test_duplicate_formatted_and_unicode_headings(self):
        text = "# **Résumé**: `order_id`\n# Repeat\n# Repeat\n# Repeat-1\n# Repeat\n"
        self.assertEqual(heading_anchors(text),
                         {"résumé-order_id", "repeat", "repeat-1", "repeat-1-1", "repeat-2"})

    def test_fences_setext_and_explicit_anchors(self):
        text = '# Real\n```md\n# Fake\n```\n~~~\n# Also fake\n~~~\nTitle\n=====\n<a id="manual"></a>\n'
        self.assertEqual(heading_anchors(text), {"real", "title", "manual"})

    def test_heading_rename_breaks_link_and_repair_passes(self):
        with tempfile.TemporaryDirectory() as folder:
            root = Path(folder)
            guide = root / "guide.md"
            destination = root / "lab.md"
            guide.write_text('[Next](lab.md#next-step)\n', encoding="utf-8")
            destination.write_text('# Next step\n', encoding="utf-8")
            self.assertEqual(local_link_errors(guide), [])
            destination.write_text('# Changed heading\n', encoding="utf-8")
            self.assertIn('missing heading/anchor', local_link_errors(guide)[0])
            guide.write_text('[Next](lab.md#changed-heading)\n', encoding="utf-8")
            self.assertEqual(local_link_errors(guide), [])

    def test_missing_file_same_page_encoded_and_external_links(self):
        with tempfile.TemporaryDirectory() as folder:
            guide = Path(folder) / "guide.md"
            guide.write_text('# Résumé\n[Here](#r%C3%A9sum%C3%A9)\n'
                             '[Remote](https://example.org/#unverified)\n'
                             '```md\n[Example](missing.md)\n```\n', encoding="utf-8")
            self.assertEqual(local_link_errors(guide), [])
            guide.write_text('[Missing](missing.md#section)\n', encoding="utf-8")
            self.assertIn('missing local target', local_link_errors(guide)[0])
