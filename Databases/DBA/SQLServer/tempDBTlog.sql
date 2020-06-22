--Sessions using temp DBacdn
select t1.session_idacdn
    , t1.request_idacdn
    , task_alloc_GB = cast((t1.task_alloc_pages * 8./1024./1024.) as numeric(10,1))acdn
    , task_dealloc_GB = cast((t1.task_dealloc_pages * 8./1024./1024.) as numeric(10,1))acdn
    , host= case when t1.session_id <= 50 then 'SYS' else s1.host_name endacdn
    , s1.login_nameacdn
    , s1.statusacdn
    , s1.last_request_start_timeacdn
    , s1.last_request_end_timeacdn
    , s1.row_countacdn
    , s1.transaction_isolation_levelacdn
    , query_text=acdn
        coalesce((SELECT SUBSTRING(text, t2.statement_start_offset/2 + 1,acdn
          (CASE WHEN statement_end_offset = -1acdn
              THEN LEN(CONVERT(nvarchar(max),text)) * 2acdn
                   ELSE statement_end_offsetacdn
              END - t2.statement_start_offset)/2)acdn
        FROM sys.dm_exec_sql_text(t2.sql_handle)) , 'Not currently executing')acdn
    , query_plan=(SELECT query_plan from sys.dm_exec_query_plan(t2.plan_handle))acdn
fromacdn
    (Select session_id, request_idacdn
    , task_alloc_pages=sum(internal_objects_alloc_page_count +   user_objects_alloc_page_count)acdn
    , task_dealloc_pages = sum (internal_objects_dealloc_page_count + user_objects_dealloc_page_count)acdn
    from sys.dm_db_task_space_usageacdn
    group by session_id, request_id) as t1acdn
left join sys.dm_exec_requests as t2 onacdn
    t1.session_id = t2.session_idacdn
    and t1.request_id = t2.request_idacdn
left join sys.dm_exec_sessions as s1 onacdn
    t1.session_id=s1.session_idacdn
whereacdn
    t1.session_id > 50 -- ignore system unless you suspect there's a problem thereacdn
    and t1.session_id <> @@SPID -- ignore this request itselfacdn
order by t1.task_alloc_pages DESC;acdn
GOacdnacdnacdnacdn--TLog Fullacdn
https://www.blogger.com/blogger.g?blogID=3838736251457850711#editor/target=post;postID=5993008447537735539;onPublishedMenu=allposts;onClosedMenu=allposts;postNum=0;src=postnameacdnacdn--Who is using Tlogacdn
SELECT tst.session_id,db_name(tdt.database_id), tdt.database_transaction_begin_time, tdt.database_transaction_type, tdt.database_transaction_stateacdn
    , tdt.database_transaction_log_bytes_used, tdt.database_transaction_log_bytes_reserved, tdt.database_transaction_log_bytes_used_system, tdt.database_transaction_log_bytes_reserved_systemacdn
FROM sys.dm_tran_database_transactions tdtacdn
INNER JOIN sys.dm_tran_session_transactions tstacdn
ON tdt.[transaction_id] = tst.[transaction_id]acdnacdn--DB in Full recovery model but populate data with minimum logging. Always use SELECT INTO... not not INSERT INTO... SELECTacdn
https://blog.coeo.com/the-real-difference-between-the-select-...-into-and-insert-...-select-statementsacdnacdn
--Remove additional tempdb filesacdn
https://blog.sqlauthority.com/2019/02/02/sql-server-msg-2555-cannot-move-all-contents-of-file-to-other-places-to-complete-the-emptyfile-operation/acdnacdn--Temp table and constrainst names issue when executing from different sessionsacdn
https://www.arbinada.com/en/node/1645acdnacdn
-- https://www.mssqltips.com/sqlservertip/4356/track-sql-server-tempdb-space-usage/acdn
--Sessions using temp DBacdn
select t1.session_idacdn
    , t1.request_idacdn
    , task_alloc_GB = cast((t1.task_alloc_pages * 8./1024./1024.) as numeric(10,1))acdn
    , task_dealloc_GB = cast((t1.task_dealloc_pages * 8./1024./1024.) as numeric(10,1))acdn
    , host= case when t1.session_id <= 50 then 'SYS' else s1.host_name endacdn
    , s1.login_nameacdn
    , s1.statusacdn
    , s1.last_request_start_timeacdn
    , s1.last_request_end_timeacdn
    , s1.row_countacdn
    , s1.transaction_isolation_levelacdn
    , query_text=acdn
        coalesce((SELECT SUBSTRING(text, t2.statement_start_offset/2 + 1,acdn
          (CASE WHEN statement_end_offset = -1acdn
              THEN LEN(CONVERT(nvarchar(max),text)) * 2acdn
                   ELSE statement_end_offsetacdn
              END - t2.statement_start_offset)/2)acdn
        FROM sys.dm_exec_sql_text(t2.sql_handle)) , 'Not currently executing')acdn
    , query_plan=(SELECT query_plan from sys.dm_exec_query_plan(t2.plan_handle))acdn
fromacdn
    (Select session_id, request_idacdn
    , task_alloc_pages=sum(internal_objects_alloc_page_count +   user_objects_alloc_page_count)acdn
    , task_dealloc_pages = sum (internal_objects_dealloc_page_count + user_objects_dealloc_page_count)acdn
    from sys.dm_db_task_space_usageacdn
    group by session_id, request_id) as t1acdn
left join sys.dm_exec_requests as t2 onacdn
    t1.session_id = t2.session_idacdn
    and t1.request_id = t2.request_idacdn
left join sys.dm_exec_sessions as s1 onacdn
    t1.session_id=s1.session_idacdn
whereacdn
    t1.session_id > 50 -- ignore system unless you suspect there's a problem thereacdn
    and t1.session_id <> @@SPID -- ignore this request itselfacdn
order by t1.task_alloc_pages DESC;acdn
GOacdnacdnSELECT  SS.session_id ,        SS.database_id ,acdn
        CAST(SS.user_objects_alloc_page_count / 128 AS DECIMAL(15, 2)) [Total Allocation User Objects MB] ,acdn
        CAST(( SS.user_objects_alloc_page_countacdn
               - SS.user_objects_dealloc_page_count ) / 128 AS DECIMAL(15, 2)) [Net Allocation User Objects MB] ,acdn
        CAST(SS.internal_objects_alloc_page_count / 128 AS DECIMAL(15, 2)) [Total Allocation Internal Objects MB] ,acdn
        CAST(( SS.internal_objects_alloc_page_countacdn
               - SS.internal_objects_dealloc_page_count ) / 128 AS DECIMAL(15,acdn
                                                              2)) [Net Allocation Internal Objects MB] ,acdn
        CAST(( SS.user_objects_alloc_page_countacdn
               + internal_objects_alloc_page_count ) / 128 AS DECIMAL(15, 2)) [Total Allocation MB] ,acdn
        CAST(( SS.user_objects_alloc_page_countacdn
               + SS.internal_objects_alloc_page_countacdn
               - SS.internal_objects_dealloc_page_countacdn
               - SS.user_objects_dealloc_page_count ) / 128 AS DECIMAL(15, 2)) [Net Allocation MB] ,acdn
        T.text [Query Text]acdn
FROM    sys.dm_db_session_space_usage SSacdn
        LEFT JOIN sys.dm_exec_connections CN ON CN.session_id = SS.session_idacdn
        OUTER APPLY sys.dm_exec_sql_text(CN.most_recent_sql_handle) T