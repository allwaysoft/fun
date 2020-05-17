SELECT 
statement AS [database.scheme.table],
column_id , column_name, column_usage, 
migs.user_seeks, migs.user_scans, 
migs.last_user_seek, migs.avg_total_user_cost,
migs.avg_user_impact
FROM sys.dm_db_missing_index_details AS mid
CROSS APPLY sys.dm_db_missing_index_columns (mid.index_handle)
INNER JOIN sys.dm_db_missing_index_groups AS mig 
ON mig.index_handle = mid.index_handle
INNER JOIN sys.dm_db_missing_index_group_stats  AS migs 
ON mig.index_group_handle=migs.group_handle
ORDER BY mig.index_group_handle, mig.index_handle, column_id
GO




http://blog.sqlauthority.com/2011/01/03/sql-server-2008-missing-index-script-download/

SELECT TOP 25
dm_mid.database_id AS DatabaseID,
dm_migs.avg_user_impact*(dm_migs.user_seeks+dm_migs.user_scans) Avg_Estimated_Impact,
dm_migs.last_user_seek AS Last_User_Seek,
OBJECT_NAME(dm_mid.OBJECT_ID,dm_mid.database_id) AS [TableName],
'CREATE INDEX [IX_' + OBJECT_NAME(dm_mid.OBJECT_ID,dm_mid.database_id) + '_'
+ REPLACE(REPLACE(REPLACE(ISNULL(dm_mid.equality_columns,''),', ','_'),'[',''),']','') +
CASE
WHEN dm_mid.equality_columns IS NOT NULL AND dm_mid.inequality_columns IS NOT NULL THEN '_'
ELSE ''
END
+ REPLACE(REPLACE(REPLACE(ISNULL(dm_mid.inequality_columns,''),', ','_'),'[',''),']','')
+ ']'
+ ' ON ' + dm_mid.statement
+ ' (' + ISNULL (dm_mid.equality_columns,'')
+ CASE WHEN dm_mid.equality_columns IS NOT NULL AND dm_mid.inequality_columns IS NOT NULL THEN ',' ELSE
'' END
+ ISNULL (dm_mid.inequality_columns, '')
+ ')'
+ ISNULL (' INCLUDE (' + dm_mid.included_columns + ')', '') AS Create_Statement
FROM sys.dm_db_missing_index_groups dm_mig
INNER JOIN sys.dm_db_missing_index_group_stats dm_migs
ON dm_migs.group_handle = dm_mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details dm_mid
ON dm_mig.index_handle = dm_mid.index_handle
WHERE dm_mid.database_ID = DB_ID()
ORDER BY Avg_Estimated_Impact DESC
GO


http://sqlserverpedia.com/wiki/Find_Missing_Indexes#T-SQL_Code

/* ------------------------------------------------------------------
-- Title:	FindMissingIndexes
-- Author:	Brent Ozar
-- Date:	2009-04-01 
-- Modified By: Clayton Kramer <CKRAMER.KRAMER gmail.com @>
-- Description: This query returns indexes that SQL Server 2005 
-- (and higher) thinks are missing since the last restart. The 
-- "Impact" column is relative to the time of last restart and how 
-- bad SQL Server needs the index. 10 million+ is high.
-- Changes: Updated to expose full table name. This makes it easier
-- to identify which database needs an index. Modified the 
-- CreateIndexStatement to use the full table path and include the
-- equality/inequality columns for easier identifcation.
------------------------------------------------------------------ */

SELECT  
	[Impact] = (avg_total_user_cost * avg_user_impact) * (user_seeks + user_scans),  
	[Table] = [statement],
	[CreateIndexStatement] = 'CREATE NONCLUSTERED INDEX ix_' 
		+ sys.objects.name COLLATE DATABASE_DEFAULT 
		+ '_' 
		+ REPLACE(REPLACE(REPLACE(ISNULL(mid.equality_columns,'')+ISNULL(mid.inequality_columns,''), '[', ''), ']',''), ', ','_')
		+ ' ON ' 
		+ [statement] 
		+ ' ( ' + IsNull(mid.equality_columns, '') 
		+ CASE WHEN mid.inequality_columns IS NULL THEN '' ELSE 
			CASE WHEN mid.equality_columns IS NULL THEN '' ELSE ',' END 
		+ mid.inequality_columns END + ' ) ' 
		+ CASE WHEN mid.included_columns IS NULL THEN '' ELSE 'INCLUDE (' + mid.included_columns + ')' END 
		+ ';', 
	mid.equality_columns,
	mid.inequality_columns,
	mid.included_columns
FROM sys.dm_db_missing_index_group_stats AS migs 
	INNER JOIN sys.dm_db_missing_index_groups AS mig ON migs.group_handle = mig.index_group_handle 
	INNER JOIN sys.dm_db_missing_index_details AS mid ON mig.index_handle = mid.index_handle 
	INNER JOIN sys.objects WITH (nolock) ON mid.OBJECT_ID = sys.objects.OBJECT_ID 
WHERE (migs.group_handle IN 
		(SELECT TOP (500) group_handle 
		FROM sys.dm_db_missing_index_group_stats WITH (nolock) 
		ORDER BY (avg_total_user_cost * avg_user_impact) * (user_seeks + user_scans) DESC))  
	AND OBJECTPROPERTY(sys.objects.OBJECT_ID, 'isusertable') = 1 
ORDER BY [Impact] DESC , [CreateIndexStatement] DESC


--------------------------------------------------------------------------
--------------------------------------------------------------------------

/* Formatted on 02/23/2012 10:13:04 (QP5 v5.185.11230.41888) */
SELECT   'CREATE INDEX IX_Auto_'
       + CONVERT (varchar (MAX), MID.index_handle)
       + ' ON '
       + [statement] + ' (' 
       + COALESCE(equality_columns + ', ' 
       + inequality_columns, equality_columns, inequality_columns) 
       + ')' + ISNULL(' INCLUDE (' + included_columns + ')', '') AS create_statement
     , CONVERT(int, avg_total_user_cost * user_seeks * avg_user_impact) AS potential_saving
     , [statement] AS table_name
     , equality_columns
     , inequality_columns
     , included_columns
     , last_user_seek
     , avg_total_user_cost
     , user_seeks
     , avg_user_impact 
FROM   sys.dm_db_missing_index_details MID JOIN sys.dm_db_missing_index_groups MIG ON MIG.index_handle = MID.index_handle 
                                           JOIN sys.dm_db_missing_index_group_stats MIGS on MIGS.group_handle = MIG.index_group_handle 
--where lower(statement) = 'thetweb'                                           
ORDER BY  avg_total_user_cost * user_seeks * avg_user_impact DESC