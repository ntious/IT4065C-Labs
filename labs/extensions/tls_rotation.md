# Optional Lab 14: Verified TLS and credential rotation

**Connection:** SLO 5; Module 5. **Time:** 60–90 minutes.
Complete Lab 5 and [optional setup](infrastructure_setup.md), including openssl.

## Predict and run

Predict which connections should fail: trusted CA and correct hostname; unrelated
CA; incorrect hostname; plaintext; old password after rotation.

```bash
.venv/bin/python scripts/infrastructure_labs.py tls
```

Expected: PASS and stopped server. Evidence must show verified TLS, rejection of
wrong CA, wrong hostname and plaintext, rejection of the old password, and successful
access with the new password. A failure for an unrelated reason does not count as
a successful negative test.

## Guided investigation

Read `tls()` in the runner. It creates a local teaching CA and short-lived localhost
certificate, restricts TCP access to TLS, and uses verify-full to check both trust
and hostname. The wrong-hostname test keeps the same loopback address so a DNS error
cannot masquerade as identity verification. Password rotation is tested using new
connections. Existing sessions are not terminated by changing a password.

## Supported practice and independent transfer

Create a prediction/result table for each connection condition. Explain the separate
roles of CA trust, server identity and database authentication. Then design a rotation
plan for a fictional reporting service: preparation, change, client update, verification,
rollback decision and treatment of existing sessions. Never put credentials in it.

## Reflect and submit privately

Submit a short redacted evidence summary and the plan. Explain why successful TLS
does not establish storage or backup encryption. Add a proposed storage-encryption
control, key custodian and verification method; label it proposed, not demonstrated.
The teaching CA is not a production trust anchor. Its keys stay in the private run
directory and are never uploaded. Follow [cleanup](infrastructure_setup.md).

Rubric: evidence 30%; trust/authentication reasoning 30%; rotation plan 25%; limits 15%.
References: [libpq certificate verification](https://www.postgresql.org/docs/16/libpq-ssl.html)
and [server TLS](https://www.postgresql.org/docs/16/ssl-tcp.html).

---

Author: [Isaac K. Nti](../../AUTHORS.md). [Citation](../../CITATION.md).
