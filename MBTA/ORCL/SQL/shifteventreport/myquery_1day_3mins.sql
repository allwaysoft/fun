select /*+ use_hash(msh) use_hash(evt)  index(evt XIE2SHIFTEVENT)*/
    tvm.TvmID    "DEVICEID",
    trunc(evt.Creadate) "Event Date",
    evt.EventCode,
    event.EventText "Event Desc",
    count(1)
from    TvmTable    tvm,
    --DeviceClass    cla,
    --TvmStation    sta,
    ShiftEvent    evt,     
    MainShift        msh,  
    Event
where 1=1    
/*
cla.DeviceClassID    = tvm.DeviceClassID
and    sta.StationID    = tvm.TvmTariffLocationID
*/
and    evt.DeviceClassID = tvm.DeviceClassID
and    evt.DeviceID = tvm.TvmID 
and    msh.DeviceClassID = evt.DeviceClassID
and    msh.DeviceID = evt.DeviceID
and    msh.UniqueMSID = evt.UniqueMSID
and    msh.EndCreaDate = evt.PartitioningDate
and    event.EventID (+)    = evt.EventCode 
and    evt.Creadate >= to_date('2010-09-13-00-00-00','YYYY-MM-DD-HH24-MI-SS')
and    evt.Creadate <= to_date('2010-09-14-00-00-00','YYYY-MM-DD-HH24-MI-SS')
and    evt.PartitioningDate >= to_date('2010-09-13-00-00-00','YYYY-MM-DD-HH24-MI-SS')

--and    msh.UniqueMSID    = 48 
--and &P_Where

group by tvm.TvmID,
    trunc(evt.Creadate) ,
    evt.EventCode,
    event.EventText
    
--order by &P_OrderBy

------------------------------------------------------------------------
------------------------South Station Gate Usage------------------------
-------------------requested by Tom Humphrey Dec 2012-------------------
------------------------------------------------------------------------

select   /*+ ORDERED INDEX(msh XPKMAINSHIFT) INDEX(evt XIE1SHIFTEVENT) */ 
    ' ' || sta.NameShort    "STATIONNAME",
    cla.Description    "DEVICECLASS",
    tvm.DeviceClassID,
    tvm.TvmID    "DEVICEID",
    evt.Creadate,
    evt.EventCode,
    --msh.UniqueMSID,
    event.EventText--,
    --count(1)
    --EventDesc,
    --evt.eventsequno,
    --evt.EventRelatedData,
    --evt.EmployeeNo    l
from TvmStation     sta,
     TvmTable       tvm,
     DeviceClass    cla,
     MainShift      msh,
     Event,
     ShiftEvent     evt
where sta.StationID      = tvm.TvmTariffLocationID  
and   cla.DeviceClassID  = tvm.DeviceClassID   
and   msh.DeviceClassID  = tvm.DeviceClassID
and   msh.DeviceID       = tvm.TvmID 
and   msh.DeviceClassID  = evt.DeviceClassID
and   msh.DeviceID       = evt.DeviceID 
and   msh.UniqueMSID     = evt.UniqueMSID
and   msh.EndCreaDate    = evt.PartitioningDate 
and   event.EventID(+)   = evt.EventCode 
and   sta.stationid = 1009
and   tvm.DeviceClassID IN (441,411)
and   evt.Creadate >= to_date('2012-11-13-00-00-00','YYYY-MM-DD-HH24-MI-SS')
and   evt.Creadate <= to_date('2012-11-14-00-00-00','YYYY-MM-DD-HH24-MI-SS')
and   evt.PartitioningDate >= to_date('2012-11-13-00-00-00','YYYY-MM-DD-HH24-MI-SS')
--group by ' ' || sta.NameShort,
  --  cla.Description,
    --tvm.DeviceClassID,
    --tvm.TvmID,
    --evt.Creadate,
    --evt.EventCode,
    --event.EventText
    --msh.Uniq