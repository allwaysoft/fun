set verify off
column file_name format a50 word_wrapped
column smallest format 999,990 heading "Smallest|Size|Poss."
column currsize format 999,990 heading "Current|Size"
column savings  format 999,990 heading "Poss.|Savings"
break on report
compute sum of savings on report

column value new_val blksize

select value from v$parameter where name = 'db_block_size'
/

select file_name,
       ceil( (nvl(hwm,1)*&&blksize)/1024/1024 ) smallest_size_possible,
       ceil( blocks*&&blksize/1024/1024) currsize_size,
       ceil( blocks*&&blksize/1024/1024) - ceil( (nvl(hwm,1)*&&blksize)/1024/1024 ) possible_savings_mb
from dba_data_files a,
     ( select file_id, max(block_id+blocks-1) hwm
         from dba_extents
        group by file_id ) b
where a.file_id = b.file_id(+)
order by 4 desc
/

column cmd format a75 word_wrapped

select 'alter database datafile '''||file_name||''' resize ' ||
       ceil( (nvl(hwm,1)*&&blksize)/1024/1024 )  || 'm;' cmd
     , ceil( blocks*&&blksize/1024/1024) - ceil( (nvl(hwm,1)*&&blksize)/1024/1024 ) possible_savings_mb
from dba_data_files a,
     ( select file_id, max(block_id+blocks-1) hwm
         from dba_extents
        group by file_id ) b
where a.file_id = b.file_id(+)
  and ceil( blocks*&&blksize/1024/1024) -
      ceil( (nvl(hwm,1)*&&blksize)/1024/1024 ) > 0
order by 2 desc      

/* Object hanging at the end

column tablespace_name format a20
column "Name" format a45
break on file_id skip 1
ttitle &1
select file_id, block_id, blocks,
       owner||'.'||segment_name "Name"
from   sys.dba_extents
where  tablespace_name = upper('&1')
UNION
select file_id, block_id, blocks,
       'Free'
from   sys.dba_free_space
where  tablespace_name = upper('&1')
order by 1,2,3
/

*/


select value from v$parameter where name = 'db_block_size'
