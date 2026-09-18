-- Each rule has a separate row so one incident cannot hide another.
SELECT 'REPEATED_DENIAL' AS flag,actor_user,count(*) AS events
 FROM {{schema}}.audit_access_events WHERE action='DENIED'
 GROUP BY actor_user HAVING count(*) >= 3
UNION ALL
SELECT 'ROLE_SWITCH',actor_user,count(*) FROM {{schema}}.audit_access_events
 WHERE action='ROLE_SWITCH' GROUP BY actor_user
UNION ALL
SELECT 'AFTER_HOURS_EXPORT',actor_user,count(*) FROM {{schema}}.audit_access_events
 WHERE action='EXPORT' AND (extract(hour FROM event_ts AT TIME ZONE 'UTC') < 7
 OR extract(hour FROM event_ts AT TIME ZONE 'UTC') >= 19) GROUP BY actor_user;
