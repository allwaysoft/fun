http://husnusensoy.wordpress.com/2009/10/23/rman-active-duplicate/
http://docs.oracle.com/cd/B28359_01/backup.111/b28270/rcmdupdb.htm#i1006672
http://docs.oracle.com/cd/E11882_01/server.112/e10803/config_dg.htm
ID 1144273.1
https://forums.oracle.com/forums/thread.jspa?threadID=2358266&start=0&tstart=0

ID 840647.1   --various duplicate options and steps.
https://forums.oracle.com/forums/thread.jspa?threadID=2147208
--nomount DB blocked by grid listener issue resolved.

1331986.1	
452868.1 active duplication
259694.1 backup based duplication
1144273.1 active duplication tns entries for aux db on both the target and aux servers.

https://forums.oracle.com/forums/thread.jspa?threadID=619607
-- can't access ASM file system on another host from different host.

http://docs.oracle.com/cd/B28359_01/backup.111/b28270/rcmdupdb.htm#i1006672
--Even the backup on files system on different host is not accessable by other host. Please see below link. This leaves us with only backups on tape. Look for section "Making Disk Backups Accessible to the Duplicate Instance"

http://lefterhs.blogspot.com/2012/06/clone-database-using-rman-duplicate.html
--SCN based duplication

--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------

********### WHEN OMS FILES ARE NOT USED WE HAVE TO SPECIFY THE SUBDIRECTORY UNDER mentioned in the below parameters
alter system set db_file_name_convert='+HRTSTDATA/HRTST','+HRTRNDATA/HRTRN' scope=spfile;
alter system set log_file_name_convert='+HRTSTDATA/HRTST','+HRTRNDATA/HRTRN','+HRTSTFRA/HRTST','+HRTRNFRA/HRTRN' scope=spfile;

ELSE USE BELOW

alter system set db_file_name_convert='+HRPRDDATA','+HRTRNDATA' scope=spfile;
alter system set log_file_name_convert='+HRPRDDATA','+HRTRNDATA','+HRPRDFRA','+HRTRNFRA' scope=spfile;

--------------------------------------------------------------------------------------------
---------------------- PREREQ-BASIC REQUIREMENTS FOR DUPLICATION----------------------------
--------------------------------------------------------------------------------------------
->Need to have a listener owned by oracle user. (Using port 1525 for this listener)
->Need to have a sid list entry in the listener for the auxiliary database. 
->Passwords of target and aux databases should be same. Else use below on aux DB to match with target.
orapwd file=$ORACLE_HOME/dbs/orapwhrdev entries=5 password=o11gWasm
->target DB has to be in archive log mode. [This is not required if duplicating from backup only]
->rman target sys/sssdp@hrpay auxiliary sys/sssdp@hrtrn1525 log=$ORACLE_BASE/admin/scripts/logs_$ORACLE_SID/hrpay_$ORACLE_SID`date +"%m_%d_%y-%H.%M.%S"`.log 
--------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------
----------------------PREREQ-ABOUT PFILE AND SPFILE USAGE IN DUPLICATOIN--------------------
--------------------------------------------------------------------------------------------
ON AUX DB SERVER.
HUGE HUGE HUGE advantage with below dup is that we do not have to set any spfile parameters.
a. there should be a pfile in oracle_home/dbs which points to some spfile in ASM, doesnt matter even if the file do not exist in ASM.
b. there should be an spfile which WAS IN USE by the DB being duplicated before we started duplication process.
d. for tns entries and listener setup, see the following section below this section.
CASE1. When a and b above are true. If we want to startup nomount the DB with spfile at $ORACLE_HOME/dbs, then the db_file_name_convert and log_file_name_cnvert parameters in spfile should reflect the values we need for the current duplication, if not then set those values in spfile and startup force nomount the DB again.  --BEST METHOD SOFAR

[In the above case1, the duplicate will create a spfile in ASM (due to point a. above, it is tricked to create the spfile in ASM instead of at $ORACLE_HOME/dbs), which is pretty much useless for us. After that, duplicate will shutdown and restart the auxiliary instance but this time it uses spfile in $ORACLE_HOME/dbs, which is perfect for use as we have already changed the two parameter in this spfile. NOW DUPLICATE SUCCEEDS.]

alter system set db_file_name_convert='+HRPRDDATA','+HRDEVDATA' scope=spfile;
alter system set log_file_name_convert='+HRPRDDATA','+HRDEVDATA','+HRPRDFRA','+HRDEVFRA' scope=spfile;
startup force nomount;

Case2. If we want to use the pfile in some other location, the log_file_name_convert and db_file_name_convert can be provided in the DUPLICATE command so that the spfile or pfile doesnt have to be modified. If I do this, I still had to modify the spfile (for those two parameters) in $ORACLE_HOME/dbs for duplicate to work.
--------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------
-------- PREREQ-LISTENER AND TNS CONFIGURATIONS REQUIREMENTS FOR ACTIVE DUPLICATION---------
--------------------------------------------------------------------------------------------
Static entry should be made to the listener, which is owned by user ORACLE. These entries are as below.

	>ON Target server Oracle user owned listener. From below, it can be seen that LISTENERT is the listener owned by Oracle
	>--------------------------------
	SID_LIST_LISTENERT = (SID_LIST = (SID_DESC = (GLOBAL_DBNAME = hrtrn.mbta.com) (ORACLE_HOME = /u01/app/oracle/product/11.2.0/db_1) (SID_NAME= hrtrn)))
	
	>ON Auxiliary server Oracle user owned listener
	>--------------------------------
	SID_LIST_LISTENERT = (SID_LIST = (SID_DESC = (GLOBAL_DBNAME = tst.mbta.com) (ORACLE_HOME = /u01/app/oracle/product/11.2.0/db_1) (SID_NAME= tst)))

TNS entries of Aux DB for Oracle LISTENERT should be present on BOTH TARGET and AUXILARY servers. Look at doc 1144273.1

TNS entry MUST have UR=A
--------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------
-------------PREREQ-If there is any control file related errors while duplicating-----------
--------------------------------------------------------------------------------------------
Try to change the control file parameter in spfile used to nomount the DB, if it does not change the control file parameter, next step is to create a pfile from spfile, remove the control file parameter totally from the pfile, create spfile from the pfile with not control file parameter, use this spfile to nomount the DB before duplication.
--------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------
---------------------------PREREQ-Common steps for any duplication--------------------------
--------------------------------------------------------------------------------------------
1. If doing ACTIVE DUPLICATION: connect to the aux DB via rman, do a 'show all' and remove the sbt tape channel configuration. Otherwise, duplication spends a lot of time with tape channels unnecessarily.

2. Shutdown the aux DB, clear all ASM files, startup nomount the aux DB using any of the pfile or spfile as mentioned in one of the PREREQs above.
--------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------
****NOTE NOTE NOTE****
If using ASM make sure the names of all files are OMF but not physical names, in that case we will have probelms.
In our case, I had to change the control file name in pfile used for duplicate DB from actual name to '+TSTDATA'
also there was a table space RECO_CAT which had a physical name in ASM. Had problem with that. Skipped it for time being.
--------------------------------------------------------------------------------------------


--------------------------------------------------------------------------------------------
****For Post duplication steps look at "Post duplication steps" at the end of this document.
--------------------------------------------------------------------------------------------



------------------------------------------------------------------------------------------------------
--------------------------------------------START From Oracle Support.--------------------------------
------------------------------------------------------------------------------------------------------

DUPLICATE TARGET DATABASE
 TO tst
 FROM ACTIVE DATABASE  
   SPFILE PARAMETER_VALUE_CONVERT '+HRTRNDATA','+TSTDATA'
   SET DB_FILE_NAME_CONVERT    '+HRTRNDATA','+TSTDATA'
   SET LOG_FILE_NAME_CONVERT   '+HRTRNDATA','+TSTDATA'
SET CONTROL_FILES= '+TSTDATA'
SET DB_RECOVERY_FILE_DEST='+TSTDATA'
SET DB_RECOVERY_FILE_DEST_SIZE='5g';

-- Below script change from above script is that I have added htrtrnm hrtst valuse to the PARAMETER_VALUE_CONVERT --parameter.

DUPLICATE TARGET DATABASE
 TO tst
 FROM ACTIVE DATABASE  
   SPFILE PARAMETER_VALUE_CONVERT 'hrtrn','tst','+HRTRNDATA','+TSTDATA'
   SET DB_FILE_NAME_CONVERT    '+HRTRNDATA','+TSTDATA'
   SET LOG_FILE_NAME_CONVERT   '+HRTRNDATA','+TSTDATA'
SET CONTROL_FILES= '+TSTDATA'
SET DB_RECOVERY_FILE_DEST='+TSTDATA'
SET DB_RECOVERY_FILE_DEST_SIZE='5g';

--Below script has a change of adding additional parameter SET db_create_online_log_dest_1='TSTDATA' from above.

DUPLICATE TARGET DATABASE
TO tst
FROM ACTIVE DATABASE  
  SPFILE PARAMETER_VALUE_CONVERT 'hrtrn','tst','+HRTRNDATA','+TSTDATA'
  SET DB_FILE_NAME_CONVERT    '+HRTRNDATA','+TSTDATA'
  SET LOG_FILE_NAME_CONVERT   '+HRTRNDATA','+TSTDATA'
SET CONTROL_FILES= '+TSTDATA'
SET DB_RECOVERY_FILE_DEST='+TSTDATA'
SET DB_RECOVERY_FILE_DEST_SIZE='5g'
SET db_create_online_log_dest_1='+TSTDATA';

--Added hrtrnfra to the parameter_calue_convert

DUPLICATE TARGET DATABASE
TO tst
FROM ACTIVE DATABASE  
  SPFILE PARAMETER_VALUE_CONVERT 'hrtrn','tst','+HRTRNDATA','+TSTDATA','+HRTRNFRA','+TSTDATA'
  SET DB_FILE_NAME_CONVERT    '+HRTRNDATA','+TSTDATA'
  SET LOG_FILE_NAME_CONVERT   '+HRTRNDATA','+TSTDATA'
SET CONTROL_FILES= '+TSTDATA'
SET DB_RECOVERY_FILE_DEST='+TSTDATA'
SET DB_RECOVERY_FILE_DEST_SIZE='5g'
SET db_create_online_log_dest_1='+TSTDATA';

-------------- Did below to debug. Finally at this point Oracle rep wanted to open a bug but wanted the debug output before that.

rman target sys/sssdp@hrtrn1525 auxiliary sys/sssdp@tst1525 trace=debug_dup_hrtrn_tst.trc log=dup_hrtrn_tst.txt 
run { 
debug on; 
DUPLICATE TARGET DATABASE
TO tst
FROM ACTIVE DATABASE  
  SPFILE PARAMETER_VALUE_CONVERT 'hrtrn','tst','+HRTRNDATA','+TSTDATA'
  SET DB_FILE_NAME_CONVERT    '+HRTRNDATA','+TSTDATA'
  SET LOG_FILE_NAME_CONVERT   '+HRTRNDATA','+TSTDATA'
SET CONTROL_FILES= '+TSTDATA'
SET DB_RECOVERY_FILE_DEST='+TSTDATA'
SET DB_RECOVERY_FILE_DEST_SIZE='5g'
SET db_create_online_log_dest_1='+TSTDATA';
debug off; 
} 

-------------------

startup nomount pfile='/u01/app/oracle/admin/tst/pfile/inittst.ora'

cd /u01/app/oracle/admin/tst/pfile

rman log=dup_hrtrn_tst.log

connect target sys/sssdp@hrtrn1525
connect auxiliary sys/sssdp@tst1525

----------------Oracle cameback with the below suggestion, they wanted the trace and log of RMAN.
clear ASM for tst

startup nomount pfile='/u01/app/oracle/admin/tst/pfile/inittst_dup.ora';

rman target sys@hrtrn1525 auxiliary / debug trace=$ORACLE_BASE/admin/scripts/logs_$ORACLE_SID/act_dup_hrtrn_$ORACLE_SID`date +"%m_%d_%y-%H.%M.%S"`.trc log=$ORACLE_BASE/admin/scripts/logs_$ORACLE_SID/act_dup_hrtrn_$ORACLE_SID`date +"%m_%d_%y-%H.%M.%S"`.log 
rman target sys@hrtrn1525 auxiliary sys@tst debug trace=dup_trc`date +"%m_%d_%y-%H.%M.%S"`.trc log=$ORACLE_BASE/admin/scripts/logs_$ORACLE_SID/dup_`date +"%m_%d_%y-%H.%M.%S"`.log 
rman target sys@hrtrn auxiliary sys@tst log=$ORACLE_BASE/admin/scripts/logs_$ORACLE_SID/dup_`date +"%m_%d_%y-%H.%M.%S"`.log 


DUPLICATE TARGET DATABASE
TO tst
FROM ACTIVE DATABASE
SPFILE PARAMETER_VALUE_CONVERT 'hrtrn','tst','+HRTRNDATA','+TSTDATA'
SET DB_FILE_NAME_CONVERT '+HRTRNDATA','+TSTDATA'
SET CONTROL_FILES= '+TSTDATA'
SET DB_RECOVERY_FILE_DEST='+TSTDATA'
SET DB_RECOVERY_FILE_DEST_SIZE='5g'
SET db_create_online_log_dest_1='+TSTDATA';

**** check the post duplication steps at the end of this doc
--------------------------------------------------------------------------------------------------------
-------------------------------------------END ORACLE SUPPORT-------------------------------------------
--------------------------------------------------------------------------------------------------------



--------------------!!!!!!!!!!!!!!!!!BELOW WORKED WORKED WORKED!!!!!!!!!!!!!!!!!------------------------
--------------------------ON SAME SERVER FROM PAY to TRN -- Done in 5 minutes---------------------------
--******************************************************************************************************
--******************************************************************************************************
run 
{ 
DUPLICATE TARGET DATABASE
TO HRTRN
FROM ACTIVE DATABASE 
  PASSWORD FILE 
  SPFILE PARAMETER_VALUE_CONVERT 'hrpay','hrtrn','+HRPAYDATA','+HRTRNDATA','+HRPAYFRA','+HRTRNFRA'
  SET DB_FILE_NAME_CONVERT    '+HRPAYDATA','+HRTRNDATA'
  SET LOG_FILE_NAME_CONVERT   '+HRPAYDATA','+HRTRNDATA','+HRPAYFRA','+HRTRNFRA'
SET CONTROL_FILES= '+HRTRNDATA','+HRTRNFRA'
SET LOG_ARCHIVE_FORMAT='HRTRN_%s_%t_%r.ARC'
SET DB_CREATE_FILE_DEST='+HRTRNDATA'
SET DB_RECOVERY_FILE_DEST='+HRTRNFRA'
SET DB_RECOVERY_FILE_DEST_SIZE='49G'
SET SERVICE_NAMES='HRTRN.mbta.com'
SET db_create_online_log_dest_1='+HRTRNDATA'
SET db_create_online_log_dest_2='+HRTRNFRA';
} 
**** check the post duplication steps at the end of this doc
------------------------------------------BELOW WORKED-------------------------------------------------
--HRPRD to TST
startup nomount pfile='/u01/app/oracle/admin/tst/pfile/inittst_dup.ora'
->rman target sys/sssdp@hrpay auxiliary sys/sssdp@hrtrn log=$ORACLE_BASE/admin/scripts/logs_$ORACLE_SID/hrpay_$ORACLE_SID`date +"%m_%d_%y-%H.%M.%S"`.log 
run 
{ 
DUPLICATE TARGET DATABASE
TO TST
FROM ACTIVE DATABASE 
  PASSWORD FILE 
  SPFILE PARAMETER_VALUE_CONVERT 'hrprd','tst','+HRPRDDATA','+TSTDATA','+HRPRDFRA','+TSTDATA'
  SET DB_FILE_NAME_CONVERT    '+HRPRDDATA','+TSTDATA'
  SET LOG_FILE_NAME_CONVERT   '+HRPRDDATA','+TSTDATA','+HRPRDFRA','+TSTDATA'
SET CONTROL_FILES= '+TSTDATA','+TSTDATA'
SET LOG_ARCHIVE_FORMAT='TST_%s_%t_%r.ARC'
SET DB_CREATE_FILE_DEST='+TSTDATA'
SET DB_RECOVERY_FILE_DEST='+TSTDATA'
SET DB_RECOVERY_FILE_DEST_SIZE='10G'
SET db_create_online_log_dest_1='+TSTDATA'
SET db_create_online_log_dest_2='+TSTDATA';
} 

**** check the post duplication steps at the end of this doc
----------HRPAY to HRTRN

> Here, I have started nomount the DB with spfile at $ORACLE_HOME/dbs
rman target sys/o11gWasm@hrpay auxiliary sys/o11gWasm@hrtrn1525 log=$ORACLE_BASE/admin/scripts/logs_$ORACLE_SID/actdup_hrpay_$ORACLE_SID`date +"%m_%d_%y-%H.%M.%S"`.log
 
run
{
DUPLICATE target DATABASE TO hrtrn FROM ACTIVE DATABASE
NOFILENAMECHECK;
}

**** check the post duplication steps at the end of this doc
-----------------------------------------------------------------------------------------



-----------------------------------------------------------------------------------------
-----------------------------------BELOW WORKED DIFFERENT SERVER-------------------------
-----------------------------------------------------------------------------------------
-- HUGE HUGE HUGE advantage with below dup is that we do not have to set any spfile parameters as above. except fot the two mentioned in the alter system statements below.
-- a. there should be a pfile in oracle_home/dbs which points to spfile in ASM
-- b. there should be an spfile which WAS IN USE by the DB being duplicated before we started duplication process.
-- d. for tns entries and listener setup, see at the top of this document.
> Here, I have started nomount the DB with spfile at $ORACLE_HOME/dbs

rman target sys/o11gWasm@hrprd auxiliary sys/o11gWasm@hrtrn1525 log=$ORACLE_BASE/admin/scripts/logs_$ORACLE_SID/actdup_hrprd_$ORACLE_SID`date +"%m_%d_%y-%H.%M.%S"`.log

alter system set db_file_name_convert='+HRPRDDATA','+HRTRNDATA' scope=spfile;
alter system set log_file_name_convert='+HRPRDDATA','+HRTRNDATA','+HRPRDFRA','+HRTRNFRA' scope=spfile;
startup force nomount;

run 
{
DUPLICATE target DATABASE TO hrtrn FROM ACTIVE DATABASE
NOFILENAMECHECK;
}

**** check the post duplication steps at the end of this doc

------------------COMPLETE WITH PARAMETERS--NO HARDCODING. Uses Oracle_sid and hrprd at one location.

rman target sys/o11gWasm@fnprda auxiliary sys/o11gWasm@${ORACLE_SID}1525 log=$ORACLE_BASE/admin/scripts/logs_$ORACLE_SID/actdup_fnprda_${ORACLE_SID}_`date +"%m_%d_%y-%H.%M.%S"`.log using $ORACLE_SID

run 
{
DUPLICATE target DATABASE TO &1 FROM ACTIVE DATABASE
NOFILENAMECHECK;
}

**** check the post duplication steps at the end of this doc


rman target sys/o113wasm@fapa1525 auxiliary sys/o113wasm@${ORACLE_SID}1525 log=$ORACLE_BASE/admin/scripts/logs_$ORACLE_SID/actdup_fapa_${ORACLE_SID}_`date +"%m_%d_%y-%H.%M.%S"`.log using $ORACLE_SID
--------------------------------------------------------------------------------------------



--------------------------------------------------------------------------------------------
-----------------------------------Post duplication steps-----------------------------------
--------------------------------------------------------------------------------------------
**** switch off flashback
alter database flashback off;

**** IMPORTANT change the service name parameter to reflect the name of the auxiliary DB ****
alter system set service_names = 'hrtrn.mbta.com' scope=both;
exec dbms_service.delete_service('HRPRD.mbta.com'); -- Remove HRPRD (target DB service) service from DB.

**** IMPORTANT, drop statspack, run @$ORACLE_HOME/rdbms/admin/spdrop.sql, also drop the tablespace statspack to save disk space.

**** When hit with the below issue 
RMAN After 10.2.0.2 Duplicate Database Gets Ora-1186 And Ora-1110 on TempFiles [ID 374934.1] ISSSUE

ERROR
ORA-01186: file 201 failed verification tests
ORA-01122: database file 201 failed verification check
ORA-01110: data file 201: '/oratemp/oradata/DWDM2QA/temp01.dbf'
ORA-01203: wrong incarnation of this file - wrong creation SCN

How To Recover From Missing Tempfiles or an Empty Temporary Tablespace [ID 178992.1]          FIX

After reading the above, used the following script to solve the prob. C:\MISC\ORACLE\SQL\DBADMIN\TEMP_UNDO.sql

**** Drop all the jobs, schedules owned by BDADMIN and tables aswell if not needed.

SQL> BEGIN
DBMS_SCHEDULER.drop_job (job_name => 'DBADMIN.MBTA_SP_DB_SIZE_INSERT_DLY_JOB');
END;
/

SQL> BEGIN
DBMS_SCHEDULER.drop_schedule (schedule_name => 'DBADMIN.MBTA_DAILY_0400_SCHDL');
END;
/

**** IMPORTANT, register the new db in catalog and change the configurations ****
run script /u01/app/oracle/admin/scripts/dbadmin/9bregister_new_db_catalog.sh
