spool rpsc02.log
set echo on


-- Connect as database user
-- =============================================

CONNECT mbta/hallo@mvdb

-- Remove all snapshots
-- =============================================
-- #1 ------------------------------------------
drop snapshot  "MBTA"."ACCESSLEVEL";
drop snapshot  "MBTA"."ALARMACTION";
drop snapshot  "MBTA"."ALARMEVENT";
drop snapshot  "MBTA"."ALARMSERVERCONFIG";
-- #5 ------------------------------------------
drop snapshot  "MBTA"."ALARMSERVERGROUP";
drop snapshot  "MBTA"."ALARMSERVERGROUP_ALARMEVENT";
drop snapshot  "MBTA"."ARTICLE";
drop snapshot  "MBTA"."ARTICLE_RELEASE";
drop snapshot  "MBTA"."BALANCEGROUP";
-- #10 ------------------------------------------
drop snapshot  "MBTA"."CASHTYPE";
drop snapshot  "MBTA"."COMPANY";
drop snapshot  "MBTA"."CURRENCIES";
drop snapshot  "MBTA"."DBCONNECTPARAMETER";
drop snapshot  "MBTA"."DEFAULTSTATIONGROUP";
-- #15 ------------------------------------------
drop snapshot  "MBTA"."DEVICECLASS";
drop snapshot  "MBTA"."DEVICECLASS_VERSIONS";
drop snapshot  "MBTA"."DEVICECONFIG";
drop snapshot  "MBTA"."EVENT";
drop snapshot  "MBTA"."EVENTGROUP";
-- #20 ------------------------------------------
drop snapshot  "MBTA"."FEPDATA";
drop snapshot  "MBTA"."FUNCTION";
drop snapshot  "MBTA"."FUNCTIONGROUP";
drop snapshot  "MBTA"."FUNDSPOOLTVMRELATION";
drop snapshot  "MBTA"."FUNDSPOOL";
drop snapshot  "MBTA"."GRAPHICMAP";
drop snapshot  "MBTA"."GRAPHICPROPERTY";
-- #25 ------------------------------------------
drop snapshot  "MBTA"."HARDWARECOMPONENTS";
drop snapshot  "MBTA"."JOBTABLE";
drop snapshot  "MBTA"."LOCKDEPENDENCIES";
drop snapshot  "MBTA"."MASTERASSEMBLY";
drop snapshot  "MBTA"."MENUTREE";
-- #30 ------------------------------------------
drop snapshot  "MBTA"."MULTIMEDIAGROUP";
drop snapshot  "MBTA"."ORAERR";
drop snapshot  "MBTA"."PAYMENTCASHTYPE";
drop snapshot  "MBTA"."PAYMENTOPDATA";
drop snapshot  "MBTA"."PERMDETAIL";
-- #35 ------------------------------------------
drop snapshot  "MBTA"."PERMISSION";
drop snapshot  "MBTA"."PREVIOUSPASSWORD";
drop snapshot  "MBTA"."PREVIOUSPIN";
drop snapshot  "MBTA"."RELEASE";
drop snapshot  "MBTA"."RELEASE_VERSIONS";
-- #40 ------------------------------------------
drop snapshot  "MBTA"."ROUTES";
drop snapshot  "MBTA"."SCHEDULEELEMENT";
drop snapshot  "MBTA"."SCHEDULEGROUP";
drop snapshot  "MBTA"."SCHEDULEGROUPELEMENTS";
drop snapshot  "MBTA"."SCTVMRELATION";
-- #45 ------------------------------------------
drop snapshot  "MBTA"."SDRELEASE";
drop snapshot  "MBTA"."SDRELEASE_RELEASE";
drop snapshot  "MBTA"."STATIONCONTROLLER";
drop snapshot  "MBTA"."STATUSOPTIONS";
drop snapshot  "MBTA"."TABLEINFO";
-- #50 ------------------------------------------
drop snapshot  "MBTA"."TARIFFVERSIONS";
drop snapshot  "MBTA"."TVMFEPGROUP";
drop snapshot  "MBTA"."TVMGROUP";
drop snapshot  "MBTA"."TVMNETCONFGROUP";
drop snapshot  "MBTA"."TVMSCHEDULEGROUPELEMENT";
-- #55 ------------------------------------------
--drop snapshot  "MBTA"."TVMSCHEDULEGROUPELEMENTS";
drop snapshot  "MBTA"."TVMSTATION";
drop snapshot  "MBTA"."TVMTABLE";
drop snapshot  "MBTA"."TVMVERSIONGROUP";
drop snapshot  "MBTA"."UNIQUENUMBERS";
-- #60 ------------------------------------------
drop snapshot  "MBTA"."USERDATA";
drop snapshot  "MBTA"."USERGROUPS";
drop snapshot  "MBTA"."VERSIONGROUPLIST";
drop snapshot  "MBTA"."VERSIONS";
drop snapshot  "MBTA"."WORKSTATIONGRP";
-- #65 ------------------------------------------
drop snapshot  "MBTA"."WORKSTATIONS";
drop snapshot  "MBTA"."WSGRPCONTENTS";

spool off
--exit
