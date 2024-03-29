
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

accept connect_env prompt 'Please enter user credentials to run the script. Example:- DBADMIN/pswd@sid:'

---------- End Part-1   ---------

SET TERMOUT OFF

---------- Start Part 2 ---------

connect &connect_env
column vpath new_value new_vpath
column loc new_value new_loc 
column ext new_value new_ext
select '/u01/app/oracle/admin/scripts/logs_' vpath, SYS_CONTEXT ('USERENV', 'instance_name') loc, '/statspack.log' ext from dual;  
SPOOL &new_vpath&new_loc&new_ext

---------- End Part-2   ---------

---------- Start Part-3 ---------
--
SET ECHO ON
SET TERMOUT ON
SET TIMING ON
--

CREATE TABLESPACE STATSPACK 
DATAFILE '+HRDEVDATA' 
SIZE 20M AUTOEXTEND ON NEXT 5M MAXSIZE 1024M 
EXTENT MANAGEMENT LOCAL AUTOALLOCATE SEGMENT SPACE MANAGEMENT AUTO
/

@$ORACLE_HOME/rdbms/admin/spcreate.sql

execute statspack.snap
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