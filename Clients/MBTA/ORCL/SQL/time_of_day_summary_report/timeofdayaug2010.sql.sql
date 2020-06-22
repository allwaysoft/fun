create table  temp_time_of_day_line_aug2010 as
SELECT
    /*+
        ORDERED
        INDEX        (sub    XIE1SalesDetail)
        USE_HASH    (sd)
        USE_HASH    (sub)        
        USE_HASH    (mcm)
        USE_HASH    (st)
        USE_HASH    (ms)
        USE_HASH    (hol)
        parallel(sd 8)
        parallel(sub 8)
        parallel(mcm 8)
        parallel(st 8)
        parallel(ms 8)
        FULL        (sd)
        FULL        (mcm)
        FULL        (st)
        FULL        (ms)        
        USE_NL        (rou)
        USE_NL        (tvm)
        USE_NL        (sta)
    */
	(case when sta.stationid in (15,1051,1052,1053,1054,1054,1055,1056,1057,1058,1059,1060,1061,1062,1091,1092,1093
                                        ,1094,1095,1096,1097,1098,1099,1100,1101,1102,1105,1106,1107,1108,1109,1111,1114)
  then 1000           --Green Line                   
  when sta.stationid in (1002,1004,1005,1006,1007,1009,1020,1032,1033,1034,1035,1036,1037,1040,1041,1042,1043,1103,1112,2106)
  then 1100           --Red Line
  when sta.stationid in(1010,1010,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019) 
  then 1200           --Blue Line
  when sta.stationid in (1039,1070,1071,1072,1073,1074,1075,1076,1077,1078,1079,1080,1080,1081,1082,1083,1084,1085,1086,1087)
  then 1300            --Orange Line
  when sta.stationid in (1115,1116)
  then 1400
  else
  rou.routeid
  end)                 "LINE ID"--Line Id
,sta.stationid      "STATION ID"--Station Id
  ,(case when sta.stationid in (15,1051,1052,1053,1054,1054,1055,1056,1057,1058,1059,1060,1061,1062,1091,1092,1093
                                         ,1094,1095,1096,1097,1098,1099,1100,1101,1102,1105,1106,1107,1108,1109,1111,1114)
  then (select description from routes where routeid = 1000 and rownum <=1)          --Green Line                   
  when sta.stationid in (1002,1004,1005,1006,1007,1009,1020,1032,1033,1034,1035,1036,1037,1040,1041,1042,1043,1103,1112,2106)
  then (select description from routes where routeid = 1100 and rownum <=1)           --Red Line
  when sta.stationid in(1010,1010,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019) 
  then (select description from routes where routeid = 1200 and rownum <=1)          --Blue Line
  when sta.stationid in (1039,1070,1071,1072,1073,1074,1075,1076,1077,1078,1079,1080,1080,1081,1082,1083,1084,1085,1086,1087)
  then (select description from routes where routeid = 1300 and rownum <=1)          --Orange Line
  when sta.stationid in (1115,1116)
  then (select description from routes where routeid = 1400 and rownum <=1)          --Silver Line
  else
  rou.description
  end)                            "LINE NAME" --Line
 , sta.Name           "STATION NAME"                                                         --    Station
  ,sum(decode(hol.service_date, null, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 )) "WD COUNT"                                          --weekdays Count
    ,round((sum(decode(hol.service_date, null, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 )))/22) "WD AVG"                                          --weekdays Count
  ,sum(decode(hol.service_type, 2, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 ))    "SA COUNT"                                          --Saturday Count
  ,round(sum(decode(hol.service_type, 2, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 ))/4)    "SA AVG"                                          --Saturday Count                                                                
  ,sum(decode(hol.service_type, 3, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 ))    "SU COUNT"                                          --Sunday Count
  ,round(sum(decode(hol.service_type, 3, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 ))/5)    "SU AVG"                                          --Sunday Count  
  ,sum(decode(hol.service_type, 1, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 ))    "HD COUNT"                                          --Holidays Count
  ,round(sum(decode(hol.service_type, 1, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 ))/1)    "HD AVG"                                          --Holidays Count  
  ,sum(decode(hol.service_date, null, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 )
       + decode(hol.service_type, 2, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 )
       + decode(hol.service_type, 3, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 )
       + decode(hol.service_type, 1, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 )
         )                                                                                                                                                   "TD COUNT"
  ,round(sum(decode(hol.service_date, null, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 )
       + decode(hol.service_type, 2, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 )
       + decode(hol.service_type, 3, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 )
       + decode(hol.service_type, 1, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 )
         )/31)   "TD AVG"         
FROM
SalesDetail               sd
,SalesDetail               sub
,MiscCardMovement   mcm
,SalesTransaction       st
,Mainshift                  ms
,Routes                    rou
,TVMTable                tvm
,tvmStation               sta
,mbta_weekend_service              hol
WHERE        1=1
--
--    Join conditions
--
AND    sub.DeviceClassId       (+)    = sd.DeviceClassId
AND    sub.DeviceId               (+)    = sd.DeviceId
AND    sub.Uniquemsid             (+)    = sd.Uniquemsid
AND    sub.SalestransactionNo    (+)    = sd.SalesTransactionNo
AND    sub.SalesDetailEvSequNo    (+)    = sd.SalesDetailEvSequNo    +1
AND    sub.CorrectionCounter    (+)    = sd.CorrectionCounter
AND    sub.PartitioningDate    (+)    = sd.PartitioningDate
AND    mcm.DeviceClassId           = sd.DeviceClassId
AND    mcm.DeviceId                   = sd.DeviceId
AND    mcm.Uniquemsid                 = sd.Uniquemsid
AND    mcm.SalestransactionNo        = sd.SalesTransactionNo
AND    mcm.SequenceNo                = Decode    (sub.SalesDetailEvSequNo
                                                    ,NULL    ,sd.SalesDetailEvSequNo
                                                ,sub.SalesDetailEvSequNo
                                                )
AND    mcm.CorrectionCounter        = sd.CorrectionCounter
AND    mcm.PartitioningDate        = sd.PartitioningDate
AND    mcm.TimeStamp                = sd.CreaDate
AND   st.DeviceID =  mcm.DeviceID         
AND   st.DeviceClassID =  mcm.DeviceClassID        
AND    st.UniqueMSID = mcm.UniqueMSID                
AND    st.SalesTransactionNo =  mcm.SalesTransactionNo     
AND    st.PartitioningDate = mcm.PartitioningDate     
AND    ms.DeviceClassId    =    st.DeviceClassId
AND    ms.DeviceId            =    st.DeviceId
AND    ms.Uniquemsid        =    st.Uniquemsid
AND    ms.EndCreaDate        =    st.PartitioningDate
AND    tvm.TVMID            =    ms.DeviceID
AND    tvm.DeviceClassID    =    ms.DeviceClassID
AND    sta.StationID     (+)    =    tvm.TVMTariffLocationID
AND    rou.RouteID         =    ms.RouteNo
AND    trunc(hol.service_date (+)) = trunc(sd.creadate)
AND    trunc(hol.service_date(+), 'hh24')  = trunc(sd.creadate, 'hh24')
--
--    Filter conditions
--
AND    mcm.MovementType    IN     (7,20)
AND    sd.ArticleNo                >     100000
AND    sd.CorrectionFlag            =     0
AND    sd.RealStatisticArticle        =     0
AND    sd.TempBooking                =     0
AND    sd.ArticleNo                <>     607900100
AND    sub.ArticleNo            (+)    =    607900100
AND    st.TestSaleFlag                =     0
AND	rou.routeid in 
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
-- Subway Stations Only 
--
--    Parameter conditions
--
AND    sd.CreaDate            >= to_date('2010-08-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
AND    sd.CreaDate            <= to_date('2010-09-01-02-59-59','YYYY-MM-DD-HH24-MI-SS')
AND    sd.PartitioningDate    >= to_date('2010-08-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
AND    sd.PartitioningDate    <  to_date('2010-10-01-00-00-00','YYYY-MM-DD-HH24-MI-SS')
AND  hol.service_date(+) >= to_date('2010-08-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')     --This and below line are very important otherwise it is taking 10 hrs for 1 month.
AND  hol.service_date(+) <= to_date('2010-09-01-02-59-59','YYYY-MM-DD-HH24-MI-SS')
GROUP BY rou.routeid, sta.stationid, rou.Description, sta.Name;




select line id,  from temp_time_of_day_line_aug2010







SELECT 
decode("LINE ID", 741, -999
                        , 742, -999
                        , 743, -999
                        , 746, -999
                       , "LINE ID"
          )  "LINE ID",
  "STATION ID",
decode("LINE ID", 741, 'SL Waterfront'
                        , 742, 'SL Waterfront'
                        , 743, 'SL Waterfront'
                        , 746, 'SL Waterfront'
                       , "LINE NAME"
            )  "LINE NAME",
  "STATION NAME",
  sum("WD COUNT") "WD COUNT",
  round(sum("WD COUNT")/22) "WD AVG", 
  sum( "SA COUNT") "SA COUNT",
 round(sum( "SA COUNT")/4) "SA AVG",
sum("SU COUNT") "SU COUNT",
  round(sum("SU COUNT")/5) "SU AVG",
  sum("HD COUNT") "HD COUNT",
  round(sum("HD COUNT")/1) "HD AVG",
  sum("TD COUNT") "TD COUNT",
  round(sum("TD COUNT")/31) "TD AVG"
FROM TEMP_TIME_OF_DAY_LINE_AUG2010
where   decode("LINE ID", 1000, decode("STATION ID", 1051, -99, 1052, -99, 1053, -99, 1054, -99, 1055, -99
, 1056, -99, 1057, -99, 1058, -99, 1059, -99, 1060, -99, 1061, -99, 1101, -99, "STATION ID"), "STATION ID")  = decode("LINE ID", 1000,  -99, "STATION ID") -- Only particular stations for green line and all 
 group by decode("LINE ID", 741, -999
                        , 742, -999
                        , 743, -999
                        , 746, -999
                       , "LINE ID"
          ), "STATION ID", decode("LINE ID", 741, 'SL Waterfront'
                        , 742, 'SL Waterfront'
                        , 743, 'SL Waterfront'
                        , 746, 'SL Waterfront'
                       , "LINE NAME"
            ), "STATION NAME" 
order by "LINE NAME", "STATION NAME";









