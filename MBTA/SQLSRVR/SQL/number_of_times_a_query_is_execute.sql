SELECT  
       sdest.dbid  
       ,sdest.[text] AS Batch_Object, 
       SUBSTRING(sdest.[text], (sdeqs.statement_start_offset/2) + 1, 
       ((CASE sdeqs.statement_end_offset 
               WHEN -1 THEN DATALENGTH(sdest.[text]) ELSE sdeqs.statement_end_offset END 
                       - sdeqs.statement_start_offset)/2) + 1) AS SQL_Statement 
       , sdeqp.query_plan  
       , sdeqs.execution_count 
       , sdeqs.total_physical_reads 
       ,(sdeqs.total_physical_reads / sdeqs.execution_count) AS average_physical_reads 
       , sdeqs.total_logical_writes 
       , (sdeqs.total_logical_writes / sdeqs.execution_count) AS average_logical_writes 
       , sdeqs.total_logical_reads 
       , (sdeqs.total_logical_reads / sdeqs.execution_count) AS average_logical_lReads 
       , sdeqs.total_clr_time 
       , (sdeqs.total_clr_time / sdeqs.execution_count) AS average_CLRTime 
       , sdeqs.total_elapsed_time 
       , (sdeqs.total_elapsed_time / sdeqs.execution_count) AS average_elapsed_time 
       , sdeqs.last_execution_time 
       , sdeqs.creation_time  
FROM sys.dm_exec_query_stats AS sdeqs 
       CROSS apply sys.dm_exec_sql_text(sdeqs.sql_handle) AS sdest 
       CROSS apply sys.dm_exec_query_plan(sdeqs.plan_handle) AS sdeqp 
WHERE  sdeqs.last_execution_time > DATEADD(HH,-2,GETDATE())  
               --AND sdest.dbid = (SELECT DB_ID('AdventureWorks')) 
ORDER BY execution_count DESC 