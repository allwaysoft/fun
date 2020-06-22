select distinct(a.MVIEW_SITE)--, b.MVIEW_LAST_REFRESH_TIME 
from dba_registered_mviews a, dba_base_table_mviews b
where 1=1 
and b.MVIEW_LAST_REFRESH_TIME < sysdate-1 
and a.mview_id=b.mview_id
  
  
select scabbreviation SC_abbreviation, sclocation2 SC_location, scnetaddr SC_ip from stationcontroller

select * from stationcontroller

NWCD.GCS19
NWCD.STA10116

  
select * from dba_registered_mviews


select * from dba_base_table_mviews


select view_name from dba_views where view_name like 'DBA_%MVIEW%'


create table mbta_temp_stationcontrollers
(
host_name      varchar2(20),
global_db_name varchar2(20),
host_ip        varchar2(20)
)


ALTER TABLE MBTA.mbta_temp_stationcontrollers ADD (
  CONSTRAINT XPK1
  PRIMARY KEY (host_ip) ENABLE VALIDATE);
  

alter table mbta_temp_stationcontrollers rename to mbta_temp_stationcontroller
  
--update mbta_temp_stationcontrollers set global_db_name = ltrim(rtrim(global_db_name)), host_ip=ltrim(rtrim(host_ip))

select * from mbta_temp_stationcontroller



select s1.scabbreviation server_name, s1.sclocation2 location, s1.SCNETADDR server_ip, S2.GLOBAL_DB_NAME db_name, 
       'Microsoft Windows Server 2003 Standard Edition, Service Pack 2' OS_Version, 
       'Oracle9i Release 9.2.0.1.0 - Production' DB_Version
--, S2.host_ip , dbl.db_link, dbl.host dblin_host 
from stationcontroller s1, mbta_temp_stationcontroller s2--, dba_db_links dbl
where S1.SCNETADDR = S2.HOST_IP(+)
--and  dbl.host(+) = S2.GLOBAL_DB_NAME

Oracle9i Release 9.2.0.1.0 - Production

select * from v$version


select s1.scabbreviation, s1.sclocation2, s1.SCNETADDR, S2.GLOBAL_DB_NAME, S2.host_ip 
from stationcontroller s1, mbta_temp_stationcontroller s2--, dba_db_links dbl
where S1.SCNETADDR(+) = S2.HOST_IP
and s1.scnetaddr is null


select --s1.scabbreviation, s1.sclocation2, s1.SCNETADDR, 
       S2.GLOBAL_DB_NAME, S2.host_ip , 
       dbl.db_link, dbl.host dblin_host 
from --stationcontroller s1, 
     mbta_temp_stationcontroller s2, 
     dba_db_links dbl
where 1=1 
--and S1.SCNETADDR = S2.HOST_IP(+)
and  dbl.host = S2.GLOBAL_DB_NAME (+)

and s2.global_db_name is null


172.17.187.20

select * from stationcontroller

select * from mbta_temp_stationcontroller

select * from dba_db_links


select * from global_name@NWCD.STA1036

select * from v$version@NWCD.STA1036  

SELECT UTL_INADDR.get_host_name FROM v$instance@NWCD.STA1036

SELECT UTL_INADDR.get_host_address from dual@NWCD.STA1036

select utl_inaddr.get_host_address(host_name), host_name from v$instance@NWCD.STA1036

select * from v$database





select * from dba_views where view_name like '%LINK%';

select * from user_db_links


select * from sys.V_$DBLINK

select * from sys.GV_$DBLINK


select * from ORA_KGLR7_DB_LINKS

select * from sys.KU$_DBLINK_VIEW

select * from sys.KU$_TRLINK_VIEW