set verify off
ACCEPT sysPassword CHAR PROMPT 'Enter new password for SYS: ' HIDE
ACCEPT systemPassword CHAR PROMPT 'Enter new password for SYSTEM: ' HIDE
ACCEPT dbsnmpPassword CHAR PROMPT 'Enter new password for DBSNMP: ' HIDE
ACCEPT asmSysPassword CHAR PROMPT 'Enter ASM SYS user password: ' HIDE
host /u01/app/oracle/product/11.2.0/db_1/bin/orapwd file=/u01/app/oracle/product/11.2.0/db_1/dbs/orapwhrtrn force=y
host /u01/app/grid/product/11.2.0/grid/bin/setasmgidwrap o=/u01/app/oracle/product/11.2.0/db_1/bin/oracle
@/u01/app/oracle/admin/scripts/dbca/hrtrn/CreateDB.sql
@/u01/app/oracle/admin/scripts/dbca/hrtrn/CreateDBFiles.sql
@/u01/app/oracle/admin/scripts/dbca/hrtrn/CreateDBCatalog.sql
@/u01/app/oracle/admin/scripts/dbca/hrtrn/JServer.sql
@/u01/app/oracle/admin/scripts/dbca/hrtrn/xdb_protocol.sql
@/u01/app/oracle/admin/scripts/dbca/hrtrn/ordinst.sql
@/u01/app/oracle/admin/scripts/dbca/hrtrn/interMedia.sql
@/u01/app/oracle/admin/scripts/dbca/hrtrn/apex.sql
host /u01/app/oracle/product/11.2.0/db_1/bin/srvctl add database -d hrtrn -o /u01/app/oracle/product/11.2.0/db_1 -p +HRTRNDATA/hrtrn/spfilehrtrn.ora -n hrtrn -m mbta.com -a HRTRNDATA,HRTRNFRA
host echo "SPFILE='+HRTRNDATA/hrtrn/spfilehrtrn.ora'" > /u01/app/oracle/product/11.2.0/db_1/dbs/inithrtrn.ora
@/u01/app/oracle/admin/scripts/dbca/hrtrn/lockAccount.sql
@/u01/app/oracle/admin/scripts/dbca/hrtrn/postDBCreation.sql
