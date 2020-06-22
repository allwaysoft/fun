@%ORACLE_HOME%\bundle\Patch30\catcpu.sql
--
@%ORACLE_HOME%\rdbms\admin\utlrp.sql
--
@%ORACLE_HOME%\bundle\view_recompile\recompile_precheck_jan2008cpu.sql
--
SHUTDOWN IMMEDIATE;
--
--
--
--
--
accept x prompt 'Next step: start DB in migrate mode and run the view_recompile_jan2008cpu.sql script.. press enter'
--
--
--
--
--
STARTUP MIGRATE pfile='D:\NWCD\Scripte\initNWCD.ora';
--startup migrate pfile = 'C:\oracle\ora92\database\initNWCD.ora';
--
@%ORACLE_HOME%\bundle\view_recompile\view_recompile_jan2008cpu.sql
--
SHUTDOWN IMMEDIATE;
--
--
--
--
--
accept x prompt 'Next step: start DB in normal mode, run the utlrp.sql script and recompile MBTA Mviews.. press enter'
--
--
--
--
--
STARTUP pfile='D:\NWCD\Scripte\initNWCD.ora'
--startup pfile = 'C:\oracle\ora92\database\initNWCD.ora';
--
@%ORACLE_HOME%\rdbms\admin\utlrp.sql
--
@@8d-recomp_mbta_miews.sql
--
exit;




