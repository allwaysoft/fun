SELECT sess.sid as Id, sess.username as username, nvl(sess.SCHEMANAME, 'N/A') as db, sess.OSUSER as osuser, sess.machine as Host, sess.PROGRAM as Program, sess.event as State, 
nvl(sess.sql_id,0) as Info, sess.module as Module, ss.value*10 as cpu_usage, decode( sess.P1TEXT, 'file#', sess.P1, 'file number', sess.P1, NULL ) as file_id, sess.ROW_WAIT_OBJ#, sess.seq#, 
sess.state as sess_state, sess.client_identifier as snapshot_guid, sess.blocking_session as blocker, sess_block.username blocker_username, sess_block.machine as Blocker_Host
FROM v$session sess 
LEFT OUTER JOIN v$session sess_block ON (sess.blocking_session = sess_block.sid) 
LEFT OUTER JOIN v$sesstat ss ON (sess.sid = ss.SID and ss.statistic# = 19 )
WHERE sess.username is not null AND sess.status = 'ACTIVE' AND sess.sid NOT IN (1046, 1020);


SELECT sql_id, executions, CPU_TIME, elapsed_time, rows_processed, buffer_gets, disk_reads, parse_calls, plan_hash_value, direct_writes, serializable_aborts, fetches, 
end_of_fetch_count, loads, version_count, invalidations, px_servers_executions, plsql_exec_time, application_wait_time, concurrency_wait_time, cluster_wait_time, user_io_wait_time, 
java_exec_time, sorts, sharable_mem, TYPECHECK_MEM, IO_CELL_OFFLOAD_ELIGIBLE_BYTES, IO_INTERCONNECT_BYTES, PHYSICAL_READ_REQUESTS, PHYSICAL_READ_BYTES, 
PHYSICAL_WRITE_REQUESTS, PHYSICAL_WRITE_BYTES, EXACT_MATCHING_SIGNATURE, FORCE_MATCHING_SIGNATURE, IO_CELL_UNCOMPRESSED_BYTES, IO_CELL_OFFLOAD_RETURNED_BYTES
FROM v$sqlstats
WHERE LAST_ACTIVE_TIME > sysdate-1/24/(60/1)



WITH ash_rows AS
(SELECT inst.instance_number, ash.session_type, decode(ash.session_state, 'ON CPU', 'CPU', event) as event_name, decode(ash.session_state, 'ON CPU', 'CPU', wait_class) as class_name, info.sampling_interval * 1000 as wait_time_micro, case when ash.time_waited = 0 then 0 else greatest(1, info.sampling_interval * 1000 / ash.time_waited) end as wait_count, inst.instance_number || '_' || ash.session_id || '_' || ash.session_serial# as sid, decode(session_type, 'BACKGROUND', null, inst.instance_number || '_' || ash.session_id || '_' || ash.session_serial#) as sid_fg
FROM v$active_session_history ash, v$ash_info info, v$instance inst
WHERE ash.sample_time >= info.latest_sample_time - NUMTODSINTERVAL(:1 , 'SECOND') AND ash.sample_id >= info.latest_sample_id - (:2 * 1000 / info.sampling_interval) AND ash.wait_class <> 'Idle' ) ,events AS
(SELECT event_name, class_name, sum(wait_time_micro) as wait_time_micro, sum(decode(session_type, 'BACKGROUND', 0, wait_time_micro)) as wait_time_micro_fg, greatest(count(distinct sid), sum(wait_count)) as wait_count, greatest(count(distinct sid_fg), sum(decode(session_type, 'BACKGROUND', 0, wait_count))) as wait_count_fg
FROM ash_rows GROUP BY event_name, class_name )
SELECT event_name, class_name, ROUND(wait_count), ROUND(wait_time_micro/1000000, 2) wait_time, ROUND(wait_time_micro/1000/wait_count, 2) average_wait, ROUND(wait_count_fg), ROUND(wait_time_micro_fg/1000000, 2) wait_time_fg, ROUND(wait_time_micro_fg/1000/wait_count_fg, 2) average_wait_fg
FROM
(SELECT *
FROM events
WHERE wait_count_fg > 0 ORDER BY wait_time_micro_fg DESC)
WHERE ROWNUM <= 5