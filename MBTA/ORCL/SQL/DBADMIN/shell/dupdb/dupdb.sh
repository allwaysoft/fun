#!/sbin/sh

function execprc              # this function has the script to perform the duplicate.
{
date

#export ORACLE_SID=$targetdb

#echo ""
#echo "Next step, Check if there is a valid backup available, which can be used for duplication process"
#echo ""
#read prompt?'Press any key to continue....'

#rman target sys/${dbsyspass}@${targetdb} catalog rman/${emgcrpswd}@emgcr   <<EOFRMAN

#RESTORE DATABASE VALIDATE;
#RESTORE ARCHIVELOG ALL VALIDATE;

#EOFRMAN


export ORACLE_SID=$duplicatedb

echo ""
echo "Next step, deleteing all the backups of DB being duplicated. Also unregister it from catalog. Proceed only if the validate above Succeeded"
echo ""
read prompt?'Press any key to continue....'

rman target / catalog rman/${emgcrpswd}@emgcr   <<EOFRMAN1

DELETE NOPROMPT BACKUP;
UNREGISTER DATABASE NOPROMPT;

EOFRMAN1

echo ""
echo "Next step, generate drop script for data files, temp files and log files of the DB being duplicated"
echo ""
read prompt?'Press any key to continue....'

sqlplus '/ as sysdba' <<EOFSQL1

@generate_ddl.sql

shutdown immediate;
startup nomount;
exit;

EOFSQL1


chmod 700 dropdbf.sql

dataloc=${duplicatedb}data
fraloc=${duplicatedb}fra

echo ""
echo "Next step, run the scipt generated in the above step to drop data files, temp files and log files of the DB being duplicated"
echo ""
read prompt?'Press any key to continue....'

sqlplus  sys/${asmpswd}@+ASM as sysdba @dropdbf.sql $dataloc $fraloc $duplicatedb <<EOFSQL2
exit;
EOFSQL2

echo ""
echo "Next step, generate script to drop any other files in ASM disks, except PARAMETER and CONTROL files"
echo ""
read prompt?'Press any key to continue....'

#sqlplus  sys/${asmpswd}@+ASM as sysdba @generate_ddl2.sql $dataloc $fraloc $duplicatedb <<EOFSQL3
sqlplus  sys/${asmpswd}@+ASM as sysdba @generate_ddl2.sql $dataloc $fraloc <<EOFSQL3
exit;
EOFSQL3

chmod 700 dropasmfiles.sql

echo ""
echo "Next step, run the scipt generated in the above step to drop any other files in ASM disks, except PARAMETER and CONTROL files"
echo ""
read prompt?'Press any key to continue....'

sqlplus  sys/${asmpswd}@+ASM as sysdba @dropasmfiles.sql $dataloc $fraloc $duplicatedb <<EOFSQL4
exit;
EOFSQL4


#rm dropdbf.sql
#rm dropasmfiles.sql
echo ""
echo "Next step, duplicating database........"
echo ""
read prompt?'Press any key to continue....'

rman auxiliary / catalog rman/${emgcrpswd}@emgcr using $duplicatedb $targetdb <<EOFRMAN2
run
{
allocate channel t1 type 'sbt_tape';
allocate channel t2 type 'sbt_tape';
allocate channel t3 type 'sbt_tape';
allocate channel t4 type 'sbt_tape';
duplicate database &2 to &1;
}
exit;
EOFRMAN2



echo ""
echo "Next step, Have the DB in archive log mode or not. This part is not developed yet"
echo ""
read prompt?'Press any key to continue....'



echo ""
echo "Next step, Drop and recreate statspack."
echo ""
read prompt?'Press any key to continue....'



echo ""
echo "Next step, register the duplicated database in catalog along with RMAN configuration"
echo ""
read prompt?'Press any key to continue....'


#Register DB with rman catalog and configure parameters; 
#
#Check the below line, add a parameter to "9breg..." shell, now we have to pass 3 PARAMETERS to below script
#
./u01/app/oracle/admin/scripts/dbadmin/9bregister_new_db_catalog.sh $duplicatedb $emgcrpswd


#CONFIGURE RETENTION POLICY TO REDUNDANCY 1; 
#rman target / catalog rman/${emgcrpswd}@emgcr using $duplicatedb <<EOFRMAN3
#register database;
#CONFIGURE CONTROLFILE AUTOBACKUP ON;
#CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 35 DAYS;  
#CONFIGURE DEFAULT DEVICE TYPE TO DISK; 
#CONFIGURE ARCHIVELOG DELETION POLICY TO NONE;
#CONFIGURE DEVICE TYPE DISK PARALLELISM 4 BACKUP TYPE TO COMPRESSED BACKUPSET;
#CONFIGURE COMPRESSION ALGORITHM 'BASIC';
#CONFIGURE CHANNEL DEVICE TYPE DISK FORMAT '+&1fra/&1/backupset/df_%d_%T_%s_%p';
#CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO '+&1fra/&1/backupset/ctl_%d_%F';
#exit;
#EOFRMAN3


echo ""
echo "Next step, create pfile from spfile"
echo ""
read prompt?'Press any key to continue....'

/u01/app/oracle/admin/scripts/dbadmin/2q_pfile_frm_spfile.sh $duplicatedb

date

}

function runsh 
{
clear
echo "\nPlease enter value for an existing database sid which has to be duplicated:"
typeset -l duplicatedb 		# this command converts the value in the duplicatedb variable to lowercase, use -u for uppercase
read duplicatedb

echo "\nDatabase to be duplicated is "$duplicatedb

echo "\n"$duplicatedb" has to be duplicated from the backup of which database? Please enter sid:"
typeset -l targetdb
read targetdb

echo "\nThis script needs connection to +ASM instance as sysdba. Please enter password for +ASM instance:"
stty -echo                     #this disables the value entered by the user for ASM from displaying on the screen
read asmpswd
stty echo                      #this enables display back on

echo "\nThis script needs to connection as sysdba to DB FROM which we need to duplicate. Please enter password:"
stty -echo                     #this disables the value entered by the user for sys from displaying on the screen
read dbsyspass
stty echo                      #this enables display back on


echo "\nThis script needs connection to the catalog emgcr database as rman user. Please enter rman password for emgcr:"
stty -echo                     
read emgcrpswd
stty echo

echo "\n"$duplicatedb" will be duplicated from the most recent backup of "$targetdb" Continue? y or n: "
typeset -l contproc            
read contproc

if [ $contproc = "y" ]  
then

cd $SETENV
. ./setorcle11GR2 $duplicatedb

cd $ORACLE_BASE/admin/scripts/dbadmin/shell/dupdb


	if [ $duplicatedb = "hrprd" ]  
	then
	echo "\nPRODUCTION HR DATA FILES will be DELETED and recreated from "$targetdb ". Do you want to continue?? y or n:"
	typeset -l contprocifprd         
	read contprocifprd
		if [ $contprocifprd = "y" ]  
		then	
		execprc | tee $ORACLE_BASE/admin/scripts/logs_$duplicatedb/dupdb_`date +"%m_%d_%y-%H.%M.%S"`.sh.log                            #call to the function
		echo "\nLog file is generated at: " $ORACLE_BASE/admin/scripts/logs_$duplicatedb/dupdb_`date +"%m_%d_%y-%H.%M.%S"`.sh.log"\n"
		else
		echo "User entered n for a PRODUCTION refresh. Exited out of script."	
		fi
        else
	execprc | tee $ORACLE_BASE/admin/scripts/logs_$duplicatedb/dupdb_`date +"%m_%d_%y-%H.%M.%S"`.sh.log                                    #call to the function
	echo ""
	echo "End of script"
	echo ""
	read prompt?'Press any key to continue....'	
	echo "\nLog file is generated at: " $ORACLE_BASE/admin/scripts/logs_$duplicatedb/dupdb_`date +"%m_%d_%y-%H.%M.%S"`.sh.log"\n"
	
	
	fi

else
echo "user entered n, exited out of script."
fi

}

runsh
