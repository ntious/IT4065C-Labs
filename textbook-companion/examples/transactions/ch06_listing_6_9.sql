WITH s AS (
  SELECT snapshot_date, units_on_hand
  FROM mart.fct_inventory_snapshot
  WHERE product_id = 3
    AND snapshot_date BETWEEN :'period_start'::date AND :'period_end'::date
)
SELECT
  (SELECT units_on_hand FROM s
    WHERE snapshot_date = :'period_end'::date)          AS closing_balance,
  (SELECT max(snapshot_date) FROM s)                    AS last_observed_date,
  (SELECT units_on_hand FROM s
    ORDER BY snapshot_date DESC LIMIT 1)                AS last_observed_balance,
  COUNT(*)                                              AS days_observed,
  :'period_end'::date - :'period_start'::date + 1       AS days_in_period,
  ROUND(AVG(units_on_hand), 1)                          AS avg_of_observed_days
FROM s;
