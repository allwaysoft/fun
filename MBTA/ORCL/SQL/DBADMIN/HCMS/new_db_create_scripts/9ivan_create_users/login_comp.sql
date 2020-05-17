
SET ECHO OFF

/* 
List of permissions granted to 'comp' users(Paul A-Z and Gina Gelsomini) on PeopleSoft HRMS  
Review SQL Extract on user comp in DBArtisan  
Provided access on 7/26/2005 so Paul can run a query and transfer the result set to MS ACCESS and run another query to match 
description columns using external link with these tables in Sybase  
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
select '/u01/app/oracle/admin/scripts/logs_' vpath, SYS_CONTEXT ('USERENV', 'instance_name') loc, '/login_comp.log' ext from dual;  
SPOOL &new_vpath&new_loc&new_ext

---------- End Part-2   ---------

---------- Start Part-3 ---------
--
SET ECHO ON
SET TERMOUT ON
--

drop user COMP cascade 
/ 
create user COMP identified by MBTA01 default tablespace MBAPP temporary tablespace TEMP profile DEFAULT 
--PASSWORD EXPIRE
/ 
 
drop role PS_MB_COMP cascade
/ 
create role PS_MB_COMP 
/ 
 
grant CREATE SESSION, PS_MB_COMP to COMP 
/ 
 
 GRANT SELECT ON sysadm.PS_JOBCODE_TBL TO PS_MB_COMP 
/ 
 GRANT SELECT ON sysadm.PS_POSITION_DATA TO PS_MB_COMP 
/ 
 GRANT SELECT ON sysadm.PS_DEPT_TBL TO PS_MB_COMP 
/ 
 GRANT SELECT ON sysadm.PS_BUS_UNIT_TBL_HR TO PS_MB_COMP 
/ 
 GRANT SELECT ON sysadm.PS_UNION_TBL TO PS_MB_COMP 
/ 
 GRANT SELECT ON sysadm.PS_SAL_GRADE_TBL TO PS_MB_COMP 
/ 
 GRANT SELECT ON sysadm.PS_SAL_PLAN_TBL TO PS_MB_COMP 
/ 
 GRANT SELECT ON sysadm.PS_LOCATION_TBL TO PS_MB_COMP 
/ 
 GRANT SELECT ON sysadm.PS_PAYGROUP_TBL TO PS_MB_COMP 
/ 
 GRANT SELECT ON sysadm.XLATTABLE_VW TO PS_MB_COMP 
/ 
 
 
/* -- 8/1/2005 
   Added Transaction tables because Paul is unable to join master tables due to error on  
   external(Sybase) tables 'Columns not indexed' 
*/ 
 
 
GRANT SELECT ON sysadm.PS_JOB TO PS_MB_COMP 
/ 
GRANT SELECT ON sysadm.PS_DIVERSITY TO PS_MB_COMP 
/ 
-- GRANT SELECT ON sysadm.PS_APP_DIVERSITY TO PS_MB_COMP 
GRANT SELECT ON sysadm.PS_PERSONAL_DATA TO PS_MB_COMP 
/ 
-- GRANT SELECT ON sysadm.PS_JOB_REQUISITION TO PS_MB_COMP 
GRANT SELECT ON sysadm.PS_HRS_JOB_OPENING TO PS_MB_COMP 
/ 
-- GRANT SELECT ON sysadm.PS_APPLICANT TO PS_MB_COMP 
GRANT SELECT ON sysadm.PS_HRS_APPLICANT TO PS_MB_COMP 
/ 
 
-- GRANT SELECT ON sysadm.PS_APPLICANT_DATA TO PS_MB_COMP 
GRANT SELECT ON sysadm.PS_HRS_APP_PROFILE TO PS_MB_COMP 
/ 
 
-- GRANT SELECT ON sysadm.PS_APPL_DATA_EFFDT TO PS_MB_COMP 
GRANT SELECT ON sysadm.PS_HRS_APP_ADDRESS TO PS_MB_COMP 
/ 
GRANT SELECT ON sysadm.PS_HRS_APP_NAMES TO PS_MB_COMP 
/ 
 
-- GRANT SELECT ON sysadm.PS_POSN_APPLIEDFOR TO PS_MB_COMP 
GRANT SELECT ON sysadm.PS_HRS_RCMNT TO PS_MB_COMP 
/ 
 
GRANT SELECT ON sysadm.PS_HEALTH_BENEFIT TO PS_MB_COMP 
/ 
GRANT SELECT ON sysadm.PS_BEN_PROG_PARTIC TO PS_MB_COMP 
/ 
GRANT SELECT ON sysadm.PS_RTRMNT_PLAN TO PS_MB_COMP 
/ 
GRANT SELECT ON sysadm.PS_EMPLOYEES TO PS_MB_COMP 
/ 
GRANT SELECT ON sysadm.PS_EMPLOYMENT TO PS_MB_COMP 
/ 
 
 
/* -- 8/29/2005 
Paul requested access to the STEP Tables 
*/ 
GRANT SELECT ON sysadm.PS_SAL_STEP_TBL TO PS_MB_COMP 
/ 
 
/* -- 2/15/2006 
Paul requested access to FMLA Tables as Kathleen Rawdon needs it for Child Care services 
*/ 
GRANT SELECT ON sysadm.PS_MB_FMLA TO PS_MB_COMP 
/ 
 
/* -- 2/16/2006 
Paul requested access to Discipline Tables with Approval from Maryanne Walsh as Kathleen Rawden  
needs it for Unemployment, Educational assistance and other services  
*/ 
GRANT SELECT ON sysadm.PS_DISCIPLIN_ACTN TO PS_MB_COMP 
/ 
GRANT SELECT ON sysadm.PS_DISCIPLIN_STEP TO PS_MB_COMP 
/ 
GRANT SELECT ON sysadm.PS_DISCIP_TYPE_TBL TO PS_MB_COMP 
/ 
GRANT SELECT ON sysadm.PS_DISCIP_STEP_TBL TO PS_MB_COMP 
/ 
 
/* -- 2/17/2006 
Paul requested access to Inbound Tables with approval from Dee Richardson. 
He will use this data for Unemployment, Child Care and other services his unit  
is now responsible for 
*/ 
GRANT SELECT ON sysadm.PS_MB_INB_TBL TO PS_MB_COMP 
/ 
GRANT SELECT ON sysadm.PS_MB_INB_EARNINGS TO PS_MB_COMP 
/ 
GRANT SELECT ON sysadm.PS_MB_INB_DED TO PS_MB_COMP 
/ 
GRANT SELECT ON sysadm.PS_MB_INB_YTD TO PS_MB_COMP 
/ 
 
/* -- 6/2/2006 
Paul requested access to current view of JOB as he had a complicated way in MS ACCESS to determine current JOB rows 
*/ 
GRANT SELECT ON sysadm.PS_JOB_ALL_CURR_VW TO PS_MB_COMP 
/ 
 
/* -- 6/6/2006 
Paul requested access to new Diversity table 
*/ 
GRANT SELECT ON sysadm.PS_DIVERS_ETHNIC TO PS_MB_COMP 
/ 
 
/* -- 8/24/2006 
Paul requested access to new Applicant Diversity table 
*/ 
/* 11/2/2006 - See note for PS_HRS_APP_DIV_ETH */ 
-- GRANT SELECT ON sysadm.PS_HRS_APP_DIV TO PS_MB_COMP 
-- REVOKE SELECT ON sysadm.PS_HRS_APP_DIV TO PS_MB_COMP 
 
/* -- 11/2/2006 
HRS_APP_DIV is not updated when Recruiters update Ethnic Group. PS_HRS_APP_DIV_ETH is instead used. Hence 
access was provided to Paul's group to this table. 
*/ 
GRANT SELECT ON sysadm.PS_HRS_APP_DIV_ETH TO PS_MB_COMP 
/ 
 
/* 
Date: 5/10/2007 
Requested access to PS_HEALTH_VW and PS_HEALTH_DEPENDNT by Paul A-Z 
*/ 
GRANT SELECT ON sysadm.PS_HEALTH_VW TO PS_MB_COMP 
/ 
GRANT SELECT ON sysadm.PS_HEALTH_DEPENDNT TO PS_MB_COMP 
/ 
 
/* 
Date: 12/03/2007 
Requested access to sysadm.PS_DEPENDENT_BENEF by Paul A-Z instead of DEP_BEN which does not have NAME fields 
*/ 
GRANT SELECT ON sysadm.PS_DEPENDENT_BENEF TO PS_MB_COMP 
/ 
 
/* 
Date: 3/31/2008 
Requested access to sysadm.PS_DEPENDENT_BENEF by Paul A-Z and John Gaskins to run audits in HR 
*/ 
GRANT SELECT ON sysadm.PS_PAY_CHECK TO PS_MB_COMP 
/ 
GRANT SELECT ON sysadm.PS_PAY_DEDUCTION TO PS_MB_COMP 
/ 
GRANT SELECT ON sysadm.PS_PAY_EARNINGS TO PS_MB_COMP 
/ 
 
/* 
Date: 8/6/2008 
Requested access to PS_PERS_NID by Paul A-Z 
*/ 
GRANT SELECT ON sysadm.PS_PERS_NID TO PS_MB_COMP 
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