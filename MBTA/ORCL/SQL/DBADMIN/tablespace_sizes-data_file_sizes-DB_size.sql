/*
Below query gives the size of all data file, excluding undo and temp file.
*/

select 
  d.file_name
, round(sum(d.bytes)/1024/1024) - round(sum(f.bytes)/1024/1024) "Actual data in datafile"
, round(sum(d.bytes)/1024/1024) "size of data file"
from 
(select tablespace_name, file_id, file_name, sum(bytes) bytes, autoextensible, sum(maxbytes) maxbytes
             from dba_data_files
             where 1=1
             --file# = file_id
             --and tablespace_name = 'USER_DATA_B'
             group by tablespace_name, file_id, file_name, autoextensible
)    d,
(select tablespace_name, file_id, sum(bytes) bytes from dba_free_space
group by tablespace_name, file_id
) f
where d.tablespace_name in (select tablespace_name from DBA_tablespaces where upper(tablespace_name) not like '%UNDO%')
    and d.tablespace_name = f.tablespace_name(+)
    and d.file_id = f.file_id(+)
group by d.file_name
order by round(sum(d.bytes)/1024/1024) - round(sum(f.bytes)/1024/1024) desc


/* 
#1.   Use below query for details of data files in a table space
This query can be used to find the table space of a given data file or the data files of a given table space. Modify it appropriately for the desired results
This query also can be used to find only the data files which have space left for use 
*/
select d.tablespace_name
       , d.file_id, d.file_name
       , round(d.bytes/ 1024 / 1024)  MB_allocated
       , round(nvl(f.bytes,0)/ 1024 / 1024) MB_free
       , round(d.maxbytes/1024/1024) MB_MAX
       , autoextensible auto_extend
    from (select tablespace_name, file_id, file_name, sum(bytes) bytes, autoextensible, sum(maxbytes) maxbytes
             from dba_data_files
             where 1=1
             --file# = file_id
             --and tablespace_name = 'USER_DATA_B'
             group by tablespace_name, file_id, file_name, autoextensible
            )    d,
           (select tablespace_name, file_id, sum(bytes) bytes from dba_free_space
            group by tablespace_name, file_id
           ) f
    where 1=1
    --and upper(d.file_name) like '%UDF17%'                 -- This condition is used to know the table space of a given data file
   and d.tablespace_name  in ('USER_DATA_B')       -- This condition is used to know the data files of a given table space
    and d.tablespace_name = f.tablespace_name(+)
    and d.file_id = f.file_id(+)
    --and  (round(nvl(f.bytes,0)/ 1024 / 1024) > 0 or ( round(d.maxbytes/1024/1024) <> round(d.bytes/ 1024 / 1024) and round(d.maxbytes/1024/1024)>0))    
    -- The above condition helps in finding the data files of a table space which have some space left
 order by tablespace_name, file_id;



/*
#2.  Same as above(#1) but at summarized tablespace level. Different from the below query (#3.) as there is an extra where condtion in this query to eliminate the datafiles already full.
*/ 
select d.tablespace_name
         --, d.file_id, d.file_name
         , round(sum(d.bytes)/ 1024 / 1024)-round(sum(f.bytes)/1024/1024)  "size_of_data_in_TBS"
         , round(sum(nvl(f.bytes,0)/ 1024 / 1024)) "free_space_in_TBS_bef_grth"
         , round(sum(d.bytes)/1024/1024) "size_of_TBS_bef_grth"       
         , round(sum(decode(d.maxbytes,0,d.bytes,d.maxbytes))/1024/1024)  "TBS_can_grow_to_this_size"
         , round(sum(decode(d.maxbytes,0,d.bytes,d.maxbytes))/1024/ 1024) - round(sum(d.bytes)/1024/1024) + round(sum(f.bytes)/1024/ 1024)    "free_space_in_TBS_aft_grth" 
       --, autoextensible auto_extend
    from (select tablespace_name, file_id, file_name, sum(bytes) bytes, autoextensible, sum(maxbytes) maxbytes
             from dba_data_files
             where 1=1
             --file# = file_id
             --and tablespace_name = 'USER_DATA_B'
             group by tablespace_name, file_id, file_name, autoextensible
            )    d,
           (select tablespace_name, file_id, sum(bytes) bytes from dba_free_space
            group by tablespace_name, file_id
           ) f
    where d.tablespace_name  in (select tablespace_name from DBA_tablespaces)
    and d.tablespace_name = f.tablespace_name(+)
    and d.file_id = f.file_id(+)
    and  (round(nvl(f.bytes,0)/ 1024 / 1024) > 0 or (round(d.maxbytes/1024/1024) <> round(d.bytes/ 1024 / 1024) and round(d.maxbytes/1024/1024)>0))
group by d.tablespace_name--,d.file_name, d.file_id   
 order by 4 desc --tablespace_name--,file_id;




/*
#3.   Below query gives the summery level data of a table space. It gives the allocated space, free space, before growth, after growth, pct used before growth, pct used after growth 
Maximum size of table space after the dbfiles are extended to their max, free space if the db files were extended to max at this moment
Output of the below query is in a tabular format in document located at: C:\MISC\Documents\afc_dbserv_storage_on_server.xlsx which is sent out as email to Adam every week
*/
select tablespace_name
, round(sum(mb_allocated)/1024/1024) "TBS_bef_grth_MB" 
--, round(sum(mb_allocated)/1024/1024) - round(sum(mb_free)/1024/1024) "Used_Space_bef_grth_MB"
, round(sum(mb_free)/1024/1024) "free_space_bef_grth_MB" 
, round(((round(sum(mb_allocated)/1024/1024) - round(sum(mb_free)/1024/1024))/round(sum(mb_allocated)/1024/1024))*100) || '%' "Pct_used_bef_grth"        
, round(sum(decode(mb_max,0,mb_allocated,mb_max))/1024/1024)   "MAX_size_of_TBS_MB"
--"TBS_can_grow_to_this_size"          -- This depends on the free space on ths disk at OS level
, round(sum(decode(mb_max,0,mb_allocated,mb_max))/1024/1024) - round(sum(mb_allocated)/1024/1024) + round(sum(mb_free)/1024/1024) "free_space_aft_grth_MB"   
-- This depends on the free space on ths disk at OS level
, round(((round(sum(mb_allocated)/1024/1024) - round(sum(mb_free)/1024/1024))/round(sum(decode(mb_max,0,mb_allocated,mb_max))/1024/1024))*100) || '%' "Pct_used_MAX"from
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
order by round(((round(sum(mb_allocated)/1024/1024) - round(sum(mb_free)/1024/1024))/round(sum(mb_allocated)/1024/1024))*100) desc
           , round(((round(sum(mb_allocated)/1024/1024) - round(sum(mb_free)/1024/1024))/round(sum(decode(mb_max,0,mb_allocated,mb_max))/1024/1024))*100) desc



/*
# 4.    Run the below Query for Total size of the Database.        
Note that this includes SYSTEM, SYSAUX tablespaces.       
Doesn't include the UNDO, TEMP as they change dynamically and should be treated specially, see #5 and #6 for TEMP and UNDO
size_of_data_in_db_mb is different from size_of_db_on_disk_mb because a data file might be allocated certain size not all of it might be used by data.
*/
select  round(sum(mb_allocated)/1024/1024) - round(sum(mb_free)/1024/1024) "size_of_data_in_DB_mb"
     ,  round(sum(mb_allocated)/1024/1024) "size_of_DB_on_Disk_mb"        -- This could be more than the data because we might have allocate a size to table spaces but might not have data occupying all the space in Table Space
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
             --file# = file_id
             --and tablespace_name = 'USER_DATA_B'
             group by tablespace_name, file_id, file_name, autoextensible
            )    d,
           (select tablespace_name, file_id, sum(bytes) bytes from dba_free_space
            group by tablespace_name, file_id
           ) f
    where d.tablespace_name in (select tablespace_name from DBA_tablespaces where upper(tablespace_name) not like '%UNDO%')
    and d.tablespace_name = f.tablespace_name(+)
    and d.file_id = f.file_id(+)
 order by tablespace_name, file_id
)




/*
#5.   TEMPORARY TABLE SPACE
*/

select tablespace_name
, round(sum(mb_allocated)/1024/1024) "TBS_bef_grth_MB" 
--, round(sum(mb_allocated)/1024/1024) - round(sum(mb_free)/1024/1024) "Used_Space_bef_grth_MB"
, round(sum(mb_free)/1024/1024) "free_space_bef_grth_MB" 
, round(((round(sum(mb_allocated)/1024/1024) - round(sum(mb_free)/1024/1024))/round(sum(mb_allocated)/1024/1024))*100) || '%' "Pct_used_bef_grth"        
, round(sum(decode(mb_max,0,mb_allocated,mb_max))/1024/1024)   "MAX_size_of_TBS_MB"
--"TBS_can_grow_to_this_size"          -- This depends on the free space on ths disk at OS level
, round(sum(decode(mb_max,0,mb_allocated,mb_max))/1024/1024) - round(sum(mb_allocated)/1024/1024) + round(sum(mb_free)/1024/1024) "free_space_aft_grth_MB"   
-- This depends on the free space on ths disk at OS level
, round(((round(sum(mb_allocated)/1024/1024) - round(sum(mb_free)/1024/1024))/round(sum(decode(mb_max,0,mb_allocated,mb_max))/1024/1024))*100) || '%' "Pct_used_MAX"from
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
           sum(free_space) bytes from dba_temp_free_space
            group by tablespace_name--, file_id
           ) f
    where d.tablespace_name in (select tablespace_name from DBA_tablespaces)
    and d.tablespace_name = f.tablespace_name(+)
    --and d.file_id = f.file_id(+)
 order by tablespace_name, file_id
)
group by tablespace_name
order by round(((round(sum(mb_allocated)/1024/1024) - round(sum(mb_free)/1024/1024))/round(sum(mb_allocated)/1024/1024))*100) desc
           , round(((round(sum(mb_allocated)/1024/1024) - round(sum(mb_free)/1024/1024))/round(sum(decode(mb_max,0,mb_allocated,mb_max))/1024/1024))*100) desc


select tablespace_name, sum(bytes_used)/1024/1024 as MB_being_used, sum(bytes_free)/1024/1024 as MB_free
from v$temp_space_header
group by tablespace_name;




/*
#6.   UNDO TABLE SPACE
*/
select  tablespace_name
       ,  round(sum(mb_allocated)/1024/1024) - round(sum(mb_free)/1024/1024) "Size of UNDO in use"
       ,  round(sum(mb_allocated)/1024/1024) "Size of UNDO on Disk"        -- This could be more than the data because we might have allocate a size to table spaces but might not have data occupying all the space in Table Space
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
             --file# = file_id
             --and tablespace_name = 'USER_DATA_B'
             group by tablespace_name, file_id, file_name, autoextensible
            )    d,
           (select tablespace_name, file_id, sum(bytes) bytes from dba_free_space
            group by tablespace_name, file_id
           ) f
    where d.tablespace_name in (select tablespace_name from DBA_tablespaces where upper(tablespace_name) like '%UNDO%')
    and d.tablespace_name = f.tablespace_name(+)
    and d.file_id = f.file_id(+)
 order by tablespace_name, file_id
)
group by tablespace_name




/*
#7.   Data files with Auto Extension enabled and not extended to full. This will help keep track of the space to be left free on the disk to allow the dbf's to auto extend with out any problem.
*/
select tablespace_name, file_id, file_name, autoextensible, sum(bytes)/1024/1024 mbytes, sum(maxbytes)/1024/1024 maxmbytes,  sum(maxbytes)/1024/1024 - sum(bytes)/1024/1024 diffMB
             from dba_data_files
             where 1=1
             --file# = file_id
             --and tablespace_name = 'USER_DATA_B'
             and autoextensible <> 'NO'
             group by tablespace_name, file_id, file_name, autoextensible
having   sum(bytes) <> sum(maxbytes) and sum(maxbytes)/1024/1024 - sum(bytes)/1024/1024 > 5
order by file_name


-- Below are some other helpful queries
---------------------------------------------
select * from dba_free_space  


select * from v$datafile 

where 

select * 
from dba_data_files, v$datafile
where tablespace_name = 'USER_DATA_A'
and file_name = name

select * from dba_tablespaces


select * from dba_data_files

select * from all_objects where upper(object_name) like '%DATA%FILE%'


select * from dictionary where upper(table_name) = 'V$DATAFILE'

select * from DICT_COLUMNS where table_name =  'V$DATAFILE'



SELECT*
FROM dba_data_files ddf
       , v$datafile df
       , dba_free_space dfs
WHERE ddf.tablespace_name = 'USER_DATA_A'
and ddf.file_name = df.name
and  df.file# = dfs.file_id(+)

GROUP BY dfs.file_id, df.NAME, df.file#, df.bytes
ORDER BY file_name;

select * from dba_free_space 


select tablespace_neme from DBA_tablespaces


select * from sys.filext$

select * from dba_data_files


select * from dba_tablespaces

select * from dba_extents

select 	 tablespace_name, substr(file_name,1,4) file_name
from dba_data_files
group by substr(file_name,1,4), tablespace_name
order by 1,2
---------------------------


