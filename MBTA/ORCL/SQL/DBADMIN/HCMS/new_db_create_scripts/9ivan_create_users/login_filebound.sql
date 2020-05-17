
SET ECHO OFF

/* list of permissions granted to filebound user(HR Scanning project) on PeopleSoft HCMS


-- EXEC sp_droplogin 'filebound'
-- EXEC sp_dropuser 'filebound'

-- EXEC sp_addlogin 'filebound','mbta01',HRPROD, 'us_english', 'FileBound Active Employee View'
--go
-- EXEC sp_adduser 'filebound','filebound','public'
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
select '/u01/app/oracle/admin/scripts/logs_' vpath, SYS_CONTEXT ('USERENV', 'instance_name') loc, '/login_filebound.log' ext from dual;  
SPOOL &new_vpath&new_loc&new_ext

---------- End Part-2   ---------

---------- Start Part-3 ---------
--
SET ECHO ON
SET TERMOUT ON
--

drop user FILEBOUND cascade 
/ 
create user FILEBOUND identified by MBTA01 default tablespace MBAPP temporary tablespace TEMP profile DEFAULT 
--PASSWORD EXPIRE
/ 
 
drop role PS_MB_FILEBOUND cascade
/ 
create role PS_MB_FILEBOUND
/ 
 
grant CREATE SESSION, PS_MB_FILEBOUND to FILEBOUND 
/ 

GRANT SELECT ON sysadm.PS_MB_FILEBOUND_VW TO PS_MB_FILEBOUND
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