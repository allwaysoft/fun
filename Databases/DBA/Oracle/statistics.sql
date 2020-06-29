SELECT * FROM dba_autotask_operation;

select * from dba_autotask_client

select * from DBA_AUTOTASK_JOB_HISTORY where client_name = 'auto optimizer stats collection' order by window_start_time

select m.TABLE_OWNER,
		m.TABLE_NAME,
		m.INSERTS,
		m.UPDATES,
		m.DELETES,
		m.TRUNCATED,
		m.TIMESTAMP as LAST_MODIFIED,		
		round((m.inserts+m.updates+m.deletes)*100/NULLIF(t.num_rows,0),2) as EST_PCT_MODIFIED,
		t.num_rows as last_known_rows_number,
		t.last_analyzed,
        dts.stale_stats
From dba_tab_modifications m,
		 dba_tables t,
         dba_tab_statistics dts
where 	m.table_owner=t.owner
and	m.table_name=t.table_name
and t.table_name = dts.table_name
and 	table_owner not in ('SYS','SYSTEM','SQLTXPLAIN','AUDSYS','CTXSYS','DBSNMP')
--and table_owner = 'DWLOAD'
--and 	((m.inserts+m.updates+m.deletes)*100/NULLIF(t.num_rows,0) > 10 or t.last_analyzed is null)
and (dts.stale_stats = 'YES' or dts.stale_stats is null)
order by t.num_rows desc, timestamp desc;
