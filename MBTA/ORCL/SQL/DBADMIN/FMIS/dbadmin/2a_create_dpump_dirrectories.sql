
SET ECHO OFF

/* 
1. This is a template script, which can be copied and used as source to create any user defined scripts to run against DB using sqlplus. 
2. please make the below changes after a copy of this script is made. This script is divided into 4 parts.
	Part-1
        ------
        Template already has a connect_env parameter which will be prompted to run the script. 
	Any additional parameters to be passed to user defined script should go here
	
	Part-2
	------
	MUST MUST MUST change the value 'template.log' to 'xx.log' where xx is the name of the script to be run
	
	Part-3
	------
	Replace the '<ACTUAL SCRIPT WHICH HAS TO BE EXECUTED>' with the actual script in this part
	
	Part-4
	------
	None to change at this point
3. Lastly, add new comments to this comments section to include user defined comments related the script.
*/

SET VERIFY OFF

---------- Start Part-1 ---------

--accept connect_env prompt 'Connect as SYS user and run this manually after changing the locations based on the database:'

column datapumpdir new_value new_datapumpdir
column w_schema new_value new_schema
select 'DATA_PUMP_DIR' datapumpdir, SYS_CONTEXT ('USERENV', 'instance_name') w_schema from dual;

---------- End Part-1   ---------

SET TERMOUT OFF

---------- Start Part 2 ---------

--connect &connect_env
column vpath new_value new_vpath
column loc new_value new_loc 
column ext new_value new_ext
select '/u01/app/oracle/admin/scripts/logs_' vpath, SYS_CONTEXT ('USERENV', 'instance_name') loc, '/create_datapump_directories.log' ext from dual;  
SPOOL &new_vpath&new_loc&new_ext

---------- End Part-2   ---------

---------- Start Part-3 ---------
--
SET ECHO ON
SET TERMOUT ON
SET TIMING ON
--

drop directory data_pump_dir
/

drop directory data_pump_log_dir
/
--************ Below was done for hrstg. change the read write permissions based on the db instance this is run for

CREATE OR REPLACE DIRECTORY FNPRDA_DATA_PUMP_DIR as '+FNPRDBFRA'
/

--GRANT READ ON DIRECTORY HRDEV_DATA_PUMP_DIR TO DBADMIN   --only read
--/

--CREATE OR REPLACE DIRECTORY HRTST_DATA_PUMP_DIR as '+HRTSTFRA/HRTST/DUMPSET'
--/

--GRANT READ ON DIRECTORY HRTST_DATA_PUMP_DIR TO DBADMIN  -- only read
--/

--CREATE OR REPLACE DIRECTORY HRSTG_DATA_PUMP_DIR as '+HRSTGFRA/HRSTG/DUMPSET'
--/

--GRANT READ ON DIRECTORY HRSTG_DATA_PUMP_DIR TO DBADMIN  -- only read
--/

--GRANT READ, WRITE ON DIRECTORY &new_schema&new_datapumpdir TO DBADMIN;   --read and write
--/

--CREATE OR REPLACE DIRECTORY HRPAY_DATA_PUMP_DIR as '+HRPAYFRA/HRPAY/DUMPSET'
--/

--GRANT READ ON DIRECTORY HRPAY_DATA_PUMP_DIR TO DBADMIN     --read and write
--/

--CREATE OR REPLACE DIRECTORY HRTRN_DATA_PUMP_DIR as '+HRTRNFRA/HRTRN/DUMPSET'
--/

--GRANT READ ON DIRECTORY HRTRN_DATA_PUMP_DIR TO DBADMIN     --read and write
--/

--CREATE OR REPLACE DIRECTORY HRDMO_DATA_PUMP_DIR as '+HRDMOFRA/HRDMO/DUMPSET'
--/

--GRANT READ, WRITE ON DIRECTORY HRDMO_DATA_PUMP_DIR TO DBADMIN     --read and write
--/

CREATE OR REPLACE DIRECTORY FNPRDB_DATA_PUMP_LOG_DIR as '/u01/app/oracle/admin/fnprdb/dpdump'    -- Log files can't be written to ASM to put them at this location. Based on DB instance, change loc
/
GRANT READ, WRITE ON DIRECTORY FNPRDB_DATA_PUMP_LOG_DIR TO DBADMIN;
/

--
SET ECHO OFF
SPOOL OFF
SET TIMING OFF
--
---------- End Part-3   ---------

---------- Start Part-4 ---------

SET VERIFY ON
PROMPT Log is generated at &new_vpath&new_loc&new_ext

---------- End Part-4   ---------