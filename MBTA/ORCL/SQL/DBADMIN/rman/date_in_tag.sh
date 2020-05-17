RMAN Hot backup---unix script
*******************************************

The RMAN hot backup script rman_backup.sh:
#!/bin/bash

# Declare your environment variables
export ORACLE_SID=hrpay
export ORACLE_BASE=/u01/app/oracle
export ORACLE_HOME=/u01/app/oracle/product/11.2.0/db_1
export PATH=$PATH:${ORACLE_HOME}/bin
currentdate=`date '+%m%d%y%H%M%S'`

# Start the rman commands
rman catalog rman/rman1@emgcr target / LOG=/u01/app/oracle/admin/scripts/logs_hrpay/backup/rman.log << EOF
CONFIGURE CONTROLFILE AUTOBACKUP ON;
CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 6 DAYS;
run {
                                backup as compressed backupset format 'al_%d_%T_%s_%p' archivelog all delete input tag='HRPAYARC${currentdate}';
                                backup as compressed backupset format 'ctl_%d_%T_%s_%p' current controlfile tag='HRPAYCTL${currentdate}';
    }
                                EXIT;
EOF                                
