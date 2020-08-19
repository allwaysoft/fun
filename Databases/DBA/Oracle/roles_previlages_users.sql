http://download.oracle.com/docs/cd/B19306_01/network.102/b14266/admusers.htm#i1006219

http://www.adp-gmbh.ch/ora/concepts/profile.html   --profiles

http://asktom.oracle.com/pls/asktom/f?p=100:11:0::::P11_QUESTION_ID:646423863863

/*
--*****SYSTEM PRIVILEGES 

system privileges assigned to ROLE are trickey. the user assigning this privilege to a user must have the GRANT ANY PRIVILEGE with "ADMIN OPTION" . If the ADMIN OPTION is missing for user granting this privilege to a role then the grant will not work directly. See below for more details.

Prerequisites
To grant a system privilege, one of the following conditions must be met:
You must have been granted the GRANT ANY PRIVILEGE system privilege. In this case, if you grant the system privilege to a role, then a user to whom the role has been granted does not have the privilege unless the role is enabled in user's session.
You must have been granted the system privilege with the ADMIN OPTION. In this case, if you grant the system privilege to a role, then a user to whom the role has been granted has the privilege regardless whether the role is enabled in the user's session.

To grant a role, you must either have been granted the role with the ADMIN OPTION or have been granted the GRANT ANY ROLE system privilege, or you must have created the role.

To grant an object privilege, you must own the object, or the owner of the object must have granted you the object privileges with the GRANT OPTION, or you must have been granted the GRANT ANY OBJECT PRIVILEGE system privilege. If you have the GRANT ANY OBJECT PRIVILEGE, then you can grant the object privilege only if the object owner could have granted the same object privilege. In this case, the GRANTOR column of the DBA_TAB_PRIVS view displays the object owner rather than the user who issued the GRANT statement.

https://docs.oracle.com/cd/B28359_01/server.111/b28286/statements_9013.htm#

--***** DROP privilege can't be provided at object level. Only thing available is DROP ANY TABLE

--***** Privs and Roles catalog tables
http://www.dbaref.com/users-privs-and-roles

*/

--------------------------------------------------------------------------------------------------------------------------
--Impersonate a different DB user
ALTER USER BWONG002 GRANT CONNECT THROUGH digital_priv_user;

CONN digital_priv_user[BWONG002]@stgmyblue;

ALTER USER BWONG002 REVOKE CONNECT THROUGH digital_priv_user;

--------------------------------------------------------------------------------------------------------------------------
--Create new user
create user vpande03 
identified by ExpiredPassword
default tablespace yyyy 
password expire;
grant CONNECT to vpande03;
grant SELECT_CATALOG_ROLE to vpande03;
select * from dba_users

--------------------------------------------------------------------------------------------------------------------------
select dbms_metadata.GET_GRANTED_DDL('DEVELOPER', '<GRANTEE>') from dual ; 

select dbms_metadata.get_dependent_ddl( 'OBJECT_GRANT', 'EMP', 'SCOTT' ) from dual;


-- ROLE is being granted to other roles or other roles granted to this ROLE
select * from ROLE_ROLE_PRIVS where (role = 'DEVELOPER' or granted_role = 'DEVELOPER') 


-- ROLE is being granted to other (roles/users) or other roles granted to this ROLE. Different from above as this also includes users
select * from DBA_ROLE_PRIVS where (grantee = 'MBTACON' or granted_role = 'MBTACON')

grant create synonym to etluser

--****************ROLES
--Other roles assigned to a role
select * from DBA_role_privs where grantee =  'PZNETLADMIN_READ_RL'   --If can't access DBA use ROLE_ROLE_PRIVS

-- System privileges granted to roles
select * from DBA_SYS_PRIVS where grantee = 'PZNETLADMIN_READ_RL'     --If can't access DBA use ROLE_SYS_PRIVS

-- Object privileges granted to role
select * from DBA_TAB_PRIVS where  grantee = 'PZNETLADMIN_READ_RL'   --If can't access DBA use ROLE_TAB_PRIVS



--***************USERS

--ALL privileges give to a user.
select lpad(' ', 2*level) || granted_role "User, his roles and privileges"
from
  (
  /* THE USERS */
    select null     grantee,  username granted_role from dba_users
    where username like upper('%&enter_username%')
  union
    /* THE ROLES TO ROLES RELATIONS */ 
    select grantee, granted_role from dba_role_privs
  union
    /* THE ROLES TO PRIVILEGE RELATIONS */ 
    select grantee, privilege from dba_sys_privs
  )
  start with grantee is null
  connect by grantee = prior granted_role
  union all
    /* DIRECT PRIVS TO USER */
  select  privilege || ' on ' || owner || '.' ||table_name from dba_tab_privs where grantee = upper('&enter_username');


--Direct privileges granted to user
select * 
from dba_tab_privs where GRANTEE ='FILEBOUND' and privilege = 'SELECT';

--system privileges and roles assigned to user
select grantee, privilege, admin_option, null default_role, 'PREV' Prev_or_role 
from dba_sys_privs where grantee = 'FILEBOUND'
union all     
select GRANTEE,GRANTED_ROLE,ADMIN_OPTION,DEFAULT_ROLE, 'ROLE' 
from DBA_ROLE_PRIVS where grantee = 'FILEBOUND'   

  


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