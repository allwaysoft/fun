insert into temp_ridership_year 
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
,sum(decode(hol.service_type, 1,  Decode(To_Char(sd.Creadate,'HH24'), '00', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0))    hd_00
,sum(decode(hol.service_type, 1,  Decode(To_Char(sd.Creadate,'HH24'), '01', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0))    hd_01
,sum(decode(hol.service_type, 1,  Decode(To_Char(sd.Creadate,'HH24'), '02', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0))    hd_02
,sum(decode(hol.service_type, 1,  Decode(To_Char(sd.Creadate,'HH24'), '03', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0))    hd_03
,sum(decode(hol.service_type, 1,  Decode(To_Char(sd.Creadate,'HH24'), '04', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0))    hd_04
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

,sum(Decode(To_Char(sd.Creadate,'HH24'), '00', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0))    td_00
,sum(Decode(To_Char(sd.Creadate,'HH24'), '01', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0))    td_01
,sum(Decode(To_Char(sd.Creadate,'HH24'), '02', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0))    td_02
,sum(Decode(To_Char(sd.Creadate,'HH24'), '03', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0))    td_03
,sum(Decode(To_Char(sd.Creadate,'HH24'), '04', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0))    td_04
,sum(Decode(To_Char(sd.Creadate,'HH24'), '05', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0))    td_05
,sum(Decode(To_Char(sd.Creadate,'HH24'), '06', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0))    td_06
,sum(Decode(To_Char(sd.Creadate,'HH24'), '07', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0))    td_07
,sum(Decode(To_Char(sd.Creadate,'HH24'), '08', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0))    td_08
,sum(Decode(To_Char(sd.Creadate,'HH24'), '09', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0))    td_09
,sum(Decode(To_Char(sd.Creadate,'HH24'), '10', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0))    td_10
,sum(Decode(To_Char(sd.Creadate,'HH24'), '11', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0))    td_11
,sum(Decode(To_Char(sd.Creadate,'HH24'), '12', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0))    td_12
,sum(Decode(To_Char(sd.Creadate,'HH24'), '13', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0))    td_13
,sum(Decode(To_Char(sd.Creadate,'HH24'), '14', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0))    td_14
,sum(Decode(To_Char(sd.Creadate,'HH24'), '15', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0))    td_15
,sum(Decode(To_Char(sd.Creadate,'HH24'), '16', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0))    td_16
,sum(Decode(To_Char(sd.Creadate,'HH24'), '17', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0))    td_17
,sum(Decode(To_Char(sd.Creadate,'HH24'), '18', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0))    td_18
,sum(Decode(To_Char(sd.Creadate,'HH24'), '19', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0))    td_19
,sum(Decode(To_Char(sd.Creadate,'HH24'), '20', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0))    td_20
,sum(Decode(To_Char(sd.Creadate,'HH24'), '21', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0))    td_21
,sum(Decode(To_Char(sd.Creadate,'HH24'), '22', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0))    td_22
,sum(Decode(To_Char(sd.Creadate,'HH24'), '23', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0))    td_23
,sum(Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1)) td_tot

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
AND    1=1    
AND mcm.PartitioningDate >= to_date('2010-01-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
AND mcm.PartitioningDate < to_date('2010-08-01-00-00-00','YYYY-MM-DD-HH24-MI-SS')    
AND  st.PartitioningDate >= to_date('2010-01-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
AND  st.PartitioningDate < to_date('2010-08-01-00-00-0','YYYY-MM-DD-HH24-MI-SS')    
AND ms.EndCreaDate >= to_date('2010-01-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
AND ms.EndCreaDate <= to_date('2010-08-01-00-00-00','YYYY-MM-DD-HH24-MI-SS')    
AND  hol.service_date(+) >= to_date('2010-01-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')     --This and below line are very important otherwise it is taking 10 hrs for 1 month.
AND  hol.service_date(+) <= to_date('2010-07-01-02-59-59','YYYY-MM-DD-HH24-MI-SS')
GROUP BY rou.routeid, sta.stationid, rou.Description, sta.Name;










select  Lineid, station_id, linename , STATION_NAME
/*
, sum(WD_00), sum(WD_01 ), sum(WD_02), sum(WD_03), sum(WD_04), sum(WD_05), sum(WD_06), sum(WD_07), sum(WD_08)
, sum(WD_09), sum(WD_10), sum(WD_11), sum(WD_12), sum(WD_13), sum(WD_14), sum(WD_15), sum(WD_16), sum(WD_17), sum(WD_18), sum(WD_19), sum(WD_20), sum(WD_21)
, sum(WD_22), sum(WD_23), sum(WD_TOT), round(sum(WD_TOT)/252) wd_avg

, sum(WEsat_00), sum(WEsat_01), sum(WEsat_02), sum(WEsat_03), sum(WEsat_04), sum(WEsat_05), sum(WEsat_06), sum(WEsat_07)
, sum(WEsat_08), sum(WEsat_09), sum(WEsat_10), sum(WEsat_11), sum(WEsat_12), sum(WEsat_13), sum(WEsat_14), sum(WEsat_15), sum(WEsat_16), sum(WEsat_17), sum(WEsat_18), sum(WEsat_19), sum(WEsat_20)
, sum(WEsat_21), sum(WEsat_22), sum(WEsat_23), sum(WEsat_TOT), round(sum(WEsat_TOT)/51) wesat_avg

, sum(WEsun_00), sum(WEsun_01), sum(WEsun_02), sum(WEsun_03), sum(WEsun_04), sum(WEsun_05), sum(WEsun_06), sum(WEsun_07)
, sum(WEsun_08), sum(WEsun_09), sum(WEsun_10), sum(WEsun_11), sum(WEsun_12), sum(WEsun_13), sum(WEsun_14), sum(WEsun_15), sum(WEsun_16), sum(WEsun_17), sum(WEsun_18), sum(WEsun_19), sum(WEsun_20)
, sum(WEsun_21), sum(WEsun_22), sum(WEsun_23), sum(WEsun_TOT), round(sum(WEsun_TOT)/52) wesun_avg

, sum(HD_00), sum(HD_01), sum(HD_02), sum(HD_03), sum(HD_04), sum(HD_05), sum(HD_06)
, sum(HD_07), sum(HD_08), sum(HD_09), sum(HD_10), sum(HD_11), sum(HD_12), sum(HD_13), sum(HD_14), sum(HD_15), sum(HD_16), sum(HD_17), sum(HD_18), sum(HD_19)
, sum(HD_20), sum(HD_21), sum(HD_22), sum(HD_23), sum(HD_TOT), sum(hd_tot/10) hd_avg
*/
, sum(WD_00 ) WD_00, sum(WD_01 ) WD_01, sum(WD_02) WD_02, sum(WD_03) WD_03
, sum(WD_04) WD_04, sum(WD_05) WD_05, sum(WD_06) WD_06, sum(WD_07) WD_07, sum(WD_08) WD_08
, sum(WD_09) WD_09, sum(WD_10) WD_10, sum(WD_11) WD_11, sum(WD_12) WD_12, sum(WD_13) WD_13, sum(WD_14) WD_14, sum(WD_15) WD_15, sum(WD_16) WD_16
, sum(WD_17) WD_17, sum(WD_18) WD_18, sum(WD_19) WD_19, sum(WD_20) WD_20, sum(WD_21) WD_21
, sum(WD_22) WD_22, sum(WD_23) WD_23, sum(WD_TOT) WD_TOT, round(sum(WD_TOT)/252) wd_avg

, sum(WEsat_00) WEsat_00, sum(WEsat_01) WEsat_01, sum(WEsat_02) WEsat_02, sum(WEsat_03) WEsat_03, sum(WEsat_04) WEsat_04, sum(WEsat_05) WEsat_05, sum(WEsat_06) WEsat_06
,  sum(WEsat_07) WEsat_07
, sum(WEsat_08) WEsat_08, sum(WEsat_09) WEsat_09, sum(WEsat_10) WEsat_10, sum(WEsat_11) WEsat_11, sum(WEsat_12) WEsat_12
, sum(WEsat_13) WEsat_13, sum(WEsat_14) WEsat_14, sum(WEsat_15) WEsat_15, sum(WEsat_16) WEsat_16, sum(WEsat_17) WEsat_17, sum(WEsat_18) WEsat_18, sum(WEsat_19) WEsat_19, sum(WEsat_20) WEsat_20
, sum(WEsat_21) WEsat_21, sum(WEsat_22) WEsat_22, sum(WEsat_23) WEsat_23, sum(WEsat_TOT) WEsat_TOT, round(sum(WEsat_TOT)/51) wesat_avg

, sum(WEsun_00) WEsun_00, sum(WEsun_01) WEsun_01, sum(WEsun_02) WEsun_02, sum(WEsun_03) WEsun_03, sum(WEsun_04) WEsun_04, sum(WEsun_05) WEsun_05, sum(WEsun_06) WEsun_06, sum(WEsun_07) WEsun_07
, sum(WEsun_08) WEsun_08, sum(WEsun_09) WEsun_09, sum(WEsun_10) WEsun_10, sum(WEsun_11) WEsun_11, sum(WEsun_12) WEsun_12, sum(WEsun_13) WEsun_13
, sum(WEsun_14) WEsun_14, sum(WEsun_15) WEsun_15, sum(WEsun_16) WEsun_16, sum(WEsun_17) WEsun_17, sum(WEsun_18) WEsun_18, sum(WEsun_19) WEsun_19, sum(WEsun_20) WEsun_20
, sum(WEsun_21) WEsun_21, sum(WEsun_22) WEsun_22, sum(WEsun_23) WEsun_23, sum(WEsun_TOT) WEsun_TOT, round(sum(WEsun_TOT)/52) wesun_avg 

, sum(HD_00) HD_00, sum(HD_01) HD_01, sum(HD_02) HD_02, sum(HD_03) HD_03, sum(HD_04) HD_04, sum(HD_05) HD_05, sum(HD_06) HD_06
, sum(HD_07) HD_07, sum(HD_08) HD_08, sum(HD_09) HD_09, sum(HD_10) HD_10, sum(HD_11) HD_11, sum(HD_12) HD_12, sum(HD_13) HD_13
, sum(HD_14) HD_14, sum(HD_15) HD_15, sum(HD_16) HD_16, sum(HD_17) HD_17, sum(HD_18) HD_18, sum(HD_19) HD_19
, sum(HD_20) HD_20, sum(HD_21) HD_21, sum(HD_22) HD_22, sum(HD_23) HD_23, sum(HD_TOT) HD_TOT, round(sum(hd_tot/10)) hd_avg

,sum(  WD_00 +  WESAT_00 +  WESUN_00 +  HD_00 ) TR_00
,sum(  WD_01 +  WESAT_01 +  WESUN_01 +  HD_01 ) TR_01
,sum(  WD_02 +  WESAT_02 +  WESUN_02 +  HD_02 ) TR_02
,sum(  WD_03 +  WESAT_03 +  WESUN_03 +  HD_03 ) TR_03
,sum(  WD_04 +  WESAT_04 +  WESUN_04 +  HD_04 ) TR_04
,sum(  WD_05 +  WESAT_05 +  WESUN_05 +  HD_05 ) TR_05
,sum(  WD_06 +  WESAT_06 +  WESUN_06 +  HD_06 ) TR_06
,sum(  WD_07 +  WESAT_07 +  WESUN_07 +  HD_07 ) TR_07
,sum(  WD_08 +  WESAT_08 +  WESUN_08 +  HD_08 ) TR_08
,sum(  WD_09 +  WESAT_09 +  WESUN_09 +  HD_09 ) TR_09
,sum(  WD_10 +  WESAT_10 +  WESUN_10 +  HD_10 ) TR_10
,sum(  WD_11 +  WESAT_11 +  WESUN_11 +  HD_11 ) TR_11
,sum(  WD_12 +  WESAT_12 +  WESUN_12 +  HD_12 ) TR_12
,sum(  WD_13 +  WESAT_13 +  WESUN_13 +  HD_13 ) TR_13
,sum(  WD_14 +  WESAT_14 +  WESUN_14 +  HD_14 ) TR_14
,sum(  WD_15 +  WESAT_15 +  WESUN_15 +  HD_15 ) TR_15
,sum(  WD_16 +  WESAT_16 +  WESUN_16 +  HD_16 ) TR_16
,sum(  WD_17 +  WESAT_17 +  WESUN_17 +  HD_17 ) TR_17
,sum(  WD_18 +  WESAT_18 +  WESUN_18 +  HD_18 ) TR_18
,sum(  WD_19 +  WESAT_19 +  WESUN_19 +  HD_19 ) TR_19
,sum(  WD_20 +  WESAT_20 +  WESUN_20 +  HD_20 ) TR_20
,sum(  WD_21 +  WESAT_21 +  WESUN_21 +  HD_21 ) TR_21
,sum(  WD_22 +  WESAT_22 +  WESUN_22 +  HD_22 ) TR_22
,sum(  WD_23 +  WESAT_23 +  WESUN_23 +  HD_23 ) TR_23
,sum(  WD_TOT +  WESAT_TOT +  WESUN_TOT +  HD_TOT) TR_TOT
,round(sum(  WD_TOT +  WESAT_TOT +  WESUN_TOT +  HD_TOT)/365) TR_AVG

from
(
SELECT	(case when STATION_ID in (15,1051,1052,1053,1054,1054,1055,1056,1057,1058,1059,1060,1061,1062,1091,1092,1093
                                                   ,1094,1095,1096,1097,1098,1099,1100,1101,1102,1105,1106,1107,1108,1109,1111,1114)
  then 1000           --Green Line                   
  when STATION_ID in (1002,1004,1005,1006,1007,1009,1020,1032,1033,1034,1035,1036,1037,1040,1041,1042,1043,1087,1103,1112,2106)
  then 1100           --Red Line
  when STATION_ID in(1010,1010,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019) 
  then 1200           --Blue Line
  when STATION_ID in (1039,1070,1071,1072,1073,1074,1075,1076,1077,1078,1079,1080,1080,1081,1082,1083,1084,1085,1086,1087)
  then 1300            --Orange Line
  when STATION_ID in (1115,1116)
  then 1400
  else Line_ID
  end)     LINEID
  , STATION_ID
  ,(case when STATION_ID in (15,1051,1052,1053,1054,1054,1055,1056,1057,1058,1059,1060,1061,1062,1091,1092,1093
                                          ,1094,1095,1096,1097,1098,1099,1100,1101,1102,1105,1106,1107,1108,1109,1111,1114)
  then (select description from routes where routeid = 1000 and rownum <=1)          --Green Line                   
  when STATION_ID in (1002,1004,1005,1006,1007,1009,1020,1032,1033,1034,1035,1036,1037,1040,1041,1042,1043,1103,1112,2106)
  then (select description from routes where routeid = 1100 and rownum <=1)           --Red Line
  when STATION_ID in(1010,1010,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019) 
  then (select description from routes where routeid = 1200 and rownum <=1)          --Blue Line
  when STATION_ID in (1039,1070,1071,1072,1073,1074,1075,1076,1077,1078,1079,1080,1080,1081,1082,1083,1084,1085,1086,1087)
  then (select description from routes where routeid = 1300 and rownum <=1)          --Orange Line
  when STATION_ID in (1115,1116)
  then (select description from routes where routeid = 1400 and rownum <=1)          --Silver Line
  else
 LINE_NAME
  end)          linename
  , STATION_NAME 
  
, sum(WD_00 ) WD_00, sum(WD_01 ) WD_01, sum(WD_02) WD_02, sum(WD_03) WD_03
, sum(WD_04) WD_04, sum(WD_05) WD_05, sum(WD_06) WD_06, sum(WD_07) WD_07, sum(WD_08) WD_08
, sum(WD_09) WD_09, sum(WD_10) WD_10, sum(WD_11) WD_11, sum(WD_12) WD_12, sum(WD_13) WD_13, sum(WD_14) WD_14, sum(WD_15) WD_15, sum(WD_16) WD_16
, sum(WD_17) WD_17, sum(WD_18) WD_18, sum(WD_19) WD_19, sum(WD_20) WD_20, sum(WD_21) WD_21
, sum(WD_22) WD_22, sum(WD_23) WD_23, sum(WD_TOT) WD_TOT

, sum(WEsat_00) WEsat_00, sum(WEsat_01) WEsat_01, sum(WEsat_02) WEsat_02, sum(WEsat_03) WEsat_03, sum(WEsat_04) WEsat_04, sum(WEsat_05) WEsat_05, sum(WEsat_06) WEsat_06
,  sum(WEsat_07) WEsat_07
, sum(WEsat_08) WEsat_08, sum(WEsat_09) WEsat_09, sum(WEsat_10) WEsat_10, sum(WEsat_11) WEsat_11, sum(WEsat_12) WEsat_12
, sum(WEsat_13) WEsat_13, sum(WEsat_14) WEsat_14, sum(WEsat_15) WEsat_15, sum(WEsat_16) WEsat_16, sum(WEsat_17) WEsat_17, sum(WEsat_18) WEsat_18, sum(WEsat_19) WEsat_19, sum(WEsat_20) WEsat_20
, sum(WEsat_21) WEsat_21, sum(WEsat_22) WEsat_22, sum(WEsat_23) WEsat_23, sum(WEsat_TOT) WEsat_TOT

, sum(WEsun_00) WEsun_00, sum(WEsun_01) WEsun_01, sum(WEsun_02) WEsun_02, sum(WEsun_03) WEsun_03, sum(WEsun_04) WEsun_04, sum(WEsun_05) WEsun_05, sum(WEsun_06) WEsun_06, sum(WEsun_07) WEsun_07
, sum(WEsun_08) WEsun_08, sum(WEsun_09) WEsun_09, sum(WEsun_10) WEsun_10, sum(WEsun_11) WEsun_11, sum(WEsun_12) WEsun_12, sum(WEsun_13) WEsun_13
, sum(WEsun_14) WEsun_14, sum(WEsun_15) WEsun_15, sum(WEsun_16) WEsun_16, sum(WEsun_17) WEsun_17, sum(WEsun_18) WEsun_18, sum(WEsun_19) WEsun_19, sum(WEsun_20) WEsun_20
, sum(WEsun_21) WEsun_21, sum(WEsun_22) WEsun_22, sum(WEsun_23) WEsun_23, sum(WEsun_TOT) WEsun_TOT 

, sum(HD_00) HD_00, sum(HD_01) HD_01, sum(HD_02) HD_02, sum(HD_03) HD_03, sum(HD_04) HD_04, sum(HD_05) HD_05, sum(HD_06) HD_06
, sum(HD_07) HD_07, sum(HD_08) HD_08, sum(HD_09) HD_09, sum(HD_10) HD_10, sum(HD_11) HD_11, sum(HD_12) HD_12, sum(HD_13) HD_13
, sum(HD_14) HD_14, sum(HD_15) HD_15, sum(HD_16) HD_16, sum(HD_17) HD_17, sum(HD_18) HD_18, sum(HD_19) HD_19
, sum(HD_20) HD_20, sum(HD_21) HD_21, sum(HD_22) HD_22, sum(HD_23) HD_23, sum(HD_TOT) HD_TOT
 FROM temp_ridership_year
 where   decode(line_id, 1000, decode(station_id, 1051, -99, 1052, -99, 1053, -99, 1054, -99, 1055, -99, 1056, -99, 1057, -99, 1058, -99, 1059, -99, 1060, -99, 1061, -99, 1101, -99, station_id), station_id)  = decode(line_id, 1000,  -99, station_id) -- Only particular stations for green line and all Stations of other LinesGROUP BY Line_id, STATION_ID, LINE_NAME, STATION_NAME
 group by	(case when STATION_ID in (15,1051,1052,1053,1054,1054,1055,1056,1057,1058,1059,1060,1061,1062,1091,1092,1093
                                                     ,1094,1095,1096,1097,1098,1099,1100,1101,1102,1105,1106,1107,1108,1109,1111,1114)
  then 1000           --Green Line                   
  when STATION_ID in (1002,1004,1005,1006,1007,1009,1020,1032,1033,1034,1035,1036,1037,1040,1041,1042,1043,1087,1103,1112,2106)
  then 1100           --Red Line
  when STATION_ID in(1010,1010,1010,1011,1012,1013,1014,1015,1016,1017,1018,1019) 
  then 1200           --Blue Line
  when STATION_ID in (1039,1070,1071,1072,1073,1074,1075,1076,1077,1078,1079,1080,1080,1081,1082,1083,1084,1085,1086,1087)
  then 1300            --Orange Line
  when STATION_ID in (1115,1116)
  then 1400
  else Line_ID
  end)   
  , STATION_ID
  ,line_name      
  , STATION_NAME
 ORDER BY line_name, station_id, station_name
)
group by Lineid, station_id, linename , STATION_NAME
order by linename, station_name






select * from temp_ridership_year








SELECT 
(
SELECT CEIL(TO_DATE ('2010-09-01-02-59-59', 'YYYY-MM-DD-HH24-MI-SS') -TO_DATE ('2010-08-01-03-00-00', 'YYYY-MM-DD-HH24-MI-SS') )
FROM DUAL
) - 
(
SELECT COUNT(DISTINCT TRUNC(HOLIDAY_DATE)) 
FROM MBTA_HOLIDAY
WHERE 1=1

            AND holiday_date(+) >=
                   TO_DATE ('2010-08-01-03-00-00', 'YYYY-MM-DD-HH24-MI-SS') --This and below line are very important otherwise it is taking 10 hrs for 1 month.
            AND holiday_date(+) <=
                   TO_DATE ('2010-09-01-02-59-59', 'YYYY-MM-DD-HH24-MI-SS')
--AND HOLIDAY_DATE(+) >= dDateFirst
--AND HOLIDAY_DATE(+) <= dDateLast
AND TO_CHAR(HOLIDAY_DATE,'hh24') NOT IN ('00','01','02')
)                                                                                 --Count of weekdays of given date range
FROM DUAL;
 
                 
SELECT COUNT(DISTINCT TRUNC(HOLIDAY_DATE))-- INTO V_SATURDAYS          -- Count of Saturdays
FROM MBTA_HOLIDAY
WHERE 1=1
            AND holiday_date(+) >=
                   TO_DATE ('2010-08-01-03-00-00', 'YYYY-MM-DD-HH24-MI-SS') --This and below line are very important otherwise it is taking 10 hrs for 1 month.
            AND holiday_date(+) <=
                   TO_DATE ('2010-09-01-02-59-59', 'YYYY-MM-DD-HH24-MI-SS')
AND HOLIDAY_DESCRIPTION IN ('Saturday')
AND TO_CHAR(HOLIDAY_DATE,'hh24') NOT IN ('00','01','02');                 


SELECT COUNT(DISTINCT TRUNC(HOLIDAY_DATE)) -- INTO V_SUNDAYS             -- Count of Sundays
FROM MBTA_HOLIDAY
WHERE 1=1
            AND holiday_date(+) >=
                   TO_DATE ('2010-08-01-03-00-00', 'YYYY-MM-DD-HH24-MI-SS') --This and below line are very important otherwise it is taking 10 hrs for 1 month.
            AND holiday_date(+) <=
                   TO_DATE ('2010-09-01-02-59-59', 'YYYY-MM-DD-HH24-MI-SS')
AND HOLIDAY_DESCRIPTION IN ('Sunday')
AND TO_CHAR(HOLIDAY_DATE,'hh24') NOT IN ('00','01','02');


SELECT COUNT(DISTINCT TRUNC(HOLIDAY_DATE)) --INTO V_HOLIDAYS            --Count of Holidays
FROM MBTA_HOLIDAY
WHERE 1=1
            AND holiday_date(+) >=
                   TO_DATE ('2010-08-01-03-00-00', 'YYYY-MM-DD-HH24-MI-SS') --This and below line are very important otherwise it is taking 10 hrs for 1 month.
            AND holiday_date(+) <=
                   TO_DATE ('2010-09-01-02-59-59', 'YYYY-MM-DD-HH24-MI-SS')
AND HOLIDAY_DESCRIPTION NOT IN ('Saturday','Sunday')
AND TO_CHAR(HOLIDAY_DATE,'hh24') NOT IN ('00','01','02');    





SELECT LINE_ID,
  STATION_ID,
  LINE_NAME,
  STATION_NAME,
  WD_00,
  WD_01,
  WD_02,
  WD_03,
  WD_04,
  WD_05,
  WD_06,
  WD_07,
  WD_08,
  WD_09,
  WD_10,
  WD_11,
  WD_12,
  WD_13,
  WD_14,
  WD_15,
  WD_16,
  WD_17,
  WD_18,
  WD_19,
  WD_20,
  WD_21,
  WD_22,
  WD_23,
  WD_TOT,
  WESAT_00,
  WESAT_01,
  WESAT_02,
  WESAT_03,
  WESAT_04,
  WESAT_05,
  WESAT_06,
  WESAT_07,
  WESAT_08,
  WESAT_09,
  WESAT_10,
  WESAT_11,
  WESAT_12,
  WESAT_13,
  WESAT_14,
  WESAT_15,
  WESAT_16,
  WESAT_17,
  WESAT_18,
  WESAT_19,
  WESAT_20,
  WESAT_21,
  WESAT_22,
  WESAT_23,
  WESAT_TOT,
  WESUN_00,
  WESUN_01,
  WESUN_02,
  WESUN_03,
  WESUN_04,
  WESUN_05,
  WESUN_06,
  WESUN_07,
  WESUN_08,
  WESUN_09,
  WESUN_10,
  WESUN_11,
  WESUN_12,
  WESUN_13,
  WESUN_14,
  WESUN_15,
  WESUN_16,
  WESUN_17,
  WESUN_18,
  WESUN_19,
  WESUN_20,
  WESUN_21,
  WESUN_22,
  WESUN_23,
  WESUN_TOT,
  HD_00,
  HD_01,
  HD_02,
  HD_03,
  HD_04,
  HD_05,
  HD_06,
  HD_07,
  HD_08,
  HD_09,
  HD_10,
  HD_11,
  HD_12,
  HD_13,
  HD_14,
  HD_15,
  HD_16,
  HD_17,
  HD_18,
  HD_19,
  HD_20,
  HD_21,
  HD_22,
  HD_23,
  HD_TOT
FROM TEMP_RIDERSHIP_YEAR ;
