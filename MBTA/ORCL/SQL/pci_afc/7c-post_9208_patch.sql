SHUTDOWN IMMEDIATE;
--
--
--
--
--
accept x prompt 'Next step: start DB in migrate mode, run the catpatch.sql script.. press enter'
--
--
--
--
--
STARTUP MIGRATE pfile='D:\NWCD\Scripte\initNWCD.ora';
--startup migrate pfile = 'C:\oracle\ora92\database\initNWCD.ora';
SPOOL C:\oracle\scripts\logs_nwcd\patch.log
@%ORACLE_HOME%\rdbms\admin\catpatch.sql
SPOOL OFF
SHUTDOWN IMMEDIATE;
--
--
--
--
--
accept x prompt 'Next step: start DB in normal mode and run the utlprc.sql script.. press enter'
--
--
--
--
--
STARTUP pfile='D:\NWCD\Scripte\initNWCD.ora'
--startup pfile = 'C:\oracle\ora92\database\initNWCD.ora';
SPOOL C:\oracle\scripts\logs_nwcd\utlprc.log
@%ORACLE_HOME%\rdbms\admin\utlrp.sql
--
--
--
--
--
accept x prompt 'Next step: Checking for Banner, Output below should show 9.2.0.8 ... press enter'
--
--
--
--
--
select * from v$version;
--@@7c-9208_patch_proof.sql
SPOOL OFF
exit;

