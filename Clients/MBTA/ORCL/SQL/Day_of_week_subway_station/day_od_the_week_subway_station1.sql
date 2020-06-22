create table mbta_temp_day_of_week as
SELECT
    /*+
        ORDERED
        INDEX        (sub    XIE1SalesDetail)
        USE_HASH    (sd)
        USE_HASH    (sub)
        USE_HASH    (mcm)
        USE_HASH    (st)
        USE_HASH    (ms)
        USE_nl   (hol)    
        PARALLEL    (sd  2)
    PARALLEL (sub 2)
        PARALLEL    (mcm  2)
        PARALLEL    (st  2)
    PARALLEL    (ms  2)
        FULL        (sd)
        FULL        (mcm)
        FULL        (st)
    FULL        (ms)
        USE_NL        (rou)
        USE_NL        (tvm)
        USE_NL        (sta)
    */
     --:QueryID
   -- ,
   -- 1 
   -- ,
    rou.routeid         --Line Id
  ,sta.stationid       --Station Id
  ,rou.description    --  Line_Name
    ,sta.Name                         --    Station_Name

--,:sundays
--,:mondays
--,:tuesdays
--,:wednesdays
--,:thursdays
--,:fridays
--,:saturdays
--,:Totaldays
,decode(to_Char(sd.Creadate,'HH24'),'00',decode(to_char(sd.creadate,'d')-1,0,7,to_char(sd.creadate,'d')-1)
                                                     ,'01',decode(to_char(sd.creadate,'d')-1,0,7,to_char(sd.creadate,'d')-1)
                                                     ,'02',decode(to_char(sd.creadate,'d')-1,0,7,to_char(sd.creadate,'d')-1)
                                                           ,to_char(sd.creadate,'d')  
          )                                                                                                             day_of_week

,decode(to_Char(sd.Creadate,'HH24'),'00',decode(to_char(sd.creadate,'ddd')-1,0,to_char(trunc(sd.creadate,'yyyy')-1,'ddd') ,to_char(sd.creadate,'ddd')-1)
                                                     ,'01',decode(to_char(sd.creadate,'ddd')-1,0,to_char(trunc(sd.creadate,'yyyy')-1,'ddd') ,to_char(sd.creadate,'ddd')-1)
                                                     ,'02',decode(to_char(sd.creadate,'ddd')-1,0,to_char(trunc(sd.creadate,'yyyy')-1,'ddd') ,to_char(sd.creadate,'ddd')-1)
                                                           ,to_char(sd.creadate,'ddd')  
          )                                                                                                             day_of_year             
,hol.service_day                                                                                                 holiday_day_of_year

,nvl(sum(Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1)),0) tot_cnt--Totaldays Count

,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'00',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) hr00
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'01',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) hr01
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'02',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) hr02
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'03',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) hr03
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'04',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) hr04
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'05',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) hr05
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'06',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) hr06
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'07',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) hr07
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'08',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) hr08
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'09',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) hr09
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'10',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) hr10
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'11',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) hr11
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'12',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) hr12
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'13',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) hr13
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'14',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) hr14
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'15',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) hr15
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'16',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) hr16
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'17',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) hr17
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'18',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) hr18
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'19',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) hr19
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'20',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) hr20
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'21',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) hr21
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'22',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) hr22
,nvl(sum(Decode(To_Char(sd.Creadate,'HH24'),'23',decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0)),0) hr23
FROM
     SalesDetail            sd
    ,SalesDetail            sub
    ,MiscCardMovement        mcm
    ,SalesTransaction        st
    ,Mainshift                ms
    ,Routes                    rou
    ,TVMTable                tvm
    ,tvmStation                sta
    ,mbta_weekend_service1     hol
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

    AND    st.DeviceID = sd.DeviceID
    AND    st.DeviceClassID = sd.DeviceClassID
    AND    st.UniqueMSID = sd.UniqueMSID
    AND    st.SalesTransactionNo = sd.SalesTransactionNo
    AND    st.PartitioningDate = sd.PartitioningDate
    AND    ms.DeviceClassId    =    st.DeviceClassId
    AND    ms.DeviceId            =    st.DeviceId
    AND    ms.Uniquemsid        =    st.Uniquemsid
    AND    ms.EndCreaDate        =    st.PartitioningDate
    AND    tvm.TVMID            =    ms.DeviceID
    AND    tvm.DeviceClassID    =    ms.DeviceClassID
    AND    sta.StationID     (+)    =    tvm.TVMTariffLocationID
    AND    rou.RouteID            =    ms.RouteNo                                 --outer join not necessary for this report.
    
    AND    hol.service_day (+) = to_char(sd.creadate,'ddd')
    AND    hol.service_year (+)  = to_char(sd.creadate, 'yyyy')    
    
--
--    Filter conditions
--

    AND    mcm.MovementType    IN     (7,20)

    AND    sd.ArticleNo                >     100000
    AND    sd.CorrectionFlag            =     0
    AND    sd.RealStatisticArticle        =     0
    AND    sd.TempBooking                =     0
    AND sd.ArticleNo                <>     607900100
    AND sub.ArticleNo            (+)    =    607900100
    AND    st.TestSaleFlag                =     0

AND    rou.routeid in
(
1400,
1200,
1000,
1300,
1100
)   -- Subway Stations Only
--
--    Parameter conditions
--
    --AND    sd.CreaDate            >=      :dDateFirst                                             --to_date(:dDateFirst, 'mm/dd/yyyy hh24:mi:ss')
    --AND    sd.CreaDate            <=      :dDateLast
    --AND    sd.PartitioningDate    >= :dPartitioningDateFirst
    --AND    sd.PartitioningDate    <   :dPartitioningDateLast    
    AND    sd.CreaDate            >= to_date('2010-09-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
    AND    sd.CreaDate            <= to_date('2010-10-01-02-59-59','YYYY-MM-DD-HH24-MI-SS')
    AND    sd.PartitioningDate    >= to_date('2010-09-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
    AND    sd.PartitioningDate    <  to_date('2010-11-01-00-00-00','YYYY-MM-DD-HH24-MI-SS')    
--    AND    hol.service_date(+)            >= :dDateFirst                                        --to_date(:dDateFirst, 'mm/dd/yyyy hh24:mi:ss')
--    AND    hol.service_date(+)            <= :dDateLast
 AND sd.sellingrrid <> 2 AND 1=1 
GROUP BY rou.routeid
  ,sta.NAME
  ,sta.stationid
  ,rou.description
  ,decode(to_Char(sd.Creadate,'HH24'),'00',decode(to_char(sd.creadate,'d')-1,0,7,to_char(sd.creadate,'d')-1)
                                                        ,'01',decode(to_char(sd.creadate,'d')-1,0,7,to_char(sd.creadate,'d')-1)
                                                        ,'02',decode(to_char(sd.creadate,'d')-1,0,7,to_char(sd.creadate,'d')-1)
                                                              ,to_char(sd.creadate,'d')  
            )                                                               

  ,decode(to_Char(sd.Creadate,'HH24'),'00',decode(to_char(sd.creadate,'ddd')-1,0,to_char(trunc(sd.creadate,'yyyy')-1,'ddd') ,to_char(sd.creadate,'ddd')-1)
                                                        ,'01',decode(to_char(sd.creadate,'ddd')-1,0,to_char(trunc(sd.creadate,'yyyy')-1,'ddd') ,to_char(sd.creadate,'ddd')-1)
                                                        ,'02',decode(to_char(sd.creadate,'ddd')-1,0,to_char(trunc(sd.creadate,'yyyy')-1,'ddd') ,to_char(sd.creadate,'ddd')-1)
                                                              ,to_char(sd.creadate,'ddd')  
             )
  ,hol.service_day               
  
  
  
select * 
from mbta_temp_day_of_week
where day_of_year = holiday_day_of_year
  
  
 alter table mbta_temp_day_of_week rename column name to data31
 
 
 
 select to_char('abc') from dual
 
SELECT
     EXTRACT(day FROM TO_TIMESTAMP('01-JAN-2005 19:15:26',
        'DD-MON-YYYY HH24:MI:SS')) AS HOUR,
      EXTRACT(MINUTE FROM TO_TIMESTAMP('01-JAN-2005 19:15:26',
        'DD-MON-YYYY HH24:MI:SS')) AS MINUTE,
      EXTRACT(SECOND FROM TO_TIMESTAMP('01-JAN-2005 19:15:26',
        'DD-MON-YYYY HH24:MI:SS')) AS SECOND
    FROM dual;
    
    select extract(day from sysdate) from dual


 
 select
 line_id,
 station_id,
 line_name,
 station_name,
 day_of_week,
 sum(all_hrs_tot) all_hrs_tot,
 ----
sum( tot00)  tot00,
sum( tot01)  tot01,
sum( tot02)  tot02,
sum( tot03)  tot03,
sum( tot04)  tot04,
sum( tot05)  tot05,
sum( tot06)  tot06,
sum( tot07)  tot07,
sum( tot08)  tot08,
sum( tot09)  tot09,
sum( tot10)  tot10,
sum( tot11)  tot11,
sum( tot12)  tot12,
sum( tot13)  tot13,
sum( tot14)  tot14,
sum( tot15)  tot15,
sum( tot16)  tot16,
sum( tot17)  tot17,
sum( tot18)  tot18,
sum( tot19)  tot19,
sum( tot20)  tot20,
sum( tot21)  tot21,
sum( tot22)  tot22,
sum( tot23)  tot23
from
 (
select 
--queryid, lineid,
 (case when number2 in (1051,1052,1053,1054,1055,1056,1057,1058,1059,1060,1061,1101)
  then 1000           --Green Line                   
  when number2 in (1002,1004,1005,1006,1007,1009,1020,1032,1033,1034,1035,1036,1037,1040,1041,1042,1043,1103,1112,2106)
  then 1100           --Red Line
  when number2 in(1010,1010,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019) 
  then 1200           --Blue Line
  when number2 in (1039,1070,1071,1072,1073,1074,1075,1076,1077,1078,1079,1080,1080,1081,1082,1083,1084,1085,1086,1087)
  then 1300            --Orange Line
  when number2 in (1115,1116)
  then 1400            --Silver Line
/*
  when number2 in (1122)
  then 751              --SL4/SL Dudley-S.Station
*/ 
--  when number1 in (741,742,743,746)
--  then -999             --Silver Line Waterfront
  else
  number1
  end)                                                              Line_id, 
number2                                                         Station_id,
(case when number2 in (1051,1052,1053,1054,1055,1056,1057,1058,1059,1060,1061,1101)
  then (select ' '||description from routes where routeid = 1000 and rownum <=1)          --Green Line                   
  when number2 in (1002,1004,1005,1006,1007,1009,1020,1032,1033,1034,1035,1036,1037,1040,1041,1042,1043,1103,1112,2106)
  then (select ' '||description from routes where routeid = 1100 and rownum <=1)           --Red Line
  when number2 in(1010,1010,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019) 
  then (select ' '||description from routes where routeid = 1200 and rownum <=1)          --Blue Line
  when number2 in (1039,1070,1071,1072,1073,1074,1075,1076,1077,1078,1079,1080,1080,1081,1082,1083,1084,1085,1086,1087)
  then (select ' '||description from routes where routeid = 1300 and rownum <=1)          --Orange Line
  when number2 in (1115,1116)
  then (select ' '||description from routes where routeid = 1400 and rownum <=1)          --Silver Line
/*  
  when number2 in (1122)
  then (select ' '||description from routes where routeid = 751 and rownum <=1)            --SL4/SL Dudley-S.Station
*/  
--  when number1 in (741,742,743,746)
--  then ' SL Waterfront'
  else
  ' '||data30
  end)                                                          Line_name,
' '||data31 Station_name,
decode(day_of_year,holiday_day_of_year,8,day_of_week) day_of_week,
--day_of_year,
--holiday_day_of_year,
sum(hr00+hr01+hr02+hr03+hr04+hr05+hr06+hr07+hr08+hr09+hr10+hr11+hr12+hr13+hr14+hr15+hr16+hr17+hr18+hr19+hr20+hr21+hr22+hr23) all_hrs_tot,
----
sum(hr00) tot00,
sum(hr01) tot01,
sum(hr02) tot02,
sum(hr03) tot03,
sum(hr04) tot04,
sum(hr05) tot05,
sum(hr06) tot06,
sum(hr07) tot07,
sum(hr08) tot08,
sum(hr09) tot09,
sum(hr10) tot10,
sum(hr11) tot11,
sum(hr12) tot12,
sum(hr13) tot13,
sum(hr14) tot14,
sum(hr15) tot15,
sum(hr16) tot16,
sum(hr17) tot17,
sum(hr18) tot18,
sum(hr19) tot19,
sum(hr20) tot20,
sum(hr21) tot21,
sum(hr22) tot22,
sum(hr23) tot23
from mbta_temp_day_of_week
  where number2 in (1051,1052,1053,1054,1055,1056,1057,1058,1059,1060,1061,1101, --Green Line 
                           1002,1004,1005,1006,1007,1009,1020,1032,1033,1034,1035,1036,1037,1040,1042,1043,1041,1103,1112,2106, --Red Line
                           1010,1011,1012,1013,1014,1015,1016,1017,1018,1019, --Blue Line
                           1039,1070,1071,1072,1073,1074,1075,1076,1077,1078,1079,1080,1081,1082,1083,1084,1085,1086,1087, --Orange Line
                           1115,1116 --Silver Line
                           --,1,3,4,5,6,7,8,11,12,13,14,18 -- All other Silver Line Required for the report.
                          )
------------
group by number1, number2,data30, data31,day_of_week,day_of_year,holiday_day_of_year
)
group by line_id,
 station_id,
 line_name,
 station_name,
 day_of_week