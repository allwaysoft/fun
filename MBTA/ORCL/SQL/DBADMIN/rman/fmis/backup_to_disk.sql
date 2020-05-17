rman target / catalog rman@emgcrab log=$ORACLE_BASE/admin/scripts/logs_$ORACLE_SID/bkp_dsk_${ORACLE_SID}_`date +"%m_%d_%y-%H.%M.%S"`.log

-- Note: there is no format used below, it is not needed when using FRA, if a format is used the backups go to ORACLE_HOME/dbs

RUN {
allocate channel c1 type disk;
allocate channel c2 type disk;
allocate channel c3 type disk;
allocate channel c4 type disk;

crosscheck archivelog all;
resync catalog;
sql 'ALTER SYSTEM ARCHIVE LOG CURRENT';
backup as compressed backupset database tag='1st_bkp';
sql 'ALTER SYSTEM ARCHIVE LOG CURRENT';
backup as compressed backupset archivelog all tag='1st_bkp';
backup as compressed backupset current controlfile tag='1st_bkp';
restore database preview;  

CROSSCHECK BACKUP;
DELETE NOPROMPT OBSOLETE;
DELETE NOPROMPT EXPIRED BACKUP;
DELETE NOPROMPT EXPIRED ARCHIVELOG ALL;
delete noprompt foreign archivelog until time 'sysdate-2';  
							
RELEASE CHANNEL c1;
RELEASE CHANNEL c2;
RELEASE CHANNEL c3;
RELEASE CHANNEL c4;
}