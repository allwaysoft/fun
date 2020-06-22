
-- Connect to Conv as SYS and run the below command

set serveroutput on size 1000000;

connect sys/conv@conv as sysdba;

CREATE USER da1
IDENTIFIED BY da1
/ 

GRANT CREATE SESSION to da1   
/

--grant all privileges to da1
--/

--revoke all privileges from da1
--/

grant create any table to da1
/

grant select any table to da1
/

grant insert any table to da1
/

grant create any index to da1
/

alter user da1 quota unlimited on users
/

grant delete any table to da
/

grant drop any table to da
/

--Revoke drop any table to da
--/


create table errors 
(ers_order number, ers_error varchar2(4000))
/

/*

--To see the privilege and it's name
select * from system_privilege_map
where name like '%PRIV%'


--To see all the grants allocated to a user
select *
 from dba_sys_privs
 where grantee in ('DA1','DA')
 --group by grantee

--Grant select on all VIEWS (connect as DA and issue the below command)
begin
for i in (select object_name from user_objects where object_type in ('VIEW')) LOOP
execute immediate 'grant select on DA.'||i.object_name||' to DA1'; 
end loop;
exception
when others
then
DBMS_OUTPUT.PUT_LINE (SQLERRM);
end;
/


select * from my_tab

SELECT * FROM V$DATAFILE
SELECT * FROM V$TABLESPACE

select username, schemaname 
from v$session 
where sid in (select sid from v$mystat)

select	TABLESPACE_NAME,
	INITIAL_EXTENT,
	NEXT_EXTENT,
	MIN_EXTENTS,
	MAX_EXTENTS,
	PCT_INCREASE,
	STATUS,
	CONTENTS
from 	dba_tablespaces
order 	by TABLESPACE_NAME  
    
    select INSTANCE_NAME from V$INSTANCE

    
    DEFAULT TABLESPACE example 
    QUOTA 10M ON example 
    TEMPORARY TABLESPACE temp
    QUOTA 5M ON system 
    PROFILE app_user 
    PASSWORD EXPIRE;
*/