BEGIN

--
-- NOTE: PLEASE PASS APPROPRIATE VALUE TO @LOGICAL_DISK_NAME PARAMETER BEFORE RUNNING THE SCRIPT. THIS SCRIPT NEEDS THE BACKUP DEVICE CREATED IN ADVANCE, THAT NAME IS USED AS -- VALU TO THE PARAMETER @LOGICAL_DISK_NAME 
--

Declare @logical_disk_name varchar(100)
Declare @DBName            varchar(500)
declare @backupSetId       int

set @DBName = DB_NAME()
Set @logical_disk_name = --'kranthi_test_db_back' 

exec ('BACKUP DATABASE [' + @DBName + '] ' 
    + 'TO ' + @logical_disk_name + ' WITH RETAINDAYS = 1000, NOFORMAT, NOINIT,  NAME = N'''
    + @DBName + '-Full Database Backup'', SKIP, NOREWIND, NOUNLOAD,  STATS = 10, CHECKSUM')

set @backupSetId = (select position 
                      from msdb..backupset 
                     where database_name=N'kranthi_test' 
                       and backup_set_id=(select max(backup_set_id) 
                                            from msdb..backupset 
                                           where database_name=N'kranthi_test'
                                         )
                   )

print @backupsetid

if @backupSetId is null 
begin 
raiserror(N'Verify failed. Backup information for database ''kranthi_test'' not found.', 16, 1) 
end
exec ('RESTORE VERIFYONLY '
+ 'FROM  '
+ @logical_disk_name
+ ' WITH  FILE = '
+ @backupSetId 
+ ',  NOUNLOAD,  NOREWIND')
END