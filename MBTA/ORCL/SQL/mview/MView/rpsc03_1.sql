spool rpsc03_1.log
set echo on

connect mbta/hallo@mvdb;

drop table ACCESSLEVEL;
drop table ALARMACTION;
drop table ALARMEVENT;
drop table ALARMSERVERCONFIG;
drop table ALARMSERVERGROUP;
drop table ALARMSERVERGROUP_ALARMEVENT;
drop table ARTICLE;
drop table ARTICLE_RELEASE;
drop table BALANCEGROUP;
drop table CASHTYPE;
drop table COMPANY;
drop table CURRENCIES;
drop table DBCONNECTPARAMETER;
drop table DEFAULTSTATIONGROUP;
drop table DEVICECLASS;
drop table DEVICECLASS_VERSIONS;
drop table DEVICECONFIG;
drop table EVENT;
drop table EVENTGROUP;
drop table FEPDATA;
drop table FUNCTION;
drop table FUNCTIONGROUP;
drop table FUNDSPOOL;
drop table FUNDSPOOLTVMRELATION;
drop table GRAPHICMAP;
drop table GRAPHICPROPERTY;
drop table HARDWARECOMPONENTS;
drop table JOBTABLE;
drop table LOCKDEPENDENCIES;
drop table MASTERASSEMBLY;
drop table MENUTREE;
drop table MULTIMEDIAGROUP;
drop table ORAERR;
drop table PAYMENTCASHTYPE;
drop table PAYMENTOPDATA;
drop table PERMDETAIL;
drop table PERMISSION;
drop table PREVIOUSPASSWORD;
drop table PREVIOUSPIN;
drop table RELEASE;
drop table RELEASE_VERSIONS;
drop table ROUTES;
drop table SCHEDULEELEMENT;
drop table SCHEDULEGROUP;
drop table SCHEDULEGROUPELEMENTS;
drop table SCTVMRELATION;
drop table SDRELEASE;
drop table SDRELEASE_RELEASE;
drop table STATIONCONTROLLER;
drop table STATUSOPTIONS;
drop table TABLEINFO;
drop table TARIFFVERSIONS;
drop table TVMFEPGROUP;
drop table TVMGROUP;
drop table TVMNETCONFGROUP;
drop table TVMSCHEDULEGROUPELEMENT;
--drop table TVMSCHEDULEGROUPELEMENTS;
drop table TVMSTATION;
drop table TVMTABLE;
drop table TVMVERSIONGROUP;
drop table UNIQUENUMBERS;
drop table USERDATA;
drop table USERGROUPS;
drop table VERSIONGROUPLIST;
drop table VERSIONS;
drop table WORKSTATIONGRP;
drop table WORKSTATIONS;
drop table WSGRPCONTENTS;


spool off
--exit
