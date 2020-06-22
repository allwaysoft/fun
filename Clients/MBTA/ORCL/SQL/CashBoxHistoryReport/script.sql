---------------
delete from reportparameter where listid = 99990
/
delete from reportparameter where listid = 99991
/

insert into reportparameter
------------
select distinct 99990, tvmid, '', tvmabbreviation, 4711, sysdate  
from tvmstation sta, tvmtable tvm, cashboxmovement cbm
where sta.StationID    = tvm.TVMTariffLocationID
and cbm.deviceid       = tvm.tvmid
and cbm.deviceclassid  = tvm.deviceclassid
and cbm.mancorrstatus  = 1
and cbm.boxoutrecvaultdatetime is null
and tvm.deviceclassid  in (501,502) 
and cbm.BOXREMDATETIME > To_Date('11/07/2012','mm/dd/yyyy') 
and cbm.BOXREMDATETIME < To_Date('11/08/2012','mm/dd/yyyy')
and sta.stationid in (13)
--and upper(sta.nameshort) = 'ARBORWAY GARAGE'
----
UNION ALL
----
select 99991, stationid, '', nameshort, 4711, sysdate 
from tvmstation 
where stationtype=1
--
and stationid in (13)
--and nameshort in (Riverside Garage,Reservoir Garage)
------------
/

commit
/

exit;
---------------