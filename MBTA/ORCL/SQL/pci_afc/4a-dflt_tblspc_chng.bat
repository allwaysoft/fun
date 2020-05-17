@echo off

echo "Enter user credentials to connect as mbta Ex: mbta/xx@mvdb"
set /p loginmbta=

echo %loginmbta%
pause

sqlplus %loginmbta% @Z:\kranthi\pci_afc\4b-dflt_tblspc_chng.sql
pause