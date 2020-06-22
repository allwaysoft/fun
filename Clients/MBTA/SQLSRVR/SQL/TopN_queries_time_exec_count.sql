Please see below for the top N query, all the columns in the select have a comment explaining about what they mean. Below stats are re evaluated after every time SQL gets compiled.

SELECT DISTINCT TOP 100
dbid, t.TEXT QueryName,
s.creation_time Compile_Time,            --Most recent Compile time of SQL
s.execution_count AS ExecutionCount,     --Number of Times SQL has been executed after it was compiled
ISNULL(s.execution_count / NULLIF(DATEDIFF(s, s.creation_time, GETDATE()), 0), 0) AS ExecutionsPerSec,
--s.max_elapsed_time AS MaxElapsedTime,  --Max time taken by a particular execution of SQL in Micro Seconds
ISNULL(s.total_elapsed_time / 1000 / NULLIF(s.execution_count, 0), 0) AS AvgElapsedTime_milliSecs,     --Average(of all executions) time to execute SQL in milli secs
ISNULL(s.total_worker_time / 1000 / NULLIF(s.execution_count, 0), 0) AS AvgCPUTime_milliSecs,  --Average (of all executions) CPU time to execute SQL in milli secs
ISNULL(s.total_logical_reads / NULLIF(s.execution_count, 0), 0) AS AvgLogicalReads,
ISNULL(s.total_physical_reads / NULLIF(s.execution_count, 0), 0) AS AvgPhysicalReads,
ISNULL(s.total_logical_Writes / NULLIF(s.execution_count, 0), 0) AS AvgLogicalWrites
FROM sys.dm_exec_query_stats s
CROSS APPLY sys.dm_exec_sql_text( s.sql_handle ) t
where s.creation_time <= getdate()-1
ORDER BY executioncount desc, AvgCPUTime_milliSecs desc   

Note: Activity Monitor in SQL Server, which we saw earlier, shows information about the most expensive queries that have been run on the instance over the last 30 seconds.
