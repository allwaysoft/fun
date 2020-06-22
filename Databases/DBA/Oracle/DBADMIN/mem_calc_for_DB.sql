http://oracleflash.com/8/Automatic-Shared-Memory-Management-in-Oracle-10g.html
http://docs.oracle.com/cd/B28359_01/server.111/b28274/memory.htm



SELECT  component, current_size, min_size, max_size
FROM    v$memory_dynamic_components
WHERE   current_size != 0;



SELECT * FROM v$memory_target_advice ORDER BY memory_size;


SELECT name, value
FROM   v$parameter
WHERE  name IN ('pga_aggregate_target', 'sga_target')
UNION
SELECT 'maximum PGA allocated' AS name, TO_CHAR(value) AS value
FROM   v$pgastat
WHERE  name = 'maximum PGA allocated';


select * from v$db_cache_advice


select * from v$memory_dynamic_components order by component

select * from v$memory_resize_ops


SELECT size_for_estimate, buffers_for_estimate, estd_physical_read_factor, estd_physical_reads
   FROM V$DB_CACHE_ADVICE
   WHERE name          = 'DEFAULT'
     AND block_size    = (SELECT value FROM V$PARAMETER WHERE name = 'db_block_size')
     AND advice_status = 'ON';
     
     
     
SELECT NAME, VALUE
  FROM V$SYSSTAT
WHERE NAME IN ('db block gets from cache', 'consistent gets from cache', 'physical reads cache');     



-- Calculate MEMORY_TARGET
SELECT sga.value + GREATEST(pga.value, max_pga.value) AS 
memory_target
FROM (SELECT TO_NUMBER(value) AS value FROM v$parameter WHERE name = 'sga_target') sga,
(SELECT TO_NUMBER(value) AS value FROM v$parameter WHERE name = 'pga_aggregate_target') pga,
(SELECT value FROM v$pgastat WHERE name = 'maximum PGA allocated') max_pga;

ACTION PLAN :
===================================

Asuming our required setting was 3G, we might issue the following statements.

CONN / AS SYSDBA
-- Set the static parameter. Leave some room for possible future growth without restart.

ALTER SYSTEM SET MEMORY_MAX_TARGET=5G SCOPE=SPFILE;

-- Set the dynamic parameters. Assuming Oracle has full control.

ALTER SYSTEM SET MEMORY_TARGET=4G SCOPE=SPFILE; ALTER SYSTEM SET PGA_AGGREGATE_TARGET=0 SCOPE=SPFILE; ALTER SYSTEM SET SGA_TARGET=0 SCOPE=SPFILE;

-- Restart instance.
SHUTDOWN IMMEDIATE;
STARTUP;
Once the database is restarted the MEMORY_TARGET parameter can be amended as required without an instance restart.

ALTER SYSTEM SET MEMORY_TARGET=4G SCOPE=SPFILE;

select component , round(current_size/1024/1024,2) size_mb
from v$sga_dynamic_components
where component like '%pool'
OR component ='DEFAULT buffer cache';