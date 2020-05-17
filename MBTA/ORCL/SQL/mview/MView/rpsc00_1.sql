-- Connect as MBTA and drop the constraints. This helps in removing all the existing Mviews from the site so that it is ready for the fresh.

CONNECT mbta/hallo@mvdb

Alter table MBTA.SCHEDULEGROUP drop constraint R_1282;    
Alter table MBTA.TVMFEPGROUP drop constraint R_1253;                                                
Alter table MBTA.TVMTABLE drop constraint R_1297;                                                   
Alter table MBTA.PAYMENTRECEIPT drop constraint R_1250;
Alter table MBTA.EXPORTBALANCEGROUP drop constraint R_1251;
Alter table MBTA.ITSO_DEVICE_ISAM_MAPPING drop constraint R_1259;
Alter table MBTA.IMPORTVERSIONLINKLIST drop constraint R_1303;
Alter table MBTA.MASTERASSEMBLYDEVICECLASS drop constraint R_1305;
/