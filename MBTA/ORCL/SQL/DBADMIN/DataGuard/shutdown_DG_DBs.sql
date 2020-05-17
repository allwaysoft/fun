/* ----------From the Docs
9.1.2 Shutting Down a Physical Standby Database

Use the SQL*Plus SHUTDOWN command to stop Redo Apply and shut down a physical standby database. Control is not returned to the session that initiates a database shutdown until shutdown is complete.

If the primary database is up and running, defer the standby destination on the primary database and perform a log switch before shutting down the physical standby database.
*/
 
********-- Follow this if shutdown of only Standby

-> Stop Observer first
	$ dgmgrl -logfile observer.log sys/o11gWasm@hrprd "stop observer"

On Primary and Standby: Check if standby is in sync with primary
	sql> select sequence#, applied from v$archived_log;	

On Primary: defer the parameter log_archive_dest_state_n
	sql> alter system set log_archive_min_succeed_dest=1;
	sql> alter system set log_archive_dest_state_2=DEFER;

On Standby: Sthutdown the Standby
	sql> alter database recover managed standby database cancel;
	SQL> shutdown immediate

***-- To startup Standby follow below.

On Standby: First do the following
	SQL> startup nomount;
	SQL> alter database mount standby database;

On Primary: Enable back the defered parameter on primary
	sql> alter system set log_archive_dest_state_2=ENABLE;
		
On Standby:	Do below to complete the DB startup	
--alter database flashback on;
	SQL> alter database recover managed standby database using current logfile disconnect from session; --check standby controlfile consistant with primary
	SQL> alter database recover managed standby database cancel;
	SQL> alter database open read only;
	SQL> alter database recover managed standby database using current logfile disconnect from session;

On Primary: Now switch the log file on primary and see if everything looks fine.
	SQL> alter system switch lgofile;

On Both: Check if log is shipped and applied properly
    SQL> select sequence#, applied from v$archived_log;	
	
	
	
********-- Follow this if shutdown of both primary and Standby

-> Stop Observer first
	$ dgmgrl -logfile observer.log sys/o11gWasm@hrprd "stop observer"

Both Primary and Standby: Check if standby is in sync with primary
	sql> select sequence#, applied from v$archived_log;	
 
On Primary: Defer the parameter log_archive_dest_state on the primary db:
	SQL> alter system set log_archive_min_succeed_dest=1;
	SQL> alter system set log_archive_dest_state_3=DEFER;
	SQL> alter system switch logfile;
	SQL> shutdown immediate

On Standby: Now cancel the MRP process on the standby db using the following command:
	sql> alter database recover managed standby database cancel;
	sql> shutdown immediate;


***-- To startup Standby and primary follow below.
On Standby: irst mount the standby db...
	SQL> startup nomount;
	SQL> alter database mount standby database;


On Primary: Now start the primary database and enable the log_archive_dest_state parameter
	SQL> startup
	SQL> alter system set log_archive_dest_state_2=ENABLE;
	SQL> alter system set log_archive_min_succeed_dest=2;


On Standby: Now start the standby DB
	SQL> alter database recover managed standby database using current logfile disconnect from session; --check standby controlfile consistant with primary
	SQL> alter database recover managed standby database cancel;
	SQL> alter database open read only;
	SQL> alter database recover managed standby database using current logfile disconnect from session;

On Primary: Now switch the log file on primary and see if everything looks fine.
	SQL> alter system switch logfile;

On Both: Check if log is shipped and applied properly
    SQL> select sequence#, applied from v$archived_log;

-> Start Observer back
-- This should be done from the subdirectories of the scripts directory where the startobserver script lives
	$ nohup ./startobserver &	