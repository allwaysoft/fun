#!/sbin/sh
if [ $# = 3 ]
then
        db=$1
		catdb = $2		
		emgcrpswd = $3		
        shift
else
        echo "please enter value for database sid:"
        read db
        echo $db
		
		echo "\nPlease enter value for catalog DB tns alias:"                    
		read catdb
		echo $catdb		
		
		echo "\nThis script needs connection to the catalog database as rman user. Please enter rman password for catalog DB:"
		stty -echo                     
		read emgcrpswd
		stty echo		
fi

#if [$# = 2]
#then
#	catdb = $2
#	shift 
#else	
#echo "\nThis script needs connection to the catalog database as rman user. Please enter sid for catalog DB:"                    
#read catdb
#echo $catdb
#fi

#if [$# = 3]
#then
#	emgcrpswd = $3
#	shift 
#else	
#echo "\nThis script needs connection to the catalog emgcr database as rman user. Please enter rman password for emgcr:"
#stty -echo                     
#read emgcrpswd
#stty echo
#fi

cd $SETENV
. ./setorcle11GR2 $db

HOSTNAME=$(hostname)

rman target / catalog rman/${emgcrpswd}@${catdb} log=$ORACLE_BASE/admin/scripts/logs_$db/9bregister_new_db_catalog`date +"%m_%d_%y-%H.%M.%S"`.log using $db <<EOFRMAN

unregister database noprompt;

register database;

CONFIGURE CONTROLFILE AUTOBACKUP ON;
#CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '+&1fra'; see the notes below on why this is commented.
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK CLEAR;
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE 'SBT_TAPE' TO 'ctl_spfile_auto_%d_%F'; 
#CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE 'SBT_TAPE' CLEAR; 
#Incase of tape backups: format has to be used, as we are not configuring any sbt_tape channels as the duplication DB is being delayed if tape channels are configured. If format is not used and there are no tape channel CONFIGURATION, control and spfile will not be autobacked up at all. In case os restore: when tape channels are allocated and if spfile or controlfile has to be restored, when not using catalog, FORMAT #COMMAND has to be used **format 'ctl_spfile_auto_%d_%F'**
CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 35 DAYS;  
CONFIGURE DEFAULT DEVICE TYPE TO DISK; 
CONFIGURE DEVICE TYPE DISK PARALLELISM 4 BACKUP TYPE TO COMPRESSED BACKUPSET;
CONFIGURE DEVICE TYPE 'SBT_TAPE' PARALLELISM 4 BACKUP TYPE TO COMPRESSED BACKUPSET;
CONFIGURE COMPRESSION ALGORITHM CLEAR;
CONFIGURE CHANNEL DEVICE TYPE DISK FORMAT '+&1fra';
CONFIGURE ARCHIVELOG DELETION POLICY TO BACKED UP 2 TIMES TO 'SBT_TAPE';
# CONFIGURE ARCHIVELOG DELETION POLICY TO APPLIED ON ALL STANDBY BACKED UP 2 TIMES TO 'SBT_TAPE'; 
# this to be used when configuring on Primary DB
exit;

EOFRMAN

echo "\nlog is generated at " $ORACLE_BASE/admin/scripts/logs_$db/

#Above formats are confirmed as giging the asm FULL path or not giving the path at all is causing problems.
#CONFIGURE ARCHIVELOG DELETION POLICY TO NONE;
#CONFIGURE CHANNEL DEVICE TYPE 'SBT_TAPE' FORMAT 'df_%d_%T_%s_%p';
#CONFIGURE CHANNEL DEVICE TYPE 'SBT_TAPE' parms 'ENV=(NSR_CLIENT=${HOSTNAME}.mbta.com,NSR_SERVER=hs-networker1.mbta.com,NSR_DATA_VOLUME_POOL=HPLTO4)' FORMAT 'db_%d_%s_%p_%T_%U';
#If above configuration is done, when duplicating, it is spending lot of time with the tape channels, even though there is no use of tape channels while duplicating (when doing a duplication from backup on disk or active DB).
# Even though deletion policy is set on archive logs, FRA is an exception, they will still be retained until there is free space in FRA. Once space isneeded in FRA archivelogs eligable for deletion are deleted.
# Check the below link for archive log deletion when using DR setup.
#
#https://forums.oracle.com/forums/thread.jspa?messageID=10350995
#https://forums.oracle.com/forums/thread.jspa?threadID=2269581
# CONFIGURE ARCHIVELOG DELETION POLICY TO APPLIED ON ALL STANDBY BACKED UP 2 TIMES TO 'SBT_TAPE'; Look at email RMAN Archivelog AutoDeletion Solution from NITIN on 09/13/2012 at 7:39 AM for more clarification on archivelog deletion policy on Primary and standby
#CONFIGURE CHANNEL DEVICE TYPE DISK CLEAR;
#
# CONFIGURE DEVICE TYPE 'SBT_TAPE' CLEAR;
#***** removing the aboce will remove most of the SBT_TAPE configuratinos in RMAN *****
#---------------------------------------------------------------------------------------------
#CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '+&1fra';
#above parameter should not be set by default the control files autobackup goes to FRA if it is set, and goes to $ORACLE_HOME/dbs if FRA is not set.
# In our case, we have set the FRA so it should to go to FRA. If a FORMAT for the autobackup is used, that has to be specified while restoring, when not using catalog, and spfile and controlfile are lost.
# So, to keep it simple, I have decided to use the defult and it can be achieve by clearing the configuration.
#https://forums.oracle.com/forums/thread.jspa?messageID=10196105&tstart=0#10196105
#
# **********ABOUT ARCHIVELOG DELETION POLICY IN DG ENVIRONMENT. FOLLOW ONLY BELOW.
#
# http://docs.oracle.com/cd/B19306_01/server.102/b14239/rman.htm#SBYDB00750
# 728053.1
# **********
#
#**************************************************************************************
# backup only those archivelogs which are not backedup before to tape. Even though, the
# device type is not mentioned in the backup archivelod all not backedup statement, RMAN
# will consider only those backups on the device type it is backing up to. See below. 
# http://docs.oracle.com/cd/E11882_01/backup.112/e10642/rcmbckba.htm
#
#Above is actually not needed because of the below. Here it says, if there is a archivelog deletion policy in
#place, the regular rman backup of archivelogs will backup only those which are out of deletion policy.
#http://docs.oracle.com/cd/E11882_01/backup.112/e10642/rcmconfb.htm#CHDCFHBG
#**************************************************************************************