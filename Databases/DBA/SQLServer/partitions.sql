--Partitioned table and indexes internals
https://www.red-gate.com/simple-talk/sql/database-administration/gail-shaws-sql-server-howlers/ --partitioning and indexes
https://dbafromthecold.com/2018/02/21/indexing-and-partitioning/https://www.mssqltips.com/sqlservertip/5296/implementation-of-sliding-window-partitioning-in-sql-server-to-purge-data/ --simple sliding window partitionning example
http://blogs.microsoft.co.il/yaniv_etrogi/2016/08/15/automate-partitions-management-sliding-window/ --Extensive code base to automate partition maintenance for most partitions of a DB
--Partitions with low and high range values of each partition and number of rows for each partition. 
-- This query can be used for multiple purposes, 1. find all tables using a partition scheme, finf all schemes using a partition function and so on....exec master.dbo.SPGetAllPartitions
--OR
use accounting
go
SELECT
OBJECT_SCHEMA_NAME(pstats.object_id) AS SchemaName
,OBJECT_NAME(pstats.object_id) AS TableName
,ps.name AS PartitionSchemeName
,ds.name AS PartitionFilegroupName
,pf.name AS PartitionFunctionName
,CASE pf.boundary_value_on_right WHEN 0 THEN 'Range Left' ELSE 'Range Right' END AS PartitionFunctionRange
,CASE pf.boundary_value_on_right WHEN 0 THEN 'Upper Boundary' ELSE 'Lower Boundary' END AS PartitionBoundary
,prv.value AS PartitionBoundaryValue
,c.name AS PartitionKey
,CASE 
WHEN pf.boundary_value_on_right = 0 
THEN c.name + ' > ' + CAST(ISNULL(LAG(prv.value) OVER(PARTITION BY pstats.object_id ORDER BY pstats.object_id, pstats.partition_number), 'Infinity') AS VARCHAR(100)) + ' and ' + c.name + ' <= ' + CAST(ISNULL(prv.value, 'Infinity') AS VARCHAR(100)) 
ELSE c.name + ' >= ' + CAST(ISNULL(prv.value, 'Infinity') AS VARCHAR(100)) + ' and ' + c.name + ' < ' + CAST(ISNULL(LEAD(prv.value) OVER(PARTITION BY pstats.object_id ORDER BY pstats.object_id, pstats.partition_number), 'Infinity') AS VARCHAR(100))
END AS PartitionRange
,pstats.partition_number AS PartitionNumber
,p.rows
,pstats.row_count AS PartitionRowCount
,p.data_compression_desc AS DataCompression
FROM sys.dm_db_partition_stats AS pstats
INNER JOIN sys.partitions AS p ON pstats.partition_id = p.partition_id
INNER JOIN sys.destination_data_spaces AS dds ON pstats.partition_number = dds.destination_id
INNER JOIN sys.data_spaces AS ds ON dds.data_space_id = ds.data_space_id
INNER JOIN sys.partition_schemes AS ps ON dds.partition_scheme_id = ps.data_space_id
INNER JOIN sys.partition_functions AS pf ON ps.function_id = pf.function_id
INNER JOIN sys.indexes AS i ON pstats.object_id = i.object_id AND pstats.index_id = i.index_id AND dds.partition_scheme_id = i.data_space_id AND i.type <= 1 /* Heap or Clustered Index */
INNER JOIN sys.index_columns AS ic ON i.index_id = ic.index_id AND i.object_id = ic.object_id AND ic.partition_ordinal > 0
INNER JOIN sys.columns AS c ON pstats.object_id = c.object_id AND ic.column_id = c.column_id
LEFT JOIN sys.partition_range_values AS prv ON pf.function_id = prv.function_id AND pstats.partition_number = (CASE pf.boundary_value_on_right WHEN 0 THEN prv.boundary_id ELSE (prv.boundary_id+1) END)
where 1=1
--and pstats.object_id = object_id('accounting.dbo.custHoldings')
--and ps.name = 'PS_QuarterlyDateDT'
--and pf.name = 'PF_QuarterlyDateDT'
ORDER BY TableName, PartitionNumber desc;
Go
--OR
use accounting
go
declare @TableName varchar(100) = 'custHoldings'
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
--OR
use accounting
go
select i.Name, ps.Name PartitionScheme, pf.name PartitionFunction
 from sys.indexes i
 join sys.partition_schemes ps on ps.data_space_id = i.data_space_id
 join sys.partition_functions pf on pf.function_id = ps.function_id
where i.object_id = object_id('accounting.dbo.custHoldings')
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--All partitin functions and ranges for a given database
use accounting
goEXEC [master].[dbo].[SPGetPartitionSchemes] 
--OR
select f.name as NameHere,f.type_desc as TypeHere
,(case when f.boundary_value_on_right=0 then 'LEFT' else 'Right' end) as LeftORRightHere
,v.value,v.boundary_id,t.name from sys.partition_functions f
inner join  sys.partition_range_values v
on f.function_id = v.function_id
inner join sys.partition_parameters p
on f.function_id = p.function_id
inner join sys.types t
on t.system_type_id = p.system_type_id
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--SWITCH partitions
    https://www.cathrinewilhelmsen.net/2015/04/19/table-partitioning-in-sql-server-partition-switching/ --Had to do switch partitions for SOPS-769
--STEP.1 - Create custHoldings_archive_20190820 backup table to hold the deleted data for custHoldings table
CREATE TABLE [dbo].[custHoldings_archive_20190820](
  [SourceId] [int] NOT NULL,
  [AsOfDate] [date] NOT NULL,
  [CustAcctCode] [varchar](16) NOT NULL,
  [CustIdentifier] [varchar](16) NOT NULL,
  [PortfolioOldCode] [varchar](3) NULL,
  [PrimaryIdentifier] [varchar](16) NULL,
  [PrimaryIdentifierId] [int] NULL,
  [Nominal] [float] NULL,
  [ReasonCode] [int] NULL,
  [Cusip] [varchar](12) NULL,
  [CusipIdentifierId] [int] NULL,
  [Sedol] [varchar](12) NULL,
  [SedolIdentifierId] [int] NULL,
  [BloombergGlobalID] [varchar](64) NULL,
  [REDCode] [varchar](20) NULL,
  [AcadianIDKey] [bigint] NULL,
  [AcadianIDTypeID] [int] NULL,
  [AcadianIDSourceID] [int] NULL,
  [AcadianID] [varchar](255) NULL,
 CONSTRAINT [PK_custHoldings_archive_20190820] PRIMARY KEY CLUSTERED 
(
  [AsOfDate] ASC,
  [CustAcctCode] ASC,
  [CustIdentifier] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, DATA_COMPRESSION = PAGE) ON [PS_QuarterlyDateDT]([AsOfDate])
) ON [PS_QuarterlyDateDT]([AsOfDate])
GOSET ANSI_PADDING ON
GOCREATE NONCLUSTERED INDEX [idx_custHoldings_archive_20190820_CustAcctCode_CustIdentifier] ON [dbo].[custHoldings_archive_20190820]
(
  [CustAcctCode] ASC,
  [CustIdentifier] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, FILLFACTOR = 80, DATA_COMPRESSION = PAGE) ON [PS_QuarterlyDateDT]([AsOfDate])
GOCREATE STATISTICS [stat_PortfolioOldCode] ON [dbo].[custHoldings_archive_20190820]([PortfolioOldCode])
GOEXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Bloomberg Global ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'custHoldings_archive_20190820', @level2type=N'COLUMN',@level2name=N'BloombergGlobalID'
GOEXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Markit RED Code for CDS Trades' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'custHoldings_archive_20190820', @level2type=N'COLUMN',@level2name=N'REDCode'
GO--STEP.2 - purge data in custHoldings table older than Jan 1st 2019
ALTER TABLE accounting.dbo.custHoldings SWITCH PARTITION 78 to accounting.dbo.custHoldings_archive_20190820 PARTITION 78;
ALTER TABLE accounting.dbo.custHoldings SWITCH PARTITION 79 to accounting.dbo.custHoldings_archive_20190820 PARTITION 79;
ALTER TABLE accounting.dbo.custHoldings SWITCH PARTITION 80 to accounting.dbo.custHoldings_archive_20190820 PARTITION 80;
ALTER TABLE accounting.dbo.custHoldings SWITCH PARTITION 81 to accounting.dbo.custHoldings_archive_20190820 PARTITION 81;
ALTER TABLE accounting.dbo.custHoldings SWITCH PARTITION 82 to accounting.dbo.custHoldings_archive_20190820 PARTITION 82;
ALTER TABLE accounting.dbo.custHoldings SWITCH PARTITION 83 to accounting.dbo.custHoldings_archive_20190820 PARTITION 83;
ALTER TABLE accounting.dbo.custHoldings SWITCH PARTITION 84 to accounting.dbo.custHoldings_archive_20190820 PARTITION 84;
ALTER TABLE accounting.dbo.custHoldings SWITCH PARTITION 85 to accounting.dbo.custHoldings_archive_20190820 PARTITION 85;
ALTER TABLE accounting.dbo.custHoldings SWITCH PARTITION 86 to accounting.dbo.custHoldings_archive_20190820 PARTITION 86;
ALTER TABLE accounting.dbo.custHoldings SWITCH PARTITION 87 to accounting.dbo.custHoldings_archive_20190820 PARTITION 87;
ALTER TABLE accounting.dbo.custHoldings SWITCH PARTITION 88 to accounting.dbo.custHoldings_archive_20190820 PARTITION 88;
ALTER TABLE accounting.dbo.custHoldings SWITCH PARTITION 89 to accounting.dbo.custHoldings_archive_20190820 PARTITION 89;
ALTER TABLE accounting.dbo.custHoldings SWITCH PARTITION 90 to accounting.dbo.custHoldings_archive_20190820 PARTITION 90;
ALTER TABLE accounting.dbo.custHoldings SWITCH PARTITION 91 to accounting.dbo.custHoldings_archive_20190820 PARTITION 91;
ALTER TABLE accounting.dbo.custHoldings SWITCH PARTITION 92 to accounting.dbo.custHoldings_archive_20190820 PARTITION 92;
ALTER TABLE accounting.dbo.custHoldings SWITCH PARTITION 93 to accounting.dbo.custHoldings_archive_20190820 PARTITION 93;
ALTER TABLE accounting.dbo.custHoldings SWITCH PARTITION 94 to accounting.dbo.custHoldings_archive_20190820 PARTITION 94;
ALTER TABLE accounting.dbo.custHoldings SWITCH PARTITION 95 to accounting.dbo.custHoldings_archive_20190820 PARTITION 95;
ALTER TABLE accounting.dbo.custHoldings SWITCH PARTITION 96 to accounting.dbo.custHoldings_archive_20190820 PARTITION 96;
ALTER TABLE accounting.dbo.custHoldings SWITCH PARTITION 97 to accounting.dbo.custHoldings_archive_20190820 PARTITION 97;
ALTER TABLE accounting.dbo.custHoldings SWITCH PARTITION 98 to accounting.dbo.custHoldings_archive_20190820 PARTITION 98;
ALTER TABLE accounting.dbo.custHoldings SWITCH PARTITION 99 to accounting.dbo.custHoldings_archive_20190820 PARTITION 99;
ALTER TABLE accounting.dbo.custHoldings SWITCH PARTITION 100 to accounting.dbo.custHoldings_archive_20190820 PARTITION 100;
ALTER TABLE accounting.dbo.custHoldings SWITCH PARTITION 101 to accounting.dbo.custHoldings_archive_20190820 PARTITION 101;
ALTER TABLE accounting.dbo.custHoldings SWITCH PARTITION 102 to accounting.dbo.custHoldings_archive_20190820 PARTITION 102;
ALTER TABLE accounting.dbo.custHoldings SWITCH PARTITION 103 to accounting.dbo.custHoldings_archive_20190820 PARTITION 103;
ALTER TABLE accounting.dbo.custHoldings SWITCH PARTITION 104 to accounting.dbo.custHoldings_archive_20190820 PARTITION 104;
ALTER TABLE accounting.dbo.custHoldings SWITCH PARTITION 105 to accounting.dbo.custHoldings_archive_20190820 PARTITION 105;
GO
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Locks on partitions
SELECT   OBJECT_NAME(p.object_id) AS table_name,
         p.index_id,
         p.partition_number,
         SUM(p.rows) AS sum_rows,
         dtl.resource_type,
         dtl.request_mode,
         dtl.request_type,
         dtl.request_status,
         COUNT(*) AS records
FROM     sys.dm_tran_locks AS dtl
JOIN     sys.partitions AS p
ON dtl.resource_associated_entity_id = p.partition_id
WHERE    dtl.request_session_id = 56
and p.object_id = object_id('accounting.dbo.custHoldings')
GROUP BY OBJECT_NAME(p.object_id),
         p.index_id,
         p.partition_number,
         dtl.resource_type,
         dtl.request_mode,
         dtl.request_type,
         dtl.request_status
ORDER BY p.partition_number;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------