--***************************** HOW TO FORCE A BETTER PLAN ON SQL-----USING SQL PLAN MANAGEMENT*************************
http://intermediatesql.com/oracle/oracle-11g-sql-plan-management-the-dark-side-of-spm-part-4/
http://orastory.wordpress.com/2007/04/26/are-my-stored-outlines-being-used-why-not/
http://www.oracle.com/technetwork/issue-archive/2009/09-mar/o29spm-092092.html
Peoplesoft redpaper in "New Oracle Insall" documents folder of my machine has a working example on this whole procedre.

/*
******************* -- Multiple executions plans for a sql statement

https://forums.oracle.com/forums/thread.jspa?messageID=2811410

Since you're already on 10.2 you can identify the actual execution plan by checking in V$SESSION the SQL_ID 
and SQL_CHILD_NUMBER column. This can be used to identify the plan in 
V$SQL_PLAN (columns SQL_ID and CHILD_NUMBER) resp. in 10g you can use the convenient 
DBMS_XPLAN.DISPLAY_CURSOR function to obtain the actual plan information using those two parameters.

Regards,
Randolf
*/
--****** If parameters are used in the original SQL, even the SQL with hints should have parameters. 
--****** SQL with hints should be EXACTLY(even the bind variables) same as the original exception for the HINTS
--1. Find the sql_id, plan_hash_value of the SQL to be tuned with the below statements. Keep those values. 
--If there are more than one record returned for the below query/s then the one record which is executed latest has to be picked. 

SELECT sql_id, sql_fulltext, PLAN_HASH_VALUE, first_load_time,PARSE_CALLS ,EXECUTIONS ,USERS_EXECUTING, sql_text 
FROM V$SQL 
WHERE SQL_TEXT LIKE 'SELECT DISTINCT B.BUSINESS_UNIT, B.DEPTID, A.EMPLID, D.NAME_PSFORMAT, D.SEX, TO_CHAR(D.BIRTHDATE,%'
order by first_load_time desc, sql_text asc

select * 
from v$sql 
WHERE SQL_TEXT LIKE 'SELECT DISTINCT B.BUSINESS_UNIT, B.DEPTID, A.EMPLID, D.NAME_PSFORMAT, D.SEX, TO_CHAR(D.BIRTHDATE,%' 
order by first_load_time desc, sql_text asc


sqlid          plan_hash_value
5xcdkk0k5jcr6  588955105     --parms
------------

/*
-------------------------------------------------------------------------------------------------------------
-- This is optional informative step only. This will retrive the exection plan of SQL, using SQLID from above
-------------------------------------------------------------------------------------------------------------
--http://robertgfreeman.blogspot.com/2007/07/10g-new-feature-get-yer-execution-plan.html

select * from table(dbms_xplan.display_cursor('88647kpghcx13',0))

*/
--2. Create a baseline for the original query by using the sqlid obtained from above step as shown below.****execute below in sqlplus

Variable cnt number;
EXECUTE :cnt :=SYS.DBMS_SPM.LOAD_PLANS_FROM_CURSOR_CACHE(sql_id=>'5xcdkk0k5jcr6');
------------

--3. Find the sql_handle, plan_name from the below query. We are going to disable this plan baseline as this is the bad plan which optimizer is choosing and taking more time to execute.

SELECT sql_handle, sql_text, plan_name, enabled, accepted 
from dba_sql_plan_baselines 
WHERE SQL_TEXT LIKE '%SELECT DISTINCT B.BUSINESS_UNIT, B.DEPTID, A.EMPLID, D.NAME_PSFORMAT, D.SEX, TO_CHAR(D.BIRTHDATE,%'

sql_handle
SQL_7c82198ed58d2805

plan_name
SQL_PLAN_7t0htjvasua05161a4b4a
SQL_PLAN_7t0htjvasua05f9b84271

------------

--4. Disable the plan obtained in the above step as shown below. 

variable cnt number;
exec :cnt :=DBMS_SPM.ALTER_SQL_PLAN_BASELINE(SQL_HANDLE => 'SQL_7c82198ed58d2805',PLAN_NAME => 'SQL_PLAN_7t0htjvasua05161a4b4a',ATTRIBUTE_NAME => 'enabled',ATTRIBUTE_VALUE => 'NO');
------------

--5. Get the SQL ID and plan_hash_value of the SQL with HINTS, which performs better, by using below statement.

SELECT SQL_ID, PLAN_HASH_VALUE, SQL_TEXT, sql_fulltext FROM V$SQL WHERE SQL_TEXT LIKE '%SELECT /*+ INDEX(C.A PS2JOB) */ K.BUSINESS_UNIT, K.DEPTID%'

sql_id           plan_hash_value
0nnf65kjtm91k    647909654  --parms
------------

--6. Use below to force the good plan to the original sql. SQL_Id, plan_hash_value below are from step 5. sql_handle is from step 3.

exec :cnt:=sys.dbms_spm.load_plans_from_cursor_cache(sql_id => '0nnf65kjtm91k',plan_hash_value => 647909654,sql_handle => 'SQL_7c82198ed58d2805');

------------------------------------------------------ END END END ---------------------------------------------------------

-- Check if the new plan is used by the original sql, sql_id is the sql_id from step 1.
-- Below query shows two columns, sql_plan_base_line and outline_category. 
-- If from the above steps, plan new plan was accepted by optimizer, sql_plan_base_line for the below query will have a new value.

select sql_id, SQL_PLAN_BASELINE, outline_category, sql_text from V$SQL where SQL_ID in ('9a2fd07109236')


-- Drop a baseline for a sql.the sql_handle, plan_values below can be obtained from dba_sql_plan_baselines 

Variable cnt number;
EXECUTE :cnt :=SYS.dbms_spm.drop_sql_plan_baseline(sql_handle=>'SQL_7c82198ed58d2805',plan_name=>'SQL_PLAN_7t0htjvasua05f9b84271');


-- If by doing the above steps doesn't accept a baseline OR if you want to be 100% sure that the new plan is the best plan and only it should be used all the time.
-- Issue the below command and that creates a stored outlines.sql_handle and plan_name can be obtained from dba_sql_plan_baselines 

variable cnt number;
exec :cnt :=DBMS_SPM.ALTER_SQL_PLAN_BASELINE(SQL_HANDLE => 'SQL_0c27924e1517084f',PLAN_NAME => 'SQL_PLAN_0s9wk9sajf22gde9ea096',ATTRIBUTE_NAME => 'fixed', ATTRIBUTE_VALUE => 'YES');




8q2b9vbdndhks
14z1g0xczjskg
5t8ff49z9yxa8
5r895c6xwvamx