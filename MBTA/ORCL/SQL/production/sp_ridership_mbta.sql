
  CREATE OR REPLACE PROCEDURE "MBTA"."SP_RIDERSHIP_2007_MBTA" (nQueryID 		NUMBER
                                   ,nReportID		NUMBER
                                   ,dDateFirst 	DATE
                                   ,dDateLast 		DATE
                                   ,pLine 			VARCHAR2
                                   ,pStation 		VARCHAR2
                                   ,pGarageId		VARCHAR2
                                   ,pFareClassId	VARCHAR2
                                   ,pProductType	VARCHAR2
                                   ,pRouteId		VARCHAR2
                                   ,pWhere 		VARCHAR2
                                    )
IS
--------------------------------------------------------------------------------
-- Procedure: SP_RiderShip_2007_MBTA
-- MBTA procedure for ridership reports
--
-- Creation :	2010-09-09, Kranthi Pabba
--
-- Purpose  :	Executes querys for ridership reports
--
--
-- Input    :	nQueryID		ID to identify result set in table MBTA_TempResult
--
--				dDateFirst		start date of query
--				dDateLast		end date of query
--        PWhere     filter conditions if any
--
-- Return   : 	Results in TempResult
--
--------------------------------------------------------------------------------
--
-- Change:
--
--------------------------------------------------------------------------------

	nDays		NUMBER		(10);
  
	vCrLf		VARCHAR2	(10) 	:= Chr(13)||Chr(10);

	cHint						VARCHAR2	( 1000);							-- Hint: Full or single scan


	dDateFirst_loop			DATE :=ddatefirst;				-- Date first for looping
	dDatelast_loop			DATE;											-- Date last for looping
  
	dDateFirst_1				DATE;											-- Date first for 1. partitioning section
	dDateFirst_2				DATE;											-- Date first for 2. partitioning section
	dDateFirst_3				DATE;											-- Date first for 3. partitioning section
	dDateFirst_4				DATE;											-- Date first for 4. partitioning section
	dDateLast_1					DATE;											-- Date last for 1. partitioning section
	dDateLast_2					DATE;											-- Date last for 2. partitioning section
	dDateLast_3					DATE;											-- Date last for 3. partitioning section
	dDateLast_4					DATE;											-- Date last for 4. partitioning section
	dPartitioningDateFirst 		DATE;
	dPartitioningDateLast 		DATE;

  v_weekdays       NUMBER;                 -- Used for caliculating weekdays average ridership
  v_holidays          NUMBER;                 -- Used for caliculating Holidays average ridership
  v_saturdays        NUMBER;                 -- Used for caliculating Saturdays average ridership
  v_sundays          NUMBER;                 -- Used for caliculating Sundays average ridership
  v_totaldays        NUMBER;                 -- Used for caliculating Total average ridership

	nDays_1						NUMBER;											-- Count of days 1. partitioning section
	nDays_2						NUMBER;											-- Count of days 2. partitioning section
	nDays_3						NUMBER;											-- Count of days 3. partitioning section

	TYPE EmptyCursorTyp IS REF CURSOR;

	stmt_Main_Full				VARCHAR2	(32767);							-- Main statemenent	full scan
	stmt_Main_Single			VARCHAR2	(32767);							-- Main statemenent	single scan
	stmt_Insert					VARCHAR2	(30000);							-- First part of Insert statement
	stmt_Select_Full			VARCHAR2	(30000);							-- Select statement full scan
	stmt_Select_Single			VARCHAR2	(30000);							-- Select statement	single scan
	stmt_Hint_Complete_Full		VARCHAR2	( 1000);							-- Complete hint: Full table scan
	stmt_Hint_Complete_Single	VARCHAR2	( 1000);							-- Complete hint: Single scan
	stmt_From					VARCHAR2	(  400);							-- From clause
	stmt_Group					VARCHAR2	(  200);							-- Group By clause
	stmt_Where					VARCHAR2	(20000);							-- Where clause
  
  print_c VARCHAR2	(30000);

----------------------------------------------------
--
--	Parameter presets
--
----------------------------------------------------

	pnDays4SingleScan		CONSTANT	NUMBER	:=	2;									--	limit of days for single scan


--------------------------------------------------------------------------------
--
--	statement presets
--
--------------------------------------------------------------------------------
	stmt_Insert_Start			VARCHAR2	(  100)	:=							-- Insert statement start
'INSERT INTO
	mbta_tempresult
';
	stmt_Insert_List			VARCHAR2	(20000)	:=							-- Insert statement	column list
'	(QueryID
	,LineId
';
--------------------------------------------------------------------------------
	stmt_Select_Start			VARCHAR2	( 1000)	:=							-- Select statement start
'SELECT
';

	stmt_Select_List			VARCHAR2	( 30000)	:=							--	start of select column list
'	 :QueryID
	,1
';
--------------------------------------------------------------------------------
	stmt_Hint_Start				VARCHAR2	(  200)	:=							--	Hint start
'	/*+
';
	stmt_Hint_List				VARCHAR2	(  200);							--	Hint list

	stmt_Hint_Full				VARCHAR2	(  500)	:=							--	Hint: Full table scan
'		ORDERED
		INDEX		(sub	XIE1SalesDetail)
		USE_HASH	(sd)    
		USE_HASH	(sub)
		USE_HASH	(mcm)
		USE_HASH	(st)    
    USE_HASH	(ms)
		PARALLEL	(sd  4)    
    PARALLEL sub 4)    
		PARALLEL	(mcm  4)
		PARALLEL	(st  4)        
    PARALLEL	(ms  4)
		FULL		(sd)    
		FULL		(mcm)
		FULL		(st)    
    FULL		(ms)
';

	stmt_Hint_Single			VARCHAR2	(  500)	:=							--	Hint: Single scan
'		ORDERED
		INDEX		(sub	XIE1SalesDetail)
		USE_HASH	(sub)    
		USE_NL		(mcm)
		USE_NL		(st)
		PARALLEL	(sd  4)    
    PARALLEL sub 4)    
		PARALLEL	(mcm  4)
		PARALLEL	(st  4)        
    PARALLEL	(ms  4) 
		INDEX		(mcm	XIE5MiscCardMovement)
		INDEX		(sd		XIE8SalesDetail)
		INDEX		(st		XPKSalesTransaction)
    INDEX		(ms		XPKMainShift)
    INDEX   (hol PK_MBTA_WEEKEND_SERVICE_DATE)
';
	stmt_Hint_End				VARCHAR2	(   10)	:=							--	Hint end
'	*/
';
--------------------------------------------------------------------------------
	stmt_From_Start				VARCHAR2	(   10)	:=							--	From clause
'FROM
';
	stmt_From_List				VARCHAR2	(  500)	:=							--	From table list
'	 SalesDetail			sd
	,SalesDetail			sub
	,MiscCardMovement		mcm
	,SalesTransaction		st
';
--------------------------------------------------------------------------------
	stmt_Where_Start			VARCHAR2	(   20)	:=							--	Where clause
'WHERE		1=1
';
	stmt_Where_Join				VARCHAR2	( 2000)	:=							--	Default Join conditions
'--
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

	AND	st.DeviceID = sd.DeviceID
	AND	st.DeviceClassID = sd.DeviceClassID
	AND	st.UniqueMSID = sd.UniqueMSID
	AND	st.SalesTransactionNo = sd.SalesTransactionNo
	AND	st.PartitioningDate = sd.PartitioningDate
';

	stmt_Where_Parameter		VARCHAR2	( 1000)	:=							--	Default Parameter conditions
'--
--	Parameter conditions
--

	AND	sd.CreaDate			>=      :dDateFirst                                             --to_date(:dDateFirst, ''mm/dd/yyyy hh24:mi:ss'')
	AND	sd.CreaDate			<=      :dDateLast                                             
	AND	sd.PartitioningDate	>= :dPartitioningDateFirst                              
	AND	sd.PartitioningDate	<   :dPartitioningDateLast                               
';
	stmt_Where_Filter			VARCHAR2	( 1000)	:=							--	Default Filter conditions
'--
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
';
--------------------------------------------------------------------------------
	stmt_Group_Start			VARCHAR2	(   10)	:=							-- Group By statement start
'GROUP	BY
';
	stmt_Group_List				VARCHAR2	(  100);							-- Group by column list
--------------------------------------------------------------------------------
	exc_Test            		EXCEPTION;
	iNum						NUMBER		(   10);
--==============================================================================
--
--	Start procedure
--
--------------------------------------------------------------------------------
BEGIN
	DELETE mbta_tempResult;
	COMMIT;

--------------------------------------------------------------------------------
--
--	Compose Statement
--
--------------------------------------------------------------------------------
--
--	Case of Report-Id
--
----------------------
	CASE	TRUE
--------------------------------------------------------------------------------
--
--	377	Route Ridership by Garage                          --MBTA
--
--------------------------------------------------------------------------------

	WHEN	nReportId	=	377 	THEN
--------
		stmt_Insert_List	:=	stmt_Insert_List	||
' ,Data30	
  ,Data31
  ,number1
  ,number2
  ,number3
  ,number4
  ,number5
  ,number6
  ,number7
  ,number8
  ,number9
  ,number10
	)
';
--------
		stmt_Hint_List	:=	stmt_Hint_List	||
'		USE_NL		(tvm)
		USE_NL		(sta)
    USE_HASH    (hol)
';
--------
		stmt_Select_List	:=	stmt_Select_List	||
'	,sta.stationid                            -- Station Id
  ,sta.Name																	--	Station
  ,nvl(sum(decode(hol.service_date, null, Decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0 )),0)                                           --weekdays Count
  ,:weekdays
  ,nvl(sum(decode(hol.service_type, 2, Decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0 )),0)                                              --Saturdays Count                                                             
  ,:saturdays
  ,nvl(sum(decode(hol.service_type, 3, Decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0 )),0)                                              --Sundays Count
  ,:sundays
  ,nvl(sum(decode(hol.service_type, 1, Decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0 )),0)                                              --Holidays Count
  ,:holidays
  ,nvl(sum(Decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1)),0)                                                                                           --Totaldays Count
  ,:Totaldays
';
--------
		stmt_From_List	:=	stmt_From_List	||
'	,TVMTable				tvm
	,tvmStation				sta
  ,mbta_weekend_service   hol
';
--------
		stmt_Where_Join		:=	stmt_Where_Join		||
'	AND	tvm.TVMID			=	st.DeviceID
	AND	tvm.DeviceClassID	=	st.DeviceClassID
  
	AND	sta.StationID 	(+)	=	tvm.TVMTariffLocationID

AND    trunc(hol.service_date (+)) = trunc(sd.creadate)
AND    trunc(hol.service_date (+), ''hh24'')  = trunc(sd.creadate, ''hh24'')
';
--------
		stmt_Where_Filter	:=	stmt_Where_Filter		||
'    
AND	mcm.DeviceClassID		IN	(
										SELECT
											DeviceClassID
										FROM
											DeviceClass
										WHERE	DeviceClassType	IN	(5)                                                                                  --	Fareboxes
									)
';

stmt_Where_Parameter := stmt_Where_Parameter ||
'
	AND	hol.service_date(+)			>= :dDateFirst                                        --to_date(:dDateFirst, ''mm/dd/yyyy hh24:mi:ss'')
	AND	hol.service_date(+)			<= :dDateLast                                        
';

--------
		stmt_Group_List		:=	stmt_Group_List	||
'	sta.NAME, sta.stationid 
';
--------------------------------------------------------------------------------
--
--	399	Time of Day Line Summary                           --MBTA
--
--------------------------------------------------------------------------------

	WHEN	nReportId	=	399 	THEN
--------
		stmt_Insert_List	:=	stmt_Insert_List	||
'	,number1
  ,number2
  ,data30
	,Data31
  ,number3
  ,number4
  ,number5
  ,number6
  ,number7
  ,number8
  ,number9
  ,number10
  ,number11
  ,number12
	)
';
--------

		stmt_Hint_List	:=	stmt_Hint_List	||
'		USE_NL		(rou)
		USE_NL		(tvm)
		USE_NL		(sta)
    USE_HASH    (hol)
';
--------
		stmt_Select_List	:=	stmt_Select_List	||
' ,rou.routeid         --Line Id
  ,sta.stationid       --Station Id
  ,rou.description    --  Line_Name
	,sta.Name						 --	Station_Name
  
  ,nvl(sum(decode(hol.service_date, null, Decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0 )),0)                                           --weekdays Count
  ,:weekdays
  ,nvl(sum(decode(hol.service_type, 2, Decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0 )),0)                                              --Saturdays Count                                                             
  ,:saturdays
  ,nvl(sum(decode(hol.service_type, 3, Decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0 )),0)                                              --Sundays Count
  ,:sundays
  ,nvl(sum(decode(hol.service_type, 1, Decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0 )),0)                                              --Holidays Count
  ,:holidays
  ,nvl(sum(Decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1)),0)                                                                                           --Totaldays Count
  ,:Totaldays
  ';
--------
		stmt_From_List	:=	stmt_From_List	||
'	,Mainshift				ms
	,Routes					rou
	,TVMTable				tvm
	,tvmStation				sta
  ,mbta_weekend_service     hol
';
--------
		stmt_Where_Join		:=	stmt_Where_Join		||
'	AND	ms.DeviceClassId	=	st.DeviceClassId
	AND	ms.DeviceId			=	st.DeviceId
	AND	ms.Uniquemsid		=	st.Uniquemsid
	AND	ms.EndCreaDate		=	st.PartitioningDate

	AND	tvm.TVMID			=	ms.DeviceID
	AND	tvm.DeviceClassID	=	ms.DeviceClassID

	AND	sta.StationID 	(+)	=	tvm.TVMTariffLocationID

	AND	rou.RouteID			=	ms.RouteNo  --outer join not necessary for this report.

AND    trunc(hol.service_date (+)) = trunc(sd.creadate)
AND    trunc(hol.service_date (+), ''hh24'')  = trunc(sd.creadate, ''hh24'')
';
--------

stmt_Where_Filter	:=	stmt_Where_Filter		||
'  
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
)   -- Silver Lines and SubWays Only 
';


stmt_Where_Parameter := stmt_Where_Parameter ||
'
	AND	hol.service_date(+)			>= :dDateFirst                                        --to_date(:dDateFirst, ''mm/dd/yyyy hh24:mi:ss'')
	AND	hol.service_date(+)			<= :dDateLast
';

--------
		stmt_Group_List		:=	stmt_Group_List	||
'	 rou.routeid
  ,sta.NAME
  ,sta.stationid
  ,rou.description
';

--------------------------------------------------------------------------------
--
--	400	Subway Station Ridership Report                     --MBTA
--
--------------------------------------------------------------------------------

	WHEN	nReportId	=	400 	THEN
--------
		stmt_Insert_List	:=	stmt_Insert_List	||
'	,number1
  ,number2
  ,data30
	,Data31
 ,number3
 ,number4
 ,number5
 ,number6
 ,number7
 ,number8
 ,number9
 ,number10
 ,number11
 ,number12
 ,number13
 ,number14
 ,number15
 ,number16
 ,number17
 ,number18
 ,number19
 ,number20
 ,number21
 ,number22
 ,number23
 ,number24
 ,number25
 ,number26
 ,number27
 ,number28
 ,number29
 ,number30
 ,number31
 ,number32
 ,number33
 ,number34
 ,number35
 ,number36
 ,number37
 ,number38
 ,number39
 ,number40
 ,number41
 ,number42
 ,number43
 ,number44
 ,number45
 ,number46
 ,number47
 ,number48
 ,number49
 ,number50
 ,number51
 ,number52
 ,number53
 ,number54
 ,number55
 ,number56
 ,number57
 ,number58
 ,number59
 ,number60
 ,number61
 ,number62
 ,number63
 ,number64
 ,number65
 ,number66
 ,number67
 ,number68
 ,number69
 ,number70
 ,number71
 ,number72
 ,number73
 ,number74
 ,number75
 ,number76
 ,number77
 ,number78
 ,number79
 ,number80
 ,number81
 ,number82
 ,number83
 ,number84
 ,number85
 ,number86
 ,number87
 ,number88
 ,number89
 ,number90
 ,number91
 ,number92
 ,number93
 ,number94
 ,number95
 ,number96
 ,number97
 ,number98
 ,number99
 ,number100
 ,number101
 ,number102
 ,number103
 ,number104
 ,number105
 ,number106
 ,number107
 ,number108
 ,number109
 ,number110
 ,number111
 ,number112
 ,number113
 ,number114
 ,number115
 ,number116
 ,number117
 ,number118
 ,number119
 ,number120
 ,number121
 ,number122
 ,number123
 ,number124
 ,number125
 ,number126
 ,number127
 ,number128
 ,number129
 ,number130
 ,number131
 ,number132
)
';

--------
		stmt_Hint_List	:=	stmt_Hint_List	||
'		USE_NL		(rou)
		USE_NL		(tvm)
		USE_NL		(sta)
    USE_HASH    (hol)    
';
--------
		stmt_Select_List	:=	stmt_Select_List	||
'	,rou.routeid         --Line Id
  ,sta.stationid       --Station Id
  ,rou.description    --  Line_Name
	,sta.Name						 --	Station_Name

,nvl(sum(decode(hol.service_date, null, Decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0 )),0)  --weekdays Count
,:weekdays
,nvl(sum(decode(hol.service_type, 2, Decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0 )),0) --Saturdays Count                                                             
,:saturdays
,nvl(sum(decode(hol.service_type, 3, Decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0 )),0) --Sundays Count
,:sundays
,nvl(sum(decode(hol.service_type, 1, Decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0 )),0) --Holidays Count
,:holidays
,nvl(sum(Decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1)),0) --Totaldays Count
,:Totaldays

,nvl(sum(decode(service_date,null,Decode(To_Char(sd.Creadate,''HH24''),''00'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0) 
,nvl(sum(decode(service_date,null,Decode(To_Char(sd.Creadate,''HH24''),''01'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0) 
,nvl(sum(decode(service_date,null,Decode(To_Char(sd.Creadate,''HH24''),''02'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0) 
,nvl(sum(decode(service_date,null,Decode(To_Char(sd.Creadate,''HH24''),''03'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0) 
,nvl(sum(decode(service_date,null,Decode(To_Char(sd.Creadate,''HH24''),''04'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0) 
,nvl(sum(decode(service_date,null,Decode(To_Char(sd.Creadate,''HH24''),''05'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0) 
,nvl(sum(decode(service_date,null,Decode(To_Char(sd.Creadate,''HH24''),''06'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0) 
,nvl(sum(decode(service_date,null,Decode(To_Char(sd.Creadate,''HH24''),''07'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0) 
,nvl(sum(decode(service_date,null,Decode(To_Char(sd.Creadate,''HH24''),''08'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0) 
,nvl(sum(decode(service_date,null,Decode(To_Char(sd.Creadate,''HH24''),''09'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0) 
,nvl(sum(decode(service_date,null,Decode(To_Char(sd.Creadate,''HH24''),''10'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_date,null,Decode(To_Char(sd.Creadate,''HH24''),''11'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_date,null,Decode(To_Char(sd.Creadate,''HH24''),''12'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_date,null,Decode(To_Char(sd.Creadate,''HH24''),''13'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_date,null,Decode(To_Char(sd.Creadate,''HH24''),''14'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_date,null,Decode(To_Char(sd.Creadate,''HH24''),''15'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_date,null,Decode(To_Char(sd.Creadate,''HH24''),''16'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_date,null,Decode(To_Char(sd.Creadate,''HH24''),''17'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_date,null,Decode(To_Char(sd.Creadate,''HH24''),''18'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_date,null,Decode(To_Char(sd.Creadate,''HH24''),''19'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_date,null,Decode(To_Char(sd.Creadate,''HH24''),''20'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_date,null,Decode(To_Char(sd.Creadate,''HH24''),''21'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_date,null,Decode(To_Char(sd.Creadate,''HH24''),''22'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_date,null,Decode(To_Char(sd.Creadate,''HH24''),''23'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
---
,nvl(sum(decode(service_type,2,Decode(To_Char(sd.Creadate,''HH24''),''00'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,2,Decode(To_Char(sd.Creadate,''HH24''),''01'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,2,Decode(To_Char(sd.Creadate,''HH24''),''02'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,2,Decode(To_Char(sd.Creadate,''HH24''),''03'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,2,Decode(To_Char(sd.Creadate,''HH24''),''04'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,2,Decode(To_Char(sd.Creadate,''HH24''),''05'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,2,Decode(To_Char(sd.Creadate,''HH24''),''06'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,2,Decode(To_Char(sd.Creadate,''HH24''),''07'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,2,Decode(To_Char(sd.Creadate,''HH24''),''08'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,2,Decode(To_Char(sd.Creadate,''HH24''),''09'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0) 
,nvl(sum(decode(service_type,2,Decode(To_Char(sd.Creadate,''HH24''),''10'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0) 
,nvl(sum(decode(service_type,2,Decode(To_Char(sd.Creadate,''HH24''),''11'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0) 
,nvl(sum(decode(service_type,2,Decode(To_Char(sd.Creadate,''HH24''),''12'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0) 
,nvl(sum(decode(service_type,2,Decode(To_Char(sd.Creadate,''HH24''),''13'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,2,Decode(To_Char(sd.Creadate,''HH24''),''14'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0) 
,nvl(sum(decode(service_type,2,Decode(To_Char(sd.Creadate,''HH24''),''15'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,2,Decode(To_Char(sd.Creadate,''HH24''),''16'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,2,Decode(To_Char(sd.Creadate,''HH24''),''17'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,2,Decode(To_Char(sd.Creadate,''HH24''),''18'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,2,Decode(To_Char(sd.Creadate,''HH24''),''19'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,2,Decode(To_Char(sd.Creadate,''HH24''),''20'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,2,Decode(To_Char(sd.Creadate,''HH24''),''21'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,2,Decode(To_Char(sd.Creadate,''HH24''),''22'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,2,Decode(To_Char(sd.Creadate,''HH24''),''23'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
---
,nvl(sum(decode(service_type,3,Decode(To_Char(sd.Creadate,''HH24''),''00'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,3,Decode(To_Char(sd.Creadate,''HH24''),''01'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,3,Decode(To_Char(sd.Creadate,''HH24''),''02'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,3,Decode(To_Char(sd.Creadate,''HH24''),''03'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,3,Decode(To_Char(sd.Creadate,''HH24''),''04'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,3,Decode(To_Char(sd.Creadate,''HH24''),''05'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,3,Decode(To_Char(sd.Creadate,''HH24''),''06'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,3,Decode(To_Char(sd.Creadate,''HH24''),''07'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,3,Decode(To_Char(sd.Creadate,''HH24''),''08'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,3,Decode(To_Char(sd.Creadate,''HH24''),''09'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,3,Decode(To_Char(sd.Creadate,''HH24''),''10'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,3,Decode(To_Char(sd.Creadate,''HH24''),''11'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,3,Decode(To_Char(sd.Creadate,''HH24''),''12'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,3,Decode(To_Char(sd.Creadate,''HH24''),''13'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,3,Decode(To_Char(sd.Creadate,''HH24''),''14'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,3,Decode(To_Char(sd.Creadate,''HH24''),''15'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,3,Decode(To_Char(sd.Creadate,''HH24''),''16'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,3,Decode(To_Char(sd.Creadate,''HH24''),''17'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,3,Decode(To_Char(sd.Creadate,''HH24''),''18'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,3,Decode(To_Char(sd.Creadate,''HH24''),''19'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,3,Decode(To_Char(sd.Creadate,''HH24''),''20'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,3,Decode(To_Char(sd.Creadate,''HH24''),''21'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,3,Decode(To_Char(sd.Creadate,''HH24''),''22'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,3,Decode(To_Char(sd.Creadate,''HH24''),''23'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
---
,nvl(sum(decode(service_type,1, Decode(To_Char(sd.Creadate,''HH24''),''00'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,1, Decode(To_Char(sd.Creadate,''HH24''),''01'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,1, Decode(To_Char(sd.Creadate,''HH24''),''02'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,1, Decode(To_Char(sd.Creadate,''HH24''),''03'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,1, Decode(To_Char(sd.Creadate,''HH24''),''04'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,1, Decode(To_Char(sd.Creadate,''HH24''),''05'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,1, Decode(To_Char(sd.Creadate,''HH24''),''06'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,1, Decode(To_Char(sd.Creadate,''HH24''),''07'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,1, Decode(To_Char(sd.Creadate,''HH24''),''08'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,1, Decode(To_Char(sd.Creadate,''HH24''),''09'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,1, Decode(To_Char(sd.Creadate,''HH24''),''10'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,1, Decode(To_Char(sd.Creadate,''HH24''),''11'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,1, Decode(To_Char(sd.Creadate,''HH24''),''12'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,1, Decode(To_Char(sd.Creadate,''HH24''),''13'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,1, Decode(To_Char(sd.Creadate,''HH24''),''14'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,1, Decode(To_Char(sd.Creadate,''HH24''),''15'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,1, Decode(To_Char(sd.Creadate,''HH24''),''16'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,1, Decode(To_Char(sd.Creadate,''HH24''),''17'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,1, Decode(To_Char(sd.Creadate,''HH24''),''18'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,1, Decode(To_Char(sd.Creadate,''HH24''),''19'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,1, Decode(To_Char(sd.Creadate,''HH24''),''20'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,1, Decode(To_Char(sd.Creadate,''HH24''),''21'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,1, Decode(To_Char(sd.Creadate,''HH24''),''22'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
,nvl(sum(decode(service_type,1, Decode(To_Char(sd.Creadate,''HH24''),''23'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0),0)),0)
---
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''00'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0)
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''01'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0)
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''02'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0)
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''03'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0)
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''04'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0)
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''05'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0)
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''06'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0)
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''07'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0)
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''08'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0)
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''09'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0)
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''10'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0)
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''11'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0)
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''12'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0)
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''13'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0)
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''14'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0)
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''15'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0)
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''16'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0)
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''17'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0)
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''18'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0)
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''19'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0)
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''20'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0)
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''21'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0)
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''22'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0)
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''23'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0)
';
--------
		stmt_From_List	:=	stmt_From_List	||
'	,Mainshift				ms
	,Routes					rou
	,TVMTable				tvm
	,tvmStation				sta
  ,mbta_weekend_service     hol
';
--------
		stmt_Where_Join		:=	stmt_Where_Join		||
'	AND	ms.DeviceClassId	=	st.DeviceClassId
	AND	ms.DeviceId			=	st.DeviceId
	AND	ms.Uniquemsid		=	st.Uniquemsid
	AND	ms.EndCreaDate		=	st.PartitioningDate
	AND	tvm.TVMID			=	ms.DeviceID
	AND	tvm.DeviceClassID	=	ms.DeviceClassID
	AND	sta.StationID 	(+)	=	tvm.TVMTariffLocationID
	AND	rou.RouteID			=	ms.RouteNo                                 --outer join not necessary for this report.
AND    trunc(hol.service_date (+)) = trunc(sd.creadate)
AND    trunc(hol.service_date (+), ''hh24'')  = trunc(sd.creadate, ''hh24'')
';
--------

stmt_Where_Filter	:=	stmt_Where_Filter		||
'
AND	rou.routeid in 
(
1400,	
1200,	
1000,	
1300,	
1100	
)   -- Subway Stations Only 
';
-------
stmt_Where_Parameter := stmt_Where_Parameter ||
'
	AND	hol.service_date(+)			>= :dDateFirst                                        --to_date(:dDateFirst, ''mm/dd/yyyy hh24:mi:ss'')
	AND	hol.service_date(+)			<= :dDateLast                                        
';

--------
		stmt_Group_List		:=	stmt_Group_List	||
'	 rou.routeid
  ,sta.NAME
  ,sta.stationid     
  ,rou.description
';

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
	END CASE;

--==============================================================================
--
--	Compose	Statement
--
--------------------------------------------------------------------------------

	stmt_Hint_Complete_Full		:=		stmt_Hint_Start
									||	stmt_Hint_Full
									||	stmt_Hint_List
									||	stmt_Hint_End;

	stmt_Hint_Complete_Single	:=		stmt_Hint_Start
									||	stmt_Hint_Single
									||	stmt_Hint_List
									||	stmt_Hint_End;

	stmt_From					:=		stmt_From_Start
									||	stmt_From_List;

	stmt_Where					:=		stmt_Where_Start
									||	stmt_Where_Join
									||	stmt_Where_Filter
									||	stmt_Where_Parameter
									||
'	AND	'||pWhere||'
'
--' AND sd.sellingrrid <> 2 AND '||pWhere||'        -- Add this when moving to prod
;

	stmt_Group			:=		stmt_Group_Start
							||	stmt_Group_List;

--------

	stmt_Insert			:=		stmt_Insert_Start
							||	stmt_Insert_List;

	stmt_Select_Full	:=		stmt_Select_Start
							||	stmt_Hint_Complete_Full
							||	stmt_Select_List
							||	stmt_From
							||	stmt_Where
							||	stmt_Group;

	stmt_Select_Single	:=		stmt_Select_Start
							||	stmt_Hint_Complete_Single
							||	stmt_Select_List
							||	stmt_From
							||	stmt_Where
							||	stmt_Group;

--------

	stmt_Main_Full			:=		stmt_Insert
							||	stmt_Select_Full
							;

	stmt_Main_Single		:=		stmt_Insert
							||	stmt_Select_Single
							;

	sp_output_mbta	(stmt_Main_Full);
	sp_output_mbta	(stmt_Main_Single);

--------------------------------------------------------------------------------
--
--	Divide time range into 4 partitioning sections
--	-	1. section:	partition containing dDateFirst
--	-	2. section:	partition(s) not containing dDateFirst nor dDatelast
--	-	3. section:	partition containing dDateLast
--	-	4. section:	partions not containing dDateLast with date > dDateLast
--
--------------------------------------------------------------------------------


v_totaldays := CEIL(dDateLast -dDateFirst); 

SELECT nvl(sum(decode(service_type, 1,COUNT (DISTINCT TRUNC(SERVICE_DATE)), 0)),0)             --Count of Holidays
          , nvl(sum(decode(service_type, 2,COUNT (DISTINCT TRUNC(SERVICE_DATE)), 0)),0)          --Count of Saturdays
          , nvl(sum(decode(service_type, 3,COUNT (DISTINCT TRUNC(SERVICE_DATE)), 0)),0)             --Count of Sundays
INTO V_HOLIDAYS, V_SATURDAYS, V_SUNDAYS
FROM MBTA_WEEKEND_SERVICE
WHERE 1=1
AND SERVICE_DATE(+) >= dDateFirst  
AND SERVICE_DATE(+) <= dDateLast
--AND SERVICE_TYPE = 1                     --Holiday
AND TO_CHAR(SERVICE_DATE,'hh24') NOT IN ('00','01','02')
GROUP BY SERVICE_TYPE;

V_weekdays := v_totaldays - (V_HOLIDAYS+V_SATURDAYS+V_SUNDAYS);




loop                                                         -- Loop to divide the given date range in to 184 day ranges(approx 6 months) temp space

  if  ddatelast - ddatefirst_loop > 184
  then
  --ddatefirst_loop := ddatefirst;
  ddatelast_loop := ddatefirst_loop -1/(24*60*60) + 184;
  else
  ddatelast_loop := ddatelast;
end if;
  
																				--	1. section
	dDateFirst_1	:=	ddatefirst_loop;
	dDateLast_1		:=	Trunc	(Last_Day (ddatefirst_loop), 'DD') + 1;				-- 	First day of next month

																				--	2. section
	dDateFirst_2	:=	dDateLast_1;
	dDateLast_2		:=	Trunc	(ddatelast_loop, 'MM');								--	First day of month containing dDateLast

																				--	3. section
	ddatefirst_3	:=	dDateLast_2;
	dDateLast_3		:=	Trunc	(Last_Day (ddatelast_loop) +	1, 'MM');				--	First day of next month

																				--	4. section
	dDateFirst_4	:=	dDateLast_3;
	dDateLast_4		:=	To_Date	('9999-12-31 23-59-59','YYYY-MM-DD HH24-MI-SS');--	Max. date

--------------------


	nDays	:=	Ceil	(ddatelast_loop   - ddatefirst_loop  );							--	Count of all days in loop



	nDays_1	:=	Ceil	(dDateLast_1 - ddatefirst_1);							--	count of days in 1. section in loop
  

 	nDays_2	:=	Ceil	(dDateLast_2 - dDateFirst_2);							--	count of days in 2. section

	IF		(	Trunc	(dDateFirst_1, 'MM')
			=	Trunc	(dDateFirst_3, 'MM')
			)	THEN															--	1. section contains 3. section
		nDays_3	:=	0;
	ELSE
  
		nDays_3	:=	Ceil	(ddatelast_loop   - dDateFirst_3);						--	count of days in 3. section
	END IF;

--------------------------------------------------------------------------------

	sp_output_mbta	(To_Char (ddatefirst_loop, 'YYYY-MM-DD-HH24-MI-SS')||', '||To_Char (ddatelast_loop, 'YYYY-MM-DD-HH24-MI-SS')|| ', Total days: '|| To_Char(v_totaldays) 
                                                                                                                        || ', Total Weekdays: '|| TO_CHAR (V_WEEKDAYS)
                                                                                                                        || ', Total Saturdays: '|| TO_CHAR (V_SATURDAYS)
                                                                                                                        || ', Total Sundays: '|| TO_CHAR (V_sundays)
                                                                                                                        || ', Total Holidays: '|| To_Char (v_holidays));
	sp_output_mbta	(' 1. Section: '||To_Char (dDateFirst_1, 'YYYY-MM-DD-HH24-MI-SS')||', '||To_Char (dDateLast_1, 'YYYY-MM-DD-HH24-MI-SS')||', '||To_Char (nDays_1));
	sp_output_mbta	(' 2. Section: '||To_Char (dDateFirst_2, 'YYYY-MM-DD-HH24-MI-SS')||', '||To_Char (dDateLast_2, 'YYYY-MM-DD-HH24-MI-SS')||', '||To_Char (nDays_2));
	sp_output_mbta	(' 3. Section: '||To_Char (dDateFirst_3, 'YYYY-MM-DD-HH24-MI-SS')||', '||To_Char (dDateLast_3, 'YYYY-MM-DD-HH24-MI-SS')||', '||To_Char (nDays_3));
	sp_output_mbta	(' 4. Section: '||To_Char (dDateFirst_4, 'YYYY-MM-DD-HH24-MI-SS')||', '||To_Char (dDateLast_4, 'YYYY-MM-DD-HH24-MI-SS'));

--==============================================================================
--
--	Execute statement for 4 sections
--
--
--------------------------------------------------------------------------------

----------------
--
--	1. section
--
----------------

	cHint	:=	stmt_Hint_Complete_Full;										--	Assume full scan
	IF		(nDays	 <=	pnDays4SingleScan)
		OR
			(nDays_1 <= pnDays4SingleScan)
	THEN
		cHint	:=	stmt_Hint_Complete_Single;

--    print_c := stmt_main_single||'1a'|| ' ' ||ddatefirst_loop|| ' ' ||ddatelast_loop|| ' ' ||ddatefirst_loop|| ' ' ||dDateLast_1|| ' ' || ndays;
-- insert into ridership(reportnum,ssql) values(nReportId, print_c);
		EXECUTE	IMMEDIATE
			stmt_Main_Single
		USING
		  	nQueryID
          ,v_weekdays
          ,v_saturdays
          ,v_sundays
          ,v_holidays
          ,v_totaldays
			,ddatefirst_loop															--	date range
			,ddatelast_loop
			,ddatefirst_loop															--	partitioning date range
			,dDateLast_1
		,ddatefirst_loop	
		,ddatelast_loop        
		;
	ELSE
		cHint	:=	stmt_Hint_Complete_Full;
--    print_c := stmt_main_full||'1b'|| ' ' ||dDateFirst|| ' ' ||dDateLast|| ' ' ||dDateFirst|| ' ' ||dDateLast_1|| ' ' || ndays;
-- insert into ridership(reportnum,ssql) values(nReportId, print_c);
		EXECUTE	IMMEDIATE
			stmt_Main_Full
		USING
		  	nQueryID
          ,v_weekdays
          ,v_saturdays
          ,v_sundays
          ,v_holidays
          ,v_totaldays
			,ddatefirst_loop															--	date range
			,ddatelast_loop
			,ddatefirst_loop															--	partitioning date range
			,dDateLast_1
		,ddatefirst_loop	
		,ddatelast_loop        
		;
	END IF;
  
    sp_output_mbta	(' 1. Section: '||cHint||'  '||To_Char (dDateFirst_1, 'YYYY-MM-DD')||', '||To_Char (dDateLast_1, 'YYYY-MM-DD')||', '||To_Char (nDays_1));

	
COMMIT;
----------------
--
--	2. section
--
----------------

	IF	(nDays_2	>	0)	THEN												--	section contains days
		cHint	:=	stmt_Hint_Complete_Full;									--	2. section always full scan
    
--print_c := stmt_main_full||'2'|| ' ' ||dDateFirst|| ' ' ||dDateLast|| ' ' ||dDateFirst_2|| ' ' ||dDateLast_2|| ' ' || ndays;
--insert into ridership(reportnum,ssql) values(nReportId, print_c);
		sp_output_mbta	(' 2. Section: '||cHint||'  '||To_Char (dDateFirst_2, 'YYYY-MM-DD')||', '||To_Char (dDateLast_2, 'YYYY-MM-DD')||', '||To_Char (nDays_2));

		EXECUTE	IMMEDIATE
			stmt_Main_Full
		USING
			 nQueryID
          ,v_weekdays
          ,v_saturdays
          ,v_sundays
          ,v_holidays
          ,v_totaldays
			,ddatefirst_loop															--	date range
			,ddatelast_loop
			,dDateFirst_2														--	partitioning date range
			,dDateLast_2
		,ddatefirst_loop	
		,ddatelast_loop        
		;
   
	END IF;

COMMIT;
----------------
--
--	3. section
--
----------------
	IF	(nDays_3	>	0)	THEN												--	section contains days
		IF	(nDays_3	<=	pnDays4SingleScan)	THEN
			cHint	:=	stmt_Hint_Complete_Single;
      
--      print_c := stmt_main_single||'3a'|| ' ' ||dDateFirst|| ' ' ||dDateLast|| ' ' ||dDateFirst_3|| ' ' ||dDateLast_3|| ' ' || ndays;
--insert into ridership(reportnum,ssql) values(nReportId, print_c);

			EXECUTE	IMMEDIATE
				stmt_Main_Single
			USING
				 nQueryID
          ,v_weekdays
          ,v_saturdays
          ,v_sundays
          ,v_holidays
          ,v_totaldays
				,ddatefirst_loop														--	date range
				,ddatelast_loop
				,dDateFirst_3													--	partitioning date range
				,dDateLast_3
		,ddatefirst_loop	
		,ddatelast_loop          
			;
      
		ELSE
			cHint	:=	stmt_Hint_Complete_Full;								--	Assume full scan
--print_c := stmt_main_full || '3b'|| ' ' ||dDateFirst|| ' ' ||dDateLast|| ' ' ||dDateFirst_3|| ' ' ||dDateLast_3|| ' ' || ndays ;     
--insert into ridership(reportnum,ssql) values(nReportId, print_c); 

			EXECUTE	IMMEDIATE
				stmt_Main_Full
			USING
				 nQueryID
          ,v_weekdays
          ,v_saturdays
          ,v_sundays
          ,v_holidays
          ,v_totaldays
				,ddatefirst_loop														--	date range
				,ddatelast_loop
				,dDateFirst_3													--	partitioning date range
				,dDateLast_3
		    ,ddatefirst_loop	
		    ,ddatelast_loop          
			;
      
      
		END IF;
sp_output_mbta	(' 3. Section: '||cHint||'  '||To_Char (dDateFirst_3, 'YYYY-MM-DD')||', '||To_Char (dDateLast_3, 'YYYY-MM-DD')||', '||To_Char (nDays_3));
	END IF;

COMMIT;
----------------
--
--	4. section
--
----------------

	cHint	:=	stmt_Hint_Complete_Single;										--	4. section always single scan

	sp_output_mbta	(' 4. Section: '||cHint||'  '||To_Char (dDateFirst_4, 'YYYY-MM-DD')||', '||To_Char (dDateLast_4, 'YYYY-MM-DD'));
--print_c := stmt_main_single||'4'|| ' ' ||dDateFirst|| ' ' ||dDateLast|| ' ' ||dDateFirst_4|| ' ' ||dDateLast_4|| ' ' || ndays;
--insert into ridership(reportnum,ssql) values(nReportId, print_c);

	EXECUTE	IMMEDIATE
		stmt_Main_Single
	USING
		 nQueryID
          ,v_weekdays
          ,v_saturdays
          ,v_sundays
          ,v_holidays
          ,v_totaldays
		,ddatefirst_loop																--	date range
		,ddatelast_loop
		,dDateFirst_4															--	partitioning date range
		,dDateLast_4
		,ddatefirst_loop	
		,ddatelast_loop    
	;

	COMMIT;
  
  if ddatelast_loop = ddatelast
  then
    Exit;
else
  ddatefirst_loop := ddatelast_loop + 1/(24*60*60);
end if;

END loop;

EXCEPTION WHEN OTHERS
THEN
RAISE_APPLICATION_ERROR ( -20000, SQLERRM);

--==============================================================================
END;
/
 
