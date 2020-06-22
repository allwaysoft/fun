@echo off

cd /d C:\oracle\scripts\logs_nwcd
echo "
echo "
echo "
echo "
echo "Next Step: Start the following services (listener, oracleservicenwcd)" 
echo "
echo "DO NOT PROCEED WITH THIS STEP IF THE PATCH FAILED IN THE PREVIOUS STEP." 
echo "CLOSE THIS DOS PROMPT BY CLICKING x ON THE TOP RIGHT, INVESTIGATE WHY THE PATCH FAILED, FIX THE ISSUE AND"
echo "START THIS STEP FROM THE BEGINING"
echo "
echo "
echo "
echo "
echo "
pause
sc start oracleora92tnslistener
sc start oracleoraclehometnslistener
sc start oracleoraclehomehttpserver
sc start oracleservicenwcd
echo "
echo "Next Step: Running post patch scripts, wait for 30 Seconds now, for the services to start up" 
echo "
pause
@echo off
echo "Enter user credentials to connect as sysdba Ex: sys/xx as sysdba. enclose the whole string in DOUBLE QUOTES" 
set /p loginsys=
echo %loginsys%
pause
sqlplus %loginsys% @Z:\kranthi\pci_afc\7c-post_9208_patch.sql
echo "
echo "
echo "
echo "Next Step: Start the following service oraclemtsrecoveryservice" 
echo "
pause
sc start oraclemtsrecoveryservice
sc start "distributed transaction coordinator"
::net start "Scheidt & Bachmann PSI Service"
::net start "COM+ System Application"
::>> C:\oracle\scripts\logs_nwcd\9-9208_patch_set.log
:: above line has to be added to each line of this file to send the output of this script to a file.
echo "
echo "End of script. Pressing any key now, will close this batch file" 
echo "
pause