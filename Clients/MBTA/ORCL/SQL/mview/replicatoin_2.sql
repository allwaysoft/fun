execute dbms_mview.refresh('"MBTA"."ACCESSLEVEL"','C');
execute dbms_mview.refresh('"MBTA"."ALARMACTION"','C');
execute dbms_mview.refresh('"MBTA"."ALARMEVENT"','C');
execute dbms_mview.refresh('"MBTA"."ALARMSERVERCONFIG"','C');
execute dbms_mview.refresh('"MBTA"."ALARMSERVERGROUP"','C');
execute dbms_mview.refresh('"MBTA"."ALARMSERVERGROUP_ALARMEVENT"','C');
execute dbms_mview.refresh('"MBTA"."ARTICLE"','C');
execute dbms_mview.refresh('"MBTA"."ARTICLE_RELEASE"','C');
execute dbms_mview.refresh('"MBTA"."CASHTYPE"','C');
execute dbms_mview.refresh('"MBTA"."COMPANY"','C');
execute dbms_mview.refresh('"MBTA"."CURRENCIES"','C');
execute dbms_mview.refresh('"MBTA"."DBCONNECTPARAMETER"','C');
execute dbms_mview.refresh('"MBTA"."DEFAULTSTATIONGROUP"','C');
execute dbms_mview.refresh('"MBTA"."DEVICECLASS_VERSIONS"','C');
execute dbms_mview.refresh('"MBTA"."DEVICECONFIG"','C');
execute dbms_mview.refresh('"MBTA"."EVENT"','C');
execute dbms_mview.refresh('"MBTA"."EVENTGROUP"','C');
execute dbms_mview.refresh('"MBTA"."FUNCTION"','C');
execute dbms_mview.refresh('"MBTA"."FUNCTIONGROUP"','C');
execute dbms_mview.refresh('"MBTA"."GRAPHICMAP"','C');
execute dbms_mview.refresh('"MBTA"."GRAPHICPROPERTY"','C');
execute dbms_mview.refresh('"MBTA"."HARDWARECOMPONENTS"','C');
--
execute dbms_mview.refresh('"MBTA"."LOCKDEPENDENCIES"','C');
execute dbms_mview.refresh('"MBTA"."MASTERASSEMBLY"','C');
execute dbms_mview.refresh('"MBTA"."MENUTREE"','C');

execute dbms_mview.refresh('"MBTA"."ORAERR"','C');
execute dbms_mview.refresh('"MBTA"."PAYMENTCASHTYPE"','C');
execute dbms_mview.refresh('"MBTA"."PAYMENTOPDATA"','C');
execute dbms_mview.refresh('"MBTA"."PERMDETAIL"','C');
execute dbms_mview.refresh('"MBTA"."PERMISSION"','C');
execute dbms_mview.refresh('"MBTA"."PREVIOUSPASSWORD"','C');
execute dbms_mview.refresh('"MBTA"."PREVIOUSPIN"','C');
execute dbms_mview.refresh('"MBTA"."RELEASE"','C');
execute dbms_mview.refresh('"MBTA"."RELEASE_VERSIONS"','C');
execute dbms_mview.refresh('"MBTA"."ROUTES"','C');
execute dbms_mview.refresh('"MBTA"."SCHEDULEELEMENT"','C');
execute dbms_mview.refresh('"MBTA"."SCHEDULEGROUP"','C');
execute dbms_mview.refresh('"MBTA"."SCHEDULEGROUPELEMENTS"','C');
execute dbms_mview.refresh('"MBTA"."SCTVMRELATION"','C');
execute dbms_mview.refresh('"MBTA"."SDRELEASE"','C');
execute dbms_mview.refresh('"MBTA"."SDRELEASE_RELEASE"','C');
execute dbms_mview.refresh('"MBTA"."STATIONCONTROLLER"','C');
execute dbms_mview.refresh('"MBTA"."STATUSOPTIONS"','C');
execute dbms_mview.refresh('"MBTA"."TABLEINFO"','C');
execute dbms_mview.refresh('"MBTA"."TARIFFVERSIONS"','C');
execute dbms_mview.refresh('"MBTA"."TVMFEPGROUP"','C');
execute dbms_mview.refresh('"MBTA"."TVMGROUP"','C');
execute dbms_mview.refresh('"MBTA"."TVMNETCONFGROUP"','C');
execute dbms_mview.refresh('"MBTA"."TVMSCHEDULEGROUPELEMENT"','C');

execute dbms_mview.refresh('"MBTA"."TVMSTATION"','C');

execute dbms_mview.refresh('"MBTA"."UNIQUENUMBERS"','C');

execute dbms_mview.refresh('"MBTA"."USERDATA"','C');

execute dbms_mview.refresh('"MBTA"."USERGROUPS"','C');

execute dbms_mview.refresh('"MBTA"."VERSIONGROUPLIST"','C');

execute dbms_mview.refresh('"MBTA"."WORKSTATIONGRP"','C');

execute dbms_mview.refresh('"MBTA"."WORKSTATIONS"','C');

execute dbms_mview.refresh('"MBTA"."WSGRPCONTENTS"','C');

execute dbms_mview.refresh('"MBTA"."MULTIMEDIAGROUP"','C');







execute dbms_mview.refresh('"MBTA"."BALANCEGROUP"','C');

execute dbms_mview.refresh('"MBTA"."DEVICECLASS"','C');

execute dbms_mview.refresh('"MBTA"."FEPDATA"','C');

execute dbms_mview.refresh('"MBTA"."JOBTABLE"','C');

execute dbms_mview.refresh('"MBTA"."TVMTABLE"','C');

execute dbms_mview.refresh('"MBTA"."TVMVERSIONGROUP"','C');

execute dbms_mview.refresh('"MBTA"."VERSIONS"','C');



   exec DBMS_REFRESH.SUBTRACT(name => '"MVIEWADMIN"."MBTA_REFG1"', list => '"MBTA"."BALANCEGROUP"', lax => TRUE);
   
   exec DBMS_REFRESH.SUBTRACT(name => '"MVIEWADMIN"."MBTA_REFG1"', list => '"MBTA"."DEVICECLASS"', lax => TRUE);
   
   exec DBMS_REFRESH.SUBTRACT(name => '"MVIEWADMIN"."MBTA_REFG1"', list => '"MBTA"."FEPDATA"', lax => TRUE);
   
   exec DBMS_REFRESH.SUBTRACT(name => '"MVIEWADMIN"."MBTA_REFG1"', list => '"MBTA"."JOBTABLE"', lax => TRUE);
   
   exec DBMS_REFRESH.SUBTRACT(name => '"MVIEWADMIN"."MBTA_REFG1"', list => '"MBTA"."TVMTABLE"', lax => TRUE);
   
   exec DBMS_REFRESH.SUBTRACT(name => '"MVIEWADMIN"."MBTA_REFG1"', list => '"MBTA"."TVMVERSIONGROUP"', lax => TRUE);
   
   exec DBMS_REFRESH.SUBTRACT(name => '"MVIEWADMIN"."MBTA_REFG1"', list => '"MBTA"."VERSIONS"', lax => TRUE);
   


   exec DBMS_REFRESH.ADD(name => '"MVIEWADMIN"."MBTA_REFG1"', list => '"MBTA"."BALANCEGROUP"', lax => TRUE);
   
   exec DBMS_REFRESH.ADD(name => '"MVIEWADMIN"."MBTA_REFG1"', list => '"MBTA"."DEVICECLASS"', lax => TRUE);
   
   exec DBMS_REFRESH.ADD(name => '"MVIEWADMIN"."MBTA_REFG1"', list => '"MBTA"."FEPDATA"', lax => TRUE);
   
   exec DBMS_REFRESH.ADD(name => '"MVIEWADMIN"."MBTA_REFG1"', list => '"MBTA"."JOBTABLE"', lax => TRUE);
   
   exec DBMS_REFRESH.ADD(name => '"MVIEWADMIN"."MBTA_REFG1"', list => '"MBTA"."TVMTABLE"', lax => TRUE);
   
   exec DBMS_REFRESH.ADD(name => '"MVIEWADMIN"."MBTA_REFG1"', list => '"MBTA"."TVMVERSIONGROUP"', lax => TRUE);
   
   exec DBMS_REFRESH.ADD(name => '"MVIEWADMIN"."MBTA_REFG1"', list => '"MBTA"."VERSIONS"', lax => TRUE);
   
   
   
   
select sysdate from dual   


select * from 




Alter table MBTA.SCHEDULEGROUP add (constraint R_1282 foreign key ( JOBIDREF) references MBTA.JOBTABLE(JOBID) deferrable );
Alter table MBTA.TVMFEPGROUP add (constraint R_1253 foreign key ( FEPGATEWAY) references MBTA.FEPDATA(FEPID) deferrable ); 
Alter table MBTA.TVMTABLE add (constraint R_1297 foreign key ( TVMMANUALVERSIONGROUPID) references MBTA.TVMVERSIONGROUP(TVMVERGROUPID) deferrable );     
ALTER TABLE MBTA.PAYMENTRECEIPT ADD (  CONSTRAINT R_1250  FOREIGN KEY (DEVICECLASSID, DEVICEID)  REFERENCES MBTA.TVMTABLE (DEVICECLASSID,TVMID) deferrable );
ALTER TABLE MBTA.EXPORTBALANCEGROUP ADD (  CONSTRAINT R_1251  FOREIGN KEY (BALANCEGROUPID)  REFERENCES MBTA.BALANCEGROUP (BALANCEGROUPID) deferrable );
ALTER TABLE MBTA.ITSO_DEVICE_ISAM_MAPPING ADD (CONSTRAINT R_1259 FOREIGN KEY (DEVICECLASSID, DEVICEID) REFERENCES MBTA.TVMTABLE (DEVICECLASSID,TVMID) deferrable );
ALTER TABLE MBTA.IMPORTVERSIONLINKLIST ADD (  CONSTRAINT R_1303  FOREIGN KEY (VERSIONID)  REFERENCES MBTA.VERSIONS (VERSIONID) deferrable );
ALTER TABLE MBTA.MASTERASSEMBLYDEVICECLASS ADD (  CONSTRAINT R_1305  FOREIGN KEY (DEVICECLASSID)  REFERENCES MBTA.DEVICECLASS (DEVICECLASSID) deferrable );


Alter table MBTA.EXPORTBALANCEGROUP drop constraint R_1251;

Alter table MBTA.IMPORTVERSIONLINKLIST drop constraint R_1303;

Alter table MBTA.ITSO_DEVICE_ISAM_MAPPING drop constraint R_1259;

Alter table MBTA.MASTERASSEMBLYDEVICECLASS drop constraint R_1305;

Alter table MBTA.PAYMENTRECEIPT drop constraint R_1250;

Alter table MBTA.SCHEDULEGROUP drop constraint R_1282;

Alter table MBTA.TVMFEPGROUP drop constraint R_1253;

Alter table MBTA.TVMTABLE drop constraint R_1297;


Alter table MBTA.EXPORTBALANCEGROUP add (constraint R_1251 foreign key ( BALANCEGROUPID) references MBTA.BALANCEGROUP(BALANCEGROUPID) deferrable );

Alter table MBTA.IMPORTVERSIONLINKLIST add (constraint R_1303 foreign key ( VERSIONID) references MBTA.VERSIONS(VERSIONID) deferrable );

Alter table MBTA.ITSO_DEVICE_ISAM_MAPPING add (constraint R_1259 foreign key ( DEVICECLASSID,DEVICEID) references MBTA.TVMTABLE(DEVICECLASSID,TVMID) deferrable );

Alter table MBTA.MASTERASSEMBLYDEVICECLASS add (constraint R_1305 foreign key ( DEVICECLASSID) references MBTA.DEVICECLASS(DEVICECLASSID) deferrable );

Alter table MBTA.PAYMENTRECEIPT add (constraint R_1250 foreign key ( DEVICECLASSID,DEVICEID) references MBTA.TVMTABLE(DEVICECLASSID,TVMID) deferrable );

Alter table MBTA.SCHEDULEGROUP add (constraint R_1282 foreign key ( JOBIDREF) references MBTA.JOBTABLE(JOBID) deferrable );

Alter table MBTA.TVMFEPGROUP add (constraint R_1253 foreign key ( FEPGATEWAY) references MBTA.FEPDATA(FEPID) deferrable );

Alter table MBTA.TVMTABLE add (constraint R_1297 foreign key ( TVMMANUALVERSIONGROUPID) references MBTA.TVMVERSIONGROUP(TVMVERGROUPID) deferrable );


drop materialized view mbta.TVMSCHEDULEGROUPELEMENTS



