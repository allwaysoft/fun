--select count from dba_objects
/*
http://www.techonthenet.com/oracle/sys_tables/
*/

-- All objects
select object_type "Object Type", count(1) "Object Count"
from dba_objects 
where owner = 'PSADMN'  
group by object_type
/

--Tables
select o.owner "Owner", o.object_type "Object Type", table_name "Table Name", t.num_rows "No of Rows", t.tablespace_name "Table Space Name"
       , t.status "Table Status", to_char(s.bytes/1024/1024,'999,999.99') "Table Size MB" 
from dba_tables t, 
        dba_segments s,
        dba_objects o 
where t.owner='PSADMN'
and t.table_name=s.segment_name(+)
and s.segment_type(+) = 'TABLE'
--and s.segment_name = 'PS_TRAINING'
and t.table_name = o.object_name
and o.object_type = 'TABLE'
order by table_name
/ 

--indexes
select o.owner "Owner", o.object_type "Object Type", t.table_name "Table Name", t.index_name "Index Name",  i.column_position "Column Position", i.column_name "Column Name"
       , t.index_type "Index Tye", t.uniqueness "Unique??", t.tablespace_name "Table Space Name", t.status "Index Status", to_char(s.bytes/1024/1024,'999,999.99') "Index Size MB" 
from dba_indexes t,
        dba_ind_columns i, 
        dba_segments s,
        dba_objects o 
where t.owner='PSADMN'
--and t.index_type <> 'LOB'
and t.index_name = i.index_name
and t.index_name=s.segment_name(+)
and s.segment_type(+) = 'INDEX'
--and t.index_name = 'PS_GPFR_DA_COD_LNG'
and t.index_name = o.object_name
and o.object_type = 'INDEX'
order by t.table_name, t.index_name, i.column_position
/

--views
select owner "Owner", 'View' "Object Type", view_name "View Name", read_only "Read Only??"  
from dba_views 
where owner = 'PSADMN' 
order by view_name
/

--lobs
select o.owner "Owner", o.object_type "Object Type",   t.table_name "Table Name", t.column_name "Column Name", t.segment_name "Lob Name"
       , s.segment_type "Lob Type", t.tablespace_name "Table Space Name", to_char(s.bytes/1024/1024,'999,999.99') "Lob Size MB" 
from dba_lobs t, 
        dba_segments s,
        dba_objects o 
where t.owner='PSADMN'
and t.segment_name=s.segment_name(+)
and s.segment_type(+) like '%LOB%'
--and s.segment_name = 'PS_TRAINING'
and t.segment_name = o.object_name
and o.object_type = 'LOB'
order by t.table_name, t.column_name, t.segment_name
/

--triggers
select owner "Owner", trigger_name "Triggeer Name", trigger_type "Trigger Type", triggering_event "Trigger Event"
       , base_object_type "Base Object Type", table_name "Base Object Name", status "Status", fire_once "Fire Once" 
from dba_triggers
where owner = 'PSADMN' order by trigger_name
/

--table view columns
select owner "Owner", table_name "Table Name", column_id "Column Id", column_name "Column Name"
       , data_type "Data Type", data_length "Data Length", nullable "Nullable??" 
from dba_tab_columns 
where owner='PSADMN' 
order by table_name, column_id
/









select * from dba_objects where object_type = 'LOB'

INDEX    27779
LOB    2328
TABLE    23779
TRIGGER    10
VIEW    17184

select object_type, count(1) from dba_objects where owner = 'PSADMN'  group by object_type

select count(1) from dba_ind_columns where index_owner = 'PSADMN'

select count(1) from (select index_name from dba_ind_columns where index_owner = 'PSADMN' group by index_name)

select * from dba_indexes where owner = 'PSADMN' and index_name

select count(1) from dba_lobs where owner = 'PSADMN'

select * from dba_segments where segment_name like '%SYS_LOB%7$$%'

select * from dba_ind_columns

select count(1) from dba_segments 
where owner = 'PSADMN'
and segment_type like '%LOB%'

PS_GPFR_DA_COD_LNG
PS_GPFR_DA_CODE
PS0GPFR_DA_CODE

select * from all_ind_columns where index_name = 'PS_GPFR_DA_COD_LNG'

select count(1) from dba_lobs where owner = 'PSADMN'

select * from dba_segments where segment_name = 'SYS_LOB0000198168C00007$$'

SYS_LOB0000198168C00007$$    AAAPP    
SYS_IL0000198168C00007$$

select * from 

select * from dba_segments  

where segment_name = '' 

select * from dba_objects where object_name = ''

where segment_type = 'LOB'

select * from dba_lobs where owner = 'PSAD'

select object_type, count(1) from dba_objects where owner = 'PSADMN' group by object_type




select count(1) from
(
select index_name from dba_indexes where owner = 'PSADMN' group by index_name
)

select index_name, count(1) from dba_indexes where owner = 'PSADMN' group by index_name order by index_name desc

se

select object_name from dba_objects where owner = 'PSADMN' and object_type = 'INDEX' order by object_name desc

select count(1) from dba_indexes where owner = 'PSADMN' and index_type <> 'LOB' order by index_name desc

select * from dba_objects wherf


select * from dictionary where table_name = 'DBA_INDEXES'

select * from dict_columns where table_name = 'DBA_INDEXES' 

select * from dba_objects

select count(1) from dba_tables where owner = 'PSADMN'

select count(1) from dba_segments where owner = 'PSADMN' and segment_type = 'TABLE'--segment_name = 'PS_TRAINING'



select * from dba_objects where object_name = 'PS_TRAINING'

select * from dba_segments where segment_name = 'PS_TRAINING'


dba_indexes

dba_views

select * from dba_triggers

select * from dba_lobs

select object_type, count(1) 
from dba_objects 
where owner='PSADMN'
group by object_type


select owner, segment_name table_name, to_char(bytes/1024/1024,'999,999.99') table_size_MB
from dba_segments
where segment_type = 'TABLE'
and segment_name not like 'BIN%'
and owner = 'PSADMN'

select * from dba_segments where owner = 'PSADMN'

select * from dba_tables










with tables
    as
    (
    select owner, segment_name table_name, to_char(bytes/1024/1024,'999,999.99') table_size
      from dba_segments
     where owner = 'PSADMN' 
         and segment_type = 'TABLE'
         and segment_name = 'PS_TRAINING' 
         and segment_name not like 'BIN%'
    ),
    indexes
    as
    (
    select index_owner,table_name, index_name, columns, rn,
           (
           select to_char(bytes/1024/1024,'999,999.99') 
           from dba_segments 
           where segment_name = INDEX_NAME 
           and segment_type = 'INDEX' 
           and owner = sub.index_owner 
           ) index_size
   from (
           select index_owner, table_name, index_name,
           substr( max(sys_connect_by_path( column_name, ', ' )), 3) COLUMNS,
           row_number() over (partition by table_name order by index_name) rn
           from dba_ind_columns
           start with column_position = 1 and table_name = 'PS_TRAINING'
           connect by prior table_name = table_name
           and prior index_name = index_name
           and prior column_position+1 = column_position
           group by index_owner,table_name, index_name
           ) sub 
    )
    select decode( nvl(rn,1), 1, tables.table_name ) table_name,
           decode( nvl(rn,1), 1, tables.table_size ) table_size,
               rn "INDEX#",
               indexes.columns,
               indexes.index_name,
               indexes.index_size
      from tables, indexes
     where tables.table_name = indexes.table_name(+)
       and tables.owner = indexes.index_owner(+)
       and tables.table_name = 'PS_TRAINING'
     order by tables.table_name, indexes.rn
     

PS_TRAINING
     
     
push the where clause into the with subqueries.

where segment_type = 'TABLE' and segment_name = 'T'

start with column_position = 1 and table_name = 'T'

Especially push that into the connect by - I dont believe we can automatically do that one.