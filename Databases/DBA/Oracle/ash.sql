--Top SQL by time
SELECT active_session_history.user_id,
dba_users.username,
SUM(active_session_history.wait_time +
active_session_history.time_waited)/1000000 ttl_wait_time_in_seconds,
sqlarea.sql_text
FROM v$active_session_history active_session_history,
v$sqlarea sqlarea,
dba_users
WHERE active_session_history.sample_time BETWEEN SYSDATE - 1 AND SYSDATE
AND active_session_history.sql_id = sqlarea.sql_id
AND active_session_history.user_id = dba_users.user_id
and dba_users.username <>'SYS'
GROUP BY active_session_history.user_id,sqlarea.sql_text, dba_users.username
ORDER BY 4 DESC

http://orababy.blogspot.com/2013/08/active-session-history-queries.html