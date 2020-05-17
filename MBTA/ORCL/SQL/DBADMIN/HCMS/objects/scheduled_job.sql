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

BEGIN
  SYS.DBMS_SCHEDULER.DROP_SCHEDULE
    (schedule_name  => 'DBADMIN.MBTA_DAILY_0400_SCHDL');
END;
/

BEGIN
  SYS.DBMS_SCHEDULER.CREATE_JOB
    (
       job_name        => 'DBADMIN.mbta_sp_db_size_insert_dly_job'
      ,schedule_name   => 'DBADMIN.MBTA_DAILY_0400_SCHDL'
      ,job_class       => 'DEFAULT_JOB_CLASS'
      ,job_type        => 'STORED_PROCEDURE'
      ,job_action      => 'DBADMIN.mbta_sp_db_size_insert'
      ,comments        => 'Job to call procedure DBADMIN.mbta_sp_db_size_insert_dly_job'
    );
END;
/

BEGIN
  SYS.DBMS_SCHEDULER.DROP_JOB
    (job_name  => 'DBADMIN.MBTA_SP_DB_SIZE_INSERT_DLY_JOB');
END;
/

-- do below as job owner, do not add the schema name in the job name parameter below. It is not working with the schema name.
BEGIN
 DBMS_SCHEDULER.ADD_JOB_EMAIL_NOTIFICATION (
  job_name   =>  'mbta_sp_db_size_insert_dly_job',
  recipients =>  'database@mbta.com',
  sender     =>  'hrprdab@mbta.com',
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

-- do below as job owner to remove the above EMAIL job created
BEGIN
 DBMS_SCHEDULER.REMOVE_JOB_EMAIL_NOTIFICATION (
  job_name   =>  'mbta_sp_db_size_insert_dly_job',
  recipients =>  'database@mbta.com',
  events     =>  'JOB_SUCCEEDED, JOB_FAILED, JOB_BROKEN, JOB_DISABLED, JOB_SCH_LIM_REACHED, JOB_STOPPED, JOB_CHAIN_STALLED');
END;
/

BEGIN
DBMS_SCHEDULER.ENABLE('DBADMIN.mbta_sp_db_size_insert_dly_job');
END;
/    

