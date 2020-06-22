SELECT s.username, s.program, s.logon_time
FROM v$session s, v$process p, sys.v_$sess_io si
WHERE s.paddr = p.addr(+) AND si.sid(+) = s.sid AND s.type = 'USER'

SELECT 
S.USERNAME SU,
S.OSUSER OSU,
to_char(S.LOGON_TIME,'MM-DD-YYYY HH24:MI:SS') LOGTIME,
S.STATUS STAT,
S.SID SSID,
S.SERIAL# SSER,
LPAD(P.SPID,9) SPID,
SUBSTR(SA.SQL_TEXT,1,540) TXT
FROM V$PROCESS P,
V$SESSION S,
V$SQLAREA SA
WHERE P.ADDR=S.PADDR
AND S.USERNAME IS NOT NULL
AND S.SQL_ADDRESS=SA.ADDRESS (+)
AND S.SQL_HASH_VALUE=SA.HASH_VALUE (+)
ORDER BY 1,3,6;


--Show sessions that are blocking each other
select	'SID ' || l1.sid ||' is blocking  ' || l2.sid blocking
from	v$lock l1, v$lock l2
where	1=1
and l1.block =1 and l2.request > 0
and	l1.id1=l2.id1
and	l1.id2=l2.id2


--Show locked objects
select	oracle_username || ' (' || s.osuser || ')' username
,	s.sid || ',' || s.serial# sess_id
,	owner || '.' ||	object_name object
,	object_type
,	decode(	l.block
	,	0, 'Not Blocking'
	,	1, 'Blocking'
	,	2, 'Global') status
,	decode(v.locked_mode
	,	0, 'None'
	,	1, 'Null'
	,	2, 'Row-S (SS)'
	,	3, 'Row-X (SX)'
	,	4, 'Share'
	,	5, 'S/Row-X (SSX)'
	,	6, 'Exclusive', TO_CHAR(lmode)) mode_held
from	v$locked_object v
,	dba_objects d
,	v$lock l
,	v$session s
where 	v.object_id = d.object_id
and 	v.object_id = l.id1
and 	v.session_id = s.sid
order by oracle_username
,	session_id


--Show which row is locked
select	do.object_name
,	row_wait_obj#
,	row_wait_file#
,	row_wait_block#
,	row_wait_row#
,	dbms_rowid.rowid_create (1, ROW_WAIT_OBJ#, ROW_WAIT_FILE#, 
				ROW_WAIT_BLOCK#, ROW_WAIT_ROW#)
from	v$session s
,	dba_objects do
where	sid=&sid
and 	s.ROW_WAIT_OBJ# = do.OBJECT_ID



delete from PYEMPPAYHIST where rowid='AAANOhAAIAAAm4LAAA'--'AAANOhAAFAAAhzqAAA';
commit
select rowid from pyemppayhist where rowid = 'AAANOhAAIAAAm4LAAA'

--List locks
SELECT	session_id
,	lock_type
,	mode_held
,	mode_requested
,	blocking_others
,	lock_id1
FROM	dba_lock l
WHERE 	lock_type NOT IN ('Media Recovery', 'Redo Thread')