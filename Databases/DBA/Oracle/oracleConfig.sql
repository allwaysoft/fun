--At BCBS we are using automatic SGA and PGA management. Not AMM. Below query gives the values for SGA, PGA and CPU for both the instances of RAC
select inst_id, name, display_value from
(
select * from gv$parameter where name in ('sga_target','sga_max_size')
union
select * from gv$parameter where name like '%pga%'
union 
select * from gv$parameter where name in ('cpu_count', 'parallel_threads_per_cpu')
)
order by 1, 2


select * from gv$parameter where name like '%sessions%'


select
   current_utilization, limit_value
from
   v$resource_limit
where
   resource_name='sessions';