@echo off
echo "Enter user credentials to connect as sysdba Ex: sys/xx as sysdba. enclose the whole string in double quotes" 
set /p login=

echo %login%
pause

sqlplus %login% @Z:\kranthi\pci_afc\sql92_security_shutdown.sql
pause
echo #----Setting the sql92 to restrict users from delete update who can't select------- >> D:\NWCD\Scripte\initNWCD.ora
echo sql92_security=TRUE >> D:\NWCD\Scripte\initNWCD.ora
sqlplus %login% @Z:\kranthi\pci_afc\sql92_security_shutdown.sql
goto :EOF