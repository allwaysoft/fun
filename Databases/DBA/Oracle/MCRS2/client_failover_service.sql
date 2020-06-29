SQL> exec dbms_service.create_service('fap1.mbta.com','fap1.mbta.com');
SQL> exec dbms_service.create_service('fap2.mbta.com','fap2.mbta.com');

exec dbms_service.start_service('fap1.mbta.com');

exec dbms_service.stop_service('fap1.mbta.com');
exec dbms_service.stop_service('fap2.mbta.com');

exec dbms_service.delete_service('fap1.mbta.com');
exec dbms_service.delete_service('fap2.mbta.com');

CREATE OR REPLACE TRIGGER MBTA_START_DG_SERVICE after startup on database
DECLARE
  db_role VARCHAR(30);
  db_open_mode VARCHAR(30);
BEGIN
  SELECT DATABASE_ROLE, OPEN_MODE INTO db_role, db_open_mode FROM V$DATABASE;
  IF db_role = 'PRIMARY' 
  THEN 
  DBMS_SERVICE.START_SERVICE('fap1.mbta.com'); 
  DBMS_SERVICE.STOP_SERVICE('fap2.mbta.com'); 
  END IF;
  IF db_role = 'PHYSICAL STANDBY' AND db_open_mode LIKE 'READ ONLY%' 
  THEN 
  DBMS_SERVICE.START_SERVICE('fap2.mbta.com'); 
  DBMS_SERVICE.STOP_SERVICE('fap1.mbta.com'); 
  END IF;
END;
/ 

alter system switch logfile;

drop trigger MBTA_START_DG_SERVICE;
/

FAP =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (FAILOVER = ON)
      (LOAD_BALANCE = OFF)
      (ADDRESS = (PROTOCOL = TCP)(HOST = hseax15.mbta.com)(PORT = 1521))
      (ADDRESS = (PROTOCOL = TCP)(HOST = hseax16.mbta.com)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = fap1.mbta.com)
    )
  )
  
FAP_STB =
  (DESCRIPTION =
    (ADDRESS_LIST =
      (FAILOVER = ON)
      (LOAD_BALANCE = OFF)
      (ADDRESS = (PROTOCOL = TCP)(HOST = hseax15.mbta.com)(PORT = 1521))
      (ADDRESS = (PROTOCOL = TCP)(HOST = hseax16.mbta.com)(PORT = 1521))
    )
    (CONNECT_DATA =
      (SERVICE_NAME = fap2.mbta.com)
    )
  )  
  
---------------------------
OR, we can do below but doing below was not successful. got error as below.
PRCD-1026 : Failed to create service fap1.mbta.com for database fapa
PRKH-1014 : Current user "grid" is not the oracle owner user "oracle" of oracle home "/u01/app/oracle/product/11.2.0/db_1"
---------------------------
  
On primary:
[oracle@vmOraLinux6 ~]$ srvctl add service -d fapa -s fap1.mbta.com -l PRIMARY -e SESSION -m BASIC -w 10 -z 10

On standby:
[oracle@vmOraLinux6 ~]$ srvctl add service -d fapb -s fap1.mbta.com -l PRIMARY -e SESSION -m BASIC -w 10 -z 10  

On Primary
srvctl start service -d ora.fapa -s prim_db


On primary:
[oracle@vmOraLinux6 ~]$ srvctl add service -d ora.fapa.db -s fap2.mbta.com -l PHYSICAL_STANDBY -e SESSION -m BASIC -w 10 -z 10

On standby:
[oracle@vmOraLinux6 ~]$ srvctl add service -d ora.fapa.db -s fap2.mbta.com -l PHYSICAL_STANDBY -e SESSION -m BASIC -w 10 -z 10

On Primary
EXECUTE DBMS_SERVICE.CREATE_SERVICE (service_name=>'stby_db',network_name=>'stby_db',failover_method=>'BASIC',failover_type=>'SESSION',failover_retries=>10,failover_delay=>10);
SQL> select thread#, sequence# from v$log where status = 'CURRENT';
SQL> alter system archive log current;

On Standby
srvctl start service -d ora.fapa.db -s stby_db