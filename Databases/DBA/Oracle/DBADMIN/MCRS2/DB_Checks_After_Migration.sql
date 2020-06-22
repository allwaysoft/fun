select * from v$version

select unique OBJECT_NAME, OBJECT_TYPE,
OWNER from DBA_OBJECTS where
STATUS='INVALID' and owner not in ('PUBLIC', 'OLAPSYS')

select OBJECT_NAME, OBJECT_TYPE from
DBA_OBJECTS where OBJECT_NAME||OBJECT_TYPE
in (select OBJECT_NAME||OBJECT_TYPE from
DBA_OBJECTS where OWNER='SYS') and
OWNER='SYSTEM' and OBJECT_NAME not in
('AQ$_SCHEDULES_PRIMARY', 'AQ$_SCHEDULES',
'DBMS_REPCAT_AUTH');



select substr(COMP_ID, 1,10) compid,
substr(COMP_NAME,1,24) compname, STATUS,
VERSION from DBA_REGISTRY where
STATUS<>'VALID';



select count(1) from dba_objects where object_type = 'SYNONYM' and owner = 'EMSDBA' --51

select count(1) from dba_objects where object_type = 'SYNONYM' and owner = 'PUBLIC'

select table_owner, count(1) from dba_synonyms where owner = 'PUBLIC' and table_owner in ('EMSDBA','MAXQUEUE') group by table_owner --1933, 3

select table_owner, count(1) from dba_synonyms where owner = 'EMSDBA' group by table_owner --51
 
select table_owner, count(1) from dba_synonyms where owner = 'MAXQUEU' group by table_owner --0

select object_type, count(1) from dba_objects where owner = 'EMSDBA' group by object_type order by count(1) desc

select object_type, count(1) from dba_objects where owner = 'MAXQUEUE' group by object_type order by count(1) desc

select * from dba_synonyms where synonym_name = 'RPT_MBTA_MMBF_SUMMARY_HSU'