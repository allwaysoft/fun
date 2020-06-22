Alter table MBTA.SCHEDULEGROUP drop constraint R_1282;    
Alter table MBTA.TVMFEPGROUP drop constraint R_1253;                                                
Alter table MBTA.TVMTABLE drop constraint R_1297;                                                   
Alter table MBTA.PAYMENTRECEIPT drop constraint R_1250;
Alter table MBTA.EXPORTBALANCEGROUP drop constraint R_1251;
Alter table MBTA.ITSO_DEVICE_ISAM_MAPPING drop constraint R_1259;
Alter table MBTA.IMPORTVERSIONLINKLIST drop constraint R_1303;
Alter table MBTA.MASTERASSEMBLYDEVICECLASS drop constraint R_1305;



Alter table MBTA.SCHEDULEGROUP add (constraint R_1282 foreign key ( JOBIDREF) references MBTA.JOBTABLE(JOBID) deferrable );
Alter table MBTA.TVMFEPGROUP add (constraint R_1253 foreign key ( FEPGATEWAY) references MBTA.FEPDATA(FEPID) deferrable ); 
Alter table MBTA.TVMTABLE add (constraint R_1297 foreign key ( TVMMANUALVERSIONGROUPID) references MBTA.TVMVERSIONGROUP(TVMVERGROUPID) deferrable );     
ALTER TABLE MBTA.PAYMENTRECEIPT ADD (  CONSTRAINT R_1250  FOREIGN KEY (DEVICECLASSID, DEVICEID)  REFERENCES MBTA.TVMTABLE (DEVICECLASSID,TVMID) deferrable );
ALTER TABLE MBTA.EXPORTBALANCEGROUP ADD (  CONSTRAINT R_1251  FOREIGN KEY (BALANCEGROUPID)  REFERENCES MBTA.BALANCEGROUP (BALANCEGROUPID) deferrable );
ALTER TABLE MBTA.ITSO_DEVICE_ISAM_MAPPING ADD (CONSTRAINT R_1259 FOREIGN KEY (DEVICECLASSID, DEVICEID) REFERENCES MBTA.TVMTABLE (DEVICECLASSID,TVMID) deferrable );
ALTER TABLE MBTA.IMPORTVERSIONLINKLIST ADD (  CONSTRAINT R_1303  FOREIGN KEY (VERSIONID)  REFERENCES MBTA.VERSIONS (VERSIONID) deferrable );
ALTER TABLE MBTA.MASTERASSEMBLYDEVICECLASS ADD (  CONSTRAINT R_1305  FOREIGN KEY (DEVICECLASSID)  REFERENCES MBTA.DEVICECLASS (DEVICECLASSID) deferrable );







-- taken out from rgroup1 fundspool, FUNDSPOOLTVMRELATION                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      



