/* Formatted on 9/2/2010 11:32:29 AM (QP5 v5.149.1003.31008) */
INSERT INTO TempResult (QueryID,
                        LineId,
                        Data31,
                        Data32,
                        Data1,
                        Data2,
                        Data3,
                        Data4,
                        Data5,
                        Data6,
                        Data7,
                        Data8,
                        Data9,
                        Data10,
                        Data11,
                        Data12,
                        Data13,
                        Data14,
                        Data15,
                        Data16,
                        Data17,
                        Data18,
                        Data19,
                        Data20,
                        Data21,
                        Data22,
                        Data23,
                        Data24,
                        Data25)
     SELECT /*+
             ORDERED
             USE_HASH (sub)
             INDEX  (sub XIE1SalesDetail)
             USE_HASH (mcm)
             USE_HASH (ms)
             USE_HASH (sd)
             USE_HASH (st)
             FULL  (mcm)
             FULL  (ms)
             FULL  (sd)
             FULL  (st)
             USE_NL  (tvm)
             USE_NL  (sta)
            */
            :QueryID,
            1,
            sta.Name                                                -- Station
                    ,
            TO_CHAR (NVL (sd.BranchLineId, 0))                        -- Route
                                              ,
            TO_CHAR (
               SUM (
                  DECODE (
                     TO_CHAR (sd.Creadate, 'HH24'),
                     '00', DECODE (sd.Machinebooking || ':' || sd.Cancellation,
                                   '1:1', 1,
                                   '0:0', 1,
                                   -1),
                     0))),
            TO_CHAR (
               SUM (
                  DECODE (
                     TO_CHAR (sd.Creadate, 'HH24'),
                     '01', DECODE (sd.Machinebooking || ':' || sd.Cancellation,
                                   '1:1', 1,
                                   '0:0', 1,
                                   -1),
                     0))),
            TO_CHAR (
               SUM (
                  DECODE (
                     TO_CHAR (sd.Creadate, 'HH24'),
                     '02', DECODE (sd.Machinebooking || ':' || sd.Cancellation,
                                   '1:1', 1,
                                   '0:0', 1,
                                   -1),
                     0))),
            TO_CHAR (
               SUM (
                  DECODE (
                     TO_CHAR (sd.Creadate, 'HH24'),
                     '03', DECODE (sd.Machinebooking || ':' || sd.Cancellation,
                                   '1:1', 1,
                                   '0:0', 1,
                                   -1),
                     0))),
            TO_CHAR (
               SUM (
                  DECODE (
                     TO_CHAR (sd.Creadate, 'HH24'),
                     '04', DECODE (sd.Machinebooking || ':' || sd.Cancellation,
                                   '1:1', 1,
                                   '0:0', 1,
                                   -1),
                     0))),
            TO_CHAR (
               SUM (
                  DECODE (
                     TO_CHAR (sd.Creadate, 'HH24'),
                     '05', DECODE (sd.Machinebooking || ':' || sd.Cancellation,
                                   '1:1', 1,
                                   '0:0', 1,
                                   -1),
                     0))),
            TO_CHAR (
               SUM (
                  DECODE (
                     TO_CHAR (sd.Creadate, 'HH24'),
                     '06', DECODE (sd.Machinebooking || ':' || sd.Cancellation,
                                   '1:1', 1,
                                   '0:0', 1,
                                   -1),
                     0))),
            TO_CHAR (
               SUM (
                  DECODE (
                     TO_CHAR (sd.Creadate, 'HH24'),
                     '07', DECODE (sd.Machinebooking || ':' || sd.Cancellation,
                                   '1:1', 1,
                                   '0:0', 1,
                                   -1),
                     0))),
            TO_CHAR (
               SUM (
                  DECODE (
                     TO_CHAR (sd.Creadate, 'HH24'),
                     '08', DECODE (sd.Machinebooking || ':' || sd.Cancellation,
                                   '1:1', 1,
                                   '0:0', 1,
                                   -1),
                     0))),
            TO_CHAR (
               SUM (
                  DECODE (
                     TO_CHAR (sd.Creadate, 'HH24'),
                     '09', DECODE (sd.Machinebooking || ':' || sd.Cancellation,
                                   '1:1', 1,
                                   '0:0', 1,
                                   -1),
                     0))),
            TO_CHAR (
               SUM (
                  DECODE (
                     TO_CHAR (sd.Creadate, 'HH24'),
                     '10', DECODE (sd.Machinebooking || ':' || sd.Cancellation,
                                   '1:1', 1,
                                   '0:0', 1,
                                   -1),
                     0))),
            TO_CHAR (
               SUM (
                  DECODE (
                     TO_CHAR (sd.Creadate, 'HH24'),
                     '11', DECODE (sd.Machinebooking || ':' || sd.Cancellation,
                                   '1:1', 1,
                                   '0:0', 1,
                                   -1),
                     0))),
            TO_CHAR (
               SUM (
                  DECODE (
                     TO_CHAR (sd.Creadate, 'HH24'),
                     '12', DECODE (sd.Machinebooking || ':' || sd.Cancellation,
                                   '1:1', 1,
                                   '0:0', 1,
                                   -1),
                     0))),
            TO_CHAR (
               SUM (
                  DECODE (
                     TO_CHAR (sd.Creadate, 'HH24'),
                     '13', DECODE (sd.Machinebooking || ':' || sd.Cancellation,
                                   '1:1', 1,
                                   '0:0', 1,
                                   -1),
                     0))),
            TO_CHAR (
               SUM (
                  DECODE (
                     TO_CHAR (sd.Creadate, 'HH24'),
                     '14', DECODE (sd.Machinebooking || ':' || sd.Cancellation,
                                   '1:1', 1,
                                   '0:0', 1,
                                   -1),
                     0))),
            TO_CHAR (
               SUM (
                  DECODE (
                     TO_CHAR (sd.Creadate, 'HH24'),
                     '15', DECODE (sd.Machinebooking || ':' || sd.Cancellation,
                                   '1:1', 1,
                                   '0:0', 1,
                                   -1),
                     0))),
            TO_CHAR (
               SUM (
                  DECODE (
                     TO_CHAR (sd.Creadate, 'HH24'),
                     '16', DECODE (sd.Machinebooking || ':' || sd.Cancellation,
                                   '1:1', 1,
                                   '0:0', 1,
                                   -1),
                     0))),
            TO_CHAR (
               SUM (
                  DECODE (
                     TO_CHAR (sd.Creadate, 'HH24'),
                     '17', DECODE (sd.Machinebooking || ':' || sd.Cancellation,
                                   '1:1', 1,
                                   '0:0', 1,
                                   -1),
                     0))),
            TO_CHAR (
               SUM (
                  DECODE (
                     TO_CHAR (sd.Creadate, 'HH24'),
                     '18', DECODE (sd.Machinebooking || ':' || sd.Cancellation,
                                   '1:1', 1,
                                   '0:0', 1,
                                   -1),
                     0))),
            TO_CHAR (
               SUM (
                  DECODE (
                     TO_CHAR (sd.Creadate, 'HH24'),
                     '19', DECODE (sd.Machinebooking || ':' || sd.Cancellation,
                                   '1:1', 1,
                                   '0:0', 1,
                                   -1),
                     0))),
            TO_CHAR (
               SUM (
                  DECODE (
                     TO_CHAR (sd.Creadate, 'HH24'),
                     '20', DECODE (sd.Machinebooking || ':' || sd.Cancellation,
                                   '1:1', 1,
                                   '0:0', 1,
                                   -1),
                     0))),
            TO_CHAR (
               SUM (
                  DECODE (
                     TO_CHAR (sd.Creadate, 'HH24'),
                     '21', DECODE (sd.Machinebooking || ':' || sd.Cancellation,
                                   '1:1', 1,
                                   '0:0', 1,
                                   -1),
                     0))),
            TO_CHAR (
               SUM (
                  DECODE (
                     TO_CHAR (sd.Creadate, 'HH24'),
                     '22', DECODE (sd.Machinebooking || ':' || sd.Cancellation,
                                   '1:1', 1,
                                   '0:0', 1,
                                   -1),
                     0))),
            TO_CHAR (
               SUM (
                  DECODE (
                     TO_CHAR (sd.Creadate, 'HH24'),
                     '23', DECODE (sd.Machinebooking || ':' || sd.Cancellation,
                                   '1:1', 1,
                                   '0:0', 1,
                                   -1),
                     0))),
            TO_CHAR (
               SUM (
                  DECODE (sd.Machinebooking || ':' || sd.Cancellation,
                          '1:1', 1,
                          '0:0', 1,
                          -1)))
       FROM SalesDetail sd,
            SalesDetail sub,
            MiscCardMovement mcm,
            SalesTransaction st,
            TVMTable tvm,
            tvmStation sta
      WHERE     1 = 1
            --
            -- Join conditions
            --
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
            AND sd.DeviceID = st.DeviceID
            AND sd.DeviceClassID = st.DeviceClassID
            AND sd.UniqueMSID = st.UniqueMSID
            AND sd.SalesTransactionNo = st.SalesTransactionNo
            AND sd.PartitioningDate = st.PartitioningDate
            AND tvm.TVMID = st.DeviceID
            AND tvm.DeviceClassID = st.DeviceClassID
            AND sta.StationID(+) = tvm.TVMTariffLocationID
            --
            -- Filter conditions
            --

            AND mcm.MovementType IN (7, 20)
            AND sd.ArticleNo > 100000
            AND sd.CorrectionFlag = 0
            AND sd.RealStatisticArticle = 0
            AND sd.TempBooking = 0
            AND sd.ArticleNo <> 607900100
            AND sub.ArticleNo(+) = 607900100
            AND st.TestSaleFlag = 0
            AND mcm.DeviceClassID IN (SELECT DeviceClassID
                                        FROM DeviceClass
                                       WHERE DeviceClassType IN (5 -- Fareboxes
                                                                  ))
            --
            -- Parameter conditions
            --

            AND sd.CreaDate >= :dDateFirst
            AND sd.CreaDate <= :dDateLast
            AND sd.PartitioningDate >= :dPartitioningDateFirst
            AND sd.PartitioningDate < :dPartitioningDateLast
            AND 1 = 1
   GROUP BY sd.BranchLineId, sta.NAME
   
   
   
   
   
select * from ridership   

delete from ridership