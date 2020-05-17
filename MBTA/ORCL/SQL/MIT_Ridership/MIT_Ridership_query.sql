-- If run for a year, this will run over night.
------set serverouput on
------set serveroutput on size 200000
------alter session set nls_date_format = 'MM-DD-YYYY:HH24:MI:SS';
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
dDatelast_loop	DATE;                             -- Date last for looping
ddate_plc_holder date;                                             
--
begin
--
execute immediate 'truncate table mbta_temp_mit_ridership';
--
loop
--
if months_between(ddate_end, ddatefirst_loop) > 1
--if  ddate_end - ddatefirst_loop > 7
then
ddatelast_loop := add_months(ddatefirst_loop -1/(24*60*60), 1);
--ddatelast_loop := (ddatefirst_loop-1/(24*60*60)) + 7;
else
ddatelast_loop := ddate_end;
end if;
--
insert into mbta_temp_mit_ridership
SELECT 
st.deviceclassid
, To_char(st.creadate,'YYYY-MM-DD-HH24:MI:SS') --createdate
, sd.BranchLineId --route
, sd.fareoptamount --amount
, sd.DeviceId
, tt.description --ticketdesc
, sd.ticketserialno
, tst.description --description
, tvm.tvmtarifflocationid
, sta.name --Location 
, mcm.movementtype
, decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1, 0) --trans
, Decode(mcm.movementtype, 7, 'Validation', 20, 'Cash AND Go') --movement 
From MiscCardMovement mcm 
,SalesDetail sd 
,SalesDetail sub 
,SalesTransaction st
,tICKETTYPE TT
,TVMTable tvm
,tvmStation sta
,ticketstocktype tst 
,MiscFuncItemMovement        fimvt1 
,MiscFuncItemMovement        fimvt2 
,MiscFuncItemMovement        fimvt3 
,MiscFuncItemMovement        fimvt4 
,MiscFuncItemMovement        fimvt5 
,MiscFuncItemMovement        fimvt6 
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
AND mcm.SequenceNo = Decode(sub.SalesDetailEvSequNo ,NULL ,sd.SalesDetailEvSequNo,sub.SalesDetailEvSequNo) 
AND mcm.CorrectionCounter = sd.CorrectionCounter 
AND mcm.PartitioningDate= sd.PartitioningDate 
AND mcm.TimeStamp = sd.CreaDate 
AND fimvt1.CardMovementId    (+)    =    mcm.CardMovementId 
AND fimvt1.ElementId        (+)    =    714 
AND fimvt1.PartitioningDate    (+)    =    mcm.PartitioningDate 
AND fimvt2.CardMovementId    (+)    =    mcm.CardMovementId 
AND fimvt2.ElementId        (+)    =    713 
AND fimvt2.PartitioningDate    (+)    =    mcm.PartitioningDate 
AND fimvt3.CardMovementId    (+)    =    mcm.CardMovementId 
AND fimvt3.ElementId        (+)    =    20                        
AND fimvt3.PartitioningDate    (+)    =    mcm.PartitioningDate 
AND fimvt4.CardMovementId    (+)    =    mcm.CardMovementId 
AND fimvt4.ElementId        (+)    =    21 
AND fimvt4.PartitioningDate    (+)    =    mcm.PartitioningDate 
AND fimvt5.CardMovementId    (+)    =    mcm.CardMovementId 
AND fimvt5.ElementId        (+)    =    38 
AND fimvt5.PartitioningDate    (+)    =    mcm.PartitioningDate 
AND fimvt6.CardMovementId    (+)    =    mcm.CardMovementId 
AND fimvt6.ElementId        (+)    =    39 
AND fimvt6.PartitioningDate    (+)    =    mcm.PartitioningDate 
AND sd.DeviceID = st.DeviceID 
AND sd.DeviceClassID = st.DeviceClassID 
AND sd.UniqueMSID = st.UniqueMSID 
AND sd.SalesTransactionNo = st.SalesTransactionNo 
AND sd.PartitioningDate = st.PartitioningDate 
AND sd.articleno = tt.tickettypeid 
AND sd.tariffversion = tt.versionid 
AND tst.inttickettype (+) = sd.ticketstocktype 
AND tvm.DeviceClassID = sd.DeviceClassID 
AND tvm.TVMID=sd.DeviceID 
AND sta.StationId (+)= tvm.TVMTariffLocationID  
and sd.CreaDate = st.CreaDate 
AND sd.CreaDate           >=  ddatefirst_loop
AND sd.CreaDate           <=  ddatelast_loop
AND sd.PartitioningDate   >=  ddatefirst_loop
AND sd.PartitioningDate   <=  trunc(last_day(add_months(ddatelast_loop, 1)))
/* 
AND    sd.CreaDate           >=  To_Date('2012-06-01-03-00-03', 'YYYY-MM-DD-HH24:MI:SS')                     
AND    sd.CreaDate           <=  To_Date('2012-12-01-02-59-59', 'YYYY-MM-DD-HH24:MI:SS') 
AND    sd.PartitioningDate   >=  To_Date('2012-06-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')   
AND    sd.PartitioningDate   <=  To_Date('2013-01-01-02-59-59', 'YYYY-MM-DD-HH24:MI:SS')      
*/ 
AND mcm.movementtype IN (7,20) 
AND sd.ArticleNo > 100000 
AND sd.CorrectionFlag = 0 
AND sd.RealStatisticArticle = 0 
AND sd.TempBooking = 0 
AND sd.ArticleNo <> 607900100 
AND sub.ArticleNo (+) =607900100 
AND st.TestSaleFlag = 0 
AND sta.StationType (+) = 1 
AND mcm.DeviceClassID in (501,411,441,901,801,802, 902);
/*
Added new device class 902 later
*/   
--
commit;
--
------dbms_output.put_line(ddatefirst_loop ||'---'|| dDatelast_loop);
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
--************************************************************************
/* -- Below is taking longer
SELECT
--/*+ 
FULL (mcm) 
FULL (sd) 
FULL (st) 
USE_Hash (mcm) 
USE_Hash (sd) 
USE_Hash (st) 
USE_NL (sub)
INDEX(fimvt1 XPKMISCFUNCITEMMOVEMENT)
INDEX(fimvt2 XPKMISCFUNCITEMMOVEMENT)
INDEX(fimvt3 XPKMISCFUNCITEMMOVEMENT)
INDEX(fimvt4 XPKMISCFUNCITEMMOVEMENT)
INDEX(fimvt5 XPKMISCFUNCITEMMOVEMENT)
INDEX(fimvt6 XPKMISCFUNCITEMMOVEMENT)
--/
st.deviceclassid
, To_char(st.creadate,'YYYY-MM-DD-HH24:MI:SS') --createdate
, sd.BranchLineId --route
, sd.fareoptamount --amount
, sd.DeviceId
, tt.description --ticketdesc
, sd.ticketserialno
, tst.description --description
, tvm.tvmtarifflocationid
, sta.name --Location 
, mcm.movementtype
, decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1, 0) --trans
, Decode(mcm.movementtype, 7, 'Validation', 20, 'Cash AND Go') --movement 
From MiscCardMovement mcm 
,SalesDetail sd 
,SalesDetail sub 
,SalesTransaction st
,tICKETTYPE TT
,TVMTable tvm
,tvmStation sta
,ticketstocktype tst 
,MiscFuncItemMovement        fimvt1 
,MiscFuncItemMovement        fimvt2 
,MiscFuncItemMovement        fimvt3 
,MiscFuncItemMovement        fimvt4 
,MiscFuncItemMovement        fimvt5 
,MiscFuncItemMovement        fimvt6 
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
AND mcm.SequenceNo = Decode(sub.SalesDetailEvSequNo ,NULL ,sd.SalesDetailEvSequNo,sub.SalesDetailEvSequNo) 
AND mcm.CorrectionCounter = sd.CorrectionCounter 
AND mcm.PartitioningDate= sd.PartitioningDate 
AND mcm.TimeStamp = sd.CreaDate 
AND fimvt1.CardMovementId    (+)    =    mcm.CardMovementId 
AND fimvt1.ElementId        (+)    =    714 
AND fimvt1.PartitioningDate    (+)    =    mcm.PartitioningDate 
AND fimvt2.CardMovementId    (+)    =    mcm.CardMovementId 
AND fimvt2.ElementId        (+)    =    713 
AND fimvt2.PartitioningDate    (+)    =    mcm.PartitioningDate 
AND fimvt3.CardMovementId    (+)    =    mcm.CardMovementId 
AND fimvt3.ElementId        (+)    =    20                        
AND fimvt3.PartitioningDate    (+)    =    mcm.PartitioningDate 
AND fimvt4.CardMovementId    (+)    =    mcm.CardMovementId 
AND fimvt4.ElementId        (+)    =    21 
AND fimvt4.PartitioningDate    (+)    =    mcm.PartitioningDate 
AND fimvt5.CardMovementId    (+)    =    mcm.CardMovementId 
AND fimvt5.ElementId        (+)    =    38 
AND fimvt5.PartitioningDate    (+)    =    mcm.PartitioningDate 
AND fimvt6.CardMovementId    (+)    =    mcm.CardMovementId 
AND fimvt6.ElementId        (+)    =    39 
AND fimvt6.PartitioningDate    (+)    =    mcm.PartitioningDate 
AND sd.DeviceID = st.DeviceID 
AND sd.DeviceClassID = st.DeviceClassID 
AND sd.UniqueMSID = st.UniqueMSID 
AND sd.SalesTransactionNo = st.SalesTransactionNo 
AND sd.PartitioningDate = st.PartitioningDate 
AND sd.articleno = tt.tickettypeid 
AND sd.tariffversion = tt.versionid 
AND tst.inttickettype (+) = sd.ticketstocktype 
AND tvm.DeviceClassID = sd.DeviceClassID 
AND tvm.TVMID=sd.DeviceID 
AND sta.StationId (+)= tvm.TVMTariffLocationID 
and sd.CreaDate = st.CreaDate
AND    sd.CreaDate           >=  To_Date('2012-09-11-03-00-03', 'YYYY-MM-DD-HH24:MI:SS')                     
AND    sd.CreaDate           <=  To_Date('2012-09-17-02-59-59', 'YYYY-MM-DD-HH24:MI:SS') 
AND    sd.PartitioningDate   >=  To_Date('2012-09-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')   
AND    sd.PartitioningDate   <=  To_Date('2012-10-01-02-59-59', 'YYYY-MM-DD-HH24:MI:SS')  
/* 
AND    sd.CreaDate           >=  To_Date('2012-06-01-03-00-03', 'YYYY-MM-DD-HH24:MI:SS')                     
AND    sd.CreaDate           <=  To_Date('2012-12-01-02-59-59', 'YYYY-MM-DD-HH24:MI:SS') 
AND    sd.PartitioningDate   >=  To_Date('2012-06-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')   
AND    sd.PartitioningDate   <=  To_Date('2013-01-01-02-59-59', 'YYYY-MM-DD-HH24:MI:SS')      
/ 
AND mcm.movementtype IN (7,20) 
AND sd.ArticleNo > 100000 
AND sd.CorrectionFlag = 0 
AND sd.RealStatisticArticle = 0 
AND sd.TempBooking = 0 
AND sd.ArticleNo <> 607900100 
AND sub.ArticleNo (+) =607900100 
AND st.TestSaleFlag = 0 
AND sta.StationType (+) = 1 
AND mcm.DeviceClassID in (501,411,441,901,801,802, 902);
*/