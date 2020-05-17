sSql = SELECT sta.NAME Station, rou.Description Route, cla.description DeviceClass, tvm.deviceclassid deviceclassid, 
        Sum(Decode(State.Status,1,1,0)) FullService, Sum(Decode(State.Status,6,1,5,1,4,1,3,1,0)) ReducedService, 
        Sum(Decode(State.Status,2,1,0)) OfLine, Sum(Decode(State.Status,8,1,7,1,0)) OutOfService, Count(*) Quantity, 
        Decode(Sum(Decode(State.Status,1,1,0)),0,0,(Sum(Decode(State.Status,1,1,0))/Count(*)) * 100) PercFullService,
        1 Counter 
        From (SELECT DeviceClassID, DeviceID, Max(Decode(AssStatus,3,8,2,7,1,6,4,5,6,4,5,3,7,2,0,1,-1)) Status 
                     From Assembly Where 1=1 
                     GROUP BY DeviceClassID, DeviceID
                 ) State,
                 deviceclass cla, 
                 TVMTable tvm, 
                 TVMStation sta, 
                 Routes rou 
        Where State.DeviceID = tvm.TVMID AND state.DeviceClassID = tvm.DeviceClassID 
        AND cla.DeviceClassID = tvm.deviceclassid and sta.StationID = tvm.TVMTariffLocationID 
        AND rou.RouteID = tvm.RouteID AND tvm.fieldstate=1 and tvm.deviceclassid in (202,201,441,411,1101)
        Group By sta.NAME, rou.Description, cla.description,tvm.deviceclassid
        
        
        
        
SELECT sta.stationid stationId,tvm.deviceclassid DeviceclassId,tvm.TVMID DeviceId, state.assno assId,sta.NAME Station, 
            cla.Description DeviceClass, tvm.tvmabbreviation device,State.ass_desc AssDesc,Decode(State.Status,1,1,0) FullService, 
            Decode(State.Status,6,1,5,1,4,1,3,1,0) ReducedService, Decode(State.Status,2,1,0) OfLine, Decode(State.Status,8,1,7,1,0) OutOfService, 
            Decode(DSta.DevSta, 8, 'OUT', 7,'OUT', 6, 'RED', 5, 'RED', 4, 'RED', 3, 'RED', 2, 'OFF', 1, 'FULL', -1, 'N/A' ) devsta
From (SELECT AssNo, DeviceClassID, DeviceID, (select description from masterassembly ma where subassno = 0 and ma.assno = a.assno) ass_desc, 
            Decode(AssStatus,3,8,2,7,1,decode(lastassstatus,46340,1,8),4,5,6,4,5,3,7,2,0,1,-1) Status 
            From Assembly a Where a.deviceclassid in (202,201,441,411)
         ) State,
         (select  DeviceClassID, DeviceID, max(decode(AssStatus,3,8,2,7,1,decode(lastassstatus,46340,1,8),4,5,6,4,5,3,7,2,0,1,-1)) DevSta 
            from assembly 
            where deviceclassid in (202,201,441,411)
            group by DeviceClassID, DeviceID
         ) DSta,
         TVMTable tvm,
         deviceclass cla, 
         TVMStation sta,
         Routes rou
Where tvm.TVMID = State.DeviceID
AND tvm.deviceclassid = State.deviceclassid
AND State.DeviceID = DSta.DeviceID
AND State.deviceclassid = DSta.deviceclassid
AND cla.deviceclassid = tvm.deviceclassid
AND sta.StationID = tvm.TVMTariffLocationID 
AND rou.RouteID = tvm.RouteID
AND tvm.fieldstate=1
AND tvm.deviceclassid in (202,201,441,411)






Ful
Out
Red
Off
N/A
                3,8    Out    Intrusion -- Out of Service
                2,7    Out    -- Error                    -- Out of Service
                1,6    Full, Out    -- Warning                  -- Reduced Service
                4,5    Red    -- Unknown, not connected   -- Reduced Service
                6,4    Red    -- Out of resource          -- Reduced Service
                5,3    Red    -- Removed                  -- Reduced Service
                7,2    Off    -- Offline                  -- Offline
                0,1    Ful    -- OK                       -- Full Service
                 -1    N/A