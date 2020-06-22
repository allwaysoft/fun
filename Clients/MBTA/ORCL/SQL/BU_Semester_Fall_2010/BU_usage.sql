select /*+ parallel(sd, 2) */
bu_serialno, 
to_Char(sd.creadate,'MM/DD/YYYY HH24:MI:SS') as createdate, 
sd.Deviceclassid, 
sd.deviceid, 
sd.Machinebooking , 
sd.cancellation,
decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1,0) as test,
sd.fareoptamount,
decode (sd.deviceclassid,501,trunc(sd.branchlineid/10,0),'') as route, 
sd.branchlineid,
ts.nameshort as stationname
from mbta_temp_bu_usage,
       salesdetail sd,
       tvmtable tvm,
       tvmstation ts
where 1=1
    and sd.ticketserialno = bu_serialno
    and tvm.tvmid    (+) = sd.deviceid
    and ts.stationid   (+) = tvm.tvmtarifflocationid
    and sd.ticketstocktype = 5 
    and sd.creadate(+) >= to_date('2010-09-01-01-00-00','YYYY-MM-DD-HH24-MI-SS') 
    and sd.creadate (+) <= to_date('2010-11-30-02-59-59','YYYY-MM-DD-HH24-MI-SS')
    and sd.partitioningdate(+) >=  to_date('2010-09-01-00-00-00','YYYY-MM-DD-HH24-MI-SS')        
    and sd.productionunsure <> 1
order by sd.ticketserialno, 
            to_Char(sd.creadate,'MM/DD/YYYY HH24:MI:SS')