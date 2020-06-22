@echo off

cd /d Z:\kranthi\pci_afc\cpu\9683644  
echo "
echo "Next Step: Path will be set first, then four services (oracleservicenwcd, oraclemtsrecoveryservice, listener, SB PSI) are stopped" 
echo "
echo " 
echo "
pause
set PATH=%PATH%;%ORACLE_HOME%\OPatch;%ORACLE_HOME%\Apache\perl\5.00503\bin\MSWin32-x86;%ORACLE_HOME%\jdk\bin
echo "
echo "
echo "
echo "Starting Post CPU Scripts"
echo "
echo "Next Step: remove the vulnerable OKS Demos. respond with inputs when prompted" 
echo " 
echo "DO NOT PROCEED WITH THIS STEP IF THE CPU PATCH FAILED IN PREVIOUS STEP." 
echo "CLOSE THIS DOS PROMPT BY CLICKING x ON THE TOP RIGHT, INVESTIGATE WHY THE PATCH FAILED, FIX THE ISSUE AND"
echo "START THIS STEP FROM THE BEGINING"
echo "
echo "
echo "
echo "
echo "
pause
cscript //nologo remove_demo.js
cd /d C:\oracle\scripts\logs_nwcd
echo "
echo "Next Step: Start the following services (listener, oracleservicenwcd)" 
echo "
pause
sc start oracleora92tnslistener
sc start oracleoraclehometnslistener
sc start oracleoraclehomehttpserver
sc start oracleservicenwcd
echo "
echo "Next Step: Running post patch scripts, wait for 30 Seconds, for the services to start up" 
echo "
pause
@echo off
echo "Enter user credentials to connect as sysdba Ex: sys/xx as sysdba. enclose the whole string in DOUBLE QUOTES" 
set /p loginsys=
echo %loginsys%
pause
sqlplus %loginsys% @Z:\kranthi\pci_afc\8c-post_patch_jul2010cpu.sql
echo "
echo "Next Step: Starting the following services (Oraclemtsrecoveryservice, SB PSI)" 
echo "
pause
sc start oraclemtsrecoveryservice
net start "distributed transaction coordinator" 
net start "Scheidt & Bachmann PSI Service"
net start "COM+ System Application"
::>> C:\oracle\scripts\logs_nwcd\99-cpujul2010.log
:: above line has to be added to each line of this file to send the output of this script to a file.
echo "
echo "
echo "
echo "Next Step: Run opatch to check for the CPU installation" 
echo "
echo " 
echo "
pause
opatch lsinventory
echo "
echo "End of script. Pressing any key now, will close this batch file" 
echo "
pause