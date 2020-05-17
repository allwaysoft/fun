SELECT
        /*+            
           INDEX    (sd XPKSALESDETAIL)                           
        */
    :QueryID
    ,1
    ,rou.Description                                                            RouteDesc
    ,sta.NAME                                                                    StationDesc
    ,To_Char    (Sum    (Decode    (Decode    (mcm.MovementType
                                                ,1        ,1
                                                ,2        ,1
                                                ,20        ,1
                                                ,null    ,1
                                        ,0
                                        )
                                    ,1    ,Decode    (sd.MachineBooking||':'||sd.Cancellation
                                                        ,'0:0'    ,1
                                                        ,'1:1'    ,1
                                                ,-1
                                                )
                                ,0
                                )
                        )
                    -
                Sum        (Decode    (mcm.MovementType
                                    ,6    ,Decode    (sd.MachineBooking||':'||sd.Cancellation
                                                     ,'0:0'    ,1
                                                     ,'1:1'    ,1
                                                ,-1
                                                )
                                ,0
                                )
                        )
                )                                                                TicketsCount
    ,tte.Description                                                            TicketTypeDesc
    ,To_Char    (tte.TicketTypeID)                                                TicketTypeID
     ,To_Char    (Sum    (        (        st.SumCashAmountWoToken
                                    +    st.SumCreditAmount
                                    +    st.SumCheckAmount
                                    -    st.SumCancelAmount
                                )
                            *    sd.FareOptAmount
                            /    st.SumFareOptAmount
                        )
                )                                                                SumAmountWoToken
    ,To_Char    (Sum    (        st.SumCreditAmount
                            *    sd.FareOptAmount
                            /    st.SumFareOptAmount
                        )
                )                                                                CreditAmount
    ,To_Char    (Sum    (        st.SumCancelAmount
                            *    sd.FareOptAmount
                            /    st.SumFareOptAmount
                        )
                )                                                                CancelAmount
    ,To_Char    (Sum    (        st.SumCheckAmount
                            *    sd.FareOptAmount
                            /    st.SumFareOptAmount
                        )
                )                                                                CheckAmount

    ,To_Char    (Sum    (         (        st.SumCashAmountWoToken
                                    -    st.SumCancelAmount
                                )
                            *    sd.FareOptAmount
                            /    st.SumFareOptAmount
                        )
                )                                                                CashAmountWoToken

     ,To_Char    (Sum    (        st.SumTokenAmount
                            *    sd.FareOptAmount
                            /    st.SumFareOptAmount
                        )
                )                                                                TokenAmount
FROM
    (
    ----------------------------------------------------------------------------
     --
    --    Subselect for Transactions
    --
    ----------------------------------------------------------------------------
        SELECT
             st.DeviceClassId
            ,st.DeviceId
            ,st.UniqueMsId
            ,st.SalesTransactionNo
            ,st.Partitioningdate
            ,Nvl    (cp.SumCashAmount    -    cp.SumTokenAmount,    0)        SumCashAmountWoToken
             ,Nvl    (cp.SumTokenAmount,    0)                                        SumTokenAmount
            ,st.SnobAmount
            ,Decode    (sd.SumFareOptAmount
                        ,0    ,1                                                    --    to avoid division by zero
                    ,sd.SumFareOptAmount
                    )                                                                  SumFareOptAmount

            ,Nvl    (clp.SumCreditAmount,    0)                            SumCreditAmount
            ,Nvl    (clp.SumCheckAmount,    0)                            SumCheckAmount
             ,Nvl    (clp.SumCancelAmount,    0)                            SumCancelAmount
        FROM
            (
            --------------------------------------------------------------------
            --
            --    Subselect for SalesTransaction
            --
            --------------------------------------------------------------------
                SELECT
                        /*+
                        INDEX    (st, XPKSALESTRANSACTION)
                        */
                     st.DeviceClassId
                    ,st.DeviceId
                    ,st.UniqueMsId
                    ,st.SalesTransactionNo
                    ,st.PartitioningDate
                    ,st.SnobAmount
                FROM
                           SalesTransaction    st
                 WHERE    1 = 1

                --
                --    Filter conditions
                --
          AND (st.DEVICECLASSID, st.DEVICEID) in (select  tvm.DeviceClassID DeviceClassId, tvm.TVMID DeviceId
                                                                       from TVMTable                    tvm
                                                                              ,Routes                        rou
                                                                              ,TVMStation                    sta
                                                                    where sta.StationID     =    tvm.TVMTariffLocationID
                                                                       AND rou.RouteID     =    tvm.RouteID
                                                                       AND (rou.routeid = 9996 and (sta.stationid in(1080,1009,1075)) or (rou.routeid = 1500))
                                                                     )

                    AND st.TestSaleFlag                =    0

                --
                --    Parameter conditions
                --

                    AND    st.CreaDate                    >=    To_Date    ('2010-09-01 00-00-01','YYYY-MM-DD HH24-MI-SS')
                    AND    st.CreaDate                    <=    To_Date    ('2010-10-01 00-00-01','YYYY-MM-DD HH24-MI-SS')
                    AND    st.PartitioningDate            >=    To_Date    ('2010-09-01 00-00-01','YYYY-MM-DD HH24-MI-SS')

            --------------------------------------------------------------------
            )                                st
            ,
            (
            --------------------------------------------------------------------
            --
            --    Subselect for CashPayment of SalesTransaction
            --
            --------------------------------------------------------------------
                SELECT
                        /*+
                        INDEX        (cp XPKCASHPAYMENT)
                        */
                     cp.DeviceClassId
                    ,cp.DeviceId
                    ,cp.UniqueMsId
                    ,cp.SalesTransactionNo
                    ,cp.PartitioningDate
                    ,Sum    (Decode    (cp.ChangeFlag
                                        ,1    , cp.PaymentTypeValue * NumberPieces
                                        ,2    ,-cp.PaymentTypeValue * NumberPieces
                                    ,0
                                    )
                            )                                            SumCashAmount
                     ,Sum    (Decode    (cp.changeFlag || ':' || cp.PaymentTypeID || ':' || cp.PaymentTypeValue
                                        ,'1:8:125'    , cp.paymentTypeValue * cp.NumberPieces
                                        ,'2:8:125'    ,-cp.paymentTypeValue * cp.NumberPieces
                                    ,0
                                    )
                            )                                            SumTokenAmount
                FROM
                        CashPayment        cp

                 WHERE    1 = 1
                --
                --    Filter conditions
                --
                  AND (cp.DEVICECLASSID, cp.DEVICEID) in (select  tvm.DeviceClassID DeviceClassId, tvm.TVMID DeviceId
                                                                       from TVMTable                    tvm
                                                                              ,Routes                        rou
                                                                              ,TVMStation                    sta
                                                                    where sta.StationID     =    tvm.TVMTariffLocationID
                                                                       AND rou.RouteID     =    tvm.RouteID
                                                                       and (rou.routeid = 9996 and (sta.stationid in(1080,1009,1075)) or (rou.routeid = 1500))
                                                                                )         
                --
                --    Parameter conditions
                --

                    AND    cp.CreaDate                    >=    To_Date    ('2010-09-01 00-00-01','YYYY-MM-DD HH24-MI-SS')
                    AND    cp.CreaDate                    <=    To_Date    ('2010-10-01 00-00-01','YYYY-MM-DD HH24-MI-SS')
                    AND    cp.PartitioningDate            >=    To_Date    ('2010-09-01 00-00-01','YYYY-MM-DD HH24-MI-SS')

                GROUP    BY
                       cp.DeviceClassId
                    ,cp.DeviceId
                    ,cp.UniqueMsId
                    ,cp.SalesTransactionNo
                    ,cp.PartitioningDate
            --------------------------------------------------------------------
            )                                cp
            ,
            (
            --------------------------------------------------------------------
            --
            --    Subselect for SalesDetail of SalesTransaction
            --
            --------------------------------------------------------------------
                SELECT
                        /*+
                        INDEX        (sd XPKSALESDETAIL)
                        */
                     sd.DeviceClassId
                    ,sd.DeviceId
                    ,sd.UniqueMsId
                    ,sd.SalesTransactionNo
                    ,sd.Partitioningdate
                    ,Abs(Sum(sd.FareOptAmount))                SumFareOptAmount
                 FROM
                        SalesDetail                    sd
                 WHERE    1 = 1
                --
                --    Filter conditions
                --
                  AND (sd.DEVICECLASSID, sd.DEVICEID) in (select  tvm.DeviceClassID DeviceClassId, tvm.TVMID DeviceId
                                                                       from TVMTable                    tvm
                                                                              ,Routes                        rou
                                                                              ,TVMStation                    sta
                                                                    where sta.StationID     =    tvm.TVMTariffLocationID
                                                                       AND rou.RouteID     =    tvm.RouteID
  and (rou.routeid = 9996 and (sta.stationid in(1080,1009,1075)) or (rou.routeid = 1500))
                                                                               )                  
                --
                --    Parameter conditions
                --
                    AND    sd.CreaDate                    >=    To_Date    ('2010-09-01 00-00-01','YYYY-MM-DD HH24-MI-SS')
                    AND    sd.CreaDate                    <=    To_Date    ('2010-10-01 00-00-01','YYYY-MM-DD HH24-MI-SS')
                    AND    sd.PartitioningDate            >=    To_Date    ('2010-09-01 00-00-01','YYYY-MM-DD HH24-MI-SS')
                GROUP    BY
                       sd.DeviceClassId
                    ,sd.DeviceId
                    ,sd.UniqueMsId
                    ,sd.SalesTransactionNo
                    ,sd.PartitioningDate
            --------------------------------------------------------------------
            )                                sd
            ,
            (
            --------------------------------------------------------------------
            --
            --    Subselect for CashlessPayment of SalesTransaction
            --
            --------------------------------------------------------------------
                SELECT
                        /*+
                        INDEX    (clp XPKCASHLESSPAYMENT)
                        */
                     clp.DeviceClassId
                    ,clp.DeviceId
                    ,clp.UniqueMsId
                    ,clp.SalesTransactionNo
                    ,clp.PartitioningDate
                    ,Sum    (Decode    (clp.PayTypeCashless
                                        ,1    ,clp.Amount
                                        ,2    ,clp.Amount
                                    ,0
                                    )
                            )                                                            SumCreditAmount
                    ,Sum    (Decode    (clp.PayTypeCashless
                                        ,4    ,clp.Amount
                                    ,0
                                    )
                            )                                                            SumCheckAmount
                    ,Sum    (Decode    (clp.PayTypeCashless
                                        ,16    ,clp.Amount
                                        ,19    ,clp.Amount
                                        ,32    ,clp.Amount
                                        ,64    ,clp.Amount
                                    ,0
                                    )
                            )                                                            SumCancelAmount
                FROM
                        CashlessPayment        clp

                 WHERE    1 = 1
                --
                --    Filter conditions
                --
                    AND    clp.PayTypeCashless        IN    (1
                                                    ,2
                                                    ,4
                                                    ,16
                                                    ,19
                                                    ,32
                                                    ,64
                                                    )

                  AND (clp.DEVICECLASSID, clp.DEVICEID) in (select  tvm.DeviceClassID DeviceClassId, tvm.TVMID DeviceId
                                                                       from TVMTable                    tvm
                                                                              ,Routes                        rou
                                                                              ,TVMStation                    sta
                                                                    where sta.StationID     =    tvm.TVMTariffLocationID
                                                                       AND rou.RouteID     =    tvm.RouteID
                                                                       and (rou.routeid = 9996 and (sta.stationid in(1080,1009,1075)) or (rou.routeid = 1500))   
                                                                                )       
                                                    
                --
                --    Parameter conditions
                --

                    AND    clp.CreaDate                >=    To_Date    ('2010-09-01 00-00-01','YYYY-MM-DD HH24-MI-SS')
                    AND    clp.CreaDate                <=    To_Date    ('2010-10-01 00-00-01','YYYY-MM-DD HH24-MI-SS')
                    AND    clp.PartitioningDate        >=    To_Date    ('2010-09-01 00-00-01','YYYY-MM-DD HH24-MI-SS')

                GROUP    BY
                       clp.DeviceClassId
                    ,clp.DeviceId
                    ,clp.UniqueMsId
                    ,clp.SalesTransactionNo
                    ,clp.PartitioningDate
            --------------------------------------------------------------------
            )                                clp
        WHERE    1 = 1

            AND    cp.DeviceClassId        (+)    =    st.DeviceClassId
            AND    cp.DeviceId                (+)    =    st.DeviceId
            AND    cp.UniqueMsId            (+)    =    st.UniqueMsId
            AND    cp.SalesTransactionNo    (+)    =    st.SalesTransactionNo
            AND    cp.PartitioningDate        (+)    =    st.PartitioningDate

            AND    sd.DeviceClassId            =    st.DeviceClassId
            AND    sd.DeviceId                    =    st.DeviceId
            AND    sd.UniqueMsId                =    st.UniqueMsId
            AND    sd.SalesTransactionNo        =    st.SalesTransactionNo
            AND    sd.PartitioningDate            =    st.PartitioningDate

            AND    clp.DeviceClassId        (+)    =    st.DeviceClassId
            AND    clp.DeviceId            (+)    =    st.DeviceId
            AND    clp.UniqueMsId            (+)    =    st.UniqueMsId
            AND    clp.SalesTransactionNo    (+)    =    st.SalesTransactionNo
            AND    clp.PartitioningDate    (+)    =    st.PartitioningDate
    ----------------------------------------------------------------------------
    )                            st
    ,SalesDetail                 sd
    ,SalesDetail                 sub
    ,MiscCardMovement            mcm
    ,TicketType                    tte
    ,TVMTable                    tvm
    ,Routes                        rou
    ,TVMStation                    sta
WHERE    1    =    1

--
--    Join conditions
--
    AND sd.DeviceClassID            =    st.DeviceClassID
    AND sd.DeviceID                    =    st.DeviceID
    AND sd.UniquemsID                =    st.UniquemsID
    AND sd.SalesTransactionNo        =    st.SalesTransactionNo
    AND sd.PartitioningDate            =    st.PartitioningDate


    AND    sub.DeviceClassId       (+)    =    sd.DeviceClassId
    AND    sub.DeviceId               (+)    =    sd.DeviceId
    AND    sub.Uniquemsid             (+)    =    sd.Uniquemsid
    AND    sub.SalestransactionNo    (+)    =    sd.SalesTransactionNo
    AND    sub.SalesDetailEvSequNo    (+)    =    sd.SalesDetailEvSequNo    +1
    AND    sub.CorrectionCounter    (+)    =    sd.CorrectionCounter
    AND    sub.PartitioningDate    (+)    =    sd.PartitioningDate

    AND    mcm.DeviceClassId           =    sd.DeviceClassId
    AND    mcm.DeviceId                   =    sd.DeviceId
    AND    mcm.Uniquemsid                 =    sd.Uniquemsid
    AND    mcm.SalestransactionNo        =    sd.SalesTransactionNo
    AND    mcm.SequenceNo                =    Decode    (sub.SalesDetailEvSequNo
                                                    ,NULL    ,sd.SalesDetailEvSequNo
                                                ,sub.SalesDetailEvSequNo
                                                )
    AND    mcm.CorrectionCounter        =    sd.CorrectionCounter
    AND    mcm.PartitioningDate        =    sd.PartitioningDate
    AND    mcm.TimeStamp                =    sd.CreaDate

    AND tte.TicketTypeID            =    sd.ArticleNo
    AND tte.VersionID                =    sd.TariffVersion

    AND tvm.DeviceClassID            =     st.DeviceClassID
    AND tvm.TVMID                    =    st.DeviceID

    AND sta.StationID                =    tvm.TVMTariffLocationID

    AND rou.RouteID                    =    tvm.RouteID

--
--    Filter conditions
--

    AND mcm.MovementType            IN (  1
                                        , 2
                                        , 4                    --    2008-04-17    ABU
                                        , 6                    --    2008-04-17    ABU
                                        ,16                    --    2008-04-17    ABU
                                        ,18                    --    2008-04-17    ABU
                                        ,20
                                        )
   AND (sd.DEVICECLASSID, sd.DEVICEID) in (select  tvm.DeviceClassID DeviceClassId, tvm.TVMID DeviceId
                                                                       from TVMTable                    tvm
                                                                              ,Routes                        rou
                                                                              ,TVMStation                    sta
                                                                    where sta.StationID     =    tvm.TVMTariffLocationID
                                                                       AND rou.RouteID     =    tvm.RouteID
                                                                       and (rou.routeid = 9996 and (sta.stationid in(1080,1009,1075)) or (rou.routeid = 1500))
                                                                 )                  

    AND sd.ArticleNo                NOT    IN    (605400100,607900100)
    AND sd.RealStatisticArticle        =    0
    AND sd.Tempbooking                =    0
    AND sd.CorrectionFlag            =    0

    AND sub.ArticleNo            (+)    =    607900100

--
--    Parameter conditions
--

    AND    sd.CreaDate                    >=    To_Date    ('2010-09-01 00-00-01','YYYY-MM-DD HH24-MI-SS')
    AND    sd.CreaDate                    <=    To_Date    ('2010-10-01 00-00-01','YYYY-MM-DD HH24-MI-SS')
    AND    sd.PartitioningDate            >=    To_Date    ('2010-09-01 00-00-01','YYYY-MM-DD HH24-MI-SS')

AND 1=1 AND 1=1 AND 1=1 AND 1=1 AND 1=1 AND 1=1 
GROUP    BY
     rou.Description
    ,sta.NAME
    ,tte.Description
    ,tte.TicketTypeID