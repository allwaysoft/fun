#!/bin/sh

OLD_UMASK=`umask`
umask 0027
mkdir -p /u01/app/oracle/admin/hrtrn/adump
mkdir -p /u01/app/oracle/admin/hrtrn/dpdump
mkdir -p /u01/app/oracle/admin/hrtrn/pfile
mkdir -p /u01/app/oracle/cfgtoollogs/dbca/hrtrn
umask ${OLD_UMASK}
ORACLE_SID=hrtrn; export ORACLE_SID
PATH=$ORACLE_HOME/bin:$PATH; export PATH
echo You should Add this entry in the /etc/oratab: hrtrn:/u01/app/oracle/product/11.2.0/db_1:Y
/u01/app/oracle/product/11.2.0/db_1/bin/sqlplus /nolog @/u01/app/oracle/admin/scripts/dbca/hrtrn/hrtrn.sql
