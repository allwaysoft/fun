--Backups at Acadian are trigger through Agent jobs on most servers----------------------------------------------------------------------------------------------------------------------------------------------
--When was a DB last restoredSELECT 
   [rs].[destination_database_name], 
   [rs].[restore_date], 
   [bs].[backup_start_date], 
   [bs].[backup_finish_date], 
   [bs].[database_name] as [source_database_name], 
   [bmf].[physical_device_name] as [backup_file_used_for_restore]
FROM msdb..restorehistory rs
INNER JOIN msdb..backupset bs ON [rs].[backup_set_id] = [bs].[backup_set_id]
INNER JOIN msdb..backupmediafamily bmf ON [bs].[media_set_id] = [bmf].[media_set_id] 
ORDER BY [rs].[restore_date] DESC/*
destination_database_name  The name of the database that has been restored.
restore_date   The time at which the restore command was started.
backup_start_date The time at which the backup command was started.
backup_finish_date   The time at which the backup command completed.
source_database_name The name of the database after it was restored.
backup_file_used_for_restore  The file(s) that the restore used in the RESTORE command
*/--Last SQL server start time
select * from sys.dm_server_services
SELECT sqlserver_start_time FROM sys.dm_os_sys_info--Database create time
SELECT create_date, st.*
FROM sys.databases st


------------------------------------------------------------------------------------------------------------------------------------------------Had an issue with ROR DB stuck in restoring state and we had to restore the whole DB from primary. 
/*
--Could have tried below but didn't.
  https://support.managed.com/kb/a398/how-to-repair-a-suspect-database-in-mssql.aspx
  EXEC sp_resetstatus [YourDatabase];
  ALTER DATABASE [YourDatabase] SET EMERGENCY
  DBCC checkdb([YourDatabase])
  ALTER DATABASE [YourDatabase] SET SINGLE_USER WITH ROLLBACK IMMEDIATE
  DBCC CheckDB ([YourDatabase], REPAIR_ALLOW_DATA_LOSS)
  ALTER DATABASE [YourDatabase] SET MULTI_USER
*/
--Restore a DB from primary to ROR
1. Remove from AG
2. Restore DB with no RECOVERY
3. Add to AG--Below script will generate a restore script
--Optimize sql server restore https://www.mssqltips.com/sqlservertip/4935/optimize-sql-server-database-restore-performance/
--For restoring to a dev environment form production environment with moving files to the same location as SOURCE (prod), use below. This canbe run from snap server with sqldev account to check how the script to restore looks like.

/*
$result = Restore-DbaDatabase -SqlInstance 'use1-sbox-db01.sandbox.acadian.am' -Path '\\use1-prod-db01.acadian.am\BACKUP\EC2AMAZ-OSST82Q\BISAMDW\FULL','\\use1-prod-db01.acadian.am\BACKUP\EC2AMAZ-OSST82Q\BISAMDW\DIFF' -MaxTransferSize 4194304 -BufferCount 20 -WithReplace -ReuseSourceFolderStructure -KeepCDC -OutputScriptOnly 
$result | Out-File -Filepath C:\DBA\misc\restore.sql
*/
DECLARE @databaseName sysname
DECLARE @backupStartDate datetime
DECLARE @backup_set_id_start INT
DECLARE @backup_set_id_end INT
DECLARE @backup_set_id_FULL INTSET @databaseName = 'FactorModel';
SELECT @backup_set_id_FULL = MAX(backup_set_id) 
   FROM  msdb.dbo.backupset 
   WHERE database_name = @databaseName AND type = 'D'SELECT @backup_set_id_start = MAX(backup_set_id) 
   FROM  msdb.dbo.backupset 
   WHERE database_name = @databaseName AND type = 'I'SELECT @backup_set_id_end = MIN(backup_set_id) 
   FROM  msdb.dbo.backupset 
   WHERE database_name = @databaseName AND type = 'D'
   AND backup_set_id > @backup_set_id_startIF @backup_set_id_end IS NULL SET @backup_set_id_end = 999999999;select -10 backup_set_id,'-- DBCC TRACEON (3213, -1) Turning this flag on before the restore and then running the restore will show the pages restored and time taken and MB per second restored'
UNION
select -9 backup_set_id,'-- DBCC TRACEON (3605, -1) Turning this flag will show more details about the memoery limt and other stats of a restore in the sql server log. The list of stats with this flag is more comprehencive than the above flag'
UNION
select -5 backup_set_id, ' RESTORE DATABASE '  + @databaseName + ' FROM ' +
stuff((
      SELECT --','+' DISK = '''+ physical_device_name + ''''
      ','+' DISK = '''+ physical_device_name + ''' '
     FROM msdb.dbo.backupset b,
         msdb.dbo.backupmediafamily mf
          where b.media_set_id = mf.media_set_id 
        and b.database_name = @databaseName
          AND b.backup_set_id = @backup_set_id_FULL
      ORDER BY family_sequence_number
      FOR XML PATH('')
),1,1,'')
+ ' WITH NORECOVERY, REPLACE, STATS = 1, MAXTRANSFERSIZE = 4194304, BUFFERCOUNT = 10 '
UNION --Above is full
select -1 backup_set_id, ' RESTORE DATABASE '  + @databaseName + ' FROM ' +
stuff((
      SELECT --','+' DISK = '''+ physical_device_name + ''''
      ','+' DISK = '''+ physical_device_name + ''' '
     FROM msdb.dbo.backupset b,
         msdb.dbo.backupmediafamily mf
          where b.media_set_id = mf.media_set_id 
        and b.database_name = @databaseName
          AND b.backup_set_id = @backup_set_id_start
      ORDER BY family_sequence_number
      FOR XML PATH('')
),1,1,'')
+ ' WITH NORECOVERY, REPLACE, STATS = 1, MAXTRANSFERSIZE = 4194304, BUFFERCOUNT = 10 '
UNION --Above is diff
SELECT backup_set_id, 'RESTORE DATABASE ' + @databaseName + ' FROM DISK = ''' 
          + mf.physical_device_name + ''' WITH NORECOVERY'
   FROM  msdb.dbo.backupset b,
          msdb.dbo.backupmediafamily mf
   WHERE b.media_set_id = mf.media_set_id
          AND b.database_name = @databaseName
          AND b.backup_set_id >= @backup_set_id_start AND b.backup_set_id < @backup_set_id_end
          AND b.type = 'L'
UNION -- Above is Log
SELECT 999999999 AS backup_set_id, 'RESTORE DATABASE ' + @databaseName + ' WITH RECOVERY'
ORDER BY backup_set_id;
-- Above is to recover
GO


----------------------------------------------------------------------------------------------------------------------------------------------
--Verify if backup is valid
RESTORE VERIFYONLY from disk = 'D:\.\.\db.bak'--Check restore completion percentage. Below qery might show as 99.9999% complete and spend time there because of zeroing out of log files to the size they were on the backedup database at the time backup was taken. 
SELECT session_id as SPID, command, a.text AS Query, start_time, percent_complete, dateadd(second,estimated_completion_time/1000, getdate()) as estimated_completion_time
FROM sys.dm_exec_requests r CROSS APPLY sys.dm_exec_sql_text(r.sql_handle) a
WHERE r.command in ('BACKUP DATABASE','RESTORE DATABASE')


----------------------------------------------------------------------------------------------------------------------------------------------
--Backup location of a DB (physical_device_name is the column which has this info)SELECT  
   distinct CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server, 
   msdb.dbo.backupset.database_name,  
   msdb.dbo.backupset.backup_start_date,  
   msdb.dbo.backupset.backup_finish_date, 
 CAST((DATEDIFF(second,  msdb.dbo.backupset.backup_start_date,msdb.dbo.backupset.backup_finish_date)) AS varchar)+ ' secs  ' AS [Total Time] ,   Cast(msdb.dbo.backupset.backup_size/1024/1024 AS numeric(10,2)) AS 'Backup Size(MB)',   
   msdb.dbo.backupset.name AS backupset_name
FROM   msdb.dbo.backupmediafamily  
   INNER JOIN msdb.dbo.backupset ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id   
--Enter your database below
and database_name = 'BISAMDW'
and msdb.dbo.backupset.backup_start_date>'2019-10-01' and msdb.dbo.backupset.backup_start_date<'2019-10-31 23:59:59'
ORDER BY  
   msdb.dbo.backupset.database_name, 
   msdb.dbo.backupset.backup_start_date
select a.server_name, a.database_name, backup_finish_date, a.backup_size,
CASE a.[type] -- Let's decode the three main types of backup here
 WHEN 'D' THEN 'Full'
 WHEN 'I' THEN 'Differential'
 WHEN 'L' THEN 'Transaction Log'
 ELSE a.[type]
END as BackupType
 ,b.physical_device_name
from msdb.dbo.backupset a 
join msdb.dbo.backupmediafamily b on a.media_set_id = b.media_set_id
where a.database_name Like 'BISAMDW%'
and a.backup_start_date>'2019-10-01' and a.backup_start_date<'2019-10-31 23:59:59'
and a.[type] = 'D'
order by a.backup_finish_date desc
----------------------------------------------------------------------------------------------------------------------------------------------