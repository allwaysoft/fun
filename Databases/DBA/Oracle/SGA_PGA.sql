--SGA
-----



--PGA
------
select * from gv$parameter where name like '%parallel%' order by inst_id, num, name

select * from gv$parameter where name in ('pga_aggregate_limit','pga_aggregate_target')
  
select inst_id, value/(1024*1024) max_PGA_in_MB from gv$pgastat where name='maximum PGA allocated'; --This shows the value of the MAXIMUM PGA that the instace(s) had at some point after DB startup


--Aggregated Total PGA usage by all oracle processes currently in an instance.
SELECT ROUND(sum(pga_used_mem)/(1024*1024),2) PGA_USED_MB, ROUND(sum(pga_alloc_mem)/(1024*1024),2) PGA_alloc_MB
FROM v$process p
where 1=1         --and pname like 'P0%'
order by 1 desc;

select count(1) from v$process where pname like 'P0%'


--PGA usage by session
SELECT DECODE(TRUNC(SYSDATE - LOGON_TIME), 0, NULL, TRUNC(SYSDATE - LOGON_TIME) || ' Days' || ' + ') || 
TO_CHAR(TO_DATE(TRUNC(MOD(SYSDATE-LOGON_TIME,1) * 86400), 'SSSSS'), 'HH24:MI:SS') LOGON, 
SID, a.SERIAL#, b.SPID , ROUND(b.pga_used_mem/(1024*1024), 2) PGA_MB_USED, 
a.USERNAME, STATUS, OSUSER, MACHINE, a.PROGRAM, MODULE 
FROM v$session a, v$process b
WHERE a.paddr = b.addr 
--and a.program like '%P0%'
--and status = 'ACTIVE' 
--and v$session.sid = 97
--and v$session.username = 'SYSTEM' 
--and v$process.spid = 24301
ORDER BY TRUNC(SYSDATE - LOGON_TIME) desc, pga_used_mem DESC;


select distinct
   originating_timestamp,
   message_text
from
   x$dbgalertext
where
   originating_timestamp > sysdate-2
and
(
   message_text = 'ORA-00600'
   or
   message_text like '%Fatal%'
);