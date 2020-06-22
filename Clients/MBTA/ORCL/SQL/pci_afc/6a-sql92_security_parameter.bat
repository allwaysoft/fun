sc stop oracleservicenwcd  #this command stops Oracle DB by stopiing the Oracle windows service.
pause
echo #----Setting the sql92 to restrict users from delete update who can't select------- >> D:\NWCD\Scripte\initNWCD.ora
echo sql92_security=TRUE >> D:\NWCD\Scripte\initNWCD.ora
pause
sc start oracleservicenwcd
pause
