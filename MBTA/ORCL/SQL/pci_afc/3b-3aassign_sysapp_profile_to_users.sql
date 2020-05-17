SET ECHO OFF

/* 
-------------
   Create individual users to log on to the Database. This is in effor to move away from using application account to log on to the Database.
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
select 'c:\oracle\scripts\logs_' vpath, SYS_CONTEXT ('USERENV', 'DB_NAME') loc, '/assign_sysapp_profile_to_users.log' ext from dual;  
SPOOL &new_vpath&new_loc&new_ext

---------- End Part-2   ---------

---------- Start Part-3 ---------
--
SET ECHO ON
SET TERMOUT ON
SET TIMING ON
--

Alter user system profile MBTA_SYSAPP_PROFILE
/
Alter user sys profile MBTA_SYSAPP_PROFILE
/
alter user outln profile MBTA_SYSAPP_PROFILE
/
alter user dbsnmp profile MBTA_SYSAPP_PROFILE
/
alter user mviewadmin profile MBTA_SYSAPP_PROFILE
/
alter user mbta profile MBTA_SYSAPP_PROFILE
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