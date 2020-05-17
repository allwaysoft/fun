Select wait_class, sum(time_waited), sum(time_waited)/sum(total_waits) Sum_Waits From v$system_wait_class;


select * from v$session_wait

select * from v$system_event

select * from v$event_name


select * from all_objects where object_name like '%WAIT%'
