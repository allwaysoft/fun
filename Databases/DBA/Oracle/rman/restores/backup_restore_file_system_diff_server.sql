-- Awsome example of how to duplicate from a backup just from a backup with only auxiliary connection
http://www.oracle-base.com/articles/11g/duplicate-database-using-rman-11gr2.php#backup_based_duplication

--####################### WORKED ################
--### Backup of the DB which is used to clone
--###############################################
1. take backup of the DB which is used for cloning.
rman target / log=$ORACLE_BASE/admin/scripts/logs_$ORACLE_SID/hrprd_backup_filesystem_`date +"%m_%d_%y-%H.%M.%S"`.log

--CONFIGURE CHANNEL DEVICE TYPE DISK FORMAT   '+hrprdfra'; 
CONFIGURE CHANNEL DEVICE TYPE DISK FORMAT   '/u01/backup/rmanbackup1';

run 
{
CONFIGURE CONTROLFILE AUTOBACKUP OFF;
crosscheck archivelog all;
allocate channel c1 type disk;
allocate channel c2 type disk;
allocate channel c3 type disk;
allocate channel c4 type disk;
#allocate channel c5 type disk;
#allocate channel c6 type disk;
#allocate channel c7 type disk;
#allocate channel c8 type disk;
sql 'ALTER SYSTEM ARCHIVE LOG CURRENT';
backup database format '/u01/backup/rmanbackup2/db_%T_%u_s%s_p%p';
sql 'ALTER SYSTEM ARCHIVE LOG CURRENT';
backup archivelog all format '/u01/backup/rmanbackup2/arch_%T_%u_s%s_p%p';
backup current controlfile format'/u01/backup/rmanbackup2/ctl_%T_%u_s%s_p%p' ;
CONFIGURE CONTROLFILE AUTOBACKUP ON; 
}

2. scp the backups to the remote server where clone has to be performed

3. change the permissions on the backups to 777

4. Password file of the DB being cloned should be same as the DB from which the current DB is being cloned. replace password file of hrtrn with hrprd and rename it to hrtrn.

---########################
--##restore a DB from backup of different DB, diff server taken on disk (File System)
---########################
1. take the existing pfile of the DB which has to be cloned and make the below modifications.

a. Change the control file parameter just to have the disk group name instead of having the whole path in ASM.

b. Add the below pfile parameters. --Below, HRPRD backup is used to clone HRTRN
*.db_file_name_convert='+HRPRDDATA/HRPRD','+HRTRNDATA/HRTRN'
*.log_file_name_convert='+HRPRDDATA/HRPRD','+HRTRNDATA/HRTRN','+HRPRDFRA/HRPRD','+HRTRNFRA/HRTRN'
*.nls_date_format = 'MM-DD-YYYY:HH24:MI:SS'

3. Shutdown the DB

4. Remove EVERYTHING from the asm disk groups of the DB which is to be cloned.

5. Startup the instance without mounting, USING THE PFILE created in step 1

6. Run the duplicate command. This can be done with various OPTIONS. 
***ALWAYS MAKE SURE THE CONFIGURATION ON THE DB FOR CHANNEL IS SET TO WHERE THE BACKUP was taken to, on THE PROD DB**
CONFIGURE CHANNEL DEVICE TYPE DISK FORMAT   '/u01/backup/rmanbackup4';

---
--- OPTION.1: BEST APPROCH. Below was used to restore from the folder /u01/backup/rmanbackup
---

rman auxiliary / log=$ORACLE_BASE/admin/scripts/logs_$ORACLE_SID/onlyaux_dup_hrprd_$ORACLE_SID`date +"%m_%d_%y-%H.%M.%S"`.log 

-- Below duplicate command will work only if all of the below conditions are satisfied. 
-- HUGE HUGE HUGE advantage with below dup is that we do not have to set any spfile parameters as above.
-- a. there should be a pfile in oracle_home/dbs which points to spfile in ASM
-- b. there should be an spfile which WAS IN USE by the DB being duplicated before we started duplication process.
-- c. do a startup nomount of the DB being duplicated using a pfile at other location or using spfile in step b above.
run
{
DUPLICATE DATABASE TO hrtrn
BACKUP LOCATION '/u01/backup/rmanbackup4'
NOFILENAMECHECK;
}

---------------------
run
{
DUPLICATE DATABASE TO hrtrn
SPFILE PARAMETER_VALUE_CONVERT 'hrprd','hrtrn','+HRPRDDATA','+HRTRNDATA','+HRPRDFRA','+HRTRNFRA'
SET DB_FILE_NAME_CONVERT    '+HRPRDDATA','+HRTRNDATA'
SET LOG_FILE_NAME_CONVERT   '+HRPRDDATA','+HRTRNDATA','+HRPRDFRA','+HRTRNFRA'
SET CONTROL_FILES= '+HRTRNDATA','+HRTRNFRA'
SET LOG_ARCHIVE_FORMAT='HRTRN_%s_%t_%r.ARC'
SET DB_CREATE_FILE_DEST='+HRTRNDATA'
SET DB_RECOVERY_FILE_DEST='+HRTRNFRA'
SET DB_RECOVERY_FILE_DEST_SIZE='49G'
SET db_create_online_log_dest_1='+HRTRNDATA'
SET db_create_online_log_dest_2='+HRTRNFRA'
SET SERVICE_NAMES='HRTRN.mbta.com'
BACKUP LOCATION '/u01/backup/rmanbackup4'
NOFILENAMECHECK;
} 

---------------------
run
{
DUPLICATE DATABASE TO hrtrn
BACKUP LOCATION '/u01/backup/rmanbackup4'
NOFILENAMECHECK
SPFILE
set control_files='+HRTRNDATA','+HRTRNFRA'
SET LOG_FILE_NAME_CONVERT ='+HRPRDDATA','+HRTRNDATA','+HRPRDFRA','+HRTRNFRA'
SET DB_FILE_NAME_CONVERT ='+HRPRDDATA','+HRTRNDATA'
Set DB_CREATE_FILE_DEST='+HRTRNDATA'
set DB_CREATE_ONLINE_LOG_DEST_1='+HRTRNDATA'
set DB_CREATE_ONLINE_LOG_DEST_2='+HRTRNFRA';}
} 

---
--- OPTION.2: Next best approch. Below timestamp was used to restore from the folder /u01/backup/rmanbackup2
---

rman auxiliary / target sys@hrprd log=$ORACLE_BASE/admin/scripts/logs_$ORACLE_SID/time_based_dup_hrprd_$ORACLE_SID`date +"%m_%d_%y-%H.%M.%S"`.log 
run
{
sql "alter session set nls_date_format = ''MM-DD-YYYY:HH24:MI:SS''"; 
set until time '07-16-2012:17:20:00'; -- This time can be obtained by looking at the backup pieces.
duplicate target database to hrtrn;
}
---------

---
rman auxiliary / target sys@hrprd log=$ORACLE_BASE/admin/scripts/logs_$ORACLE_SID/SCN_based_dup_hrprd_$ORACLE_SID`date +"%m_%d_%y-%H.%M.%S"`.log 
-- This SCN can be obtained by running "list backup of database;" command on the db where the backup is taken. Use the maximum of the SCN of all the backup sets of a backup taken at a particular time. To find the backups taken at a particulr time, look for the completetion time of the backup set in the output obtained from above command.
run 
{
set until scn 8142006;  -- This SCN can be obtained by running list backup of database
duplicate target database to hrtrn;
}
---------

7. Turn off flash back if it is set to on... as it is set to on in prod, this will clone the new DB.
select log_mode,flashback_on from v$database;

alter database flashback off;

---------
/*
run
{
sql "alter session set nls_date_format = ''MM-DD-YYYY:HH24:MI:SS''";
set until time "to_date('07-16-2012:17:20:00','MM-DD-YYYY:HH24:MI:SS')"; 
duplicate target database to hrtrn;
}

sql "alter session set nls_date_language = ''american''"; 

run
{
sql "alter session set nls_date_format = ''MM-DD-YYYY:HH24:MI:SS''"; 
set until time "to_date('07-16-2012:17:20:00','MM-DD-YYYY:HH24:MI:SS')"; 
duplicate target database to hrtrn;
}
*/
---------
run
{
allocate channel c1 type disk;
BACKUP ARCHIVELOG SEQUENCE BETWEEN 1215 AND 1221 format '/u01/backup/rmanbackup2/arch_%T_%u_s%s_p%p';
}
