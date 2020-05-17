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

REM * Set terminal output and command echoing on; log output of this script.
REM *
set termout on

REM * The database should already be started up at this point from createdb.sql

set echo off

REM * Creates data dictionary views.  Must be run when connected AS SYSDBA
@$ORACLE_HOME/rdbms/admin/catalog.sql;

REM * Creates views of oracle locks
@$ORACLE_HOME/rdbms/admin/catblock.sql;

REM * Scripts for procedural option. Must be run when connected AS SYSDBA
@$ORACLE_HOME/rdbms/admin/catproc.sql;

set echo on
spool utlspace.log

REM * Create a temporary tablespace for database users.
REM *
REM -- MBTA Custom  Below PSTEMP Table Space is not necessary as we can use default TEMP tablespace for everything.
REM CREATE TEMPORARY TABLESPACE PSTEMP
REM TEMPFILE              '+HRSTGDATA/hrstg/tempfile/pstemp01.dbf'           SIZE 300M
REM EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
REM ;

REM * Create a tablespace for database users default tablespace.
REM *
CREATE TABLESPACE       PSDEFAULT
DATAFILE               '+HRDMODATA' SIZE 100M autoextend on next 20M maxsize UNLIMITED 
EXTENT MANAGEMENT LOCAL AUTOALLOCATE
SEGMENT SPACE MANAGEMENT AUTO
;

spool off



