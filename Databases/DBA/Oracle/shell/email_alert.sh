#!/usr/bin/sh
log_file=/u01/app/oracle/diag/rdbms/hrdev/hrdev/trace/alert_hrdev.log
Last_lin=`wc -l $log_file|cut -d' ' -f1`
cnrl=`cat email_alert_ctl`
echo $cnrl
#echo $sed_com
#`$sed_com`
#sed '1500,11620p' /u01/app/oracle/diag/rdbms/hrdev/hrdev/trace/alert_hrdev.log|grep 'ORA-'>test
#sed '`wc -l $log_file|cut -d' ' -f1`,`cat email_alert_ctl`p' /u01/app/oracle/diag/rdbms/hrdev/hrdev/trace/alert_hrdev.log|grep 'ORA-'>test
sed -n ''"$cnrl"',$ {
	/^ORA-.*/{
	P
	}
	}' $log_file |mailx -s "ORACLE Error" kpabba@mbta.com

echo "$Last_lin">email_alert_ctl 
