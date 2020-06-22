SESSION LVEL info for current active sessions

***CPU Usage by ACTIVE sessions***
select s.inst_id, s.sid sid, s.serial# serial#, to_char(s.logon_time,’dd-mon-yyy hh:mi:ss HH24′), lpad(s.status,9) session_status
, lpad(s.username,12) oracle_username, lpad(s.osuser,9) os_username, lpad(p.spid,7) os_pid , s.client_info, s.program session_program, lpad(s.machine,8) session_machine
, round(((sum(stm.value)/1000000)/(((sysdate-s.logon_time)*24*60*60)*(select value from gv$parameter gp where gp.inst_id = s.inst_id and upper(name) like ‘%CPU_COUNT%’)))*100, 2) sess_cpu_perc
, (sysdate-s.logon_time)*24*60*60 ses_elap_time_sec
, SUM(CASE WHEN stat_name = ‘background cpu time’
THEN round(stm.value/1000000,0)
ELSE 0
END
) bakGrnd_cpu_secs
, SUM(CASE WHEN stat_name = ‘DB CPU’
THEN round(stm.value/1000000,0)
ELSE 0
END
) ForeGrnd_cpu_secs
, SUM(CASE WHEN stat_name = ‘RMAN cpu time (backup/restore)’
THEN round(stm.value/1000000,0)
ELSE 0
END
) RMAN_cpu_secs
from gv$process p, gv$session s, gv$sess_time_model stm
WHERE p.addr (+) = s.paddr
AND p.inst_id (+) = s.INST_ID
AND s.sid = stm.sid
AND s.inst_id = stm.inst_id
AND stat_name in (‘background cpu time’, ‘DB CPU’,’RMAN cpu time (backup/restore)’)
AND round(stm.value/1000000,0) <> 0
group by s.sid, s.inst_id, s.serial#, to_char(s.logon_time,’dd-mon-yyy hh:mi:ss’), lpad(s.status,9),
lpad(s.username,12), lpad(s.osuser,9), lpad(p.spid,7), s.client_info, s.program, lpad(s.machine,8)
,(sysdate-s.logon_time)*24*60*60
order by SUM(CASE WHEN stat_name = ‘background cpu time’
THEN round(stm.value/1000000,0)
ELSE 0
END
) +
SUM(CASE WHEN stat_name = ‘DB CPU’
THEN round(stm.value/1000000,0)
ELSE 0
END
) +
SUM(CASE WHEN stat_name = ‘RMAN cpu time (backup/restore)’
THEN round(stm.value/1000000,0)
ELSE 0
END
) desc, inst_id, sid, serial#;

*** CPU Usage By Session *** Old Style
CPU USAGE BY SESSION NOTES:
Username – Name of the user
SID – Session id
CPU Usage – CPU centiseconds used by this session (divide by 100 to get real CPU seconds)

select nvl(ss.USERNAME,’ORACLE PROC’) username,
se.SID,
VALUE cpu_usage
from v$session ss,
v$sesstat se,
v$statname sn
where se.STATISTIC# = sn.STATISTIC#
and NAME like ‘%CPU used by this session%’
and se.SID = ss.SID
order by VALUE desc


**PGA usage by ACTIVE sessions**
SELECT s.sid sid, s.inst_id, s.serial# serial_id, lpad(s.status,9) session_status
, lpad(s.username,12) oracle_username, lpad(s.osuser,9) os_username, lpad(p.spid,7) os_pid
, s.program session_program, lpad(s.machine,8) session_machine, sstat1.value session_pga_memory
, sstat2.value session_pga_memory_max
FROM gv$process p, gv$session s
, gv$sesstat sstat1, gv$sesstat sstat2
, gv$statname statname1, gv$statname statname2
WHERE p.addr (+) = s.paddr
AND p.inst_id (+) = s.INST_ID
AND s.sid = sstat1.sid
AND s.sid = sstat2.sid
AND s.INST_ID = sstat1.INST_ID
AND s.inst_id = sstat2.INST_ID
AND statname1.statistic# = sstat1.statistic#
AND statname2.statistic# = sstat2.statistic#
AND statname1.INST_ID = sstat1.INST_ID
AND statname2.INST_ID = sstat2.INST_ID
AND statname1.name = ‘session pga memory’
AND statname2.name = ‘session pga memory max’
ORDER BY session_pga_memory DESC;


***User Hit Ratios***
USER HIT RATIO NOTES:
Username – Name of the user
Consistent Gets – The number of accesses made to the block buffer to retrieve data in a consistent mode.
DB Blk Gets – The number of blocks accessed via single block gets (i.e. not through the consistent get mechanism).
Physical Reads – The cumulative number of blocks read from disk.

Logical reads are the sum of consistent gets and db block gets.
The db block gets statistic value is incremented when a block is read for update and when segment header blocks are accessed.
Hit ratio should be > 90%

select USERNAME,
CONSISTENT_GETS,
BLOCK_GETS,
PHYSICAL_READS,
((CONSISTENT_GETS+BLOCK_GETS-PHYSICAL_READS) / (CONSISTENT_GETS+BLOCK_GETS)) Ratio
from v$session, v$sess_io
where v$session.SID = v$sess_io.SID
and (CONSISTENT_GETS+BLOCK_GETS) > 0
and USERNAME is not null
order by ((CONSISTENT_GETS+BLOCK_GETS-PHYSICAL_READS) / (CONSISTENT_GETS+BLOCK_GETS))


***Cursor Usage By Session***
CURSOR USAGE BY SESSION NOTES:
Username – Name of the user
Recursive Calls – Total number of recursive calls
Opened Cursors – Total number of opened cursors
Current Cursors – Number of cursor currently in use

select user_process username,
“Recursive Calls”,
“Opened Cursors”,
“Current Cursors”
from (
select nvl(ss.USERNAME,’ORACLE PROC’)||’(‘||se.sid||’) ‘ user_process,
sum(decode(NAME,’recursive calls’,value)) “Recursive Calls”,
sum(decode(NAME,’opened cursors cumulative’,value)) “Opened Cursors”,
sum(decode(NAME,’opened cursors current’,value)) “Current Cursors”
from v$session ss,
v$sesstat se,
v$statname sn
where se.STATISTIC# = sn.STATISTIC#
and (NAME like ‘%opened cursors current%’
or NAME like ‘%recursive calls%’
or NAME like ‘%opened cursors cumulative%’)
and se.SID = ss.SID
and ss.USERNAME is not null
group by nvl(ss.USERNAME,’ORACLE PROC’)||’(‘||se.SID||’) ‘
)
orasnap_user_cursors
order by USER_PROCESS,”Recursive Calls”


***Session Stats By Session***
SESSION STAT NOTES:
Username – Name of the user
SID – Session ID
Statistic – Name of the statistic
Usage – Usage according to Oracle

select nvl(ss.USERNAME,’ORACLE PROC’) username,
se.SID,
sn.NAME stastic,
VALUE usage
from v$session ss,
v$sesstat se,
v$statname sn
where se.STATISTIC# = sn.STATISTIC#
and se.SID = ss.SID
and se.VALUE > 0
order by sn.NAME, se.SID, se.VALUE desc


***Resource Usage By User***
RESOURCE USAGE BY USER NOTES:
SID – Session ID
Username – Name of the user
Statistic – Name of the statistic
Value – Current value

select ses.SID,
nvl(ses.USERNAME,’ORACLE PROC’) username,
sn.NAME statistic,
sest.VALUE
from v$session ses,
v$statname sn,
v$sesstat sest
where ses.SID = sest.SID
and sn.STATISTIC# = sest.STATISTIC#
and sest.VALUE is not null
and sest.VALUE != 0
order by ses.USERNAME, ses.SID, sn.NAME


****Session I/O By User***
SESSION I/O BY USER NOTES:
Username – Name of the Oracle process user
OS User – Name of the operating system user
PID – Process ID of the session
SID – Session ID of the session
Serial# – Serial# of the session
Physical Reads – Physical reads for the session
Block Gets – Block gets for the session
Consistent Gets – Consistent gets for the session
Block Changes – Block changes for the session
Consistent Changes – Consistent changes for the session

select nvl(ses.USERNAME,’ORACLE PROC’) username,
OSUSER os_user,
PROCESS pid,
ses.SID sid,
SERIAL#,
PHYSICAL_READS,
BLOCK_GETS,
CONSISTENT_GETS,
BLOCK_CHANGES,
CONSISTENT_CHANGES
from v$session ses,
v$sess_io sio
where ses.SID = sio.SID
order by PHYSICAL_READS, ses.USERNAME


/************** SESSION LEVEL info for historical sessions ***************/
**History (ASH) of CPU, PGA and DB times by SESSION and by sample from dba_hist_ash, sample is approx every 1 seconds**
**This is in memoery, might not have long enough history, in that case, go with DBA_HIST_ASH, below this query**
SELECT snap_id,to_char(sample_time,’DD Mon HH24:MI’) as Sample_Time,
instance_number,session_id,session_serial#,session_type
,u.username
,round(h.tm_delta_time/1000000,2) tm_delta_secs /*–time interval from previous sample for v$ASH and SUM of value from samples between current and previous dba_hist_ash entry*/
,round(h.tm_delta_db_time/1000000,2) tm_db_time_secs /* DB time with respect to tm_delta_time */
,round(h.TM_DELTA_CPU_TIME/1000000,2) cpu_time /* CPU time with respect to tm_delta_time */
,round(pga_allocated/1024/1024) pga_alloctd_mb
,round(delta_time/1000000,2) delta_time_secs
,DELTA_READ_IO_BYTES
,DELTA_WRITE_IO_BYTES
,h.program,h.module,s.sql_text
,EVENT /*If SESSION_STATE = WAITING, then the event for which the session was waiting for at the time of sampling. If SESSION_STATE = ON CPU, then this column is NULL.*/
,session_state
,WAIT_TIME /*Total wait time for the event for which the session last waited if the session was on the CPU when sampled; 0 if the session was waiting at the time of sampling */
,TIME_WAITED /*If SESSION_STATE = WAITING, then the time that the session actually spent waiting for that event (in hundredths of a second). This column is set for waits that were in progress at the time the sample was taken. */
,BLOCKING_SESSION /*Session identifier of the blocking session. Populated only if the blocker is on the same instance and the session was waiting for enqueues or a “buffer busy” wait. Maps to V$SESSION.BLOCKING_SESSION.*/
,BLOCKING_INST_ID /*Instance number of the blocker shown in BLOCKING_SESSION */
FROM v$ACTIVE_SESS_HISTORY h,DBA_USERS u,DBA_HIST_SQLTEXT s
WHERE to_char(sample_time,’MM-DD-YYYY HH24:MI:SS’) BETWEEN ‘&s_time’ and ‘&e_time’
–03-23-2014 00:00:00
AND INSTANCE_NUMBER=&inst_no
–AND session_id in (2712)
AND (upper(h.program) like ‘%RMAN%’ OR upper(module) like ‘%RMAN%’) — Use this to get the info based on the tool used to connect, if session id is not known
AND h.user_id=u.user_id (+)
AND h.sql_id = s.sql_iD (+)
ORDER BY instance_number, sample_time desc, session_id, session_serial#;
**History (DBA_HIST_ASH) of CPU, PGA and DB times by SESSION and by sample, sample is approx every 10 seconds**
SELECT snap_id,to_char(sample_time,’DD Mon HH24:MI’) as Sample_Time,
instance_number,session_id,session_serial#,session_type
,u.username
,round(h.tm_delta_time/1000000,2) tm_delta_secs /*–time interval from previous sample for v$ASH and SUM of value from samples between current and previous dba_hist_ash entry*/
,round(h.tm_delta_db_time/1000000,2) tm_db_time_secs /* DB time with respect to tm_delta_time */
,round(h.TM_DELTA_CPU_TIME/1000000,2) cpu_time /* CPU time with respect to tm_delta_time */
,round(pga_allocated/1024/1024) pga_alloctd_mb
,round(delta_time/1000000,2) delta_time_secs
,DELTA_READ_IO_BYTES
,DELTA_WRITE_IO_BYTES
,h.program,h.module,s.sql_text
,EVENT /*If SESSION_STATE = WAITING, then the event for which the session was waiting for at the time of sampling. If SESSION_STATE = ON CPU, then this column is NULL.*/
,session_state
,WAIT_TIME /*Total wait time for the event for which the session last waited if the session was on the CPU when sampled; 0 if the session was waiting at the time of sampling */
,TIME_WAITED /*If SESSION_STATE = WAITING, then the time that the session actually spent waiting for that event (in hundredths of a second). This column is set for waits that were in progress at the time the sample was taken. */
,BLOCKING_SESSION /*Session identifier of the blocking session. Populated only if the blocker is on the same instance and the session was waiting for enqueues or a “buffer busy” wait. Maps to V$SESSION.BLOCKING_SESSION.*/
,BLOCKING_INST_ID /*Instance number of the blocker shown in BLOCKING_SESSION */
FROM DBA_HIST_ACTIVE_SESS_HISTORY h,DBA_USERS u,DBA_HIST_SQLTEXT s
WHERE to_char(sample_time,’MM-DD-YYYY HH24:MI:SS’) BETWEEN ‘&s_time’ and ‘&e_time’
–03-23-2014 00:00:00
AND INSTANCE_NUMBER=&inst_no
–AND session_id in (2712)
AND (upper(h.program) like ‘%RMAN%’ OR upper(module) like ‘%RMAN%’) — Use this to get the info based on the tool used to connect, if session id is not known
AND h.user_id=u.user_id (+)
AND h.sql_id = s.sql_iD (+)
ORDER BY instance_number, sample_time desc, session_id, session_serial#;


**History (ASH) of all the wait events on a machine**
select event, count(1)
from v$active_session_history
where machine = ‘&machine’
and sample_time between
to_date(’29-SEP-12 04.55.00 PM’,’dd-MON-yy hh:mi:ss PM’)
and
to_date(’29-SEP-12 05.05.00 PM’,’dd-MON-yy hh:mi:ss PM’)
group by event
order by event;
**History (DBA_HIST_ASH) of Row loc information**
select snap_id, instance_number, sample_time, session_state, blocking_session,
owner||’.’||object_name||’:’||nvl(subobject_name,’-’) obj_name,
dbms_ROWID.ROWID_create (
1,
o.data_object_id,
current_file#,
current_block#,
current_row#
) row_id
from dba_hist_active_sess_history s, dba_objects o
where user_id = 92
and sample_time between
to_date(’29-SEP-12 04.55.02 PM’,’dd-MON-yy hh:mi:ss PM’)
and
to_date(’29-SEP-12 05.05.02 PM’,’dd-MON-yy hh:mi:ss PM’)
and event = ‘enq: TX – row lock contention’
and o.data_object_id = s.current_obj#
order by 1,2;


/******** ACTIVE, SESSION LVEL info for locking, statistics, wait events *********/
**Use the below query to get the info of all the sessions and their current stats(waiting/working) OR a session from particular user or machine and so on**
select s.sid, s.serial#, p.spid unix_pid, s.inst_id, s.osuser, s.machine, s.terminal, s.program, s.service_name
, s.logon_time, s.last_call_et “lst_sql_call_made_bef_secs”, s.sql_id
,decode(s.state,
‘WAITING’,’Waiting’,
‘Working’) state
,wait_class
,decode(s.state,
‘WAITING’,
‘Currently waiting, So far ‘||seconds_in_wait,
‘Last waited ‘||
wait_time/100)||
‘ secs for ‘||event
“Wait_Description”
,s.blocking_session, s.blocking_instance, s.row_wait_obj# blocked_object, s.row_wait_file# blocked_file_num
,s.row_wait_block# blocked_block#_in_File, s.row_wait_row# blocked_row_Slot_in_file
,do.owner blckd_obj_owner, do.object_type blckd_obj_type, do.object_name blkd_obj_name, do.data_object_id row_id_type
from gv$session s, dba_objects do, gv$process p
where s.row_wait_obj# = do.object_id (+)
and s.paddr = p.addr
and s.inst_id = p.inst_id
–and username = ‘&user’
–and machine = ‘&machine’;


**Now that there is enough info on the blocking session and objects from above query, use below to find more detailed row level info using below query**
REM Filename: rowinfo.sql
REM This shows the row from the table when the
REM components of ROWID are passed. Pass the
REM following in this exact order
REM 1. owner
REM 2. table name
REM 3. data_object_id
REM 4. relative file ID
REM 5. block ID
REM 6. row Number
REM
select *
from &1..&2
where rowid =
dbms_rowid.rowid_create (
rowid_type => 1,
object_number => &3,
relative_fno => &4,
block_number => &5,
row_number => &6
);


**Get object level info for Data Access waits such as “db file sequential reads”. Use this once a session is found to be waiting on Data access wait**
select s.SID, s.inst_id, s.state, s.event, s.p1, s.p2, de.segment_name, de.SEGMENT_TYPE
from gv$session s
,dba_extents de
where de.file_id = s.p1
and s.p2 between de.block_id and de.block_id+de.blocks
and s.username = ‘&user’
and s.session_id = &sess_id
and s.inst_id = &inst_id;


**All the wait events info of Active sessions, not just current wait events, but all the events since session start time**
select se.sid, se.inst_id, se.event, se.total_waits, se.time_waited*10 TimeWaited_ms,
se.average_wait*10 avgWait_ms, se.max_wait*10 MaxWait_ms
from gv$session_event se
where se.sid = &sid
–and se.inst_id = &inst_id
order by se.inst_id, se.sid;


**Stats and their values by an active session**
select s.sid, s.inst_id, n.name, s.value
from gv$sesstat s, gv$statname n
where s.sid = &sid
and s.inst_id = &inst_id
and n.statistic# = s.statistic#
and n.inst_id = s.inst_id
order by s.value desc;
**Stats by Time by an active session**
select sid, stat_name, value/1000000 Time_Spent_in_secs
from GV$SESS_TIME_MODEL
where sid=&sid
and inst_id=&inst_id;