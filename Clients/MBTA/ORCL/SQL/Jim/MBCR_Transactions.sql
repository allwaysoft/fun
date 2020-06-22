select * from person


select  sta.stationid, rou.routeid, sta.name, rou.description, tvm.DeviceClassID DeviceClassId, tvm.TVMID DeviceId
from 
TVMTable					tvm
,Routes						rou
,TVMStation					sta
where sta.StationID 	=	tvm.TVMTariffLocationID
  AND rou.RouteID	 =	tvm.RouteID
  and (rou.routeid = 9996 and (sta.stationid in(1080,1009,1075)) or (rou.routeid = 1500))
  
select  sta.stationid, rou.routeid, sta.name, rou.description, tvm.DeviceClassID DeviceClassId, tvm.TVMID DeviceId
from 
TVMTable                    tvm
,Routes                        rou
,TVMStation                    sta
where sta.StationID     =    tvm.TVMTariffLocationID
  AND rou.RouteID     =    tvm.RouteID
  and (rou.routeid = 9996 and (sta.stationid in(1080,1009,1075)) or (rou.routeid = 1500))
  
  
  
  	AND tvm.DeviceClassID			= 	st.DeviceClassID
	AND tvm.TVMID					=	st.DeviceID
  
select * from routes
9996      	Retail Sales Terminals
1500	      Worcester Commuter Rail Line
  
  
select * from tvmstation
1080	       Back Bay
1009	       South Station
1075	       North Station

select * from tvmtable

select tvm.DeviceClassID DeviceClassId, tvm.TVMID DeviceId, count(1)
from tvmtable tvm
group by  tvm.DeviceClassID , tvm.TVMID 
order by count(1) desc