--All Sessions
exec sp_who;

--All Sessions more Info
exec sp_who2;

--Currently executing sessions
exec sp_who3;

 80 = SQL Server 2000    =  8.00.xxxx
 90 = SQL Server 2005    =  9.00.xxxx
100 = SQL Server 2008    = 10.00.xxxx
105 = SQL Server 2008 R2 = 10.50.xxxx
110 = SQL Server 2012    = 11.00.xxxx
120 = SQL Server 2014    = 12.00.xxxx
130 = SQL Server 2016    = 13.00.xxxx
140 = SQL Server 2017    = 14.00.xxxx
150 = SQL Server 2019    = 15.00.xxxx

--Get DB Recovery mode and the last tlog backup time
SELECT   d.name,
         d.recovery_model_desc,
         MAX(b.backup_finish_date) AS backup_finish_date
FROM     master.sys.databases d
         LEFT OUTER JOIN msdb..backupset b
         ON       b.database_name = d.name
         AND      b.type          = 'L'
where d.name = 'accounting'
GROUP BY d.name, d.recovery_model_desc
ORDER BY backup_finish_date DESC;

--Check when a proc was last executed
SELECT o.name,
       ps.last_execution_time
FROM   sys.dm_exec_procedure_stats ps
INNER JOIN
       sys.objects o
       ON ps.object_id = o.object_id
WHERE  DB_NAME(ps.database_id) = 'DataWarehouse'
and o.name like '%SPcdcMergeChanges_warehouse_bnkC%'
ORDER  BY
       ps.last_execution_time DESC

--If creating a new table and renaming to old, things to keep in mind are.
    1. Is the table CDC enabled
    2. Existing grants on the table
    3. Compression on the table. If setting are not right, SSMS might not script the compression options of the existing table to new table.
    4. How is the transaction log growing while the table is created with data inserts from the old table

--Connectoin Pooling
https://blog.pythian.com/sql-server-understanding-and-controlling-connection/

--Inserts
https://www.mssqltips.com/sqlservertutorial/3/sql-server-full-recovery-model/
The "Full" recovery model tells SQL Server to keep all transaction data in the transaction log until either a transaction log backup occurs or the transaction log is truncated. 
The way this works is that all transactions that are issued against SQL Server first get entered into the transaction log and then the data is written to the appropriate data file.  
This allows SQL Server to rollback each step of the process in case there was an error or the transaction was cancelled for some reason.  
So, when the database is set to the "Full" recovery model, since all transactions have been saved you have the ability to do point in time recovery which means you can recover to a point right before a transaction occurred like an accidental deletion of all data from a table    
https://www.mssqltips.com/sqlservertip/1185/minimally-logging-bulk-load-inserts-into-sql-server/

--Transaction Isolation
https://littlekendra.com/2016/02/18/how-to-choose-rcsi-snapshot-isolation-levels/ --Best doc which explains the difference between Read Committed Snapshot vs Snapshot Isolcation. Just read this not any other doc.
https://www.brentozar.com/archive/2013/01/implementing-snapshot-or-read-committed-snapshot-isolation-in-sql-server-a-guide/
https://dba.stackexchange.com/questions/44557/how-do-these-snapshot-isolation-level-configurations-interact-on-a-sql-server-20
[READ_COMMITTED_SNAPSHOT] differs from the SNAPSHOT isolation level in that instead of providing a reader with the last committed version of the row that was available when the transaction started (SNAPSHOT ISOLATION), a reader gets the last committed version of the row that was available when the statement started (READ_COMMITTED_SNAPSHOT)

--NULL NULL NULL...
https://www.red-gate.com/simple-talk/sql/t-sql-programming/how-to-get-nulls-horribly-wrong-in-sql-server/