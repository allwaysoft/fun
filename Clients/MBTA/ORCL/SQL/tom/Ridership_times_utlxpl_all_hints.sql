set pagesize 100
set linesize 150


delete from plan_table;
commit;

explain plan for SELECT
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
rou.routeid         line_id--Line Id
,sta.stationid        station_id--Station Id
,rou.Description    line_name              --Line
,sta.Name          station_name                              --    Station
,sum(decode(hol.service_date, null, Decode(To_Char(sd.Creadate,'HH24'), '00', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_00
,sum(decode(hol.service_date, null, Decode(To_Char(sd.Creadate,'HH24'), '01', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_01
,sum(decode(hol.service_date, null, Decode(To_Char(sd.Creadate,'HH24'), '02', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_02
,sum(decode(hol.service_date, null, Decode(To_Char(sd.Creadate,'HH24'), '03', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_03
,sum(decode(hol.service_date, null, Decode(To_Char(sd.Creadate,'HH24'), '04', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_04
,sum(decode(hol.service_date, null, Decode(To_Char(sd.Creadate,'HH24'), '05', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_05
,sum(decode(hol.service_date, null, Decode(To_Char(sd.Creadate,'HH24'), '06', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_06
,sum(decode(hol.service_date, null, Decode(To_Char(sd.Creadate,'HH24'), '07', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_07
,sum(decode(hol.service_date, null, Decode(To_Char(sd.Creadate,'HH24'), '08', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_08
,sum(decode(hol.service_date, null, Decode(To_Char(sd.Creadate,'HH24'), '09', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_09
,sum(decode(hol.service_date, null, Decode(To_Char(sd.Creadate,'HH24'), '10', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_10
,sum(decode(hol.service_date, null, Decode(To_Char(sd.Creadate,'HH24'), '11', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_11
,sum(decode(hol.service_date, null, Decode(To_Char(sd.Creadate,'HH24'), '12', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_12
,sum(decode(hol.service_date, null, Decode(To_Char(sd.Creadate,'HH24'), '13', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_13
,sum(decode(hol.service_date, null, Decode(To_Char(sd.Creadate,'HH24'), '14', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_14
,sum(decode(hol.service_date, null, Decode(To_Char(sd.Creadate,'HH24'), '15', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_15
,sum(decode(hol.service_date, null, Decode(To_Char(sd.Creadate,'HH24'), '16', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_16
,sum(decode(hol.service_date, null, Decode(To_Char(sd.Creadate,'HH24'), '17', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_17
,sum(decode(hol.service_date, null, Decode(To_Char(sd.Creadate,'HH24'), '18', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_18
,sum(decode(hol.service_date, null, Decode(To_Char(sd.Creadate,'HH24'), '19', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_19
,sum(decode(hol.service_date, null, Decode(To_Char(sd.Creadate,'HH24'), '20', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_20
,sum(decode(hol.service_date, null, Decode(To_Char(sd.Creadate,'HH24'), '21', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_21
,sum(decode(hol.service_date, null, Decode(To_Char(sd.Creadate,'HH24'), '22', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_22
,sum(decode(hol.service_date, null, Decode(To_Char(sd.Creadate,'HH24'), '23', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_23
,sum(decode(hol.service_date, null, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 )) wd_tot
-----------
,sum(decode(hol.service_type, 2, Decode(To_Char(sd.Creadate,'HH24'), '00', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_00
,sum(decode(hol.service_type, 2, Decode(To_Char(sd.Creadate,'HH24'), '01', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_01
,sum(decode(hol.service_type, 2, Decode(To_Char(sd.Creadate,'HH24'), '02', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_02
,sum(decode(hol.service_type, 2, Decode(To_Char(sd.Creadate,'HH24'), '03', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_03
,sum(decode(hol.service_type, 2, Decode(To_Char(sd.Creadate,'HH24'), '04', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_04
,sum(decode(hol.service_type, 2, Decode(To_Char(sd.Creadate,'HH24'), '05', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_05
,sum(decode(hol.service_type, 2, Decode(To_Char(sd.Creadate,'HH24'), '06', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_06
,sum(decode(hol.service_type, 2, Decode(To_Char(sd.Creadate,'HH24'), '07', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_07
,sum(decode(hol.service_type, 2, Decode(To_Char(sd.Creadate,'HH24'), '08', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_08
,sum(decode(hol.service_type, 2, Decode(To_Char(sd.Creadate,'HH24'), '09', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_09
,sum(decode(hol.service_type, 2, Decode(To_Char(sd.Creadate,'HH24'), '10', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_10
,sum(decode(hol.service_type, 2, Decode(To_Char(sd.Creadate,'HH24'), '11', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_11
,sum(decode(hol.service_type, 2, Decode(To_Char(sd.Creadate,'HH24'), '12', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_12
,sum(decode(hol.service_type, 2, Decode(To_Char(sd.Creadate,'HH24'), '13', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_13
,sum(decode(hol.service_type, 2, Decode(To_Char(sd.Creadate,'HH24'), '14', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_14
,sum(decode(hol.service_type, 2, Decode(To_Char(sd.Creadate,'HH24'), '15', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_15
,sum(decode(hol.service_type, 2, Decode(To_Char(sd.Creadate,'HH24'), '16', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_16
,sum(decode(hol.service_type, 2, Decode(To_Char(sd.Creadate,'HH24'), '17', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_17
,sum(decode(hol.service_type, 2, Decode(To_Char(sd.Creadate,'HH24'), '18', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_18
,sum(decode(hol.service_type, 2, Decode(To_Char(sd.Creadate,'HH24'), '19', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_19
,sum(decode(hol.service_type, 2, Decode(To_Char(sd.Creadate,'HH24'), '20', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_20
,sum(decode(hol.service_type, 2, Decode(To_Char(sd.Creadate,'HH24'), '21', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_21
,sum(decode(hol.service_type, 2, Decode(To_Char(sd.Creadate,'HH24'), '22', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_22
,sum(decode(hol.service_type, 2, Decode(To_Char(sd.Creadate,'HH24'), '23', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_23
,sum(decode(hol.service_type, 2, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 )) wesat_tot
----------
,sum(decode(hol.service_type, 3, Decode(To_Char(sd.Creadate,'HH24'), '00', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_00
,sum(decode(hol.service_type, 3, Decode(To_Char(sd.Creadate,'HH24'), '01', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_01
,sum(decode(hol.service_type, 3, Decode(To_Char(sd.Creadate,'HH24'), '02', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_02
,sum(decode(hol.service_type, 3, Decode(To_Char(sd.Creadate,'HH24'), '03', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_03
,sum(decode(hol.service_type, 3, Decode(To_Char(sd.Creadate,'HH24'), '04', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_04
,sum(decode(hol.service_type, 3, Decode(To_Char(sd.Creadate,'HH24'), '05', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_05
,sum(decode(hol.service_type, 3, Decode(To_Char(sd.Creadate,'HH24'), '06', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_06
,sum(decode(hol.service_type, 3, Decode(To_Char(sd.Creadate,'HH24'), '07', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_07
,sum(decode(hol.service_type, 3, Decode(To_Char(sd.Creadate,'HH24'), '08', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_08
,sum(decode(hol.service_type, 3, Decode(To_Char(sd.Creadate,'HH24'), '09', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_09
,sum(decode(hol.service_type, 3, Decode(To_Char(sd.Creadate,'HH24'), '10', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_10
,sum(decode(hol.service_type, 3, Decode(To_Char(sd.Creadate,'HH24'), '11', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_11
,sum(decode(hol.service_type, 3, Decode(To_Char(sd.Creadate,'HH24'), '12', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_12
,sum(decode(hol.service_type, 3, Decode(To_Char(sd.Creadate,'HH24'), '13', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_13
,sum(decode(hol.service_type, 3, Decode(To_Char(sd.Creadate,'HH24'), '14', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_14
,sum(decode(hol.service_type, 3, Decode(To_Char(sd.Creadate,'HH24'), '15', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_15
,sum(decode(hol.service_type, 3, Decode(To_Char(sd.Creadate,'HH24'), '16', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_16
,sum(decode(hol.service_type, 3, Decode(To_Char(sd.Creadate,'HH24'), '17', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_17
,sum(decode(hol.service_type, 3, Decode(To_Char(sd.Creadate,'HH24'), '18', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_18
,sum(decode(hol.service_type, 3, Decode(To_Char(sd.Creadate,'HH24'), '19', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_19
,sum(decode(hol.service_type, 3, Decode(To_Char(sd.Creadate,'HH24'), '20', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_20
,sum(decode(hol.service_type, 3, Decode(To_Char(sd.Creadate,'HH24'), '21', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_21
,sum(decode(hol.service_type, 3, Decode(To_Char(sd.Creadate,'HH24'), '22', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_22
,sum(decode(hol.service_type, 3, Decode(To_Char(sd.Creadate,'HH24'), '23', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_23
,sum(decode(hol.service_type, 3, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 )) wesun_tot
-----------
,sum(decode(hol.service_type, 1,  Decode(To_Char(sd.Creadate,'HH24'), '00', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0))   hd_00
,sum(decode(hol.service_type, 1,  Decode(To_Char(sd.Creadate,'HH24'), '01', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0))    hd_01
,sum(decode(hol.service_type, 1,  Decode(To_Char(sd.Creadate,'HH24'), '02', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0))    hd_02
,sum(decode(hol.service_type, 1,  Decode(To_Char(sd.Creadate,'HH24'), '03', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0))   hd_03
,sum(decode(hol.service_type, 1,  Decode(To_Char(sd.Creadate,'HH24'), '04', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0))  hd_04
,sum(decode(hol.service_type, 1,  Decode(To_Char(sd.Creadate,'HH24'), '05', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0))    hd_05
,sum(decode(hol.service_type, 1,  Decode(To_Char(sd.Creadate,'HH24'), '06', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0))    hd_06
,sum(decode(hol.service_type, 1,  Decode(To_Char(sd.Creadate,'HH24'), '07', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0))    hd_07
,sum(decode(hol.service_type, 1,  Decode(To_Char(sd.Creadate,'HH24'), '08', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0))    hd_08
,sum(decode(hol.service_type, 1,  Decode(To_Char(sd.Creadate,'HH24'), '09', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0))    hd_09
,sum(decode(hol.service_type, 1,  Decode(To_Char(sd.Creadate,'HH24'), '10', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0))    hd_10
,sum(decode(hol.service_type, 1,  Decode(To_Char(sd.Creadate,'HH24'), '11', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0))    hd_11
,sum(decode(hol.service_type, 1,  Decode(To_Char(sd.Creadate,'HH24'), '12', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0))    hd_12
,sum(decode(hol.service_type, 1,  Decode(To_Char(sd.Creadate,'HH24'), '13', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0))    hd_13
,sum(decode(hol.service_type, 1,  Decode(To_Char(sd.Creadate,'HH24'), '14', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0))    hd_14
,sum(decode(hol.service_type, 1,  Decode(To_Char(sd.Creadate,'HH24'), '15', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0))    hd_15
,sum(decode(hol.service_type, 1,  Decode(To_Char(sd.Creadate,'HH24'), '16', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0))    hd_16
,sum(decode(hol.service_type, 1,  Decode(To_Char(sd.Creadate,'HH24'), '17', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0))    hd_17
,sum(decode(hol.service_type, 1,  Decode(To_Char(sd.Creadate,'HH24'), '18', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0))    hd_18
,sum(decode(hol.service_type, 1,  Decode(To_Char(sd.Creadate,'HH24'), '19', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0))    hd_19
,sum(decode(hol.service_type, 1,  Decode(To_Char(sd.Creadate,'HH24'), '20', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0))    hd_20
,sum(decode(hol.service_type, 1,  Decode(To_Char(sd.Creadate,'HH24'), '21', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0))    hd_21
,sum(decode(hol.service_type, 1,  Decode(To_Char(sd.Creadate,'HH24'), '22', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0))    hd_22
,sum(decode(hol.service_type, 1,  Decode(To_Char(sd.Creadate,'HH24'), '23', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0))    hd_23
,sum(decode(hol.service_type, 1,  Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))  hd_tot
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
AND    rou.routeid in 
(
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
AND    sd.CreaDate            >= to_date('2010-01-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
AND    sd.CreaDate            <= to_date('2010-07-01-02-59-59','YYYY-MM-DD-HH24-MI-SS')
AND    sd.PartitioningDate    >= to_date('2010-01-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
AND    sd.PartitioningDate    <  to_date('2010-08-01-00-00-00','YYYY-MM-DD-HH24-MI-SS')
AND  hol.service_date(+) >= to_date('2010-01-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')     --with out the below date condition it took 10 hrs for 1 month.
AND  hol.service_date(+) <= to_date('2010-07-01-02-59-59','YYYY-MM-DD-HH24-MI-SS')
GROUP BY rou.routeid, sta.stationid, rou.Description, sta.Name;