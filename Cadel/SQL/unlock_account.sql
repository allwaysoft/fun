--PASSOWRDS LIST
-- Use this commend in Command prompt to connect to sqlplus with out logon 'SQLPLUSW /NOLOG'
-- SYS/CONV@CONV as SYSDBA
-- DA/DA@CONV
-- BIS2006/CONV@CONV

prompt
accept connect_as_user prompt 'This script can be run only as SYSDBA, please enter the USER to run. Example:- SYS:'
accept connect_passowrd prompt 'Please enter the password for the user. Example:- CONV:'
accept connect_to_env prompt 'Please enter the Environment where it has to be run. Example:- CONV:'

connect &connect_as_user/&connect_passowrd@&connect_to_env as SYSDBA

SET VERIFY OFF 
SET serveroutput on size 1000000
prompt
prompt 'User will be altered in &connect_to_env Environment.'
prompt
accept wich_user prompt 'Please enter the user to be unlocked:'
accept user_password prompt 'Please enter the passowrd of the user to be unlocked:'

alter user &wich_user identified by &user_password account unlock;
/

Disconnect
/