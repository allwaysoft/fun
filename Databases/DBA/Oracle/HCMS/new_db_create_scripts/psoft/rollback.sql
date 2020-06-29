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

REM *
REM * Create rollback segments.
REM *

set echo on
spool rollback.log

create rollback segment r01 tablespace PSRBS
  storage (minextents 4 maxextents 20 optimal 16M);
create rollback segment r02 tablespace PSRBS
  storage (minextents 4 maxextents 20 optimal 16M);
create rollback segment r03 tablespace PSRBS
  storage (minextents 4 maxextents 20 optimal 16M);
create rollback segment r04 tablespace PSRBS
  storage (minextents 4 maxextents 20 optimal 16M);
create rollback segment rbsbig tablespace PSRBS
  storage (initial 8M next 8M minextents 4 maxextents 32 optimal 32M);

alter rollback segment rbsbig online;
alter rollback segment r00 offline;

spool off

