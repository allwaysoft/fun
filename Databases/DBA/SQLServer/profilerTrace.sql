Like DBMS_Profiler in oracle, to know the bottleneck in a procedure in SQL Server, all one needs to do is run the proc and before running, hit the show execution plan button, which will show all the executions plans of SQLs and also the percent of time spent with each of those SQLs. 

Now we know which SQL is the culprit and we can tune that SQL accordingly.

SQL Profiler in SQL Server also provides profile information and is used mostly to trace the sessions of an application where you cant manually execute procs in SSMS but only app can run the process

SQL Batch Complete is a group of statements executed with a GO at the end
SQL Statement Complete is every single SQL statement completed


When tracing always filter out ObjectType 20038 if there is UDF in the code being traced.

select * from sys.traces --Shows all the traces running on an instance
select * from sys.dm_xe_sessions --Shows all the extended events running on an instance
select * from sys.fn_trace_getinfo(0) --Shows all the extended events running on an instance


--All trace flags and descriptions in SQL Server

https://github.com/ktaranov/sqlserver-kit/blob/master/SQL%20Server%20Trace%20Flag.md


--**************************
--DEFAULT TRACE in SQL SERVE
--**************************

https://blogs.technet.microsoft.com/beatrice/2008/04/29/sql-server-default-trace/
--Check the properties of the default trace on a server

SELECT *   FROM ::fn_trace_getinfo(default);

SELECT distinct e.name as Event_Description    --All the events that are captured by default trace on a server.
  FROM ::fn_trace_geteventinfo(1) t
    JOIN sys.trace_events e ON t.eventID = e.trace_event_id
    JOIN sys.trace_columns c ON t.columnid = c.trace_column_id


SELECT t.EventID, t.ColumnID, e.name as Event_Description, c.name as Column_Description
  FROM ::fn_trace_geteventinfo(1) t
    JOIN sys.trace_events e ON t.eventID = e.trace_event_id
    JOIN sys.trace_columns c ON t.columnid = c.trace_column_id


SELECT top 2000 loginname, textdata, RoleName, TargetLoginName, starttime, e.name as EventName
, hostname, applicationname, servername, databasename, objectName, e.category_id, cat.name, duration, eventclass, eventsubclass, loginsid, endtime, spid 
FROM ::fn_trace_gettable('C:\sql\local\data0\MSSQL11.MSSQLSERVER\MSSQL\Log\log_1812.trc',0)  --Get this location from query1 above
INNER JOIN sys.trace_events e ON eventclass = trace_event_id 
INNER JOIN sys.trace_categories AS cat ON e.category_id = cat.category_id 
where e.name in ('Audit Add DB User Event'
 'Audit Add Login to Server Role Event'
, 'Audit Add Member to DB Role Event'
, 'Audit Add Role Event'
, 'Audit Addlogin Event'
, 'Audit Login Failed'
, 'Audit Login Change Property Event'
, 'Audit Login GDR Event'
,'')
order by starttime desc;

SELECT top 15 loginname, textdata, RoleName, TargetLoginName, starttime, e.name as EventName
, hostname, applicationname, servername, databasename, objectName, e.category_id, cat.name, duration, eventclass, eventsubclass, loginsid, endtime, spid 
FROM ::fn_trace_gettable('C:\sql\local\data0\MSSQL11.MSSQLSERVER\MSSQL\Log\log_1812.trc',0) 
INNER JOIN sys.trace_events e ON eventclass = trace_event_id 
INNER JOIN sys.trace_categories AS cat ON e.category_id = cat.category_id 
where e.name='Audit Add Login to Server Role Event' 
order by starttime des;
