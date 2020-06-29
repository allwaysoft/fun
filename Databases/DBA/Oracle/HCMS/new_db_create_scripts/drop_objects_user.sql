REM --http://docs.oracle.com/cd/A87860_01/doc/appdev.817/a77069/10_dynam.htm
REM cant pass bind arguments to sql while dropping objects

REM https://forums.oracle.com/forums/thread.jspa?threadID=2465596 --FORALL not good for "execute immediate"

SET ECHO OFF
/* 
This script is created from template.sql and below are notes from template.sql. This scripts drops some of the objects in a schema and finally drops the schema.
-----------------
1. This is a template script, which can be copied and used as source to create any user defined scripts to run against DB using sqlplus. 
2. please make the below changes after a copy of this script is made. This script is divided into 4 parts.
	Part-1
        ------
        Template already has a connect_env parameter which will be prompted to run the script. 
	Any additional parameters to be passed to user defined script should go here
	
	Part-2
	------
	MUST MUST MUST change the value 'template.log' to 'xx.log' where xx is thename name of your script
	
	Part-3
	------
	Replace the '<ACTUAL SCRIPT WHICH HAS TO BE EXECUTED>' with the actual script in this part
	
	Part-4
	------
	None to change at this point
3. Lastly, add new comments to this comments section to include user defined comments related the script.
*/

SET VERIFY OFF

---------- Start Part-1 ---------

accept connect_env prompt 'Please enter user credentials to run the script. Example:- DBADMIN/pswd@sid:'
accept user_to_drop prompt 'Please enter the exact user name to be dropped:'

---------- End Part-1   ---------

SET TERMOUT OFF

---------- Start Part 2 ---------

connect &connect_env
column vpath new_value new_vpath
column loc new_value new_loc 
column ext new_value new_ext
select '/u01/app/oracle/admin/scripts/logs_' vpath, SYS_CONTEXT ('USERENV', 'instance_name') loc, '/drop_user.log' ext from dual;  
SPOOL &new_vpath&new_loc&new_ext

---------- End Part-2   ---------

---------- Start Part-3 ---------
--
SET ECHO ON
SET TERMOUT ON
SET TIMING ON
--

--BEGIN
--FOR x IN (select privilege priv from dba_sys_privs where grantee =  upper('&&user_to_drop') union all select granted_role priv from DBA_ROLE_PRIVS where grantee = upper('&&user_to_drop'))
--LOOP
--EXECUTE IMMEDIATE ' REVOKE ' || x.priv || ' FROM ' || upper('&&user_to_drop');
--END LOOP;
--END;
--/
declare
i number := 0;
BEGIN
FOR x IN (select object_name from dba_objects where owner = upper('&&user_to_drop') and object_type in ('INDEX'))
LOOP
EXECUTE IMMEDIATE 'DROP INDEX ' || upper('&&user_to_drop') ||'.' || x.object_name || '  ';
i :=i+1;
if i = 1000
then
dbms_lock.sleep(10);
i :=0;
end if;
END LOOP;

FOR x IN (select object_name from dba_objects where owner = upper('&&user_to_drop') and object_type in ('TABLE'))
LOOP
EXECUTE IMMEDIATE 'DROP TABLE ' || upper('&&user_to_drop') ||'.' || x.object_name || ' CASCADE CONSTRAINTS ';
i :=i+1;
if i = 1000
then
dbms_lock.sleep(10);
i :=0;
end if;
END LOOP;

FOR x IN (select object_name from dba_objects where owner = upper('&&user_to_drop') and object_type in ('VIEW'))
LOOP
EXECUTE IMMEDIATE 'DROP VIEW ' || upper('&&user_to_drop') ||'.' || x.object_name || ' CASCADE CONSTRAINTS ';
i :=i+1;
if i = 1000
then
dbms_lock.sleep(10);
i :=0;
end if;
END LOOP;

EXECUTE IMMEDIATE 'DROP USER ' || upper('&&user_to_drop') ||' CASCADE';

END;
/

--BEGIN
--EXECUTE IMMEDIATE 'DROP USER ' || upper('&&user_to_drop') ||' CASCADE';
--END;
--/

UNDEF user_to_drop

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

/*

declare
----
TYPE cur_ref IS REF CURSOR;
	 cur_var  cur_ref;
----
TYPE ass_arr_type IS TABLE OF VARCHAR2(100)
        INDEX BY binary_integer;
     ass_arr      ass_arr_type;
----	
	 rows     pls_integer :=1000;
	 sql_stmt varchar2(32000);
----	
BEGIN

sql_stmt := 'SELECT object_name FROM dba_objects where owner = upper(''' 
         || '&&user_to_drop'
         || ''' and object_type in ''INDEX''';

OPEN cur_var FOR sql_stmt;			 
LOOP -- the following statement fetches 1000 rows or less in each iteration
-- bulk fetch the list of office locations
fetch cur_var BULK COLLECT INTO ass_arr limit rows;
-- for each location, give a raise to employees with the given 'job'
FORALL i IN ass_arr.first..ass_arr.last 
EXECUTE IMMEDIATE 'DROP INDEX ' || upper('&&user_to_drop') ||'.' || ass_arr(i) || '  ';
END LOOP; 
CLOSE cur_var; 
APEX_COLLECTION.TRUNCATE_COLLECTION(p_collection_name => 'ass_arr');

END;
/

*/