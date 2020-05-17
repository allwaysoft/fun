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

REMARK -- These are the minimum privileges required to run PeopleSoft
REMARK -- applications.  If you plan to run SQL<>Secure, you will need to
REMARK -- grant "execute any procedure" to PSUSER and PSADMIN.

set echo on
spool psroles.log

DROP ROLE PSUSER;
DROP ROLE PSADMIN;

CREATE ROLE PSUSER;
GRANT CREATE SESSION TO PSUSER;

CREATE ROLE PSADMIN;
GRANT 
ANALYZE ANY,
CREATE SESSION, ALTER SESSION,
CREATE TABLESPACE, DROP TABLESPACE,
CREATE ANY TABLE, ALTER ANY TABLE, SELECT ANY TABLE,
INSERT ANY TABLE, UPDATE ANY TABLE, COMMENT ANY TABLE,
DROP ANY TABLE,
CREATE ANY PROCEDURE, ALTER ANY PROCEDURE,
EXECUTE ANY PROCEDURE, DROP ANY PROCEDURE,
CREATE ANY INDEX, DROP ANY INDEX,
CREATE ANY INDEXTYPE, DROP ANY INDEXTYPE,
CREATE ANY SEQUENCE, DROP ANY SEQUENCE,
CREATE PUBLIC SYNONYM, CREATE ANY SYNONYM,
DROP ANY SYNONYM, DROP PUBLIC SYNONYM,
CREATE ANY VIEW, DROP ANY VIEW,
CREATE ANY TRIGGER, ALTER ANY TRIGGER,
ADMINISTER DATABASE TRIGGER, DROP ANY TRIGGER,
CREATE DATABASE LINK,
CREATE PUBLIC DATABASE LINK, 
DROP PUBLIC DATABASE LINK,
CREATE ROLE, DROP ANY ROLE,
CREATE USER
TO PSADMIN WITH ADMIN OPTION;

EXEC DBMS_RESOURCE_MANAGER_PRIVS.GRANT_SYSTEM_PRIVILEGE -
    (GRANTEE_NAME => 'PSADMIN', PRIVILEGE_NAME => 'ADMINISTER_RESOURCE_MANAGER', -
     ADMIN_OPTION => TRUE);
     
conn / as sysdba;
      
GRANT SELECT ON V_$MYSTAT to PSADMIN;

spool off
