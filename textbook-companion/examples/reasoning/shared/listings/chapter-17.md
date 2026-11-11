```sql
SELECT p.prediction_id, f.feature_version, f.return_state
FROM predictions p
LEFT JOIN LATERAL (
  SELECT h.feature_version, h.return_state
  FROM feature_history h
  WHERE h.purchase_id = p.purchase_id
    AND h.event_time <= p.predicted_at
    AND h.available_at <= p.predicted_at
  ORDER BY h.available_at DESC, h.feature_version DESC
  LIMIT 1
) f ON TRUE
ORDER BY p.prediction_id;
```
