
SET ECHO OFF

/*
Add login mcrs for the MCRS system to access PeopleSoft HRMS real time.

-- Drop user from every database before droping the login
-- EXEC sp_dropuser 'mcrs'
-- EXEC sp_droplogin 'mcrs'
-- sp_displaylogin mcrs

-- EXEC sp_addlogin 'mcrs','mbta01',HRPROD, 'us_english', 'MCRS Employee View User'
--go
-- EXEC sp_adduser 'mcrs','mcrs','public'
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
select '/u01/app/oracle/admin/scripts/logs_' vpath, SYS_CONTEXT ('USERENV', 'instance_name') loc, '/login_mcrs.log' ext from dual;  
SPOOL &new_vpath&new_loc&new_ext

---------- End Part-2   ---------

---------- Start Part-3 ---------
--
SET ECHO ON
SET TERMOUT ON
--

drop user MCRS cascade 
/ 
create user MCRS identified by MBTA01 default tablespace MBAPP temporary tablespace TEMP profile default
--PASSWORD EXPIRE
/ 
-- In above script changed the profile from ps_mb_default to default based on communication with JRW.
 
drop role PS_MB_MCRS cascade
/ 
create role PS_MB_MCRS 
/ 
 
grant CREATE SESSION, PS_MB_MCRS to MCRS 
/ 

GRANT SELECT ON sysadm.PS_MB_MCRS_VW TO PS_MB_MCRS
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