@echo off

echo "Enter user credentials to connect as sysdba Ex: sys/xx as sysdba. enclose the whole string in DOUBLE QUOTES" 
set /p loginsys=

echo "Enter user credentials to connect as mbta Ex: mbta/xx@mvdb"
set /p loginmbta=

echo %loginsys%
echo %loginmbta%
pause

sqlplus %loginsys% @Z:\kranthi\pci_afc\3b-1user_password_verification_function.sql
pause
sqlplus %loginsys% @Z:\kranthi\pci_afc\3b-1asysapp_password_verification_function.sql
pause
sqlplus %loginmbta% @Z:\kranthi\pci_afc\3b-2mbta_user_profile.sql
pause
sqlplus %loginmbta% @Z:\kranthi\pci_afc\3b-2ambta_sysapp_profile.sql
pause
sqlplus %loginsys% @Z:\kranthi\pci_afc\3b-3create_additional_users.sql
pause
sqlplus %loginsys% @Z:\kranthi\pci_afc\3b-3aassign_sysapp_profile_to_users.sql
pause
sqlplus %loginmbta% @Z:\kranthi\pci_afc\3b-4set_session_schema_at_login.sql
pause