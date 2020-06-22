select 
    tvm.TvmID    "DEVICEID",
    trunc(evt.Creadate) "Event Date",
    evt.EventCode,
    event.EventText "Event Desc",
    count(1)
from    TvmTable    tvm,
    --DeviceClass    cla,
    --TvmStation    sta,
    MainShift        msh,
    ShiftEvent    evt,   
    Event
where 1=1    
/*
cla.DeviceClassID    = tvm.DeviceClassID
and    sta.StationID    = tvm.TvmTariffLocationID
*/
and    msh.DeviceClassID    = tvm.DeviceClassID
and    msh.DeviceID    = tvm.TvmID 
and    evt.DeviceClassID = msh.DeviceClassID
and    evt.DeviceID = msh.DeviceID 
and    evt.UniqueMSID = msh.UniqueMSID
and    evt.PartitioningDate = msh.EndCreaDate
and    event.EventID(+)    = evt.EventCode 
and    evt.Creadate    >= to_date('2010-10-13-00-00-00','YYYY-MM-DD-HH24-MI-SS')
and    evt.Creadate    <= to_date('2010-10-14-00-00-00','YYYY-MM-DD-HH24-MI-SS')
and    evt.PartitioningDate    >= to_date('2010-10-13-00-00-00','YYYY-MM-DD-HH24-MI-SS')

--and    msh.UniqueMSID    = 48 
--and &P_Where

group by tvm.TvmID,
    trunc(evt.Creadate) ,
    evt.EventCode,
    event.EventText
    
--order by &P_OrderBy


