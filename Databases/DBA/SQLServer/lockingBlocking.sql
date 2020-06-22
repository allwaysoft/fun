--Active Sessions
sp_who3SELECT 
    r.session_id
    ,st.text AS batch_text
    ,SUBSTRING(st.text, statement_start_offset / 2 + 1, (
            (
                CASE 
                    WHEN r.statement_end_offset = - 1
                        THEN (LEN(CONVERT(NVARCHAR(max), st.text)) * 2)
                    ELSE r.statement_end_offset
                    END
                ) - r.statement_start_offset
            ) / 2 + 1) AS statement_text
    ,qp.query_plan AS 'XML Plan'
    ,r.*
FROM sys.dm_exec_requests r
CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) AS st
CROSS APPLY sys.dm_exec_query_plan(r.plan_handle) AS qp
ORDER BY cpu_time DESC
------------------------------------------------------------------------------------------------------------------------------------------------------------
--Who is blocking a session
-- Can also use S1 for blocking sessions
sp_who3
sp_who2--DB object is blocked by whom?
declare @tablename sysnameselect @tablename = 'Replace with your table name'
select convert (smallint, req_spid) As spid,
rsc_dbid As dbid,
rsc_objid As ObjId,
rsc_indid As IndId,
substring (v.name, 1, 4) As Type,
substring (rsc_text, 1, 32) as Resource,
substring (u.name, 1, 8) As Mode,
substring (x.name, 1, 5) As Status
from master.dbo.syslockinfo,
master.dbo.spt_values v,
master.dbo.spt_values x,
master.dbo.spt_values u
where master.dbo.syslockinfo.rsc_type = v.number
and v.type = 'LR'
and master.dbo.syslockinfo.req_status = x.number
and x.type = 'LS'
and master.dbo.syslockinfo.req_mode + 1 = u.number
and u.type = 'L'
and rsc_objid = object_id(@tablename)
------------------------------------------------------------------------------------------------------------------------------------------------------------
--Good read on PAGELATCH_UP wait
https://documentation.red-gate.com/sm4/working-with-overviews/using-performance-diagnostics/list-of-common-wait-types/pagelatch_up--Get the resource on which spid is locking.
https://docs.microsoft.com/en-us/sql/relational-databases/system-dynamic-management-views/sys-dm-os-waiting-tasks-transact-sql?view=sql-server-ver15 --This link shows what all possible values for resource_description field
select * from sys.dm_os_waiting_tasks order by resource_description --resource_description is the key here. From this, one can get more info about the file and object--Get object information from the values of rescource_description filed above
https://www.sqlskills.com/blogs/paul/finding-table-name-page-id/ --This doc shows the usage of DBCC PAGE
https://www.sqlservercentral.com/forums/topic/object-id-99 --If object Id from dbcc comesup to be 99, it might bewriting to new pages, example a new index creation will show up as objectId 99 until the index is built and persists in DB as an object 
DBCC TRACEON (3604);
DBCC PAGE (8, 7, 76245576, 0);  --DBID, fileId, pageId, print only page header are the parameters here.
DBCC TRACEOFF (3604);select FILE_NAME(6)
-- Get the object info on which there is locking
SELECT  t1.resource_type,  
        t1.resource_database_id,  
        t1.resource_associated_entity_id,  
        t1.request_mode,  
        t1.request_session_id,  
        t2.blocking_session_id, t1.resource_description, object_name(object_id), *  
    FROM sys.dm_tran_locks as t1  
    INNER JOIN sys.dm_os_waiting_tasks as t2 ON t1.lock_owner_address = t2.resource_address
    inner join sys.partitions on hobt_id = t1.resource_associated_entity_id
    WHERE resource_database_id = 8  
------------------------------------------------------------------------------------------------------------------------------------------------------------