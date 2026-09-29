# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
"""Check website publication boundaries and preservation of lab commands."""
import unittest
from scripts.build_site import allowed, page_name, rewrite


class SiteBuilderTests(unittest.TestCase):
    def test_private_and_runtime_files_excluded(self):
        for name in ('.env', '.local/report.md', '.site-build/source/index.md',
                     'dbt/project/target/manifest.json', 'private/report.md', 'submissions/report.md',
                     'dbt/project/student_tests/report.md',
                     'submissions/.private/report.md', 'data/export.csv'):
            self.assertFalse(allowed(name), name)

    def test_public_guides_and_mapping(self):
        self.assertTrue(allowed('labs/core/lab01-environment/README.md'))
        self.assertEqual(page_name('README.md'), 'repository.md')
        self.assertEqual(page_name('labs/README.md'), 'labs/index.md')

    def test_links_rewrite_without_changing_fenced_commands(self):
        pages = {'README.md': 'repository.md', 'labs/README.md': 'labs/index.md'}
        text = '[Labs](labs/README.md#core)\n```bash\n[example](labs/README.md)\n```\n'
        result = rewrite(text, 'README.md', pages, set())
        self.assertIn('[Labs](labs/index.md#core)', result)
        self.assertIn('```bash\n[example](labs/README.md)\n```', result)

    def test_source_files_open_on_github(self):
        result = rewrite('[SQL](scripts/query.py)', 'README.md', {'README.md': 'repository.md'}, set())
        self.assertIn('https://github.com/ntious/IT4065C-Labs/blob/main/scripts/query.py', result)

    def test_external_and_same_page_links_preserved(self):
        text = '[Web](https://example.com/) [Here](#topic)'
        self.assertEqual(rewrite(text, 'README.md', {'README.md': 'repository.md'}, set()), text)
