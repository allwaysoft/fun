@echo off

echo "Enter user credentials to connect as mbta Ex: mbta/xx@mvdb"
set /p loginmbta=

echo %loginmbta%
pause

sqlplus %loginmbta% @Z:\kranthi\pci_afc\1b-pass_change_users.sql
pause