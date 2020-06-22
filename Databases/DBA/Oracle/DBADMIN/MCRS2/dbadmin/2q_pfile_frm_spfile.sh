#!/sbin/sh
if [ $# = 1 ]
then
        db=$1
        shift
else
        echo "please enter value for database sid:"
        read db
        echo $db
fi

cd $SETENV
. ./setorcle11GR2 $db

cd $ORACLE_BASE/admin/$ORACLE_SID/pfile

pfileloc=$ORACLE_BASE/admin/$ORACLE_SID/pfile/init$db.ora

#pfileloc=$ORACLE_HOME/dbs/init$db.ora
#can't use above as the pfile at above location point to asm spile and we don't want to overwrite that pfile.

mv init$ORACLE_SID.ora init$ORACLE_SID.ora.`date +"%m_%d_%y_%R:%S"`

sqlplus / as sysdba <<EOFSQL

create pfile='$pfileloc' from spfile;

exit

EOFSQL

echo "pfile is created at location "$pfileloc