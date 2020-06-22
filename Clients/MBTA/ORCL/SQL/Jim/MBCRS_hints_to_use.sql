All the below are in test

SELECT  --12 secs --97863 records
						/*+
						INDEX	(st, XPKSALESTRANSACTION)
						*/
count(1)
				FROM
	 		 		 	SalesTransaction	st
 				WHERE	1 = 1
					AND st.TestSaleFlag				=	0
          AND (st.DEVICECLASSID, st.DEVICEID) in (select  tvm.DeviceClassID DeviceClassId, tvm.TVMID DeviceId
                                                                       from TVMTable					tvm
                                                                              ,Routes						rou
                                                                              ,TVMStation					sta
                                                                    where sta.StationID 	=	tvm.TVMTariffLocationID
                                                                       AND rou.RouteID	 =	tvm.RouteID
                                                                       AND (rou.routeid = 9996 and (sta.stationid in(1080,1009,1075)) or (rou.routeid = 1500))
                                                                     )
					AND	st.CreaDate					>=	To_Date	('2007-09-01 03-00-00','YYYY-MM-DD HH24-MI-SS')
					AND	st.CreaDate					<=	To_Date	('2007-10-01 02-59-59','YYYY-MM-DD HH24-MI-SS')
					AND	st.PartitioningDate			>=	To_Date	('2007-09-01 03-00-00','YYYY-MM-DD HH24-MI-SS')
          

SELECT -- 9 secs --97678 recs
						/*+
						INDEX		(cp XPKCASHPAYMENT)
						*/
count(1)
				FROM
						CashPayment		cp
 				WHERE	1 = 1 
					AND	cp.CreaDate					>=	To_Date	('2007-09-01 03-00-00','YYYY-MM-DD HH24-MI-SS')
					AND	cp.CreaDate					<=	To_Date	('2007-10-01 02-59-59','YYYY-MM-DD HH24-MI-SS')
					AND	cp.PartitioningDate			>=	To_Date	('2007-09-01 03-00-00','YYYY-MM-DD HH24-MI-SS')
                  AND (cp.DEVICECLASSID, cp.DEVICEID) in (select  tvm.DeviceClassID DeviceClassId, tvm.TVMID DeviceId
                                                                       from TVMTable					tvm
                                                                              ,Routes						rou
                                                                              ,TVMStation					sta
                                                                    where sta.StationID 	=	tvm.TVMTariffLocationID
                                                                       AND rou.RouteID	 =	tvm.RouteID
  and (rou.routeid = 9996 and (sta.stationid in(1080,1009,1075)) or (rou.routeid = 1500))
                                                                    )                 
                                                                             
                                                                    
SELECT -- 83 secs  122331 recs
						/*+
						INDEX		(sd XPKSALESDETAIL)
						*/
count(1)
 				FROM
						SalesDetail					sd
 				WHERE	1 = 1
					AND	sd.CreaDate					>=	To_Date	('2007-09-01 03-00-00','YYYY-MM-DD HH24-MI-SS')
					AND	sd.CreaDate					<=	To_Date	('2007-10-01 02-59-59','YYYY-MM-DD HH24-MI-SS')
					AND	sd.PartitioningDate			>=	To_Date	('2007-09-01 03-00-00','YYYY-MM-DD HH24-MI-SS')    
                  AND (sd.DEVICECLASSID, sd.DEVICEID) in (select  tvm.DeviceClassID DeviceClassId, tvm.TVMID DeviceId
                                                                       from TVMTable					tvm
                                                                              ,Routes						rou
                                                                              ,TVMStation					sta
                                                                    where sta.StationID 	=	tvm.TVMTariffLocationID
                                                                       AND rou.RouteID	 =	tvm.RouteID
  and (rou.routeid = 9996 and (sta.stationid in(1080,1009,1075)) or (rou.routeid = 1500))
                                                                    )                  
  
  SELECT  -- 6secs      185 recs
						/*+
						INDEX	(clp XPKCASHLESSPAYMENT)
						*/
count(1)
				FROM
						CashlessPayment		clp

 				WHERE	1 = 1
					AND	clp.PayTypeCashless		IN	(1
													,2
													,4
													,16
													,19
													,32
													,64
													)
					AND	clp.CreaDate				>=	To_Date	('2007-09-01 03-00-00','YYYY-MM-DD HH24-MI-SS')
					AND	clp.CreaDate				<=	To_Date	('2007-10-01 02-59-59','YYYY-MM-DD HH24-MI-SS')
					AND	clp.PartitioningDate		>=	To_Date	('2007-09-01 03-00-00','YYYY-MM-DD HH24-MI-SS')
                  AND (clp.DEVICECLASSID, clp.DEVICEID) in (select  tvm.DeviceClassID DeviceClassId, tvm.TVMID DeviceId
                                                                       from TVMTable					tvm
                                                                              ,Routes						rou
                                                                              ,TVMStation					sta
                                                                    where sta.StationID 	=	tvm.TVMTariffLocationID
                                                                       AND rou.RouteID	 =	tvm.RouteID
  and (rou.routeid = 9996 and (sta.stationid in(1080,1009,1075)) or (rou.routeid = 1500))   )       
  