declare
date1 date := to_date('09/01/2009 03:00:00 AM', 'mm/dd/yyyy hh:mi:ss AM');
date2 date;
date3 date;
begin
EXECUTE IMMEDIATE 'TRUNCATE TABLE mbta_temp_farebox_1_year';
for i in 1..4
loop
date2 := add_months(date1, 3)-1/86400;
date3 := add_months(date1, 4)-3/24;
Insert into mbta_temp_farebox_1_year
SELECT 
/*+ 
ORDERED 
FULL (mcm) 
FULL (sd)          
FULL (st) 
INDEX (sub XIE1SalesDetail)
parallel (sd 4) 
parallel (st 4) 
parallel (mcm 4) 
parallel (sub 4) 
USE_Hash (mcm) 
USE_Hash (sd)             
USE_Hash (st) 
USE_HASH (sub)        
USE_NL (tvm) 
USE_NL (sta) 
*/
to_char(sd.Creadate,'mm/dd/yyyy') CreateDate, 
To_Char(Nvl(sd.BranchLineId, 0)) Signcode, 
tt.description Product, 
tst.description Stocktype,
sd.fareoptamount Cashvalue, 
To_Char(sum(decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1))) Riders,
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
From SalesDetail sd,
SalesDetail sub,
MiscCardMovement mcm,
SalesTransaction st,
TVMTable tvm, 
tvmStation sta,
tICKETTYPE tt, 
ticketstocktype tst 
Where 1 = 1 
AND sub.DeviceClassId       (+)    = sd.DeviceClassId
AND sub.DeviceId               (+)    = sd.DeviceId
AND sub.Uniquemsid             (+)    = sd.Uniquemsid
AND sub.SalestransactionNo    (+)    = sd.SalesTransactionNo
AND sub.SalesDetailEvSequNo    (+)    = sd.SalesDetailEvSequNo    +1
AND sub.CorrectionCounter    (+)    = sd.CorrectionCounter
AND sub.PartitioningDate    (+)    = sd.PartitioningDate
-------
AND mcm.DeviceClassId           = sd.DeviceClassId
AND mcm.DeviceId                   = sd.DeviceId
AND mcm.Uniquemsid                 = sd.Uniquemsid
AND mcm.SalestransactionNo        = sd.SalesTransactionNo
AND mcm.SequenceNo  = Decode(sub.SalesDetailEvSequNo, NULL, sd.SalesDetailEvSequNo, sub.SalesDetailEvSequNo)
AND mcm.CorrectionCounter        = sd.CorrectionCounter
AND mcm.PartitioningDate        = sd.PartitioningDate
AND mcm.TimeStamp                = sd.CreaDate
-------
AND st.DeviceID = sd.DeviceID
AND st.DeviceClassID = sd.DeviceClassID
AND st.UniqueMSID = sd.UniqueMSID
AND st.SalesTransactionNo = sd.SalesTransactionNo
AND st.PartitioningDate = sd.PartitioningDate
-------
AND tvm.TVMID            =    st.DeviceID
AND tvm.DeviceClassID    =    st.DeviceClassID
-------
AND sta.StationID     =    tvm.TVMTariffLocationID
-------
AND tt.tickettypeid(+) = sd.articleno
AND tt.versionid(+)= sd.tariffversion 
-------
AND tst.inttickettype(+)= sd.ticketstocktype
-------
AND sd.creadate >= date1				--To_Date('2009-09-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')
AND sd.creadate <= date2				--To_Date('2009-10-01-02-59-59', 'YYYY-MM-DD-HH24:MI:SS')
AND sd.PartitioningDate >= date1  			--To_Date('2009-09-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')
AND sd.PartitioningDate < date3 			--To_Date('2009-11-01-00-00-00', 'YYYY-MM-DD-HH24:MI:SS')
-------
AND mcm.MovementType IN (7,20) 
AND sd.ArticleNo > 100000 
AND sd.CorrectionFlag = 0
AND sd.RealStatisticArticle = 0 
AND sd.TempBooking = 0 
AND sd.ArticleNo <> 607900100
AND sub.ArticleNo (+) =607900100 
AND st.TestSaleFlag = 0
AND sta.StationType  = 1 
--AND mcm.DeviceClassID = 501
AND    mcm.DeviceClassID  IN    (SELECT DeviceClassID FROM DeviceClass WHERE  DeviceClassType  IN  (5))  --    Fareboxes
-------Added below condition to match with the ridership information given to Melissa. Change it accordingly if the ridership reports are changed.
and sta.stationid in ('1','3','4','5','6','7','8','12','13','11','14','18')     
-------------------------------------------------------------------------------------------------
Group By to_char(sd.Creadate,'mm/dd/yyyy'),sd.BranchLineId,tt.description,tst.description, sd.fareoptamount;
select add_months(date1, 3) into date1 from dual;
commit;
end loop;
end;
/