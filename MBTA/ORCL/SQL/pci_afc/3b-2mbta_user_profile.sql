SET ECHO OFF

/* 
-------------
   Creates a MB custom profile which can be assigned to any users created.
-------------
*/

SET VERIFY OFF

---------- Start Part-1 ---------

--accept connect_env prompt 'Please enter user credentials to run the script. Example:- MBTA/pswd@sid:'

---------- End Part-1   ---------

SET TERMOUT OFF

---------- Start Part 2 ---------

--connect &connect_env
column vpath new_value new_vpath
column loc new_value new_loc 
column ext new_value new_ext
select 'c:\oracle\scripts\logs_' vpath, SYS_CONTEXT ('USERENV', 'DB_NAME') loc, '/mbta_user_profile.log' ext from dual;  
SPOOL &new_vpath&new_loc&new_ext

---------- End Part-2   ---------

---------- Start Part-3 ---------
--
SET ECHO ON
SET TERMOUT ON
SET TIMING ON
--

DROP PROFILE MBTA_USER_PROFILE CASCADE
/

CREATE PROFILE MBTA_USER_PROFILE LIMIT
PASSWORD_LIFE_TIME 90
PASSWORD_REUSE_TIME 90
PASSWORD_REUSE_MAX 10
FAILED_LOGIN_ATTEMPTS 10
PASSWORD_LOCK_TIME UNLIMITED
PASSWORD_GRACE_TIME 14
PASSWORD_VERIFY_FUNCTION mbta_user_verify_function
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
exit;