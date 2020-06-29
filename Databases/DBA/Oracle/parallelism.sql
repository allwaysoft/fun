--Parallel degree limits
select inst_id, name, value from gv$parameter
where name in ('parallel_degree_policy','parallel_degree_limit','cpu_count','parallel_threads_per_cpu','parallel_max_servers','parallel_instance_group'); 
--For all instances on a RAC. 
--parallel_degree_policy this parameter drives ONLY if auto dop is used. If this parameter is set to limited, then only tables which have parallel set at table level will get dop automatically. If set to manual. Parallelism behaviour of the DB goes back to before 11.2 version of Oracle, which is based on the below two parameters. So in other words, setting the above parameter to manual does not completely limit parallelism.
--parallel_max_servers this parameter defines the maximum number of server processes that oracle can have at a maximum to handle parallel requests, do not confuse this with DOP which is defined by parallel_degree_limit.
--parallel_threads_per_cpu is uaually OS dependent and is typically 2
--parallel_degree_limit is usually (CPU_COUNT * parallel_threads_per_cpu) or a manual integer. In any case,  this parameter will be used only when PARALLEL_DEGREE_POLICY is set to either AUTO or LIMITED

Note: When a query has explicit parallel hint set, irrespective of the PARALLEL_DEGREE_POLICY, it still uses parallel execution as long as other parameters have values to accommodate parallel execution.
Parallel DML is a different story, it doesnt happen automatically even when PARALLEL_DEGREE_POLICY is set. Please see below.
https://docs.oracle.com/database/121/VLDBG/GUID-5EB01FA8-030B-45BB-9B16-2D13881F6010.htm

select name, value from v$ses_optimizer_env
where name in ('parallel_degree_limit','parallel_max_degree')
and sid=(select sid from v$mystat where rownum=1); --For the specific node where this runs

select inst_id, name, value from gv$parameter where name like '%parallel%'