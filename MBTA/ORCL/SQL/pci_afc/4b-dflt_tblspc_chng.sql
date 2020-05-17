SET ECHO OFF

/* 
This script changes the default tablespace of the below users
mviewadmin
outln
dbsnmp
*/

SET VERIFY OFF

undef connect_env
undef new_vpath
undef new_loc
undef new_ext
---------- Start Part-1 ---------

--accept connect_env prompt 'Please enter user credentials to run the script. Example:- MBTA/pswd@sid:'

---------- End Part-1   ---------

SET TERMOUT OFF

---------- Start Part 2 ---------

--connect &connect_env
column vpath new_value new_vpath
column loc new_value new_loc 
column ext new_value new_ext
select 'c:\oracle\scripts\logs_' vpath, SYS_CONTEXT ('USERENV', 'DB_NAME') loc, '/dflt_tplspc_chng.log' ext from dual;  
SPOOL &new_vpath&new_loc&new_ext

---------- End Part-2   ---------

---------- Start Part-3 ---------
--
SET ECHO ON
SET TERMOUT ON
SET TIMING ON
--

alter user mviewadmin default tablespace user_Data_a
/
alter user outln default tablespace user_Data_a
/
alter user dbsnmp default tablespace user_Data_a
/

--
SET ECHO OFF
SPOOL OFF
SET TIMING OFF
undef connect_env
--
---------- End Part-3   ---------

---------- Start Part-4 ---------

SET VERIFY ON
PROMPT Log is generated at &new_vpath&new_loc&new_ext

---------- End Part-4   ---------
exit;