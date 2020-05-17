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

REMARK -- Review the parameters in this file and edit
REMARK -- for your environment.
REMARK -- Specifically -
REMARK -- Edit the MAXDATAFILES parameter to use the max
REMARK -- allowed by the operating system platform.
REMARK -- Replace <SID> with your SID.
REMARK -- Edit logfile and datafile names.
REMARK -- Modify the CHARACTER SET if necessary.
REMARK -- This script is using character set WE8ISO8859P15.


set termout on
set echo on
spool createdb.log

startup nomount pfile=$ORACLE_HOME/dbs/init<SID>.ora

create database   <SID>
    maxdatafiles  1021
    maxinstances  1
    maxlogfiles   8
    maxlogmembers 4
    character set WE8ISO8859P15
DATAFILE '/u01/oradata/<SID>/system01.dbf' SIZE 2000M REUSE AUTOEXTEND ON NEXT 10240K MAXSIZE UNLIMITED
UNDO TABLESPACE "PSUNDOTS" DATAFILE '/u01/oradata/<SID>/psundots01.dbf' SIZE 500M REUSE AUTOEXTEND ON NEXT 5120K MAXSIZE UNLIMITED
LOGFILE ('/u01/oradata/<SID>/log01.dbf') SIZE 100M,
        ('/u01/oradata/<SID>/log02.dbf') SIZE 100M,
        ('/u01/oradata/<SID>/log03.dbf') SIZE 100M;
spool off
