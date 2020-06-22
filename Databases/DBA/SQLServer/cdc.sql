--Acadian specific CDC steps
1. Disable enable CDC script for the new table
2. Go to http://bos-dbclus5n1/ and click buttons
3. ChangeData database metadata schema has all the cdc related history and tables
4. ChangeData database loader schema has RunQueue has the run history
5. There is a SSIS package and SP created as part of CDC setup. The SP has a bug when it comes to case insensitive vs case sensitive columns
6. There is a agent job which runs and initializes the tables
7. Load ChangeData agent job sends out an error email if there is any issue with the setup    Load change data sends a message via rabbit mq to another service
    I think it’s name is SqlServerCDCReplication
    It is a service in windows
    It triggers a stored proc which is auto generated-Slava, are you mentioning the process which moves data from transactional sql server to WH sql server? like CORE to WH? I think Suchi is asking for the process which moves data from ChangeData DB on WH server to Datawarehouse DB on WH server. I might be completely off track here.
-Kranthi Pabba It is part of the same process. the service calls a stored procedure to merge data from ChangeData to WH
-SP will be in the format loader.SPcdcMergeChanges_warehouse_<TableName>/****** Script for SelectTopNRows command from SSMS  ******/
SELECT *  FROM [ChangeData].[metadata].[CollectionTables] where SourceName='bnkCustodian'
select * from ChangeData.metadata.TargetTables where name='bnkCustodian'
SELECT TOP (1000) * FROM [DataWarehouse].[loader].[RunQueue] where ChangeDataTable='Acadian.bnkCustodian'
--Run the below on the BISAM upgraded environment if issues with CDC after restore form an higher environment to lower environment
https://git.acadian-asset.com/bisam/database-mssql-upgrade/blob/master/BISAM/BISAMDW/Scripts/Upgrade/03-EnableCDC/20_BISAMDW_ReEnable_CDC_On_Tables.sql<https://teams.microsoft.com/l/message/19:e59dbe51b7a3400d943b31f448b7936a@thread.skype/1571332621982?tenantId=7b318b14-c275-4ecf-99f3-48e008c4014f&amp;groupId=34e35f14-3354-4d24-87f7-9c5976101ed5&amp;parentMessageId=1571332537617&amp;teamName=DBOPS&amp;channelName=General&amp;createdTime=1571332621982>--CDC null and 0 issue. 
https://acadian-asset.atlassian.net/browse/POPS-114--General steps to setup CDC in SQL Server
use Acadiandrop table tcreate table t (a varchar(5), b varchar(5), PRIMARY KEY (a))alter table t add d varchar(5) default 'defdd'insert into t (a,b) values ('1','a')update t set a = '10' where a = '1'select * from tUSE Acadian  
GO  
EXEC sys.sp_cdc_enable_table  
@source_schema = N'dbo',  
@source_name   = N't',  
@role_name     = NULL,  
@supports_net_changes = 1  
GO  
  
select * from Acadian.[cdc].dbo_t_CTselect * from performance.dbo.aumAssetMatrix where PortfolioOldCode in ('485','369') order by MonthEndDate
select * from performance.dbo.aumAssetMatrix where IncludeInFirmAum is nullselect * from performance.cdc.dbo_aumAssetMatrix_CTUSE Acadian  
GO

EXEC sys.sp_cdc_disable_table  
@source_schema = N'dbo',  
@source_name   = N't',  
@capture_instance = N'dbo_t'  
GO 

select * from cdc.captured_columns
-- Highlevel flow of CDC at Acadian
Source tables are usually in core or some other transactional database servers of Acadian
select * from [performance].[dbo].[aumAssetMatrix]      --Main table
select * from [performance].[cdc].[dbo_aumAssetMatrix_CT] --CDC collected data of the main table on the source side. Under system tables folder
Destination tables are usually in EDW of Acadian (BOS-DBWH02)
DB Name ChangeData
select * from [ChangeData].[Acadian].[aumAssetMatrix]   --Destination table. This is populated by an AB job //10.3.20.197/DatabaseOperations2/Database Operations/DataWarehouse/Load ChangeData. This triggers a sql agent job (Load ChangeData) on DW, which inturn triggers an exe SqlServerCdcCollector.exe
select * from [DataWarehouse].[warehouse].[aumAssetMatrix]  --Final destination table used for reporting. This is populated by a windows service which runs on DW (SqlServerReplication). This service calls a procedure similar to loader.SPcdcMergeChanges_warehouse_aumAssetMatrix in DataWarehouse DB 
-- Issue: CDC null and 0 issue. 
https://acadian-asset.atlassian.net/browse/POPS-114
--when this happens, disable cdc, update the column with default value, enable cdc
or
if the column alreayd has no NULL values, disable cdc, update the column to itself, enable cdc-- Issue: CDC table not replicated to the final table in DataWarehouse DB. Which means data is fine in the ChangeData DB of DW
https://acadian-asset.atlassian.net/wiki/spaces/DO/pages/459964783/How+to+fix+collation+issue+in+CDC+Replication+process+to+Datawarehouse
select * from DataWarehouse.metadata.ChangeDataSubscriptions where ChangeDataTableID = OBJECT_ID('ChangeData.FeedHistory.idxMSCICustomIndexData') --Check if the filed Isenable is marked as 1
If it is set to 0, update the table to set it to 1 and restart the cluster service SqlServerReplication on DW machine
If after restart, it is reset to 0 again, there should be an email which should go out to DataMartAlerts@Acadian-Asset.com which shows what caused the failure. Check the email and act accordingly. If the issue is related to collation the fix the loader merge proc(loader.SPcdcMergeChanges_warehouse_aumAssetMatrix) for the column which is causint the collation issue
Then renable and restart the service and see if it works, if not. Table has to be reseeded
--Check all DBs where CDC is enabled
select name, is_cdc_enabled from sys.databases--Check if table has CDC enabled --RUN IN RESPECTIVE DB
SELECT s.name AS Schema_Name, tb.name AS Table_Name
, tb.object_id, tb.type, tb.type_desc, tb.is_tracked_by_cdc
FROM sys.tables tb
INNER JOIN sys.schemas s on s.schema_id = tb.schema_id
WHERE tb.is_tracked_by_cdc = 1
and tb.name = 'GPrcCode';--Enable CDC, change the parameters accordingly
--After enabling CDC, it creates a _CT table in system tables of the database and should create a capture and clean agent jobs for the database with name cdc.---
https://stackoverflow.com/questions/23744083/cdc-is-enabled-but-cdc-dbotable-name-ct-table-is-not-being-populated/23747007
https://stackoverflow.com/questions/40922497/missing-cdc-capture-job-when-enabling-cdc-on-table-in-sql-server
USE qai  
GO  
  
EXEC sys.sp_cdc_enable_table  
@source_schema = N'dbo',  
@source_name   = N'GPrcCode',  
@role_name     = N'CDCRole',  
@filegroup_name = N'CDC',  
@supports_net_changes = 1  
GO  --Disable CDC, Change the parameters accordinly
USE qai;  
GO  
EXECUTE sys.sp_cdc_disable_table   
    @source_schema = N'dbo',   
    @source_name = N'GPrcCode',  
    @capture_instance = N'dbo_GPrcCode';  EXECUTE sys.sp_cdc_help_change_data_capture
@source_schema = N'dbo',  
@source_name   = N'GPrcCode'
EXEC sys.sp_cdc_add_job @job_type = N'capture';
GOEXEC sys.sp_cdc_add_job @job_type = N'cleanup';--Below queries assist in finding time associate with a start ane end lsn data present in _CT table of cdc capture
SELECT [__$start_lsn]
      ,[__$end_lsn]
      ,[__$seqval]
      ,[__$operation]
      ,[__$update_mask]
      ,[Type_]
      ,[Code]
      ,[Desc_]
      ,[__$command_id]
  FROM [qai].[cdc].[dbo_GPrcCode_CT]
  
select * from cdc.lsn_time_mapping
select sys.fn_cdc_map_lsn_to_time ( 0x001C68EA00038E530099 )  --Below can also be obtained by querying  FeedHistory.[cdc].dbo_idxMSCICustomIndexData_CT directly
DECLARE @from_lsn binary(10), @to_lsn binary(10);  
SET @from_lsn = sys.fn_cdc_get_min_lsn('dbo_idxMSCICustomIndexData');  
SET @to_lsn   = sys.fn_cdc_get_max_lsn();  
SELECT * FROM FeedHistory.cdc.fn_cdc_get_all_changes_dbo_idxMSCICustomIndexData
  (@from_lsn, @to_lsn, N'all');  
GO  select distinct PortfolioOldCode
from [cdc].[fn_cdc_get_all_changes_dbo_ph_staging_table](0x001C68EA0006D1820093,0x001C68EA00105DFE003F,'all')
