-- Below is for gate_ridership or Gate usage
SELECT /*+ ORDERED FULL (mcm) FULL (ms) FULL (sd) FULL (st) USE_Hash (mcm) USE_Hash (ms) USE_Hash (sd) USE_Hash (st) USE_NL (sub) USE_NL(tvm) USE_NL (sta) */
To_Char(sd.creadate,'mm/dd/yyyy'), tt.description Product, sta.name Location, tst.description tickettype, rt.description route,sd.deviceId,
To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '03', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider3am,
To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '04', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider4am,
To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '05', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider5am,
To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '06', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider6am,
To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '07', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider7am,
To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '08', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider8am,
To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '09', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider9am,
To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '10', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider10am,
To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '11', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider11am,
To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '12', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider12pm,
To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '13', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider1pm,
To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '14', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider2pm,
To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '15', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider3pm,
To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '16', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider4pm,
To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '17', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider5pm,
To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '18', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider6pm,
To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '19', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider7pm,
To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '20', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider8pm,
To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '21', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider9pm,
To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '22', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider10pm,
To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '23', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider11pm,
To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '00', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider12am,
To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '01', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider1am,
To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '02', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider2am
From MiscCardMovement mcm , SalesDetail sd ,SalesDetail sub ,SalesTransaction st, tICKETTYPE TT, TVMTable tvm, tvmStation sta,
ticketstocktype tst, routes rt
Where 1 = 1 AND tvm.TVMID=st.DeviceID
AND tvm.DeviceClassID = st.DeviceClassID AND sta.StationID(+) =tvm.TVMTariffLocationID
AND sub.DeviceClassId (+) = sd.DeviceClassId AND sub.DeviceId (+) = sd.DeviceId
AND sub.Uniquemsid (+) = sd.Uniquemsid AND sub.SalestransactionNo (+) = sd.SalesTransactionNo
AND sub.SalesDetailEvSequNo (+) = sd.SalesDetailEvSequNo+1 AND sub.CorrectionCounter(+) = sd.CorrectionCounter
AND sub.PartitioningDate (+) = sd.PartitioningDate AND mcm.DeviceClassId = sd.DeviceClassId
AND mcm.DeviceId = sd.DeviceId AND mcm.Uniquemsid = sd.Uniquemsid AND mcm.SalestransactionNo = sd.SalesTransactionNo
AND mcm.SequenceNo = Decode(sub.SalesDetailEvSequNo ,NULL   ,sd.SalesDetailEvSequNo,sub.SalesDetailEvSequNo)
AND mcm.CorrectionCounter = sd.CorrectionCounter AND mcm.PartitioningDate= sd.PartitioningDate
AND mcm.TimeStamp = sd.CreaDate AND sd.DeviceID = st.DeviceID AND sd.DeviceClassID = st.DeviceClassID
AND sd.UniqueMSID = st.UniqueMSID AND sd.SalesTransactionNo = st.SalesTransactionNo
AND sd.PartitioningDate = st.PartitioningDate AND sd.articleno = tt.tickettypeid
AND sd.tariffversion = tt.versionid AND tst.inttickettype = sd.ticketstocktype
and sd.CreaDate = st.CreaDate
AND mcm.TimeStamp >= To_Date('2012-03-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')
AND mcm.TimeStamp < To_Date('2012-04-01-02-59-59', 'YYYY-MM-DD-HH24:MI:SS')
AND mcm.PartitioningDate >= To_Date('2012-03-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')
AND mcm.PartitioningDate < To_Date('2012-04-01-02-59-59', 'YYYY-MM-DD-HH24:MI:SS')
AND sd.PartitioningDate >= To_Date('2012-03-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')
AND sd.PartitioningDate < To_Date('2012-04-01-02-59-59', 'YYYY-MM-DD-HH24:MI:SS')
AND st.PartitioningDate >= To_Date('2012-03-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')
AND st.PartitioningDate < To_Date('2012-04-01-02-59-59', 'YYYY-MM-DD-HH24:MI:SS')
AND mcm.MovementType in (7,2) -- used to be 1 but chnged to 7 and 2 after talking to Rob. For gates, only use 7,2
--7 validate
--20 cash
--2 upgrade 
--1 Sale
AND sd.ArticleNo > 100000 
AND sd.CorrectionFlag = 0
AND sd.RealStatisticArticle = 0 
AND sd.TempBooking = 0 
AND sd.ArticleNo <> 607900100
AND sub.ArticleNo (+) =607900100 
AND st.TestSaleFlag = 0 
AND rt.routeid = tvm.routeid
AND sta.StationType =0 --This represents only subway stations but when using device type 411 and 441 this is not required as those devices are only at subway stations.
AND mcm.DeviceClassID IN (441,411) -- These are gates.
AND sd.ticketstocktype <> 5 --These are smart cards and are not requred for this usage.
Group By To_Char(sd.creadate,'mm/dd/yyyy'),tt.description,sta.name,tst.description, rt.description, sd.deviceId







/*+ 
ORDERED FULL (mcm) 
FULL (ms) 
FULL (sd) 
FULL (st) 
USE_Hash (mcm) 
USE_Hash (ms) 
USE_Hash (sd) 
USE_Hash (st) 
USE_NL (sub) 
USE_NL(tvm) 
USE_NL (sta) 
*/

        /*+
            ORDERED
            FULL        (det)
            FULL        (mcm)
            FULL        (st)
            USE_HASH    (det)
            USE_HASH    (mcm)
            USE_HASH    (st)
            USE_NL        (sub)
        */







-- ********
-- *** BELOW IS MUCH BETTER AND FASTER WITH THE NEW HINTS. SAME AS ABOVE BUT GETS THE RESULTS IN only 20 mins, where as above takes 45 mins. This not only includes GATES but also the FVMs.
-- ********
SELECT /*+
    LEADING  (sd)
    FULL     (sd) 
    INDEX    (sub XIE1SalesDetail) 
    USE_HASH (sub) 
    USE_NL   (mcm) 
    USE_NL   (st) 
    INDEX    (mcm XIE5MiscCardMovement)  
    INDEX    (st XPKSalesTransaction) 
    USE_NL   (tvm) 
    USE_NL   (sta) 
    */                   
        sta.name Location, 
        rt.description route,
        sd.DeviceClassID,
        sd.deviceId,
		To_Char(sd.creadate,'mm/dd/yyyy') usage_Date,
        TO_CHAR (SUM(DECODE(sd.Machinebooking || ':' || sd.Cancellation,'1:1', 1,'0:0', 1, -1))) tot_usage
From SalesDetail sd,
     SalesDetail sub,
     MiscCardMovement mcm, 
     SalesTransaction st, 
     TICKETTYPE TT,
     ticketstocktype tst,
     tvmStation sta,            
     TVMTable tvm, 
     routes rt
Where 1 = 1 
AND sub.DeviceClassId (+) = sd.DeviceClassId 
AND sub.DeviceId (+) = sd.DeviceId
AND sub.Uniquemsid (+) = sd.Uniquemsid 
AND sub.SalestransactionNo (+) = sd.SalesTransactionNo
AND sub.SalesDetailEvSequNo (+) = sd.SalesDetailEvSequNo+1 
AND sub.CorrectionCounter(+) = sd.CorrectionCounter
AND sub.PartitioningDate (+) = sd.PartitioningDate
AND mcm.DeviceClassId = sd.DeviceClassId
AND mcm.DeviceId = sd.DeviceId 
AND mcm.Uniquemsid = sd.Uniquemsid 
AND mcm.SalestransactionNo = sd.SalesTransactionNo
AND mcm.SequenceNo = Decode(sub.SalesDetailEvSequNo ,NULL   ,sd.SalesDetailEvSequNo,sub.SalesDetailEvSequNo)
AND mcm.CorrectionCounter = sd.CorrectionCounter
AND mcm.TimeStamp = sd.CreaDate  
AND mcm.PartitioningDate= sd.PartitioningDate
AND sd.DeviceID = st.DeviceID 
AND sd.DeviceClassID = st.DeviceClassID
AND sd.UniqueMSID = st.UniqueMSID 
AND sd.SalesTransactionNo = st.SalesTransactionNo
and sd.CreaDate = st.CreaDate
AND sd.PartitioningDate = st.PartitioningDate
AND sd.ticketstocktype = tst.inttickettype
-- 
AND sd.articleno = tt.tickettypeid
AND sd.tariffversion = tt.versionid
--  
AND tvm.TVMID=st.DeviceID
AND tvm.DeviceClassID = st.DeviceClassID
-- 
AND sta.StationID(+) =tvm.TVMTariffLocationID
--
AND rt.routeid = tvm.routeid
--
AND sd.CreaDate         >= to_date('2013-01-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
AND sd.CreaDate         <= to_date('2013-02-01-02-59-59','YYYY-MM-DD-HH24-MI-SS')
AND sd.PartitioningDate >= To_Date('2013-01-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')
AND sd.PartitioningDate <  To_Date('2013-04-01-02-59-59', 'YYYY-MM-DD-HH24:MI:SS')
AND mcm.MovementType in (1,2,7) --  2 and 7 are for gates, 1 is for FVM's
--7 validate
--20 cash
--2 upgrade
--1 Sale
AND sd.ArticleNo > 100000 
AND sd.CorrectionFlag = 0
AND sd.RealStatisticArticle = 0 
AND sd.TempBooking = 0 
AND sd.ArticleNo <> 607900100
AND sd.DeviceClassID IN (201,202,441,411)  --Includes both gates and FVM's
AND sd.ticketstocktype <> 5 --These are smart cards and are not requred for this usage.
AND sub.ArticleNo (+) =607900100 
AND st.TestSaleFlag = 0 
AND sta.StationType =0 --This represents only subway stations but when using device type 411 and 441 this is not required as those devices are only at subway stations.
Group By sta.name,
         rt.description,
         sd.DeviceClassID, 
         sd.deviceId,
		 To_Char(sd.creadate,'mm/dd/yyyy')

		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
		 
--************************************************************
--BELOW IS FOR FVM USAGE
--************************************************************

SELECT /*+ ORDERED FULL (mcm) FULL (ms) FULL (sd) FULL (st) USE_Hash (mcm) USE_Hash (ms) USE_Hash (sd) USE_Hash (st) USE_NL (sub) USE_NL(tvm) USE_NL (sta) */
 To_Char(sd.creadate,'mm/dd/yyyy'), tt.description Product, sta.name Location, tst.description tickettype, rt.description route,sd.deviceId,
 To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '03', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider3am,
 To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '04', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider4am,
 To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '05', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider5am,
 To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '06', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider6am,
 To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '07', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider7am,
 To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '08', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider8am,
 To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '09', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider9am,
 To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '10', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider10am,
 To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '11', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider11am,
 To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '12', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider12pm,
 To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '13', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider1pm,
 To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '14', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider2pm,
 To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '15', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider3pm,
 To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '16', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider4pm,
 To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '17', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider5pm,
 To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '18', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider6pm,
 To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '19', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider7pm,
 To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '20', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider8pm,
 To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '21', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider9pm,
 To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '22', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider10pm,
 To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '23', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider11pm,
 To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '00', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider12am,
 To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '01', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider1am,
 To_Char(sum(Decode(To_Char(sd.Creadate,'HH24'), '02', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))) rider2am
From MiscCardMovement mcm , SalesDetail sd ,SalesDetail sub ,SalesTransaction st, tICKETTYPE TT, TVMTable tvm, tvmStation sta,
ticketstocktype tst, routes rt
Where 1 = 1 AND tvm.TVMID=st.DeviceID
AND tvm.DeviceClassID = st.DeviceClassID AND sta.StationID(+) =tvm.TVMTariffLocationID
AND sub.DeviceClassId (+) = sd.DeviceClassId AND sub.DeviceId (+) = sd.DeviceId
AND sub.Uniquemsid (+) = sd.Uniquemsid AND sub.SalestransactionNo (+) = sd.SalesTransactionNo
AND sub.SalesDetailEvSequNo (+) = sd.SalesDetailEvSequNo+1 AND sub.CorrectionCounter(+) = sd.CorrectionCounter
AND sub.PartitioningDate (+) = sd.PartitioningDate AND mcm.DeviceClassId = sd.DeviceClassId
AND mcm.DeviceId = sd.DeviceId AND mcm.Uniquemsid = sd.Uniquemsid AND mcm.SalestransactionNo = sd.SalesTransactionNo
AND mcm.SequenceNo = Decode(sub.SalesDetailEvSequNo ,NULL   ,sd.SalesDetailEvSequNo,sub.SalesDetailEvSequNo)
AND mcm.CorrectionCounter = sd.CorrectionCounter AND mcm.PartitioningDate= sd.PartitioningDate
AND mcm.TimeStamp = sd.CreaDate AND sd.DeviceID = st.DeviceID AND sd.DeviceClassID = st.DeviceClassID
AND sd.UniqueMSID = st.UniqueMSID AND sd.SalesTransactionNo = st.SalesTransactionNo
AND sd.PartitioningDate = st.PartitioningDate AND sd.articleno = tt.tickettypeid
AND sd.tariffversion = tt.versionid AND tst.inttickettype = sd.ticketstocktype
and sd.CreaDate = st.CreaDate
AND mcm.TimeStamp >= To_Date('2012-03-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')
AND mcm.TimeStamp < To_Date('2012-04-01-02-59-59', 'YYYY-MM-DD-HH24:MI:SS')
AND mcm.PartitioningDate >= To_Date('2012-03-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')
AND mcm.PartitioningDate < To_Date('2012-04-01-02-59-59', 'YYYY-MM-DD-HH24:MI:SS')
AND sd.PartitioningDate >= To_Date('2012-03-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')
AND sd.PartitioningDate < To_Date('2012-04-01-02-59-59', 'YYYY-MM-DD-HH24:MI:SS')
AND st.PartitioningDate >= To_Date('2012-03-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')
AND st.PartitioningDate < To_Date('2012-04-01-02-59-59', 'YYYY-MM-DD-HH24:MI:SS')
AND mcm.MovementType in (1,2) -- For FVMs only 1 and 2
AND sd.ArticleNo > 100000 
AND sd.CorrectionFlag = 0
AND sd.RealStatisticArticle = 0 
AND sd.TempBooking = 0 
AND sd.ArticleNo <> 607900100
AND sub.ArticleNo (+) =607900100 
AND st.TestSaleFlag = 0 
AND rt.routeid = tvm.routeid
AND sta.StationType =0 
AND mcm.DeviceClassID IN (201,202)  -- Only FVMs
AND sd.ticketstocktype <> 5
Group By To_Char(sd.creadate,'mm/dd/yyyy'),tt.description,sta.name,tst.description, rt.description, sd.deviceId