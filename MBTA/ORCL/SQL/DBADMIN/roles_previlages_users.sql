http://download.oracle.com/docs/cd/B19306_01/network.102/b14266/admusers.htm#i1006219

http://www.adp-gmbh.ch/ora/concepts/profile.html   --profiles

http://asktom.oracle.com/pls/asktom/f?p=100:11:0::::P11_QUESTION_ID:646423863863



select dbms_metadata.GET_GRANTED_DDL('DEVELOPER', '<GRANTEE>') from dual ; 

select dbms_metadata.get_dependent_ddl( 'OBJECT_GRANT', 'EMP', 'SCOTT' ) from dual;




-- ROLE is being granted to other roles or other roles granted to this ROLE
select * from ROLE_ROLE_PRIVS where (role = 'DEVELOPER' or granted_role = 'DEVELOPER') 


-- ROLE is being granted to other (roles/users) or other roles granted to this ROLE. Different from above as this also includes users
select * from DBA_ROLE_PRIVS where (grantee = 'MBTACON' or granted_role = 'MBTACON')


-- System privileges granted to roles
select * from ROLE_SYS_PRIVS where role = 'PS_MB_FILEBOUND'     


-- Table privileges granted to role
select * from ROLE_TAB_PRIVS where  role = 'PS_MB_FILEBOUND'   

--Table privileges granted to user
select * from dba_tab_privs where GRANTEE ='FILEBOUND' and privilege = 'SELECT';


--system privileges and roles assigned to user
select grantee, privilege, admin_option, null default_role, 'PREV' Prev_or_role from dba_sys_privs where grantee = 'FILEBOUND'
union all     
select GRANTEE,GRANTED_ROLE,ADMIN_OPTION,DEFAULT_ROLE, 'ROLE' from DBA_ROLE_PRIVS where grantee = 'FILEBOUND'   


--ALL privileges give to a user.
select
  lpad(' ', 2*level) || granted_role "User, his roles and privileges"
from
  (
  /* THE USERS */
    select 
      null     grantee, 
      username granted_role
    from 
      dba_users
    where
      username like upper('%&enter_username%')
  /* THE ROLES TO ROLES RELATIONS */ 
  union
    select 
      grantee,
      granted_role
    from
      dba_role_privs
  /* THE ROLES TO PRIVILEGE RELATIONS */ 
  union
    select
      grantee,
      privilege
    from
      dba_sys_privs
  )
start with grantee is null
connect by grantee = prior granted_role;


--Generate scripts to create roles, previs assigned to USER
select dbms_metadata.get_ddl( 'USER', 'FILEBOUND' ) from dual
UNION ALL
select dbms_metadata.get_granted_ddl( 'SYSTEM_GRANT', 'FILEBOUND' ) from dual
--UNION ALL
--select dbms_metadata.get_granted_ddl( 'OBJECT_GRANT', 'FILEBOUND' ) from dual
UNION ALL
select dbms_metadata.get_granted_ddl( 'ROLE_GRANT', 'FILEBOUND' ) from dual;



select * from dba_tab_privs where GRANTEE ='MBTACON' and privilege = 'SELECT';

select * from dba_users

select * from dba_objects where upper(object_name) like '%PRIV%'

select * from v$OBJECT_PRIVILEGE

select * from session_privs

select * from DBA_objects where object_name like '%DBA%PRIV%'

and privilege like 'CREATE%PROFILE%'

and privilege like '%SYNONYM%'

select * from DBA_ROLE_PRIVS where grantee ='PSUSER' 


and table_name = 'PS_MB_RATE_INC_RC'

select * from dba_users order by 1


select * from dba_roles where role = 'PSUSER'



drop user perfstat cascade;