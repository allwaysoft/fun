--Connections and users
--Maximum connections allowed by SQL Server
select * from sys.configurations
where name ='user connections'
-Current open connections count to a SQL Server
select * from sys.dm_os_performance_counters
where counter_name ='User Connections'