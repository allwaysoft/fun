select * from routes where Routeid in 
  (
   746,	 
   741,	
   742,	
   743,	
   751,	
   749,	
   1400,	
   1200,	
   1000,	
   1300,	
   1100	
  ) 
  
  
  
  

741	SL/Bus SL1/SL3 Waterfront 
742	SL/Bus SL2 Waterfront 
743	SL/Bus SL2_3/SL3 Waterfront 
746	SL/Bus SL Waterfront 
749	SL5/Bus SL Washington
751	SL4/SL Dudley-S.Station
1000	Subway Green Line
1100	Subway Red Line
1200	Subway Blue Line
1300	Subway Orange Line
1400	Silver Line

select distinct sta.stationid, sta.name 
from 
   (select /*+ INDEX (mainshift XIE5MAINSHIFT) */
    distinct deviceid, deviceclassid, Uniquemsid, EndCreaDate
      from mainshift
    where routeno in (741,742,743,746)
    and trunc(EndCreaDate) >= to_date('01-05-2010', 'dd-mm-yyyy')
   )  ms
	,TVMTable	tvm
	,tvmStation	sta
  ,SalesDetail sd
  ,MiscCardMovement mcm
  ,SalesTransaction st
  Where 1=1
    AND tvm.TVMID =	ms.DeviceID
	  AND tvm.DeviceClassID =	ms.DeviceClassID
	  AND sta.StationID(+)	=	tvm.TVMTariffLocationID
    AND mcm.DeviceClassId = sd.DeviceClassId 
    AND mcm.DeviceId = sd.DeviceId 
    AND mcm.Uniquemsid = sd.Uniquemsid 
    AND mcm.SalestransactionNo = sd.SalesTransactionNo 
    AND mcm.SequenceNo = sd.SalesDetailEvSequNo
    AND mcm.CorrectionCounter = sd.CorrectionCounter 
    AND mcm.PartitioningDate = sd.PartitioningDate 
    AND mcm.TimeStamp = sd.CreaDate 
    AND sd.DeviceID = st.DeviceID 
    AND sd.DeviceClassID = st.DeviceClassID 
    AND sd.UniqueMSID = st.UniqueMSID 
    AND sd.SalesTransactionNo = st.SalesTransactionNo 
    AND sd.PartitioningDate = st.PartitioningDate
	  AND	ms.DeviceClassId	=	st.DeviceClassId
	  AND	ms.DeviceId			=	st.DeviceId
	  AND	ms.Uniquemsid		=	st.Uniquemsid
	  AND	ms.EndCreaDate		=	st.PartitioningDate  
    AND	trunc(st.PartitioningDate)  >=  to_date('01-05-2010', 'dd-mm-yyyy')
    AND mcm.MovementType IN (7, 20) 
    AND sd.ArticleNo > 100000 
    AND sd.CorrectionFlag = 0 
    AND sd.RealStatisticArticle = 0 
    AND sd.TempBooking = 0 
    AND sd.ArticleNo <> 607900100 
    AND st.TestSaleFlag = 0

order by sta.name


select * from tvmstation
where stationid in (1051,1052,1053,1054,1055,1056,1057,1058,1059,1060,1061,1101) -- All greenline station for report

select * from tvmstation
where stationid in (1039,1075, 1076, 1077) -- orange line station level details for these station only


1009   -- red line station id for which detail is required in the report


select * from salestransaction where trunc(partitioningdate) = to_date('22-06-2009', 'dd-mm-yyyy')   


select * from tempresult_mbta


select count(1) from mbta_holiday