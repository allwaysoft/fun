rman target / catalog rman@emgcrab log=$ORACLE_BASE/admin/scripts/logs_$ORACLE_SID/bkp_dsk_${ORACLE_SID}_`date +"%m_%d_%y-%H.%M.%S"`.log

run
{
allocate channel c1 type disk;
allocate channel c2 type disk;
allocate channel c3 type disk;
allocate channel c4 type disk;

crosscheck archivelog all;
resync catalog;
sql 'ALTER SYSTEM ARCHIVE LOG CURRENT';
backup as compressed backupset database tag='HRPRD_DB_TAX_UPD';
sql 'ALTER SYSTEM ARCHIVE LOG CURRENT';
backup as compressed backupset archivelog all tag='HRPRD_ARC_TAX_UPD';
backup as compressed backupset current controlfile tag='HRPRD_CTL_TAX_UPD';
restore database preview;

RELEASE CHANNEL c1;
RELEASE CHANNEL c2;
RELEASE CHANNEL c3;
RELEASE CHANNEL c4;
}

-- Without KEEP, obays configured retention.
backup as compressed backupset database tag='HRPRD_DB_TAX_UPD' keep until time 'sysdate+14';
backup as compressed backupset archivelog all tag='HRPRD_ARC_TAX_UPD' keep until time 'sysdate+14';
backup as compressed backupset current controlfile tag='HRPRD_CTL_TAX_UPD' keep until time 'sysdate+14';

run
{
crosscheck archivelog all;
CROSSCHECK BACKUP;
resync catalog;
sql 'ALTER SYSTEM ARCHIVE LOG CURRENT';
backup as compressed backupset database tag='TSTR1AftrTabT';
sql 'ALTER SYSTEM ARCHIVE LOG CURRENT';
backup as compressed backupset archivelog all tag='TSTR1AftrTabT';
backup as compressed backupset current controlfile tag='TSTR1AftrTabT';
}

--TST on hseax08

run
{
crosscheck archivelog all;
CROSSCHECK BACKUP;
resync catalog;
sql 'ALTER SYSTEM ARCHIVE LOG CURRENT';
backup as compressed backupset database tag='HRDEV_DSK_TST';
sql 'ALTER SYSTEM ARCHIVE LOG CURRENT';
backup as compressed backupset archivelog all tag='HRDEV_DSK_TST';
backup as compressed backupset current controlfile tag='HRDEV_DSK_TST';
}

--###### Below is to backup to file system NOT ASM. and the control file autobackup is turned off below because, the auto backup location is in ASM and this backup and latest control file of this backup has to be on disk.

rman target / catalog rman@emgcr_dr log=$ORACLE_BASE/admin/scripts/logs_$ORACLE_SID/bkp_to_file_system_`date +"%m_%d_%y-%H.%M.%S"`.log
-- REMOVE the control file autpbackup.
run
{
allocate channel c1 type disk;
allocate channel c2 type disk;
allocate channel c3 type disk;
allocate channel c4 type disk;
crosscheck archivelog all;
resync catalog;
backup database format '/u01/backup/rmanbackup/db_%T_%u_s%s_p%p';
backup format '/u01/backup/rmanbackup/arch_%T_%u_s%s_p%p' archivelog all;
backup current controlfile for standby format'/u01/backup/rmanbackup/ctl_%T_%u_s%s_p%p' ;
}
-- add the control file autpbackup.