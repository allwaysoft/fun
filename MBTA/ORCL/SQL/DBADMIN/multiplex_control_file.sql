https://forums.oracle.com/forums/thread.jspa?threadID=498592&start=0&tstart=0

****************** Followed the below procedure.
We executed this procedure to multiplex our controlfiles on ASM.

Tested on 11gR1 11.1.0.6 RAC on ASM, very clean:

There was only one controlfile:
+DG01/database/controlfile/current.260.660142191

1) shutdown database on all nodes; ensure no instance is mounting the database
2) startup nomount one instance
3) rman target /
4) RMAN> backup current controlfile;
5) set dbid=1234567 (i.e whatever your database dbid is, this is an example)
RMAN> restore controlfile to '+DGFR' from '+DG01/database/controlfile/current.260.660142191';

NOTE: This will restore a controlfile to the respective directory without creating a symlink.
Check the newly created controlfilename in the directory and edit and set control_file parameter
accordingly in step 6.

6) alter system set control_files='+DG01/database/controlfile/current.260.660142191',
'+DGFR/database/controlfile/current.374.660394089' scope=spfile sid='*';
check your ASM disk targets... this is only a example

7) shutdown (immediate)

8) startup or use srvctl start database -d <database name> commands 
****************************** 
 





create directory TEMPDIR1 as '+hrdevdata/hrdev/controlfile';
create directory TEMPDIR2 as '+hrdevfra/hrdev/controlfile';

+HRDEVDATA/hrdev/controlfile/backup.256.762461623


BEGIN
DBMS_FILE_TRANSFER.COPY_FILE('TEMPDIR1','backup.256.762461623', 'TEMPDIR2', 'Current');
END;
/


+hrdevdata/hrdev/controlfile/backup.256.762461623



alter system set control_files='+hrdevfra/hrdev/controlfile/current.666.770656339', '+hrdevdata/hrdev/controlfile/current.262.770656441' scope=spfile sid='hrdev';


alter system set control_files='+HRTSTDATA/hrtst/controlfile/current.260.763774485', '+HRTSTFRA/hrtst/controlfile/current.1374.770659319' scope=spfile sid='hrtst';





