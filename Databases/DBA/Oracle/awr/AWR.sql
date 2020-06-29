-– AWR queries
http://www.oracleexpert.co.uk/2011/07/useful-awr-queries/ –AWR USEFUL queries
http://pavandba.files.wordpress.com/2009/11/owp_awr_historical_analysis.pdf –AWR useful queries
http://gavinsoorma.com/2012/11/ash-and-awr-performance-tuning-scripts/ –ASH and AWR queries
How to Use AWR Reports to Diagnose Database Performance Issues [Article ID 1359094.1] –AWR MOS note
Automatic Workload Repository (AWR) Reports – Start Point [Article ID 1363422.1] –AWR MOS note
--https://asktom.oracle.com/pls/apex/f?p=100:11:0::::P11_QUESTION_ID:2159478097863 --Explanation about Parse to Execute percentages in AWR report


–Always look for end_interval_time column for snap_id. For example if you want a report between 10 am and 11 am.
–Look for snap ids for those records with end_interval_time = 10 and end_interval_time = 11.
–End_interval_time is the time when the actual snap is taken for that particular snapid


/**************AWR interval and retention on a DB**********/
 select * from dba_hist_wr_control


/************** TOP 50 SQL by total time spent in the past 30 days***************/
--This is a very good starting point to understand whats going on in a DB historically.
--Note that this doesn't capture all SQL, only top sql based on some criteria, in general this query is a good start for finding top SQL by execution time. But to find specific number of executions of a SQL, this is not the perfect way to do it. If you want to track a specific SQL though it might not be important for it to be stored in the hist sqlstats, it has to be colored, look for DBMS_WORKLOAD_REPOSITORY.ADD_COLORED_SQL

select sub.sql_id,
       txt.sql_text,
       parsing_schema_name,
       sub.seconds_since_date Total_Seconds_for_all_execs_Last_30_Days,
       sub.execs_since_date Total_Execs_Since_Last_30_Days,
       sub.gets_since_date Total_Gets_Since_Last_30_Days,
       round(sub.seconds_since_date / (sub.execs_since_date + 0.01), 3) aTime_Spent_Per_Exex_In_Secs
  from ( -- sub to sort before top N filter
        select sql_id,
                g.parsing_schema_name,
                round(sum(elapsed_time_delta) / 1000000) as seconds_since_date,
                sum(executions_delta) as execs_since_date,
                sum(buffer_gets_delta) as gets_since_date,
                row_number() over (order by round(sum(elapsed_time_delta) / 1000000) desc) r
          from dba_hist_snapshot natural
          join dba_hist_sqlstat g --This doesn't capture all SQL, only top sql based on some criteria
         where begin_interval_time > sysdate - 30
           --and parsing_schema_name in ('PZNADMIN1','WEBUSER01','DWMOBLOAD','APPD_USER')
         group by sql_id, g.parsing_schema_name) sub
  join dba_hist_sqltext txt on sub.sql_id = txt.sql_id
 where r <= &N
 order by seconds_since_date desc;


/************** DB Time by snap ***************/
–DB TImed by snap, Below is for two instances, add more similar queries with union all if more instances
select snap_id, instance_number, to_char(begin_interval_time,’dd-mon-yyyy hh24′) begin_interval_time
, to_char(end_interval_time,’dd-mon-yyyy hh24′) end_interval_time, stat_name
, to_char(end_interval_time, ‘DAY’) day, to_char(end_interval_time, ‘HH AM’) Hr, db_time_in_hr_by_period
, rank() over (partition by instance_number, trunc(end_interval_time) order by db_time_in_hr_by_period desc) heaviest_period_first
from (
select snap_id,instance_number,begin_interval_time, end_interval_time, stat_name
, round((value-prev_value)/1000000/3600,2) db_time_in_hr_by_period
from (
select a.snap_id snap_id, b.begin_interval_time, b.end_interval_time, a.instance_number, a.stat_name, a.value
,lag(a.value,1,0) over (partition by b.dbid,b.instance_number,b.startup_time
order by b.snap_id
) prev_value
from dba_hist_sys_time_model a
,dba_hist_snapshot b
where a.snap_id=b.snap_id
and a.instance_number = b.instance_number
and a.stat_name=’DB time’
and a.instance_number=b.instance_number
–and a.instance_number=1
order by a.snap_id
)
where prev_value <> 0
)
order by instance_number, snap_id desc;


/************** CPU by snap ***************/
–AWR CPU usage by SNAP
SELECT z.host_name,
z.instance_name,
w.instance_number,
w.begin_interval_time,
w.end_interval_time,
to_char(w.end_interval_time, ‘DAY’) day,
to_char(w.end_interval_time, ‘HH AM’) Hr,
w.begin_load host_begin_load,
w.end_load host_end_load,
w.host_num_cpu,
ROUND (
( (w.busy_time_end – w.busy_time_start)
/ ( (w.idle_time_end – w.idle_time_start)
+ (w.busy_time_end – w.busy_time_start)))
* 100, 2) HOST_Busy_CPU_perc,
w.inst_num_cpu,
ROUND (
( (w.inst_cpu_end – w.inst_cpu_start)
/ ( (w.idle_time_end – w.idle_time_start)
+ (w.busy_time_end – w.busy_time_start)))
* 100,2) INST_BUSY_CPU_PERC,
ROUND (
( ( (w.inst_cpu_end – w.inst_cpu_start)
* (w.host_num_cpu / w.inst_num_cpu))
/ ( (w.idle_time_end – w.idle_time_start)
+ (w.busy_time_end – w.busy_time_start)))
* 100, 2) EFFECTIVE_INST_BUSY_CPU_PERC
FROM (WITH snp
AS ( SELECT /*+ materialize */
a.instance_number,
a.snap_id,
(SELECT b.snap_id
FROM dba_hist_snapshot b
WHERE a.begin_interval_time =
b.end_interval_time
AND a.instance_number = b.instance_number)
prev_snap_id,
a.begin_interval_time,
A.END_INTERVAL_TIME
FROM dba_hist_snapshot a
WHERE a.end_interval_time >= sysdate – 30 — Start date/time , change as needed
AND a.end_interval_time <= sysdate
ORDER BY snap_id DESC, instance_number)
SELECT s.instance_number,
s.begin_interval_time,
s.end_interval_time,
(SELECT ROUND (o2.VALUE, 2)
FROM dba_hist_osstat o2
WHERE o2.instance_number = s.instance_number
AND o2.snap_id = s.prev_snap_id
AND o2.stat_name = ‘LOAD’)
begin_load,
(SELECT ROUND (o2.VALUE, 2)
FROM dba_hist_osstat o2
WHERE o2.instance_number = s.instance_number
AND o2.snap_id = s.snap_id
AND o2.stat_name = ‘LOAD’)
end_load,
(SELECT ROUND (o2.VALUE, 2)
FROM dba_hist_osstat o2
WHERE o2.instance_number = s.instance_number
AND o2.snap_id = s.prev_snap_id
AND o2.stat_name = ‘IDLE_TIME’)
idle_time_start,
(SELECT ROUND (o2.VALUE, 2)
FROM dba_hist_osstat o2
WHERE o2.instance_number = s.instance_number
AND o2.snap_id = s.prev_snap_id
AND o2.stat_name = ‘BUSY_TIME’)
busy_time_start,
(SELECT ROUND (o2.VALUE, 2)
FROM dba_hist_osstat o2
WHERE o2.instance_number = s.instance_number
AND o2.snap_id = s.snap_id
AND o2.stat_name = ‘IDLE_TIME’)
idle_time_end,
(SELECT ROUND (o2.VALUE, 2)
FROM dba_hist_osstat o2
WHERE o2.instance_number = s.instance_number
AND o2.snap_id = s.snap_id
AND o2.stat_name = ‘BUSY_TIME’)
busy_time_end,
(SELECT ROUND (SUM (y.VALUE) / 10000, 2)
FROM dba_hist_sys_time_model y
WHERE y.instance_number = s.instance_number
AND y.snap_id = s.prev_snap_id
AND y.stat_name IN (‘background cpu time’, ‘DB CPU’))
inst_cpu_start,
(SELECT ROUND (SUM (y.VALUE) / 10000, 2)
FROM dba_hist_sys_time_model y
WHERE y.instance_number = s.instance_number
AND y.snap_id = s.snap_id
AND y.stat_name IN (‘background cpu time’, ‘DB CPU’))
inst_cpu_end,
(SELECT o2.VALUE
FROM dba_hist_osstat o2
WHERE o2.instance_number = s.instance_number
AND o2.snap_id = s.snap_id
AND o2.stat_name = ‘NUM_CPUS’)
host_num_cpu,
(SELECT TO_NUMBER (p.VALUE)
FROM dba_hist_parameter p
WHERE p.instance_number = s.instance_number
AND p.snap_id = s.snap_id
AND p.parameter_name = ‘cpu_count’)
inst_num_cpu
FROM snp s) w,
( SELECT host_name, instance_name, instance_number FROM gv$instance) z
WHERE w.instance_number = z.instance_number
ORDER BY w.instance_number, w.end_interval_time desc;


/************** PGA by snap ***************/

http://docs.oracle.com/cd/E11882_01/server.112/e40402/dynviews_2096.htm

aggregate pga target column: curernt value of PGA_AGGREGATE_TARGET
total PGA allocated column: PGA allocated to instance, should not exceed aggregate pga target column but there are exceptions
total PGA used column: total PGA used by instance

Question: Why is total PGA (agg target) not used during a snap and a single pass is done even though there is available PGA to use
Answer: https://community.oracle.com/thread/846027?start=0&tstart=0 –Look for Jonathan’s reply in this OTN discussion.
Don’t use dba_hist_sysstat for PGA info, values such as “session pga memory” don’t have any meaning in this view.
*/
–AWR PGA usage by SNAP
select * from v$pgastat;– where name = ‘over allocation count’;
select * from DBA_HIST_PGASTAT;
select sn.snap_id, sn.instance_number, to_char(sn.end_interval_time,’MM-DD-YYYY HH24′) Snap_Time
, round(dhp.value/1024/1024) “AggregatePGATargetPar”
, dhp0.value “PrcsCntDuringSnap”
, round(dhp1.value/1024/1024) “MAX_PGAAllocated_MB” –any snapshot, max allocated after instance startup
, round(dhp2.value/1024/1024) “PGAAllocDuringSnap_MB”
, round(dhp3.value/1024/1024) “PGAUsedDuringSnap_MB”
, round(dhp4.value/1024/1024) “GlblMemBound_MB”
, round(dhp5.value/1024/1024) “PGACldBeFreedDrngSnap_MB”
, round((case when sn.begin_interval_time = sn.startup_time
then dhp6.value
else dhp6.value – lag(dhp6.value,1) over (partition by dhp6.dbid
, sn.instance_number
, sn.startup_time
order by sn.snap_id
)
end
)/1024/1024, 2
) “MPPrcssdDuringSnap”
, round((case when sn.begin_interval_time = sn.startup_time
then dhp7.value
else dhp7.value – lag(dhp7.value,1) over (partition by dhp7.dbid
, sn.instance_number
, sn.startup_time
order by sn.snap_id
)
end
)/1024/1024,2
) “ExtraMBPrcsdDuringSnap”
, round ((((case when sn.begin_interval_time = sn.startup_time
then dhp6.value
else dhp6.value – lag(dhp6.value,1) over (partition by dhp6.dbid
, sn.instance_number
, sn.startup_time
order by sn.snap_id
)
end
)/1024/1024
)/(
((case when sn.begin_interval_time = sn.startup_time
then dhp6.value
else dhp6.value – lag(dhp6.value,1) over (partition by dhp6.dbid
, sn.instance_number
, sn.startup_time
order by sn.snap_id
)
end
)/1024/1024)
+nvl(((case when sn.begin_interval_time = sn.startup_time
then dhp7.value
else dhp7.value – lag(dhp7.value,1) over (partition by dhp7.dbid
, sn.instance_number
, sn.startup_time
order by sn.snap_id
)
end
)/1024/1024),0)
))*100,2) “PGACacheHitDrngSnap”
from dba_hist_snapshot sn, DBA_HIST_PGASTAT dhp, DBA_HIST_PGASTAT dhp0, DBA_HIST_PGASTAT dhp1
, DBA_HIST_PGASTAT dhp2, DBA_HIST_PGASTAT dhp3, DBA_HIST_PGASTAT dhp4, DBA_HIST_PGASTAT dhp5
, DBA_HIST_PGASTAT dhp6 , DBA_HIST_PGASTAT dhp7
where sn.snap_id=dhp.snap_id and dhp.snap_id=dhp0.snap_id(+) and dhp0.snap_id=dhp1.snap_id(+)
and dhp1.snap_id=dhp2.snap_id(+) and dhp2.snap_id=dhp3.snap_id(+) and dhp3.snap_id=dhp4.snap_id(+)
and dhp4.snap_id=dhp5.snap_id(+) and dhp5.snap_id=dhp6.snap_id(+) and dhp6.snap_id=dhp7.snap_id(+)
and sn.instance_number = dhp.instance_number(+) and dhp.instance_number = dhp0.instance_number (+)
and dhp0.instance_number = dhp1.instance_number(+) and dhp1.instance_number = dhp2.instance_number(+)
and dhp2.instance_number = dhp3.instance_number(+) and dhp3.instance_number = dhp4.instance_number(+)
and dhp4.instance_number = dhp5.instance_number(+) and dhp5.instance_number = dhp6.instance_number(+)
and dhp6.instance_number = dhp7.instance_number(+)
and dhp.name(+) = ‘aggregate PGA target parameter’
and dhp0.name(+) = ‘process count’
and dhp1.name(+) = ‘maximum PGA allocated’ –This is the maximum PGA allocated to instance, at a particular point in time after instance started, for what ever the reason
and dhp2.name(+) = ‘total PGA allocated’ –PGA allocated for that snapshot. this should be less than pga aggregate target but there are exceptions
and dhp3.name(+) = ‘total PGA inuse’ –PGA used by instance for the snapshot. This only includes “work areas”, not otehr consumers (for example, PL/SQL or Java)
and dhp4.name(+) = ‘global memory bound’ –Max memory that could be used by a single process during the snap. Dynamically changed based on number of processes and other factors
and dhp5.name(+) = ‘total freeable PGA memory’ –Freeable PGA not used by instance
and dhp6.name(+) = ‘bytes processed’ –Optimal byte process, additive from instance startup
and dhp7.name(+) = ‘extra bytes read/written’ –1 OR more passes it took for bytes to be processed, additive from instance starup
order by instance_number, snap_id desc;


–PGA optimal, single pass and multi pass by buckets
SELECT low_optimal_size/1024 low_kb, (high_optimal_size+1)/1024 high_kb,
estd_optimal_executions estd_opt_cnt,
estd_onepass_executions estd_onepass_cnt,
estd_multipasses_executions estd_mpass_cnt
FROM V$PGA_TARGET_ADVICE_HISTOGRAM
WHERE pga_target_factor = 2
AND estd_total_executions != 0
ORDER BY 1;


–PGA Target Advisor
SELECT ROUND(pga_target_for_estimate/1024/1024) target_mb,
estd_pga_cache_hit_percentage cache_hit_perc,
estd_overalloc_count
FROM V$PGA_TARGET_ADVICE;


/************** SGA by snap ***************/
–sga_max_size: can have some buffer for memory here, sga_target can be increased to sga_max_size DYNAMICALLY
–Similar to PGA, SGA stats can be obtained from below

select sga.SNAP_ID, sga.INSTANCE_NUMBER
,to_char(snap.BEGIN_INTERVAL_TIME, ‘dd-mon-yyyy hh:mi:ss HH24′) snap_begin_interval
,to_char(snap.END_INTERVAL_TIME, ‘dd-mon-yyyy hh:mi:ss HH24′) snap_end_interval
,dhmdc.current_size/1024/1024 snap_tot_available_SGA_mb
,round(sum(case when pool is null and name = ‘buffer_cache’
then bytes
end
)/1024/1024
,2
) snap_buff_cache_mb
,round(sum(case when pool is null and name = ‘log_buffer’
then bytes
end
)/1024/1024
,2
) snap_log_buff_mb
,round(sum(case when pool = ‘shared pool’
then bytes
end
)/1024/1024
,2
) snap_tot_shrd_pool_mb
,round(sum(case when pool = ‘shared pool’ and name = ‘free memory’
then bytes
end
)/1024/1024
,2
) snap_free_shrd_pool_mb
,round(sum(case when pool = ‘large pool’
then bytes
end
)/1024/1024
,2
) snap_tot_lrg_pool_mb
,round(sum(case when pool = ‘large pool’ and name = ‘free memory’
then bytes
end
)/1024/1024
,2
) snap_free_lrg_pool_mb
,round(sum(case when pool is null and name = ‘fixed_sga’
then bytes
end
)/1024/1024
,2
) snap_fxd_sga_mb
,round(sum(case when pool = ‘java pool’
then bytes
end
)/1024/1024
,2
) snap_tot_java_pool_mb
,round(sum(case when pool = ‘java pool’ and name = ‘free memory’
then bytes
end
)/1024/1024
,2
) snap_free_java_pool_mb
,round(sum(case when pool = ‘streams pool’
then bytes
end
)/1024/1024
,2
) snap_tot_strms_pool_mb
,round(sum(case when pool = ‘streams pool’ and name = ‘free memory’
then bytes
end
)/1024/1024
,2
) snap_free_strms_pool_mb
from dba_hist_sgastat sga
,DBA_HIST_SNAPSHOT snap
,DBA_HIST_MEM_DYNAMIC_COMP dhmdc
where sga.snap_id = snap.snap_id
and sga.instance_number = snap.instance_number
and dhmdc.snap_id = snap.snap_id (+)
and dhmdc.instance_number = snap.instance_number (+)
and dhmdc.component(+) = ‘SGA Target’
group by sga.snap_id, sga.instance_number, snap.BEGIN_INTERVAL_TIME, snap.END_INTERVAL_TIME, dhmdc.current_size/1024/1024
order by sga.instance_number, sga.snap_id desc;


–SGA Target Advisor
select * FROM V$sga_TARGET_ADVICE;


–Historical information of all the memory components and their resizes by snap
select current_size/1024/1024 curr_mb
, min_size/1024/1024 min_mb
, max_size/1024/1024 max_mb, dhmdc.*
from DBA_HIST_MEM_DYNAMIC_COMP dhmdc
–where component = ‘SGA Target’–’pga target’–’large pool’
order by instance_number, snap_id desc;


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


http://www.slideshare.net/satishGaddipati/analyzing-awr-report

http://www.slideshare.net/satishGaddipati/analyzing-awr-report