@echo off

echo "
echo "
echo "
echo "
echo "
echo "This step will check if the Mview are refreshed properly after all the changes made to the DB" 
echo "Output of this step is the mview name and the date it was last refreshed"
echo "
echo "
echo "
echo "
echo "
echo "Enter user credentials to connect as mbta Ex: mbta/xx@mvdb"
set /p loginmbta=
echo %loginmbta%
pause
sqlplus %loginmbta% @Z:\kranthi\pci_afc\9b-mview_refresh_chk.sql
echo "
echo "
echo "
echo "
echo "
echo "End of script. Pressing any key now, will close this batch file" 
pause