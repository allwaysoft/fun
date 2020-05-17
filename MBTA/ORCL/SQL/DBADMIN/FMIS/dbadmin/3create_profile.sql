
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
-------------
   Creates a MB custom profile which can be assigned to any users created.
-------------
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
select '/u01/app/oracle/admin/scripts/logs_' vpath, SYS_CONTEXT ('USERENV', 'instance_name') loc, '/create_profile.log' ext from dual;  
SPOOL &new_vpath&new_loc&new_ext

---------- End Part-2   ---------

---------- Start Part-3 ---------
--
SET ECHO ON
SET TERMOUT ON
SET TIMING ON
--
ALTER PROFILE DEFAULT LIMIT PASSWORD_LIFE_TIME UNLIMITED;
/
DROP PROFILE PS_MB_DEFAULT CASCADE
/
CREATE PROFILE PS_MB_DEFAULT LIMIT
SESSIONS_PER_USER 4
IDLE_TIME 60
FAILED_LOGIN_ATTEMPTS 5
PASSWORD_LIFE_TIME 90
PASSWORD_REUSE_TIME 30
PASSWORD_REUSE_MAX 5
PASSWORD_LOCK_TIME 1/24
PASSWORD_GRACE_TIME 10
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