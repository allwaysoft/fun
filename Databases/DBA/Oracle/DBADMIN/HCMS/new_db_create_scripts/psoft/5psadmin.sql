-- ****************************************************************** 
-- ORACLE CONFIDENTIAL.  For authorized use only.  Except for as      
-- expressly authorized by Oracle, do not disclose, copy, reproduce,  
-- distribute, or modify.                                             
-- ****************************************************************** 
--                                                                    
-- ******************************************************************
-- ******************************************************************
--
--                          
--
--                                                                  
--
-- ******************************************************************

REMARK -- This script sets up the PeopleSoft Owner ID.  An Oracle DBA is
REMARK -- required to run this script.

set echo on
spool psadmin.log

--ACCEPT ADMIN CHAR PROMPT 'Enter name of PeopleSoft Owner ID: '
--ACCEPT PASSWORD CHAR PROMPT 'Enter PeopleSoft Owner ID password:'
--PROMPT
--PROMPT Enter a desired default tablespace for this user.
--PROMPT
--PROMPT Please Note:  The tablespace must already exist
--PROMPT               If you are unsure, enter PSDEFAULT or SYSTEM -- in our case MBAPP
--PROMPT
--ACCEPT TSPACE CHAR PROMPT 'Enter desired default tablespace:'


REMARK -- Create the PeopleSoft Administrator schema.

create user &&ADMIN identified by &PASSWORD default tablespace &TSPACE
temporary tablespace temp; 
grant PSADMIN TO &&ADMIN;

REMARK -- PeopleSoft Administrator needs unlimited tablespace in order to
REMARK -- create the PeopleSoft application tablespaces and tables in Data
REMARK -- Mover.  This system privilege can only be granted to schemas, not
REMARK -- Oracle roles.

grant unlimited tablespace to &&ADMIN;

REMARK -- Run the commands below to create database synonyms.
REMARK -- Modify the connect string appropriately for your organization.

connect system/sssdp

set echo off

@$ORACLE_HOME/rdbms/admin/catdbsyn
@$ORACLE_HOME/sqlplus/admin/pupbld

spool off
