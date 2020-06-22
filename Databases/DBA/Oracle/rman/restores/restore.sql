--incomplete recovery
http://allappsdba.blogspot.com/2012/04/restorerecovery-using-rman-with.html

--recovery after crash, using TAG
http://oracledbabhuvan.blogspot.com/2011/11/restore-database-using-rman-tag.html 

--various recovery scenarios
http://pbraun.nethence.com/oracle/rman_2_restore.html

--recover db from previous incarnation
http://oraware.blogspot.com/2008/03/how-to-recover-database-with-previous.html

-- Awsome example of how to duplicate from a backup just from a backup with only auxiliary connection
http://www.oracle-base.com/articles/11g/duplicate-database-using-rman-11gr2.php#backup_based_duplication

--restore controlfile from autobackup when catalog is used/not used.
http://www.bash-dba.com/2011/11/restoring-control-file-scenarios.html


-- Can't allocate more than on channel for restore from tape. Use the below parameter in rman.
-- Also see docs 358171.1 and 433335.1
rman target / catalog rman@emgcrdr log=$ORACLE_BASE/admin/scripts/logs_$ORACLE_SID/recover_frm_tape`date +"%m_%d_%y-%H.%M.%S"`.log
--
RMAN> SET PARALLELMEDIARESTORE OFF;  -- This parameter usage will enable parallel restore.
      RUN {
        RESTORE DATABASE;
        RECOVER DATABASE;
          }

		  
		  
SET PARALLELMEDIARESTORE OFF;		  
run {
allocate channel t1 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate channel t2 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate channel t3 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate channel t4 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
restore database;
recover database;
RELEASE CHANNEL t1;
RELEASE CHANNEL t2;
RELEASE CHANNEL t3;
RELEASE CHANNEL t4;
}

----------------------------------------------------
-- Below is for incomplete media recovery from a TAG
----------------------------------------------------

-> First start the database in NOMOUNT state using an existing pfile or spfile. 

SET PARALLELMEDIARESTORE OFF;
run 
{
allocate channel t1 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
restore controlfile from tag='HRPAYCTL2';
RELEASE CHANNEL t1;
}

SET PARALLELMEDIARESTORE OFF;		  
run
{
allocate channel t1 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate channel t2 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate channel t3 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate channel t4 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
restore database from tag='HRPAYDB2';
RELEASE CHANNEL t1;
RELEASE CHANNEL t2;
RELEASE CHANNEL t3;
RELEASE CHANNEL t4;
}


RECOVER DATABASE UNTIL TIME '2012-06-28:18:46:00' USING BACKUP CONTROLFILE;

SET PARALLELMEDIARESTORE OFF;
run
{
allocate channel t1 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate channel t2 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate channel t3 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate channel t4 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
restore archivelog scn between 56442520 and 56442590;
RELEASE CHANNEL t1;
RELEASE CHANNEL t2;
RELEASE CHANNEL t3;
RELEASE CHANNEL t4;
}

recover database from tag='HRPAYDB2' ARCHIVELOG TAG='HRPAYARC2';
recover database from TAG='HRPAYARC2';

----------------------------------------------------
-- Below is recommended by Nitin
----------------------------------------------------

Hi kranthi,

Based on our discussion, please find the steps to reproduce the correct method for Incomplete Recovery.

- Create pfile from spfile.

- Shutdown the database

- Goto ASMCMD and flush the DATA AND FRA logs so that it becomes clean and there should not be any files under DATA AND FRA.

- Login to sqlplus / as sysdba

- startup nomount pfile='inithrstst.ora'

- rman target / catalog rman/rman1@emgcr 

- run
{
allocate channel ch1 type sbt_tape;
restore controlfile from TAG TAG20090820T105907 ; restore database; }

- Now login to asmcmd and check the control file ID number and modify it in pfile.
- Shutdown the database and modify the control file entry and start mount the database.

- Alter database open resetlogs;

- Now create a SPFILE and start the database using spfile.

Please retest.

Regards,
Nitin Arora
----------------------------------------
----------------------------------------
----------------------------------------

Select distinct to_char(checkpoint_time,'DD-MON-YYYY HH24:MI:SS') from v$datafile;