
SET ECHO OFF

/* 
This script does the below.
---------------------------
1. Creates a users and grant some roles to the user
*/

SET VERIFY OFF

---------- Start Part-1 ---------

accept connect_env prompt 'Please enter user credentials to run the script. Example:- DBADMIN/pswd@sid:'
accept new_user prompt 'Enter new 2-tier user login name (UPPERCASE):'

---------- End Part-1   ---------

SET TERMOUT OFF

---------- Start Part 2 ---------

connect &connect_env
column vpath new_value new_vpath
column loc new_value new_loc 
column ext new_value new_ext
select '/u01/app/oracle/admin/scripts/logs_' vpath, SYS_CONTEXT ('USERENV', 'instance_name') loc, '/new_user.log' ext from dual;  
SPOOL &new_vpath&new_loc&new_ext

---------- End Part-2   ---------

---------- Start Part-3 ---------
SET ECHO ON
SET TERMOUT ON

drop user &new_user cascade 
/ 
CREATE USER &new_user IDENTIFIED BY &new_user PASSWORD EXPIRE DEFAULT TABLESPACE MBAPP TEMPORARY TABLESPACE TEMP
/
grant create session, PS_MB_SIUD to &new_user
/
alter user &new_user quota unlimited on MBAPP default role PS_MB_SIUD
/

SPOOL OFF
SET ECHO OFF
---------- End Part-3   ---------

---------- Start Part-4 ---------

SET VERIFY ON
PROMPT Log of the script is generated at &new_vpath&new_loc&new_ext

---------- End Part-4   ---------