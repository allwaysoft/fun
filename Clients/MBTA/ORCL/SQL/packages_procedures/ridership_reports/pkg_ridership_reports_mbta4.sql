CREATE OR REPLACE package pkg_ridership_reports_mbta
AS
/*********************************************************************
** Name:    pkg_ridership_reports_mbta
**
** Author:  Kranthi Pabba                  Date:12/28/2010
** Description:
**
** Parameter Description:
**--------------------------------------------------------------------
** Modified By :
** Remarks:
** Modified By :
** Remarks:
** Modified By :
** Remarks:
*********************************************************************/
PROCEDURE "SP_RIDERSHIP_2007_MBTA" (nQueryID 		NUMBER
                                   ,nReportID		NUMBER
                                   ,dDateFirst 	DATE
                                   ,dDateLast 		DATE
                                   ,pLine 			VARCHAR2
                                   ,pStation 		VARCHAR2
                                   ,pGarageId		VARCHAR2
                                   ,pFareClassId	VARCHAR2
                                   ,pProductType	VARCHAR2
                                   ,pRouteId		VARCHAR2
                                   ,pwhere 		varchar2
                                    );

PROCEDURE "SP_DAY_OF_WEEK_RIDERSHIP_MBTA" (nQueryID 		NUMBER
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
                                    );

end pkg_ridership_reports_mbta;
/


CREATE OR REPLACE package body pkg_ridership_reports_mbta
AS
/*********************************************************************************************************************************************/
/*********************************************************************************************************************************************/

/*********************************************** BEGIN SP_RiderShip_2007_MBTA PROCEDURE **********************************************/

----------------------------------------------------------------------------------------
PROCEDURE        "SP_RIDERSHIP_2007_MBTA" (nQueryID 		NUMBER
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
-- Custom Version of Procedure SP_RiderShip_2007  by S and B, any modifications done to the original SP_RiderShip_2007 procedure
-- after the below create date of this procedure should be made in this procedure too.

-- Creation :	12/28/2010, Kranthi Pabba
--
-- Purpose  :	Executes query for ridership reports
--
--
-- Input    :	nQueryID		ID to identify result set in table TempResult
--
--				dDateFirst		start date of query
--				dDateLast		end date of query
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
    USE_HASH    (hol)
		PARALLEL	(sd  2)
    PARALLEL (sub 2)
		PARALLEL	(mcm  2)
		PARALLEL	(st  2)
    PARALLEL	(ms  2)
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
    USE_NL    (hol)
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
--	377	Route Ridership by Garage                          Type of Day Garage Summary
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
--	399	Time of Day Line Summary                                              Type of Day Line Summary
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
--	400	Subway Station Ridership Report                      Type and Time of Day Station Summary
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
--
--	401	Type and Time of Day Ridership by Signcode
--
--------------------------------------------------------------------------------

	WHEN	nReportId	=	401 	THEN
--------
		stmt_Insert_List	:=	stmt_Insert_List	||
'	,number2
	,Data31
  ,Data32
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
'		USE_NL		(tvm)
		USE_NL		(sta)
';
--------
		stmt_Select_List	:=	stmt_Select_List	||
'	,sta.stationid       --Station Id
	,sta.Name						 --	Station_Name
  ,nvl	(sd.BranchLineId, 0)							--	Route
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
'	,TVMTable				tvm
	,tvmStation				sta
  ,mbta_weekend_service   hol
';
--------
		stmt_Where_Join		:=	stmt_Where_Join		||
' AND tvm.TVMID			=	st.DeviceID
AND tvm.DeviceClassID	=	st.DeviceClassID

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
	AND	hol.service_date(+)			<= :dDateLast                                        --to_date(:dDateFirst, ''mm/dd/yyyy hh24:mi:ss'')
';
--------
		stmt_Group_List		:=	stmt_Group_List	||
'	sta.NAME, sta.stationid, Nvl(sd.BranchLineId, 0)
';

--------------------------------------------------------------------------------
--
--	500 BusRidershipByFareMediaType                       -- Rob Creedon
--
--------------------------------------------------------------------------------

	WHEN	nReportId	=	500 	THEN
--------
		stmt_Insert_List	:=	stmt_Insert_List	||
' ,number2
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
'		
';
--------
		stmt_Select_List	:=	stmt_Select_List	||
'	,nvl	(sd.BranchLineId, 0)						sign_code	--	Route

,nvl(Sum(case when sd.articleno in (102000100,102400400,102400500,102400600,102402500,102402700,102403300,202000100,600900100,
                                                  601200100,601300100,601400100,601500100,601600100,601700100,601800100,601900100,602600100,
                                                  602800100,602900100,603400500,603400600,603500500,603500600,603800100,603900100,605501200,
                                                  606000700,606000800,606000900,606001000,606001400,606002000,606002100,606002200,606002300,
                                                  606002800,606003000,606003100,606100500,606100600,606101600,606101700,606101800,606101900,
                                                  606300100,606301000,606302000,606302100,606302200,606302300,607000400,607100100,607100300,
                                                  607102700,608300100,609000100,609100100,609200100,609300100,609400100,609500100,609600100,
                                                  609700100,609800100,609900100,610000100,610100100,610200100,610300100,610400100,610500100,
                                                  610600100,610700100,610800100,610900100,611000100,611100100,611200100,611300100,611400400,
                                                  611500400,618000100,618100100,618200100,618300100,618500500,618500600,618700100,619000100,
                                                  619200100,620000100,620000400,620000500,620000600
                                                 )
                then
                  case when sd.ticketstocktype in (5,40)
                    then Decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1)  
                  end
              end),0) CC_riders
      
,nvl(Sum(case when sd.articleno in (102000100,102400400,102400500,102400600,102402500,102402700,102403300,202000100,600900100,601200100,601300100,601400100,
                                                  601500100,601600100,601700100,601800100,601900100,602600100,602800100,602900100,603400500,603400600,603500500,603500600,
                                                  603800100,603900100,608300100,609000100,609100100,609200100,609300100,609400100,609500100,609600100,609700100,609800100,
                                                  609900100,610000100,610100100,610200100,610300100,610400100,610500100,610600100,610700100,610800100,610900100,611000100,
                                                  611100100,611200100,611300100,618000100,618100100,618200100,618300100,618500500,618500600,618700100,619000100,619200100,
                                                  300100101,300100102,300100103,300100104,300100105,300100106,300100107,300100108,300100109,300100110,300101501,
                                                  300101502,300101503,300101504,300101505,300101506,300101507,300101508,300101509,300101510,300300101,300300102,300300103,
                                                  300300104,300300105,300300106,300300107,300300108,300301501,300301502,300301503,300301504,300301505,300301506,300301507,
                                                  300301508,300400101,300400102,300400103,300400104,300400105,300400106,300400107,300400108,300400109,300400110,300401501,
                                                  300401502,300401503,300401504,300401505,300401506,300401507,300401508,300401509,300401510,300700101,300700102,300700103,
                                                  300700104,300700105,300700106,300700107,300700108,300701501,300701502,300701503,300701504,300701505,300701506,300701507,
                                                  300701508,302100101,302100103,302100104,302100105,302100106,302100107,302100108,302100109,302100110,302200101,302200103,
                                                  302200104,302200105,302200106,302200107,302200108,302200109,302200110,302300101,302300102,302300103,302300104,302300105,
                                                  302300106,302300107,302300108,302300109,302300110,302500101,302500102,302500103,302500104,302500105,302500106,302500107,
                                                  302500108,303000101,303000102,303000103,303000104,303000105,303000106,303000107,303000108,303000109,303000110,303001501,
                                                  303001502,303001503,303001504,303001505,303001506,303001507,303001508,303001509,303001510,303100101,303100102,303100103,
                                                  303100104,303100105,303100106,303100107,303100108,303101501,303101502,303101503,303101504,303101505,303101506,303101507,
                                                  303101508,303200101,303200102,303200103,303200104,303200105,303200106,303200107,303200108,303200109,303200110,303300101,
                                                  303300102,303300103,303300104,303300105,303300106,303300107,303300108,303600101,303600102,303600103,303600104,303600105,
                                                  303600106,303600107,303600108,303700101,303700102,303700103,303700104,303700105,303700106,303700107,303700108,304101501,
                                                  304101502,304101503,304101504,304101505,304101506,304101507,304101508,304101509,304101510,304200101,304200102,304200103,
                                                  304200104,304200105,304200106,304200107,304200108,304200109,304200110,318400101,318400103,318400104,318400105,318400106,
                                                  318400107,318400108,318400109,318400110,318600101,318600102,318600103,318600104,318600105,318600106,318600107,318600108,
                                                  605400100,606200400,606200500,606202400,606202600
                                                  )
               then
                 case when sd.ticketstocktype in (1,2,4,6,254)
                   then Decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1) 
                 end 
            end),0)  Month_ticket_riders
      
,nvl(Sum(case when sd.articleno in (607000100,607000300,607200100,620000100,620000400,620000500, 620000600)
                then
                  case when sd.ticketstocktype not in (5,40)
                    then Decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1)  
                  end
              end),0) stored_value_magnetic_riders
             
,nvl(Sum(case when sd.articleno in (208000100,208000200,208000300,208000400,208000500,208000600,208000700,208000800,208000900,208001000,208001100)
               then Decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1)  
             end),0) Cash_riders         
      
,nvl(Sum(Decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1)),0)  total_riders

,:weekdays
,:saturdays
,:sundays
,:holidays
,:Totaldays
';
--------
		stmt_From_List	:=	stmt_From_List	||
'	
';
--------
		stmt_Where_Join		:=	stmt_Where_Join		||
'
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
';
--------
		stmt_Group_List		:=	stmt_Group_List	||
'	
Nvl(sd.BranchLineId, 0), :dDateFirst, :dDateLast           
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
' AND sd.sellingrrid <> 2 AND '||pWhere||' '
--'	AND	'||pWhere||'
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

loop                                                         -- Loop to divide the given date range in to 90 day ranges(approx 3 months) temp space

  if  ddatelast - ddatefirst_loop > 90
  then
  --ddatefirst_loop := ddatefirst;
  ddatelast_loop := ddatefirst_loop -1/(24*60*60) + 122;
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

/************************************************** END SP_RiderShip_2007_MBTA PROCEDURE *********************************************/


/************************************************** BEGIN SP_DAY_OF_WEEK_RIDERSHIP_MBTA PROCEDURE ********************************************/
PROCEDURE "SP_DAY_OF_WEEK_RIDERSHIP_MBTA"
                                   (nQueryID 		NUMBER
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
-- Procedure: SP_DAY_OF_WEEK_RIDERSHIP_MBTA
-- MBTA procedure for ridership reports
--
-- Creation :	12/28/2010, Kranthi Pabba
--
-- Purpose  :	Executes query for ridership reports
--
-- Any modifications made to the above SP_RiderShip_2007_MBTA  procedure should be applied to this if necessery
--
-- Input    :	nQueryID		ID to identify result set in table TempResult
--
--				dDateFirst		start date of query
--				dDateLast		end date of query
--
-- Return   : 	Results in TempResult
--
--------------------------------------------------------------------------------
--
-- Change:
--
--------------------------------------------------------------------------------

	vMail		VARCHAR2	(30000);
	dStart		DATE;
	dEnd		DATE;
	iRows		NUMBER		(10);

	nDays		NUMBER		(10);
  vnDays		NUMBER		(10);
	nDays_1						NUMBER(10);											-- Count of days 1. partitioning section
	nDays_2						NUMBER(10);											-- Count of days 2. partitioning section
	nDays_3						NUMBER(10);											-- Count of days 3. partitioning section


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


  v_holidays          NUMBER;                 -- Used for caliculating Holidays average ridership
  v_totaldays         NUMBER;                 -- Used for caliculating Total average ridership

	TYPE EmptyCursorTyp IS REF CURSOR;

	stmt_Main_Full				VARCHAR2	(32767);							-- Main statemenent	full scan
	stmt_Main_Single			VARCHAR2	(32767);							-- Main statemenent	single scan
  stmt_Hint_Complete_Full		VARCHAR2	( 1000);							-- Complete hint: Full table scan
	stmt_Hint_Complete_Single	VARCHAR2	( 1000);							-- Complete hint: Single scan

  stmt_insert    VARCHAR2	(32767);
  stmt_no_hint_select    VARCHAR2	(32767);
  stmt_select_single VARCHAR2	(32767);
  stmt_select_full VARCHAR2	(32767);
  stmt_from    VARCHAR2	(32767);
  stmt_where    VARCHAR2	(32767);
  stmt_group_by    VARCHAR2	(32767);
  
  
  print_c VARCHAR2	(30000);

 TYPE day_type is table of number index by binary_integer;
  day_of_week day_type;
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
	stmt_Hint_Start				VARCHAR2	(  200)	:=							--	Hint start
'	/*+
';
	stmt_Hint_List				VARCHAR2	(  200);							--	Hint list

	stmt_Hint_Full				VARCHAR2	(  500)	:=							--	Hint: Full table scan
'		ORDERED
		USE_HASH	(sub)
		INDEX		(sub	XIE1SalesDetail)
		USE_HASH	(mcm)
    USE_HASH	(ms)
		USE_HASH	(sd)
		USE_HASH	(st)
		PARALLEL	(mcm, 2)
    PARALLEL	(ms, 2)
		PARALLEL	(sd, 2)
    PARALLEL (sub 2)
		PARALLEL	(st, 2)
		FULL		(mcm)
    FULL		(ms)
		FULL		(sd)
		FULL		(st)
';
	stmt_Hint_Single			VARCHAR2	(  500)	:=							--	Hint: Single scan
'		ORDERED
		USE_HASH	(sub)
		USE_NL		(mcm)
		USE_NL		(st)    
		INDEX		(sub	 XIE1SalesDetail)
		INDEX		(mcm    XIE5MiscCardMovement)
		INDEX		(sd		XIE8SalesDetail)
		INDEX		(st 	  XPKSalesTransaction)
    INDEX		(ms 		XPKMainShift)
';
	stmt_Hint_End				VARCHAR2	(   10)	:=							--	Hint end
'	*/
';
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
--	402 	Day of Week Station Summary
--
--------------------------------------------------------------------------------
WHEN	nReportId	=	402 	THEN

stmt_hint_list := 
'USE_NL		(rou)
USE_NL		(tvm)
USE_NL		(sta)
';

  stmt_insert  :='
 INSERT INTO mbta_tempresult
	(QueryID
	,LineId
  ,number1
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


 ,number15              --Total_hrs Count

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
) 

';

stmt_no_hint_select :=
' SELECT
	/*HINT*/
	 :QueryID
	,1
	,rou.routeid         --Line Id
  ,sta.stationid       --Station Id
  ,rou.description    --  Line_Name
	,sta.Name						 --	Station_Name

,:totaldays
,:holidays
,:sundays
,:mondays
,:tuesdays
,:wednesdays
,:thursdays
,:fridays
,:saturdays

,decode(to_Char(sd.Creadate,''HH24''),''00'',decode(to_char(sd.creadate,''d'')-1,0,7,to_char(sd.creadate,''d'')-1)
                                                     ,''01'',decode(to_char(sd.creadate,''d'')-1,0,7,to_char(sd.creadate,''d'')-1)
                                                     ,''02'',decode(to_char(sd.creadate,''d'')-1,0,7,to_char(sd.creadate,''d'')-1)
                                                            ,to_char(sd.creadate,''d'')
          )                                                                                                             --day_of_week

,decode(to_Char(sd.Creadate,''HH24''),''00'',decode(to_char(sd.creadate,''ddd'')-1,0,to_char(trunc(sd.creadate,''yyyy'')-1,''ddd'') ,to_char(sd.creadate,''ddd'')-1)
                                                     ,''01'',decode(to_char(sd.creadate,''ddd'')-1,0,to_char(trunc(sd.creadate,''yyyy'')-1,''ddd'') ,to_char(sd.creadate,''ddd'')-1)
                                                     ,''02'',decode(to_char(sd.creadate,''ddd'')-1,0,to_char(trunc(sd.creadate,''yyyy'')-1,''ddd'') ,to_char(sd.creadate,''ddd'')-1)
                                                            ,to_char(sd.creadate,''ddd'')
          )                                                                                                             --day_of_year
,hol.service_day                                                                                                   --holiday_day_of_year


,nvl(sum(Decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1)),0) tot_hrs_count                            --Total_hrs Count

,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''00'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr00
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''01'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr01
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''02'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr02
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''03'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr03
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''04'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr04
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''05'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr05
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''06'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr06
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''07'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr07
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''08'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr08
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''09'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr09
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''10'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr10
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''11'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr11
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''12'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr12
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''13'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr13
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''14'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr14
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''15'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr15
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''16'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr16
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''17'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr17
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''18'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr18
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''19'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr19
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''20'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr20
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''21'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr21
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''22'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr22
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''23'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr23

';

stmt_from:= 
' FROM
	 SalesDetail			sd
	,SalesDetail			sub
	,MiscCardMovement		mcm
	,SalesTransaction		st
	,Mainshift				    ms
	,Routes					    rou
	,TVMTable				  tvm
	,tvmStation				sta
  ,(select trunc(service_date) service_date
            ,to_number(to_char(service_date,''ddd'')) service_day
            ,to_number(to_char(service_date,''yyyy'')) service_year
     from MBTA_WEEKEND_SERVICE
   where service_type = 1
       and To_Char(service_Date,''HH24'') = ''06''
     ) hol
     
';

stmt_where :=
' 
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

	AND	st.DeviceID = sd.DeviceID
	AND	st.DeviceClassID = sd.DeviceClassID
	AND	st.UniqueMSID = sd.UniqueMSID
	AND	st.SalesTransactionNo = sd.SalesTransactionNo
	AND	st.PartitioningDate = sd.PartitioningDate
	AND	ms.DeviceClassId	=	st.DeviceClassId
	AND	ms.DeviceId			=	st.DeviceId
	AND	ms.Uniquemsid		=	st.Uniquemsid
	AND	ms.EndCreaDate		=	st.PartitioningDate
	AND	tvm.TVMID			=	ms.DeviceID
	AND	tvm.DeviceClassID	=	ms.DeviceClassID
	AND	sta.StationID 	(+)	=	tvm.TVMTariffLocationID
	AND	rou.RouteID			=	ms.RouteNo  --outer join not necessary for this report

  AND    hol.service_day (+) = decode(to_Char(sd.Creadate,''HH24''),''00'',decode(to_number(to_char(sd.creadate,''ddd''))-1,0,to_number(to_char(trunc(sd.creadate,''yyyy'')-1,''ddd'')) ,to_number(to_char(sd.creadate,''ddd''))-1)
                                                     ,''01'',decode(to_number(to_char(sd.creadate,''ddd''))-1,0,to_number(to_char(trunc(sd.creadate,''yyyy'')-1,''ddd'')) ,to_number(to_char(sd.creadate,''ddd''))-1)
                                                     ,''02'',decode(to_number(to_char(sd.creadate,''ddd''))-1,0,to_number(to_char(trunc(sd.creadate,''yyyy'')-1,''ddd'')) ,to_number(to_char(sd.creadate,''ddd''))-1)
                                                            ,to_number(to_char(sd.creadate,''ddd'')))
  AND    hol.service_year (+)  = decode(to_Char(sd.Creadate,''HH24''),''00'',decode(to_number(to_char(sd.creadate,''ddd''))-1,0,to_number(to_char(sd.creadate, ''yyyy''))-1 ,to_number(to_char(sd.creadate, ''yyyy'')))
                                                     ,''01'',decode(to_number(to_char(sd.creadate,''ddd''))-1,0,to_number(to_char(sd.creadate, ''yyyy''))-1 ,to_number(to_char(sd.creadate, ''yyyy'')))
                                                     ,''02'',decode(to_number(to_char(sd.creadate,''ddd''))-1,0,to_number(to_char(sd.creadate, ''yyyy''))-1,to_number(to_char(sd.creadate, ''yyyy'')))
                                                            ,to_number(to_char(sd.creadate, ''yyyy'')))

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

  AND	rou.routeid in
  (
  1400,
  1200,
  1000,
  1300,
  1100
  )   -- Subway Stations Only
--
--	Parameter conditions
--

	AND	sd.CreaDate			>=      :dDateFirst                                             --to_date(:dDateFirst, ''mm/dd/yyyy hh24:mi:ss'')
	AND	sd.CreaDate			<=      :dDateLast
	AND	sd.PartitioningDate	>= :dPartitioningDateFirst
	AND	sd.PartitioningDate	<   :dPartitioningDateLast
  
  AND sd.sellingrrid <> 2
  
 ';
 
 stmt_group_by :=
'
 GROUP BY
   rou.routeid
  ,sta.NAME
  ,sta.stationid
  ,rou.description
 ,decode(to_Char(sd.Creadate,''HH24''),''00'',decode(to_char(sd.creadate,''d'')-1,0,7,to_char(sd.creadate,''d'')-1)
                                                        ,''01'',decode(to_char(sd.creadate,''d'')-1,0,7,to_char(sd.creadate,''d'')-1)
                                                        ,''02'',decode(to_char(sd.creadate,''d'')-1,0,7,to_char(sd.creadate,''d'')-1)
                                                              ,to_char(sd.creadate,''d'')
            )
  ,decode(to_Char(sd.Creadate,''HH24''),''00'',decode(to_char(sd.creadate,''ddd'')-1,0,to_char(trunc(sd.creadate,''yyyy'')-1,''ddd'') ,to_char(sd.creadate,''ddd'')-1)
                                                        ,''01'',decode(to_char(sd.creadate,''ddd'')-1,0,to_char(trunc(sd.creadate,''yyyy'')-1,''ddd'') ,to_char(sd.creadate,''ddd'')-1)
                                                        ,''02'',decode(to_char(sd.creadate,''ddd'')-1,0,to_char(trunc(sd.creadate,''yyyy'')-1,''ddd'') ,to_char(sd.creadate,''ddd'')-1)
                                                              ,to_char(sd.creadate,''ddd'')
             )
  ,hol.service_day
  
';
--------------------------------------------------------------------------------
--
--	403 	 Day of Week Ridership by SignCode
--
--------------------------------------------------------------------------------
WHEN	nReportId	=	403 	THEN

stmt_hint_list := 
'USE_NL		(rou)
USE_NL		(tvm)
USE_NL		(sta)
';

  stmt_insert  :='
 INSERT INTO mbta_tempresult
	(QueryID
	,LineId
  ,number1

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


 ,number15              --Total_hrs Count

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
) 

';

stmt_no_hint_select :=
' SELECT
	/*HINT*/
	 :QueryID
	,1
	,nvl	(sd.BranchLineId, 0)				--sign_code	

,:totaldays
,:holidays
,:sundays
,:mondays
,:tuesdays
,:wednesdays
,:thursdays
,:fridays
,:saturdays

,decode(to_Char(sd.Creadate,''HH24''),''00'',decode(to_char(sd.creadate,''d'')-1,0,7,to_char(sd.creadate,''d'')-1)
                                                     ,''01'',decode(to_char(sd.creadate,''d'')-1,0,7,to_char(sd.creadate,''d'')-1)
                                                     ,''02'',decode(to_char(sd.creadate,''d'')-1,0,7,to_char(sd.creadate,''d'')-1)
                                                            ,to_char(sd.creadate,''d'')
          )                                                                                                             --day_of_week

,decode(to_Char(sd.Creadate,''HH24''),''00'',decode(to_char(sd.creadate,''ddd'')-1,0,to_char(trunc(sd.creadate,''yyyy'')-1,''ddd'') ,to_char(sd.creadate,''ddd'')-1)
                                                     ,''01'',decode(to_char(sd.creadate,''ddd'')-1,0,to_char(trunc(sd.creadate,''yyyy'')-1,''ddd'') ,to_char(sd.creadate,''ddd'')-1)
                                                     ,''02'',decode(to_char(sd.creadate,''ddd'')-1,0,to_char(trunc(sd.creadate,''yyyy'')-1,''ddd'') ,to_char(sd.creadate,''ddd'')-1)
                                                            ,to_char(sd.creadate,''ddd'')
          )                                                                                                             --day_of_year
,hol.service_day                                                                                                   --holiday_day_of_year


,nvl(sum(Decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1)),0) tot_hrs_count                            --Total_hrs Count

,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''00'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr00
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''01'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr01
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''02'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr02
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''03'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr03
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''04'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr04
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''05'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr05
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''06'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr06
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''07'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr07
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''08'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr08
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''09'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr09
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''10'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr10
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''11'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr11
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''12'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr12
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''13'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr13
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''14'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr14
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''15'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr15
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''16'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr16
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''17'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr17
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''18'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr18
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''19'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr19
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''20'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr20
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''21'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr21
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''22'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr22
,nvl(sum(Decode(To_Char(sd.Creadate,''HH24''),''23'',decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1),0)),0) hr23

';

stmt_from:= 
' FROM
	 SalesDetail			sd
	,SalesDetail			sub
	,MiscCardMovement		mcm
	,SalesTransaction		st
  ,(select trunc(service_date) service_date
            ,to_number(to_char(service_date,''ddd'')) service_day
            ,to_number(to_char(service_date,''yyyy'')) service_year
     from MBTA_WEEKEND_SERVICE
   where service_type = 1
       and To_Char(service_Date,''HH24'') = ''06''
     ) hol
     
';

stmt_where :=
' 
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

	AND	st.DeviceID = sd.DeviceID
	AND	st.DeviceClassID = sd.DeviceClassID
	AND	st.UniqueMSID = sd.UniqueMSID
	AND	st.SalesTransactionNo = sd.SalesTransactionNo
	AND	st.PartitioningDate = sd.PartitioningDate

  AND    hol.service_day (+) = decode(to_Char(sd.Creadate,''HH24''),''00'',decode(to_number(to_char(sd.creadate,''ddd''))-1,0,to_number(to_char(trunc(sd.creadate,''yyyy'')-1,''ddd'')) ,to_number(to_char(sd.creadate,''ddd''))-1)
                                                     ,''01'',decode(to_number(to_char(sd.creadate,''ddd''))-1,0,to_number(to_char(trunc(sd.creadate,''yyyy'')-1,''ddd'')) ,to_number(to_char(sd.creadate,''ddd''))-1)
                                                     ,''02'',decode(to_number(to_char(sd.creadate,''ddd''))-1,0,to_number(to_char(trunc(sd.creadate,''yyyy'')-1,''ddd'')) ,to_number(to_char(sd.creadate,''ddd''))-1)
                                                            ,to_number(to_char(sd.creadate,''ddd'')))
  AND    hol.service_year (+)  = decode(to_Char(sd.Creadate,''HH24''),''00'',decode(to_number(to_char(sd.creadate,''ddd''))-1,0,to_number(to_char(sd.creadate, ''yyyy''))-1 ,to_number(to_char(sd.creadate, ''yyyy'')))
                                                     ,''01'',decode(to_number(to_char(sd.creadate,''ddd''))-1,0,to_number(to_char(sd.creadate, ''yyyy''))-1 ,to_number(to_char(sd.creadate, ''yyyy'')))
                                                     ,''02'',decode(to_number(to_char(sd.creadate,''ddd''))-1,0,to_number(to_char(sd.creadate, ''yyyy''))-1,to_number(to_char(sd.creadate, ''yyyy'')))
                                                            ,to_number(to_char(sd.creadate, ''yyyy'')))

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

	AND	sd.CreaDate			>=      :dDateFirst                                             --to_date(:dDateFirst, ''mm/dd/yyyy hh24:mi:ss'')
	AND	sd.CreaDate			<=      :dDateLast
	AND	sd.PartitioningDate	>= :dPartitioningDateFirst
	AND	sd.PartitioningDate	<   :dPartitioningDateLast
  
  AND sd.sellingrrid <> 2
  
 ';
 
 stmt_group_by :=
'
 GROUP BY
	nvl	(sd.BranchLineId, 0)				--sign_code	
 ,decode(to_Char(sd.Creadate,''HH24''),''00'',decode(to_char(sd.creadate,''d'')-1,0,7,to_char(sd.creadate,''d'')-1)
                                                        ,''01'',decode(to_char(sd.creadate,''d'')-1,0,7,to_char(sd.creadate,''d'')-1)
                                                        ,''02'',decode(to_char(sd.creadate,''d'')-1,0,7,to_char(sd.creadate,''d'')-1)
                                                              ,to_char(sd.creadate,''d'')
            )
  ,decode(to_Char(sd.Creadate,''HH24''),''00'',decode(to_char(sd.creadate,''ddd'')-1,0,to_char(trunc(sd.creadate,''yyyy'')-1,''ddd'') ,to_char(sd.creadate,''ddd'')-1)
                                                        ,''01'',decode(to_char(sd.creadate,''ddd'')-1,0,to_char(trunc(sd.creadate,''yyyy'')-1,''ddd'') ,to_char(sd.creadate,''ddd'')-1)
                                                        ,''02'',decode(to_char(sd.creadate,''ddd'')-1,0,to_char(trunc(sd.creadate,''yyyy'')-1,''ddd'') ,to_char(sd.creadate,''ddd'')-1)
                                                              ,to_char(sd.creadate,''ddd'')
             )
  ,hol.service_day
  
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

	stmt_Hint_Complete_Full	:=	stmt_Hint_Start
                                      || stmt_Hint_Full
                                      ||	stmt_Hint_List
                                      ||	stmt_Hint_End;

	stmt_Hint_Complete_Single	:= stmt_Hint_Start
                                          ||	stmt_Hint_Single
                                          ||	stmt_Hint_List
                                          ||	stmt_Hint_End;

  stmt_where := stmt_where || ' AND ' || pWhere||' ';

stmt_select_full := replace(stmt_no_hint_select,'/*HINT*/',stmt_Hint_Complete_Full);
stmt_select_single := replace(stmt_no_hint_select,'/*HINT*/',stmt_Hint_Complete_Single);

	stmt_Main_Full	:= stmt_Insert	
                        || stmt_select_full
                        || stmt_from
                        || stmt_where
                        || stmt_group_by;
                        
	stmt_Main_Single 	:= stmt_Insert	
                        || stmt_select_single
                        || stmt_from
                        || stmt_where
                        || stmt_group_by;
                        
--------

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

SELECT nvl(count(SERVICE_DATE),0)                                                                        --Count of Holidays
          , nvl(sum(decode(to_char(SERVICE_DATE,'d'),1,1,0)),0)                                 --Count of Sundays which are holidays
          , nvl(sum(decode(to_char(SERVICE_DATE,'d'),2,1,0)),0)                                 --Count of Mondays which are holidays
          , nvl(sum(decode(to_char(SERVICE_DATE,'d'),3,1,0)),0)                                 --Count of Tuesdays which are holidays
          , nvl(sum(decode(to_char(SERVICE_DATE,'d'),4,1,0)),0)                                 --Count of Wednesday which are holidays
          , nvl(sum(decode(to_char(SERVICE_DATE,'d'),5,1,0)),0)                                 --Count of Thursdays which are holidays
          , nvl(sum(decode(to_char(SERVICE_DATE,'d'),6,1,0)),0)                                 --Count of Fridays which are holidays
          , nvl(sum(decode(to_char(SERVICE_DATE,'d'),7,1,0)),0)                                 --Count of Saturdays which are holidays
into   v_holidays
      , day_of_week(1)
      , day_of_week(2)
      , day_of_week(3)
      , day_of_week(4)
      , day_of_week(5)
      , day_of_week(6)
      , day_of_week(7)
FROM (select trunc(service_date) service_date
            ,to_char(service_date,'ddd') service_day
            ,to_char(service_date,'yyyy')service_year
     from MBTA_WEEKEND_SERVICE
   where service_type = 1
       and To_Char(service_Date,'HH24') = '06'
     )    
WHERE 1=1
AND SERVICE_DATE(+) >= trunc(dDateFirst)
AND SERVICE_DATE(+) < trunc(dDateLast);     -- only less than here

select nvl(sum(decode(to_char(dDateFirst + rownum-1,'d'),1,1,0)),0)                    --Count of Sundays
       , nvl(sum(decode(to_char(dDateFirst + rownum-1,'d'),2,1,0)),0)
       , nvl(sum(decode(to_char(dDateFirst + rownum-1,'d'),3,1,0)),0)
       , nvl(sum(decode(to_char(dDateFirst + rownum-1,'d'),4,1,0)),0)
       , nvl(sum(decode(to_char(dDateFirst + rownum-1,'d'),5,1,0)),0)
       , nvl(sum(decode(to_char(dDateFirst + rownum-1,'d'),6,1,0)),0)
       , nvl(sum(decode(to_char(dDateFirst + rownum-1,'d'),7,1,0)),0)
into  day_of_week(8)
      ,day_of_week(9)
      ,day_of_week(10)
      ,day_of_week(11)
      ,day_of_week(12)
      ,day_of_week(13)
      ,day_of_week(14)
  from tvmtable
where rownum <= CEIL(dDateLast-dDateFirst);

day_of_week(1) := day_of_week(8)-day_of_week(1);
day_of_week(2) := day_of_week(9)-day_of_week(2);
day_of_week(3) := day_of_week(10)-day_of_week(3);
day_of_week(4) := day_of_week(11)-day_of_week(4);
day_of_week(5) := day_of_week(12)-day_of_week(5);
day_of_week(6) := day_of_week(13)-day_of_week(6);
day_of_week(7) := day_of_week(14)-day_of_week(7);

loop                                                         -- Loop to divide the given date range in to 122 day ranges(approx 6 months) temp space

  if  ddatelast - ddatefirst_loop > 90
  then
  --ddatefirst_loop := ddatefirst;
  ddatelast_loop := ddatefirst_loop -1/(24*60*60) + 90;
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
	dDateLast_4		:=	To_Date	('9999-12-31 23-59-59','YYYY-MM-DD HH24-MI-SS');           --	Max. date

--------------------


	nDays	:=	Ceil	(ddatelast_loop   - ddatefirst_loop  );			--	Count of all days in loop



	nDays_1	:=	Ceil	(dDateLast_1 - ddatefirst_1);							--	count of days in 1. section in loop


 	nDays_2	:=	Ceil	(dDateLast_2 - dDateFirst_2);							--	count of days in 2. section

	IF		(	Trunc	(dDateFirst_1, 'MM')
			=	Trunc	(dDateFirst_3, 'MM')
			)	THEN														                                   	--	1. section contains 3. section
		nDays_3	:=	0;
	ELSE

		nDays_3	:=	Ceil	(ddatelast_loop   - dDateFirst_3);			  --	count of days in 3. section
	END IF;

--------------------------------------------------------------------------------

	sp_output_mbta	(To_Char (ddatefirst_loop, 'YYYY-MM-DD-HH24-MI-SS')||', '||To_Char (ddatelast_loop, 'YYYY-MM-DD-HH24-MI-SS')|| ', Total days: '|| To_Char(v_totaldays)
                                                                                                                        || ', Total Holidays: '|| TO_CHAR (v_holidays)
                                                                                                                        || ', Total Sundays: '|| To_Char (day_of_week(1))
                                                                                                                        || ', Total Mondays: '|| TO_CHAR (day_of_week(2))
                                                                                                                        || ', Total Tuesdays: '|| TO_CHAR (day_of_week(3))
                                                                                                                        || ', Total Wednesdays: '|| TO_CHAR (day_of_week(4))
                                                                                                                        || ', Total Thursdays: '|| To_Char (day_of_week(5))
                                                                                                                        || ', Total Fridays: '|| To_Char (day_of_week(6))
                                                                                                                        || ', Total Saturdays: '|| To_Char (day_of_week(7)));
	sp_output_mbta	(' 1. Section: '||To_Char (dDateFirst_loop, 'YYYY-MM-DD-HH24-MI-SS')||', '||To_Char (dDateLast_1, 'YYYY-MM-DD-HH24-MI-SS')||', '||To_Char (nDays_1));
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

sp_output_mbta	('1');

		EXECUTE	IMMEDIATE
			stmt_Main_Single
		USING
		  	nQueryID
       ,v_totaldays
       ,v_holidays
       ,day_of_week(1)
       ,day_of_week(2)
       ,day_of_week(3)
       ,day_of_week(4)
       ,day_of_week(5)
       ,day_of_week(6)
       ,day_of_week(7)
   		 ,ddatefirst_loop															--	date range
 			 ,ddatelast_loop
 			 ,ddatefirst_loop															--	partitioning date range
 			 ,dDateLast_1
		;
 
 sp_output_mbta	('2');   
    
    sp_output_mbta	(' 1a. Section: '||cHint||'  '||To_Char (dDateFirst_1, 'YYYY-MM-DD')||', '||To_Char (dDateLast_1, 'YYYY-MM-DD')||', '||To_Char (nDays_1));    
    
	ELSE
		cHint	:=	stmt_Hint_Complete_Full;
--    print_c := stmt_main_full||'1b'|| ' ' ||dDateFirst|| ' ' ||dDateLast|| ' ' ||dDateFirst|| ' ' ||dDateLast_1|| ' ' || ndays;
-- insert into ridership(reportnum,ssql) values(nReportId, print_c);

		EXECUTE	IMMEDIATE
			stmt_Main_Full
		USING
		  	nQueryID
       ,v_totaldays
       ,v_holidays
       ,day_of_week(1)
       ,day_of_week(2)
       ,day_of_week(3)
       ,day_of_week(4)
       ,day_of_week(5)
       ,day_of_week(6)
       ,day_of_week(7)
			,ddatefirst_loop															--	date range
			,ddatelast_loop
			,ddatefirst_loop															--	partitioning date range
			,dDateLast_1
		;

    sp_output_mbta	(' 1b. Section: '||cHint||'  '||To_Char (dDateFirst_1, 'YYYY-MM-DD')||', '||To_Char (dDateLast_1, 'YYYY-MM-DD')||', '||To_Char (nDays_1));
    
	END IF;

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
       ,v_totaldays
       ,v_holidays
       ,day_of_week(1)
       ,day_of_week(2)
       ,day_of_week(3)
       ,day_of_week(4)
       ,day_of_week(5)
       ,day_of_week(6)
       ,day_of_week(7)
			,ddatefirst_loop															--	date range
			,ddatelast_loop
			,dDateFirst_2														--	partitioning date range
			,dDateLast_2
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
       ,v_totaldays
       ,v_holidays
       ,day_of_week(1)
       ,day_of_week(2)
       ,day_of_week(3)
       ,day_of_week(4)
       ,day_of_week(5)
       ,day_of_week(6)
       ,day_of_week(7)
				,ddatefirst_loop														--	date range
				,ddatelast_loop
				,dDateFirst_3													--	partitioning date range
				,dDateLast_3
			;

		ELSE
			cHint	:=	stmt_Hint_Complete_Full;								--	Assume full scan
--print_c := stmt_main_full || '3b'|| ' ' ||dDateFirst|| ' ' ||dDateLast|| ' ' ||dDateFirst_3|| ' ' ||dDateLast_3|| ' ' || ndays ;
--insert into ridership(reportnum,ssql) values(nReportId, print_c);

			EXECUTE	IMMEDIATE
				stmt_Main_Full
			USING
		  	nQueryID
       ,v_totaldays
       ,v_holidays
       ,day_of_week(1)
       ,day_of_week(2)
       ,day_of_week(3)
       ,day_of_week(4)
       ,day_of_week(5)
       ,day_of_week(6)
       ,day_of_week(7)
				,ddatefirst_loop														--	date range
				,ddatelast_loop
				,dDateFirst_3													--	partitioning date range
				,dDateLast_3
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
       ,v_totaldays
       ,v_holidays
       ,day_of_week(1)
       ,day_of_week(2)
       ,day_of_week(3)
       ,day_of_week(4)
       ,day_of_week(5)
       ,day_of_week(6)
       ,day_of_week(7)
		,ddatefirst_loop																--	date range
		,ddatelast_loop
		,dDateFirst_4															--	partitioning date range
		,dDateLast_4
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
RAISE_APPLICATION_ERROR ( -20001, SQLERRM);

end;
/************************************************** END SP_DAY_OF_WEEK_RIDERSHIP_MBTA PROCEDURE *********************************************/

/*********************************************************************************************************************************************/
/*********************************************************************************************************************************************/

end pkg_ridership_reports_mbta;
/
