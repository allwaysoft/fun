---------------------------------------------------------
-- Tables used in locking information
---------------------------------------------------------
sys.dm_exec_sessions
sys.dm_tran_locks

---------------------------------------------------------
-- Find Locks Query1
---------------------------------------------------------
use master
go
SELECT
db.name DBName,
tl.request_session_id,
wt.blocking_session_id,
OBJECT_NAME(p.OBJECT_ID) BlockedObjectName,
tl.resource_type,   
h1.TEXT AS RequestingText,
h2.TEXT AS BlockingTest,
tl.request_mode  --lock type
FROM sys.dm_tran_locks AS tl
INNER JOIN sys.databases db ON db.database_id = tl.resource_database_id
INNER JOIN sys.dm_os_waiting_tasks AS wt ON tl.lock_owner_address = wt.resource_address
INNER JOIN sys.partitions AS p ON p.hobt_id = tl.resource_associated_entity_id
INNER JOIN sys.dm_exec_connections ec1 ON ec1.session_id = tl.request_session_id
INNER JOIN sys.dm_exec_connections ec2 ON ec2.session_id = wt.blocking_session_id
CROSS APPLY sys.dm_exec_sql_text(ec1.most_recent_sql_handle) AS h1
CROSS APPLY sys.dm_exec_sql_text(ec2.most_recent_sql_handle) AS h2

---------------------------------------------------------
--Find session info from session id of a locking session
---------------------------------------------------------
select * from sys.dm_exec_sessions

---------------------------------------------------------
--Find locks Query2 -- This is a StoredProcedure
---------------------------------------------------------
Create Procedure SQL_ShowLOCKS as
Set NOCOUNT ON
------------------------------------------------
-- Auhtor: Saleem Hakani (WWW.SQLCOMMUNITY.COM)
-- Date: June 24th 2007 @ 7:12 PM PST
-- Description: This procedure helps you detect realtime deaclocks and blocks
-- Compatibility: SQL Server 2005 only
-- Disclaimer: This script, is provided for informational purposes only and SQL Server Community (aka: WWW.SQLCOMMUNITY.COM) or the author of this script makes no warranties, 
-- either express or implied. This script, scenarios and other external web site references, is subject to change without notice. 
-- The entire risk of the use or the results of the use of this script remains with the user.
-------------------------------------------------
If Exists (Select Name from TempDB..SysObjects Where Name = '##Tmp_SQL_Locks')
Begin
	Drop Table ##Tmp_SQL_Locks
End

Select t1.resource_type as [Lock_Type]
	,db_name(resource_database_id) as [DB_Name]
	,t1.resource_associated_entity_id as [Victim]
	,t1.request_mode as [Requested_by]			-- lock requested
	,t1.request_session_id as [Waiter_SPID]  -- spid of waiter
	,t2.wait_duration_ms as [Wait_Time]	
	,(select text from sys.dm_exec_requests as r  --- get sql for waiter
	cross apply sys.dm_exec_sql_text(r.sql_handle) 
	where r.session_id = t1.request_session_id) as Waiter_Batch
	,(select substring(qt.text,r.statement_start_offset/2, 
	(case when r.statement_end_offset = -1 
	then len(convert(nvarchar(max), qt.text)) * 2 
	else r.statement_end_offset end - r.statement_start_offset)/2) 
	from sys.dm_exec_requests as r
	cross apply sys.dm_exec_sql_text(r.sql_handle) as qt
	where r.session_id = t1.request_session_id) as Waiter_STMT    --- this is the statement executing right now
	,t2.blocking_session_id as [Blocker_SPID] -- spid of blocker
    ,(select text from sys.sysprocesses as p		--- get sql for blocker
	cross apply sys.dm_exec_sql_text(p.sql_handle) 
	where p.spid = t2.blocking_session_id) as Blocker_STMT
	into ##Tmp_SQL_Locks from 
	sys.dm_tran_locks as t1, 
	sys.dm_os_waiting_tasks as t2
	where 
	t1.lock_owner_address = t2.resource_address

If (Select count(*) from ##Tmp_SQL_Locks) = 0
Begin
	Print 'No locks found'
End
If (Select count(*) from ##Tmp_SQL_Locks) > 0
Begin
	Select * from ##Tmp_SQL_Locks
End

--execute SQL_ShowLOCKS

---------------------------------------------------------
--Find locks Query3
---------------------------------------------------------
-- **********************************************/
-- Description  :    Script to check is there any blocking, if there's locked sessions and determines what sessions are generating blocking and what sessions are blocked
--                        This Script will check blocking and blocked process
--                            We can also use use this script to check blocking
-- Compatibility  :     7.0+
-- **********************************************/
use master
go
SELECT  x.session_id,
        x.host_name,
        x.login_name,
        x.start_time,
        x.totalReads,
        x.totalWrites,
        x.totalCPU,
        x.writes_in_tempdb,
    (
            -- Query gets XML text for the sql query for the session_id
            SELECT      text AS [text()]
            FROM  sys.dm_exec_sql_text(x.sql_handle)
            FOR XML PATH(''), TYPE
      
    )AS sql_text,
     COALESCE(x.blocking_session_id, 0) AS blocking_session_id,
    (
        SELECT p.text
        FROM
        (
            -- Query gets the corresponding sql_handle info to find the XML text in the next query
            SELECT MIN(sql_handle) AS sql_handle
            FROM sys.dm_exec_requests r2
            WHERE r2.session_id = x.blocking_session_id
        ) AS r_blocking
        CROSS APPLY
        (
            -- Query will pull back the XML text for a blocking session if there is any from the sql_haldle
            SELECT text AS [text()]
            FROM sys.dm_exec_sql_text(r_blocking.sql_handle)
            FOR XML PATH(''), TYPE
        ) p (text)
    ) AS blocking_text
FROM
(
-- Query returns active session_id and metadata about the session for resource, blocking, and sql_handle
    SELECT  r.session_id,
            s.host_name,
            s.login_name,
            r.start_time,
            r.sql_handle,
            r.blocking_session_id,
            SUM(r.reads) AS totalReads,
            SUM(r.writes) AS totalWrites,
            SUM(r.cpu_time) AS totalCPU,
            SUM(tsu.user_objects_alloc_page_count + tsu.internal_objects_alloc_page_count) AS writes_in_tempdb
    FROM    sys.dm_exec_requests r
    JOIN    sys.dm_exec_sessions s ON s.session_id = r.session_id
    JOIN    sys.dm_db_task_space_usage tsu ON s.session_id = tsu.session_id and r.request_id = tsu.request_id
    WHERE   r.status IN ('running', 'runnable', 'suspended')
      and r.blocking_session_id <> 0
    GROUP BY    r.session_id,
                s.host_name,
                s.login_name,
                r.start_time,
                r.sql_handle,
                r.blocking_session_id
) x
---------------------------------------------------------
---------------------------------------------------------

select
  object_name(sl.resource_associated_entity_id) as 'TableName' ,dr.command,sl.*
from
  sys.dm_tran_locks as sl left join sys.dm_exec_requests dr on sl.request_session_id=dr.session_id
where sl.resource_type = 'OBJECT'
  and sl.resource_database_id = DB_ID()
   and sl.request_mode = 'Sch-M'  -- This tells that show only locks at schema level, schema level locks are donw when DDL is executed against object of a schema.
--http://msdn.microsoft.com/en-us/library/ms175519%28v=sql.105%29.aspx   