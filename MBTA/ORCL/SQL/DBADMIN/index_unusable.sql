-- Below query gives the list of all the unusable indexes


SELECT segment_name, sum(bytes)/1048576 Megs, tablespace_name
from user_extents 
where segment_name in (select index_name from dba_indexes where status = 'UNUSABLE')
group by segment_name, tablespace_name
order by 2

SELECT 'alter index ' || segment_name || ' rebuild online nologging;' || CHR(13) || CHR(10) 
            || 'alter index ' || segment_name || ' logging;' || CHR(13) || CHR(10)
            || '--' ||sum(bytes)/1048576 Megs
FROM user_extents
WHERE segment_name in (select index_name from dba_indexes where status = 'UNUSABLE') 
GROUP BY segment_name
order by megs;


-- Unusable partitioned indexes 

SELECT 'ALTER INDEX ' || segment_name ||' REBUILD PARTITION ' || uip.partition_name ||' NOLOGGING;', 
       'ALTER INDEX ' || segment_name ||' MODIFY PARTITION ' || uip.partition_name ||' LOGGING;',
       sum(bytes)/1048576 Megs, uip.Status
FROM user_extents ue, 
(select index_name, partition_name, status from user_ind_partitions where status <> 'USABLE' group by index_name, partition_name, status) uip 
WHERE segment_name = uip.index_name
and ue.partition_name = uip.partition_name
GROUP BY segment_name, uip.partition_name, uip.status
order by megs


select 'select sysdate from dual;' || CHR(13) || CHR(10) 
     || 'spool off;' || CHR(13) || CHR(10) 
     || 'exit'
from dual;     

select sysdate from dual;
spool off;
exit


-- To make the indexes usable, they have to be rebuilt or dropped and recreated.

-- Default for LOGGING/NOLOGGING is different for global and partitioned indexes. For partitioned indexes NOLOGGING is default, for global indexes LOGGING is default. The NOLOGGING options helps to NOT generate redo log.

--After the indexes are rbuilt, turn on the logging.


select index_name, partition_name, status from user_ind_partitions where index_name = 'XIE3MAINSHIFT' and partition_name = 'MAXVALUE'

select sum(bytes)/1048576 Megs from user_extents where segment_name = 'XIE3MAINSHIFT' and partition_name = 'MAXVALUE'

select index_name, partition_name from dba_ind_partitions where status <> 'USABLE' group by index_name, partition_name

select * from DBA_IND_SUBPARTITIONS

ALTER INDEX indexname REBUILD PARTITION partitionname  nologging;

select * from user_extents






