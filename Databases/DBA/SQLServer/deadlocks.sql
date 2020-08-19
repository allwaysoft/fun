--https://social.technet.microsoft.com/wiki/contents/articles/31280.finding-and-extracting-deadlock-information-using-extended-events.aspx
--Dead locks can be viewd from 
       --Sentry1 deadlock tab
       --SSMS Management -> health_check
       --Querying the health_check but it's xml data. Use queries below
       --or by SQL and ring buffer method (This might not be effecient as ring buffer is a moving target.)
--First, query the extended events dynamic management views to identify if the SYSTEM_HEALTH trace is on the server and that the xml_deadlock_report is included in the trace.
SELECT s.name, se.event_name
FROM sys.dm_xe_sessions s
       INNER JOIN sys.dm_xe_session_events se ON (s.address = se.event_session_address) and (event_name = 'xml_deadlock_report')
WHERE name = 'system_health'--Query to see the dead lock events
SELECT event_data = CONVERT(XML, event_data)
       , CONVERT(xml, event_data).query('/event/data/value/child::*')
       , CONVERT(xml, event_data).value('(event[@name="xml_deadlock_report"]/@timestamp)[1]','datetime') as Execution_Time 
FROM sys.fn_xe_file_target_read_file('system_health*.xel', null, null, null) 
WHERE object_name like 'xml_deadlock_report'