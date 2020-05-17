SELECT /*+ ORDERED FULL (mcm) FULL (ms) FULL (sd) FULL (st) USE_Hash (mcm) USE_Hash (ms) USE_Hash (sd) USE_Hash (st) USE_NL (sub) USE_NL(tvm) USE_NL (sta) */
sta.tvmstation, tt.description Product, To_Char(Nvl(sd.BranchLineId, 0)) BranchLineid, tst.description tickettype, sd.fareoptamount amount,
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
From MiscCardMovement mcm 
    , SalesDetail sd 
    , SalesDetail sub 
    , SalesTransaction st
    , tICKETTYPE TT
    , TVMTable tvm
    , tvmStation sta
    , ticketstocktype tst
Where 1 = 1 
AND tvm.TVMID=st.DeviceID 
AND tvm.DeviceClassID = st.DeviceClassID
AND sta.StationID(+) =tvm.TVMTariffLocationID 
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
AND mcm.SequenceNo = Decode(sub.SalesDetailEvSequNo ,NULL ,sd.SalesDetailEvSequNo,sub.SalesDetailEvSequNo)
AND mcm.CorrectionCounter = sd.CorrectionCounter 
AND mcm.PartitioningDate= sd.PartitioningDate 
AND mcm.TimeStamp = sd.CreaDate
AND sd.DeviceID = st.DeviceID 
AND sd.DeviceClassID = st.DeviceClassID 
AND sd.UniqueMSID = st.UniqueMSID
AND sd.SalesTransactionNo = st.SalesTransactionNo 
AND sd.PartitioningDate = st.PartitioningDate 
AND sd.articleno = tt.tickettypeid
AND sd.tariffversion = tt.versionid 
AND tst.inttickettype (+) = sd.ticketstocktype 
and sd.CreaDate = st.CreaDate
AND mcm.TimeStamp >= To_Date('2009-12-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')
AND mcm.TimeStamp < To_Date('2009-12-03-02-59-59', 'YYYY-MM-DD-HH24:MI:SS')
AND mcm.PartitioningDate >= To_Date('2009-12-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')
AND mcm.PartitioningDate < To_Date('2010-01-04-00-00-00', 'YYYY-MM-DD-HH24:MI:SS')
AND sd.PartitioningDate >= To_Date('2009-12-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')
AND sd.PartitioningDate < To_Date('2010-01-04-00-00-00', 'YYYY-MM-DD-HH24:MI:SS')
AND st.PartitioningDate >= To_Date('2009-12-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')
AND st.PartitioningDate < To_Date('2010-01-04-00-00-00', 'YYYY-MM-DD-HH24:MI:SS')
AND mcm.MovementType IN (7,20) 
AND sd.ArticleNo > 100000 
AND sd.CorrectionFlag = 0
AND sd.RealStatisticArticle = 0 
AND sd.TempBooking = 0 
AND sd.ArticleNo <> 607900100
and sd.ticketstocktype <> 40 
AND sub.ArticleNo (+) =607900100 
AND st.TestSaleFlag = 0
AND sta.StationType (+) = 1 
AND mcm.DeviceClassID = 501
Group By tt.description,sd.BranchLineId,tst.description, sd.fareoptamount, sta.tvmstation

