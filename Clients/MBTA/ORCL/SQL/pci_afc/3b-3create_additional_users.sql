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
select 'c:\oracle\scripts\logs_' vpath, SYS_CONTEXT ('USERENV', 'DB_NAME') loc, '/create_additional_users.log' ext from dual;  
SPOOL &new_vpath&new_loc&new_ext

---------- End Part-2   ---------

---------- Start Part-3 ---------
--
SET ECHO ON
SET TERMOUT ON
SET TIMING ON
--

DROP USER KPABBA CASCADE
/

CREATE USER KPABBA
    PROFILE MBTA_USER_PROFILE
    IDENTIFIED BY "Todaymbta!1"
    DEFAULT TABLESPACE USER_DATA_A
    TEMPORARY TABLESPACE TEMP
    QUOTA UNLIMITED ON TEMP
    QUOTA UNLIMITED ON USER_DATA_A 
    QUOTA UNLIMITED ON USER_DATA_B 
    QUOTA UNLIMITED ON USER_INDEX_A 
    QUOTA UNLIMITED ON USER_INDEX_B 
    ACCOUNT UNLOCK
	PASSWORD EXPIRE
/	

GRANT DBA TO KPABBA
/


DROP USER JWIESMAN CASCADE
/

CREATE USER JWIESMAN
    PROFILE MBTA_USER_PROFILE
    IDENTIFIED BY "Todaymbta!1"
    DEFAULT TABLESPACE USER_DATA_A
    TEMPORARY TABLESPACE TEMP
    QUOTA UNLIMITED ON TEMP
    QUOTA UNLIMITED ON USER_DATA_A 
    QUOTA UNLIMITED ON USER_DATA_B 
    QUOTA UNLIMITED ON USER_INDEX_A 
    QUOTA UNLIMITED ON USER_INDEX_B 
    ACCOUNT UNLOCK
	PASSWORD EXPIRE
/

GRANT DBA TO JWIESMAN
/


DROP USER CRAYMOND CASCADE
/

CREATE USER CRAYMOND
    PROFILE MBTA_USER_PROFILE
    IDENTIFIED BY "Todaymbta!1"
    DEFAULT TABLESPACE USER_DATA_A
    TEMPORARY TABLESPACE TEMP
    QUOTA UNLIMITED ON TEMP
    QUOTA UNLIMITED ON USER_DATA_A 
    QUOTA UNLIMITED ON USER_DATA_B 
    QUOTA UNLIMITED ON USER_INDEX_A 
    QUOTA UNLIMITED ON USER_INDEX_B 
    ACCOUNT UNLOCK
	PASSWORD EXPIRE
/

GRANT DBA TO CRAYMOND
/


DROP USER RCREEDON CASCADE
/

CREATE USER RCREEDON
    PROFILE MBTA_USER_PROFILE
    IDENTIFIED BY "Todaymbta!1"
    DEFAULT TABLESPACE USER_DATA_A
    TEMPORARY TABLESPACE TEMP
    QUOTA UNLIMITED ON TEMP
    QUOTA UNLIMITED ON USER_DATA_A 
    QUOTA UNLIMITED ON USER_DATA_B 
    QUOTA UNLIMITED ON USER_INDEX_A 
    QUOTA UNLIMITED ON USER_INDEX_B 
    ACCOUNT UNLOCK
	PASSWORD EXPIRE
/

GRANT DBA TO RCREEDON
/


DROP USER SHENDERSON CASCADE
/

CREATE USER SHENDERSON
    PROFILE MBTA_USER_PROFILE
    IDENTIFIED BY "Todaymbta!1"
    DEFAULT TABLESPACE USER_DATA_A
    TEMPORARY TABLESPACE TEMP
    QUOTA UNLIMITED ON TEMP
    QUOTA UNLIMITED ON USER_DATA_A 
    QUOTA UNLIMITED ON USER_DATA_B 
    QUOTA UNLIMITED ON USER_INDEX_A 
    QUOTA UNLIMITED ON USER_INDEX_B 
    ACCOUNT UNLOCK
	PASSWORD EXPIRE
/

GRANT DBA TO SHENDERSON
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