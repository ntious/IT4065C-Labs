# Lab 5: Authentication, authorization and masking

Authentication establishes the login. Authorization determines which operations it
can perform. The lab opens separate connections for the analyst and steward; successful
builder queries are not proof that those reader identities have the same access.

The builder owns the raw data and controlled views. Readers receive schema usage and
SELECT on specified views, but no raw schema access or membership in the builder role.
The analyst sees sales aggregates; the steward can additionally use masked customer
fields. A 42501 response confirms an authorization denial. A wrong-password error or
missing-table error would not establish the intended access boundary.

The views use their owner’s access to expose a deliberately restricted projection.
Granting access to an owner-controlled view therefore requires reviewing its entire
query. Adding a raw column later could expose it to every existing reader of that view.
The owner is trusted; the design does not protect raw data from its own owner.

Masking is data minimization, not proof of anonymity. Domains, suffixes, identifiers
and joinable patterns can still reveal information. Unkeyed hashes of predictable
identifiers are not a safe substitute for an access policy.

**Check your understanding:** Predict all three commands in the practice guide before
running them. Explain both the role grant and the view projection behind each result.

[Run Lab 5](../../labs/module_5/lab5/README.md) · [Hands-on practice](../../labs/practice/README.md)

---

Author: [Isaac K. Nti](../../AUTHORS.md). [Citation and reuse terms](../../CITATION.md).
