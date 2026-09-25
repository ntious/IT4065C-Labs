# Optional Lab 14: Verified TLS and credential rotation

> **Completion:** Passing automated checks, where present, confirms technical behavior.
> Complete the independent task, explanation and evidence specified on this page.

**Connection:** SLO 5; Module 5. **Time:** 60–90 minutes.
Complete [Lab 5](../../core/lab05-access-control/README.md) and [optional setup](../infrastructure_setup.md), including openssl.

## Why this lab matters

Transport trust and database credentials address different risks. You will check the intended rejection cases and plan a credential change without exposing secrets.

## Learning objectives

These instructor-developed objectives support the outcomes above. You will:

- Distinguish CA trust, hostname verification and password authentication.
- Interpret successful negative tests and new-connection rotation evidence.
- Specify a rotation plan and separate storage-encryption proposal.

## Skills you will practice

Compare connection conditions, read boolean assertions and document operational ownership.

## Terms you need for this lab

| Term | Meaning here |
| --- | --- |
| TLS / CA | Encryption in transit / the certificate authority used to establish certificate trust. |
| Server identity / database authorization | Certificate trust and a matching server name help verify the server; database privileges still determine allowed queries. |
| Rotation | Replace a password, check the new one works and the old one fails for new connections. Existing sessions are a separate concern. |

Use the [glossary](../../../docs/glossary.md#infrastructure-and-recovery) for more detail; this is reference support, not another assignment.

## Part A: Run and inspect the supplied experiment

Predict which connections should fail: trusted CA and correct hostname; unrelated
CA; incorrect hostname; plaintext; old password after rotation.

```bash
.venv/bin/python scripts/infrastructure_labs.py tls
```

Expected: PASS and stopped server. Evidence must show verified TLS, rejection of
wrong CA, wrong hostname and plaintext, rejection of the old password, and successful
access with the new password. A failure for an unrelated reason does not count as
a successful negative test.

### Open your evidence

Run from the repository root in Ubuntu. On success the runner prints:

```text
Private run directory: .local/infrastructure/tls-<unique suffix>
PASS: optional tls assertions verified; teaching instances stopped. Read evidence.json and complete the reflection.
Read your results with:
.venv/bin/python -m json.tool .local/infrastructure/tls-<unique suffix>/evidence.json
```

**Copy the complete evidence command from your own terminal**, where the actual
suffix is already filled in, and run it. The angle-bracket text above explains
where a generated value appears; do not paste it as a command. Each run gets a
new directory. Read the file from the run that just passed, not a previous run.
This command displays JSON without changing it; the experiment's servers have stopped.

| Field | Expected | What was checked |
| --- | --- | --- |
| `verified_tls` | `true` | Trusted CA and matching server hostname connected |
| `wrong_ca_rejected` | `true` | Unrelated CA trust failed |
| `wrong_hostname_rejected` | `true` | Wrong hostname failed against the same server address |
| `plaintext_rejected` | `true` | Non-TLS connection failed |
| `old_password_rejected` | `true` | Old password failed on a new connection after rotation |
| `new_password_accepted` | `true` | New password successfully accessed the fixture |

All six values should be `true`: a `rejected` value of `true` means the unsafe
connection was blocked as intended. Do not weaken trust or authentication to make
it connect. No password or key belongs in your prediction/result table.

### Read the implementation

Read `tls()` in the runner. It creates a local teaching CA and short-lived localhost
certificate, restricts TCP access to TLS, and uses verify-full to check both trust
and hostname. The wrong-hostname test keeps the same loopback address so a DNS error
cannot masquerade as identity verification. Password rotation is tested using new
connections. Existing sessions are not terminated by changing a password.

## Part B: Explain and propose a different design

Write these responses in your private submission. No runner edits, extra accounts
or live infrastructure changes are required. Text diagrams/tables are sufficient.

Create a prediction/result table for each connection condition. Explain the separate
roles of CA trust, server identity and database authentication. Then design a rotation
plan for a fictional reporting service: preparation, change, client update, verification,
rollback decision and treatment of existing sessions. Never put credentials in it.

## Submit privately

Submit a short redacted evidence summary and the plan. Explain why successful TLS
does not establish storage or backup encryption. Add a proposed storage-encryption
control, key custodian and verification method; label it proposed, not demonstrated.
The teaching CA is not a production trust anchor. Its keys stay in the private run
directory and are never uploaded. Follow [cleanup](../infrastructure_setup.md).

Rubric: evidence 30%; trust/authentication reasoning 30%; rotation plan 25%; limits 15%.
References: [libpq certificate verification](https://www.postgresql.org/docs/16/libpq-ssl.html)
and [server TLS](https://www.postgresql.org/docs/16/ssl-tcp.html).

---

Author: [Isaac K. Nti](../../../AUTHORS.md). [Citation](../../../CITATION.md).
