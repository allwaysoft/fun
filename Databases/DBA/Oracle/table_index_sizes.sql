select 
   segment_name           table_name,    
   sum(bytes)/(1024*1024) table_size_meg 
from   
   user_extents 
where  
   segment_type='TABLE' 
and    
   segment_name = 'ACTIONLIST' 
   group by segment_name
   
   
   
   select 
   segment_name           table_name,    
   sum(bytes)/(1024*1024) table_size_meg 
from   
   user_extents 
where  
   segment_type='TABLE' 
and    
   segment_name = 'ACTIONLIST' 
   group by segment_name
   
   
select sum(bytes)/(1024*1024) from user_extents where segment_name = 'XIE5CASHLESSPAYMENT'   

select sum(bytes)/(1024*1024) from dba_segments where segment_type='INDEX PARTITION' and segment_name = 'XIE5CASHLESSPAYMENT';



and bytes <> 524288
   
select segment_name index_name, sum(bytes)/(1024*1024) index_size from user_extents    
where  1=1
and segment_type = 'INDEX PARTITION'
and segment_name in
(
'XIE1MISCFUNCITEMMOVEMENT'
,'XIE2MISCFUNCITEMMOVEMENT'
,'XIE6SALESDETAIL'
,'XIE5MISCCARDMOVEMENT'
,'XIE1FUNCITEMMOVEMENT'
,'XIE3SALESTRANSACTION'
,'XIE2SHIFTEVENT'
,'XIE4SHIFTEVENT'
,'XIE3SHIFTEVENT'
,'XIE1SHIFTEVENT'
,'XIE4MISCCARDMOVEMENT'
,'XIE3CASHLESSPAYMENT'
,'XIE7SALESDETAIL'
)
group by segment_name



SELECT PCT_USED FROM INDEX_STATS 
WHERE NAME = 'INDEX';









select * from user_indexes 
where upper(table_name) like 'EVENTHISTORY'

select * from user_indexes 
where upper(table_name) like 'OPENALARM'

where blevel >4
order by blevel desc

select * from sys.dba_tab_modifications



select name as IndexName,height,lf_rows,del_lf_rows
from index_stats
where indexname like 'XIE1EVENTHISTORY';


   select index_name, partition_name, tablespace_name
      from user_ind_partitions
      where status like 'USABLE';