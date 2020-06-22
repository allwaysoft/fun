REM you can also use "echo exit | sqlplus mbta/xxx@nwcdprod @filename" to exit out of sqlplus to return prompt to batch file. password has to be provided in the command line itself

sqlplus /nolog mbta@nwcdprod @C:\MISC\ORACLE\SQL\SchoolCards_Load\school_cards_backup.sql

pause

sqlldr userid=mbta@nwcdprod control= "C:\MISC\ORACLE\SQL\SchoolCards_Load\school_cards.ctl" LOG= "C:\MISC\ORACLE\SQL\SchoolCards_Load\school_cards.log"

pause