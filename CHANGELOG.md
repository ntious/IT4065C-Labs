# Changes

## Reproducible local edition (development)

- One private literal .env and one runner; unique generated credentials.
- Dedicated non-superuser builder and separate reader logins; no shared passwords.
- Fixed duplicate SQL, model selectors, schema drift, relationship tests and sales grain.
- Deterministic synthetic data; safe reruns with no automatic destructive reseed.
- Real permission assertions and clearly labeled client/simulated audit evidence.
- Added AI governance, retention and snapshot experiments with explicit limitations.
- Canonical Markdown replaces obsolete PDF screenshots/instructions and workbook metadata.
- Public outcome/evidence map, instructor runbook, submission templates and checks.

Migration: use a fresh database and new usernames through .env, preserving old
student work. Do not run the new bootstrap against a previous unmarked database.
Old published credentials must still be rotated/revoked by their owner where
applicable. This change cannot remove old clones or Git history.
