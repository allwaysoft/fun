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
EXECUTE IMMEDIATE 'TRUNCATE TABLE MBTA_TEMP_GATES_1_YEAR';
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
Insert into MBTA_TEMP_GATES_1_YEAR
SELECT 
/*+ ORDERED 
FULL (mcm) 
FULL (ms) 
FULL (sd) 
FULL (st)
FULL (tt) 
INDEX (sub XIE1SalesDetail)                  
USE_Hash (mcm) 
USE_Hash (ms) 
USE_Hash (sd) 
USE_Hash (st) 
USE_Hash (sub) 
USE_Hash (tt)
USE_NL(tvm) 
USE_NL (sta) 
*/       
To_Char(sd.creadate,'yyyy/mm/dd') CreateDate
, tt.description Product
, sta.name Location
, tst.description tickettype
, rou.description route 
, sd.deviceId DeviceId
, sd.fareoptamount Cashvalue
, To_Char(sum(decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1))) Riders, 
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
salesDetail sub,
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
AND rou.RouteID         =    ms.RouteNo
AND tt.tickettypeid(+) = sd.articleno
AND tt.versionid(+) = sd.tariffversion 
AND tst.inttickettype(+) = sd.ticketstocktype
--and sd.CreaDate = st.CreaDate
AND sd.creadate >= ddatefirst_loop --To_Date('2009-09-01-03-00-00','YYYY-MM-DD-HH24:MI:SS')
AND sd.creadate <= ddatelast_loop                                      --To_Date('2010-02-01-02-59-59','YYYY-MM-DD-HH24:MI:SS')
AND sd.PartitioningDate >= ddatefirst_loop                            --To_Date('2010-09-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')
AND sd.PartitioningDate < ddatelast_loop+30                          --To_Date('2010-03-01-00-00-00', 'YYYY-MM-DD-HH24:MI:SS')
--AND sd.PartitioningDate >= To_Date('2009-07-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')
--AND sd.PartitioningDate < To_Date('2010-07-04-00-00-00', 'YYYY-MM-DD-HH24:MI:SS')
--AND st.PartitioningDate >= To_Date('2009-07-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')
--AND st.PartitioningDate < To_Date('2010-07-04-00-00 -00', 'YYYY-MM-DD-HH24:MI:SS')
--AND mcm.MovementType =7
AND mcm.MovementType    IN     (7, 20) 
AND sd.ArticleNo > 100000 
AND sd.CorrectionFlag = 0
AND sd.RealStatisticArticle = 0 
AND sd.TempBooking = 0 
AND sd.ArticleNo <> 607900100
AND sub.ArticleNo (+) =607900100 
AND st.TestSaleFlag = 0 
AND sta.StationType =0
---------- Added the below conditon to match the numbers with the ridership reports. Change it accordingly if the ridership reports are changed.
and sta.stationid in 
(
1051,1052,1053,1054,1055,1056,1057,1058,1059,1060,1061,1101,
1002,1004,1005,1006,1007,1009,1020,1032,1033,1034,1035,1036,1037,1040,1042,1043,1041,1103,1112,2106,
1010,1011,1012,1013,1014,1015,1016,1017,1018,1019,
1039,1070,1071,1072,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,1086,1087,
1115,1116
) 
--green, red, blue, orange and silver lines are above stationid's
------------------------------------------------------------------------------------------------
AND rou.routeid in
(
1400,    
1200,    
1000,    
1300,    
1100    
)
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