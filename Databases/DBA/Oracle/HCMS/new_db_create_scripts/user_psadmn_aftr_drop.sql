
SET ECHO OFF

/* 
creates user dbadmin
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
select '/u01/app/oracle/admin/scripts/logs_' vpath, SYS_CONTEXT ('USERENV', 'instance_name') loc, '/user_dbadmin.log' ext from dual;  
SPOOL &new_vpath&new_loc&new_ext

---------- End Part-2   ---------

---------- Start Part-3 ---------
--
SET ECHO ON
SET TERMOUT ON
--

--ACCEPT ADMIN CHAR PROMPT 'Enter name of PeopleSoft Owner ID: '
--ACCEPT PASSWORD CHAR PROMPT 'Enter PeopleSoft Owner ID password:'
--PROMPT
--PROMPT Enter a desired default tablespace for this user.
--PROMPT
--PROMPT Please Note:  The tablespace must already exist
--PROMPT               If you are unsure, enter PSDEFAULT or SYSTEM
--PROMPT
--ACCEPT TSPACE CHAR PROMPT 'Enter desired default tablespace:'


REMARK -- Create the PeopleSoft Administrator schema.


create user &&ADMIN identified by &PASSWORD default tablespace &TSPACE
temporary tablespace TEMP;
grant PSADMIN TO &&ADMIN;

grant unlimited tablespace to &&ADMIN;

connect system/sssdp@&SID;

@$ORACLE_HOME/rdbms/admin/catdbsyn;
@$ORACLE_HOME/sqlplus/admin/pupbld;

UNDEF ADMIN;

--
SET ECHO OFF
SPOOL OFF
--
---------- End Part-3   ---------

---------- Start Part-4 ---------

SET VERIFY ON
PROMPT Log is generated at &new_vpath&new_loc&new_ext

---------- End Part-4   ---------
