http://damir-vadas.blogspot.com/2010/02/how-to-find-correct-scn.html
-- great examples on how to find the scn. the last example in above link is awesome for finding the scn of a backup.

How to find exact SCN Number for Oracle Restore
Posted by goldparrot · May 16, 2011	· Leave a Comment

The following was written by myself and published for the 2011 Oracle Open World Tips and Tricks guide.

TIP: How to find the SCN POINT to safely restore a database for a point-in-time recovery
-----------------------------------------------------------------------------------------

I often get called in to assist in point-in-time recoveries where the dba keeps getting
errors on "alter database open resetlogs;".

This error condition can be hard to fix without another full restore, if we already rolled forward too
much, beyond where we intended and easy to NEVER EVER hit those errors again.

A successful recovery must begin with just a little bit of preperation to know your SCN number
that you would like to use to roll the database forward to the point in time needed.

Whether I am just doing disaster recovery testing, cloning, creation of a standby or in an actual
disaster, I use the following TIPS and recipe below.

1) Prepare and startup mount your instance.

   * Prepare your restore db by setting up your pfile, data directories, flash area, 
   and physical nature of your database.

   * Prepare your pfile and make sure your db_name and db_unique_name are set appropriate.
	db_name=yourdbname
	db_unique_name=instance
	
   * startup nomount the database;
   
   * restore the controlfile
	If your current production is available, just create a new controlfile using alter database,
	or use rman with an autobackup controlfile, or catalog.
	

2) Now that you have a controlfile mounted, you can query the latest backup details, archivelog details and
find the exact SCN to use in your recovery script.
These preperation steps will allow you to ALWAYS open a db resetlogs WITHOUT Error.

TIP:
	1) Never use: "set until time" for your recovery needs.
	   Always use: "set until scn" for your recovery needs.
	   
	   The "time" portion is a great feature, but problematic and last I 
	   read, oracle only guarantees a 5 minute window closest to your time.
	   
	   The SCN is exact and works if you do the preperation steps below.
	   
	2) Get the greatest of either absolute_fuzzy_change# or checkpoint_change# for your datafile backups.
	
		The quickest way to roll forward just beyond the backup to open resetlogs is
		to query v$backup_datafile.
		You then just need to choose the greatest of either the absolute_fuzzy_change# or checkpoint_change#
		for your backupset.
		
		You can modify the query to your liking, and even add in many details from stamp and recid, but below
		gets the job done quickly.  Just choose the day in which your level0 or level1 completed and modify appropriately.
	
		        =============================================
	`		col fuzz# format 99999999999999999999999999		
	`		col chkpnt# format 99999999999999999999999999		

		        select max(absolute_fuzzy_change#) fuzz#, max(checkpoint_change#) chkpnt# from
			(select file#, completion_time, checkpoint_change#, absolute_fuzzy_change# from v$backup_datafile
			where incremental_level = 0
			and trunc(completion_time) = to_date('JUN-20-2010','MON-DD-YYYY')
			and file# <> 0
			order by completion_time desc
		        );
		        ===============================================

		This will return 2 SCN numbers. Pick the greatest of the 2.
		
				      FUZZ#  		     CHKPNT#
		       --------------------	--------------------
				23138984359		 23138974759
		
		2a) Feel free to correlate this with information directly from an rman "list backup".
			rman target /
				spool log to list_backup.log;
				list backup;
				exit;
				
			Edit list_backup.log and search for checkpoint change# (chkpnt#) you need.  
			You should see your SCN provided.
			
			This should be the last checkpoint_change# for your backupset that your
			interested in.
		
                
	3) Or, since checkpoints occur at every log switch, you can then choose an SCN from the exact 
	   	log switch closest to your recovery needs.
		
			 ============================================================
			 col next_change# format 999999999999999;
			 col first_change# format 999999999999999;

			 select sequence#, to_date(first_time,'DD-MON-YYYY HH24:MI:SS') first_time, 
						  first_change#, 
						  to_date(next_time,'DD-MON-YYYY HH24:MI:SS') next_time, 
						  next_change# from v$archived_log
			 where completion_time between to_date('JUN-22-2010','MON-DD-YYYY') and Sysdate
			 ;
			 ============================================================
  
  		
  	4) Or, if the EXACT SCN prior to crash, or logical errors is needed, use LogMiner.
  	
  		To get closest, or exactly to your recovery needs, get the scn's from the archived logs
  		between the point in time that you need to restore to and mine the log itself (from step above).
  		
  		I suggest copying the archived log in question to /tmp or somewhere you can keep it.
  		Setup logminer and then query it using the following, replacing the scn's from your query above.
  		
 		Pick times that are as close as you can get to the errors that you need to avoid.
 		
			=======================================
			BEGIN
			    DBMS_LOGMNR.add_logfile (
			    options     => DBMS_LOGMNR.new,
			    logfilename => '/tmp/a55050.arc');
			END;
			/

			BEGIN
			  DBMS_LOGMNR.start_logmnr (
			    starttime => to_date('10-MAR-2010 18:50:00','DD-MON-YYYY HH24:MI:SS'),
			    endtime => to_date('10-MAR-2010 19:05:00','DD-MON-YYYY HH24:MI:SS'),
			    options => Dbms_Logmnr.DDL_Dict_Tracking);
			END;
			/

			=======================================
		 	
		Now Query the log, looking for your errors.
		You can make multiple runs of this, narrowing or expanding your search as needed.
  		
			=======================================
			SELECT scn, to_char(timestamp,'DD-MON-YYYY HH24:MI:SS') timest, operation, sql_redo FROM   v$logmnr_contents
			where scn between  21822207692 and 21822211410
			order by scn;
			=======================================
			
			You can look for, grep, search, find the operation in question.
			Then choose that EXACT SCN to roll forward to.
			You will want to subtract 1 from the result.


Finally:
5) Create your restore script using the found SCN#.

	Once you have chosen the SCN number, the rest is academic:
		rman->
			run {
		 	     set until scn=23138974759;
			     restore database;
			     recover database;
			}
		
	Don't forget to add "set newnames" or channel allocations if needed.
	
And thats it.

If you follow these simple preperation steps, you will ALWAYS be able to "alter database open resetlogs"
without error.
