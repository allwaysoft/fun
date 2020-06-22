--ID 1070453.6 -- recover database to a time beofre the reset logs (to a point in previous incarnation)
rman target / catalog rman@emgcrdr log=$ORACLE_BASE/admin/scripts/logs_$ORACLE_SID/recover_frm_tape`date +"%m_%d_%y-%H.%M.%S"`.log

-- If every thing is lost start from step 1. If control file and spfile are intact start from step 8.



1. startup nomount using any old pfile; or do a startup force nomount, this will start the DB using a dummy spfile.

2. set dbid with the below command. -- db id can be viewd from recovery catalog, select * from rman.RC_DATABASE
set dbid=<db_id_database>

3. list incarnation of database;

4. Check if we have to go to previous incarnation based on the time we want to go back to. ID 1070453.6
reset database to incatnation inc_number;

5. restore spfile from backup.
run 
{
allocate channel t1 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
sql "alter session set nls_date_format = ''MM-DD-YYYY:HH24:MI:SS''"; 
set until time '06-29-2012:11:10:00'; 
restore spfile;  #This command works only if we are using catalog. else restore spfile from autobackup MUST be userd and if a non default name is specified for autobackup, it should be used when restoring the file.
release channel t1;
}

6. startup force nomount; -- this will bring the new spfile into effect.

7. restore controlfile from backup.
run 
{
allocate channel t1 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
sql "alter session set nls_date_format = ''MM-DD-YYYY:HH24:MI:SS''"; 
set until time '06-29-2012:11:10:00'; 
restore controlfile;
release channel t1;
}

8. Startup force mount; -- this will bring the new controlfile into effect

9.
SET PARALLELMEDIARESTORE OFF;
run 
{
allocate channel t1 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate channel t2 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate channel t3 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
allocate channel t4 type 'sbt_tape' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
sql "alter session set nls_date_format = ''MM-DD-YYYY:HH24:MI:SS''";
set until time '06-29-2012:11:10:00'; 
restore database;
recover database;
release channel t1;
release channel t2;
release channel t3;
release channel t4;
}

10. sql 'alter database open resetlogs';
