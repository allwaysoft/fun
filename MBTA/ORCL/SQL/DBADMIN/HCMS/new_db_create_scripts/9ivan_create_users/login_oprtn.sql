
SET ECHO OFF

/*
List of permissions granted to 'oprtn' users(Angel Fong and Adam Veneziano) on PeopleSoft HRMS 
Provided access on 10/10/2007 so Planning dept can create forms, reports, etc. This would be used from Remote databases such as MS ACCESS

-- To drop existing DB users and Server logins
-- EXEC sp_dropuser 'oprtn'
-- EXEC sp_droplogin 'oprtn'


-- To add DB users and Server logins.
-- EXEC sp_addlogin 'oprtn','mbta01',HRPROD, 'us_english', 'Operations/Planning User'
-- EXEC sp_adduser 'oprtn','oprtn','public'
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
select '/u01/app/oracle/admin/scripts/logs_' vpath, SYS_CONTEXT ('USERENV', 'instance_name') loc, '/login_oprtn.log' ext from dual;  
SPOOL &new_vpath&new_loc&new_ext

---------- End Part-2   ---------

---------- Start Part-3 ---------
--
SET ECHO ON
SET TERMOUT ON
--

drop user OPRTN cascade 
/ 
create user OPRTN identified by MBTA01 default tablespace MBAPP temporary tablespace TEMP profile DEFAULT 
--PASSWORD EXPIRE
/ 
 
drop role PS_MB_OPRTN cascade
/ 
create role PS_MB_OPRTN 
/ 
 
grant CREATE SESSION, PS_MB_OPRTN to OPRTN 
/ 

 GRANT SELECT ON sysadm.PS_DEPT_TBL TO PS_MB_OPRTN
 /
 GRANT SELECT ON sysadm.PS_BUS_UNIT_TBL_HR TO PS_MB_OPRTN
 /
 GRANT SELECT ON sysadm.PS_UNION_TBL TO PS_MB_OPRTN
 /
 GRANT SELECT ON sysadm.PS_LOCATION_TBL TO PS_MB_OPRTN
 /
 GRANT SELECT ON sysadm.XLATTABLE_VW TO PS_MB_OPRTN
 /
 GRANT SELECT ON sysadm.PS_MB_OPRTN_VW TO PS_MB_OPRTN
 /

-- Proposed by Adam V and approved by Paul A-Z on 9/24/208
 GRANT SELECT ON sysadm.PS_MB_JOB_VW TO PS_MB_OPRTN
 /
 GRANT SELECT ON sysadm.PS_JOBCODE_TBL TO PS_MB_OPRTN
 /

-- Proposed by Angel Fong and approved by Ellen Martin-Storey on ??
 GRANT SELECT ON sysadm.PS_MB_FMLA_VW TO PS_MB_OPRTN
 /

-- Proposed by Angel Fong (Not in Production)
-- GRANT SELECT ON sysadm.PS_MB_EMP_JOBDESC_VW TO PS_MB_OPRTN

-- For use in Absence Monitoring Tool - 4/5/2011 - (Not in Production)
 GRANT SELECT ON sysadm.PS_MB_SUPV_EML_VW TO PS_MB_OPRTN
 /

--
SET ECHO OFF
SPOOL OFF
--
---------- End Part-3   ---------

---------- Start Part-4 ---------

SET VERIFY ON
PROMPT Log is generated at &new_vpath&new_loc&new_ext

---------- End Part-4   ---------