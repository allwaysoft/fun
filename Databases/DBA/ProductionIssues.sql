-------------------------------------------------------------------------------------------------------------------------------------------------------------
Issue: SQL and ORACLE
-- All of a sudden query/Proc performs poorly
Procs runs fine and all of a sudden then start being very slow.FULL

Fix1: 
This could be due to bad plan for one of the SQLs in the proc, this could be due to many reasons. For a quick and fast fix, remove the plan for all the SQLs in cache and drop/recreate or do 
an inplace alter of the proc so everything relating to those procs are removed from cache.

Fix2: 
If the above doesnt fix it, might have to rebuild stats.
-------------------------------------------------------------------------------------------------------------------------------------------------------------
Issue: SQL SERVER
-- Somes times, the drives doesnt come online or are missing in the disk management too. This sometimes happens during a refresh and the only way to get them back is to reboot the host.

Fix:
Trigger Advanced on the Detach Databases step of BOS-DBSNAP01 plan and click Check All before running
    Trigger Advanced on the Offline Drives step of BOS-SNAP01 plan and click Check All before running
    Snooze alerts for BOS-DBSNAP01 in SentryOne
    Send e-mail to ServerRebootNotices with BOS-DBSNAP01 in the subject line
    Reboot host
    Trigger Advanced on the Online Drives step of the BOS-DBSNAP01 plan and click Check All before running
    Verify that all the drives came online in the Disk Management console
    Trigger Attach Databases step of the BOS-DBSNAP01 plan and let the rest of the plan run
    After verifying that things worked properly override the completion status to force success which will trigger the other jobs
-------------------------------------------------------------------------------------------------------------------------------------------------------------
Issue: SQL SERVER
-- Acadian CORE hangs

-> select * from sysprocesses where spid not in (select spid from sysprocesses where blocked <> 0 or blocked <> spid) --blocking sql
OR
master.[dbo].[Check_Blocking] --Can also run this proc to get the lead and 
OR
Check S1 blocking SQL Tab whch shows the blocking SPIDs tree in the order they are being blocked

-> Try to kill the blocking SPID if it sits in rollback state, try to zap the SPID at OS level.
ssms: kill 123
cmd: taskkill /F /PID pid_number

-> Stop all extended events except for system health and always on health

-> Stop S1 watching on core if required 

-> Get the name of the cmd for background processes
SELECT DISTINCT cmd
FROM sys.sysprocesses
WHERE spid <= 50
      AND status = 'background'
ORDER BY cmd

-> If required, kill all process
--DO this a last resource and the only next step is to stop the service
ALTER DATABASE YourDatabaseName SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
ALTER DATABASE YourDatabaseName set MULTI_USER;

-> If need to restart Service
stop role in cluster manager
start role in cluster manager

-------------------------------------------------------------------------------------------------------------------------------------------------------------
Issue: SQL SERVER
--Multipe jobs fail after adding additional partitions across databases. Selects created core dumps. Tried multiple things like rebuild indexes and check some microsoft documents on bugs but a simple update statistics on partitions tables in some databases fixed the core dump issue and jobs were successful.

--As part of mitigation, we also tried to open a sev1 with Microsoft but we have a contract with lighthouse and we went through it by foloowing this doc https://acadian-asset.atlassian.net/wiki/spaces/IN/pages/312511095/Microsoft+Support but then as we found the solution as line above, we reduced the severioty

select  distinct 'UPDATE STATISTICS ' +s.name+ '.'+  (t.name) + ' WITH SAMPLE 1 PERCENT;'
from sys.tables t join sys.schemas s on t.schema_id = s.schema_id
join sys.indexes i on t.object_id = i.object_id
join sys.partition_schemes ps on i.data_space_id = ps.data_space_id
join sys.partition_functions pf on ps.function_id = pf.function_id

-------------------------------------------------------------------------------------------------------------------------------------------------------------
Issue: SQL SERVER
UDFs in sql server profiler/extended events trace could bring a sql server instance to a crawl. Filter out objectType 20038 in trace to avoid this situation

-------------------------------------------------------------------------------------------------------------------------------------------------------------
Issue: SQL SERVER
--Issue: Create Index takes too long and never finishes

Fix: Here is the magic, I did rebuild the cluster index and then create this new non-clustered index and it completed in 33 seconds. I don’t know why that would make a difference, it worked

-------------------------------------------------------------------------------------------------------------------------------------------------------------
Issue: SQL SERVER
--Blocking SQL Server

select spid.cmd.blocked from svs.sysprocesses where blocked!=0

-------------------------------------------------------------------------------------------------------------------------------------------------------------
Issue: ORACLE
--OEM shows concurrency wait events and digging more in OEM by clicking on the graphs shows that it is caused by "Cursor: pin S wait on X"

--First query and see what are the sessions which are waiting on that event.
    select * from v$session where event='cursor: pin S wait on X';

--Next check the final blocking session for all those waiting on the above event.
    select distinct final_blocking_session from v$session where event='cursor: pin S wait on X';

--Next check what the final_blocking_session-session is doing by issuing below query
    select * from v$session where sid = 439
    --In my case, it was waiting on "gc cr request" event which showed that there was an issue with RAC global cache sync
    --and this session did not have any other final_blocking_session. So, the root cause of concurrency was this session.

