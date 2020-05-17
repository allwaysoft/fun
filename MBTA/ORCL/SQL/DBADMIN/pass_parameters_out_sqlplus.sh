
Delete Archivelogs from Standby after it has been applied
June 16th, 2011 | Tags: applied, archivelog, dataguard

My script to delete arch logs from Dataguard when archlogs backups are taken from Primary database.

#!/bin/ksh
################################################################################
#
#  Script to perform purge of the archive logs applied in the standby database
#
#  MODIFICATION HISTORY:
#
#  Ver   Name               Date        Comments
#  —– —————–  ———-  —————————————
#  01.00 Alex Lima          2011-06-15  Initial Release.
#
#
#
################################################################################

. /scripts/dba/bin/SetOracleEnv

export script=`basename $0`
export tmpf=/tmp/”${script}_${vdate}.tmp”
export logtokeep=5

### Get Max sequence # applied from Primary database ###
applied_sequence=`sqlplus -silent /nolog  <<EOSQL
connect / as sysdba
whenever sqlerror exit sql.sqlcode
set pagesize 0 feedback off verify off heading off echo off
select max(sequence#) from v\\$archived_log where applied = ‘YES’ and REGISTRAR=’RFS’;
exit;
EOSQL`

### Calculate the archive log # to delete ###
arch_to_del=$(($applied_sequence-$logtokeep))

#echo “applied_sequence: ” $applied_sequence
#echo “arch_to_del: “$arch_to_del

if [ -z "$arch_to_del" ]; then
echo “No rows returned from database” >> ${tmpf}
exit 0
fi

#delete old logs – current applied -5
#
rman  << EORMAN >> ${tmpf}
connect target ;
#delete noprompt archivelog all completed before 'SYSDATE-1' ;
delete noprompt archivelog until sequence = $arch_to_del;
exit
EORMAN

echo

find /tmp/$script*.tmp -mtime +30 | xargs /bin/rm -f >> ${tmpf}
du -hs /u04/oradata/TS2PRD/flash_recovery_area/TS2STB/* >>  ${tmpf}

exit

Notes:
columns V$ARCHIVED_LOG.REGISTRAR and APPLIED
If REGISTRAR=’RFS’ and APPLIEDis NO, then the log has arrived at the standby but has not yet been applied.
If REGISTRAR=’RFS’ and APPLIED is YES, the log has arrived and been applied at the standby database.

column V$ARCHIVED_LOG.DELETED
Indicates whether an RMAN DELETE command has physically deleted the archived log file from disk (YES) or not (NO)

RMAN EXPIRED
Removes only files whose status in the repository is EXPIRED.
RMAN marks backups and copies as expired when you run a CROSSCHECK command and the files are absent or inaccessible.
To determine which files are expired, run a LIST EXPIRED command.

RMAN NOPROMPT
Beginning in Oracle9i, RMAN’s default behavior is to prompt for confirmation when you run DELETE EXPIRED.
In prior releases, RMAN did not prompt.
Leave a comment | Trackback







    David Shockey
    August 25th, 2011 at 09:42
    Reply | Quote | #1

    There is one thing missing and a logic error in your script.

    Missing: The vdate variable is not set. May I suggest…
    export vdate=`date +%Y%m%d`

    Logic error: The check for and empty result from the sql query comes after you have altered the variable. The block…

    if [ -z "$arch_to_del" ]; then
    echo “No rows returned from database” >> ${tmpf}
    exit 0
    fi

    …should come before the line…

    arch_to_del=$(($applied_sequence-$logtokeep))

    The way it is now, your if statement will never find an empty variable.

    I found your script to be very useful. We are using a modified version at our site. We have an optional destination for archive logs on our primary servers (log_archive_dest_3) that is used to hold logs until they have been transmitted to the standby. This location is used by the fal process in case there is a break in communication and the mandatory destination logs have already been deleted. I modified your script to look for the and delete logs in our optional destination that have already been transmitted to the standby site.

    Thanks for sharing your work!
