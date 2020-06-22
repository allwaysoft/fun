     SELECT /*+
                   INDEX  (st XPKSALESTRANSACTION)
                     INDEX  (sd XPKSALESDETAIL)
                     INDEX  (sub XPKSALESDETAIL
                     INDEX (mcm XPKMISCCARDMOVEMENT )
            */
sd.DeviceClassId,
sd.DeviceId,
sd.UniqueMsId,
sd.SalesTransactionNo,
               SUM (sd.FareOptAmount )
                      FROM (----------------------------------------------------------------------------
             --
             -- Subselect for Transactions
             --
             ----------------------------------------------------------------------------
             SELECT 
                                 st.DeviceClassId,
                    st.DeviceId,
                    st.UniqueMsId,
                    st.SalesTransactionNo,
                    st.Partitioningdate,
                    DECODE (sd.SumFareOptAmount)
               FROM (--------------------------------------------------------------------
                     --
                     -- Subselect for SalesTransaction
                     --
                     --------------------------------------------------------------------
                     SELECT /*+
                            INDEX  (st XPKSALESTRANSACTION)

                            */
                            st.DeviceClassId DeviceClassId, 
                            st.DeviceId DeviceId,
                            st.UniqueMsId UniqueMsId,
                            st.SalesTransactionNo SalesTransactionNo,
                            st.PartitioningDate PartitioningDate,
                            st.SnobAmount SnobAmount
                       FROM mbta.mbta_temp_product_sales_smry smry,
                       SalesTransaction st
                      WHERE 1 = 1 --
                                  -- Filter conditions
                                  --

                            AND st.TestSaleFlag = 0
                            --
                            -- Parameter conditions
                            --
and st.DeviceClassId = smry.DeviceClassId
and st.DeviceId =smry.DeviceId
and st.UniqueMsId = smry.UniqueMsId
and st.SalesTransactionNo = smry.SalesTransactionNo
and st.creadate >= TO_DATE ('2010-09-01 03-00-00', 'YYYY-MM-DD HH24-MI-SS')
and st.creadate < TO_DATE ('2010-10-10 03-00-00', 'YYYY-MM-DD HH24-MI-SS')
AND st.PartitioningDate >= TO_DATE ('2010-09-01 03-00-00', 'YYYY-MM-DD HH24-MI-SS')--------------------------------------------------------------------
                    ) st,
                    (  --------------------------------------------------------------------
                       --
                       -- Subselect for CashPayment of SalesTransaction
                       --
                       --------------------------------------------------------------------
                       SELECT /*+
                             index  (cp XPKCASHPAYMENT)

                              */
                              cp.DeviceClassId,
                              cp.DeviceId,
                              cp.UniqueMsId,
                              cp.SalesTransactionNo,
                              cp.PartitioningDate,
                              SUM (
                                 DECODE (cp.ChangeFlag,
                                         1, cp.PaymentTypeValue * NumberPieces,
                                         2, -cp.PaymentTypeValue * NumberPieces,
                                         0))
                                 SumCashAmount,
                              SUM (
                                 DECODE (
                                       cp.changeFlag
                                    || ':'
                                    || cp.PaymentTypeID
                                    || ':'
                                    || cp.PaymentTypeValue,
                                    '1:8:125', cp.paymentTypeValue
                                               * cp.NumberPieces,
                                    '2:8:125', -cp.paymentTypeValue
                                               * cp.NumberPieces,
                                    0))
                                 SumTokenAmount
                         FROM mbta.mbta_temp_product_sales_smry smry, 
                         CashPayment cp
                        WHERE 1 = 1
                              --
                              -- Filter conditions
                              --

                              --
                              -- Parameter conditions
                              --
and cp.DeviceClassId = smry.DeviceClassId
and cp.DeviceId =smry.DeviceId
and cp.UniqueMsId = smry.UniqueMsId
and cp.SalesTransactionNo = smry.SalesTransactionNo
and cp.creadate >= TO_DATE ('2010-09-01 03-00-00', 'YYYY-MM-DD HH24-MI-SS')
and cp.creadate < TO_DATE ('2010-10-10 03-00-00', 'YYYY-MM-DD HH24-MI-SS')
AND cp.PartitioningDate >= TO_DATE ('2010-09-01 03-00-00', 'YYYY-MM-DD HH24-MI-SS')
                     GROUP BY cp.DeviceClassId,
                              cp.DeviceId,
                              cp.UniqueMsId,
                              cp.SalesTransactionNo,
                              cp.PartitioningDate--------------------------------------------------------------------
                    ) cp,
                    (  --------------------------------------------------------------------
                       --
                       -- Subselect for SalesDetail of SalesTransaction
                       --
                       --------------------------------------------------------------------
                       SELECT /*+
                              INDEX (sd XPKSALESDETAIL)
                              */
                              sd.DeviceClassId,
                              sd.DeviceId,
                              sd.UniqueMsId,
                              sd.SalesTransactionNo,
                              sd.Partitioningdate,
                              ABS (SUM (sd.FareOptAmount)) SumFareOptAmount
                         FROM mbta.mbta_temp_product_sales_smry smry,  
                         SalesDetail sd
                        WHERE 1 = 1
                              --
                              -- Filter conditions
                              --

                              --
                              -- Parameter conditions
                              --
and sd.DeviceClassId = smry.DeviceClassId
and sd.DeviceId =smry.DeviceId
and sd.UniqueMsId = smry.UniqueMsId
and sd.SalesTransactionNo = smry.SalesTransactionNo
and sd.creadate >= TO_DATE ('2010-09-01 03-00-00', 'YYYY-MM-DD HH24-MI-SS')
and sd.creadate < TO_DATE ('2010-10-10 03-00-00', 'YYYY-MM-DD HH24-MI-SS')
AND sd.PartitioningDate >= TO_DATE ('2010-09-01 03-00-00', 'YYYY-MM-DD HH24-MI-SS')
                     GROUP BY sd.DeviceClassId,
                              sd.DeviceId,
                              sd.UniqueMsId,
                              sd.SalesTransactionNo,
                              sd.PartitioningDate--------------------------------------------------------------------
                    ) sd,
                    (  --------------------------------------------------------------------
                       --
                       -- Subselect for CashlessPayment of SalesTransaction
                       --
                       --------------------------------------------------------------------
                       SELECT /*+
                              index  (clp XPKCASHLESSPAYMENT)

                              */
                              clp.DeviceClassId,
                              clp.DeviceId,
                              clp.UniqueMsId,
                              clp.SalesTransactionNo,
                              clp.PartitioningDate,
                              SUM (
                                 DECODE (clp.PayTypeCashless,
                                         1, clp.Amount,
                                         2, clp.Amount,
                                         0))
                                 SumCreditAmount,
                              SUM (
                                 DECODE (clp.PayTypeCashless, 4, clp.Amount, 0))
                                 SumCheckAmount,
                              SUM (
                                 DECODE (clp.PayTypeCashless,
                                         16, clp.Amount,
                                         19, clp.Amount,
                                         32, clp.Amount,
                                         64, clp.Amount,
                                         0))
                                 SumCancelAmount
                         FROM mbta.mbta_temp_product_sales_smry smry,  
                          CashlessPayment clp
                        WHERE 1 = 1
                              --
                              -- Filter conditions
                              --
                              AND clp.PayTypeCashless IN
                                     (1, 2, 4, 16, 19, 32, 64)
                              --
                              -- Parameter conditions
                              --
and clp.DeviceClassId = smry.DeviceClassId
and clp.DeviceId =smry.DeviceId
and clp.UniqueMsId = smry.UniqueMsId
and clp.SalesTransactionNo = smry.SalesTransactionNo
and clp.creadate >= TO_DATE ('2010-09-01 03-00-00', 'YYYY-MM-DD HH24-MI-SS')
and clp.creadate < TO_DATE ('2010-10-10 03-00-00', 'YYYY-MM-DD HH24-MI-SS')
AND clp.PartitioningDate >= TO_DATE ('2010-09-01 03-00-00', 'YYYY-MM-DD HH24-MI-SS')
                     GROUP BY clp.DeviceClassId,
                              clp.DeviceId,
                              clp.UniqueMsId,
                              clp.SalesTransactionNo,
                              clp.PartitioningDate--------------------------------------------------------------------
                    ) clp
              WHERE     1 = 1
                    AND cp.DeviceClassId(+) = st.DeviceClassId
                    AND cp.DeviceId(+) = st.DeviceId
                    AND cp.UniqueMsId(+) = st.UniqueMsId
                    AND cp.SalesTransactionNo(+) = st.SalesTransactionNo
                    AND cp.PartitioningDate(+) = st.PartitioningDate
                    AND sd.DeviceClassId = st.DeviceClassId
                    AND sd.DeviceId = st.DeviceId
                    AND sd.UniqueMsId = st.UniqueMsId
                    AND sd.SalesTransactionNo = st.SalesTransactionNo
                    AND sd.PartitioningDate = st.PartitioningDate
                    AND clp.DeviceClassId(+) = st.DeviceClassId
                    AND clp.DeviceId(+) = st.DeviceId
                    AND clp.UniqueMsId(+) = st.UniqueMsId
                    AND clp.SalesTransactionNo(+) = st.SalesTransactionNo
                    AND clp.PartitioningDate(+) = st.PartitioningDate----------------------------------------------------------------------------
            ) st,
            mbta.mbta_temp_product_sales_smry smry,  
            SalesDetail sd,
            SalesDetail sub,
            MiscCardMovement mcm,
            TicketType tte,
            TVMTable tvm,
            Routes rou,
            TVMStation sta
      WHERE     1 = 1
            --
            -- Join conditions
            --
            and sd.DeviceClassId = smry.DeviceClassId
            and sd.DeviceId =smry.DeviceId
            and sd.UniqueMsId = smry.UniqueMsId
            and sd.SalesTransactionNo = smry.SalesTransactionNo
            AND sd.DeviceClassID = st.DeviceClassID
            AND sd.DeviceID = st.DeviceID
            AND sd.UniquemsID = st.UniquemsID
            AND sd.SalesTransactionNo = st.SalesTransactionNo
            AND sd.PartitioningDate = st.PartitioningDate
            AND sub.DeviceClassId(+) = sd.DeviceClassId
            AND sub.DeviceId(+) = sd.DeviceId
            AND sub.Uniquemsid(+) = sd.Uniquemsid
            AND sub.SalestransactionNo(+) = sd.SalesTransactionNo
            AND sub.SalesDetailEvSequNo(+) = sd.SalesDetailEvSequNo + 1
            AND sub.CorrectionCounter(+) = sd.CorrectionCounter
            AND sub.PartitioningDate(+) = sd.PartitioningDate
            AND mcm.DeviceClassId = sd.DeviceClassId
            AND mcm.DeviceId = sd.DeviceId
            AND mcm.Uniquemsid = sd.Uniquemsid
            AND mcm.SalestransactionNo = sd.SalesTransactionNo
            AND mcm.SequenceNo =
                   DECODE (sub.SalesDetailEvSequNo,
                           NULL, sd.SalesDetailEvSequNo,
                           sub.SalesDetailEvSequNo)
            AND mcm.CorrectionCounter = sd.CorrectionCounter
            AND mcm.PartitioningDate = sd.PartitioningDate
            AND mcm.TimeStamp = sd.CreaDate
            AND tte.TicketTypeID = sd.ArticleNo
            AND tte.VersionID = sd.TariffVersion
            AND tvm.DeviceClassID = st.DeviceClassID
            AND tvm.TVMID = st.DeviceID
            AND sta.StationID = tvm.TVMTariffLocationID
            AND rou.RouteID = tvm.RouteID
            --
            -- Filter conditions
            --
            AND mcm.MovementType IN (1, 2, 4                 -- 2008-04-17 ABU
                                            , 6              -- 2008-04-17 ABU
                                               , 16          -- 2008-04-17 ABU
                                                   , 18      -- 2008-04-17 ABU
                                                       , 20)
            AND sd.ArticleNo NOT IN (605400100, 607900100)
            AND sd.RealStatisticArticle = 0
            AND sd.Tempbooking = 0
            AND sd.CorrectionFlag = 0
            AND sub.ArticleNo(+) = 607900100
            --
            -- Parameter conditions
            --
and sd.creadate >= TO_DATE ('2010-09-01 03-00-00', 'YYYY-MM-DD HH24-MI-SS')
and sd.creadate < TO_DATE ('2010-10-10 03-00-00', 'YYYY-MM-DD HH24-MI-SS')
AND sd.PartitioningDate >= TO_DATE ('2010-09-01 03-00-00', 'YYYY-MM-DD HH24-MI-SS')
   GROUP BY sd.DeviceClassId,
                  sd.DeviceId,
                  sd.UniqueMsId,
                  sd.SalesTransactionNo