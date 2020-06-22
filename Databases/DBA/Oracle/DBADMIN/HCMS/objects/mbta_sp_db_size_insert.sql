DROP PROCEDURE DBADMIN.MBTA_SP_DB_SIZE_INSERT;

CREATE OR REPLACE PROCEDURE DBADMIN.mbta_sp_db_size_insert
AUTHID  CURRENT_USER
is
--------------------------------------------------------------------------------
-- Procedure: mbta_sp_db_size_insert
--
-- Procedure to insert table space sizes into mbta_db_size_hist table
--
-- AUTHID CURRENT_USER has to be used in this prcedure as the dba_xxx views are used in
-- this procedure. When compiling this procedure, there will be errors, to overcome that,
-- explicit select previlege has to be give to the user who owns the procedure, once it is
-- compiled, the previleges can be revoked and the procedure runs with out errors as
-- AUTHID CURRENT_USER is used.
--
-- Creation :    09-28-2012, Kranthi Pabba
--
-- Purpose  :    Inserts data into mbta_db_size_hist table
--
--
-- Input    :   
--
-- Return   :    Data in mbta_db_size_hist table
--
--------------------------------------------------------------------------------
--
-- Change:
--
--------------------------------------------------------------------------------
begin
insert into dbadmin.mbta_db_size_hist
select trunc(sysdate)
, tablespace_name
, round(sum(mb_allocated)/1024/1024)  
, round(sum(mb_allocated)/1024/1024) - round(sum(mb_free)/1024/1024)
, round(sum(mb_free)/1024/1024)
, round(((round(sum(mb_allocated)/1024/1024) - round(sum(mb_free)/1024/1024))/round(sum(mb_allocated)/1024/1024))*100) || '%'
, round(sum(decode(mb_max,0,mb_allocated,mb_max))/1024/1024)   
, null     
from
( 
select d.tablespace_name
       , d.file_id, d.file_name
       , d.bytes  MB_allocated
       , nvl(f.bytes,0) MB_free
       , d.maxbytes MB_MAX
       , autoextensible auto_extend
    from (select tablespace_name, file_id, file_name, sum(bytes) bytes, autoextensible, sum(maxbytes) maxbytes
          from dba_data_files
          where 1=1
          group by tablespace_name, file_id, file_name, autoextensible
         )    d,
           (select tablespace_name, file_id, sum(bytes) bytes from dba_free_space
            group by tablespace_name, file_id
           ) f
    where d.tablespace_name in (select tablespace_name from DBA_tablespaces)
    and d.tablespace_name = f.tablespace_name(+)
    and d.file_id = f.file_id(+)
 order by tablespace_name, file_id
)
group by tablespace_name
UNION ALL
select trunc(sysdate) 
, tablespace_name
, round(sum(mb_allocated)/1024/1024) 
, round(sum(mb_allocated)/1024/1024) - round(sum(mb_free)/1024/1024)
, round(sum(mb_free)/1024/1024)
, round(((round(sum(mb_allocated)/1024/1024) - round(sum(mb_free)/1024/1024))/round(sum(mb_allocated)/1024/1024))*100) || '%' 
, round(sum(decode(mb_max,0,mb_allocated,mb_max))/1024/1024)          
, null
from
( 
select d.tablespace_name
       , d.file_id, d.file_name
       , d.bytes  MB_allocated
       , nvl(f.bytes,0) MB_free
       , d.maxbytes MB_MAX
       , autoextensible auto_extend
    from (select tablespace_name, file_id, file_name, sum(bytes) bytes, autoextensible, sum(maxbytes) maxbytes
          from dba_temp_files
          where 1=1
          group by tablespace_name, file_id, file_name, autoextensible
         )    d,
           (select tablespace_name, --file_id, 
            sum(free_space) bytes 
            from dba_temp_free_space
            group by tablespace_name--, file_id
           ) f
    where d.tablespace_name in (select tablespace_name from DBA_tablespaces)
    and d.tablespace_name = f.tablespace_name(+)
    --and d.file_id = f.file_id(+)
 order by tablespace_name, file_id
)
group by tablespace_name;

commit;

EXCEPTION WHEN OTHERS
THEN
RAISE_APPLICATION_ERROR ( -20001, SQLERRM);

end;
/
