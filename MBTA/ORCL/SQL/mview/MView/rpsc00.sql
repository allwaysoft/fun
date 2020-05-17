spool rpsc00.log

set echo on

connect sys/internal@mvdb as sysdba

alter database rename global_name to NWCD.STA1118;

spool off

exit
