select /*+ use_hash(msh) use_hash(evt)  index(evt XIE2SHIFTEVENT)*/
    tvm.TvmID    DEVICEID,
    trunc(evt.Creadate) creadate,
    evt.EventCode,
    event.EventText,
    count(1)
from TvmTable    tvm,
     ShiftEvent  evt,     
     MainShift   msh,  
     Event
where 1=1    
and    evt.DeviceClassID = tvm.DeviceClassID
and    evt.DeviceID = tvm.TvmID 
and    msh.DeviceClassID = evt.DeviceClassID
and    msh.DeviceID = evt.DeviceID
and    msh.UniqueMSID = evt.UniqueMSID
and    msh.EndCreaDate = evt.PartitioningDate
and    event.EventID (+)    = evt.EventCode 
and    evt.Creadate >= to_date('2010-08-01-00-00-00','YYYY-MM-DD-HH24-MI-SS')
and    evt.Creadate <= to_date('2010-09-01-00-00-00','YYYY-MM-DD-HH24-MI-SS')
and    evt.PartitioningDate >= to_date('2010-08-01-00-00-00','YYYY-MM-DD-HH24-MI-SS')
--and    msh.UniqueMSID    = 48 
and &P_Where
group by tvm.TvmID,
    trunc(evt.Creadate) ,
    evt.EventCode,
    event.EventText
order by tvm.TvmID, evt.Creadate, evt.EventCode
