-- Links
http://www.myoraclesupports.com/content/faq-automatic-statistics-collection-job-10g-and-11g
http://viragsharma.blogspot.com/2008/04/dbmsstats-enhancements-in-oracle-11g.html
--
Note: 1408464.1



--------------------------- In the below two tables the accurate value is given by DBA_AUTOTASK_CLIENT view. For reasons see doc 858852.1
select * from DBA_AUTOTASK_CLIENT
    
select * from DBA_AUTOTASK_TASK         -- This table is at Database level and has data
---------------------------

select * from DBA_AUTOTASK_JOB_HISTORY order by job_start_time desc -- Job name and maintenance window used.

select * from dba_autotask_schedule order by start_time desc --Maintenance window.

select (TRUNC(SYSDATE) + a.job_duration - TRUNC(SYSDATE)) * 86400  as seconds
from DBA_AUTOTASK_JOB_HISTORY  a
order by job_start_time desc


BEGIN
DBMS_AUTO_TASK_ADMIN.ENABLE(
client_name => 'sql tuning advisor', 
operation => NULL, 
window_name => NULL);
END;
/


SELECT client_name, window_name, jobs_created, jobs_started, jobs_completed
FROM dba_autotask_client_history




select client_name, JOB_SCHEDULER_STATUS 
from DBA_AUTOTASK_CLIENT_JOB           
where client_name='auto optimizer stats collection';  --check if currently auto stats are running now.



-- Below should be done as sysdba
SQL> exec DBMS_AUTO_TASK_IMMEDIATE.GATHER_OPTIMIZER_STATS;


select dbms_stats.get_prefs('ESTIMATE_PERCENT') from dual;

select DBMS_STATS.GET_PREFS ('CASCADE') from dual

select DBMS_STATS.GET_PREFS ('DEGREE') from dual

select DBMS_STATS.GET_PREFS ('METHOD_OPT') from dual

select DBMS_STATS.GET_PREFS ('METHOD_OPT') from dual

select DBMS_STATS.GET_PREFS ('NO_INVALIDATE') from dual

select DBMS_STATS.GET_PREFS ('PUBLISH') from dual

select DBMS_STATS.GET_PREFS ('STALE_PERCENT') from dual

select DBMS_STATS.GET_PREFS ('CONCURRENT') from dual

select dbms_stats.get_prefs('STALE_PERCENT', 'DBADMIN', 'T1') from dual;


exec dbms_stats.SET_DATABASE_PREFS('METHOD_OPT', 'SYSADM', 'FOR ALL INDEXED COLUMNS SIZE 1'); -- didn't do this in any environment
-- set_database_prefs will change all the statistics of the objects in DB currently.

exec dbms_stats.SET_GLOBAL_PREFS('METHOD_OPT',  'SYSADM', 'FOR ALL INDEXED COLUMNS SIZE 1'); -- didn't do this in any environment
-- set_global_prefs is the default setting for any object which is created new.

--if setting the prefs at schema level and have to see the chagens affected, 
--you have to use the get_prefs including the object name aswell.See docid 1338709.1
exec DBMS_STATS.SET_SCHEMA_PREFS('SYSADM', 'METHOD_OPT','FOR ALL INDEXED COLUMNS SIZE 1'); -- didn't do this in any environment

exec dbms_stats.SET_GLOBAL_PREFS('STALE_PERCENT', 1);

exec dbms_stats.SET_GLOBAL_PREFS('DEGREE', 'DBMS_STATS.DEFAULT_DEGREE');

commit

-- find all the current settings on the database
select sname, sval1, spare4 from sys.optstat_hist_control$;


-- gather system statistics for i/o and cpu utilization. running the system stats makes the optimizer more aware of the system resources.
DBMS_STATS.GATHER_SYSTEM_STATS('start'); --starts collecting system stats
-- one hour delay during high workload
DBMS_STATS.GATHER_SYSTEM_STATS('end');   --ends collectinng system stats

DBMS_STATS.GATHER_SYSTEM_STATS           --system stats at that particular point in time.

select * from SYS.AUX_STATS$

-------------------------------------------------------------------------------


select * from dba_histograms where owner = 'SYSADM'


