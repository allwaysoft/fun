--**************
--************** PLEASE MAKE SURE PATCH FOR PEOPLE SOFT ARE INSTALLED ON ORACLE HOME BEFORE PROCEEDING****
--**************

--*************Automatic Memory Management (AMM) on 11g [ID 443746.1]
--
-- All the below parameter need not be set as we are using AMM
--
--db_cache_size
--shared_pool_size
--pga_aggregate_target
--SGA_TARGET
--SGA_MAX_SIZE
--SHARED_POOL_SIZE
--DB_CACHE_SIZE
--DB_BLOCK_BUFFERS
--*************Automatic Memory Management (AMM) on 11g [ID 443746.1]

-- Below parameter should be equal to the number of days of the rman retention policy. In HCMS,
-- the retention policy is set to 35 days.
	

alter system set log_archive_format = 'FNPRDB_%s_%t_%r.ARC' scope=spfile;

--Increase flash/fast recovery are
alter system set db_recovery_file_dest_size=153000G SCOPE=BOTH;

--DB_RECOVERY_FILE_DEST_SIZE should be set before setting DB_RECOVERY_FILE_DEST
ALTER SYSTEM SET DB_RECOVERY_FILE_DEST='+HRTRNFRA' SCOPE=BOTH;

alter system set log_archive_dest_10='location=USE_DB_RECOVERY_FILE_DEST' scope=both;
alter system set log_archive_dest_1='location=USE_DB_RECOVERY_FILE_DEST' scope=both;
alter system set log_archive_dest_1='' scope=both;
alter system set log_archive_dest_2='' scope=both;
alter system set log_archive_dest_10='' scope=both;

-- Below, I had to set to improve the performance of alter audit program of peoplesoft. 
-- BUT BUT BUT BUT this parameter should not be set in 11g but will be determined automatically.
alter system reset db_file_multiblock_read_count scope=spfile;  
alter system set db_file_multiblock_read_count=16 scope=both;

-- To enable emailing from the Database.
http://docs.oracle.com/cd/B28359_01/appdev.111/b28419/u_mail.htm
alter system set smtp_out_server='smtprelayhs.mbta.com' scope=both;



--alter system set memory_max_target=10G scope=spfile;
--alter system set memory_target=8G scope=spfile;

--alter system set memory_max_target=1536M scope=spfile;
--alter system set memory_target=1536M scope=spfile;

--alter system set log_archive_max_processes=4 scope=both;

--alter system set memory_max_target=2048M scope=spfile;
--alter system set memory_target=2048M scope=spfile;



-- This is to solve the issue of huge trace file generation. Refer to MOS doc 1380006.1 to findout more. 
-- This parameter should be coupled with filesystemio_options below. set filesystemio_options to async if disk_asynch_io is set to true
-- Do not set this to false if async io has to be used.
****** IMPORTANT ****** 
****** At this point do the following from doc ID 139272.1 and bounce the DB to enable asynch io.
******
alter system set disk_asynch_io=true scope=spfile;

select file_no,filetype_name,asynch_io from v$iostat_file;

-- This is to solve the issue of huge trace file generation. If using ASM this parameter has no effect. With ASM, disk_async_io above is used. See Doc: 120697.1
alter system set filesystemio_options=none scope=spfile
alter system set filesystemio_options=asynch scope=spfile;

-- when I have time. Also do as mentioned in below link to check the rate of transfer. 
http://www.oracle-base.com/articles/misc/measuring-storage-performance-for-oracle-systems.php


alter system set BACKUP_TAPE_IO_SLAVES=true scope=spfile;


Do not set the below parameter to more than 1, if the disk_asynch_io is set to true.
alter system set db_writer_processes=1 scope=spfile;


-- This is to solve the "minact-scn master-status: grec-scn:0x0000.00000000 gmin-scn:0x0000.00000000 gcalc-scn:0x0000.00000000" issue in trace file. MOS note: 1361567.1
alter system set "_enable_minscn_cr"=false scope=spfile;
alter system set "_smu_debug_mode"=134217728 scope=spfile;

--UNDO_RETENTION(seconds) parameter should always be greater thatn the value of the below query.
--select max(maxquerylen) from v$undostat; -- this gives the time in seconds taken by the longest running query.
--ALTER SYSTEM SET UNDO_RETENTION = 30 scope=both;

ALTER SYSTEM SET recyclebin = OFF DEFERRED scope=both;

-- Hidden parameter change recommended by Oracle for peoplesoft env.
alter system set "_unnest_subquery" = false scope=both;
alter system set "_gby_hash_aggregation_enabled"=false scope=both;

GRANT SELECT_CATALOG_ROLE to SYSADM;
GRANT EXECUTE_CATALOG_ROLE to SYSADM;

--No Licence for this. This is diagnostics and tuning pack
alter system set control_management_pack_access = NONE  scope=both;

--This is Deprecated in 11G. reset removes it from spfile. insted use diag parameter
alter system reset BACKGROUND_DUMP_DEST scope=spfile;

-- This is Deprecated in 11G. reset removes it from spfile. insted use diag parameter
alter system reset USER_DUMP_DEST scope=spfile;

-- Below parameter is to ensure that datapump doesn't fail with ORA-39079. Set this parameter if the memory target is 1G if more than 1G then no problem even with out this parameter.
alter system set streams_pool_size = 150m scope=both;

-- This is to make temp as default table space of the Database. Use only one temp for database to save disk space.
ALTER DATABASE DEFAULT TEMPORARY TABLESPACE temp;

-- Set the mttr target. This defines the time in seconds to revocer the instance after a crash.
-- use 3600 seconds for below parameter and run for a while and query the v$instance_recovery for the target_mttr value, set value of FAST_START_MTTR_TARGET to the target_mttr.
ALTER SYSTEM SET FAST_START_MTTR_TARGET=3600 scope=both;      -- If this parameter has to be set to a value other than 0 below three parameter have to be set to 0.
----------ALTER SYSTEM SET FAST_START_IO_TARGET=0 scope=both; -- This parameter is deprecated in 11gr2
ALTER SYSTEM SET LOG_CHECKPOINT_INTERVAL=0 scope=both;
ALTER SYSTEM SET LOG_CHECKPOINT_TIMEOUT=0 scope=both;


--***********Below parameters are to ensure that one loggroup goes to data and one to fra diskgroups.
--CAUTION CHANGE LOCATION NAME ACCORDINGLY
--alter system set db_create_online_log_dest_1='+DATA' scope=both; 

--CAUTION CHANGE LOCATION NAME ACCORDINGLY
--alter system set db_create_online_log_dest_2='+FRA' scope=both;  
--***********


-- Below parameter is to turn on the parallelism at the DB lvel. See link below for more info. Still haven't decided on what to do.
https://blogs.oracle.com/datawarehousing/entry/auto_dop_and_parallel_statemen

http://www.oracle.com/technetwork/database/bi-datawarehousing/twp-parallel-execution-fundamentals-133639.pdf 
Init.ora Parameter "PARALLEL_DEGREE_POLICY" Reference Note [ID 1216277.1]
--parallelism and different ways to enable it at different situations.

alter system set parallel_degree_policy=LIMITED scope=both; -- This value is MANUAL by default.


--Also make sure to add additional log files to FRA and delete additional from DATA
alter database add logfile member '+HRDEVDATA' to group 1;
ALTER DATABASE DROP LOGFILE MEMBER '+HRDEVFRA/hrdev/onlinelog/group_3.267.762396211'

************************************
-- Below paremteters force optimizer to choose index scan over a full table scan. Didn't change these as there were drawbacks of doing this. Instead, did sql plan management for problematic sql.

SQL> alter system set OPTIMIZER_INDEX_CACHING=50 scope=spfile;
SQL> alter system set  OPTIMIZER_INDEX_COST_ADJ = 5 scope=spfile;

Init.ora Parameter "OPTIMIZER_INDEX_COST_ADJ" Reference Note [ID 62285.1]
Tuning Queries: 'Quick and Dirty' Solutions [ID 207434.1]
Bug 6251917 - Merge join Cartesian setting optimizer_index_caching and optimizer_index_cost_adj [ID 6251917.8]
Bug 5578791 - Combination of optimizer_index_caching and optimizer_index_cost_adj increases Cost [ID 5578791.8]
DataPump Export Of Partitioned Table Is Very Slow And Apparently Hangs [ID 752904.1]

************************************
--**********************************************************
--			PARAMETER CHANGES SUGGESTED BY NITIN
--**********************************************************

alter system set session_cached_cursors =100 scope=spfile; -- done this in HRPRD

--How to determine the correct setting for JOB_QUEUE_PROCESSES [ID 578831.1]
--ALTER SYSTEM SET job_queue_processes = 5 scope=both;
ALTER SYSTEM SET job_queue_processes = 10 scope=both;   --changed above from 5 to 10, recommended for PS timestamp conversiont script.

alter system set open_cursors = 600 scope=both;

alter system set utl_file_dir = "/usr/tmp" scope=spfile;
alter system set processes = 500 scope=spfile;
alter system set sessions = 555 scope=spfile;
alter system set transactions = 610 scope=spfile;
-----Do not do below unless required
alter system set memory_max_target=2G scope=spfile;
alter system set memory_target=2G scope=spfile;


--**********************************************************
--		END	PARAMETER CHANGES SUGGESTED BY NITIN
--**********************************************************



--*********** Grid Infra Parameters
SRVM_TRACE="false"    -- Look at the Doc: 1192676.1 for more information on how this parameter has to be set. 
add the above parameter at the top of the cluvfy script in the <grid_infrastructure_home>/bin directory and this resolves the issue. to my best knowledge, I have done this only on hsuxb4vm1

logs are at location /u00/app/grid/product/11.2.0/grid/cv/log

--***********************************
--***********************************
--ASM Instance -- Below parameter you can set it via asmca, just add a new path with a "," in the GUI.
-- these parameter strings are correct. if Mark gives the disk as /dev/disk/*, there there will be an equivalant /dev/rdisk/*. Always use rdisk for granting permissions on disks to grid.

--****Below parameter has the path for both the original name and the alias name. ALWAYS have permissions of only one disk (either original or alias) changed to
--******grid. Having both of them changed to grid will cause error "Duplicate disk ...." Also have only value for the asm_diskstring
--********path (either path for alias of the original disk). In our case we are using the alias names location hence only /dev/rdisk/d* should be in the path.  

--alter system set asm_diskstring='/dev/rdsk/c*, /dev/rdisk/d*' scope=both;  --DO NOT USE THIS        
--alter system set asm_diskstring='/dev/rdisk/d*' scope=both;          		 --USE THIS

-- This parameter is used to add more discovery paths to diskstring parameter so that the 
--disks under those paths can be used as asm disks. I had to add an additiona path to the string as the location of the disks changed as you can see above.
--***********************************
--***********************************

--------------------------------------
PARAMETER RECOMMENDATIONS
--------------------------------------

http://docs.oracle.com/cd/E11882_01/server.112/e16638/instance_tune.htm

10.5.2.2 Reducing Checkpoint Frequency to Optimize Run-Time Performance
To reduce the checkpoint frequency and optimize run-time performance, you can do the following:

•Set the value of FAST_START_MTTR_TARGET to 3600. This enables Fast-Start checkpointing and the Fast-Start Fault Recovery feature, but minimizes its effect on run-time performance while avoiding the need for performance tuning of FAST_START_MTTR_TARGET.

•Size your online redo log files according to the amount of redo your system generates. Try to switch logs at most every twenty minutes. Having your log files too small can increase checkpoint activity and reduce performance. Also note that all redo log files should be the same size.
