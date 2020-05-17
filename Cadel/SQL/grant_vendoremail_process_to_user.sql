set feedback  1
set scan      on
set verify    off
set trimspool on  

UNDEFINE c_user_name

Prompt Grant select table access to user &&C_user_name...

grant execute on DA.CC_UTL_PKG to &&C_user_name;
grant execute on da.DBK_AP_PRTCHK_CMETH to &&C_user_name;
grant select on DA.PAYSEL to &&C_user_name;
grant all on da.sysqparm to &&C_user_name;
grant all on da.reportcontacts to &&C_user_name;
grant select on da.JFAPMAST to &&C_user_name;
grant select on da.jfapdet to &&C_user_name;
grant select on da.payamt to &&C_user_name;
prompt Complete