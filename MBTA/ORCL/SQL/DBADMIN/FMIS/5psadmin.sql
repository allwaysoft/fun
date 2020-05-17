-- ***************************************************************
--  This software and related documentation are provided under a
--  license agreement containing restrictions on use and
--  disclosure and are protected by intellectual property
--  laws. Except as expressly permitted in your license agreement
--  or allowed by law, you may not use, copy, reproduce,
--  translate, broadcast, modify, license, transmit, distribute,
--  exhibit, perform, publish or display any part, in any form or
--  by any means. Reverse engineering, disassembly, or
--  decompilation of this software, unless required by law for
--  interoperability, is prohibited.
--  The information contained herein is subject to change without
--  notice and is not warranted to be error-free. If you find any
--  errors, please report them to us in writing.
--  
--  Copyright (C) 1988, 2010, Oracle and/or its affiliates.
--  All Rights Reserved.
-- ***************************************************************
 
 
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

--START MBTA custom, commented out below propmpts and hardcoded the values to facilitate running with Grid Control 
--ACCEPT ADMIN CHAR FORMAT 'A8' -
--PROMPT 'Enter name of PeopleSoft Owner ID(max. 8 characters): '
--ACCEPT PASSWORD CHAR FORMAT 'A8' -
--PROMPT 'Enter PeopleSoft Owner ID password(max. 8 characters): '
--PROMPT
--PROMPT Enter a desired default tablespace for this user.
--PROMPT
--PROMPT Please Note:  The tablespace must already exist
--PROMPT               If you are unsure, enter PSDEFAULT or SYSTEM
--PROMPT
--PROMPT ACCEPT TSPACE CHAR PROMPT 'Enter desired default tablespace:'
--END MBTA custom 


REMARK -- Create the PeopleSoft Administrator schema.

create user SYSADM identified by NOACES4P default tablespace MBDVLP
temporary tablespace PSTEMP;
grant PSADMIN TO SYSADM;

REMARK -- PeopleSoft Administrator needs unlimited tablespace in order to
REMARK -- create the PeopleSoft application tablespaces and tables in Data
REMARK -- Mover.  This system privilege can only be granted to schemas, not
REMARK -- Oracle roles.

grant unlimited tablespace to SYSADM;

--START MBTA Custom, below is recommended by Oracle for PS
--Running the AE_SYNCIDGEN process in UA , will generate the following error: 
--Error Message SQL error. Function:  SQL.Execute  Error Position:  7  Return:  1031 - ORA-01031: insufficient privileges 
GRANT SELECT_CATALOG_ROLE to SYSADM;
GRANT EXECUTE_CATALOG_ROLE to SYSADM;
--END MBTA Custom, below is recommended by Oracle for PS

REMARK -- Run the commands below to create database synonyms.
REMARK -- Modify the connect string appropriately for your organization.

connect system/o11gWasm

set echo off

@$ORACLE_HOME/rdbms/admin/catdbsyn
@$ORACLE_HOME/sqlplus/admin/pupbld

spool off


