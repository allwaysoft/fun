set autotrace traceonly explain

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
        parallel(sd 4)
        parallel(sub 4)
        parallel(mcm 4)
        parallel(st 4)
        parallel(ms 4)
        FULL        (sd)
        FULL        (mcm)
        FULL        (st)
        FULL        (ms)        
        USE_NL        (rou)
        USE_NL        (tvm)
        USE_NL        (sta)
    */
  sta.Name                                                                    --    Station
  ,sum(decode(hol.service_date, null, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 )) "WD COUNT"                                          --weekdays Count
    ,round((sum(decode(hol.service_date, null, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 )))/22) "WD AVG"                                          --weekdays Count
  ,sum(decode(hol.service_type, 2, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 ))    "SA COUNT"                                          --Saturday Count
  ,round(sum(decode(hol.service_type, 2, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 ))/4)    "SA AVG"                                          --Saturday Count                                                                
  ,sum(decode(hol.service_type, 3, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 ))    "SU COUNT"                                          --Sunday Count
  ,round(sum(decode(hol.service_type, 3, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 ))/5)    "SU AVG"                                          --Sunday Count  
  ,sum(decode(hol.service_type, 1, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 ))    "HD COUNT"                                          --Holidays Count
  ,round(sum(decode(hol.service_type, 1, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 ))/1)    "HD AVG"                                          --Holidays Count  
  ,sum(decode(hol.service_date, null, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 )
       + decode(hol.service_type, 2, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 )
       + decode(hol.service_type, 3, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 )
       + decode(hol.service_type, 1, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 )
         )                                                                                                                                                   "TD COUNT"
  ,round(sum(decode(hol.service_date, null, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 )
       + decode(hol.service_type, 2, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 )
       + decode(hol.service_type, 3, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 )
       + decode(hol.service_type, 1, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 )
         )/31)   "TD AVG"         
FROM
     SalesDetail            sd
    ,SalesDetail            sub
    ,MiscCardMovement        mcm
    ,SalesTransaction        st
    ,TVMTable                tvm
    ,tvmStation                sta
  ,mbta_weekend_service   hol
WHERE        1=1
--
--    Join conditions
--
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
    AND    sd.DeviceID                    = st.DeviceID
    AND    sd.DeviceClassID            = st.DeviceClassID
    AND    sd.UniqueMSID                = st.UniqueMSID
    AND    sd.SalesTransactionNo        = st.SalesTransactionNo
    AND    sd.PartitioningDate            = st.PartitioningDate
    AND    tvm.TVMID            =    st.DeviceID
    AND    tvm.DeviceClassID    =    st.DeviceClassID
    AND    sta.StationID     (+)    =    tvm.TVMTariffLocationID
AND    trunc(hol.service_date (+)) = trunc(sd.creadate)
AND    trunc(hol.service_date (+), 'hh24')  = trunc(sd.creadate, 'hh24')
--
--    Filter conditions
--
    AND    mcm.MovementType    IN     (7,20)
    AND    sd.ArticleNo                >     100000
    AND    sd.CorrectionFlag            =     0
    AND    sd.RealStatisticArticle        =     0
    AND    sd.TempBooking                =     0
    AND sd.ArticleNo                <>     607900100
    AND sub.ArticleNo            (+)    =    607900100
    AND    st.TestSaleFlag                =     0
AND    mcm.DeviceClassID        IN    (
                                        SELECT
                                            DeviceClassID
                                        FROM
                                            DeviceClass
                                        WHERE    DeviceClassType    IN    (5            --    Fareboxes
                                                                      )
                                    )
--
--    Parameter conditions
--
AND    sd.CreaDate            >= to_date('2010-08-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
AND    sd.CreaDate            <= to_date('2010-09-01-02-59-59','YYYY-MM-DD-HH24-MI-SS')
AND    sd.PartitioningDate    >= to_date('2010-08-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
AND    sd.PartitioningDate    <  to_date('2010-10-01-00-00-00','YYYY-MM-DD-HH24-MI-SS')
AND  hol.service_date(+) >= to_date('2010-08-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')     --This and below line are very important otherwise it is taking 10 hrs for 1 month.
AND  hol.service_date(+) <= to_date('2010-09-01-02-59-59','YYYY-MM-DD-HH24-MI-SS')
    AND    1=1
GROUP    BY
    sta.NAME, sta.stationid;

set autotrace off