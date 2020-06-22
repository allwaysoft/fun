--***
--***Final document on what changes are implemented, out of the below proposed is at location C:\MISC\ORACLE\Documents\New_Oracle_Install\FMIS\parameter_chng_implmnted_for_PS_timestamp_scripts.xlsx


1.	Set the following init.ora parameters: 
		db_block_size=8192						Already set
			db_cache_size=325165824				using AMM
			db_file_multiblock_read_count=8		determined automatically in 11g with ASM
job_queue_processes=10
			shared_pool_size=425829120          using AMM
			pga_aggregate_target=5871947670		using AMM
		parallel_max_servers=8              	Already set to more than praposed
		workarea_size_policy=AUTO				Already set

			Note. If you are using Oracle 10g or higher, you may use the parameters 			using AMM
			SGA_TARGET=300M and 																using AMM
			SGA_MAX_SIZE=350M instead of SHARED_POOL_SIZE, DB_CACHE_SIZE, and DB_BLOCK_BUFFERS. using AMM

2.	Pre-allocate the PSTEMP tablespace to at least 10 GB. 
3.	Pre-allocate the PSDEFAULT tablespace to at least 2 GB with 10-MB local uniform extents. 
4.	Ensure that you have at least six redo logs sized at 500 MB each. 


-- Did below to implement above.

CREATE TEMPORARY TABLESPACE PSTEMP TEMPFILE SIZE 10000M AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED EXTENT MANAGEMENT LOCAL UNIFORM SIZE 1M;

ALTER DATABASE DATAFILE '+FNPRDADAT/fnprda/datafile/psdefault.266.797701415' RESIZE 2000M;
ALTER DATABASE DATAFILE '+FNPRDADAT/fnprda/datafile/psdefault.266.797701415'AUTOEXTEND ON NEXT 10M MAXSIZE UNLIMITED;

ALTER DATABASE DATAFILE '+FNPRDADAT/fnprda/datafile/mbdvlp.371.797701569' RESIZE 2000M;


ALTER DATABASE ADD LOGFILE THREAD 1
GROUP 4 ('+FNPRDADAT','+FNPRDAFRA') SIZE 500M,
GROUP 5 ('+FNPRDADAT','+FNPRDAFRA') SIZE 500M,
GROUP 6 ('+FNPRDADAT','+FNPRDAFRA') SIZE 500M;

alter database drop logfile group 1;
alter database drop logfile group 2;
alter database drop logfile group 3;

ALTER DATABASE ADD LOGFILE THREAD 1
GROUP 1 ('+FNPRDADAT','+FNPRDAFRA') SIZE 500M,
GROUP 2 ('+FNPRDADAT','+FNPRDAFRA') SIZE 500M,
GROUP 3 ('+FNPRDADAT','+FNPRDAFRA') SIZE 500M;

ALTER SYSTEM SET job_queue_processes = 10 scope=both;