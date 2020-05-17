-- ****************************************************************** 
-- ORACLE CONFIDENTIAL.  For authorized use only.  Except for as      
-- expressly authorized by Oracle, do not disclose, copy, reproduce,  
-- distribute, or modify.                                             
-- ****************************************************************** 
--                                                                    
--  PEOPLESOFT 8.41 DATABASE INSTALL TO CREATE TABLESPACES - PT
-- ******************************************************************
-- ******************************************************************
--
--                          
--
--   $Header:
--
-- ******************************************************************
--
--  THIS SCRIPT BUILDS NEW TABLESPACES ADDED TO TOOLS 8.41.  THE
--  TABLESPACE PSIMGR WAS ADDED TO ACCOMODATE 
--  TABLES THAT REQUIRE ROW LEVEL LOCKING. THE REL841.SQL SCRIPT
--  CREATES TABLES IN THIS NEW TABLESPACE AND IT IS NECESSARY TO RUN
--  THIS SCRIPT PRIOR TO RUNNING REL841.SQL. OTHERWISE YOU WILL RECEIVE
--  TABLESPACE NOT FOUND ERROR MESSAGE. RUN THIS SCRIPT ON ORACLE
--  USING SQLPLUS.
--
--  IMPORTANT!!
--  *RUN THIS SCRIPT BEFORE REL841.SQL.
--  *THIS SCRIPT MUST BE RUN FOR THE FIN/SCM APPLICATION ONLY.
--
--  REQUIREMENTS
--        THIS SCRIPT IS ONLY REQUIRED FOR INSTALLS.  THE TABLESPACES ARE
--        CREATED IN ANOTHER SCRIPT FOR THE UPGRADE PROCESS.
--
--  FOR YOUR INFORMATION
--        1) CREATE ALL TABLESPACES BELOW. IF THEY ALREADY EXIST ON YOUR
--           DATABASE, IT WILL NOT BE NECESSARY TO RUN THIS SCRIPT.
--        2) PEOPLESOFT RECOMMENDS USING STANDARD TABLESPACE NAMES
--           AS SPECIFIED BELOW
--        3) GLOBALLY MAKE THE FOLLOWING EDITS:
--
--           CHANGE <u01> AND <SID> TO THE APPROPRIATE VALUES FOR YOUR SYSTEM

set echo on
spool ts841.log


CREATE TABLESPACE PSIMGR DATAFILE '/u01/oradata/<SID>/psimgr.dbf' SIZE 8M
EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1M
SEGMENT SPACE MANAGEMENT AUTO
;

spool off

