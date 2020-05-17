select * from v$logfile

select * from v$log 

Select * from v$controlfile_record_section
where type ='REDO LOG'


--increase the size of the redolog files. This can be done only by creating new and dropping the old.Should be done as sysdba
http://mrrame.blogspot.com/2008/09/oracle-how-to-increase-redo-log-size.html

Alter database add logfile group 4 ('+HRTSTDATA','+HRTSTFRA') size 250M reuse;

Alter database add logfile group 5 ('+HRTSTDATA','+HRTSTFRA') size 250M reuse;

Alter database add logfile group 6 ('+HRTSTDATA','+HRTSTFRA') size 250M reuse;

Alter system switch logfile;

Alter system switch logfile;

Alter system switch logfile;    --Switch log file only three times if there are only three groups, the default

Alter system checkpoint;

Alter database drop logfile group 1;

Alter database drop logfile group 2;

Alter database drop logfile group 3;