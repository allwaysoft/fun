/*
-> CTE vs TEMP Table
CTE no stats but temp tables could have stats-> Some times even though two plans look a like the 'Number of rows Read' vs 'Actual rows Read' might be different in the 
same step of two look a like plans. So, check for rows of each step of the two similar plans to determine which is better.
--For Example: Below two queires gave the exact same plan at 1st look but hovering over that particular step of the two plans showed 
that the plan with DATEPART function on cloumn read much more rows compared to the other query.
declare @startYear int;
set @startYear = 2019;
select *  FROM [].[dbo].[geoHoliday]
where HolidayDate between CAST(@startYear AS VARCHAR(4)) + '0101' and CAST(@startYear+1 AS VARCHAR(4)) + '1231'
--versus
select HolidayDate,IsoCountryCode,NoFx,NoSettlement,NoTrading
   FROM [].[dbo].[geoHoliday]
   where DATEPART(YEAR, HolidayDate) >=  2019        -- current year holidays
   AND DATEPART(YEAR, HolidayDate) <=  2020  Separate the SQL in to two instead of using below
(where rs.AccountCode = @PortfolioOldCode or rs.AccountCode is null)   

->Usually, there are only three server level parameters that need tweeking to make sql server faster
   Max server memory
   cost threshold for parallelism
   MAXDOP
*/

--Memory grants on table
SELECT mg.granted_memory_kb, mg.session_id, t.text, qp.query_plan
FROM sys.dm_exec_query_memory_grants AS mg
CROSS APPLY sys.dm_exec_sql_text(mg.sql_handle) AS t
CROSS APPLY sys.dm_exec_query_plan(mg.plan_handle) AS qp
ORDER BY 1 DESC OPTION (MAXDOP 1)
---------------------------------------------------------------------------------------------------------------------------------------------GetTable Rows
sp_spaceused 'stkSandPASXConstituentData'
--OR
--Can get at Partition level too using below
USE DataMart -- replace your dbname
GO
SELECT
s.Name AS SchemaName,
t.Name AS TableName,
p.rows AS RowCounts,
CAST(ROUND((SUM(a.used_pages) / 128.00), 2) AS NUMERIC(36, 2)) AS Used_MB,
CAST(ROUND((SUM(a.total_pages) - SUM(a.used_pages)) / 128.00, 2) AS NUMERIC(36, 2)) AS Unused_MB,
CAST(ROUND((SUM(a.total_pages) / 128.00), 2) AS NUMERIC(36, 2)) AS Total_MB
FROM sys.tables t
INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_id
INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_id
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_id
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
where t.Name in ('AccountDailyReturnsBiSam','AccountDailyReturnsLegacy','AccountMonthlyReturnsBiSam','AccountMonthlyReturnsLegacy','DivIncomeReturns','RiskfreeDailyReturns','RiskfreeMonthlyReturns','MarketValues')
GROUP BY t.Name, s.Name, p.Rows
ORDER BY s.Name, t.Name
GO--Partitions with low and high range values of each partition and number of rows for each partition
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object]
     , p.partition_number AS [p#]
     , fg.name AS [filegroup]
     , p.rows
     , au.total_pages AS pages
     , CASE boundary_value_on_right
       WHEN 1 THEN 'less than'
       ELSE 'less than or equal to' END as comparison
     , rv.value
     , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) +
       SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20),
       CONVERT (INT, SUBSTRING (au.first_page, 4, 1) +
       SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) +
       SUBSTRING (au.first_page, 1, 1))) AS first_page
FROM sys.partitions p
INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_id
INNER JOIN sys.objects o ON p.object_id = o.object_id
INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_id
INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_id
INNER JOIN sys.partition_functions f ON f.function_id = ps.function_id
INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_number
INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_id
LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_id
WHERE i.index_id < 2 
AND o.object_id = OBJECT_ID(@TableName)
order by p.partition_number;
---------------------------------------------------------------------------------------------------------------------------------------------Last gather stats on a table
use Reference
GO
SELECT DB_NAME() AS DatabaseName,
SCHEMA_NAME(t.[schema_id]) AS SchemaName,
t.name AS TableName,
ix.name AS IndexName,
STATS_DATE(ix.id,ix.indid) AS 'StatsLastUpdate', -- using STATS_DATE function
ix.rowcnt AS 'RowCount',
ix.rowmodctr AS '#RowsChanged',
CAST((CAST(ix.rowmodctr AS DECIMAL(20,8))/CAST(ix.rowcnt AS DECIMAL(20,2)) * 100.0) AS DECIMAL(20,2)) AS '%RowsChanged'
FROM sys.sysindexes ix
INNER JOIN sys.tables t ON t.[object_id] = ix.[id]
WHERE ix.id > 100 -- excluding system object statistics
and t.name = 'refIssuerMarketData'
AND ix.indid > 0 -- excluding heaps or tables that do not any indexes
AND ix.rowcnt >= 500 -- only indexes with more than 500 rows
ORDER BY  [%RowsChanged] DESC
-------------------------------------------------------------------------------------------------------------------------------------------
--Get column statistics, cardinality of a column and histograms
--target is the Name of the index, statistics, or column for which to display statistics information. target is enclosed in brackets, single quotes, double quotes, or no quotes. 
--If an automatically created statistic does not exist for a column target, error message 2767 is returned. In SQL Data Warehouse and Parallel Data Warehouse, target cannot be a column name.
-- DBCC SHOW_STATISTICS ( table_name , target ) 
DBCC SHOW_STATISTICS ("dbo.hfaHoldings",Fund)
---------------

--Update statistics    
   update statistics refIdentifier WITH SAMPLE 20 PERCENT
   update statistics refIdentifier(IDX_refIdentifier_ValidTo_IdentifierTypeID) WITH FULLSCAN
-------------------------------------------------------------------------------------------------------------------------------------------
--DML Activity on table since the last SQL Server instance start
use accounting --Do not forget to change this before running below
go
select OBJECT_NAME(iu.object_id), i.name, last_user_update, *
from sys.indexes i
left join sys.dm_db_index_usage_stats iu on iu.index_id = i.index_id and iu.object_id = i.object_id
where database_id = db_id('accounting')
and iu.object_id = OBJECT_ID('accounting.dbo.hfaHoldings')
-------------------------------------------------------------------------------------------------------------------------------------------
--Get plans from cache, run below query to find the plan handle for an SQL
select qs.sql_handle, plan_handle, creation_time, last_execution_time, execution_count, qt.text
FROM sys.dm_exec_query_stats qs   
CROSS APPLY sys.dm_exec_sql_text (qs.[sql_handle]) as qt
where qt.text like '%select max(convert(smalldatetime, FactorDate))%';ORSELECT  plan_handle, t.text
FROM sys.dm_exec_cached_plans AS p
CROSS APPLY sys.dm_exec_sql_text(p.plan_handle) AS t
WHERE t.[text] LIKE N'%select max(convert(smalldatetime, FactorDate))%';ORSELECT 'DBCC FREEPROCCACHE(',cp.plan_handle,');', st.[text]
FROM sys.dm_exec_cached_plans AS cp 
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS st
WHERE [text] LIKE '%SPrptGetCrFactorAncillaryData%'--Get Plan from Plan Handle
select * from sys.dm_exec_query_plan(0x06003A005B6C092770780C59F500000001000000000000000000000000000000000000000000000000000000);  --Run below to remove plan from cache for a specific plan handle
DBCC FREEPROCCACHE (0x06000100E596C505309951E77300000001000000000000000000000000000000000000000000000000000000); --This could either be plan_handle or sql_handle. Plan_handle is for only one plan and sql_handle for all plans of that particular SQL--Last resort to clear cache at system level.
DBCC FREESYSTEMCACHE ('ALL', default); 
-------------------------------------------------------------------------------------------------------------------------------------------
--Compare query performance before and after, run below to drop the buffers from memory
Checkpoint;
DBCC dropcleanbuffers
DBCC FREEPROCCACHE; 
DBCC FREESYSTEMCACHE('ALL')
set statistics IO on --Fast way to invalidate SQL cache
USE ; 
GO 
EXEC sp_recompile N'dbo.SomeSP'; 
GO 
-------------------------------------------------------------------------------------------------------------------------------------------
--Fragmentation on a table/index without partitions
select * from sys.indexes where [object_id] = OBJECT_ID('dbo.RM_EWMAVolRatio_RootMeanDailyZScore'); --get index on table and se below to fin fragmentation

use wtan
GO
SELECT dbschemas.[name] as 'Schema', indexstats.partition_number,
dbtables.[name] as 'Table',
dbindexes.[name] as 'Index',
indexstats.avg_fragmentation_in_percent,
indexstats.page_count
FROM sys.dm_db_index_physical_stats (DB_ID(), OBJECT_ID('dbo.RM_EWMAVolRatio_RootMeanDailyZScore'), 1, NULL, 'LIMITED') AS indexstats   --Third value here is the index id which can be obtained from sys.indexes.
INNER JOIN sys.tables dbtables on dbtables.[object_id] = indexstats.[object_id]
INNER JOIN sys.schemas dbschemas on dbtables.[schema_id] = dbschemas.[schema_id]
INNER JOIN sys.indexes AS dbindexes ON dbindexes.[object_id] = indexstats.[object_id] AND indexstats.index_id = dbindexes.index_id--Fragmentation on a table/index with partitions
select * from sys.indexes where [object_id] = OBJECT_ID('dbo.RM_EWMAVolRatio_RootMeanDailyZScore'); 

use Reference
GO
SELECT dbschemas.[name] as 'Schema', indexstats.partition_number,
dbtables.[name] as 'Table',
dbindexes.[name] as 'Index',
indexstats.avg_fragmentation_in_percent,
indexstats.page_count,
lv.value leftValue, rv.value rightValue
FROM sys.dm_db_index_physical_stats (DB_ID('accounting'), OBJECT_ID('accounting.dbo.hfaHoldings'), 1, NULL, 'LIMITED') AS indexstats   --Third value here is the index id which can be obtained from sys.indexes.
INNER JOIN sys.tables dbtables on dbtables.[object_id] = indexstats.[object_id]
INNER JOIN sys.schemas dbschemas on dbtables.[schema_id] = dbschemas.[schema_id]
INNER JOIN sys.indexes AS dbindexes ON dbindexes.[object_id] = indexstats.[object_id] AND indexstats.index_id = dbindexes.index_id
INNER JOIN sys.partitions p on p.hobt_id = indexstats.hobt_id
INNER JOIN sys.allocation_units a on p.hobt_id = a.container_id
INNER join sys.partition_schemes s on dbindexes.data_space_id = s.data_space_id
INNER join sys.partition_functions f on s.function_id = f.function_id
left join sys.partition_range_values rv on f.function_id = rv.function_id and p.partition_number = rv.boundary_id
left join sys.partition_range_values lv on f.function_id = lv.function_id and p.partition_number - 1 = lv.boundary_id
WHERE 1=1 
--and dbindexes.name = 'idx_refSecurityMarketData_RefSecurityID_CloseDate_RefIdentifierID_TurnoverUSD'
ORDER BY indexstats.avg_fragmentation_in_percent desc, partition_number asc;
-------------------------------------------------------------------------------------------------------------------------------------------
--Index usage and last DML on table
use accounting --Do not forget to change this before running below
go
select OBJECT_NAME(iu.object_id), last_user_update, i.name, *
from sys.dm_db_index_usage_stats iu
join sys.indexes i on iu.index_id = i.index_id and iu.object_id = i.object_id
where database_id = db_id('accounting')
and iu.object_id = OBJECT_ID('accounting.dbo.hfaHoldings')select object_name(a.[object_id]) as [object name], 
       i.[name] as [index name], 
       a.leaf_insert_count, 
       a.leaf_update_count, 
       a.leaf_delete_count 
from   sys.dm_db_index_operational_stats (null,null,null,null ) a 
       inner join sys.indexes as i 
         on i.[object_id] = a.[object_id] 
            and i.index_id = a.index_id 
where database_id = db_id('accounting')
and a.object_id = OBJECT_ID('accounting.dbo.hfaHoldings')select * from   sys.dm_db_index_operational_stats (null,null,null,null ) a where  database_id = 7 and object_id = 2027154267--Histogram of an Index column showing the distinct values and range values of the column data
   --range_high_key  sql_variant Upper bound column value for a histogram step. The column value is also called a key value.
   --range_rows   real  Estimated number of rows whose column value falls within a histogram step, excluding the upper bound.
   --equal_rows   real  Estimated number of rows whose column value equals the upper bound of the histogram step.
   --distinct_range_rows   bigint   Estimated number of rows with a distinct column value within a histogram step, excluding the upper bound.
   --average_range_rows real  Average number of rows with duplicate column values within a histogram step, excluding the upper bound (RANGE_ROWS / DISTINCT_RANGE_ROWS for DISTINCT_RANGE_ROWS > 0).
DBCC SHOW_STATISTICS ("RM_EWMAVolRatio_RootMeanDailyZScore",PK_RM_EWMAVolRatio_RootMeanDailyZScore) with histogram; -- table name and index name
-------------------------------------------------------------------------------------------------------------------------------------------
--Last gather stats on a table
use Reference
GO
SELECT DB_NAME() AS DatabaseName,
SCHEMA_NAME(t.[schema_id]) AS SchemaName,
t.name AS TableName,
ix.name AS IndexName,
STATS_DATE(ix.id,ix.indid) AS 'StatsLastUpdate', -- using STATS_DATE function
ix.rowcnt AS 'RowCount',
ix.rowmodctr AS '#RowsChanged',
CAST((CAST(ix.rowmodctr AS DECIMAL(20,8))/CAST(ix.rowcnt AS DECIMAL(20,2)) * 100.0) AS DECIMAL(20,2)) AS '%RowsChanged'
FROM sys.sysindexes ix
INNER JOIN sys.tables t ON t.[object_id] = ix.[id]
WHERE ix.id > 100 -- excluding system object statistics
and t.name = 'refIssuerMarketData'
AND ix.indid > 0 -- excluding heaps or tables that do not any indexes
AND ix.rowcnt >= 500 -- only indexes with more than 500 rows
ORDER BY  [%RowsChanged] DESC
-------------------------------------------------------------------------------------------------------------------------------------------