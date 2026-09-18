# Lab 1: Environment and trust boundaries

A client sends a query; PostgreSQL authenticates the login and checks its privileges.
The Ubuntu account controls files and can use sudo when permitted. Database accounts
have separate passwords and privileges. A successful sudo command says nothing about
a database login’s authorization.

Setup is the one administrative phase. The builder subsequently owns only the
course database objects and cannot create databases or roles. Analyst and steward
are separate logins so permission checks include authentication. Never submit .env.
The environment file is configuration data, not a shell script.

**Check your understanding:** Why can `dbt debug` pass while a later model fails?
Connectivity, SQL correctness and data quality are separate checks. Identify one
failure in each category and the evidence you would seek before changing anything.

**Transfer:** Explain how the design would change on a shared remote server:
verified transport, centrally managed credentials, scoped provisioning and access
reviews would need a separate deployment design. This local lab does not configure them.

[Run Lab 1](../../labs/module1_preflight/README.md) · [Hands-on practice](../../labs/practice/README.md)

---

Author: [Isaac K. Nti](../../AUTHORS.md). [Citation and reuse terms](../../CITATION.md).
