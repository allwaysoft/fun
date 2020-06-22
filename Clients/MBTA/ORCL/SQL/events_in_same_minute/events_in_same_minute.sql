select t1.station_id, t1.station_name, t1.device_class_id, t1.DEVICE_ID, t1.sdt_id
     , t1.prev_sdt_id, t1.event_id, t1.prev_event_id, t1.event_time, t1.prev_event_time from
(
select sta.stationid station_id,   
    sta.NameShort station_name,
    tvm.DeviceClassID device_class_id,
    tvm.TvmID    DEVICE_ID,
    sta.stationid || tvm.DeviceClassID || tvm.TvmID sdt_id,
    lag (sta.stationid || tvm.DeviceClassID || tvm.TvmID, 1, 0) OVER (ORDER BY sta.stationid || tvm.DeviceClassID || tvm.TvmID , hist.EventTime, hist.EventRef) prev_sdt_id ,
    hist.EventRef event_id,
    lag(hist.EventRef, 1, 0) OVER (ORDER BY sta.stationid || tvm.DeviceClassID || tvm.TvmID , hist.EventTime, hist.EventRef) prev_event_id,
    hist.EventTime event_time,
    lag(hist.EventTime, 1, sysdate+1000) OVER (ORDER BY sta.stationid || tvm.DeviceClassID || tvm.TvmID , hist.EventTime, hist.EventRef) prev_event_time
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
and    hist.EventTime    >= To_Date('2012-07-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')--:P_DateFirst
and    hist.EventTime    <= To_Date('2012-08-01-02-59-59', 'YYYY-MM-DD-HH24:MI:SS')
and    CLA.DEVICECLASSID in (441,411,442)
and    hist.eventref in (50184, 50186)
)t1
where 1=1
and t1.event_id <> t1.prev_event_id
and (T1.event_time - t1.prev_event_time)*24*60 <= 1
and t1.sdt_id=t1.prev_sdt_id 