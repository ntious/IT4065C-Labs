SELECT
  COUNT(*)                                          AS customer_rows,
  COUNT(DISTINCT customer_id)                       AS distinct_ids,
  COUNT(DISTINCT lower(trim(email)))                AS distinct_normalized_emails,
  ROUND(100.0 * COUNT(postal_code) / NULLIF(COUNT(*), 0), 1) AS pct_postal_present,
  ROUND(100.0 * COUNT(birth_year)  / NULLIF(COUNT(*), 0), 1) AS pct_birth_year_present,
  COUNT(*) FILTER (WHERE last_verified <  DATE '2026-11-01' - INTERVAL '24 months')
                                                    AS stale_over_24_months,
  COUNT(*) FILTER (WHERE last_verified >= DATE '2026-11-01' - INTERVAL '24 months')
                                                    AS verified_within_24_months,
  COUNT(*) FILTER (WHERE last_verified IS NULL)     AS verification_unknown
FROM crm.customers;
