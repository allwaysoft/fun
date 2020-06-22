http://lefterhs.blogspot.com/2012/06/clone-database-using-rman-duplicate.html
--SCN based duplication

# *** If doing a restore unlike a duplicate from a backup, directly go to Method C skipping everything, except point 2, to get the SCN for the restore, look at point 2.

# *** SCN Scenario I have tested this successfully. Method A & B are not restore to same environment but duplicate HRTRN from an old backup of HRTST. Below procedures also worked successfully to duplicate from HRPRD to HRTST as well.

# Below are the steps I followed.

>>1. For all the prerequsite steps required for any typical duplication, look at the doc C:\MISC\ORACLE\SQL\DBADMIN\rman\duplicate_from_active_issues.sql

>>2. In this case, the DB backup was on tape. User wanted the DB HRTRN to be restored from the backup of HRTST taken a week earlier. For that, I used below command to get the SCN number around that backup time. If there is SCN number already present form the backup log that is better.
   
run 
{
allocate channel t1 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
sql "alter session set nls_date_format = ''MM-DD-YYYY:HH24:MI:SS''"; 
set until time '08-04-2012:02:10:00'; 
restore database preview;
RELEASE CHANNEL t1;
}   
*** In the above, the command "restore databse preview" will show how the restore would look but doesnt actully restore it.
*** The output of above command has the last few lines as below. We are interested in the SCN number from the 2nd line. As the statement in the 2nd line says, recover must be performed from SCN one above the SCN in 2nd line below.

Media recovery start SCN is 87791939
Recovery must be done beyond SCN 87793820 to clear datafile fuzziness
validation succeeded for backup piece
Finished restore at 08-14-2012:13:09:16

>>3. Shutdown the aux DB, clear all ASM files, startup nomount the aux DB. 

>>4. Do the actual duplicaton by using the SCN obtained from above. Note that we added 1 to the SCN from above to the duplicate command below. Two methods can be follwed at this point, one connectin to aux and target DBs, one connecting to Aux and catalog DB. 

****************
--Method A. This is tested and worked. connecting to AUX and TARGET
****************

**** Check ORACLE_SID before using below rman command

rman auxiliary sys/o11gWasm@${ORACLE_SID}1525 target sys/o11gWasm@hrprdab log=$ORACLE_BASE/admin/scripts/logs_$ORACLE_SID/SCNDUP_${ORACLE_SID}_`date +"%m%d%y-%H.%M.%S"`.log using $ORACLE_SID

SET PARALLELMEDIARESTORE OFF;

run
{
allocate channel t1 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate channel t2 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate channel t3 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate channel t4 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate auxiliary channel t5 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate auxiliary channel t6 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate auxiliary channel t7 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate auxiliary channel t8 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
DUPLICATE target DATABASE TO &1 UNTIL SCN 87793821 -change SCN number before using this script
NOFILENAMECHECK;
}

**** For all post duplication steps, for any typical duplication, look at the doc duplicate_from_active_issues.sql

****************
--Method B. **** This is tested successfully. Below is example to duplicate from hrprd to hrtst. connecting to ONLY CATALOG and AUX [ID 1375864.1] 
****************

-- Here the channel allocation is a bit different and includes NSR_CLIENT additional parameter. Below link expalins about this kind of allocation.
--https://forums.oracle.com/forums/thread.jspa?threadID=2134522&start=0&tstart=0



>>5a. Bug 13741583 : RMAN DUPLICATION ERRONEOUSLY FAILS WITH ORA-19804 - Hit with this bug and did the work around as suggested. set the fra size same on both DBs even though the actual size on disk is less.
alter system set db_recovery_file_dest_size=80G scope=both;

**** Check ORACLE_SID before using below rman command

rman auxiliary sys/o11gWasm@${ORACLE_SID}1525 catalog rman/rman1@emgcrab log=$ORACLE_BASE/admin/scripts/logs_$ORACLE_SID/SCNDUP_${ORACLE_SID}_`date +"%m%d%y-%H.%M.%S"`.log using $ORACLE_SID

SET PARALLELMEDIARESTORE OFF;

run
{
allocate auxiliary channel t1 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_CLIENT=hseax08.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate auxiliary channel t2 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_CLIENT=hseax08.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate auxiliary channel t3 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_CLIENT=hseax08.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate auxiliary channel t4 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_CLIENT=hseax08.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate auxiliary channel t5 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_CLIENT=hseax08.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate auxiliary channel t6 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_CLIENT=hseax08.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
DUPLICATE DATABASE hrprd dbid xxx TO &1 UNTIL SCN 87793821 -change dbid of the DB from whcih we have to duplicate, SCN number before using this script
NOFILENAMECHECK;
}

>>5b. **** alter system set db_recovery_file_dest_size=49G scope=both; --if this parameter was changed before duplication, due to Bug 13741583
     
**** For all post duplication steps, for any typical duplication, look at the doc duplicate_from_active_issues.sql

****************
--Method C. **** This is a regular restore to the same Database from the backup in FRA.
****************
--For other restore option, please look at doc C:\MISC\ORACLE\SQL\DBADMIN\rman\restores\restore.sql and links in that doc.

rman target / catalog rman@emgcrab log=$ORACLE_BASE/admin/scripts/logs_$ORACLE_SID/rstre_dsk_scn_10288013_${ORACLE_SID}_`date +"%m_%d_%y-%H.%M.%S"`.log

--****Use the below PARALLEL command only when restoring from TAPE.
SET PARALLELMEDIARESTORE OFF; 

RUN {
allocate channel c1 type disk;
allocate channel c2 type disk;
allocate channel c3 type disk;
allocate channel c4 type disk;
shutdown immediate;
startup mount;
set until scn 10288013;
restore database;
recover database;
ALTER database OPEN resetlogs;
RELEASE CHANNEL c1;
RELEASE CHANNEL c2;
RELEASE CHANNEL c3;
RELEASE CHANNEL c4;
}

run { 
  shutdown immediate;
  startup mount;
  set until time 'Nov 15 2000 09:00:00';
  # set until scn 1000;       # alternatively, you can specify SCN
  # set until sequence 9923;  # alternatively, you can specify log sequence number
  restore database;
  recover database;
  alter database open resetlogs;
}