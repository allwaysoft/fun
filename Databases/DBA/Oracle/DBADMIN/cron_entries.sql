--CRON job entries for statspack

--on hseax01
0 22 * * * /u00/app/oracle/admin/scripts/dbadmin/shell/db/HealthCheck_emgcr.sh
#Below is to run the statspack reports every night
45 23 * * * /u00/app/oracle/admin/scripts/dbadmin/statspack/statspack_auto.sh
#Below is to backup some log files
30 22 * * 1 /u00/app/oracle/admin/scripts/dbadmin/housekeeping/hseax01_oracle_mv.sh

--on hseax08
#Below is to run the statspack reports every night
45 23 * * * /u01/app/oracle/admin/scripts/dbadmin/statspack/statspack_auto.sh