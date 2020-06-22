PARALLEL_DEGREE_POLICY this parameter drives ONLY if auto dop is used. 
If above parameter is set to limited, then only tables which have parallel set at table level will get dop automatically. 
If set to manual. Parallelism behaviour of the DB goes back to before 11.2 version of Oracle, which is based on the below two parameters. So in other words, setting the above parameter to manual does not completely limit parallelism.

parallel_max_servers
parallel_threads_per_cpu

Note: When a query has explicit parallel hint set, irrespective of the PARALLEL_DEGREE_POLICY, it still uses parallel execution as long as other parameters have values to accommodate parallel execution.

Parallel DML is a different story, it doesn't happen automatically even when PARALLEL_DEGREE_POLICY is set. Please see below.

https://docs.oracle.com/database/121/VLDBG/GUID-5EB01FA8-030B-45BB-9B16-2D13881F6010.htm