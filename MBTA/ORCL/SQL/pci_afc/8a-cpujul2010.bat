@echo off

cd /d C:\oracle\scripts\logs_nwcd
echo ""
echo ""
echo "If you have come to this screen by double clicking a batch file, close this window by "  
echo ""
echo ""
echo "Next Step: Path will be set first, then four services (oracleservicenwcd, oraclemtsrecoveryservice, listener, SB PSI) are stopped" 
echo ""
echo "" 
echo ""
pause
set PATH=%PATH%;%ORACLE_HOME%\OPatch;%ORACLE_HOME%\Apache\perl\5.00503\bin\MSWin32-x86;%ORACLE_HOME%\jdk\bin
sc stop oracleservicenwcd  #this command stops Oracle DB by stopiing the Oracle windows service.
sc stop oraclemtsrecoveryservice
sc stop oracleoraclehometnslistener 
sc stop oracleora92tnslistener
sc stop oracleoraclehomehttpserver
net stop "distributed transaction coordinator"
net stop "Scheidt & Bachmann PSI Service"
net stop "COM+ System Application"
echo "
echo "Next Step: Existing OPatch folder is renamed as Opatch_bak  folder and OPatch from z drive will be copied to Oracle Home" 
echo "
pause
cd %ORACLE_HOME%
rename OPatch Opatch_bak
mkdir OPatch
xcopy "Z:\kranthi\pci_afc\opatch\OPatch" "%ORACLE_HOME%\OPatch" /S
echo "
echo "
echo "
echo "
echo "
echo "Next Step: PSUJUL2010 will be applied, respond with inputs when prompted" 
echo "
echo "
echo "
echo "
echo "
pause
::---------------------------------------------------------------------------------------------------
::cd /d Z:\kranthi\pci_afc\interm_patch\5878965            
::opatch apply 
::Commented the above as none of the TIMEZONE data is affected by version 4 transaction rules
::---------------------------------------------------------------------------------------------------
cd /d Z:\kranthi\pci_afc\cpu\9683644            
opatch apply
echo "
echo "
echo "
echo "
echo "
echo "If the CPU patch failed, rollback the CPU, investigate why it failed and re-apply the patch before continuing with the next step" 
echo "
echo "
echo "
echo "
echo "
pause