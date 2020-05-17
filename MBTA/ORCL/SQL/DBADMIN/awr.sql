--This example shows how to generate an AWR text report with the DBMS_WORKLOAD_REPOSITORY 
--package for database identifier 1557521192, instance id 1, snapshot ids 5390 and 5391 and with default options.

-- make sure to set line size appropriately
-- set linesize 152
SELECT output FROM TABLE(DBMS_WORKLOAD_REPOSITORY.AWR_REPORT_TEXT(1557521192,  1, 5390, 5392) ) ;

You can call the DBMS_WORKLOAD_REPOSITORY packaged functions directly as in the example, but Oracle recommends 
you use the corresponding supplied SQL script (awrrpt.sql in this case) for the packaged function, which prompts the user 
for required information.

--------------------------------------------------------------------------------



WITH aa AS 
(SELECT output, ROWNUM r
FROM table(DBMS_WORKLOAD_REPOSITORY.awr_report_text (2576941867, 1, 2351,2399)))
SELECT output
FROM aa, (SELECT r FROM aa
WHERE output LIKE 'Top 5 Timed Events%') bb
WHERE aa.r BETWEEN bb.r AND bb.r + 9

--To reconstruct the Top 5 hourly for the last five days, you will need to access 
--DBA_HIST_SYSTEM_EVENTS (system events) 
--DBA_HIST_SYS_TIME_MODEL (time model) 
--DBA_HIST_SNAPSHOT (list of snapshot ids and times).

select * from DBA_HIST_SNAPSHOT order by begin_interval_time

select * from DBA_HIST_SYS_TIME_MODEL

select * from DBA_HIST_SYSTEM_EVENTS

select * from DBMS_WORKLOAD_REPOSITORY
