ALTER SESSION SET TRACEFILE_IDENTIFIER = 'kran_index_exits';
ALTER SESSION SET SQL_TRACE = TRUE;
set timing on;
----
----
SELECT
/*+
parallel_INDEX (se, XIE2SHIFTEVENT, 2)
*/
-- FULL (se)
rou.routeid         --Line Id
,sta.stationid       --Station Id
,rou.description    --  Line_Name
,sta.Name						 --	Station_Name
,decode(to_Char(se.Creadate,'HH24'),'00',decode(to_char(se.creadate,'d')-1,0,7,to_char(se.creadate,'d')-1)
                                                     ,'01',decode(to_char(se.creadate,'d')-1,0,7,to_char(se.creadate,'d')-1)
                                                     ,'02',decode(to_char(se.creadate,'d')-1,0,7,to_char(se.creadate,'d')-1)
                                                            ,to_char(se.creadate,'d')
          )                                                                                                             day_of_week
,decode(to_Char(se.Creadate,'HH24'),'00',decode(to_char(se.creadate,'ddd')-1,0,to_char(trunc(se.creadate,'yyyy')-1,'ddd') ,to_char(se.creadate,'ddd')-1)
                                                     ,'01',decode(to_char(se.creadate,'ddd')-1,0,to_char(trunc(se.creadate,'yyyy')-1,'ddd') ,to_char(se.creadate,'ddd')-1)
                                                     ,'02',decode(to_char(se.creadate,'ddd')-1,0,to_char(trunc(se.creadate,'yyyy')-1,'ddd') ,to_char(se.creadate,'ddd')-1)
                                                            ,to_char(se.creadate,'ddd')
          )                                                                                                        day_of_year
,hol.service_day                                                                                                   holiday_day_of_year
,nvl(count(se.creadate),0) tot_hrs_count                            --Total_hrs Count
,Sum	(Decode	(To_Char	(se.CreaDate, 'HH24'), '00', 1 ,0))		Exits_00
,Sum	(Decode	(To_Char	(se.CreaDate, 'HH24'), '01', 1 ,0))		Exits_01
,Sum	(Decode	(To_Char	(se.CreaDate, 'HH24'), '02', 1 ,0))		Exits_02
,Sum	(Decode	(To_Char	(se.CreaDate, 'HH24'), '03', 1 ,0))		Exits_03
,Sum	(Decode	(To_Char	(se.CreaDate, 'HH24'), '04', 1 ,0))		Exits_04
,Sum	(Decode	(To_Char	(se.CreaDate, 'HH24'), '05', 1 ,0))		Exits_05
,Sum	(Decode	(To_Char	(se.CreaDate, 'HH24'), '06', 1 ,0))		Exits_06
,Sum	(Decode	(To_Char	(se.CreaDate, 'HH24'), '07', 1 ,0))		Exits_07
,Sum	(Decode	(To_Char	(se.CreaDate, 'HH24'), '08', 1 ,0))		Exits_08
,Sum	(Decode	(To_Char	(se.CreaDate, 'HH24'), '09', 1 ,0))		Exits_09
,Sum	(Decode	(To_Char	(se.CreaDate, 'HH24'), '10', 1 ,0))		Exits_10
,Sum	(Decode	(To_Char	(se.CreaDate, 'HH24'), '11', 1 ,0))		Exits_11
,Sum	(Decode	(To_Char	(se.CreaDate, 'HH24'), '12', 1 ,0))		Exits_12
,Sum	(Decode	(To_Char	(se.CreaDate, 'HH24'), '13', 1 ,0))		Exits_13
,Sum	(Decode	(To_Char	(se.CreaDate, 'HH24'), '14', 1 ,0))		Exits_14
,Sum	(Decode	(To_Char	(se.CreaDate, 'HH24'), '15', 1 ,0))		Exits_15
,Sum	(Decode	(To_Char	(se.CreaDate, 'HH24'), '16', 1 ,0))		Exits_16
,Sum	(Decode	(To_Char	(se.CreaDate, 'HH24'), '17', 1 ,0))		Exits_17
,Sum	(Decode	(To_Char	(se.CreaDate, 'HH24'), '18', 1 ,0))		Exits_18
,Sum	(Decode	(To_Char	(se.CreaDate, 'HH24'), '19', 1 ,0))		Exits_19
,Sum	(Decode	(To_Char	(se.CreaDate, 'HH24'), '20', 1 ,0))		Exits_20
,Sum	(Decode	(To_Char	(se.CreaDate, 'HH24'), '21', 1 ,0))		Exits_21
,Sum	(Decode	(To_Char	(se.CreaDate, 'HH24'), '22', 1 ,0))		Exits_22
,Sum	(Decode	(To_Char	(se.CreaDate, 'HH24'), '23', 1 ,0))		Exits_23
FROM
ShiftEvent		se
,TvmTable		tvm
,TvmStation	sta
,routes          rou
,(select trunc(service_date) service_date
            ,to_number(to_char(service_date,'ddd')) service_day
            ,to_number(to_char(service_date,'yyyy')) service_year
from MBTA_WEEKEND_SERVICE
where service_type = 1
and To_Char(service_Date,'HH24') = '06'
) hol
WHERE	1 = 1
AND	tvm.DeviceClassId		=	se.DeviceClassId
AND	tvm.TvmId		=	se.DeviceId
AND	sta.StationId		=	tvm.TvmTariffLocationId
AND  rou.RouteID		= tvm.Routeid
AND    hol.service_day (+) = decode(to_Char(se.Creadate,'HH24'),'00',decode(to_number(to_char(se.creadate,'ddd'))-1,0,to_number(to_char(trunc(se.creadate,'yyyy')-1,'ddd')) ,to_number(to_char(se.creadate,'ddd'))-1)
                                                     ,'01',decode(to_number(to_char(se.creadate,'ddd'))-1,0,to_number(to_char(trunc(se.creadate,'yyyy')-1,'ddd')) ,to_number(to_char(se.creadate,'ddd'))-1)
                                                     ,'02',decode(to_number(to_char(se.creadate,'ddd'))-1,0,to_number(to_char(trunc(se.creadate,'yyyy')-1,'ddd')) ,to_number(to_char(se.creadate,'ddd'))-1)
                                                            ,to_number(to_char(se.creadate,'ddd')))
AND    hol.service_year (+)  = decode(to_Char(se.Creadate,'HH24'),'00',decode(to_number(to_char(se.creadate,'ddd'))-1,0,to_number(to_char(se.creadate, 'yyyy'))-1 ,to_number(to_char(se.creadate, 'yyyy')))
                                                     ,'01',decode(to_number(to_char(se.creadate,'ddd'))-1,0,to_number(to_char(se.creadate, 'yyyy'))-1 ,to_number(to_char(se.creadate, 'yyyy')))
                                                     ,'02',decode(to_number(to_char(se.creadate,'ddd'))-1,0,to_number(to_char(se.creadate, 'yyyy'))-1,to_number(to_char(se.creadate, 'yyyy')))
                                                            ,to_number(to_char(se.creadate, 'yyyy')))
AND	se.EventCode		IN	(50193)
AND	rou.routeid in
  (
  1400,
  1200,
  1000,
  1300,
  1100
  )   -- Subway Stations Only
AND	se.CreaDate		>=	to_date('2011-01-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
AND	se.CreaDate		<=	to_date('2011-02-01-02-59-59','YYYY-MM-DD-HH24-MI-SS')
AND	se.PartitioningDate		>=	to_date('2011-01-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
--AND	P_Where
GROUP BY    
rou.routeid
,sta.NAME
,sta.stationid
,rou.description
,decode(to_Char(se.Creadate,'HH24'),'00',decode(to_char(se.creadate,'d')-1,0,7,to_char(se.creadate,'d')-1)
                                                        ,'01',decode(to_char(se.creadate,'d')-1,0,7,to_char(se.creadate,'d')-1)
                                                        ,'02',decode(to_char(se.creadate,'d')-1,0,7,to_char(se.creadate,'d')-1)
                                                              ,to_char(se.creadate,'d')
            )
,decode(to_Char(se.Creadate,'HH24'),'00',decode(to_char(se.creadate,'ddd')-1,0,to_char(trunc(se.creadate,'yyyy')-1,'ddd') ,to_char(se.creadate,'ddd')-1)
                                                        ,'01',decode(to_char(se.creadate,'ddd')-1,0,to_char(trunc(se.creadate,'yyyy')-1,'ddd') ,to_char(se.creadate,'ddd')-1)
                                                        ,'02',decode(to_char(se.creadate,'ddd')-1,0,to_char(trunc(se.creadate,'yyyy')-1,'ddd') ,to_char(se.creadate,'ddd')-1)
                                                              ,to_char(se.creadate,'ddd')
             )
,hol.service_day;
ALTER SESSION SET SQL_TRACE = FALSE;