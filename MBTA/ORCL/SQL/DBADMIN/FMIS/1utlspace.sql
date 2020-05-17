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
@$ORACLE_HOME/rdbms/admin/catalog.sql 			--uncomment this line later for other environments. fnprda, I have run this before hand so had to comment this.

REM * Creates views of oracle locks
@$ORACLE_HOME/rdbms/admin/catblock.sql 		--uncomment this line later for other environments. fnprda, I have run this before hand so had to comment this.

REM * Scripts for procedural option. Must be run when connected AS SYSDBA
@$ORACLE_HOME/rdbms/admin/catproc.sql 			--uncomment this line later for other environments. fnprda, I have run this before hand so had to comment this.

set echo on
spool utlspace.log

REM * Create a temporary tablespace for database users.
REM *
REM 
--MBTA custom, below PSTEM tablespace is not necessary as the default TEMP tablespace could be used for this purpose. Had bring back the pstemp tablespace as we had an issue with ntirety script using asll the temp space in HCMS, this way, alteast the application will not have any problem if the default temp is full for other reasons.
-- Below size of 10GB (changed back to 1GB for dmo environment) is recommended by PS for change assistant time conversion script.
CREATE TEMPORARY TABLESPACE PSTEMP TEMPFILE SIZE 1000M AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1M;

REM * Create a tablespace for database users default tablespace.
REM *
--Start MBTA Modified KP
--CREATE TABLESPACE       PSDEFAULT
--DATAFILE          --'+FNPRDADAT'  -- This is not required as we are using db_file_create_dest patameter    
--SIZE 100M
--EXTENT MANAGEMENT LOCAL AUTOALLOCATE
--SEGMENT SPACE MANAGEMENT AUTO
--;
--
-- Below size is recommended by PS for change assistant time conversion script.
CREATE TABLESPACE PSDEFAULT DATAFILE SIZE 2000M AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED EXTENT MANAGEMENT LOCAL AUTOALLOCATE SEGMENT SPACE MANAGEMENT AUTO;
--End MBTA Modified KP

spool off