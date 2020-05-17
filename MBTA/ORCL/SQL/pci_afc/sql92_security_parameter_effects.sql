-- Below queries will determine if there are any users or roles with update and delete priveleges on a table but no select. If there are any
-- that will be a problem if we set "sql92_security=TRUE" 
-- Below quries return few records but all of them are for the following Oracle default roles EXP_FULL_DATABASE, DELETE_CATALOG_ROLE

select * 
from DBA_TAB_PRIVS 
where privilege in ('UPDATE','DELETE')
and (grantee, owner, table_name) not in (select grantee, owner, table_name from dba_tab_privs where privilege in ('SELECT')) 



select *
from ROLE_TAB_PRIVS
where privilege in ('UPDATE','DELETE')
and (role,owner,table_name) not in (select role,owner, table_name from role_tab_privs where privilege in ('SELECT'))