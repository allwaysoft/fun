Migration
Migration Check List:

****Reference document to be used while working on the Exadata migration checklist****
Step 1: Query DBA_SEGMENTS on source database for space and verify dump destination

COLUMN freemb FORMAT 999,999,999
COLUMN sizemb FORMAT 999,999,999
COLUMN total_MB FORMAT 999,999,999
COLUMN free_mb FORMAT 999,999,999
COLUMN gb FORMAT 999,999,999
COLUMN mb FORMAT 999,999,999

SET linesize 132
SET pagesize 50;
SET feedback OFF;
SET echo OFF;
SET termout ON;

SELECT * FROM v$version;

SELECT name FROM v$database;

SELECT SUM(bytes)/1024/1024/1024 GB FROM dba_segments;

BREAK ON report skip 1

compute SUM OF Total_MB ON report
compute SUM OF Free_MB ON report
compute SUM OF MB ON report

SELECT
owner,
SUM(bytes)/1024/1024 AS MB
FROM
dba_segments
WHERE
owner NOT IN (‘MDSYS’,’EXFSYS’,’ORDSYS’,’TSMSYS’,’SYS’,’SYSTEM’,’DBSNMP’,
‘OUTLN’,’SECURITY’,’WMSYS’,’XDB’,’DBMAINT’,’I3USERA’,’I3USERB’,’CLODPLY’,
‘GGUSER’)
GROUP BY
owner;

SELECT DISTINCT
(owner)
FROM
dba_segments
WHERE
owner NOT IN (‘MDSYS’,’EXFSYS’,’ORDSYS’,’TSMSYS’,’SYS’,’SYSTEM’,’DBSNMP’,
‘OUTLN’,’SECURITY’,’WMSYS’,’XDB’,’DBMAINT’,’I3USERA’,’I3USERB’,’CLODPLY’,
‘GGUSER’)
ORDER BY
owner;

–
–* Sum of BYTES by Tablespace
–

SET lin 150 pages 9999

COL tablespace_name FOR A30
COL BYTES FOR 999,999,999,999,999
COL KBYTES FOR 999,999,999,999,999
COL MBYTES FOR 999,999,999,999,999.9
COL GBYTES FOR 999,999,999,999,999.99
COL TBYTES FOR 999,999,999,999,999.999

SELECT
tablespace_name,
SUM(bytes) AS BYTES,
SUM(bytes)/1024 AS KBYTES,
SUM(bytes)/1024/1024 AS MBYTES,
SUM(bytes)/1024/1024/1024 AS GBYTES,
SUM(bytes)/1024/1024/1024/1024 AS TBYTES
FROM DBA_SEGMENTS
WHERE tablespace_name NOT IN (‘USERS’,’UNDOTBS1′,’UNDOTBS2′,’SYSTEM’,’SYSAUX’,’SECURITY_I’,’SECURITY_D’,’GG_TBS’,’AUD’)
GROUP BY tablespace_name
ORDER BY tablespace_name
/
Step 2: Check Character Set on the Source database and if it?s not AL32UTF8 then follow next 3 steps otherwise skip them

SELECT * FROM nls_database_parameters;

Step 3: Create SRS to run CSSCAN

Step 4: Execute SRS against Source Database

– Use the CSSCAN and CSALTER utility to migrate the database character set.
– Make a note of the source character set and the destination character set.
– Take a full database backup before you proceed with the conversion.
– Check if csscan utility is installed and working fine by running this sample command:

$ORACLE_home/bin/csscan TABLE=SYS.SQL_VERSION$ FROMCHAR=US7ASCII TOCHAR=US7ASCII LOG=d:\instchk CAPTURE=N PROCESS=1 ARRAY=1024000

– If it completes successfully, then proceed with running the actual csscan utility.
– If it gives an error like ?CSS-00107: Character set migration utility schema not installed?, then install the character set migration utility schema. You can install the character set migration utility schema as follows:

cd $ORACLE_HOME/rdbms/admin
sqlplus / as sysdba
SQL> @csminst.sql

Character set scanner creates a schema called CSMIG for maintaining its data in the database. The default tablespace for this user should be system but you can change it.

- Once it is installed, try re-running the sample csscan command given above and check if it completes successfully.
- Proceed with the actual csscan command:

$cd $ORACLE_HOME/bin/
$ csscan \”sys/password@mydb as sysdba\” full=y log=

Provide the values as follows:

Current database character set is AL32UTF8.
Enter new database character set name: >
Enter array fetch buffer size: 1024000 >
Enter number of scan processes to utilize(1..32): 1 > 32

OR

You may give the command directly as:

$ORACLE_HOME/bin/csscan \”sys/password@mydb as sysdba\” full=y log= FROMCHAR= TOCHAR= ARRAY=102400 PROCESS=32

Step 5: Provide output log files

- Check the logfile from csscan and provide the same to the respective teams.
Step 6: Review csscan log and fix data

- Once the Database Character Set Scanning has completed successfully, the database must be opened in restricted mode, because no normal user should allow to access the database during this task is being performed. So you can run the CSALTER script as the SYS user. The location of the CSALTER Script is “$ORACLE_HOME/rdbms/admin/csalter.plb”.

Shut Down the Database

SQL> shutdown immediate;

Start Up the Database in Restricted Mode.

SQL> startup restrict;
Run the csalter.plb script

SQL> @?/rdbms/admin/csalter.plb

- Review the output and if it?s a success, restart the database and open it in normal mode and then verify the changed character set using -

select value from NLS_DATABASE_PARAMETERS where parameter=’NLS_CHARACTERSET’;

Step 7: Check Archive Log Frequency on source database

- To get a count of these errors: grep ‘Checkpoint not complete’ -B 3 alert*_*log | wc ?l
- To see when these errors last occurred: grep ‘Checkpoint not complete’ -B 3 alert*_*log
(On Linux)

- If there are lots of these errors, then consider adding new logfile groups.
The default setup for PROD is 8 groups, 2 members per group, sized at 4GB per member
The default setup for PROD is 16 groups, 2 members per group, sized at 4GB per member

- If it’s a Data Guard environment there should be one additional logfile group on the standby. Keep this in mind after switchover and failover scenarios.

Step 8: Create new Database on Exadata using Gold Copy Template to ensure consistent provisioning on Exadata

- Use the Gold copy template document (using OEM12c) only if Character set is AL32UTF8 which is our standard. There have been few exceptions like RKS where we needed UTF8 so in that case use the document (DB Creation – using DBCA) to create the DB.
Step 9: Run the DBRM script as sysdba to set up Exadata specific RM (/auto/data.misc/oracle/exadata/DBRM.sql), if value already exists for resource plan, then please run DBRM_1.sql

Step 10: Make an entry for the database in NDI (DMS->Open Systems Support->DMS Beeper Response

– System->Database Instance->Request Insert and make an entry)

Step 11: Make a tns entry for each instance on all the nodes. Alias should be INSTANCE_NAME as this is required for RMAN backups
Step 12: Validate output from exadata_db_check.ksh

(/auto/data.misc/oracle/exadata/exdata_db_check.ksh INSTANCE_NAME)

Step 13: DB_CACHE and SHARED_POOL size should be set to minimum and not left at 0. DB_CACHE_SIZE can be 60% of SGA and SHARED_POOL at 20%

– DB_CACHE and SHARED_POOL size should be set to minimum and not left at 0.
– DB_CACHE_SIZE can be 60% of SGA and SHARED_POOL at 20%

– Take 60 and 20 percent of SGA_MAX_SIZE parameter

show parameter SGA_MAX_SIZE
show parameter DB_CACHE_SIZE
show parameter SHARED_POOL_SIZE

– If SGA_MAX_SIZE=12G (12576M) then
ALTER SYSTEM SET DB_CACHE_SIZE=7545M SCOPE=SPFILE SID=’*’;
ALTER SYSTEM SET SHARED_POOL_SIZE=2515M SCOPE=SPFILE SID=’*’;
and recycle both instances one at a time.

Step 14: If Golden Gate “Integrated Extract” is being used, make sure to set “shared_pool_size” to atleast 5G and “streams_pool” to 3G.

Step 15: Add Database to OEM

- Email Poornima to get the database added to OEM.

Step 16: Configure Dataguard environment with Broker as per the document



Step 17: Login into any Development server and add a TNS entry for the new database .( TNS_ADMIN=/ssb/db/share/etc)

- You may use the example mentioned in step 10.

Step 18: complete database certification. Follow step1 and make an entry for each instance for the database



Step 19: Update Database/App table. (DMS->Open Systems Support->DMS Beeper Response System->Server Application->Insert the entry for database and each instance to apps in need)

Step 20: Make an entry for the db and instances in the below oratabs from any Dev server. There are 5 oratabs for the development oratools to work properly
dasomg00t(19): pwd

/auto/db.share/etc

backup below files

-rwxr-xr-x 1 oracle dba 44038 Mar 9 00:32 orattab.AIX.6
-rwxr-xr-x 1 oracle dba 72057 Mar 9 00:33 orattab.zLinux.2
-rwxr-xr-x 1 oracle dba 79135 Mar 9 00:33 orattab
-rwxr-xr-x 1 oracle dba 79297 Mar 9 00:34 orattab.Linux.2
-rwxr-xr-x 1 oracle dba 88348 Mar 9 00:34 orattab.SunOS.5

add entries as mentioned below in all 5 above files;

O24XDA1~/auto/prod/ver/oracle-11.2.0/client~O24XDA1
O24XDA11~/auto/prod/ver/oracle-11.2.0/client~O24XDA11
O24XDA12~/auto/prod/ver/oracle-11.2.0/client~O24XDA12
Step 21: Set up a unique ‘dbmaint’ account by altering the password to set a strong one and then update the Cloakware.
Send an email as follows:
_____________________________________________
From: Sharma2, Ashish
Sent: Monday, February 03, 2014 10:45 AM
To: SES-Security-Engineering
Subject: Please update password
O13XDA3:DBMAINT:
Thanks,
Ashish A. Sharma

Step 22: Execute exadata_db_check.ksh to check all instance level parameters against Exadata standard parameter. Copy and paste output for each instance to this excel sheet

Step 23: set the password_life_time of all the profiles to unlimited
Command: alter profile limit password_life_time UNLIMITED;
Step 24: Make sure that “Processes” and “Sessions” parameter are equal to or greater than source database, shared_servers set to 0
Check the values in Source db and set accordingly.

Alter system set processes=<> scope=spfile sid=?*?;
Alter system set sessions=<> scope=spfile sid=?*?;

Step 25: Make necessary changes to parameters and restart database

- The main parameters of concern are:
Cluster_interconnects
log_checkpoints_to_alert
remote_listener

- The script will generate an output which will provide you the parameters that aren?t set correct as per SS standards.

Example:

INSTANCE PARAMETER CHECKS
————————-
PARAMETER NAME SS EXADATA RECOMMENDED VALUE CURR_INSTANCE STATUS
————————- —————————- ——————- ———————- ————–
cluster_interconnects 192.168.10.4 169.254.143.67 CHECK VALUE
log_checkpoints_to_alert FALSE TRUE CHECK VALUE
remote_listener gdcx01-scan:1521 wdcx07-scan:1521 CHECK VALUE

– How to check whether cluster_interconnects parameter is set correctly?
Make a note of the IP set in the database: SQL> show parameter cluster_interconnects
Check the Private IP address of the compute node on which the exadata_db_check.ksh script has been run from the /etc/hosts file.
The IP set in the db via cluster_interconnects parameter should match with the private IP mentioned in the /etc/hosts file
If it doesn?t match, you need to set it in the db using: SQL> alter system set cluster_interconnects= scope=spfile sid=?*?;
This is a STATIC parameter and we would need to restart the database in order for it to take effect.
DO NOT CHANGE it directly without approvals and report the mismatch to the team at the earliest.

– To modify log_checkpoints_to_alert and remote_listener use these ALTER SYSTEMcommands. These changes do not need downtime.

SQL> ALTER SYSTEM SET log_checkpoints_to_alert=FALSE SCOPE=BOTH SID=?*?;
SQL> ALTER SYSTEM SET remote_listener= scope=BOTH SID=?*?;

Step 26: Provide list of APMD sub-apps

Step 27: Add sub-apps for Exadata



Step 28: DR TEST with multiple switchovers
DR TEST with multiple switchovers, make sure that unique name of DR database ends with the first letter of Data Center name. So DR database O10XAD3 in Westborough should have the unique name as O10XDA3W.

Step 29: Schedule autosys job to setup rman backup (lev 0 and lev 1)

For example: (However you need to check the existence of the backup scripts and log locations and edit accordingly. Also, schedule the backups jobs ?LVL0,1 and archivelog in such a way that they don?t conflict with each other. Refer to the attached note (by Felipe) for steps that can be used to avoid job run conflict)



/* —————– wdcx07d05_uxxda014_o05_lev0 —————– */

insert_job: wdcx07d05_uxxda014_o05_lev0 job_type: c
command: /u01/app/oracle/scripts/Exa_dba_rman_lev0 O05TDE1 6
machine: wdcx07d05
owner: oracle
permission:
date_conditions: 1
days_of_week: su
start_times: “21:00″
description: “TDE Exadata Lev0 rman backup”
std_out_file: /u01/app/oracle/log/O05TDE1_rmanlev0_out.log
std_err_file: /u01/app/oracle/log/O05TDE1_rmanlev0_err.log
max_run_alarm: 600
alarm_if_fail: 1

/* —————– wdcx07d05_uxxda014_o05_lev1 —————– */

insert_job: wdcx07d05_uxxda014_o05_lev1 job_type: c
command: /u01/app/oracle/scripts/Exa_dba_rman_lev1 O05TDE1 6
machine: wdcx07d05
owner: oracle
permission:
date_conditions: 1
days_of_week: we,fr
start_times: “19:00″
description: “TDE Exadata Lev1 rman backup”
std_out_file: /u01/app/oracle/log/O05TDE1_rmanlev1_out.log
std_err_file: /u01/app/oracle/log/O05TDE1_rmanlev1_err.log
max_run_alarm: 300
alarm_if_fail: 1

Step 30: Schedule autosys job to setup archivelog backup and purge

For example:

/* —————– gdcx02d03_uxxda014_archive_bkp —————– */

insert_job: gdcx02d03_uxxda014_archive_bkp job_type: c
command: /u01/app/oracle/scripts/O04XDA3_archive_backup_cleanup O04XDA3 8
machine: gdcx02d03
#owner: oracle@gdcx02d03
permission:
date_conditions: 1
days_of_week: all
start_times: “01:00,03:00,05:00,07:00,09:00,11:00,13:00,15:00,17:00,19:00,21:00,23:00″
description: “Backup and cleanup archive of O04XDA3″
std_out_file: /home/oracle/log/O04XDA3_archive_bkp_out.log
std_err_file: /home/oracle/log/O04XDA3_archive_bkp_err.log
condition: notrunning(gdcx02d01_uxxda014_rman_level0) and notrunning(gdcx02d01_uxxda014_rman_level1)
max_run_alarm: 100
alarm_if_fail: 1

Step 31: Schedule check DG job

Step 32: Schedule purge jobs (logs and trace files)

For example:
/* —————– wdcx07d05_uxxda014_o05_trccln —————– */

insert_job: wdcx07d05_uxxda014_o05_trccln job_type: c
command: /u01/app/oracle/scripts/exa_db_trace_cleanup.sh O05TDE1
machine: wdcx07d05
#owner: oracle@wdcx07d05
permission:
date_conditions: 1
days_of_week: all
start_times: “07:00″
description: “c – exadata trc cleanup”
std_out_file: /home/oracle/log/O05TDE1_trccln.out
std_err_file: /home/oracle/log/O05TDE1_trccln.err
max_run_alarm: 600
alarm_if_fail: 1



Step 33: Schedule audit purge autosys job following the doc:

Step 34: Schedule Dictionary and Fixed Stats jobs

For example:
/* —————– wdcx07d05_uxxda011_fixedstats —————– */

insert_job: wdcx07d05_uxxda011_fixedstats job_type: c
command: /u01/app/oracle/scripts/fixed_stats O05TDE1
machine: wdcx07d05
#owner: oracle
permission:
date_conditions: 1
run_calendar: 1stsunday
start_times: “07:00″
description: “Collect fixed and dictionary stats”
max_run_alarm: 120
alarm_if_fail: 1

Step 35: Validate dNFS on all nodes from alert.log

- Look in alert log for the following:
‘Oracle instance running with ODM: Oracle Direct NFS ODM Library Version 3.0′
grep ‘ODM:’ alert_*.log

Step 36: Disable auto maintenace jobs – SQL Advisor, Segment Advisor

BEGIN
dbms_auto_task_admin.disable(
client_name => ‘sql tuning advisor’,
operation => NULL,
window_name => NULL);
END;
/

BEGIN
dbms_auto_task_admin.disable(
client_name => ‘auto space advisor’,
operation => NULL,
window_name => NULL);
END;
/

Step 37: Validate AWR snapshot interval is set up correctly – hourly is standard

- Validate AWR snapshot interval is set up correctly – hourly is standard 90 days for the retention (in mins)

SELECT
extract( DAY FROM snap_interval) *24*60+ extract( hour FROM snap_interval) *
60 + extract( minute FROM snap_interval )
“Snapshot Interval”,
extract( DAY FROM retention) *24*60+ extract( hour FROM retention) *60+
extract( minute FROM retention ) “Retention Interval”
FROM
dba_hist_wr_control
/

– If not then, the procedure to modify. This also takes care of Step 43.
EXECUTE DBMS_WORKLOAD_REPOSITORY.MODIFY_SNAPSHOT_SETTINGS (interval => 60, retention => 129600);
Snapshot Interval Retention Interval
—————– ——————
60 129600

Step 38: Validate RMAN Configuration for retention policy is set to “Applied On Standby”

- For ADG
CONFIGURE ARCHIVELOG DELETION POLICY TO APPLIED ON ALL STANDBY;

- For OGG
CONFIGURE ARCHIVELOG DELETION POLICY TO NONE;

Step 39: DR Test

- Refer to Step 23 for SOP on DR Test.

Step 40: Validate BLOCK CHANGE TRACKING on Primary and DG

SELECT * FROM V$BLOCK_CHANGE_TRACKING;

Status should be ‘ENABLED’ and there should be a file located in ‘+DATA/changetracking/…’ directory.

–To TURN ON block change tracking:
ALTER DATABASE ENABLE BLOCK CHANGE TRACKING USING FILE ‘+DATA’;

NOTE: It will create sub-directories and a file for the database to use. Don’t specify a path to a file.
Step 41: Stats jobs window should be customized and the stats job should be configured and scheduled

Step 42: Create Tablespace for Application Data

Naming convention in TDE:
[APP_CDE]_TSPACE_COMP

CREATE BIGFILE TABLESPACE [APP_CDE]_TSPACE_COMP DEFAULT COMPRESS FOR OLTP;

Step 43: Create services as per list provided by App Team

pbrun -u oracle srvctl add service
-d DBNAME
-s SERVICE NAME
-r INSTANCE_NAME, INSTANCE_NAME2 etc.
-a AVAILABLE_INSTANCE_NAME,AVAILABLE_INSTANCE_NAME2
-l PRIMARY
(PHYSICAL_STANDBY) for Active Data Guard
-q TRUE
-e SESSION
-m BASIC
-w 10
-z 150

pbo srvctl add service -d O02TDE1 -s CLO.UAT.RWTDE -r O02TDE11,O02TDE12 -l PRIMARY -q TRUE -e SESSION -m BASIC -w 10 -z 150
pbo srvctl add service -d O02TDE1 -s CLO.UAT.ROTDE -r O02TDE11,O02TDE12 -l PHYSICAL_STANDBY -q TRUE -e SESSION -m BASIC -w 10 -z 150

Step 44: Check INVALID objects on source

SELECT OWNER, object_name, object_type, status FROM dba_objects WHERE status <> ‘VALID’
/

Step 45: Move AUD table to new tablespace

SELECT
tablespace_name
FROM dba_tables
WHERE table_name = ‘AUD$’
/

– Verify there is a AUD tablespace
SELECT *
FROM dba_tablespaces
WHERE tablespace_name=’AUD’
/

CREATE BIGFILE TABLESPACE “AUD” DATAFILE ‘+DATA’ SIZE 10240M REUSE AUTOEXTEND ON NEXT 100M MAXSIZE 33546240M LOGGING EXTENT MANAGEMENT LOCAL UNIFORM SIZE 4096K SEGMENT SPACE MANAGEMENT AUTO;

– To move the table to the AUD tablespace:
ALTER TABLE SYS.AUD$ MOVE TABLESPACE AUD;
ALTER INDEX REBUILD ONLINE;

BEGIN
DBMS_STATS.GATHER_TABLE_STATS(‘SYS’,’AUD$’);
END;
/

– to analyze indexes too
BEGIN
DBMS_STATS.GATHER_TABLE_STATS(
ownname => ‘SYS’,
tabname => ‘AUD$’,
cascade => TRUE);
end;
/

Step 46: Export/import STS

- Refer the attached metalink note ?How to Move a SQL Tuning Set from One Database to Another (Doc ID 751068.1)?



Step 47: Validate OEM Monitoring

- Check whether the emagent is running on the host and also check whether the target is up on OEM12c. If target is not configured on OEM, send email to Poornima.
$ps ?ef| grep emagent

Commands to stop, clearstate, start and upload the agent:
$./emctl stop agent
$./emctl clearstate agent
$./emctl start agent
$./emctl upload agent
Step 48: RMAN retention to 35 days

At the RMAN prompt do: RMAN> show all; —(check the retention policy is set to 35 days)

Step 49: AWR retention to 90 days

–Current setting
SELECT
EXTRACT( day from snap_interval) *24*60+
EXTRACT( hour from snap_interval) *60+
EXTRACT( minute from snap_interval ) “Snapshot Interval”,
EXTRACT( day from retention) *24*60+
EXTRACT( hour from retention) *60+
EXTRACT( minute from retention ) “Retention Interval”
FROM dba_hist_wr_control
/

Snapshot Interval Retention Interval
—————– ——————
60 129600
Hourly 90 days

If not then,
– Procedure to modify
EXECUTE DBMS_WORKLOAD_REPOSITORY.MODIFY_SNAPSHOT_SETTINGS (interval => 60, retention => 129600);
Step 50: Add app and approvers to SRS

Step 51: Check Databases added to daily Database space, Standby Lag report and monthly chargeback report running from gdcx03d01

[oracle@gdcx03d01 scripts]$ pwd
/u01/app/oracle/scripts
-rw-r–r– 1 oracle dba 208 Mar 6 06:00 chk_backup_PROD_dbs.lst
-rw-r–r– 1 oracle dba 202 Mar 6 06:00 chk_backup_NONPROD_dbs.lst
edit this files and add ur db unique name into them
also need to add TNS entries for the DB which are going to monitoring by this script on gdcx03d01 $GI_HOME/network/admin/tnsnames.ora.

Step 52: Tablespace Naming convention – [APP_CDE]_TSPACE_COMP

Step 53: Hugepages

- check on all the nodes and paste the output from node 1 in a separate sheet – dcli -l oracle -g dbs_group cat /proc/meminfo|grep -i hugepages

- Runshell to Oracle on the first node of the clusterSRS
dcli -l oracle -g dbs_group cat /proc/meminfo|grep -i hugepages

Step 54: Cloud Id setup

- Register databases to APMD Sub Application CLODPLY_UAT (application CLODPLY) or CLODPLY_PROD
- Execute the grant script as below with DBA privilege against the database
/auto/users-03/e517005/CLODPLY/CLODPLY_Grants.sql
-rw-r–r– 1 e517005 osasrvs 9965 Jun 10 09:42 CLODPLY_Grants.sql
Step 55: Collect fixed stats after the migration

exec dbms_stats.gather_dictionary_stats;

exec dbms_stats.gather_fixed_objects_stats;

Step 56: Alter system statistics to use 16K blocks instead of the default of 128K

–* Query the V$AUX_STATS$ View

SET lin 120 pages 99

COL SNAME FOR A20
COL PNAME FOR A20
COL PVAL1 FOR 999999999
COL PVAL2 FOR A50

SELECT
*
FROM
SYS.AUX_STATS$
/

SELECT
*
FROM
SYS.AUX_STATS$
– Value should be set to 16
WHERE PNAME = ‘MBRC’
/

/* Procedure to set it to 16

EXEC DBMS_STATS.SET_SYSTEM_STATS (PNAME => ‘MBRC’, PVALUE => 16);

Step 57: Install SQLT on the database

Refer the attached document for installation instructions:
Note:
1. When asked for password for SQLTXPLAIN provide generic password such as welcome1.
2. SQLT installation is done under ?/auto/data.misc/oracle/exadata/SQL_Scripts/sqlt/ ?.
3. In order to check whether SQLT is already installed or not ? check for the existence of tablespace named SQLT_DATA OR u may also run this script to get the version: (version should be 12 and above)
SELECT sqltxplain.sqlt$a.get_param(‘tool_version’) sqlt_version,
sqltxplain.sqlt$a.get_param(‘tool_date’) sqlt_version_date,
sqltxplain.sqlt$a.get_param(‘install_date’) install_date
FROM DUAL;
4. Once installation is complete for each db please make a note of the same in the following format:

DB name instance number hostname SQLT installed (Y/N) DR DB (if any) instance number hostname

Step 58: Add the newly created DB to the inventory
Update this inventory when you create any new database.