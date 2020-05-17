@echo off

cd /d C:\oracle\scripts\logs_nwcd
echo "
echo "Next Step: Path will be set first, then four services (oracleservicenwcd, oraclemtsrecoveryservice, listener, SB PSI) are stopped" 
echo "
pause
set PATH=%PATH%;%ORACLE_HOME%\OPatch;%ORACLE_HOME%\Apache\perl\5.00503\bin\MSWin32-x86;%ORACLE_HOME%\jdk\bin
sc stop oracleservicenwcd  #this command stops Oracle DB by stopiing the Oracle windows service.
sc stop oraclemtsrecoveryservice 
sc stop oracleora92tnslistener
sc stop oracleoraclehometnslistener
sc stop oracleoraclehomehttpserver
sc stop "distributed transaction coordinator"
net stop "Scheidt & Bachmann PSI Service"
net stop "COM+ System Application"
echo "
echo "
echo "
echo "
echo "
echo "Next Step: Applying patch set 9208" 
echo "
echo "DO NOT PROCEED BEFORE MAKING SURE THAT ALL S&B SERVICES ARE DOWN." 
echo "IF SERVICES ARE RUNNING, TRY TO STOP THEM, IF THAT DOESN'T WORK, CLOSE THIS DOS PROMPT BY CLICKING x ON THE TOP RIGHT AND"
echo "REBOOT THE MACHINE AND START THIS STEP FROM THE BEGINING"
echo "
echo "
echo "
echo "
echo "
pause
Z:\kranthi\pci_afc\patch_Set\Disk1\setup.exe -silent -responseFile Z:\kranthi\pci_afc\patch_Set\Disk1\response\patchset.rsp
echo "
echo "
echo "
echo "Do not press any key until the OUI window is closed, pressing enter will close this batch file" 
echo "
echo "
echo "If patch set failed, investigate why it failed and re-apply the patch set before continuing with the next step" 
echo "
echo "
echo "End of script. Pressing any key now, will close this batch file" 
echo "
pause