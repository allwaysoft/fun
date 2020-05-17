/* Formatted on 12/14/2012 4:54:09 PM (QP5 v5.185.11230.41888) */
/*
This SQL was extracted from FARE MEDIA USAGE report and change for BETTER performance. Original report was taking for ever to get the results.
This is the best performance I could achieve, takes less time to run but takes take to get the complete rows in case if run for a years worth of data.
*/
SELECT /*+
           LEADING (det)
           INDEX (det XIE1SalesDetail)
           INDEX (sub XIE1SalesDetail)
           INDEX (mcm XIE5MiscCardMovement)
           INDEX (st XPKSalesTransaction)
           USE_HASH (sub)
           USE_NL (mcm)
           USE_NL (st)
           USE_NL (tvm)
           USE_NL (sta)
       */
       --==============================================================================
       mcm.SerialNumber "Ticket No.",
       ' ' || tte.Description "ProdType",
       ' ' || sta.NAME "Location",
       mcm.DeviceID "Device",
       ' ' || cla.Description "DeviceClass",
       mcm.TIMESTAMP "DateTime",
       DECODE (cd2.text,
               NULL, ' Unknown action ' || mcm.MovementType,
               ' ' || cd2.Text)
          "Text",
       det.FareOptAmount / 100 "Usage Value",
       fkt_TicketCategory (det.ArticleNo) "TBV",
       mcm.MovementType "MovementType"
  --==============================================================================
  FROM SalesDetail det,
       SalesDetail sub,
       MiscCardMovement mcm,
       Salestransaction st,
       TVMTable tvm,
       TvmStation sta,
       DeviceClass cla,
       CodeText cd2,
       TicketType tte
 --==============================================================================
 WHERE     1 = 1
       --------------------------------------------------------------------------------
       --
       --    Join conditions
       --
       --------------------------------------------------------------------------------
       AND st.DeviceId = det.DeviceId
       AND st.DeviceClassId = det.DeviceClassId
       AND st.UniqueMsId = det.UniqueMsId
       AND st.SalesTransactionNo = det.SalesTransactionNo
       AND st.PartitioningDate = det.PartitioningDate
       --
       AND sub.DeviceClassID(+) = det.DeviceClassID
       AND sub.DeviceID(+) = det.DeviceID
       AND sub.UniquemsID(+) = det.UniquemsID
       AND sub.SalesTransactionNo(+) = det.SalesTransactionNo
       AND sub.SalesDetailEvSequNo(+) = det.SalesDetailEvSequNo + 1
       AND sub.CorrectionCounter(+) = det.CorrectionCounter
       AND sub.PartitioningDate(+) = det.PartitioningDate
       --
       AND mcm.DeviceClassID = det.DeviceClassID
       AND mcm.DeviceID = det.DeviceID
       AND mcm.UniquemsID = det.UniquemsID
       AND mcm.SalesTransactionNo = det.SalesTransactionNo
       AND mcm.SequenceNo =
              DECODE (sub.SalesDetailEvSequNo,
                      NULL, det.SalesDetailEvSequNo,
                      sub.SalesDetailEvSequNo)
       AND mcm.CorrectionCounter = det.CorrectionCounter
       AND mcm.PartitioningDate = det.PartitioningDate
       --
       AND tte.TicketTypeID(+) = det.ArticleNo
       AND tte.VersionID(+) = det.TariffVersion
       --
       AND cla.DeviceClassID = tvm.DeviceClassID
       --
       AND tvm.TvmId = st.DeviceId
       AND tvm.DeviceClassID = st.DeviceClassID
       --
       AND sta.StationID(+) = tvm.TVMTariffLocationID
       --
       AND cd2.Code(+) = mcm.MovementType
       AND cd2.Id(+) = 2000
       --------------------------------------------------------------------------------
       --
       --    Filter conditions
       --
       --------------------------------------------------------------------------------
       AND det.CorrectionFlag = 0
       AND det.RealStatisticArticle = 0
       AND det.TempBooking = 0
       AND st.TestSaleFlag = 0
       AND det.ArticleNo <> 607900100
       AND sub.ArticleNo(+) = 607900100
       --------------------------------------------------------------------------------
       --
       --    Parameter conditions
       --
       --------------------------------------------------------------------------------
       AND det.CreaDate >= TO_DATE ('2011-03-01-03-00-00', 'YYYY-MM-DD-HH24-MI-SS')
       AND det.CreaDate <= TO_DATE ('2012-03-01-02-59-59', 'YYYY-MM-DD-HH24-MI-SS')
       AND det.PartitioningDate >= TO_DATE ('2011-03-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')
       AND det.PartitioningDate < TO_DATE ('2012-04-01-02-59-59', 'YYYY-MM-DD-HH24:MI:SS')
       --
       AND det.articleno = 606300100                    --Only Tride customers
--
--==============================================================================
--ORDER BY

--******************************************************************************************************
--Version 2 of above Query, minor diff from above, added an additional condition for "Time Based Tckets"
--******************************************************************************************************

SELECT /*+
           LEADING (det)
           INDEX (det XIE1SalesDetail)
           INDEX (sub XIE1SalesDetail)
           INDEX (mcm XIE5MiscCardMovement)
           INDEX (st XPKSalesTransaction)
           USE_HASH (sub)
           USE_NL (mcm)
           USE_NL (st)
           USE_NL (tvm)
           USE_NL (sta)
       */
--==============================================================================
       mcm.SerialNumber "Ticket No.",
       ' ' || tte.Description "ProdType",
       ' ' || sta.NAME "Location",
       mcm.DeviceID "Device",
       ' ' || cla.Description "DeviceClass",
       mcm.TIMESTAMP "DateTime",
       /*
       DECODE (cd2.text,
               NULL, ' Unknown action ' || mcm.MovementType,
               ' ' || cd2.Text)
          "Text",
       */
       decode(mcm.movementtype,7,decode(fkt_TicketCategory (det.ArticleNo),1,'Time Based Ticket Validated','N/A'),'N/A') Action,
       det.FareOptAmount / 100 "Usage Value",
       fkt_TicketCategory (det.ArticleNo) "TBV",
       mcm.MovementType "MovementType"
--==============================================================================
  FROM SalesDetail det,
       SalesDetail sub,
       MiscCardMovement mcm,
       Salestransaction st,
       TVMTable tvm,
       TvmStation sta,
       DeviceClass cla,
       CodeText cd2,
       TicketType tte
--==============================================================================
 WHERE     1 = 1
       --------------------------------------------------------------------------------
       --
       --    Join conditions
       --
       --------------------------------------------------------------------------------
       AND st.DeviceId = det.DeviceId
       AND st.DeviceClassId = det.DeviceClassId
       AND st.UniqueMsId = det.UniqueMsId
       AND st.SalesTransactionNo = det.SalesTransactionNo
       AND st.PartitioningDate = det.PartitioningDate
       --
       AND sub.DeviceClassID(+) = det.DeviceClassID
       AND sub.DeviceID(+) = det.DeviceID
       AND sub.UniquemsID(+) = det.UniquemsID
       AND sub.SalesTransactionNo(+) = det.SalesTransactionNo
       AND sub.SalesDetailEvSequNo(+) = det.SalesDetailEvSequNo + 1
       AND sub.CorrectionCounter(+) = det.CorrectionCounter
       AND sub.PartitioningDate(+) = det.PartitioningDate
       --
       AND mcm.DeviceClassID = det.DeviceClassID
       AND mcm.DeviceID = det.DeviceID
       AND mcm.UniquemsID = det.UniquemsID
       AND mcm.SalesTransactionNo = det.SalesTransactionNo
       AND mcm.SequenceNo =
              DECODE (sub.SalesDetailEvSequNo,
                      NULL, det.SalesDetailEvSequNo,
                      sub.SalesDetailEvSequNo)
       AND mcm.CorrectionCounter = det.CorrectionCounter
       AND mcm.PartitioningDate = det.PartitioningDate
       --
       AND tte.TicketTypeID(+) = det.ArticleNo
       AND tte.VersionID(+) = det.TariffVersion
       --
       AND cla.DeviceClassID = tvm.DeviceClassID
       --
       AND tvm.TvmId = st.DeviceId
       AND tvm.DeviceClassID = st.DeviceClassID
       --
       AND sta.StationID(+) = tvm.TVMTariffLocationID
       --
       AND cd2.Code(+) = mcm.MovementType
       AND cd2.Id(+) = 2000
       --------------------------------------------------------------------------------
       --
       --    Filter conditions
       --
       --------------------------------------------------------------------------------
       AND det.CorrectionFlag = 0
       AND det.RealStatisticArticle = 0
       AND det.TempBooking = 0
       AND st.TestSaleFlag = 0
       AND det.ArticleNo <> 607900100
       AND sub.ArticleNo(+) = 607900100
       --------------------------------------------------------------------------------
       --
       --    Parameter conditions
       --
       --------------------------------------------------------------------------------
       AND det.CreaDate >=TO_DATE ('2012-08-01-03-00-00', 'YYYY-MM-DD-HH24-MI-SS')
       AND det.CreaDate <=TO_DATE ('2012-09-01-02-59-59', 'YYYY-MM-DD-HH24-MI-SS')
       AND det.PartitioningDate >=TO_DATE ('2012-08-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')
       AND det.PartitioningDate <TO_DATE ('2012-10-01-02-59-59', 'YYYY-MM-DD-HH24:MI:SS')
       --
       AND det.articleno = 606300100                    --Only Tride customers
       AND trim(mcm.movementtype)||fkt_TicketCategory(det.ArticleNo) = 71 -- Only "Time Base Ticket Validated" records
--
--==============================================================================
--ORDER BY