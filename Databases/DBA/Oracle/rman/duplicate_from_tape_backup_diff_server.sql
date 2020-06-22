http://www.oracle-base.com/articles/11g/duplicate-database-using-rman-11gr2.php#backup_based_duplication
-- Awsome example of how to duplicate from a backup on file system, just from a backup with only auxiliary connection.


*****
***** Tested examples of Duplicate from backup are in doc C:\MISC\ORACLE\SQL\DBADMIN\rman\restores\PITR-using-rman_set_until_SCN.sql
*****

--**********### WHEN OMS FILES ARE NOT USED WE HAVE TO SPECIFY THE SUBDIRECTORY of ASM as mentioned in the below parameters
alter system set db_file_name_convert='+HRTSTDATA/HRTST','+HRTRNDATA/HRTRN' scope=spfile;
alter system set log_file_name_convert='+HRTSTDATA/HRTST','+HRTRNDATA/HRTRN','+HRTSTFRA/HRTST','+HRTRNFRA/HRTRN' scope=spfile;

***** IMPORTANT IMPORTANT IMPORTANT
***** SOME FORM OF SET UNTIL MUST MUST TO BE USED WHEN DOING ANY KIND OF TAPE BASED BACKUP. PREFERANCE IS 
***** TO USE SET UNTIL SCN instead of SET UNTIL TIME.
*****
------------------------------------BELOW WORKED-------------------------------------
startup nomount pfile='/u01/app/oracle/admin/tst/pfile/inittst_dup.ora'

rman target sys/sssdp@hrtrn1525 auxiliary sys/sssdp@tst1525 

rman target sys/sssdp@hrtrn1525 auxiliary sys/sssdp@tst1525 log=$ORACLE_BASE/admin/scripts/logs_$ORACLE_SID/hrtrn_tst_tape_`date +"%m_%d_%y-%H.%M.%S"`.log

SET PARALLELMEDIARESTORE OFF;
RUN {
allocate channel t1 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate channel t2 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate channel t3 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate channel t4 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate auxiliary channel t5 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax08.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate auxiliary channel t6 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax08.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate auxiliary channel t7 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax08.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate auxiliary channel t8 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax08.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
duplicate target database to tst
SPFILE 
PARAMETER_VALUE_CONVERT 'hrtrn','tst','+HRTRNDATA','+TSTDATA','+HRTRNFRA','+TSTDATA'
SET DB_FILE_NAME_CONVERT    '+HRTRNDATA','+TSTDATA'
SET LOG_FILE_NAME_CONVERT   '+HRTRNDATA','+TSTDATA','+HRTRNFRA','+TSTDATA'
SET CONTROL_FILES= '+TSTDATA','+TSTDATA'
SET LOG_ARCHIVE_FORMAT='TST_%s_%t_%r.ARC'
SET DB_CREATE_FILE_DEST='+TSTDATA'
SET DB_RECOVERY_FILE_DEST='+TSTDATA'
SET DB_RECOVERY_FILE_DEST_SIZE='10G'
SET db_create_online_log_dest_1='+TSTDATA'
SET db_create_online_log_dest_2='+TSTDATA';

}


-----------------------------

rman target sys/o11gWasm@hrprd auxiliary sys/o11gWasm@${ORACLE_SID}1525 log=$ORACLE_BASE/admin/scripts/logs_$ORACLE_SID/tapedup_hrprd_${ORACLE_SID}_`date +"%m_%d_%y-%H.%M.%S"`.log using $ORACLE_SID

SET PARALLELMEDIARESTORE OFF;
run 
{
allocate channel t1 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate channel t2 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate channel t3 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate channel t4 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate auxiliary channel t5 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax08.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate auxiliary channel t6 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax08.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate auxiliary channel t7 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax08.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate auxiliary channel t8 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax08.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
DUPLICATE target DATABASE TO &1
NOFILENAMECHECK;
}