set feedback  1
set scan      on
set verify    off
set trimspool on  

UNDEFINE c_user_name

Prompt Grant select table access to user &&C_user_name...

grant execute on DA.CC_UTL_PKG to &&C_user_name;
grant execute on da.dbk_stb_proc to &&C_user_name;
grant execute on da.dbk_py_stub to &&C_user_name;
grant all on da.sysqparm to &&C_user_name;
grant all on da.pytemptab to &&C_user_name;
grant all on da.jfpydet to &&C_user_name;
grant all on da.v_pystub_01 to &&C_user_name;
grant select on da.uetd_extendedde to &&C_user_name;
grant select on da.pycontrol to &&C_user_name;
grant select on da.pypayrun to &&C_user_name;
grant select on da.pycompayprd to &&C_user_name;
grant select on da.pychkloc to &&C_user_name;
grant select on da.pycompaygrp to &&C_user_name;
prompt Complete