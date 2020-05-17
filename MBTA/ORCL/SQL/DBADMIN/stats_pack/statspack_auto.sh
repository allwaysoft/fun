#!/sbin/sh

#--------------------------------------------------------------------------
#
# Do not change the location of this script, there is a cronjob set on this.
#
# This script is applicable for users of StatsPack and want to 
# automate generation of statspack reports in a logical manner.
# Script will loop thru the stats$snapshot for anything greater
# than sysdate-1 and generate compressed 
# reports in the DDMM_StartTimeInHH24MI_EndTimeInHH24MI format
#
# This script also deletes snapshots older than DAYSDEL(varibale in this script) 
# days from the database.
#
# This scrip uses MBTA_sppurge.sql for the deletion of old snapshots,  
# MBTA_sppurge.sql is modified version of sppurge.sql which will get the snap ids to be
# delete automatically.
#
# Setup
#      1. Ensure that the sppurge.sql & spreport.sql are present in $STATSDIR
#      2. Change the STATSDIR/STATSREP/DBMS_UID/DBMS_PWD as required
#      3. Alter the sppurge.sql script to remove the undef for lo/hisnapid
#      4. Run the script (no arguments)
#---------------------------------------------------------------------------

# ----------  Change the values below as required

# <--------------------------------------------------

#. ~/.profile

#setting varibales for Oracle Home
. /home/oracle/setenv/setorcle11GR2 hrprd

# Directory where this script resides
STATSDIR=/u01/app/oracle/admin/scripts/dbadmin/statspack

# Directory where the reports are created
STATSREP=/u01/app/oracle/admin/scripts/logs_hrprd/statspack

# Number of days. Reports will be generated for snaps older than the number of days given below. And then older snaps will be deleted from the Database
DAYSDEL=30

# Other variables
DBMS_UID=perfstat
DBMS_PWD=STATSPACK4P
DBMS_INST=HRPRDAB
SQLSCRIPTFILE=/u01/app/oracle/admin/scripts/dbadmin/statspack/snap.sql
MBTA_SPPURGEFILE=/u01/app/oracle/admin/scripts/dbadmin/statspack/mbta_sppurge.sql

# -------------------------------------------------->

# ---------- Start of program

cd $STATSDIR
mkdir -p $STATSREP

rm  $SQLSCRIPTFILE
echo "Generating reports in $STATSREP ... Pls wait ..."
sqlplus -s > /dev/null <<!
$DBMS_UID/$DBMS_PWD@$DBMS_INST

set serveroutput on size 1000000
set feed off term off trims on linesize 300
spool $SQLSCRIPTFILE
declare 
    min_snap number;
	prev_snap number;
    next_snap number;
	p_db_strt_time date;
	n_db_strt_time date;
    min_snap_time varchar2(20);
    next_snap_time varchar2(20);
    fileName varchar2(255);
    cursor c1 is select snap_id, to_char(snap_time,'ddmm_hh24mi') snap_time
	      , startup_time
            from stats\$snapshot
            where snap_time  < sysdate-$DAYSDEL -- produce reps for snaps older than sysdate-DAYSDEL.
			order by snap_id;
    c1_rec c1%rowtype;

begin
    for c1_rec in c1 loop
        select nvl(min(snap_id),-999), nvl(min(startup_time), sysdate+999) into next_snap, n_db_strt_time from stats\$snapshot where snap_id > c1_rec.snap_id;
		
            if next_snap = -999
            then 
            exit;
            end if;
			
			continue when c1_rec.startup_time <> n_db_strt_time;
		
        select to_char(snap_time,'hh24mi') into next_snap_time from stats\$snapshot where snap_id = next_snap;
        
        fileName := '$STATSREP'||'/'||'sp_'||c1_rec.snap_time||'_'||next_snap_time||'.rpt';

        -- Following for generating the reports

        dbms_output.put_line('define begin_snap='||c1_rec.snap_id);
        dbms_output.put_line('define end_snap='||next_snap);
        dbms_output.put_line('define report_name='||fileName);
        dbms_output.put_line('@$ORACLE_HOME/rdbms/admin/spreport.sql');

			-- Following for Purging

			--dbms_output.put_line('define losnapid='||c1_rec.snap_id);
			--dbms_output.put_line('define hisnapid='||c1_rec.snap_id);

        -- Compress the reports

        --dbms_output.put_line('host gzip '||fileName); 
		--since done from sqlplus, "host" is needed here.
    end loop;
		--dbms_output.put_line('host gzip ' ||'$STATSREP'||'/*.rpt');
	    dbms_output.put_line('@$MBTA_SPPURGEFILE $DAYSDEL'); 
	    dbms_output.put_line('commit;');	
exception
    when no_data_found then
        -- Only last snap remaining
        null;
    when others then
        dbms_output.put_line(sqlerrm);
end;
/
spool off
!

gzip /u01/app/oracle/admin/scripts/logs_hrprd/statspack/*.rpt
chmod 775 $SQLSCRIPTFILE

sqlplus -s > /dev/null <<!
$DBMS_UID/$DBMS_PWD
        @$SQLSCRIPTFILE
!