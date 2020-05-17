set timing on
ALTER SESSION SET TRACEFILE_IDENTIFIER = 'kran_parallel';
ALTER SESSION SET SQL_TRACE = TRUE; 
SELECT
/*+
ORDERED
INDEX        (sub    XIE1SalesDetail)
USE_HASH    (sd)
USE_HASH    (sub)        
USE_HASH    (mcm)
USE_HASH    (st)
USE_HASH    (ms)
USE_HASH    (hol)
parallel(sd 2)
parallel(sub 2)
parallel(mcm 2)
parallel(st 2)
parallel(ms 2)
FULL        (sd)
FULL        (mcm)
FULL        (st)
FULL        (ms)        
USE_NL        (rou)
USE_NL        (tvm)
USE_NL        (sta)
*/
rou.routeid         line_id--Line Id
,sta.stationid        station_id--Station Id
,rou.Description    line_name              --Line
,sta.Name          station_name                              --    Station
,count(1) Cnt
FROM
SalesDetail               sd
,SalesDetail               sub
,MiscCardMovement   mcm
,SalesTransaction       st
,Mainshift                  ms
,Routes                    rou
,TVMTable                tvm
,tvmStation               sta
WHERE        1=1
AND    sub.DeviceClassId       (+)    = sd.DeviceClassId
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
AND    mcm.CorrectionCounter        = sd.CorrectionCounter
AND    mcm.PartitioningDate        = sd.PartitioningDate
AND    mcm.TimeStamp                = sd.CreaDate
AND   st.DeviceID =  mcm.DeviceID         
AND   st.DeviceClassID =  mcm.DeviceClassID        
AND    st.UniqueMSID = mcm.UniqueMSID                
AND    st.SalesTransactionNo =  mcm.SalesTransactionNo     
AND    st.PartitioningDate = mcm.PartitioningDate     
AND    ms.DeviceClassId    =    st.DeviceClassId
AND    ms.DeviceId            =    st.DeviceId
AND    ms.Uniquemsid        =    st.Uniquemsid
AND    ms.EndCreaDate        =    st.PartitioningDate
AND    tvm.TVMID            =    ms.DeviceID
AND    tvm.DeviceClassID    =    ms.DeviceClassID
AND    sta.StationID     (+)    =    tvm.TVMTariffLocationID
AND    rou.RouteID         =    ms.RouteNo
AND    mcm.MovementType    IN     (7,20)
AND    sd.ArticleNo                >     100000
AND    sd.CorrectionFlag            =     0
AND    sd.RealStatisticArticle        =     0
AND    sd.TempBooking                =     0
AND    sd.ArticleNo                <>     607900100
AND    sub.ArticleNo            (+)    =    607900100
AND    st.TestSaleFlag                =     0
AND    rou.routeid in 
(
1400,    
1200,    
1000,    
1300,    
1100    
)  
AND    sd.CreaDate            >= to_date('2008-02-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
AND    sd.CreaDate            <= to_date('2008-03-01-02-59-59','YYYY-MM-DD-HH24-MI-SS')
AND    sd.PartitioningDate    >= to_date('2008-02-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
AND    sd.PartitioningDate    <  to_date('2008-04-01-00-00-00','YYYY-MM-DD-HH24-MI-SS')
/*
AND    sd.CreaDate            >= to_date('2009-07-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
AND    sd.CreaDate            <= to_date('2009-08-01-02-59-59','YYYY-MM-DD-HH24-MI-SS')
AND    sd.PartitioningDate    >= to_date('2009-07-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
AND    sd.PartitioningDate    <  to_date('2009-09-01-00-00-00','YYYY-MM-DD-HH24-MI-SS')
AND    1=1    
*/
GROUP BY rou.routeid, sta.stationid, rou.Description, sta.Name;
ALTER SESSION SET SQL_TRACE = FALSE
/