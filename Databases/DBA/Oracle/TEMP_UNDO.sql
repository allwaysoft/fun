--***
--*** BE careful when doing the below in Data Guard Environment
http://gavinsoorma.com/2009/07/data-guard-adding-and-resizing-a-datafile-on-the-primary-database/

http://docs.oracle.com/cd/E11882_01/server.112/e25608/manage_ps.htm#i1006374
9.3 Primary Database Changes That Require Manual Intervention at a Physical Standby
--***
--***

--Read above links before doing any of the below in DG environment. Open both alert logs and perform the task.
CREATE TEMPORARY TABLESPACE TEMP TEMPFILE --'+HRTSTDATA' 
SIZE 50M 
AUTOEXTEND ON 
NEXT 640K 
MAXSIZE 1G 
TABLESPACE GROUP ''
EXTENT MANAGEMENT LOCAL 
UNIFORM SIZE 1M;

ALTER DATABASE DEFAULT TEMPORARY TABLESPACE TEMP;


DROP TABLESPACE TEMP1 INCLUDING CONTENTS AND DATAFILES;



--Read above links before doing any of the below in DG environment.Open both alert logs and perform the task.
create undo tablespace UNDOTBS2 datafile --'+HRTSTFRA' 
size 100M 
AUTOEXTEND ON 
NEXT 1M 
MAXSIZE 2G;


alter system set UNDO_TABLESPACE=UNDOTBS2 scope =both;


drop tablespace UNDOTBS1 including contents and datafiles;


---****If in case tablespace is not created on standby follow below.

On Primary: Stop archive to standby
    alter system set log_archive_dest_state_3=DEFER;

On Standby:
    alter system set standby_file_management=MANUAL;
    -- At this point look at alert log to find the standby datafile name and location, then use bleow command to recreate it
    alter database recover managed standby database using current logfile disconnect from session;  

    alter database create datafile '/u00/app/oracle/product/11.2.0/db_1/dbs/UNNAMED00010' as 'UNDOTBS2';

On Primary: Start archive to standby
    alter system set log_archive_dest_state_3=ENABLE;

    -- Now start the Recovery process back on
    alter database recover managed standby database using current logfile disconnect from session;

    alter system set standby_file_management=AUTO;
On Both: Check if log is shipped and applied properly
    select sequence#, applied from v$archived_log;




-------------------------some useful queries related to undo and temp-----------------------------------------

--DB 11.1: Temporary Tablespaces [Video] [ID 1099324.1]

--UNDO_RETENTION(seconds) parameter should always be greater thatn the value of the below query.
select max(maxquerylen) from v$undostat; -- this gives the time in seconds taken by the longest running query.


select sum(bytes /(1024*1024)) from dba_undo_extents where status='EXPIRED';
select sum(bytes /(1024*1024)) from dba_undo_extents where status='ACTIVE';
select sum(bytes /(1024*1024)) from dba_undo_extents where status='UNEXPIRED';



alter system set undo_retention = 30

select * from v$parameter where upper(name) like '%UNDO%'

select * from v$UNDOSTAT


-- You could try to resize datafiles, but this may not work (maybe you already tried it ?).
-- So, assuming your undo tablespace name is UNDOTBS1, you can do the following :
-- Create a new undo tablespace as :
-- Change parameter UNDO_TABLESPACE
-- Drop UNDOTBS1


To complete the drop command you may have to wait for some transactions to be committed or rolled back.

--Read above links at the top of this page before doing any of the below 
DROP TABLESPACE UNDOTBS1 INCLUDING CONTENTS AND DATAFILES;

CREATE UNDO TABLESPACE UNDOTBS1 DATAFILE 
  '+HRDEVDATA/hrdev/datafile/undotbs1.259.762471823' SIZE 10320M AUTOEXTEND ON NEXT 5M MAXSIZE UNLIMITED
ONLINE
RETENTION NOGUARANTEE
BLOCKSIZE 8K
FLASHBACK ON;


select * from v$undostat