--indexes which could benifit from coalase or rebuild.
select owner,index_name,table_name,blevel from dba_indexes where BLEVEL>3; 

-- Analyze indexes and find out ratio of (DEL_LF_ROWS/LF_ROWS)*100 is > 20
1. First "Analyze the index with validate structure option" and then, IN THE SAME SESSION, DO BELOW.
--index_stats view  stores information from the last ANALYZE INDEX ... VALIDATE STRUCTURE statement.
2. SELECT name,height,lf_rows,del_lf_rows,(del_lf_rows/lf_rows)*100 as ratio FROM INDEX_STATS; 

--Size of the table when compared to size of the indexes of the table
select
   segment_name, segment_type,
   bytes/1024/1024 size_in_mb
from dba_segments
where upper(segment_name) like 'HASTUS_MEASURE%'
and upper(owner)='GIRO'
and upper(segment_type) in ('TABLE','INDEX');
