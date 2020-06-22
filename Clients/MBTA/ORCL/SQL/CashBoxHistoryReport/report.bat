@echo off

echo "Enter user credentials to connect as MBTA user of DB in format mbta/xxx@nwcd"
set /p loginmbta=

sqlplus %loginmbta% @C:\MISC\ORACLE\SQL\CashBoxHistoryReport\script.sql

C:\oracle\orarep\rwrun60.exe ^
X:\OraRep\chr_prod.rdf %loginmbta% ^
PARAMFORM=NO BACKGROUND=NO ORIENTATION=LANDSCAPE DESTYPE=SCREEN  ^
P_ReceiverVault="All" ^
P_Employee="All" ^
P_Cashbox="All" ^
P_BusNo="All" ^
P_Garage="in List-99991" ^
P_FareboxFrom="in List-99990" ^
P_FareboxInto="All" ^
P_MobileVault="All" ^
P_DateFirst="2007-11-13-03-00-00" ^
P_DateLast="2007-11-25-02-59-59" ^
P_DateRange="11/13/2007 03:00:00 AM - 11/25/2007 02:59:59 AM" ^
P_DateRangeCashboxPulled="All" ^
P_DateFirstPulled="1970-01-01-00-00-00" ^
P_DateLastPulled="3000-12-31-23-59-59" ^
P_ORDERBYSHOW="Date/Time" ^
P_COMPANY="MBTA" ^
P_REPORTID="S&B" ^
P_REPORTNAME="Cashbox History Report" ^
P_WHERE="Data27 in (select NumberData from ReportParameter where ListID=99991) and Data5 in (select NumberData from ReportParameter where ListID=99990)" P_WHEREPL="ListID in (99990,99991)"