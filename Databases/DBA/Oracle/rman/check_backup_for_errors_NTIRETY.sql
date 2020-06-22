These scripts are from NTIRETY

SQL> select v$backup_datafile.recid, v$backup_datafile.stamp, 
SQL> v$backup_datafile.file#, v$backup_datafile.incremental_level,
  2          v$backup_datafile.creation_change#, v$backup_datafile.checkpoint_change#, v$backup_datafile.incremental_change#,
  3          v$backup_datafile.completion_time, v$datafile.name
  4  from v$backup_datafile, v$datafile
  5  where v$backup_datafile.set_stamp='774669643'
  6  and v$backup_datafile.set_count='12888'
  7  and v$backup_datafile.file#=v$datafile.file# (+)
  8  ;

no rows selected

SQL> 
SQL> select v$backup_datafile.recid, v$backup_datafile.stamp, 
SQL> v$backup_datafile.file#, v$backup_datafile.incremental_level,
  2          v$backup_datafile.creation_change#, v$backup_datafile.checkpoint_change#, v$backup_datafile.incremental_change#,
  3          v$backup_datafile.completion_time, v$datafile.name
  4  from v$backup_datafile, v$datafile
  5  where v$backup_datafile.set_stamp=774669643
  6  and v$backup_datafile.set_count=12888
  7  and v$backup_datafile.file#=v$datafile.file# (+)
  8  ;
