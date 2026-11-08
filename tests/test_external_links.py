# Copyright (c) 2026 Isaac K. Nti. SPDX-License-Identifier: MIT
import unittest
from unittest.mock import MagicMock
from urllib.error import HTTPError, URLError

from scripts.check_external_links import check, links, public_markdown


class ExternalLinkTests(unittest.TestCase):
    def test_private_and_generated_paths_excluded(self):
        for path in ('local-docs/review.md', '.local/pilot.md', '.site-build/page.md',
                     'submissions/completed.md', 'docs/.private/record.md'):
            self.assertFalse(public_markdown(path), path)
        self.assertTrue(public_markdown('docs/setup.md'))
        self.assertTrue(public_markdown('submissions/template.md'))

    def test_fences_fragments_credentials_and_queries(self):
        text = ('[one](https://example.com/a#part) <https://example.com/b>\n'
                '```\n[x](https://example.com/ignored)\n```\n'
                '[private](https://user:password@example.com/) '
                '[query](https://example.com/?token=private)')
        self.assertEqual(links(text), {'https://example.com/a', 'https://example.com/b'})

    def test_get_success_closes_response_without_reading(self):
        response = MagicMock(status=200)
        context = MagicMock()
        context.__enter__.return_value = response
        opener = MagicMock(return_value=context)
        self.assertEqual(check('https://example.com/', opener), ('ok', '200'))
        self.assertEqual(opener.call_args.args[0].get_method(), 'GET')
        context.__exit__.assert_called_once()
        response.read.assert_not_called()

    def test_missing_is_reported_without_retry(self):
        opener = MagicMock(side_effect=HTTPError('https://example.com/', 404, '', {}, None))
        self.assertEqual(check('https://example.com/', opener), ('problem', '404'))
        self.assertEqual(opener.call_count, 1)

    def test_access_denial_is_review_not_dead_link(self):
        for code in (401, 403, 429):
            opener = MagicMock(side_effect=HTTPError('https://example.com/', code, '', {}, None))
            self.assertEqual(check('https://example.com/', opener, lambda _: None), ('review', str(code)))

    def test_transient_failure_recovers_and_persistent_failure_is_bounded(self):
        context = MagicMock()
        context.__enter__.return_value.status = 200
        opener = MagicMock(side_effect=[URLError('temporary'), context])
        self.assertEqual(check('https://example.com/', opener, lambda _: None), ('ok', '200'))
        opener = MagicMock(side_effect=URLError('persistent'))
        self.assertEqual(check('https://example.com/', opener, lambda _: None), ('problem', 'network/timeout'))
        self.assertEqual(opener.call_count, 3)


if __name__ == '__main__':
    unittest.main()
