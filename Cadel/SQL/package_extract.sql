-- export.sql
-- saves package body and spec as separate pkb and pks files.
-- Usage: @export PackageOwner PackageName
set define on
set verify off
set heading off
set serveroutput off
set pause off
set feedback off
set time off
set linesize 1000
set pagesize 0
set trimspool on
--
-- Package Spec
--
spool &package_name..PKS
--
select 'CREATE OR REPLACE ' from dual
/
select text
from dba_source
where owner = '&owner' AND NAME = '&package_name' AND Type = 'PACKAGE'
order by line
/
--
spool off
--
-- Package Body
--
spool &package_name..PKB
--
select 'CREATE OR REPLACE ' from dual
/
select text
from dba_source
where owner = '&owner' AND NAME = '&package_name' AND Type = 'PACKAGE BODY'
order by line
/
--
spool off
--

quit;
