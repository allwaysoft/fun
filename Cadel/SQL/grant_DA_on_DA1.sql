

set linesize 10000;
set pages 0 emb on newp none;
set feedback off;
set echo off;
set heading off
set trimspool on;
set termout off;
set underline off;

spool grant_da.sql

prompt 

select 'grant delete on DA1.'||object_name||' to DA;' from all_objects
--grant ALL PRIVILEGES on da1.VENDOR_DIRDEP_EMAIL to DA 
where object_type in ('TABLE')
and owner = 'DA1'
and object_name not like '%$%'

--spool C:\tables_date\grant_da.txt

/

spool off