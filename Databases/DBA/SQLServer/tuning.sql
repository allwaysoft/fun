/*ACDN
-> CTE vs TEMP TableACDN
CTE no stats but temp tables could have statsACDNACDN-> Some times even though two plans look a like the 'Number of rows Read' vs 'Actual rows Read' might be different in the ACDN
same step of two look a like plans. So, check for rows of each step of the two similar plans to determine which is better.ACDN
--For Example: Below two queires gave the exact same plan at 1st look but hovering over that particular step of the two plans showed ACDN
that the plan with DAREPART function on cloumn read much more rows compared to the other query.ACDNACDNdeclare @startYear int;ACDN
set @startYear = 2019;ACDN
select *  FROM [acdn].[dbo].[geoHoliday]ACDN
where HolidayDate between CAST(@startYear AS VARCHAR(4)) + '0101' and CAST(@startYear+1 AS VARCHAR(4)) + '1231'ACDN
--versusACDN
select HolidayDate,IsoCountryCode,NoFx,NoSettlement,NoTradingACDN
   FROM [acdn].[dbo].[geoHoliday]ACDN
   where DATEPART(YEAR, HolidayDate) >=  2019        -- current year holidaysACDN
   AND DATEPART(YEAR, HolidayDate) <=  2020  ACDNACDNSeparate the SQL in to two instead of using belowACDN
(where rs.AccountCode = @PortfolioOldCode or rs.AccountCode is null)   ACDNACDNUsually, there are only three server level parameters that need tweeking to make sql server fasterACDN
   Max server memoryACDN
   cost threshold for parallelismACDN
   MAXDOPACDN
*/ACDNACDN--Memory grants on tableACDN
SELECT mg.granted_memory_kb, mg.session_id, t.text, qp.query_planACDN
FROM sys.dm_exec_query_memory_grants AS mgACDN
CROSS APPLY sys.dm_exec_sql_text(mg.sql_handle) AS tACDN
CROSS APPLY sys.dm_exec_query_plan(mg.plan_handle) AS qpACDN
ORDER BY 1 DESC OPTION (MAXDOP 1)ACDN
-------------------------------------------------------------------------------------------------------------------------------------------ACDNACDNACDN--GetTable RowsACDN
sp_spaceused 'stkSandPASXConstituentData'ACDN
--ORACDN
--Can get at Partition level too using belowACDN
USE DataMart -- replace your dbnameACDN
GOACDN
SELECTACDN
s.Name AS SchemaName,ACDN
t.Name AS TableName,ACDN
p.rows AS RowCounts,ACDN
CAST(ROUND((SUM(a.used_pages) / 128.00), 2) AS NUMERIC(36, 2)) AS Used_MB,ACDN
CAST(ROUND((SUM(a.total_pages) - SUM(a.used_pages)) / 128.00, 2) AS NUMERIC(36, 2)) AS Unused_MB,ACDN
CAST(ROUND((SUM(a.total_pages) / 128.00), 2) AS NUMERIC(36, 2)) AS Total_MBACDN
FROM sys.tables tACDN
INNER JOIN sys.indexes i ON t.OBJECT_ID = i.object_idACDN
INNER JOIN sys.partitions p ON i.object_id = p.OBJECT_ID AND i.index_id = p.index_idACDN
INNER JOIN sys.allocation_units a ON p.partition_id = a.container_idACDN
INNER JOIN sys.schemas s ON t.schema_id = s.schema_idACDN
where t.Name in ('AccountDailyReturnsBiSam','AccountDailyReturnsLegacy','AccountMonthlyReturnsBiSam','AccountMonthlyReturnsLegacy','DivIncomeReturns','RiskfreeDailyReturns','RiskfreeMonthlyReturns','MarketValues')ACDN
GROUP BY t.Name, s.Name, p.RowsACDN
ORDER BY s.Name, t.NameACDN
GOACDNACDN--Partitions with low and high range values of each partition and number of rows for each partitionACDN
SELECT SCHEMA_NAME(o.schema_id) + '.' + OBJECT_NAME(i.object_id) AS [object]ACDN
     , p.partition_number AS [p#]ACDN
     , fg.name AS [filegroup]ACDN
     , p.rowsACDN
     , au.total_pages AS pagesACDN
     , CASE boundary_value_on_rightACDN
       WHEN 1 THEN 'less than'ACDN
       ELSE 'less than or equal to' END as comparisonACDN
     , rv.valueACDN
     , CONVERT (VARCHAR(6), CONVERT (INT, SUBSTRING (au.first_page, 6, 1) +ACDN
       SUBSTRING (au.first_page, 5, 1))) + ':' + CONVERT (VARCHAR(20),ACDN
       CONVERT (INT, SUBSTRING (au.first_page, 4, 1) +ACDN
       SUBSTRING (au.first_page, 3, 1) + SUBSTRING (au.first_page, 2, 1) +ACDN
       SUBSTRING (au.first_page, 1, 1))) AS first_pageACDN
FROM sys.partitions pACDN
INNER JOIN sys.indexes i ON p.object_id = i.object_id AND p.index_id = i.index_idACDN
INNER JOIN sys.objects o ON p.object_id = o.object_idACDN
INNER JOIN sys.system_internals_allocation_units au ON p.partition_id = au.container_idACDN
INNER JOIN sys.partition_schemes ps ON ps.data_space_id = i.data_space_idACDN
INNER JOIN sys.partition_functions f ON f.function_id = ps.function_idACDN
INNER JOIN sys.destination_data_spaces dds ON dds.partition_scheme_id = ps.data_space_id AND dds.destination_id = p.partition_numberACDN
INNER JOIN sys.filegroups fg ON dds.data_space_id = fg.data_space_idACDN
LEFT OUTER JOIN sys.partition_range_values rv ON f.function_id = rv.function_id AND p.partition_number = rv.boundary_idACDN
WHERE i.index_id < 2 ACDN
AND o.object_id = OBJECT_ID(@TableName)ACDN
order by p.partition_number;ACDN
-------------------------------------------------------------------------------------------------------------------------------------------ACDNACDNACDN--Last gather stats on a tableACDN
use ReferenceACDN
GOACDN
SELECT DB_NAME() AS DatabaseName,ACDN
SCHEMA_NAME(t.[schema_id]) AS SchemaName,ACDN
t.name AS TableName,ACDN
ix.name AS IndexName,ACDN
STATS_DATE(ix.id,ix.indid) AS 'StatsLastUpdate', -- using STATS_DATE functionACDN
ix.rowcnt AS 'RowCount',ACDN
ix.rowmodctr AS '#RowsChanged',ACDN
CAST((CAST(ix.rowmodctr AS DECIMAL(20,8))/CAST(ix.rowcnt AS DECIMAL(20,2)) * 100.0) AS DECIMAL(20,2)) AS '%RowsChanged'ACDN
FROM sys.sysindexes ixACDN
INNER JOIN sys.tables t ON t.[object_id] = ix.[id]ACDN
WHERE ix.id > 100 -- excluding system object statisticsACDN
and t.name = 'refIssuerMarketData'ACDN
AND ix.indid > 0 -- excluding heaps or tables that do not any indexesACDN
AND ix.rowcnt >= 500 -- only indexes with more than 500 rowsACDN
ORDER BY  [%RowsChanged] DESCACDN
-------------------------------------------------------------------------------------------------------------------------------------------ACDNACDNACDN--Get column statistics, cardinality of a column and histogramsACDN
--target is the Name of the index, statistics, or column for which to display statistics information. target is enclosed in brackets, single quotes, double quotes, or no quotes. ACDN
--If an automatically created statistic does not exist for a column target, error message 2767 is returned. In SQL Data Warehouse and Parallel Data Warehouse, target cannot be a column name.ACDN
-- DBCC SHOW_STATISTICS ( table_name , target ) ACDN
DBCC SHOW_STATISTICS ("dbo.hfaHoldings",Fund)ACDN
---------------ACDN
--Update statisticsACDN
    ACDN
   update statistics refIdentifier WITH SAMPLE 20 PERCENTACDN
   update statistics refIdentifier(IDX_refIdentifier_ValidTo_IdentifierTypeID) WITH FULLSCANACDN
-------------------------------------------------------------------------------------------------------------------------------------------ACDNACDNACDN--DML Activity on table since the last SQL Server instance startACDN
use accounting --Do not forget to change this before running belowACDN
goACDN
select OBJECT_NAME(iu.object_id), i.name, last_user_update, *ACDN
from sys.indexes iACDN
left join sys.dm_db_index_usage_stats iu on iu.index_id = i.index_id and iu.object_id = i.object_idACDN
where database_id = db_id('accounting')ACDN
and iu.object_id = OBJECT_ID('accounting.dbo.hfaHoldings')ACDN
-------------------------------------------------------------------------------------------------------------------------------------------ACDNACDNACDN--Get plans from cache, run below query to find the plan handle for an SQLACDN
select qs.sql_handle, plan_handle, creation_time, last_execution_time, execution_count, qt.textACDN
FROM sys.dm_exec_query_stats qs   ACDN
CROSS APPLY sys.dm_exec_sql_text (qs.[sql_handle]) as qtACDN
where qt.text like '%select max(convert(smalldatetime, FactorDate))%';ACDNACDNORACDNACDNSELECT  plan_handle, t.textACDN
FROM sys.dm_exec_cached_plans AS pACDN
CROSS APPLY sys.dm_exec_sql_text(p.plan_handle) AS tACDN
WHERE t.[text] LIKE N'%select max(convert(smalldatetime, FactorDate))%';ACDNACDNORACDNACDNSELECT 'DBCC FREEPROCCACHE(',cp.plan_handle,');', st.[text]ACDN
FROM sys.dm_exec_cached_plans AS cp ACDN
CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS stACDN
WHERE [text] LIKE '%SPrptGetCrFactorAncillaryData%'ACDNACDN--Get Plan from Plan HandleACDN
select * from sys.dm_exec_query_plan(0x06003A005B6C092770780C59F500000001000000000000000000000000000000000000000000000000000000);  ACDNACDN--Run below to remove plan from cache for a specific plan handleACDN
DBCC FREEPROCCACHE (0x06000100E596C505309951E77300000001000000000000000000000000000000000000000000000000000000); --This could either be plan_handle or sql_handle. Plan_handle is for only one plan and sql_handle for all plans of that particular SQLACDNACDN--Last resort to clear cache at system level.ACDN
DBCC FREESYSTEMCACHE ('ALL', default); ACDNACDN
-------------------------------------------------------------------------------------------------------------------------------------------ACDNACDNACDN--Compare query performance before and after, run below to drop the buffers from memoryACDN
Checkpoint;ACDN
DBCC dropcleanbuffersACDN
DBCC FREEPROCCACHE; ACDN
DBCC FREESYSTEMCACHE('ALL')ACDN
set statistics IO on ACDNACDN--Fast way to invalidate SQL cacheACDN
USE acdn; ACDN
GO ACDN
EXEC sp_recompile N'dbo.SomeSP'; ACDN
GO ACDN
-------------------------------------------------------------------------------------------------------------------------------------------ACDNACDNACDN--Fragmentation on a table/index without partitionsACDN
select * from sys.indexes where [object_id] = OBJECT_ID('dbo.RM_EWMAVolRatio_RootMeanDailyZScore'); --get index on table and se below to fin fragmentationACDNACDNuse wtanACDN
GOACDN
SELECT dbschemas.[name] as 'Schema', indexstats.partition_number,ACDN
dbtables.[name] as 'Table',ACDN
dbindexes.[name] as 'Index',ACDN
indexstats.avg_fragmentation_in_percent,ACDN
indexstats.page_countACDN
FROM sys.dm_db_index_physical_stats (DB_ID(), OBJECT_ID('dbo.RM_EWMAVolRatio_RootMeanDailyZScore'), 1, NULL, 'LIMITED') AS indexstats   --Third value here is the index id which can be obtained from sys.indexes.ACDN
INNER JOIN sys.tables dbtables on dbtables.[object_id] = indexstats.[object_id]ACDN
INNER JOIN sys.schemas dbschemas on dbtables.[schema_id] = dbschemas.[schema_id]ACDN
INNER JOIN sys.indexes AS dbindexes ON dbindexes.[object_id] = indexstats.[object_id] AND indexstats.index_id = dbindexes.index_idACDNACDN--Fragmentation on a table/index with partitionsACDN
select * from sys.indexes where [object_id] = OBJECT_ID('dbo.RM_EWMAVolRatio_RootMeanDailyZScore'); ACDNACDNuse ReferenceACDN
GOACDN
SELECT dbschemas.[name] as 'Schema', indexstats.partition_number,ACDN
dbtables.[name] as 'Table',ACDN
dbindexes.[name] as 'Index',ACDN
indexstats.avg_fragmentation_in_percent,ACDN
indexstats.page_count,ACDN
lv.value leftValue, rv.value rightValueACDN
FROM sys.dm_db_index_physical_stats (DB_ID('accounting'), OBJECT_ID('accounting.dbo.hfaHoldings'), 1, NULL, 'LIMITED') AS indexstats   --Third value here is the index id which can be obtained from sys.indexes.ACDN
INNER JOIN sys.tables dbtables on dbtables.[object_id] = indexstats.[object_id]ACDN
INNER JOIN sys.schemas dbschemas on dbtables.[schema_id] = dbschemas.[schema_id]ACDN
INNER JOIN sys.indexes AS dbindexes ON dbindexes.[object_id] = indexstats.[object_id] AND indexstats.index_id = dbindexes.index_idACDN
INNER JOIN sys.partitions p on p.hobt_id = indexstats.hobt_idACDN
INNER JOIN sys.allocation_units a on p.hobt_id = a.container_idACDN
INNER join sys.partition_schemes s on dbindexes.data_space_id = s.data_space_idACDN
INNER join sys.partition_functions f on s.function_id = f.function_idACDN
left join sys.partition_range_values rv on f.function_id = rv.function_id and p.partition_number = rv.boundary_idACDN
left join sys.partition_range_values lv on f.function_id = lv.function_id and p.partition_number - 1 = lv.boundary_idACDN
WHERE 1=1 ACDN
--and dbindexes.name = 'idx_refSecurityMarketData_RefSecurityID_CloseDate_RefIdentifierID_TurnoverUSD'ACDN
ORDER BY indexstats.avg_fragmentation_in_percent desc, partition_number asc;ACDN
-------------------------------------------------------------------------------------------------------------------------------------------ACDNACDNACDN--Index usage and last DML on tableACDN
use accounting --Do not forget to change this before running belowACDN
goACDN
select OBJECT_NAME(iu.object_id), last_user_update, i.name, *ACDN
from sys.dm_db_index_usage_stats iuACDN
join sys.indexes i on iu.index_id = i.index_id and iu.object_id = i.object_idACDN
where database_id = db_id('accounting')ACDN
and iu.object_id = OBJECT_ID('accounting.dbo.hfaHoldings')ACDNACDNselect object_name(a.[object_id]) as [object name], ACDN
       i.[name] as [index name], ACDN
       a.leaf_insert_count, ACDN
       a.leaf_update_count, ACDN
       a.leaf_delete_count ACDN
from   sys.dm_db_index_operational_stats (null,null,null,null ) a ACDN
       inner join sys.indexes as i ACDN
         on i.[object_id] = a.[object_id] ACDN
            and i.index_id = a.index_id ACDN
where database_id = db_id('accounting')ACDN
and a.object_id = OBJECT_ID('accounting.dbo.hfaHoldings')ACDNACDNselect * from   sys.dm_db_index_operational_stats (null,null,null,null ) a where  database_id = 7 and object_id = 2027154267ACDNACDN--Histogram of an Index column showing the distinct values and range values of the column dataACDN
   --range_high_key  sql_variant Upper bound column value for a histogram step. The column value is also called a key value.ACDN
   --range_rows   real  Estimated number of rows whose column value falls within a histogram step, excluding the upper bound.ACDN
   --equal_rows   real  Estimated number of rows whose column value equals the upper bound of the histogram step.ACDN
   --distinct_range_rows   bigint   Estimated number of rows with a distinct column value within a histogram step, excluding the upper bound.ACDN
   --average_range_rows real  Average number of rows with duplicate column values within a histogram step, excluding the upper bound (RANGE_ROWS / DISTINCT_RANGE_ROWS for DISTINCT_RANGE_ROWS > 0).ACDN
DBCC SHOW_STATISTICS ("RM_EWMAVolRatio_RootMeanDailyZScore",PK_RM_EWMAVolRatio_RootMeanDailyZScore) with histogram; -- table name and index nameACDN
-------------------------------------------------------------------------------------------------------------------------------------------ACDNACDNACDN--Last gather stats on a tableACDN
use ReferenceACDN
GOACDN
SELECT DB_NAME() AS DatabaseName,ACDN
SCHEMA_NAME(t.[schema_id]) AS SchemaName,ACDN
t.name AS TableName,ACDN
ix.name AS IndexName,ACDN
STATS_DATE(ix.id,ix.indid) AS 'StatsLastUpdate', -- using STATS_DATE functionACDN
ix.rowcnt AS 'RowCount',ACDN
ix.rowmodctr AS '#RowsChanged',ACDN
CAST((CAST(ix.rowmodctr AS DECIMAL(20,8))/CAST(ix.rowcnt AS DECIMAL(20,2)) * 100.0) AS DECIMAL(20,2)) AS '%RowsChanged'ACDN
FROM sys.sysindexes ixACDN
INNER JOIN sys.tables t ON t.[object_id] = ix.[id]ACDN
WHERE ix.id > 100 -- excluding system object statisticsACDN
and t.name = 'refIssuerMarketData'ACDN
AND ix.indid > 0 -- excluding heaps or tables that do not any indexesACDN
AND ix.rowcnt >= 500 -- only indexes with more than 500 rowsACDN
ORDER BY  [%RowsChanged] DESCACDN
-------------------------------------------------------------------------------------------------------------------------------------------