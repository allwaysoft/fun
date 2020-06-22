select StationName,
    DeviceClass,
    DeviceClassID,
    DeviceID,
    EventTime,
    EventRef,
    EventText,
    EventDesc,
    ServIDNo,
    TVMSpecialRecord1,
    Running_No  -- this line is coded to avoid missing events on report in case that same event was send at the same date/time from one device 23.11.01   
from
(
select    ' ' || sta.NameShort    "STATIONNAME",
    cla.Description    "DEVICECLASS",
    tvm.DeviceClassID,
    tvm.TvmID    "DEVICEID",
    hist.EventTime,
    hist.EventRef,
    ' ' || evt.EventText    "EVENTTEXT",
    evt.EventDesc,
    hist.ServIDNo,
    hist.TVMSpecialRecord1,
    hist.EventHistoryId    "RUNNING_NO"    -- this line is coded to avoid missing events on report in case that same event was send at the same date/time from one device   23.11.01         

from    TvmTable    tvm,
    DeviceClass    cla,
    TvmStation    sta,
    EventHistory    hist,
    Event        evt

where    cla.DeviceClassID    = tvm.DeviceClassID
and    sta.StationID    = tvm.TvmTariffLocationID
and    hist.DeviceClassID    = tvm.DeviceClassID
and    hist.TvmRef    = tvm.TvmID 
and    evt.EventID(+)    = hist.EventRef
and    hist.EventTime    >= :P_DateFirst
and    hist.EventTime    <= :P_DateLast    -- removed 23.11.01    
--and    hist.EventTime    <= :P_DateLast+1    -- inserted 23.11.01 (to enable report if parameter for start and end have the same value)
and    &P_Where

union

select    ' ' || sta.NameShort    "STATIONNAME",
    cla.Description    "DEVICECLASS",
    tvm.DeviceClassID,
    tvm.TvmID    "DEVICEID",
    open.EventTime,
    open.EventRef,
    ' ' || evt.EventText    "EVENTTEXT",
    evt.EventDesc,
    open.ServIDNo,
    open.TVMSpecialRecord1,
    open.OpenAlarmId     "RUNNING_NO"    -- this line is coded to avoid missing events on report in case that same event was send at the same date/time from one device 23.11.01
from TvmTable    tvm,
    DeviceClass    cla,
    TvmStation    sta,
    OpenAlarm    open,
    Event        evt
where  cla.DeviceClassID    = tvm.DeviceClassID
and    sta.StationID    = tvm.TvmTariffLocationID
and    open.DeviceClassID= tvm.DeviceClassID
and    open.TvmRef    = tvm.TvmID 
and    evt.EventID(+)    = open.EventRef
and    open.EventTime    >= :P_DateFirst
and    open.EventTime    <= :P_DateLast    -- removed 23.11.01
--and    open.EventTime    <= :P_DateLast+1    -- inserted 23.11.01 (to enable report if parameter for start and end have the same value)
--and    &P_Where
)
order by    &P_OrderBy