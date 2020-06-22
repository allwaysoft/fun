spool rpsc08.log
set echo on

connect mbta/hallo@mvdb;

create materialized view ACCESSLEVEL refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.ACCESSLEVEL@nwcd.mbta.com;
create materialized view ALARMACTION refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.ALARMACTION@nwcd.mbta.com;
create materialized view ALARMEVENT refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.ALARMEVENT@nwcd.mbta.com;
create materialized view ALARMSERVERCONFIG refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.ALARMSERVERCONFIG@nwcd.mbta.com;
create materialized view ALARMSERVERGROUP refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.ALARMSERVERGROUP@nwcd.mbta.com;
create materialized view ALARMSERVERGROUP_ALARMEVENT refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.ALARMSERVERGROUP_ALARMEVENT@nwcd.mbta.com;
create materialized view ARTICLE refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.ARTICLE@nwcd.mbta.com;
create materialized view ARTICLE_RELEASE refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.ARTICLE_RELEASE@nwcd.mbta.com;
create materialized view BALANCEGROUP refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.BALANCEGROUP@nwcd.mbta.com;
create materialized view CASHTYPE refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.CASHTYPE@nwcd.mbta.com;
create materialized view COMPANY refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.COMPANY@nwcd.mbta.com;
create materialized view CURRENCIES refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.CURRENCIES@nwcd.mbta.com;
create materialized view DBCONNECTPARAMETER refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.DBCONNECTPARAMETER@nwcd.mbta.com;
create materialized view DEFAULTSTATIONGROUP refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.DEFAULTSTATIONGROUP@nwcd.mbta.com;
create materialized view DEVICECLASS refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.DEVICECLASS@nwcd.mbta.com;
create materialized view DEVICECLASS_VERSIONS refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.DEVICECLASS_VERSIONS@nwcd.mbta.com;
create materialized view DEVICECONFIG refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.DEVICECONFIG@nwcd.mbta.com;
create materialized view EVENT refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.EVENT@nwcd.mbta.com;
create materialized view EVENTGROUP refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.EVENTGROUP@nwcd.mbta.com;
create materialized view FEPDATA refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.FEPDATA@nwcd.mbta.com;
create materialized view FUNCTION refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.FUNCTION@nwcd.mbta.com;
create materialized view FUNCTIONGROUP refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.FUNCTIONGROUP@nwcd.mbta.com;
create materialized view GRAPHICMAP refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.GRAPHICMAP@nwcd.mbta.com;
create materialized view GRAPHICPROPERTY refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.GRAPHICPROPERTY@nwcd.mbta.com;
create materialized view HARDWARECOMPONENTS refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.HARDWARECOMPONENTS@nwcd.mbta.com;
create materialized view JOBTABLE refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.JOBTABLE@nwcd.mbta.com;
create materialized view LOCKDEPENDENCIES refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.LOCKDEPENDENCIES@nwcd.mbta.com;
create materialized view MASTERASSEMBLY refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.MASTERASSEMBLY@nwcd.mbta.com;
create materialized view MENUTREE refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.MENUTREE@nwcd.mbta.com;
create materialized view ORAERR refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.ORAERR@nwcd.mbta.com;
create materialized view PAYMENTCASHTYPE refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.PAYMENTCASHTYPE@nwcd.mbta.com;
create materialized view PAYMENTOPDATA refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.PAYMENTOPDATA@nwcd.mbta.com;
create materialized view PERMDETAIL refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.PERMDETAIL@nwcd.mbta.com;
create materialized view PERMISSION refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.PERMISSION@nwcd.mbta.com;
create materialized view PREVIOUSPASSWORD refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.PREVIOUSPASSWORD@nwcd.mbta.com;
create materialized view PREVIOUSPIN refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.PREVIOUSPIN@nwcd.mbta.com;
create materialized view RELEASE refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.RELEASE@nwcd.mbta.com;
create materialized view RELEASE_VERSIONS refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.RELEASE_VERSIONS@nwcd.mbta.com;
create materialized view ROUTES refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.ROUTES@nwcd.mbta.com;
create materialized view SCHEDULEELEMENT refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.SCHEDULEELEMENT@nwcd.mbta.com;
create materialized view SCHEDULEGROUP refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.SCHEDULEGROUP@nwcd.mbta.com;
create materialized view SCHEDULEGROUPELEMENTS refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.SCHEDULEGROUPELEMENTS@nwcd.mbta.com;
create materialized view SCTVMRELATION refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.SCTVMRELATION@nwcd.mbta.com;
create materialized view SDRELEASE refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.SDRELEASE@nwcd.mbta.com;
create materialized view SDRELEASE_RELEASE refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.SDRELEASE_RELEASE@nwcd.mbta.com;
create materialized view STATIONCONTROLLER refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.STATIONCONTROLLER@nwcd.mbta.com;
create materialized view STATUSOPTIONS refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.STATUSOPTIONS@nwcd.mbta.com;
create materialized view TABLEINFO refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.TABLEINFO@nwcd.mbta.com;
create materialized view TARIFFVERSIONS refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.TARIFFVERSIONS@nwcd.mbta.com;
create materialized view TVMFEPGROUP refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.TVMFEPGROUP@nwcd.mbta.com;
create materialized view TVMGROUP refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.TVMGROUP@nwcd.mbta.com;
create materialized view TVMNETCONFGROUP refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.TVMNETCONFGROUP@nwcd.mbta.com;
create materialized view TVMSCHEDULEGROUPELEMENT refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.TVMSCHEDULEGROUPELEMENT@nwcd.mbta.com;
--create materialized view TVMSCHEDULEGROUPELEMENTS refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.TVMSCHEDULEGROUPELEMENTS@nwcd.mbta.com;
create materialized view TVMSTATION refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.TVMSTATION@nwcd.mbta.com;
create materialized view TVMTABLE refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.TVMTABLE@nwcd.mbta.com;
create materialized view TVMVERSIONGROUP refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.TVMVERSIONGROUP@nwcd.mbta.com;
create materialized view UNIQUENUMBERS refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.UNIQUENUMBERS@nwcd.mbta.com;
create materialized view USERDATA refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.USERDATA@nwcd.mbta.com;
create materialized view USERGROUPS refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.USERGROUPS@nwcd.mbta.com;
create materialized view VERSIONGROUPLIST refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.VERSIONGROUPLIST@nwcd.mbta.com;
create materialized view VERSIONS refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.VERSIONS@nwcd.mbta.com;
create materialized view WORKSTATIONGRP refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.WORKSTATIONGRP@nwcd.mbta.com;
create materialized view WORKSTATIONS refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.WORKSTATIONS@nwcd.mbta.com;
create materialized view WSGRPCONTENTS refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.WSGRPCONTENTS@nwcd.mbta.com;
create materialized view FUNDSPOOL refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.FUNDSPOOL@nwcd.mbta.com;
create materialized view FUNDSPOOLTVMRELATION refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.FUNDSPOOLTVMRELATION@nwcd.mbta.com;
create materialized view MULTIMEDIAGROUP refresh fast  start with sysdate next sysdate + 1  with primary key as select * from MBTA.MULTIMEDIAGROUP@nwcd.mbta.com;

spool off
--exit
