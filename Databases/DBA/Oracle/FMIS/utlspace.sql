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


--#         Create Utility Tablespaces
--#
--#   Change <drive> , and <SID> to the proper values.
--#
--#

set termout on
set echo off

REM * Creates data dictionary views.  Must be run when connected AS SYSDBA
REM @%ORACLE_HOME%\rdbms\admin\catalog.sql 			--uncomment this line later for other environments, fnprda, I have run this before hand so had to comment this.

REM * Creates views of oracle locks
REM @%ORACLE_HOME%\rdbms\admin\catblock.sql 			--uncomment this line later for other environments, fnprda, I have run this before hand so had to comment this.

REM * Scripts for procedural option. Must be run when connected AS SYSDBA
REM @%ORACLE_HOME%\rdbms\admin\catproc.sql 			--uncomment this line later for other environments, fnprda, I have run this before hand so had to comment this.

set echo on
spool utlspace.log

REM * Create a temporary tablespace for database users.
REM *
REM --MBTA custom, below PSTEM tablespace is not necessary as the default TEMP tablespace could be used for this purpose
REM CREATE TEMPORARY TABLESPACE PSTEMP
REM TEMPFILE                '<drive>:\oradata\<SID>\pstemp01.dbf'     SIZE 300M
REM EXTENT MANAGEMENT LOCAL UNIFORM SIZE 128K
REM;

REM * Create a tablespace for database users default tablespace.
REM *
CREATE TABLESPACE       PSDEFAULT
DATAFILE                '+FNPRDADAT'    SIZE 100M       	--change the location in this line based on the environment
EXTENT MANAGEMENT LOCAL AUTOALLOCATE
SEGMENT SPACE MANAGEMENT AUTO
;

spool off