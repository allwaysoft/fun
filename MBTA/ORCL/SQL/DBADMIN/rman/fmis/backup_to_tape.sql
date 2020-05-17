rman target / catalog rman@emgcrab log=$ORACLE_BASE/admin/scripts/logs_$ORACLE_SID/backup_tape_${ORACLE_SID}_`date +"%m_%d_%y-%H.%M.%S"`.log

RUN {
ALLOCATE CHANNEL CH1 TYPE 'SBT_TAPE' parms 'ENV=(NSR_CLIENT=hseax09.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';

backup current controlfile;
							
RELEASE CHANNEL CH1;
}


RUN {
ALLOCATE CHANNEL CH1 TYPE 'SBT_TAPE' parms 'ENV=(NSR_CLIENT=hseax09.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
ALLOCATE CHANNEL CH2 TYPE 'SBT_TAPE' parms 'ENV=(NSR_CLIENT=hseax09.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
ALLOCATE CHANNEL CH3 TYPE 'SBT_TAPE' parms 'ENV=(NSR_CLIENT=hseax09.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';
ALLOCATE CHANNEL CH4 TYPE 'SBT_TAPE' parms 'ENV=(NSR_CLIENT=hseax09.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)';

crosscheck archivelog all;
resync catalog;
sql 'ALTER SYSTEM ARCHIVE LOG CURRENT';
backup as compressed backupset format 'df_%d_%s_%p_%T_%U' database tag='FNPRDA_TAPE3';
sql 'ALTER SYSTEM ARCHIVE LOG CURRENT';
backup as compressed backupset format 'al_%d_%s_%p_%T_%U' archivelog all tag='FNPRDA_TAPE3';
backup as compressed backupset format 'ctl_%d_%s_%p_%T_%U' current controlfile tag='FNPRDA_TAPE3';
restore database preview;   
							
RELEASE CHANNEL CH1;
RELEASE CHANNEL CH2;
RELEASE CHANNEL CH3;
RELEASE CHANNEL CH4;
}


CROSSCHECK BACKUP;
DELETE NOPROMPT OBSOLETE;
DELETE NOPROMPT EXPIRED BACKUP;
DELETE NOPROMPT EXPIRED ARCHIVELOG ALL;
delete noprompt foreign archivelog until time 'sysdate-2'; 