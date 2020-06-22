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
,sum(decode(hol.holiday_date, null, Decode(To_Char(sd.Creadate,'HH24'), '00', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_00
,sum(decode(hol.holiday_date, null, Decode(To_Char(sd.Creadate,'HH24'), '01', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_01
,sum(decode(hol.holiday_date, null, Decode(To_Char(sd.Creadate,'HH24'), '02', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_02
,sum(decode(hol.holiday_date, null, Decode(To_Char(sd.Creadate,'HH24'), '03', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_03
,sum(decode(hol.holiday_date, null, Decode(To_Char(sd.Creadate,'HH24'), '04', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_04
,sum(decode(hol.holiday_date, null, Decode(To_Char(sd.Creadate,'HH24'), '05', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_05
,sum(decode(hol.holiday_date, null, Decode(To_Char(sd.Creadate,'HH24'), '06', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_06
,sum(decode(hol.holiday_date, null, Decode(To_Char(sd.Creadate,'HH24'), '07', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_07
,sum(decode(hol.holiday_date, null, Decode(To_Char(sd.Creadate,'HH24'), '08', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_08
,sum(decode(hol.holiday_date, null, Decode(To_Char(sd.Creadate,'HH24'), '09', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_09
,sum(decode(hol.holiday_date, null, Decode(To_Char(sd.Creadate,'HH24'), '10', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_10
,sum(decode(hol.holiday_date, null, Decode(To_Char(sd.Creadate,'HH24'), '11', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_11
,sum(decode(hol.holiday_date, null, Decode(To_Char(sd.Creadate,'HH24'), '12', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_12
,sum(decode(hol.holiday_date, null, Decode(To_Char(sd.Creadate,'HH24'), '13', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_13
,sum(decode(hol.holiday_date, null, Decode(To_Char(sd.Creadate,'HH24'), '14', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_14
,sum(decode(hol.holiday_date, null, Decode(To_Char(sd.Creadate,'HH24'), '15', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_15
,sum(decode(hol.holiday_date, null, Decode(To_Char(sd.Creadate,'HH24'), '16', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_16
,sum(decode(hol.holiday_date, null, Decode(To_Char(sd.Creadate,'HH24'), '17', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_17
,sum(decode(hol.holiday_date, null, Decode(To_Char(sd.Creadate,'HH24'), '18', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_18
,sum(decode(hol.holiday_date, null, Decode(To_Char(sd.Creadate,'HH24'), '19', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_19
,sum(decode(hol.holiday_date, null, Decode(To_Char(sd.Creadate,'HH24'), '20', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_20
,sum(decode(hol.holiday_date, null, Decode(To_Char(sd.Creadate,'HH24'), '21', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_21
,sum(decode(hol.holiday_date, null, Decode(To_Char(sd.Creadate,'HH24'), '22', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_22
,sum(decode(hol.holiday_date, null, Decode(To_Char(sd.Creadate,'HH24'), '23', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0),0))    wd_23
,sum(decode(hol.holiday_date, null, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 )) wd_tot
-----------
,sum(decode(hol.holiday_description, 'Saturday', Decode(To_Char(sd.Creadate,'HH24'), '00', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_00
,sum(decode(hol.holiday_description, 'Saturday', Decode(To_Char(sd.Creadate,'HH24'), '01', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_01
,sum(decode(hol.holiday_description, 'Saturday', Decode(To_Char(sd.Creadate,'HH24'), '02', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_02
,sum(decode(hol.holiday_description, 'Saturday', Decode(To_Char(sd.Creadate,'HH24'), '03', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_03
,sum(decode(hol.holiday_description, 'Saturday', Decode(To_Char(sd.Creadate,'HH24'), '04', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_04
,sum(decode(hol.holiday_description, 'Saturday', Decode(To_Char(sd.Creadate,'HH24'), '05', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_05
,sum(decode(hol.holiday_description, 'Saturday', Decode(To_Char(sd.Creadate,'HH24'), '06', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_06
,sum(decode(hol.holiday_description, 'Saturday', Decode(To_Char(sd.Creadate,'HH24'), '07', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_07
,sum(decode(hol.holiday_description, 'Saturday', Decode(To_Char(sd.Creadate,'HH24'), '08', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_08
,sum(decode(hol.holiday_description, 'Saturday', Decode(To_Char(sd.Creadate,'HH24'), '09', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_09
,sum(decode(hol.holiday_description, 'Saturday', Decode(To_Char(sd.Creadate,'HH24'), '10', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_10
,sum(decode(hol.holiday_description, 'Saturday', Decode(To_Char(sd.Creadate,'HH24'), '11', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_11
,sum(decode(hol.holiday_description, 'Saturday', Decode(To_Char(sd.Creadate,'HH24'), '12', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_12
,sum(decode(hol.holiday_description, 'Saturday', Decode(To_Char(sd.Creadate,'HH24'), '13', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_13
,sum(decode(hol.holiday_description, 'Saturday', Decode(To_Char(sd.Creadate,'HH24'), '14', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_14
,sum(decode(hol.holiday_description, 'Saturday', Decode(To_Char(sd.Creadate,'HH24'), '15', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_15
,sum(decode(hol.holiday_description, 'Saturday', Decode(To_Char(sd.Creadate,'HH24'), '16', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_16
,sum(decode(hol.holiday_description, 'Saturday', Decode(To_Char(sd.Creadate,'HH24'), '17', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_17
,sum(decode(hol.holiday_description, 'Saturday', Decode(To_Char(sd.Creadate,'HH24'), '18', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_18
,sum(decode(hol.holiday_description, 'Saturday', Decode(To_Char(sd.Creadate,'HH24'), '19', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_19
,sum(decode(hol.holiday_description, 'Saturday', Decode(To_Char(sd.Creadate,'HH24'), '20', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_20
,sum(decode(hol.holiday_description, 'Saturday', Decode(To_Char(sd.Creadate,'HH24'), '21', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_21
,sum(decode(hol.holiday_description, 'Saturday', Decode(To_Char(sd.Creadate,'HH24'), '22', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_22
,sum(decode(hol.holiday_description, 'Saturday', Decode(To_Char(sd.Creadate,'HH24'), '23', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesat_23
,sum(decode(hol.holiday_description, 'Saturday', Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 )) wesat_tot
----------
,sum(decode(hol.holiday_description, 'Sunday', Decode(To_Char(sd.Creadate,'HH24'), '00', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_00
,sum(decode(hol.holiday_description, 'Sunday', Decode(To_Char(sd.Creadate,'HH24'), '01', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_01
,sum(decode(hol.holiday_description, 'Sunday', Decode(To_Char(sd.Creadate,'HH24'), '02', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_02
,sum(decode(hol.holiday_description, 'Sunday', Decode(To_Char(sd.Creadate,'HH24'), '03', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_03
,sum(decode(hol.holiday_description, 'Sunday', Decode(To_Char(sd.Creadate,'HH24'), '04', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_04
,sum(decode(hol.holiday_description, 'Sunday', Decode(To_Char(sd.Creadate,'HH24'), '05', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_05
,sum(decode(hol.holiday_description, 'Sunday', Decode(To_Char(sd.Creadate,'HH24'), '06', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_06
,sum(decode(hol.holiday_description, 'Sunday', Decode(To_Char(sd.Creadate,'HH24'), '07', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_07
,sum(decode(hol.holiday_description, 'Sunday', Decode(To_Char(sd.Creadate,'HH24'), '08', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_08
,sum(decode(hol.holiday_description, 'Sunday', Decode(To_Char(sd.Creadate,'HH24'), '09', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_09
,sum(decode(hol.holiday_description, 'Sunday', Decode(To_Char(sd.Creadate,'HH24'), '10', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_10
,sum(decode(hol.holiday_description, 'Sunday', Decode(To_Char(sd.Creadate,'HH24'), '11', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_11
,sum(decode(hol.holiday_description, 'Sunday', Decode(To_Char(sd.Creadate,'HH24'), '12', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_12
,sum(decode(hol.holiday_description, 'Sunday', Decode(To_Char(sd.Creadate,'HH24'), '13', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_13
,sum(decode(hol.holiday_description, 'Sunday', Decode(To_Char(sd.Creadate,'HH24'), '14', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_14
,sum(decode(hol.holiday_description, 'Sunday', Decode(To_Char(sd.Creadate,'HH24'), '15', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_15
,sum(decode(hol.holiday_description, 'Sunday', Decode(To_Char(sd.Creadate,'HH24'), '16', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_16
,sum(decode(hol.holiday_description, 'Sunday', Decode(To_Char(sd.Creadate,'HH24'), '17', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_17
,sum(decode(hol.holiday_description, 'Sunday', Decode(To_Char(sd.Creadate,'HH24'), '18', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_18
,sum(decode(hol.holiday_description, 'Sunday', Decode(To_Char(sd.Creadate,'HH24'), '19', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_19
,sum(decode(hol.holiday_description, 'Sunday', Decode(To_Char(sd.Creadate,'HH24'), '20', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_20
,sum(decode(hol.holiday_description, 'Sunday', Decode(To_Char(sd.Creadate,'HH24'), '21', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_21
,sum(decode(hol.holiday_description, 'Sunday', Decode(To_Char(sd.Creadate,'HH24'), '22', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_22
,sum(decode(hol.holiday_description, 'Sunday', Decode(To_Char(sd.Creadate,'HH24'), '23', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0), 0)) wesun_23
,sum(decode(hol.holiday_description, 'Sunday', Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 )) wesun_tot
-----------
,sum(decode(hol.holiday_date, null, 0, Decode(hol.holiday_description, 'Sunday', 0, 'Saturday' , 0,  Decode(To_Char(sd.Creadate,'HH24'), '00', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))))    hd_00
,sum(decode(hol.holiday_date, null, 0, Decode(hol.holiday_description, 'Sunday', 0, 'Saturday' , 0,  Decode(To_Char(sd.Creadate,'HH24'), '01', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))))    hd_01
,sum(decode(hol.holiday_date, null, 0, Decode(hol.holiday_description, 'Sunday', 0, 'Saturday' , 0,  Decode(To_Char(sd.Creadate,'HH24'), '02', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))))    hd_02
,sum(decode(hol.holiday_date, null, 0, Decode(hol.holiday_description, 'Sunday', 0, 'Saturday' , 0,  Decode(To_Char(sd.Creadate,'HH24'), '03', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))))    hd_03
,sum(decode(hol.holiday_date, null, 0, Decode(hol.holiday_description, 'Sunday', 0, 'Saturday' , 0,  Decode(To_Char(sd.Creadate,'HH24'), '04', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))))    hd_04
,sum(decode(hol.holiday_date, null, 0, Decode(hol.holiday_description, 'Sunday', 0, 'Saturday' , 0,  Decode(To_Char(sd.Creadate,'HH24'), '05', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))))    hd_05
,sum(decode(hol.holiday_date, null, 0, Decode(hol.holiday_description, 'Sunday', 0, 'Saturday' , 0,  Decode(To_Char(sd.Creadate,'HH24'), '06', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))))    hd_06
,sum(decode(hol.holiday_date, null, 0, Decode(hol.holiday_description, 'Sunday', 0, 'Saturday' , 0,  Decode(To_Char(sd.Creadate,'HH24'), '07', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))))    hd_07
,sum(decode(hol.holiday_date, null, 0, Decode(hol.holiday_description, 'Sunday', 0, 'Saturday' , 0,  Decode(To_Char(sd.Creadate,'HH24'), '08', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))))    hd_08
,sum(decode(hol.holiday_date, null, 0, Decode(hol.holiday_description, 'Sunday', 0, 'Saturday' , 0,  Decode(To_Char(sd.Creadate,'HH24'), '09', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))))    hd_09
,sum(decode(hol.holiday_date, null, 0, Decode(hol.holiday_description, 'Sunday', 0, 'Saturday' , 0,  Decode(To_Char(sd.Creadate,'HH24'), '10', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))))    hd_10
,sum(decode(hol.holiday_date, null, 0, Decode(hol.holiday_description, 'Sunday', 0, 'Saturday' , 0,  Decode(To_Char(sd.Creadate,'HH24'), '11', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))))    hd_11
,sum(decode(hol.holiday_date, null, 0, Decode(hol.holiday_description, 'Sunday', 0, 'Saturday' , 0,  Decode(To_Char(sd.Creadate,'HH24'), '12', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))))    hd_12
,sum(decode(hol.holiday_date, null, 0, Decode(hol.holiday_description, 'Sunday', 0, 'Saturday' , 0,  Decode(To_Char(sd.Creadate,'HH24'), '13', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))))    hd_13
,sum(decode(hol.holiday_date, null, 0, Decode(hol.holiday_description, 'Sunday', 0, 'Saturday' , 0,  Decode(To_Char(sd.Creadate,'HH24'), '14', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))))    hd_14
,sum(decode(hol.holiday_date, null, 0, Decode(hol.holiday_description, 'Sunday', 0, 'Saturday' , 0,  Decode(To_Char(sd.Creadate,'HH24'), '15', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))))    hd_15
,sum(decode(hol.holiday_date, null, 0, Decode(hol.holiday_description, 'Sunday', 0, 'Saturday' , 0,  Decode(To_Char(sd.Creadate,'HH24'), '16', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))))    hd_16
,sum(decode(hol.holiday_date, null, 0, Decode(hol.holiday_description, 'Sunday', 0, 'Saturday' , 0,  Decode(To_Char(sd.Creadate,'HH24'), '17', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))))    hd_17
,sum(decode(hol.holiday_date, null, 0, Decode(hol.holiday_description, 'Sunday', 0, 'Saturday' , 0,  Decode(To_Char(sd.Creadate,'HH24'), '18', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))))    hd_18
,sum(decode(hol.holiday_date, null, 0, Decode(hol.holiday_description, 'Sunday', 0, 'Saturday' , 0,  Decode(To_Char(sd.Creadate,'HH24'), '19', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))))    hd_19
,sum(decode(hol.holiday_date, null, 0, Decode(hol.holiday_description, 'Sunday', 0, 'Saturday' , 0,  Decode(To_Char(sd.Creadate,'HH24'), '20', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))))    hd_20
,sum(decode(hol.holiday_date, null, 0, Decode(hol.holiday_description, 'Sunday', 0, 'Saturday' , 0,  Decode(To_Char(sd.Creadate,'HH24'), '21', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))))    hd_21
,sum(decode(hol.holiday_date, null, 0, Decode(hol.holiday_description, 'Sunday', 0, 'Saturday' , 0,  Decode(To_Char(sd.Creadate,'HH24'), '22', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))))    hd_22
,sum(decode(hol.holiday_date, null, 0, Decode(hol.holiday_description, 'Sunday', 0, 'Saturday' , 0,  Decode(To_Char(sd.Creadate,'HH24'), '23', decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1), 0))))    hd_23
,sum(decode(hol.holiday_date, null, 0, Decode(hol.holiday_description, 'Sunday', 0, 'Saturday' , 0,  Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1))))  hd_tot
FROM
SalesDetail               sd
,SalesDetail               sub
,MiscCardMovement   mcm
,SalesTransaction       st
,Mainshift                  ms
,Routes                    rou
,TVMTable                tvm
,tvmStation               sta
,mbta_holiday              hol
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
AND    trunc(hol.holiday_date (+)) = trunc(sd.creadate)
AND    trunc(hol.holiday_date(+), 'hh24')  = trunc(sd.creadate, 'hh24')
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
AND    sd.CreaDate            >= to_date('2009-07-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
AND    sd.CreaDate            <= to_date('2009-08-01-02-59-59','YYYY-MM-DD-HH24-MI-SS')
AND    sd.PartitioningDate    >= to_date('2009-07-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
AND    sd.PartitioningDate    <  to_date('2009-09-01-00-00-00','YYYY-MM-DD-HH24-MI-SS')
AND    1=1    
--AND mcm.PartitioningDate >= to_date('2009-07-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
--AND mcm.PartitioningDate < to_date('2009-09-01-00-00-00','YYYY-MM-DD-HH24-MI-SS')    
--AND  st.PartitioningDate >= to_date('2009-07-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
--AND  st.PartitioningDate < to_date('2009-09-01-00-00-00','YYYY-MM-DD-HH24-MI-SS')    
--AND ms.EndCreaDate >= to_date('2009-07-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
--AND ms.EndCreaDate <= to_date('2009-09-01-00-00-00','YYYY-MM-DD-HH24-MI-SS')    
AND  hol.holiday_date(+) >= to_date('2009-07-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')     --This and below line are very important otherwise it is taking 10 hrs for 1 month.
AND  hol.holiday_date(+) <= to_date('2009-08-01-02-59-59','YYYY-MM-DD-HH24-MI-SS')
GROUP BY rou.routeid, sta.stationid, rou.Description, sta.Name



select * from mbta_holiday

select trunc(sysdate,'hh24') from dual



SELECT LINE_ID, STATION_ID, LINE_NAME, STATION_NAME, sum(WD_00), sum(WD_01 ), sum(WD_02), sum(WD_03), sum(WD_04), sum(WD_05), sum(WD_06), sum(WD_07), sum(WD_08)
, sum(WD_09), sum(WD_10), sum(WD_11), sum(WD_12), sum(WD_13), sum(WD_14), sum(WD_15), sum(WD_16), sum(WD_17), sum(WD_18), sum(WD_19), sum(WD_20), sum(WD_21)
, sum(WD_22), sum(WD_23), sum(WD_TOT), round(sum(WD_TOT)/128) wd_avg

, sum(WEsat_00), sum(WEsat_01), sum(WEsat_02), sum(WEsat_03), sum(WEsat_04), sum(WEsat_05), sum(WEsat_06), sum(WEsat_07)
, sum(WEsat_08), sum(WEsat_09), sum(WEsat_10), sum(WEsat_11), sum(WEsat_12), sum(WEsat_13), sum(WEsat_14), sum(WEsat_15), sum(WEsat_16), sum(WEsat_17), sum(WEsat_18), sum(WEsat_19), sum(WEsat_20)
, sum(WEsat_21), sum(WEsat_22), sum(WEsat_23), sum(WEsat_TOT), round(sum(WEsat_TOT)/25) we_avg, 

sum(WEsun_00), sum(WEsun_01), sum(WEsun_02), sum(WEsun_03), sum(WEsun_04), sum(WEsun_05), sum(WEsun_06), sum(WEsun_07)
, sum(WEsun_08), sum(WEsun_09), sum(WEsun_10), sum(WEsun_11), sum(WEsun_12), sum(WEsun_13), sum(WEsun_14), sum(WEsun_15), sum(WEsun_16), sum(WEsun_17), sum(WEsun_18), sum(WEsun_19), sum(WEsun_20)
, sum(WEsun_21), sum(WEsun_22), sum(WEsun_23), sum(WEsun_TOT), round(sum(WEsun_TOT)/26) we_avg,

sum(HD_00), sum(HD_01), sum(HD_02), sum(HD_03), sum(HD_04), sum(HD_05), sum(HD_06)
, sum(HD_07), sum(HD_08), sum(HD_09), sum(HD_10), sum(HD_11), sum(HD_12), sum(HD_13), sum(HD_14), sum(HD_15), sum(HD_16), sum(HD_17), sum(HD_18), sum(HD_19)
, sum(HD_20), sum(HD_21), sum(HD_22), sum(HD_23), sum(HD_TOT), sum(hd_tot/5) hd_avg
FROM temp_ridership_year
where   decode(line_id, 1000, decode(station_id, 1051, -99, 1052, -99, 1053, -99, 1054, -99, 1055, -99, 1056, -99, 1057, -99, 1058, -99, 1059, -99, 1060, -99, 1061, -99, 1101, -99, station_id), station_id)  = decode(line_id, 1000,  -99, station_id) -- Only particular stations for green line and all Stations of other LinesGROUP BY Line_id, STATION_ID, LINE_NAME, STATION_NAME
group by LINE_ID, STATION_ID, LINE_NAME, STATION_NAME
ORDER BY line_name, station_id, station_name;







SELECT 
(
SELECT CEIL(TO_DATE ('2010-01-01-02-59-59', 'YYYY-MM-DD-HH24-MI-SS') -TO_DATE ('2009-07-01-03-00-00', 'YYYY-MM-DD-HH24-MI-SS') )
FROM DUAL
) - 
(
SELECT COUNT(DISTINCT TRUNC(HOLIDAY_DATE)) 
FROM MBTA_HOLIDAY
WHERE 1=1

            AND holiday_date(+) >=
                   TO_DATE ('2009-07-01-03-00-00', 'YYYY-MM-DD-HH24-MI-SS') --This and below line are very important otherwise it is taking 10 hrs for 1 month.
            AND holiday_date(+) <=
                   TO_DATE ('2010-01-01-02-59-59', 'YYYY-MM-DD-HH24-MI-SS')
--AND HOLIDAY_DATE(+) >= dDateFirst
--AND HOLIDAY_DATE(+) <= dDateLast
AND TO_CHAR(HOLIDAY_DATE,'hh24') NOT IN ('00','01','02')
)                                                                                 --Count of weekdays of given date range
FROM DUAL;
 
                 
SELECT COUNT(DISTINCT TRUNC(HOLIDAY_DATE))-- INTO V_SATURDAYS          -- Count of Saturdays
FROM MBTA_HOLIDAY
WHERE 1=1
            AND holiday_date(+) >=
                   TO_DATE ('2009-07-01-03-00-00', 'YYYY-MM-DD-HH24-MI-SS') --This and below line are very important otherwise it is taking 10 hrs for 1 month.
            AND holiday_date(+) <=
                   TO_DATE ('2010-01-01-02-59-59', 'YYYY-MM-DD-HH24-MI-SS')
AND HOLIDAY_DESCRIPTION IN ('Saturday')
AND TO_CHAR(HOLIDAY_DATE,'hh24') NOT IN ('00','01','02');                 


SELECT COUNT(DISTINCT TRUNC(HOLIDAY_DATE)) -- INTO V_SUNDAYS             -- Count of Sundays
FROM MBTA_HOLIDAY
WHERE 1=1
            AND holiday_date(+) >=
                   TO_DATE ('2009-07-01-03-00-00', 'YYYY-MM-DD-HH24-MI-SS') --This and below line are very important otherwise it is taking 10 hrs for 1 month.
            AND holiday_date(+) <=
                   TO_DATE ('2010-01-01-02-59-59', 'YYYY-MM-DD-HH24-MI-SS')
AND HOLIDAY_DESCRIPTION IN ('Sunday')
AND TO_CHAR(HOLIDAY_DATE,'hh24') NOT IN ('00','01','02');


SELECT COUNT(DISTINCT TRUNC(HOLIDAY_DATE)) --INTO V_HOLIDAYS            --Count of Holidays
FROM MBTA_HOLIDAY
WHERE 1=1
            AND holiday_date(+) >=
                   TO_DATE ('2009-07-01-03-00-00', 'YYYY-MM-DD-HH24-MI-SS') --This and below line are very important otherwise it is taking 10 hrs for 1 month.
            AND holiday_date(+) <=
                   TO_DATE ('2010-01-01-02-59-59', 'YYYY-MM-DD-HH24-MI-SS')
AND HOLIDAY_DESCRIPTION NOT IN ('Saturday','Sunday')
AND TO_CHAR(HOLIDAY_DATE,'hh24') NOT IN ('00','01','02');    