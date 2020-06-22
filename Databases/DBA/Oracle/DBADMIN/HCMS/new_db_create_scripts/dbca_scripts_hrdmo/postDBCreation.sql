SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /u01/app/oracle/admin/scripts/dbca/hrtrn/postDBCreation.log append
@/u01/app/oracle/product/11.2.0/db_1/rdbms/admin/catbundle.sql psu apply;
select 'utl_recomp_begin: ' || to_char(sysdate, 'HH:MI:SS') from dual;
execute utl_recomp.recomp_serial();
select 'utl_recomp_end: ' || to_char(sysdate, 'HH:MI:SS') from dual;
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
create spfile='+HRTRNDATA/hrtrn/spfilehrtrn.ora' FROM pfile='/u01/app/oracle/admin/scripts/dbca/hrtrn/init.ora';
shutdown immediate;
host /u01/app/oracle/product/11.2.0/db_1/bin/srvctl enable database -d hrtrn;
host /u01/app/oracle/product/11.2.0/db_1/bin/srvctl start database -d hrtrn;
connect "SYS"/"&&sysPassword" as SYSDBA
host /u01/app/oracle/product/11.2.0/db_1/bin/emca -config centralAgent db -silent -ASM_USER_ROLE SYSDBA -ASM_USER_NAME ASMSNMP -CENTRAL_AGT_HOME /u01/app/oracle/product/Middleware/agent11g -LOG_FILE /u01/app/oracle/admin/scripts/dbca/hrtrn/emConfig.log -SID hrtrn -ASM_SID +ASM -DB_UNIQUE_NAME hrtrn -EM_HOME /u01/app/oracle/product/11.2.0/db_1 -SERVICE_NAME hrtrn.mbta.com -ASM_PORT 1521 -PORT 1521 -LISTENER_OH /u01/app/grid/product/11.2.0/grid -LISTENER LISTENER -ORACLE_HOME /u01/app/oracle/product/11.2.0/db_1 -HOST hsuxb1vm2.mbta.com -ASM_OH /u01/app/grid/product/11.2.0/grid;
spool off
