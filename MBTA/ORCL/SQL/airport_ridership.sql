-- Below is HINTS FOR MONTHLY DATA, even monthly will use index hints as this is only for airport station
-- HUGE HUGE advantage with the ORDER in which the tables are in the from clause below and the hints used
-- query takes only 3 minutes, else it takes around an hour.

SELECT 
/*+ 
	ORDERED 
	INDEX (sd XPKSALESDETAIL)	
    INDEX (sub XIE1SalesDetail) 
	INDEX (mcm XIE5MiscCardMovement)  
	INDEX (st XPKSalesTransaction) 	
	USE_HASH (sub) 
	USE_NL (mcm) 
	USE_NL (st) 
	USE_NL (tvm) 
	USE_NL (sta) 
*/
To_Char(sd.creadate,'mm/dd/yyyy') Dt
, sd.deviceId
, mcm.DeviceClassID
, sta.name Location
--, tst.description tickettype
, rt.description route,
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
From tvmStation sta
, TVMTable tvm
, SalesTransaction st 
, SalesDetail sd 
, SalesDetail sub 
, MiscCardMovement mcm 
, tICKETTYPE TT
--, ticketstocktype tst
, routes rt
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
AND mcm.SequenceNo = Decode(sub.SalesDetailEvSequNo ,NULL   ,sd.SalesDetailEvSequNo,sub.SalesDetailEvSequNo)
AND mcm.CorrectionCounter = sd.CorrectionCounter 
AND mcm.PartitioningDate= sd.PartitioningDate
AND mcm.TimeStamp = sd.CreaDate
AND sd.DeviceClassID = st.DeviceClassID 
AND sd.DeviceID = st.DeviceID 
AND sd.UniqueMSID = st.UniqueMSID 
AND sd.SalesTransactionNo = st.SalesTransactionNo
AND sd.PartitioningDate = st.PartitioningDate 
AND sd.articleno = tt.tickettypeid
AND sd.tariffversion = tt.versionid 
--AND tst.inttickettype = sd.ticketstocktype
AND sd.CreaDate = st.CreaDate
/*
AND mcm.TimeStamp >= To_Date('2012-05-13-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')
AND mcm.TimeStamp < To_Date('2012-05-14--02-59-59', 'YYYY-MM-DD-HH24:MI:SS')
AND mcm.PartitioningDate >= To_Date('2012-03-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')
AND mcm.PartitioningDate < To_Date('2012-04-01-02-59-59', 'YYYY-MM-DD-HH24:MI:SS')
AND sd.PartitioningDate >= To_Date('2012-03-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')
AND sd.PartitioningDate < To_Date('2012-04-01-02-59-59', 'YYYY-MM-DD-HH24:MI:SS')
AND st.PartitioningDate >= To_Date('2012-03-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')
AND st.PartitioningDate < To_Date('2012-04-01-02-59-59', 'YYYY-MM-DD-HH24:MI:SS')
*/
AND    sd.CreaDate            >= to_date('2012-07-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
AND    sd.CreaDate            <= to_date('2012-08-01-02-59-59','YYYY-MM-DD-HH24-MI-SS')
AND    sd.PartitioningDate    >= to_date('2012-07-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
AND    sd.PartitioningDate    <  to_date('2012-09-01-00-00-00','YYYY-MM-DD-HH24-MI-SS')
--
AND mcm.MovementType in (7,20)  -- This is what is used for ridership reports for Mellissa
--7 validate
--20 cash
--2 upgrade 
AND sd.ArticleNo > 100000 
AND sd.CorrectionFlag = 0
AND sd.RealStatisticArticle = 0 
AND sd.TempBooking = 0 
AND sd.ArticleNo <> 607900100
AND sub.ArticleNo (+) =607900100 
AND st.TestSaleFlag = 0 
AND rt.routeid = tvm.routeid
AND sta.stationid = 1011 -- Only airport Station.
--AND sta.StationType =0 --Ridership reports to melissa doesn't have this cond but gates ridership report has this, commenting at this point.
--AND mcm.DeviceClassID IN (441,411) --These are only to get gates but the ridership reports to melissa do not have these but the gates ridership query has this, so not sure to use this condition or not to fileter data, commenting it at this point.
Group By To_Char(sd.creadate,'mm/dd/yyyy'),sta.name, rt.description, sd.deviceId, mcm.DeviceClassID
--,tst.description, ,tt.description;



-- Below query is for daily data.

SELECT /*+ ORDERED INDEX (sub XIE1SalesDetail) USE_HASH (sub) USE_NL (mcm) USE_NL	(st) INDEX(mcm XIE5MiscCardMovement) INDEX (sd XIE8SalesDetail) INDEX (st XPKSalesTransaction) USE_NL(tvm) USE_NL (sta) */
To_Char(sd.creadate,'mm/dd/yyyy') Dt
, sd.deviceId
, mcm.DeviceClassID
, sta.name Location
--, tst.description tickettype
, rt.description route,
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
From SalesDetail sd 
, SalesDetail sub 
, MiscCardMovement mcm 
, SalesTransaction st
, tICKETTYPE TT
, TVMTable tvm
, tvmStation sta
--, ticketstocktype tst
, routes rt
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
AND mcm.SequenceNo = Decode(sub.SalesDetailEvSequNo ,NULL   ,sd.SalesDetailEvSequNo,sub.SalesDetailEvSequNo)
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
--AND tst.inttickettype = sd.ticketstocktype
AND sd.CreaDate = st.CreaDate
/*
AND mcm.TimeStamp >= To_Date('2012-05-13-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')
AND mcm.TimeStamp < To_Date('2012-05-14--02-59-59', 'YYYY-MM-DD-HH24:MI:SS')
AND mcm.PartitioningDate >= To_Date('2012-03-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')
AND mcm.PartitioningDate < To_Date('2012-04-01-02-59-59', 'YYYY-MM-DD-HH24:MI:SS')
AND sd.PartitioningDate >= To_Date('2012-03-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')
AND sd.PartitioningDate < To_Date('2012-04-01-02-59-59', 'YYYY-MM-DD-HH24:MI:SS')
AND st.PartitioningDate >= To_Date('2012-03-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')
AND st.PartitioningDate < To_Date('2012-04-01-02-59-59', 'YYYY-MM-DD-HH24:MI:SS')
*/
AND    sd.CreaDate            >= to_date('2012-05-13-03-00-00','YYYY-MM-DD-HH24-MI-SS')
AND    sd.CreaDate            <= to_date('2012-05-14-02-59-59','YYYY-MM-DD-HH24-MI-SS')
AND    sd.PartitioningDate    >= to_date('2012-05-13-03-00-00','YYYY-MM-DD-HH24-MI-SS')
AND    sd.PartitioningDate    <  to_date('2012-05-31-00-00-00','YYYY-MM-DD-HH24-MI-SS')
--
AND mcm.MovementType in (7,20)  -- This what is used for ridership reports for Mellissa
--7 validate
--20 cash
--2 upgrade 
AND sd.ArticleNo > 100000 
AND sd.CorrectionFlag = 0
AND sd.RealStatisticArticle = 0 
AND sd.TempBooking = 0 
AND sd.ArticleNo <> 607900100
AND sub.ArticleNo (+) =607900100 
AND st.TestSaleFlag = 0 
AND rt.routeid = tvm.routeid
AND sta.stationid = 1011 -- Only airport Station.
--AND sta.StationType =0 --Ridership reports to melissa doesn't have this cond but gates ridership report has this, commenting at this point.
--AND mcm.DeviceClassID IN (441,411) --These are only to get gates but the ridership reports to melissa do not have these but the gates ridership query has this, so not sure to use this condition or not to fileter data, commenting it at this point. Found out later that since we are using movement type 7 and 20, they are only possible at the above device classids.
Group By To_Char(sd.creadate,'mm/dd/yyyy'),sta.name, rt.description, sd.deviceId, mcm.DeviceClassID
--,tst.description, ,tt.description