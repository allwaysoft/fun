
SET ECHO OFF

/* 
This script will take the path of any sql script and run it and place the log in respective folder.
*/

SET VERIFY OFF

---------- Start Part-1 ---------

accept connect_env prompt 'Please enter user credentials to run the script. Example:- DBADMIN/pswd@sid:'
accept script_path prompt 'Enter name of the script to run including full path Eg: $ORACLE_HOME/..../utlrp.sql:'
accept log_name prompt 'Enter the log file name. only name with out path or extension. Eg: utlrp:'

---------- End Part-1   ---------

SET TERMOUT OFF

---------- Start Part 2 ---------

connect &connect_env
column vpath new_value new_vpath
column loc new_value new_loc 
column ext1 new_value new_ext1
column ext2 new_value new_ext2

select '/u01/app/oracle/admin/scripts/logs_' vpath, SYS_CONTEXT ('USERENV', 'instance_name') loc, '/' ext1, '.log' ext2 from dual;  
SPOOL &new_vpath&new_loc&new_ext1&log_name&new_ext2

---------- End Part-2   ---------

---------- Start Part-3 ---------
--
SET ECHO ON
SET TERMOUT ON
SET TIMING ON
--

@&script_path

--
SET ECHO OFF
SPOOL OFF
UNDEF connect_env
SET TIMING OFF
--
---------- End Part-3   ---------

---------- Start Part-4 ---------

SET VERIFY ON
PROMPT Log is generated at &new_vpath&new_loc&new_ext1&log_name&new_ext2

---------- End Part-4   ---------