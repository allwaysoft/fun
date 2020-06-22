Trace 10046 is to get all the SQL run by a session
Trace 10053 is to get the optimizers thought process on how it got to picking a specific exec plan

How to enable the above trace for a session
--10046
https://oracle-base.com/articles/misc/sql-trace-10046-trcsess-and-tkprof

--10053

mpstat for cpu stats on unix

http://savvinov.com/2012/04/06/awr-reports-interpreting-cpu-usage/
http://afatkulin.blogspot.com/2014/02/awr-top-5-timed-foreground-events.html top 5 wait events by snapid sql

--PROFILER
3. SQL developer and DBMS_Profiler
https://technology.amis.nl/2007/07/19/dbms_profiler-report-for-sql-developer/