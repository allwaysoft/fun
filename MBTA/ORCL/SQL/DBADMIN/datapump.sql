select * from dba_directories

drop directory data_pump_dir

drop directory data_pump_log_dir

--************ Below was done for hrtst. change the read write permissions based on the db instance this is run for

CREATE OR REPLACE DIRECTORY HRDEV_DATA_PUMP_DIR as '+HRDEVFRA/HRDEV/DUMPSET'        --DUMPSET is default directory for .dmp file created by datapump in ASM

GRANT READ ON DIRECTORY HRDEV_DATA_PUMP_DIR TO DBADMIN   --only read

CREATE OR REPLACE DIRECTORY HRTST_DATA_PUMP_DIR as '+HRTSTFRA/HRTST/DUMPSET'

GRANT READ, WRITE ON DIRECTORY HRTST_DATA_PUMP_DIR TO DBADMIN  -- only read

CREATE OR REPLACE DIRECTORY HRSTG_DATA_PUMP_DIR as '+HRSTGFRA/HRSTG/DUMPSET'

GRANT READ ON DIRECTORY HRSTG_DATA_PUMP_DIR TO DBADMIN   --read and write

CREATE OR REPLACE DIRECTORY HRTST_DATA_PUMP_LOG_DIR as '/u01/app/oracle/admin/hrtst/dpdump'    -- Log files can't be written to ASM, so put them at this location. Based on DB instance, change loc

GRANT READ, WRITE ON DIRECTORY HRTST_DATA_PUMP_LOG_DIR TO DBADMIN;



--drop directory data_pump_dir


expdp DBADMIN@hrtst 
schemas=PSADMN 
directory=HRTST_DATA_PUMP_DIR 
dumpfile=psadmn_hrtst_06-07-2012_%U.dmp
STATUS=30 
--This will display the detailed status every 30 secs only on screen but not in log file. 
logfile=HRSTG_DATA_PUMP_LOG_DIR:hrstg_psadmn_schema.log
PARALLEL=4 
--this parameter should not exceed more than twice the number of CPUs and also should not exceed number of dumpfiles of the export
REUSE_DUMPFILES = Y 
-- this can be used to replace existing dump files if same name is given for a new dump file. started in 11.1


expdp DBADMIN@hrtst 
schemas=PSADMN 
directory=HRTST_DATA_PUMP_DIR 
dumpfile=psadmn_hrtst_11-06-2011_11.1.0.7_%U.dmp 
STATUS=30 --This will display the detailed status every 30 secs only on screen but not in log file.
logfile=HRTST_DATA_PUMP_LOG_DIR:psadmn_hrtst_11-06-2011_11.1.0.7.log 
version=11.1.0.7 --This has to be used only it the import has to be done in 11.1.0.7
PARALLEL=2       --this parameter should not exceed more than twice the number of CPUs and also should not exceed number of dumpfiles of the export
REUSE_DUMPFILES = Y -- this can be used to replace existing dump files if same name is given for a new dump file.


-- Import from a dump.
impdp DBADMIN@hrstg           --Connect to the Database where the data has to be imorted
schemas=PSADMN                --schema to be imported
--REMAP_SCHEMA=PSADMN:SYSADM  -- use this if impdp into different schema
directory=HRTST_DATA_PUMP_DIR --Directory where the export dump is present. In this case it is hrtst
dumpfile=psadmn_hrtst_11-06-2011_11.1.0.7_%U.dmp                                                        -- This is to import the data from tst
STATUS=30           --This will display the detailed status every 30 secs only on screen but not in log file.
logfile=HRSTG_DATA_PUMP_LOG_DIR:psadmn_imp_hrtst_11-06-2011_11.1.0.7.log       -- Log file goes here
PARALLEL=2          --this parameter should not exceed more than twice the number of CPUs and also should not exceed number of dumpfiles of the export
REUSE_DUMPFILES = Y -- this can be used to replace existing dump files if same name is given for a new dump file.



impdp DBADMIN@hrstg 
schemas=PSADMN              --schema to be imported
REMAP_SCHEMA=PSADMN:SYSADM 
directory=HRSTG_DATA_PUMP_DIR 
dumpfile=psadmn_hrstg_06-04-2012_%U.dmp 
STATUS=30 --This will display the detailed status every 30 secs only on screen but not in log file.
logfile=HRSTG_DATA_PUMP_LOG_DIR:psadmn_sysadm_imp_hrstg_06-04-2012.log
PARALLEL=2       --this parameter should not exceed more than twice the number of CPUs and also should not exceed number of dumpfiles of the export
REUSE_DUMPFILES = Y -- this can be used to replace existing dump files if same name is given for a new dump file.


select * from dba_datapump_jobs  -- Here get the name of the job which you want to see the status for, then issue below command to see the status.

expdp attach=<job_name_from_above_sql>

-- After the above command you will be in expoer> prompt, at this prompt, issue "status" to see the job status again

impdp attach=SYS_IMPORT_SCHEMA_01

expdp scott/tiger@sids parfile=dept.par  --complete path of the parameter file.