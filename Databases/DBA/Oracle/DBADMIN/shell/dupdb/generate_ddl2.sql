set linesize 10000;
set pages 0;
set feedback off;
set echo off;
set trimspool on;
set termout off;
set verify off;
set underline off;
set heading off;

spool dropasmfiles.sql;

select 'ALTER DISKGROUP ' || adg.name || ' DROP FILE ' || '''+' || adg.name || '/' || '&3' || '/' || af.type || '/' || aa.name || ''';'
from v$asm_alias aa 
   , v$asm_diskgroup adg
   , v$asm_file af
where adg.group_number = aa.group_number
and aa.group_number = af.group_number 
and aa.file_number = af.file_number
and lower(adg.name) in ('&1','&2')
and af.type not in ('CONTROLFILE','PARAMETERFILE')
and upper(aa.name) not like 'SPFILE%' 
and upper(aa.name) not like 'CONTROL%';

spool off;

set feedback on;
set echo on;
set trimspool off;
set termout on;
set verify on;
set underline on;
set heading on;