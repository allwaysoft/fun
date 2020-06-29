select * from gv$sqlarea where upper(sql_fulltext) like '%SUBSTR(SSME.SUB_NUM,1,9) = SUBSTR(MMI.SUB_NUM,1,9)%'

select * from gv$sql where upper(sql_fulltext) like '%SUBSTR(SSME.SUB_NUM,1,9) = SUBSTR(MMI.SUB_NUM,1,9)%'

select sql_id, PLAN_HASH_VALUE, child_number, max(to_char(timestamp,'DD-MON-YYYY HH24:MI:SS')) Timestamp
from v$sql_plan
where sql_id='a8372ka371uys'
group by sql_id, PLAN_HASH_VALUE, child_number;


SELECT * from table(DBMS_XPLAN.DISPLAY_CURSOR(sql_id =>'a8372ka371uys', cursor_child_no =>'0', format => 'TYPICAL +peeked_binds'));

SELECT * from table(DBMS_XPLAN.DISPLAY_AWR(sql_id =>'4nc73q984vywm', format => 'TYPICAL +peeked_binds'));



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
            
                      


Execution Plans
view SQL plans of SQL in various scenarios.
/**** Get SQL execution plan information which is still available in SHARED POOL ****/
–get sql id from sql text
select * from v$sql where sql_text like ‘with pri_detai%’;

–get the latest plan_hash_value and other plan details used by SQL
select sql_id, PLAN_HASH_VALUE, max(to_char(timestamp,’DD-MON-YYYY HH24:MI:SS’)) Timestamp
from v$sql_plan
where sql_id= ‘&sqlid’
group by sql_id, PLAN_HASH_VALUE;

–get the execution plan based on the sqlid
FORMAT=> ‘TYPICAL +outline’ This option for format gives the outline data. In outline data, the “LEADING” section provides the join order used by the SQL
'TYPICAL +peeked_binds' This option as name suggests shows the bind variables of the SQL slong with the execution plan
cursor_child_no use this when there are more than one plans for the same sql_id
SELECT * from table(DBMS_XPLAN.DISPLAY_CURSOR(sql_id => ‘&sqlid’, cursor_child_no => ‘&chld’, plan_hash_value => ‘&phv’, format => ‘&format’));

/**** Get SQL execution plan information which is out of SHARED POOL and in AWR ****/
–get sql id from sql text
select * from dba_hist_sqltext where sql_text like ‘with pri_detai%’;

–get the latest plan_hash_value used by SQL
select sql_id, PLAN_HASH_VALUE, max(to_char(timestamp,’DD-MON-YYYY HH24:MI:SS’)) Timestamp
from DBA_HIST_SQL_PLAN
where sql_id= ’7rxh365jpp33w’
group by sql_id, PLAN_HASH_VALUE;

–get the execution plan based on the sqlid
–FORMAT=> ‘TYPICAL +outline’); This option for format gives the outline data. Inoutline data, the “LEADING” section provides the join order useed by the SQL
select * from TABLE(DBMS_XPLAN.DISPLAY_AWR(sql_id => ‘&sqlid’, plan_hash_value => ‘&phv’, format => ‘&format’));

Other ways of getting Execution plans
https://blogs.oracle.com/sql/how-to-create-an-execution-plan
 
 Finding and tuning high resource usage SQL
http://perranganos.blogspot.com/2012/01/tanel-poder-snapper-brilliant.html –This link shows how to identify the SQL

https://github.com/tanelpoder/tpt-oracle –This link has all the scripts used by Tanel Poder, including the once used in above link to identify SQL.

All about execution plans by Jonathan Lewis
http://allthingsoracle.com/author/jonathan-lewis/