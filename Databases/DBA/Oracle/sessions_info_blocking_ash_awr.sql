--BLOCKING Sessions info from Active session history and dba_hist_act_sess_history.

--ASH

select ah.sample_time even_time, s.sql_text, u.username, session_id, session_state, blocking_session_status, event, wait_class
from V$ACTIVE_SESSION_HISTORY ah,   DBA_USERS u,
   DBA_HIST_SQLTEXT s
where ah.session_id = 144
and  ah.sample_time BETWEEN '09-APR-19 07.55.16.596000000 PM' and '09-APR-19 10.45.16.596000000 PM'
AND ah.user_id=u.user_id
AND ah.sql_id = s.sql_iD
order by ah.sample_time
;

SELECT DISTINCT a.sql_id,
                a.inst_id,
                a.blocking_session         blocker_ses,
                a.blocking_session_serial# blocker_ser,
                a.user_id,
                s.sql_text,
                a.module,
                a.sample_time
  FROM GV$ACTIVE_SESSION_HISTORY a, gv$sql s
 WHERE     a.sql_id = s.sql_id
       AND blocking_session IS NOT NULL
       AND a.user_id <> 0                                -- exclude SYS user
       AND a.sample_time BETWEEN SYSDATE - 1 AND SYSDATE - 23 / 24

--If its too late to get info from ASH, got to dba_hist_Act_sess_history
SELECT sample_time, s.sql_text, u.user_id, u.username, session_id, session_State, event, h.blocking_session, blocking_session_status, wait_class,
--   u.username,
   h.program
FROM dba_hist_active_Sess_history h,
   DBA_USERS u,
   DBA_HIST_SQLTEXT s
WHERE  sample_time BETWEEN '09-APR-19 07.55.16.596000000 PM' and '09-APR-19 10.45.16.596000000 PM'
and username = 'DWMOBLOAD'
--and h.blocking_session = 144
--AND INSTANCE_NUMBER=2
AND h.user_id=u.user_id
AND h.sql_id = s.sql_iD
ORDER BY 1;

--If lucky, we might be able to get more info from below.

SELECT s.sid,
    waiter.p1raw w_p1r,
    waiter.p2raw w_p2r,
    holder.event h_wait,
    holder.p1raw h_p1r,
    holder.p2raw h_p2r,
    count(s.sid) users_blocked,
    sql.hash_value
FROM
    v$sql sql,
    V$ACTIVE_SESSION_HISTORY s,
    x$kgllk l,
    v$session_wait waiter,
    v$session_wait holder
WHERE
    s.sql_hash_value = sql.hash_value and
    l.KGLLKADR=waiter.p2raw and
    s.saddr=l.kgllkuse and
    waiter.event like 'library cache lock' and
    holder.sid=s.sid
GROUP BY
    s.sid,
    waiter.p1raw ,
    waiter.p2raw ,
    holder.event ,
    holder.p1raw ,
    holder.p2raw ,
    sql.hash_value;