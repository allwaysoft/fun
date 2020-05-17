
SET ECHO OFF

/* 
1. This is a template script, which can be copied and used as source to create any user defined scripts to run against DB using sqlplus. 
2. please make the below changes after a copy of this script is made. This script is divided into 4 parts.
	Part-1
        ------
        Template already has a connect_env parameter which will be prompted to run the script. 
	Any additional parameters to be passed to user defined script should go here
	
	Part-2
	------
	MUST MUST MUST change the value 'template.log' to 'xx.log' where xx is the name of the script to be run
	
	Part-3
	------
	Replace the '<ACTUAL SCRIPT WHICH HAS TO BE EXECUTED>' with the actual script in this part
	
	Part-4
	------
	None to change at this point
3. Lastly, add new comments to this comments section to include user defined comments related the script.

----------
This script to enable auto maintenance tasks in Database.
----------

*/

SET VERIFY OFF

---------- Start Part-1 ---------

accept connect_env prompt 'Please enter user credentials to run the script. Example:- DBADMIN/pswd@sid:'

---------- End Part-1   ---------

SET TERMOUT OFF

---------- Start Part 2 ---------

connect &connect_env
column vpath new_value new_vpath
column loc new_value new_loc 
column ext new_value new_ext
select '/u01/app/oracle/admin/scripts/logs_' vpath, SYS_CONTEXT ('USERENV', 'instance_name') loc, '/enable_autotasks.log' ext from dual;  
SPOOL &new_vpath&new_loc&new_ext

---------- End Part-2   ---------

---------- Start Part-3 ---------
--
SET ECHO ON
SET TERMOUT ON
SET TIMING ON
--

BEGIN
DBMS_AUTO_TASK_ADMIN.ENABLE(
client_name => 'auto optimizer stats collection',
operation => NULL,
window_name => NULL);
END;
/

BEGIN
DBMS_AUTO_TASK_ADMIN.ENABLE(
client_name => 'auto space advisor',
operation => NULL,
window_name => NULL);
END;
/

-- Below can be used only if we have tuning packs, seperate license.
--BEGIN
--DBMS_AUTO_TASK_ADMIN.ENABLE(
--client_name => 'sql tuning advisor',
--operation => NULL,
--window_name => NULL);
--END;
--/

-- Below is to turn OFF the histograms on columns. According to peoplesoft red papaer, Oracle DB with peoplesoft applicatoin doesn't need histograms on columns and this setting is turned on by default in oracle.

exec DBMS_STATS.SET_SCHEMA_PREFS('SYSADM', 'METHOD_OPT','FOR ALL INDEXED COLUMNS SIZE 1'); --SYSADM schema no histograms are necessary according to the peoplesoft red papaer.
exec dbms_stats.SET_GLOBAL_PREFS('DEGREE', 'DBMS_STATS.DEFAULT_DEGREE');
exec dbms_stats.SET_GLOBAL_PREFS('STALE_PERCENT', 1); -- This is to make the stats run on tables, even if there is a small change in data.

--exec dbms_stats.SET_DATABASE_PREFS('METHOD_OPT', 'FOR ALL COLUMNS SIZE AUTO') this is default.
--exec dbms_stats.SET_DATABASE_PREFS('METHOD_OPT', 'FOR ALL INDEXED COLUMNS SIZE 1'); 
-- above procedure chnges the value for existing objects only in the DB

--exec dbms_stats.SET_GLOBAL_PREFS('METHOD_OPT', 'FOR ALL COLUMNS SIZE AUTO') this is default.
--exec dbms_stats.SET_GLOBAL_PREFS('METHOD_OPT', 'FOR ALL INDEXED COLUMNS SIZE 1'); 
-- above procedure changes the value for new objects and at global level.

--
SET ECHO OFF
SPOOL OFF
SET TIMING OFF
--
---------- End Part-3   ---------

---------- Start Part-4 ---------

SET VERIFY ON
PROMPT Log is generated at &new_vpath&new_loc&new_ext

---------- End Part-4   ---------