-- under 10 mins for one month in production AFC
SELECT /*+ index(sd, XIE5SALESDETAIL) index(sd, XIE7SALESDETAIL) */ 
POLICE_ID, POLICE_SERIALNO, Replace(POLICE_NAME, ',', ' ') Police_Name, sta.stationid, sta.name Staion_Name, sd.creadate Create_Date
FROM mbta_temp_police_information mtpi
,SalesDetail               sd
,SalesDetail               sub
,MiscCardMovement   mcm
,SalesTransaction       st
,TVMTable                 tvm
,tvmStation                sta
WHERE  sd.ticketserialno = mtpi.POLICE_SERIALNO
AND sub.DeviceClassId       (+)    = sd.DeviceClassId
AND    sub.DeviceId               (+)    = sd.DeviceId
AND    sub.Uniquemsid             (+)    = sd.Uniquemsid
AND    sub.SalestransactionNo    (+)    = sd.SalesTransactionNo
AND    sub.SalesDetailEvSequNo    (+)    = sd.SalesDetailEvSequNo    +1
AND    sub.CorrectionCounter    (+)    = sd.CorrectionCounter
AND    sub.PartitioningDate    (+)    = sd.PartitioningDate
AND    mcm.DeviceClassId           = sd.DeviceClassId
AND    mcm.DeviceId                   = sd.DeviceId
AND    mcm.Uniquemsid                 = sd.Uniquemsid
AND    mcm.SalestransactionNo        = sd.SalesTransactionNo
AND    mcm.SequenceNo                = Decode    (sub.SalesDetailEvSequNo
                                                    ,NULL    ,sd.SalesDetailEvSequNo
                                                ,sub.SalesDetailEvSequNo
                                                )
AND  mcm.CorrectionCounter        = sd.CorrectionCounter
AND  mcm.PartitioningDate        = sd.PartitioningDate
AND  mcm.TimeStamp                = sd.CreaDate
AND  st.DeviceID =  mcm.DeviceID         
AND  st.DeviceClassID =  mcm.DeviceClassID        
AND  st.UniqueMSID = mcm.UniqueMSID                
AND  st.SalesTransactionNo =  mcm.SalesTransactionNo     
AND  st.PartitioningDate = mcm.PartitioningDate     
AND  tvm.TVMID            =    st.DeviceID
AND  tvm.DeviceClassID    =    st.DeviceClassID
AND  sta.StationID     (+)    =    tvm.TVMTariffLocationID

AND  mcm.MovementType   IN     (7)
AND  sd.ArticleNo                >     100000
AND  sd.CorrectionFlag        =     0
AND  sd.RealStatisticArticle  =     0
AND  sd.TempBooking         =     0
AND  sd.ArticleNo                <>     607900100
AND  sd.ticketstocktype        = 5
AND  sub.ArticleNo         (+) =    607900100
AND  st.TestSaleFlag           =     0
AND sd.CreaDate >= to_date('2010-10-01-00-00-00', 'YYYY-MM-DD-HH24-MI-SS') 
AND sd.CreaDate <= to_date('2010-11-01-00-00-00', 'YYYY-MM-DD-HH24-MI-SS') 
AND sd.PartitioningDate >= to_date('2010-10-01-00-00-00', 'YYYY-MM-DD-HH24-MI-SS') 
AND sd.PartitioningDate < to_date('2010-12-01-00-00-00', 'YYYY-MM-DD-HH24-MI-SS') 
ORDER BY POLICE_ID, POLICE_SERIALNO, POLICE_NAME, sta.stationid, sta.name, sd.creadate


/*
            AND sd.CreaDate >= :dDateFirst
            AND sd.CreaDate <= :dDateLast
            AND sd.PartitioningDate >= :dPartitioningDateFirst
            AND sd.PartitioningDate < :dPartitioningDateLast
--AND s.productionunsure <> 1
*/