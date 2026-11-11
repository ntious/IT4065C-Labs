```sql
SELECT e.event_id,
       CASE
         WHEN e.principal IS NULL THEN 'identity unresolved'
         WHEN NOT EXISTS (
           SELECT 1 FROM approvals a
           WHERE a.principal = e.principal
             AND e.occurred_at >= a.valid_from
             AND e.occurred_at < a.valid_to
         ) THEN 'no matching recorded approval'
         ELSE 'matched'
       END AS assessment
FROM access_events e
WHERE e.outcome = 'success'
ORDER BY e.event_id;
```
