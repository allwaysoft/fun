SQL Server Health Check--SQL Server Uptime
SELECT @@servername, sqlserver_start_time FROM sys.dm_os_sys_info

--SQL windows Services and their uptime
select * from sys.dm_server_services

--Databases current Health and Create Date
SELECT name, create_date, state_desc, recovery_model FROM sys.databases st

--Query to check the synchronization status of databases. Can be run on primary and ror
SELECT AGS.NAME AS AGGroupName
    ,db_name(DRS.database_id) databaseName
    ,AR.replica_server_name AS InstanceName
    ,HARS.role_desc
    ,DRS.synchronization_health_desc as SyncHealth
    ,DRS.synchronization_state_desc AS SyncState
    ,DRS.last_hardened_time
    ,DRS.last_redone_time
    ,((DRS.log_send_queue_size)/8)/1024 QueueSize_MB
    ,datediff(MINUTE, last_redone_time, last_hardened_time) as Latency_Minutes
FROM sys.dm_hadr_database_replica_states DRS
LEFT JOIN sys.availability_replicas AR ON DRS.replica_id = AR.replica_id
LEFT JOIN sys.availability_groups AGS ON AR.group_id = AGS.group_id
LEFT JOIN sys.dm_hadr_availability_replica_states HARS ON AR.group_id = HARS.group_id
    AND AR.replica_id = HARS.replica_id

--RAM allocated to SQL Server, could expand this to CPU and other resources. WIP
SELECT object_name, cntr_value
FROM sys.dm_os_performance_counters
WHERE counter_name IN ('Total Server Memory (KB)', 'Target Server Memory (KB)');

-- SQL Server 2012:
    SELECT physical_memory_kb FROM sys.dm_os_sys_info;

-- Prior versions:
    SELECT physical_memory_in_bytes FROM sys.dm_os_sys_info;
    EXEC sp_configure 'max server memory';
    SELECT
    (physical_memory_in_use_kb/1024) AS Memory_usedby_Sqlserver_MB,
    (locked_page_allocations_kb/1024) AS Locked_pages_used_Sqlserver_MB,
    (total_virtual_address_space_kb/1024) AS Total_VAS_in_MB,
    process_physical_memory_low,
    process_virtual_memory_low
    FROM sys.dm_os_process_memory;