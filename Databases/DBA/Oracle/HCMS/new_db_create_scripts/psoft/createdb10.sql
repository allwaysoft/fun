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
spool /migration/admin/hordmo/logfiles/createdb10.log

startup nomount pfile=$ORACLE_HOME/dbs/inithordmo.ora

create database   hordmo
    maxdatafiles  1021
    maxinstances  1
    maxlogfiles   8
    maxlogmembers 4
    CHARACTER SET WE8ISO8859P15
    NATIONAL CHARACTER SET AL16UTF16
    DATAFILE '/migration/oradata/hordmo/system01.dbf' 
	SIZE 2000M REUSE 
	AUTOEXTEND ON 
	NEXT 5120K 
	MAXSIZE UNLIMITED
	EXTENT MANAGEMENT LOCAL
    SYSAUX DATAFILE '/migration/oradata/hordmo/sysaux01.dbf' 
	SIZE 120M REUSE 
	AUTOEXTEND ON 
	NEXT  5120K 
	MAXSIZE UNLIMITED
    DEFAULT TEMPORARY TABLESPACE TEMP TEMPFILE '/migration/oradata/hordmo/temp01.dbf' 
	SIZE 20M REUSE 
	AUTOEXTEND ON 
	NEXT  640K 
	MAXSIZE UNLIMITED
    UNDO TABLESPACE "HORDMOUNDOTBS1" DATAFILE '/migration/oradata/hordmo/hordmoundots01.dbf' 
	SIZE 300M REUSE 
	AUTOEXTEND ON 
	NEXT  5120K 
	MAXSIZE UNLIMITED
LOGFILE GROUP 1 ('/migration/oradata/hordmo/redo01.log') SIZE 100M,
        GROUP 2 ('/migration/oradata/hordmo/redo02.log') SIZE 100M,
        GROUP 3 ('/migration/oradata/hordmo/redo03.log') SIZE 100M;
spool off
