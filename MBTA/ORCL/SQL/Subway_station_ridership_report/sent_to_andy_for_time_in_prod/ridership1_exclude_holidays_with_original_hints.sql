SELECT     -- Took 1hr 13 mins in Prod
    /*+
		ORDERED
		USE_HASH	(sub)
		INDEX		(sub	XIE1SalesDetail)
		USE_HASH	(mcm)
		USE_HASH	(sd)
		USE_HASH	(st)
		FULL		(mcm)
		FULL		(sd)
		FULL		(st)
		USE_NL		(tvm)
		USE_NL		(sta)
	*/ 1 --:QueryID 
      , 
       1, 
       sta.Name --	Station 
                , 
       sum(decode(sd.Machinebooking || ':' || sd.Cancellation, '1:1', 1, '0:0', 1, -1)), 
       20 --:ndays 
  FROM SalesDetail sd, 
       SalesDetail sub, 
       MiscCardMovement mcm, 
       SalesTransaction st, 
       TVMTable tvm, 
       tvmStation sta 
 WHERE 1 = 1 -- 
             --	Join conditions 
             -- 
   AND sub.DeviceClassId (+) = sd.DeviceClassId 
   AND sub.DeviceId (+) = sd.DeviceId 
   AND sub.Uniquemsid (+) = sd.Uniquemsid 
   AND sub.SalestransactionNo (+) = sd.SalesTransactionNo 
   AND sub.SalesDetailEvSequNo (+) = sd.SalesDetailEvSequNo + 1 
   AND sub.CorrectionCounter (+) = sd.CorrectionCounter 
   AND sub.PartitioningDate (+) = sd.PartitioningDate 
   AND mcm.DeviceClassId = sd.DeviceClassId 
   AND mcm.DeviceId = sd.DeviceId 
   AND mcm.Uniquemsid = sd.Uniquemsid 
   AND mcm.SalestransactionNo = sd.SalesTransactionNo 
   AND mcm.SequenceNo = Decode(sub.SalesDetailEvSequNo, NULL, sd.SalesDetailEvSequNo, sub.SalesDetailEvSequNo) 
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
   AND sta.StationID (+) = tvm.TVMTariffLocationID -- 
                                                   --	Filter conditions 
                                                   -- 
   AND mcm.MovementType IN (7, 20) 
   AND sd.ArticleNo > 100000 
   AND sd.CorrectionFlag = 0 
   AND sd.RealStatisticArticle = 0 
   AND sd.TempBooking = 0 
   AND sd.ArticleNo <> 607900100 
   AND sub.ArticleNo (+) = 607900100 
   AND st.TestSaleFlag = 0 -- Exclude holidays and weekends with the below condition 
   AND (to_char(sd.creadate, 'D') not in ('1', '7') 
         or trunc(sd.creadate) not in (select dateis 
                                         from (
select to_date('01-01-2008 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('01-01-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('01-01-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('01-01-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('01-21-2008 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('01-19-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('01-18-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('01-17-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('02-18-2008 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('02-16-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('02-15-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('02-21-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('04-18-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('04-19-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('04-20-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('04-21-2008 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('05-30-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('05-31-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('05-25-2008 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('05-26-2008 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('06-17-2008 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('06-17-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('06-17-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('06-17-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('07-04-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('07-04-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('07-04-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('07-04-2008 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('07-05-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('07-08-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('09-05-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('09-06-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('09-07-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('09-01-2008 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('10-10-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('10-11-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('10-12-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('10-13-2008 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('11-11-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('11-11-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('11-11-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('11-11-2008 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('11-24-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('11-25-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('11-26-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('11-27-2008 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('11-25-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('11-26-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('11-27-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('11-28-2008 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('12-24-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('12-24-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('12-25-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('12-25-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('12-25-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('12-25-2008 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('12-26-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('12-31-2008 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('12-31-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('12-31-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('12-31-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('05-25-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual                                         ) 
                                        where dateis between trunc(to_date('2010-05-01-00-00-01', 'YYYY-MM-DD-HH24-MI-SS')) and trunc(to_date('2010-06-01-00-00-01', 'YYYY-MM-DD-HH24-MI-SS')))) 
   AND mcm.DeviceClassID IN (SELECT DeviceClassID 
                               FROM DeviceClass 
                              WHERE DeviceClassType IN (5 --	Fareboxes 
                                                          )) -- 
                                                             --	Parameter conditions 
                                                             -- 
   AND sd.CreaDate >= to_date('2010-05-01-00-00-01', 'YYYY-MM-DD-HH24-MI-SS') 
   AND sd.CreaDate <= to_date('2010-06-01-00-00-01', 'YYYY-MM-DD-HH24-MI-SS') 
   AND sd.PartitioningDate >= to_date('2010-05-01-00-00-01', 'YYYY-MM-DD-HH24-MI-SS') 
   AND sd.PartitioningDate < to_date('2010-06-01-00-00-01', 'YYYY-MM-DD-HH24-MI-SS') 
   AND 1 = 1 
 group by 1, 1, sta.Name, 20
