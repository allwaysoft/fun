SELECT
    /*+
        ORDERED
        INDEX        (sub    XIE1SalesDetail)
        USE_HASH    (sub)
        USE_NL        (mcm)
        USE_NL        (st)
    USE_NL    (hol)
        INDEX        (mcm    XIE5MiscCardMovement)
        INDEX        (sd        XIE8SalesDetail)
        INDEX        (st        XPKSalesTransaction)
    INDEX        (ms        XPKMainShift)
    INDEX   (hol PK_MBTA_WEEKEND_SERVICE_DATE)
        USE_NL        (rou)
        USE_NL        (tvm)
        USE_NL        (sta)
    */
    1-- :QueryID
  ,1
  ,rou.routeid         --Line Id
  ,sta.stationid       --Station Id
  ,rou.description    --  Line_Name
  ,sta.Name                         --    Station_Name
  , tvm.TVMID -- Device Id
  , tvm.tvmabbreviation --Device Description

,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'00',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) Nxt_day_00
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'01',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) Nxt_day_01
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'02',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) Nxt_day_02
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'03',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) Curr_day_03
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'04',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) Curr_day_04
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'05',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) Curr_day_05
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'06',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) Curr_day_06
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'07',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) Curr_day_07
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'08',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) Curr_day_08
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'09',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) Curr_day_09
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'10',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) Curr_day_10
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'11',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) Curr_day_11
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'12',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) Curr_day_12
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'13',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) Curr_day_13
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'14',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) Curr_day_14
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'15',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) Curr_day_15
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'16',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) Curr_day_16
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'17',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) Curr_day_17
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'18',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) Curr_day_18
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'19',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) Curr_day_19
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'20',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) Curr_day_20
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'21',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) Curr_day_21
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'22',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) Curr_day_22
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'23',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) Curr_day_23
,nvl(sum(decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1)),0) Total
FROM
     SalesDetail            sd
    ,SalesDetail            sub
    ,MiscCardMovement        mcm
    ,SalesTransaction        st
    ,Mainshift                ms
    ,Routes                    rou
    ,TVMTable                tvm
    ,tvmStation                sta
  --,mbta_weekend_service     hol
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

    AND    st.DeviceID = sd.DeviceID
    AND    st.DeviceClassID = sd.DeviceClassID
    AND    st.UniqueMSID = sd.UniqueMSID
    AND    st.SalesTransactionNo = sd.SalesTransactionNo
    AND    st.PartitioningDate = sd.PartitioningDate
    AND    ms.DeviceClassId    =    st.DeviceClassId
    AND    ms.DeviceId            =    st.DeviceId
    AND    ms.Uniquemsid        =    st.Uniquemsid
    AND    ms.EndCreaDate        =    st.PartitioningDate
    AND    tvm.TVMID            =    ms.DeviceID
    AND    tvm.DeviceClassID    =    ms.DeviceClassID
    AND    sta.StationID     (+)    =    tvm.TVMTariffLocationID
    AND    rou.RouteID            =    ms.RouteNo                                 --outer join not necessary for this report.
--AND    trunc(hol.service_date (+)) = trunc(sd.creadate)
--AND    trunc(hol.service_date (+), 'hh24')  = trunc(sd.creadate, 'hh24')
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

AND tvm.TVMTariffLocationID = 1011  -- Airport
AND    rou.routeid in
(
--1400,
1200
--,
--1000,
--1300,
--1100
)   -- Subway Stations Only
--
--    Parameter conditions
--

    AND    sd.CreaDate            >= to_date('2011-06-19-03-00-00','YYYY-MM-DD-HH24-MI-SS')
    AND    sd.CreaDate            <= to_date('2011-06-20-02-59-59','YYYY-MM-DD-HH24-MI-SS')
    AND    sd.PartitioningDate    >= to_date('2011-06-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
    AND    sd.PartitioningDate    <  to_date('2011-08-01-00-00-00','YYYY-MM-DD-HH24-MI-SS')    
   
--    AND    hol.service_date(+)            >= :dDateFirst                                        --to_date(:dDateFirst, 'mm/dd/yyyy hh24:mi:ss')
--    AND    hol.service_date(+)            <= :dDateLast
    AND sd.sellingrrid <> 2 
    AND 1=1 
    GROUP    BY rou.routeid
                     ,sta.NAME
                     ,sta.stationid
                     ,rou.description
                     , tvm.TVMID -- DeviceId
                     , tvm.tvmabbreviation


