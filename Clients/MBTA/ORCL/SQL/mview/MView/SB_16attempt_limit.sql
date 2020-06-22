
connect sys/manager@mvdb as sysdba;
grant dba to mviewadmin;
disconnect;
connect mviewadmin/mviewadmin@mvdb;

create or replace procedure Jobs_Broken_Proc is
  cursor my_broken_jobs is
      select job from user_jobs where broken = 'Y';
begin

  for broken_job in my_broken_jobs loop
      begin
        dbms_job.broken(broken_job.job,FALSE);
      exception
         when others then null;
      end;
  end loop;
end;
/


create or replace procedure Jobs_Broken is
  jobno number;
begin

  dbms_job.submit( job => jobno, 
      what => 'Jobs_Broken_Proc;', 
      next_date => sysdate,  
      interval => 'sysdate + (1/(24*60))'); 
  dbms_job.run(jobno);
  commit;

end;
/


execute Jobs_Broken_Proc;
execute Jobs_Broken;

disconnect;
connect sys/manager as sysdba@mvdb;
revoke dba from mviewadmin;
--exit;
