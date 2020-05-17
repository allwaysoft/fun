

-- Oracle 11g top feature for dba. look for section audit.
http://www.oracle.com/technetwork/articles/sql/11g-security-100258.html

--purging sys.aud$
http://www.pythian.com/news/1106/oracle-11g-audit-enabled-by-default-but-what-about-purging/

--difference between regular auditing and fine grained auditing (FGA) 
http://www.toadworld.com/KNOWLEDGE/KnowledgeXpertforOracle/tabid/648/TopicID/FGAVS/Default.aspx

-- Auto Purge OS/DB Audit Logs. 11.2 feature
http://www.oracle-base.com/articles/11g/auditing-enhancements-11gr2.php#purging_audit_trail_records

-- Steps to Auto Purge OS/DB Audit Logs. 11.2 feature
--AS SYS user

--1. Run the below queries to find the tablespace of the two tables and their sizes. Next make sure SYSAUX table space enough space allocated to it to accomidate these two tables. Even if auto extend is on, the tablespace should have enough space pre allocated to it to accomidate these tables.

SELECT table_name, tablespace_name FROM dba_tables WHERE table_name IN ('AUD$', 'FGA_LOG$') ORDER BY table_name;

select segment_name,bytes/1024/1024 size_in_megabytes from dba_segments where segment_name in ('AUD$','FGA_LOG$');

--2. Run the below procedure which initializes the audit management infrastructure for audit trails and rechecks it every 12 hours. 

BEGIN
  DBMS_AUDIT_MGMT.init_cleanup(
    audit_trail_type         => DBMS_AUDIT_MGMT.AUDIT_TRAIL_ALL,
    default_cleanup_interval => 24 /* hours */);
END;
/

--In case if the cleanup interval has to be changed, use the below procedure.
BEGIN
DBMS_AUDIT_MGMT.SET_AUDIT_TRAIL_PROPERTY(
       audit_trail_type => DBMS_AUDIT_MGMT.AUDIT_TRAIL_ALL,
       audit_trail_property  =>  DBMS_AUDIT_MGMT.CLEAN_UP_INTERVAL,
       audit_trail_property_value =>  24 /* hours */ );
END;
/

--3. Check if the properties are set properly and initialization is started.
COLUMN parameter_name FORMAT A30
COLUMN parameter_value FORMAT A20
COLUMN audit_trail FORMAT A20

SELECT * FROM dba_audit_mgmt_config_params;

SET SERVEROUTPUT ON
BEGIN
  IF DBMS_AUDIT_MGMT.is_cleanup_initialized(DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD) THEN
    DBMS_OUTPUT.put_line('YES');
  ELSE
    DBMS_OUTPUT.put_line('NO');
  END IF;
END;
/

/* -- This is not required as we set this in step 6 below.
--4. Set the time to delete audit trails before a certain period. Below is to delete anything older than 30 days.

BEGIN
  DBMS_AUDIT_MGMT.set_last_archive_timestamp(
    audit_trail_type  => DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD,  -- Cant sue AUDIT_TRAIL_ALL_STD as a parameter each individual audit has to be delt indiviaully
    last_archive_time => SYSTIMESTAMP-30);
END;
/

BEGIN
  DBMS_AUDIT_MGMT.set_last_archive_timestamp(
    audit_trail_type  => DBMS_AUDIT_MGMT.AUDIT_TRAIL_DB_STD,
    last_archive_time => SYSTIMESTAMP-30);
END;
/

BEGIN
  DBMS_AUDIT_MGMT.set_last_archive_timestamp(
    audit_trail_type  => DBMS_AUDIT_MGMT.AUDIT_TRAIL_FGA_STD,
    last_archive_time => SYSTIMESTAMP-30);
END;
/

BEGIN
  DBMS_AUDIT_MGMT.set_last_archive_timestamp(
    audit_trail_type  => DBMS_AUDIT_MGMT.AUDIT_TRAIL_OS,
    last_archive_time => SYSTIMESTAMP-30);
END;
/

BEGIN
  DBMS_AUDIT_MGMT.set_last_archive_timestamp(
    audit_trail_type  => DBMS_AUDIT_MGMT.AUDIT_TRAIL_XML,
    last_archive_time => SYSTIMESTAMP-30);
END;
/

--5. Check if the time is set properly.

SELECT * FROM dba_audit_mgmt_last_arch_ts;

*/

-- AS SYS user
--6. Now comes the actual purge job.

-- This job runs every 24 hours.
BEGIN
  DBMS_AUDIT_MGMT.create_purge_job(
    audit_trail_type           => DBMS_AUDIT_MGMT.AUDIT_TRAIL_ALL,
    audit_trail_purge_interval => 24 /* hours */,  
    audit_trail_purge_name     => 'MBTA_PURGE_ALL_AUDIT_TRAILS',
    use_last_arch_timestamp    => TRUE);   -- Since it says true here, below procedure has to be done keep this parameter up to date.
END;
/

-- Enable/Disable above job wth the below proceudre
BEGIN
/*
  DBMS_AUDIT_MGMT.set_purge_job_status(
    audit_trail_purge_name   => 'MBTA_PURGE_ALL_AUDIT_TRAILS',
    audit_trail_status_value => DBMS_AUDIT_MGMT.PURGE_JOB_DISABLE);
*/
  DBMS_AUDIT_MGMT.set_purge_job_status(
    audit_trail_purge_name   => 'MBTA_PURGE_ALL_AUDIT_TRAILS',
    audit_trail_status_value => DBMS_AUDIT_MGMT.PURGE_JOB_ENABLE);
END;
/

-- if DOESN'T ALREADY EXIST. create a schedule which runs every 24 hours 
BEGIN
  SYS.DBMS_SCHEDULER.CREATE_SCHEDULE
    (
      schedule_name    => 'DBADMIN.MBTA_DAILY_0400_SCHDL'
     ,start_date       => TO_TIMESTAMP_TZ('','yyyy/mm/dd hh24:mi:ss.ff tzr')
     ,repeat_interval  => 'FREQ=DAILY; BYDAY=MON,TUE,WED,THU,FRI,SAT,SUN; BYHOUR=04; BYMINUTE=00'
     ,end_date         => NULL
     ,comments         => 'Runtime: Every day (Mon-Sun) at 0400 hours'
    );
END;
/

--But the use_last_archive_timestamp has to me modified to follow the 

BEGIN
  DBMS_SCHEDULER.create_job (
    job_name        => 'MB_SET_AUDIT_LAST_ARCHIVE_TIME',
	schedule_name   => 'DBADMIN.MBTA_DAILY_0400_SCHDL',
    job_type        => 'PLSQL_BLOCK',
    job_action      => 'BEGIN 
                          DBMS_AUDIT_MGMT.SET_LAST_ARCHIVE_TIMESTAMP(DBMS_AUDIT_MGMT.AUDIT_TRAIL_AUD_STD, TRUNC(SYSTIMESTAMP)-30);
                          DBMS_AUDIT_MGMT.SET_LAST_ARCHIVE_TIMESTAMP(DBMS_AUDIT_MGMT.AUDIT_TRAIL_FGA_STD, TRUNC(SYSTIMESTAMP)-30);
                          DBMS_AUDIT_MGMT.SET_LAST_ARCHIVE_TIMESTAMP(DBMS_AUDIT_MGMT.AUDIT_TRAIL_OS, TRUNC(SYSTIMESTAMP)-30);
                          DBMS_AUDIT_MGMT.SET_LAST_ARCHIVE_TIMESTAMP(DBMS_AUDIT_MGMT.AUDIT_TRAIL_XML, TRUNC(SYSTIMESTAMP)-30);
                        END;',
	job_class       => 'DEFAULT_JOB_CLASS',						
    enabled         => TRUE,
    comments        => 'Automatically set audit last archive time to help MBTA_PURGE_ALL_AUDIT_TRAILS job deletion policy.');
END;
/

--To drop above job
BEGIN
  SYS.DBMS_SCHEDULER.DROP_JOB
    (job_name  => 'MB_SET_AUDIT_LAST_ARCHIVE_TIME');
END;
/


--7.  do below as job owner, do not add the schema name in the job name parameter below. It is not working with the schema name.


--******NOTE: Change the emails below accordingly. Below tested on EMGCR DB so used that email id.
BEGIN
 DBMS_SCHEDULER.ADD_JOB_EMAIL_NOTIFICATION (
  job_name   =>  'MB_SET_AUDIT_LAST_ARCHIVE_TIME',
  recipients =>  'database@mbta.com',
  sender     =>  'emgcrab@mbta.com',
  subject    =>  'Oracle Scheduler Job Notification:- %job_owner%.%job_name%: %event_type%',
  body       =>  'Job: %job_owner%.%job_name%.%job_subname% 
 Event: %event_type%
 Date: %event_timestamp%
 Log id: %log_id%
 Job class: %job_class_name%
 Run count: %run_count%
 Failure count: %failure_count%
 Retry count: %retry_count%
 Error code: %error_code%
 Error message, if any: %error_message%',
  events     =>  'JOB_FAILED, JOB_BROKEN, JOB_DISABLED, JOB_SCH_LIM_REACHED, JOB_STOPPED, JOB_CHAIN_STALLED');
END;
/ 



--******NOTE: Change the emails below accordingly. Below tested on EMGCR DB so used that email id.
BEGIN
 DBMS_SCHEDULER.ADD_JOB_EMAIL_NOTIFICATION (
  job_name   =>  'MBTA_PURGE_ALL_AUDIT_TRAILS',
  recipients =>  'database@mbta.com',
  sender     =>  'emgcrab@mbta.com',
  subject    =>  'Oracle Scheduler Job Notification:- %job_owner%.%job_name%: %event_type%',
  body       =>  'Job: %job_owner%.%job_name%.%job_subname% 
 Event: %event_type%
 Date: %event_timestamp%
 Log id: %log_id%
 Job class: %job_class_name%
 Run count: %run_count%
 Failure count: %failure_count%
 Retry count: %retry_count%
 Error code: %error_code%
 Error message, if any: %error_message%',
  events     =>  'JOB_FAILED, JOB_BROKEN, JOB_DISABLED, JOB_SCH_LIM_REACHED, JOB_STOPPED, JOB_CHAIN_STALLED');
END;
/ 
   
-- do below as job owner to remove the above job created
BEGIN
 DBMS_SCHEDULER.REMOVE_JOB_EMAIL_NOTIFICATION (
  job_name   =>  'MBTA_PURGE_ALL_AUDIT_TRAILS'
 );
END;
/









