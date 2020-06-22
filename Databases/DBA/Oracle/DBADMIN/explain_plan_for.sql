--Explain plan for
--set autotrace traceonly explain
ALTER SESSION SET SQL_TRACE = TRUE;
SELECT
	/*+
		ORDERED
		USE_HASH	(sub)
		INDEX		(sub	XIE1SalesDetail)
		USE_HASH	(mcm)
    USE_HASH	(ms)
		USE_HASH	(sd)
		USE_HASH	(st)
		PARALLEL	(mcm, 4)
    PARALLEL	(ms, 4)
		PARALLEL	(sd, 4)
		PARALLEL	(st, 4)    
		FULL		(mcm)
    FULL		(ms)
		FULL		(sd)
		FULL		(st)
		USE_NL		(tvm)
		USE_NL		(sta)
    USE_HASH    (hol)
	*/
--	 :QueryID
--	,1
--	,
sta.stationid                            -- Station Id
  ,sta.Name																	--	Station
  ,sum(decode(hol.service_date, null, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 ))                                           --weekdays Count
--  ,:weekdays
  ,sum(decode(hol.service_type, 2, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 ))                                              --Saturdays Count                                                             
--  ,:saturdays
  ,sum(decode(hol.service_type, 3, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 ))                                              --Sundays Count
--  ,:sundays
  ,sum(decode(hol.service_type, 1, Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1),0 ))                                              --Holidays Count
--  ,:holidays
  ,sum(Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1))                                                                                           --Totaldays Count
--  :Totaldays
FROM
	 SalesDetail			sd
	,SalesDetail			sub
	,MiscCardMovement		mcm
	,SalesTransaction		st
	,TVMTable				tvm
	,tvmStation				sta
  ,mbta_weekend_service   hol
WHERE		1=1
--
--	Join conditions
--
	AND	sub.DeviceClassId   	(+)	= sd.DeviceClassId
	AND	sub.DeviceId       		(+)	= sd.DeviceId
	AND	sub.Uniquemsid     		(+)	= sd.Uniquemsid
	AND	sub.SalestransactionNo	(+)	= sd.SalesTransactionNo
	AND	sub.SalesDetailEvSequNo	(+)	= sd.SalesDetailEvSequNo	+1
	AND	sub.CorrectionCounter	(+)	= sd.CorrectionCounter
	AND	sub.PartitioningDate	(+)	= sd.PartitioningDate
	AND	mcm.DeviceClassId   		= sd.DeviceClassId
	AND	mcm.DeviceId	       		= sd.DeviceId
	AND	mcm.Uniquemsid  	   		= sd.Uniquemsid
	AND	mcm.SalestransactionNo		= sd.SalesTransactionNo
	AND	mcm.SequenceNo				= Decode	(sub.SalesDetailEvSequNo
													,NULL	,sd.SalesDetailEvSequNo
												,sub.SalesDetailEvSequNo
												)
	AND	mcm.CorrectionCounter		= sd.CorrectionCounter
	AND	mcm.PartitioningDate		= sd.PartitioningDate
	AND	mcm.TimeStamp				= sd.CreaDate
	AND	sd.DeviceID					= st.DeviceID
	AND	sd.DeviceClassID			= st.DeviceClassID
	AND	sd.UniqueMSID				= st.UniqueMSID
	AND	sd.SalesTransactionNo		= st.SalesTransactionNo
	AND	sd.PartitioningDate			= st.PartitioningDate
	AND	tvm.TVMID			=	st.DeviceID
	AND	tvm.DeviceClassID	=	st.DeviceClassID
	AND	sta.StationID 	(+)	=	tvm.TVMTariffLocationID
AND    trunc(hol.service_date (+)) = trunc(sd.creadate)
AND    trunc(hol.service_date (+), 'hh24')  = trunc(sd.creadate, 'hh24')
--
--	Filter conditions
--
	AND	mcm.MovementType	IN	 (7,20)
	AND	sd.ArticleNo				> 	100000
	AND	sd.CorrectionFlag			= 	0
	AND	sd.RealStatisticArticle		= 	0
	AND	sd.TempBooking				= 	0
	AND sd.ArticleNo				<> 	607900100
	AND sub.ArticleNo			(+)	=	607900100
	AND	st.TestSaleFlag				= 	0
  AND	mcm.DeviceClassID		IN	(
										SELECT
											DeviceClassID
										FROM
											DeviceClass
										WHERE	DeviceClassType	IN	(5)                                                                                  --	Fareboxes
									)
--
--	Parameter conditions
--
AND    sd.CreaDate            >= to_date('2010-08-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
AND    sd.CreaDate            <= to_date('2010-09-01-02-59-59','YYYY-MM-DD-HH24-MI-SS')
AND    sd.PartitioningDate    >= to_date('2010-08-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
AND    sd.PartitioningDate    <  to_date('2010-10-01-00-00-00','YYYY-MM-DD-HH24-MI-SS')
AND  hol.service_date(+) >= to_date('2010-08-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')     --This and below line are very important otherwise it is taking 10 hrs for 1 month.
AND  hol.service_date(+) <= to_date('2010-09-01-02-59-59','YYYY-MM-DD-HH24-MI-SS')
AND	1=1
GROUP	BY
sta.NAME, sta.stationid;
ALTER SESSION SET SQL_TRACE = FALSE;

/*
SELECT cardinality "Rows",
       lpad(' ',level-1)||operation||' '||
       options||' '||object_name "Plan"
  FROM PLAN_TABLE
CONNECT BY prior id = parent_id
        AND prior statement_id = statement_id
  START WITH id = 0
        AND statement_id = '124'
  ORDER BY id;
  
  
SELECT lpad(' ',level-1)||operation||' '||options||' '||
        object_name "Plan"
   FROM plan_table
CONNECT BY prior id = parent_id
        AND prior statement_id = statement_id
  START WITH id = 0 AND statement_id = '124'
  ORDER BY id;

  
  
  select * from v$sysstat 


select * from table(dbms_xplan.display_cursor('123'));  -- for current statements 

select * from v$thread

select * from v$sql_plan where object# = '123'

select sid,serial#,qcsid,qcserial#,degree from v$px_session;

            
SELECT OPTIMIZER          , 
       DECODE (id, 0, '', 
       LPAD (' ', 2 * (level - 1)) || level || '.' || position) || ' ' || 
       operation || ' ' || options || ' ' || object_name || ' ' || 
       object_type || ' ' || 
       DECODE (id, 0, 'Cost = ' || position) query_plan 
  FROM plan_table  
CONNECT BY prior id = parent_id 
        AND prior statement_id = statement_id
  START WITH id = 0
  and statement_id = 123 

            
            
            select * from plan_table          
*/            
            
            
            
            