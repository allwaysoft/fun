
cd /home/oracle/setenv

. ./setorcl_11GR2.sh hrdev

DT=`date +%Y.%m.%d`

PFILE=/u01/app/oracle/admin/hrdev/pfile/inithrdev.ora

echo
echo Backup for $DT
echo Selecting the files that must be backed up....
echo

sqlplus -S '/ as sysdba' <<EOFSQL

set termout off
set pages 0
set lines 120
set feedback off
set trimspool on

create pfile='/u01/app/oracle/admin/hrdev/pfile/inithrdev.ora' from spfile;

spool hrdev.cold.backup.files

select name   from v$datafile;
select name   from v$controlfile;
select member from v$logfile;
select '$PFILE' from dual;

spool off

shutdown immediate

exit;

EOFSQL


echo
echo now taring...
echo

tar cfv - -I hrdev.cold.backup.files | gzip | rsh -l some_user some_host "cat - > /path/to/destdir/backup-$DT.tar.gz"

sqlplus -S '/ as sysdba' <<EOFSQL
startup
exit;
EOFSQL
