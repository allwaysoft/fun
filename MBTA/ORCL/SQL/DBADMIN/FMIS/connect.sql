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

REMARK -- This script sets up the PeopleSoft Connect ID.
REMARK -- An Oracle DBA is required to run this script prior
REMARK -- to loading a PSOFT database.
REMARK --
REMARK -- If you wish to use the default CONNECTID and PASSWORD,
REMARK -- then run this script as is.
REMARK -- If you wish to change the default CONNECTID and PASSWORD,
REMARK -- DELETE the default CREATE and GRANT statements below and
REMARK -- uncomment the template version modifying the following
REMARK -- parameters <CONNECTID> , <PASSWORD> , <TSPACE>
REMARK --

REMARK -- Create the PeopleSoft Administrator schema.

set echo on
spool connect.log

REMARK -- drop user people cascade;

create user people identified by peop1e default tablespace PSDEFAULT
temporary tablespace PSTEMP;

GRANT CREATE SESSION to people;

REMARK -- drop user <CONNECTID> cascade;

REMARK -- create user <CONNECTID> identified by <PASSWORD> default tablespace <TSPACE>
REMARK -- temporary tablespace <TSPACE>;

REMARK -- GRANT CREATE SESSION to <CONNECTID>;

spool off
