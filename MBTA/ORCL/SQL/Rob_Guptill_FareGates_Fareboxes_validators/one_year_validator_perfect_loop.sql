-- This will not take more than 1 hr.

accept start_date prompt 'Enter Value for start_date in mm/dd/yyyy-hh-mi-ss format:'
accept end_date prompt 'Enter Value for end_date in mm/dd/yyyy-hh-mi-ss format:'
--
var ddatefirst varchar2(30)
var ddatelast varchar2(30)
--
exec :ddatefirst := '&start_date';
exec :ddatelast := '&end_date';
--
declare
--
ddate_start DATE := to_date(:ddatefirst,'mm/dd/yyyy-hh-mi-ss');
ddate_end DATE := to_date(:ddatelast,'mm/dd/yyyy-hh-mi-ss');
dDateFirst_loop	DATE := ddate_start;                                -- Date first for looping
dDatelast_loop	DATE;                                               -- Date last for looping
--
begin
--
EXECUTE IMMEDIATE 'TRUNCATE TABLE mbta_temp_validator_1_year';
--
loop
--
if  months_between(ddate_end, ddatefirst_loop) > 3
then
ddatelast_loop := add_months(ddatefirst_loop -1/(24*60*60), 3);
else
ddatelast_loop := ddate_end;
end if;
--
INSERT INTO mbta_temp_validator_1_year
SELECT 
/*+ 
ORDERED 
INDEX(sd, XPKSALESDETAIL)
INDEX (sub XIE1SalesDetail)                      
INDEX(mcm, XIE5MISCCARDMOVEMENT)
INDEX(sub, XPKSALESDETAIL)  
INDEX(ms, XPKMAINSHIFT)
INDEX(st, XPKSALESTRANSACTION)
USE_Hash (mcm) 
USE_Hash (ms) 
USE_Hash (sd) 
USE_Hash (st) 
USE_NL (sub) 
USE_NL(tvm) 
USE_NL (sta) 
*/
To_Char(sd.creadate,'yyyy/mm/dd') CreateDate, 
tt.description Product, 
sta.name Location, 
tst.description tickettype, 
rou.description route, 
sd.deviceId DeviceId, 
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
Mainshift ms, 
routes rou,        
TVMTable tvm, 
tvmStation sta,
tICKETTYPE tt, 
ticketstocktype tst  
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
AND mcm.PartitioningDate= sd.PartitioningDate
AND mcm.TimeStamp = sd.CreaDate 
AND st.DeviceID = sd.DeviceID 
AND st.DeviceClassID = sd.DeviceClassID
AND st.UniqueMSID = sd.UniqueMSID 
AND st.SalesTransactionNo = sd.SalesTransactionNo 
AND st.PartitioningDate = sd.PartitioningDate
AND ms.DeviceClassId  =    st.DeviceClassId
AND ms.DeviceId         =    st.DeviceId
AND ms.Uniquemsid    =    st.Uniquemsid
AND ms.EndCreaDate  =    st.PartitioningDate 
AND tvm.TVMID=ms.DeviceID
AND tvm.DeviceClassID = ms.DeviceClassID 
AND sta.StationID =tvm.TVMTariffLocationID
AND rou.RouteID  =    ms.RouteNo
AND tt.tickettypeid(+)= sd.articleno
AND tt.versionid(+)= sd.tariffversion 
AND tst.inttickettype(+)= sd.ticketstocktype
--and sd.CreaDate = st.CreaDate
AND sd.creadate >= ddatefirst_loop --To_Date('2009-09-01-03-00-00','YYYY-MM-DD-HH24:MI:SS')
AND sd.creadate <= ddatelast_loop                                      --To_Date('2010-02-01-02-59-59','YYYY-MM-DD-HH24:MI:SS')
AND sd.PartitioningDate >= ddatefirst_loop                            --To_Date('2010-09-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')
AND sd.PartitioningDate < ddatelast_loop+30                          --To_Date('2010-03-01-00-00-00', 'YYYY-MM-DD-HH24:MI:SS')
--AND sd.PartitioningDate >= To_Date(datefirst_loop, 'YYYY-MM-DD-HH24:MI:SS')
--AND sd.PartitioningDate < To_Date(datelast_loop, 'YYYY-MM-DD-HH24:MI:SS')
--AND st.PartitioningDate >= To_Date(datefirst_loop, 'YYYY-MM-DD-HH24:MI:SS')
--AND st.PartitioningDate < To_Date(datelast_loop+30, 'YYYY-MM-DD-HH24:MI:SS')
AND mcm.MovementType =7 
AND sd.ArticleNo > 100000 
AND sd.CorrectionFlag = 0
AND sd.RealStatisticArticle = 0 
AND sd.TempBooking = 0 
AND sd.ArticleNo <> 607900100
AND sub.ArticleNo (+) =607900100 
AND st.TestSaleFlag = 0 
-- Below conditions are for all the available validators
AND mcm.DeviceClassID in (801,802,803, 804,901,902,1801 )
-------------------------------------------------------------
Group By To_Char(sd.creadate,'yyyy/mm/dd'),tt.description,sta.name,tst.description, rou.description, sd.deviceId, sd.fareoptamount;
--select add_months(date1, 3) into date1 from dual;
--
commit;
--
if dDatelast_loop = ddate_end
then
exit;
else
  ddatefirst_loop := ddatelast_loop + 1/(24*60*60);
end if; 
--
end loop;
--
end;
/