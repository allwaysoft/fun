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

REMARK create user PEOPLE identified by PEOP1E default tablespace PSDEFAULT
REMARK temporary tablespace PSTEMP;

REMARK GRANT CREATE SESSION to PEOPLE;

drop user MBTACON cascade;

--MBTA Custom changed from PSTEMP to TEMP
create user MBTACON identified by MBTACON1 default tablespace PSDEFAULT
temporary tablespace TEMP;

GRANT CREATE SESSION to MBTACON;

spool off
