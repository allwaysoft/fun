USE thetweb
GO
SELECT *
FROM sys.Tables
order by name
GO 

use ektron76
SELECT o.name,
  ddps.row_count 
FROM sys.indexes AS i
  INNER JOIN sys.objects AS o ON i.OBJECT_ID = o.OBJECT_ID
  INNER JOIN sys.dm_db_partition_stats AS ddps ON i.OBJECT_ID = ddps.OBJECT_ID
  AND i.index_id = ddps.index_id 
WHERE i.index_id < 2  
AND   o.is_ms_shipped = 0 
ORDER BY o.NAME

order by row_count desc 


select * from dtproperties


--sp_MSforeachtable @command1='EXEC sp_spaceused ''?''',@whereand='or OBJECTPROPERTY(o.id, N''IsSystemTable'') = 1'

use ektron76
SELECT  OBJECT_NAME([ddps].[object_id]) AS [table_name] ,
    SUM([ddps].[row_count]) AS  [row_count] ,
    SUM([ddps].[used_page_count]*8) AS  [space_used_KB] ,
    SUM([ddps].[in_row_data_page_count]) AS  [in_row_data_page_count] ,
    SUM([ddps].[in_row_used_page_count])  AS [in_row_used_page_count] ,
    SUM([ddps].[in_row_reserved_page_count])  AS [in_row_reserved_page_count] ,
    SUM([ddps].[lob_used_page_count]) AS  [lob_used_page_count] ,
    SUM([ddps].[lob_reserved_page_count])  AS [lob_reserved_page_count] ,
    SUM([ddps].[row_overflow_used_page_count])  AS [row_overflow_used_page_count] ,
    SUM([ddps].[row_overflow_reserved_page_count])  AS [row_overflow_reserved_page_count] ,
    SUM([ddps].[used_page_count]) AS  [used_page_count] ,
    SUM([ddps].[reserved_page_count])  AS [reserved_page_count]
FROM    [sys].[dm_db_partition_stats] AS ddps
    INNER JOIN [sys].[tables] AS t ON [ddps].[object_id] = [t].[object_id]
GROUP BY [ddps].[object_id]
ORDER by table_name