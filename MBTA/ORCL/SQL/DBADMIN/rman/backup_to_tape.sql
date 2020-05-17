rman target / catalog rman@emgcr log=$ORACLE_BASE/admin/scripts/logs_$ORACLE_SID/backup_to_tape`date +"%m_%d_%y-%H.%M.%S"`.log
rman target / catalog rman@emgcrdr log=$ORACLE_BASE/admin/scripts/logs_$ORACLE_SID/bkp_2_tp_HRPAYDBR2`date +"%m_%d_%y-%H.%M.%S"`.log

RUN {
ALLOCATE CHANNEL CH1 TYPE 'SBT_TAPE' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
ALLOCATE CHANNEL CH2 TYPE 'SBT_TAPE' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
ALLOCATE CHANNEL CH3 TYPE 'SBT_TAPE' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
ALLOCATE CHANNEL CH4 TYPE 'SBT_TAPE' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';							
							crosscheck archivelog all;
                                CROSSCHECK BACKUP;
							resync catalog;
                                sql 'ALTER SYSTEM ARCHIVE LOG CURRENT';
                                backup as compressed backupset format 'df_%d_%s_%p_%T_%U' database tag='HRPAYDBR2';
                                sql 'ALTER SYSTEM ARCHIVE LOG CURRENT';
                                backup as compressed backupset format 'al_%d_%s_%p_%T_%U' archivelog all tag='HRPAYARCR2';
                                backup as compressed backupset format 'ctl_%d_%s_%p_%T_%U' current controlfile tag='HRPAYCTLR2';
RELEASE CHANNEL CH1;
RELEASE CHANNEL CH2;
RELEASE CHANNEL CH3;
RELEASE CHANNEL CH4;
}

parms 'ENV=(NSR_CLIENT=hseax08.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
-------------------------------------------
-------------------------------------------
-------------------------------------------
CONFIGURE CHANNEL DEVICE TYPE sbt 
PARMS='SBT_LIBRARY=/mediavendor/lib/libobk.so ENV=(NSR_SERVER=tape_svr,NSR_CLIENT=oracleclnt,NSR_GROUP=ora_tapes)';

CONFIGURE CHANNEL DEVICE TYPE 'SBT_TAPE' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)' FORMAT 'df_%d_%T_%s_%p';


old RMAN configuration parameters:
CONFIGURE CHANNEL DEVICE TYPE 'SBT_TAPE' FORMAT   'df_%d_%T_%s_%p';

RUN 
{
ALLOCATE CHANNEL CH1 TYPE 'SBT_TAPE' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
backup current controlfile;
RELEASE CHANNEL CH1;
}
---------------------------------------------
---------------------------------------------
---------------------------------------------

RUN {
ALLOCATE CHANNEL CH1 TYPE 'SBT_TAPE' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
ALLOCATE CHANNEL CH2 TYPE 'SBT_TAPE' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
ALLOCATE CHANNEL CH3 TYPE 'SBT_TAPE' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
ALLOCATE CHANNEL CH4 TYPE 'SBT_TAPE' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';							
							crosscheck archivelog all;
                                CROSSCHECK BACKUP;
							resync catalog;
                                sql 'ALTER SYSTEM ARCHIVE LOG CURRENT';
                                backup as compressed backupset format 'df_%d_%s_%p_%T_%U' database tag='HRTSTDBPTupg849';
                                sql 'ALTER SYSTEM ARCHIVE LOG CURRENT';
                                backup as compressed backupset format 'al_%d_%s_%p_%T_%U' archivelog all tag='HRTSTARCPTupg849';
                                backup as compressed backupset format 'ctl_%d_%s_%p_%T_%U' current controlfile tag='HRTSTCTLPTupg849';
RELEASE CHANNEL CH1;
RELEASE CHANNEL CH2;
RELEASE CHANNEL CH3;
RELEASE CHANNEL CH4;
}


----------------------------------------------

rman target / log=$ORACLE_BASE/admin/scripts/logs_$ORACLE_SID/backup_tape_$ORACLE_SID`date +"%m_%d_%y-%H.%M.%S"`.log
RUN {
CONFIGURE CONTROLFILE AUTOBACKUP ON;
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK CLEAR;
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE 'SBT_TAPE' TO 'ctl_spfile_auto_%d_%F'; 
CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 35 DAYS;  
CONFIGURE DEFAULT DEVICE TYPE TO DISK; 
CONFIGURE DEVICE TYPE DISK PARALLELISM 4 BACKUP TYPE TO COMPRESSED BACKUPSET;
CONFIGURE DEVICE TYPE 'SBT_TAPE' PARALLELISM 4 BACKUP TYPE TO COMPRESSED BACKUPSET;
CONFIGURE COMPRESSION ALGORITHM CLEAR;
CONFIGURE CHANNEL DEVICE TYPE DISK FORMAT '+hrtrnfra';
CONFIGURE ARCHIVELOG DELETION POLICY TO BACKED UP 2 TIMES TO 'SBT_TAPE';
ALLOCATE CHANNEL CH1 TYPE 'SBT_TAPE' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
ALLOCATE CHANNEL CH2 TYPE 'SBT_TAPE' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
ALLOCATE CHANNEL CH3 TYPE 'SBT_TAPE' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
ALLOCATE CHANNEL CH4 TYPE 'SBT_TAPE' parms 'ENV=(NSR_CLIENT=hseax02.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';							

							crosscheck archivelog all;
                                #CROSSCHECK BACKUP;
							#resync catalog;
                                sql 'ALTER SYSTEM ARCHIVE LOG CURRENT';
                                backup as compressed backupset format 'df_%d_%s_%p_%T_%U' database tag='HRTRN_DAILY';
                                sql 'ALTER SYSTEM ARCHIVE LOG CURRENT';
                                backup as compressed backupset format 'al_%d_%s_%p_%T_%U' archivelog all tag='HRTRN_DAILY';
                                backup as compressed backupset format 'ctl_%d_%s_%p_%T_%U' current controlfile tag='HRTRN_DAILY';
                            restore database preview;
RELEASE CHANNEL CH1;
RELEASE CHANNEL CH2;
RELEASE CHANNEL CH3;
RELEASE CHANNEL CH4;
}

---------------------------------------------------------
-------------------HRPRD BACKUP GO LIVE------------------
---------------------------------------------------------
rman target / catalog rman@emgcrab log=$ORACLE_BASE/admin/scripts/logs_$ORACLE_SID/backup_tape_$ORACLE_SID`date +"%m_%d_%y-%H.%M.%S"`.log

RUN {
CONFIGURE CONTROLFILE AUTOBACKUP ON;
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK CLEAR;
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE 'SBT_TAPE' TO 'ctl_spfile_auto_%d_%F'; 
CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 35 DAYS;  
CONFIGURE DEFAULT DEVICE TYPE TO DISK; 
CONFIGURE DEVICE TYPE DISK PARALLELISM 4 BACKUP TYPE TO COMPRESSED BACKUPSET;
CONFIGURE DEVICE TYPE 'SBT_TAPE' PARALLELISM 4 BACKUP TYPE TO COMPRESSED BACKUPSET;
CONFIGURE COMPRESSION ALGORITHM CLEAR;
CONFIGURE ARCHIVELOG DELETION POLICY TO APPLIED ON ALL STANDBY BACKED UP 2 TIMES TO 'SBT_TAPE';
ALLOCATE CHANNEL CH1 TYPE 'SBT_TAPE' parms 'ENV=(NSR_CLIENT=hseax08.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
ALLOCATE CHANNEL CH2 TYPE 'SBT_TAPE' parms 'ENV=(NSR_CLIENT=hseax08.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
ALLOCATE CHANNEL CH3 TYPE 'SBT_TAPE' parms 'ENV=(NSR_CLIENT=hseax08.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
ALLOCATE CHANNEL CH4 TYPE 'SBT_TAPE' parms 'ENV=(NSR_CLIENT=hseax08.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
							crosscheck archivelog all;
                                CROSSCHECK BACKUP;
							resync catalog;
                                sql 'ALTER SYSTEM ARCHIVE LOG CURRENT';
                                backup as compressed backupset format 'df_%d_%s_%p_%T_%U' database tag='HRPRDAB_DRESS';
                                sql 'ALTER SYSTEM ARCHIVE LOG CURRENT';
                                backup as compressed backupset format 'al_%d_%s_%p_%T_%U' archivelog all tag='HRPRDAB_DRESS';
                                backup as compressed backupset format 'ctl_%d_%s_%p_%T_%U' current controlfile tag='HRPRDAB_DRESS';
                            restore database preview;  
RELEASE CHANNEL CH1;
RELEASE CHANNEL CH2;
RELEASE CHANNEL CH3;
RELEASE CHANNEL CH4;
}