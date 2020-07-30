-- https://blogs.oracle.com/datawarehousing/configuring-and-controlling-auto-dop -Good read on Auto DOP
--Parallel degree limits
select inst_id, name, value from gv$parameter
where name in ('parallel_degree_policy','parallel_degree_limit','cpu_count','parallel_threads_per_cpu','parallel_max_servers','parallel_instance_group'); 
--For all instances on a RAC.

--PARALLEL_DEGREE_POLICY, If this parameter is set to LIMITED, then DOP kicks in and oracle determines DOP based on the table/index docorated with DEFAULT DOP. Hints override this DOP
                                                             --If set to AUTO, auto DOP is applied to all statements regardless of the table/index DOP decorations. Hints override this DOP
                                                             --If set to MANUAL, Parallelism behaviour of the DB goes back to before 11.2 version of Oracle, which is based on  PARALLEL_MAX_SERVERS, PARALLEL_THREADS_PER_CPU parameters and is dependent on table and index decorations. 
                                                                      --So in other words, setting the above parameter to manual does not completely limit parallelism. You can still use Hints to have DOP 
                  --How to limit the DOP computed by Auto DOP
                  --The DOP computed by the optimizer with Auto DOP can be quite high depending on the resource requirements of the statement. You can limit the DOP using the initialization parameter parallel_degree_limit or Database Resource Manager (DBRM).

--PARALLEL_DEGREE_LIMIT
--This parameter limits the DOP that can be computed by the optimizer. After computing the DOP the optimizer looks at this parameter and adjusts the DOP accordingly and generates a plan based on the adjusted DOP.                                                                      
--PARALLEL_DEGREE_LIMIT is usually (CPU_COUNT * parallel_threads_per_cpu) or a manual integer. In any case,  this parameter will be used only when PARALLEL_DEGREE_POLICY is set to either AUTO or LIMITED

--PARALLEL_MAX_SERVERS this parameter defines the maximum number of server processes that oracle can have in an instance to handle parallel requests, do not confuse this with DOP which is defined by parallel_degree_limit.
--PARALLEL_THREADS_PER_CPU is uaually OS dependent and is typically 2

Note: When a query has explicit parallel hint set, irrespective of the PARALLEL_DEGREE_POLICY, it still uses parallel execution as long as other parameters have values to accommodate parallel execution.
Parallel DML is a different story, it doesnt happen automatically even when PARALLEL_DEGREE_POLICY is set. Please see below.
https://docs.oracle.com/database/121/VLDBG/GUID-5EB01FA8-030B-45BB-9B16-2D13881F6010.htm

select name, value from v$ses_optimizer_env
where name in ('parallel_degree_limit','parallel_max_degree')
and sid=(select sid from v$mystat where rownum=1); --For the specific node where this runs

select inst_id, name, value from gv$parameter where name like '%parallel%'