
SET ECHO OFF

/* 
/* list of permissions granted to tracs user(Michael Brooks) on PeopleSoft HRMS
/* Review SQL Extract on user tracs in DBArtisan

-- EXEC sp_dropuser 'tracs'
-- EXEC sp_droplogin 'tracs'

-- EXEC sp_displaylogin 'tracs'

-- EXEC sp_addlogin 'tracs','mbta01',HRPROD, 'us_english', 'Tracs Employee View User'
--go
-- EXEC sp_adduser 'tracs','tracs','public'
--go
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
select '/u01/app/oracle/admin/scripts/logs_' vpath, SYS_CONTEXT ('USERENV', 'instance_name') loc, '/login_tracs.log' ext from dual;  
SPOOL &new_vpath&new_loc&new_ext

---------- End Part-2   ---------

---------- Start Part-3 ---------
--
SET ECHO ON
SET TERMOUT ON
--

drop user TRACS cascade 
/ 
create user TRACS identified by MBTA01 default tablespace MBAPP temporary tablespace TEMP profile DEFAULT 
--PASSWORD EXPIRE
/ 
 
drop role PS_MB_TRACS cascade
/ 
create role PS_MB_TRACS
/ 
 
grant CREATE SESSION, PS_MB_TRACS to TRACS
/ 


-- GRANT SELECT ON sysadm.PS_MB_DEPT TO PS_MB_TRACS -- 10/6/2004: Revoked as Michael said he didn't need it if he had access to PS_DEPT_TBL_EFF_VW.
GRANT SELECT ON sysadm.PS_MB_JOBCODE1_VW TO PS_MB_TRACS
/
GRANT SELECT ON sysadm.PS_MB_UNION_VW TO PS_MB_TRACS
/
-- GRANT SELECT ON sysadm.PS_MB_JOBCODE TO PS_MB_TRACS (replaced by view - PS_MB_JOBCODE1_VW?)
-- GRANT SELECT ON sysadm.PS_UNION_TBL TO PS_MB_TRACS (replaced by view - PS_MB_UNION_VW)
GRANT SELECT ON sysadm.PS_MB_HLTH_VW TO PS_MB_TRACS
/
GRANT SELECT ON sysadm.PS_EMPLOYEES TO PS_MB_TRACS
/
-- PS_MB_TRACS_VW does not exist
-- GRANT SELECT ON sysadm.PS_MB_TRACS_VW TO PS_MB_TRACS
GRANT SELECT ON sysadm.PS_POSITION_DATA TO PS_MB_TRACS
/

-- Include select access only if this view can be used to replace PS_MB_DEPT (9/22/2004)
-- This view indeed will replace PS_MB_DEPT (10/6/2004)
GRANT SELECT ON sysadm.PS_DEPT_TBL_EFF_VW TO PS_MB_TRACS
/

-- Matt created this view 10/5/2004 to replace MB_EMPINACTV, EMPLOYEES as these records overlapped Active and Inactive data 
-- due to transactions during the day.
GRANT SELECT ON sysadm.PS_MB_TRACS_ALL_VW TO PS_MB_TRACS
/

-- 10/6/2004: Revoked as Michael said he didn't need it if he had access to PS_MB_UNION_VW.
-- REVOKE SELECT ON sysadm.PS_UNION_TBL TO PS_MB_TRACS
-- 10/6/2004: Revoked as Michael said he didn't need it if he had access to PS_DEPT_TBL_EFF_VW.
-- REVOKE SELECT ON sysadm.PS_MB_DEPT TO PS_MB_TRACS
-- 5/27/2006: Revoked as Michael said he didn't need it anymore.

--
SET ECHO OFF
SPOOL OFF
--
---------- End Part-3   ---------

---------- Start Part-4 ---------

SET VERIFY ON
PROMPT Log is generated at &new_vpath&new_loc&new_ext

---------- End Part-4   ---------