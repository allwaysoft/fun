SET ECHO OFF

/* 
----------
This script creates a database level trigger to alter any users schem to PSADMN when logged in.
----------
*/

SET VERIFY OFF

---------- Start Part-1 ---------

--accept connect_env prompt 'Please enter user credentials to run the script. Example:- mbta/pswd@sid:'

---------- End Part-1   ---------

SET TERMOUT OFF

---------- Start Part 2 ---------

--connect &connect_env
column vpath new_value new_vpath
column loc new_value new_loc 
column ext new_value new_ext
select 'c:\oracle\scripts\logs_' vpath, SYS_CONTEXT ('USERENV', 'DB_NAME') loc, '/set_session_schema_at_login.log' ext from dual;  
SPOOL &new_vpath&new_loc&new_ext

---------- End Part-2   ---------

---------- Start Part-3 ---------
--
SET ECHO ON
SET TERMOUT ON
SET TIMING ON
--

CREATE OR REPLACE TRIGGER MBTA_SET_DEFLT_SESSION
   AFTER LOGON ON DATABASE
   WHEN (upper(USER) IN ('KPABBA','JWIESMAN','CRAYMOND','RCREEDON','SHENDERSON')
         )                                                                
   BEGIN                                                          
           execute immediate 'alter session set current_schema=MBTA';
   EXCEPTION
    WHEN OTHERS
      THEN
      RAISE_APPLICATION_ERROR(-20001,SQLERRM);
   --SUBSTR(SQLERRM);
   END;
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