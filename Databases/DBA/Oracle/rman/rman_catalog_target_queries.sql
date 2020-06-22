--connect to catalog as rman user to execute these queries. unless specified.


select * from rc_database

select * from rc_rman_status where db_name = 'HRDEV' order by end_time desc

select * from RC_DATAFILE

select * from RC_REDO_LOG

select * from RC_REDO_THREAD

select * from RC_ARCHIVE_LOG

select * from RC_CONTROLFILE_SOPY

select * from RC_STORED_SCRIPT

select * from RC_STORED_SCRIPT_LINE

select * from rc_database where db_key not in (select db_key from rc_rman_status)


select * from v$rman_configuration  -- execute this against the target database to view the rman configuration for the database.

select * from V$RMAN_OUTPUT  order by recid  -- execute this against the target database to the rman configuration for the database.

select * from v$rman_status where status='RUNNING' -- execute this against the target database to get the status of rman.

show all;   -- issue this command in rman command prompt after connecting to target and catalog to see the configuration of rman for target database.


select * from V$BACKUP_PIECE   --execute against target


SELECT SID, SERIAL#, CONTEXT, SOFAR, TOTALWORK,              --execute against target
       ROUND(SOFAR/TOTALWORK*100,2) "%_COMPLETE"
FROM   V$SESSION_LONGOPS
WHERE  OPNAME LIKE 'RMAN%'
AND    OPNAME NOT LIKE '%aggregate%'
AND    TOTALWORK != 0
AND    SOFAR <> TOTALWORK;


   
-- Find bottlenects in RMAN when async i/o isused.
SELECT   LONG_WAITS/IO_COUNT, FILENAME
FROM     V$BACKUP_ASYNC_IO
WHERE    LONG_WAITS/IO_COUNT > 0
ORDER BY LONG_WAITS/IO_COUNT DESC;


select * from v$BACKUP_SYNC_IO 


select * from v$backup_datafile