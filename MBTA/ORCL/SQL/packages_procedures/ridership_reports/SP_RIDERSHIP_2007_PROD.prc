CREATE OR REPLACE PROCEDURE MBTA."SP_RIDERSHIP_2007_PROD" (nQueryID 		NUMBER
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
-- Procedure: SP_RiderShip_2007
-- Central procedure for ridership reports
--
-- Creation :	2007-11-15, A. Bujnoch
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
-- Changes	:	2008-04-09	ABU	Index hint to new index XIE8SalesDetail (CreaDate)
--
--				2008-04-10	ABU	Divided date range into 4 partitioned sections with
--								seperated execute statements
--
--				2008-06-05	ABU	Added Report 122
--
--				2008-09-24	ABU	Removed conditions with sd.CreaDate
--
--------------------------------------------------------------------------------


	vMail		VARCHAR2	(30000);
	dStart		DATE;
	dEnd		DATE;
	iRows		NUMBER		(10);
	nDays		NUMBER		(10);
	vCrLf		VARCHAR2	(10) 	:= Chr(13)||Chr(10);

	cHint						VARCHAR2	( 1000);							-- Hint: Full or single scan

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

	nDays_1						NUMBER;											-- Count of days 1. partitioning section
	nDays_2						NUMBER;											-- Count of days 2. partitioning section
	nDays_3						NUMBER;											-- Count of days 3. partitioning section

	TYPE EmptyCursorTyp IS REF CURSOR;

	stmt_Main_Full				VARCHAR2	(30000);							-- Main statemenent	full scan
	stmt_Main_Single			VARCHAR2	(30000);							-- Main statemenent	single scan
	stmt_Insert					VARCHAR2	(  600);							-- First part of Insert statement
	stmt_Select_Full			VARCHAR2	(20000);							-- Select statement full scan
	stmt_Select_Single			VARCHAR2	(20000);							-- Select statement	single scan
	stmt_Hint_Complete_Full		VARCHAR2	( 1000);							-- Complete hint: Full table scan
	stmt_Hint_Complete_Single	VARCHAR2	( 1000);							-- Complete hint: Single scan
	stmt_From					VARCHAR2	(  400);							-- From clause
	stmt_Group					VARCHAR2	(  200);							-- Group By clause
	stmt_Where					VARCHAR2	(20000);							-- Where clause

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
	TempResult
';
	stmt_Insert_List			VARCHAR2	(  500)	:=							-- Insert statement	column list
'	(QueryID
	,LineId
';
--------------------------------------------------------------------------------
	stmt_Select_Start			VARCHAR2	( 1000)	:=							-- Select statement start
'SELECT
';

	stmt_Select_List			VARCHAR2	( 5000)	:=							--	start of select column list
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
		USE_HASH	(sub)
		INDEX		(sub	XIE1SalesDetail)
		USE_HASH	(mcm)
		USE_HASH	(ms)
		USE_HASH	(sd)
		USE_HASH	(st)
		FULL		(mcm)
		FULL		(ms)
		FULL		(sd)
		FULL		(st)
';
	stmt_Hint_Single			VARCHAR2	(  500)	:=							--	Hint: Single scan
'		ORDERED
		USE_HASH	(sub)
		INDEX		(sub	XIE1SalesDetail)
		USE_NL		(mcm)
		USE_NL		(ms)
		USE_NL		(st)
		INDEX		(mcm	XIE5MiscCardMovement)
		INDEX		(sd		XIE8SalesDetail)
		INDEX		(st		XPKSalesTransaction)
		INDEX		(ms		XPKMainShift)
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

	AND	sd.DeviceID					= st.DeviceID
	AND	sd.DeviceClassID			= st.DeviceClassID
	AND	sd.UniqueMSID				= st.UniqueMSID
	AND	sd.SalesTransactionNo		= st.SalesTransactionNo
	AND	sd.PartitioningDate			= st.PartitioningDate
';

	stmt_Where_Parameter		VARCHAR2	( 1000)	:=							--	Default Parameter conditions
'--
--	Parameter conditions
--

	AND	sd.CreaDate			>= :dDateFirst
	AND	sd.CreaDate			<= :dDateLast
	AND	sd.PartitioningDate	>= :dPartitioningDateFirst
	AND	sd.PartitioningDate	<  :dPartitioningDateLast
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
	DELETE tempResult;
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
--	29	Ridership by Fareclass Summary - Subway
--
--------------------------------------------------------------------------------

	WHEN	nReportId	=	29 	THEN
--------
		stmt_Insert_List	:=	stmt_Insert_List	||
'	,Data31
	,Data32
	,Data5																		--	length (Data5) = 256
	,Data1
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
'	,rou.Description															--	Line
	,sta.NameShort																--	Station
	,cd.Text																	--	Fare
	,To_Char	(sum(decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1))	)
';
--------
		stmt_From_List	:=	stmt_From_List	||
'	,Mainshift				ms
	,Routes					rou
	,TVMTable				tvm
	,tvmStation				sta
	,CodeText				cd
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

	AND	rou.RouteID		(+)	=	ms.RouteNo

	AND	cd.id 			(+)	= 	6												-- FareClass
	AND	cd.code			(+)	= 	SubStr	(sd.articleno, 5, 3)

';
--------
		stmt_Where_Filter	:=	stmt_Where_Filter		||
'	AND	mcm.DeviceClassID		IN	(
										SELECT
											DeviceClassID
										FROM
											DeviceClass
										WHERE	DeviceClassType	IN	(4			--	Gates
																	,7			--	FVM / SC validator
																	)
									)
';
--------
		stmt_Group_List		:=	stmt_Group_List	||
'	 rou.Description
	,sta.NameShort
	,cd.Text
';
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--
--	30	Ridership by Producttype Summary - Subway
--
--------------------------------------------------------------------------------

	WHEN	nReportId	=	30 	THEN
--------
		stmt_Insert_List	:=	stmt_Insert_List	||
'	,Data31
	,Data32
	,Data5																		--	length (Data5) = 256
	,Data1
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
'	,rou.Description															--	Line
	,sta.NameShort																--	Station
	,tte.Description															--	Product
	,To_Char	(sum(decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1))	)
';
--------
		stmt_From_List	:=	stmt_From_List	||
'	,Mainshift				ms
	,Routes					rou
	,TVMTable				tvm
	,tvmStation				sta
	,TicketType				tte
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

	AND	rou.RouteID		(+)	=	ms.RouteNo

	AND	tte.TicketTypeId(+)	= 	sd.ArticleNo
	AND	tte.VersionId	(+)	=	sd.TariffVersion

';
--------
		stmt_Where_Filter	:=	stmt_Where_Filter		||
'	AND	mcm.DeviceClassID		IN	(
										SELECT
											DeviceClassID
										FROM
											DeviceClass
										WHERE	DeviceClassType	IN	(4			--	Gates
																	,7			--	FVM / SC validator
																	)
									)
';
--------
		stmt_Group_List		:=	stmt_Group_List	||
'	 rou.Description
	,sta.NameShort
	,tte.Description
';
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--
--	31	Ridership by Fareclass Summary - System wide
--
--------------------------------------------------------------------------------

	WHEN	nReportId	=	31 	THEN
--------
		stmt_Insert_List	:=	stmt_Insert_List	||
'	,Data5
	,Data1
	)
';
--------
		stmt_Select_List	:=	stmt_Select_List	||
'	,cd.Text																	--	Fare
	,To_Char	(sum(decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1))	)
';
--------
		stmt_From_List	:=	stmt_From_List	||
'	,CodeText				cd
';
--------
		stmt_Where_Join		:=	stmt_Where_Join		||
'	AND	cd.id 			(+)	= 	6												-- FareClass
	AND	cd.code			(+)	= 	SubStr	(sd.articleno, 5, 3)

';
--------
		stmt_Group_List		:=	stmt_Group_List	||
'	 cd.Text
';
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--
--	32	Ridership by Producttype Summary - System wide
--
--------------------------------------------------------------------------------

	WHEN	nReportId	=	32 	THEN
--------
		stmt_Insert_List	:=	stmt_Insert_List	||
'	,Data5																		--	length (Data5) = 256
	,Data1
	)
';
--------
		stmt_Select_List	:=	stmt_Select_List	||
'	,tte.Description															--	Product
	,To_Char	(sum(decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1))	)
';
--------
		stmt_From_List	:=	stmt_From_List	||
'	,TicketType				tte
';
--------
		stmt_Where_Join		:=	stmt_Where_Join		||
'	AND	tte.TicketTypeId(+)	= 	sd.ArticleNo
	AND	tte.VersionId	(+)	=	sd.TariffVersion

';
--------
		stmt_Group_List		:=	stmt_Group_List	||
'	 tte.Description
';
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--
--	33	Route Ridership by Garage and Producttype
--
--------------------------------------------------------------------------------

	WHEN	nReportId	=	33 	THEN
--------
		stmt_Insert_List	:=	stmt_Insert_List	||
'	,Data31
	,Data32
	,Data33
	,Data5																		--	length (Data5) = 256
	,Data1
	)
';
--------
		stmt_Hint_List	:=	stmt_Hint_List	||
'		USE_NL		(tvm)
		USE_NL		(sta)
';
--------
		stmt_Select_List	:=	stmt_Select_List	||
'	,To_Char	(Nvl	(sta.StationID,	0)	)
	,sta.Name
	,To_Char	(Nvl	(sd.BranchLineId, 0)	)
	,tte.Description															--	Product
	,To_Char	(sum(decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1))	)
';
--------
		stmt_From_List	:=	stmt_From_List	||
'	,TVMTable				tvm
	,tvmStation				sta
	,TicketType				tte
';
--------
		stmt_Where_Join		:=	stmt_Where_Join		||
'	AND	tvm.TVMID			=	st.DeviceID
	AND	tvm.DeviceClassID	=	st.DeviceClassID

	AND	sta.StationID 	(+)	=	tvm.TVMTariffLocationID

	AND	tte.TicketTypeId(+)	= 	sd.ArticleNo
	AND	tte.VersionId	(+)	=	sd.TariffVersion

';
--------
		stmt_Where_Filter	:=	stmt_Where_Filter		||
'	AND	sta.StationType	(+)	=	1

	AND	mcm.DeviceClassID		IN	(
										SELECT
											DeviceClassID
										FROM
											DeviceClass
										WHERE	DeviceClassType	IN	(5			--	Fareboxes
  																	)
									)
';
--------
		stmt_Group_List		:=	stmt_Group_List	||
'	 sd.BranchLineId
	,tte.Description
	,sta.StationID
	,sta.Name
';
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--
--	34	Route Ridership by Garage and Producttype Summary
--
--------------------------------------------------------------------------------

	WHEN	nReportId	=	34 	THEN
--------
		stmt_Insert_List	:=	stmt_Insert_List	||
'	,Data33
	,Data5																		--	length (Data5) = 256
	,Data1
	)
';
--------
		stmt_Hint_List	:=	stmt_Hint_List	||
'		USE_NL		(tvm)
		USE_NL		(sta)
';
--------
		stmt_Select_List	:=	stmt_Select_List	||
'	,To_Char	(Nvl	(sd.BranchLineId, 0)	)
	,tte.Description															--	Product
	,To_Char	(sum(decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1))	)
';
--------
		stmt_From_List	:=	stmt_From_List	||
'	,TVMTable				tvm
	,TicketType				tte
';
--------
		stmt_Where_Join		:=	stmt_Where_Join		||
'	AND	tvm.TVMID			=	st.DeviceID
	AND	tvm.DeviceClassID	=	st.DeviceClassID

	AND	tte.TicketTypeId(+)	= 	sd.ArticleNo
	AND	tte.VersionId	(+)	=	sd.TariffVersion

';
--------
		stmt_Where_Filter	:=	stmt_Where_Filter		||
'	AND	mcm.DeviceClassID		IN	(
										SELECT
											DeviceClassID
										FROM
											DeviceClass
										WHERE	DeviceClassType	IN	(5			--	Fareboxes
  																	)
									)
';
--------
		stmt_Group_List		:=	stmt_Group_List	||
'	 sd.BranchLineId
	,tte.Description
';
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--
--	35	Route Ridership by Garage and
--
--------------------------------------------------------------------------------

	WHEN	nReportId	=	35 	THEN
--------
		stmt_Insert_List	:=	stmt_Insert_List	||
'	,Data31
	,Data32
	,Data33
	,Data5																		--	length (Data5) = 256
	,Data1
	)
';
--------
		stmt_Hint_List	:=	stmt_Hint_List	||
'		USE_NL		(tvm)
		USE_NL		(sta)
';
--------
		stmt_Select_List	:=	stmt_Select_List	||
'	,To_Char	(Nvl	(sta.StationID,	0)	)
	,sta.Name
	,To_Char	(Nvl	(sd.BranchLineId, 0)	)
	,cd.Text																	--	FareClass
	,To_Char	(sum(decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1))	)
';
--------
		stmt_From_List	:=	stmt_From_List	||
'	,TVMTable				tvm
	,tvmStation				sta
	,CodeText				cd
';
--------
		stmt_Where_Join		:=	stmt_Where_Join		||
'	AND	tvm.TVMID			=	st.DeviceID
	AND	tvm.DeviceClassID	=	st.DeviceClassID

	AND	sta.StationID 	(+)	=	tvm.TVMTariffLocationID

	AND	cd.id 			(+)	= 	6												-- FareClass
	AND	cd.code			(+)	= 	SubStr	(sd.articleno, 5, 3)

';
--------
		stmt_Where_Filter	:=	stmt_Where_Filter		||
'	AND	sta.StationType	(+)	=	1

	AND	mcm.DeviceClassID		IN	(
										SELECT
											DeviceClassID
										FROM
											DeviceClass
										WHERE	DeviceClassType	IN	(5			--	Fareboxes
  																	)
									)
';
--------
		stmt_Group_List		:=	stmt_Group_List	||
'	 sd.BranchLineId
	,cd.Text
	,sta.StationID
	,sta.Name
';
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--
--	36	Route Ridership by Faretype Summary
--
--------------------------------------------------------------------------------

	WHEN	nReportId	=	36 	THEN
--------
		stmt_Insert_List	:=	stmt_Insert_List	||
'	,Data33
	,Data5																		--	length (Data5) = 256
	,Data1
	)
';
--------
		stmt_Hint_List	:=	stmt_Hint_List	||
'		USE_NL		(tvm)
';
--------
		stmt_Select_List	:=	stmt_Select_List	||
'	,To_Char	(Nvl	(sd.BranchLineId, 0)	)
	,cd.Text																	--	FareClass
	,To_Char	(sum(decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1))	)
';
--------
		stmt_From_List	:=	stmt_From_List	||
'	,TVMTable				tvm
	,CodeText				cd
';
--------
		stmt_Where_Join		:=	stmt_Where_Join		||
'	AND	tvm.TVMID			=	st.DeviceID
	AND	tvm.DeviceClassID	=	st.DeviceClassID

	AND	cd.id 			(+)	= 	6												-- FareClass
	AND	cd.code			(+)	= 	SubStr	(sd.articleno, 5, 3)

';
--------
		stmt_Where_Filter	:=	stmt_Where_Filter		||
'	AND	mcm.DeviceClassID		IN	(
										SELECT
											DeviceClassID
										FROM
											DeviceClass
										WHERE	DeviceClassType	IN	(5			--	Fareboxes
  																	)
									)
';
--------
		stmt_Group_List		:=	stmt_Group_List	||
'	 sd.BranchLineId
	,cd.Text
';
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--
--	37	Route Ridership by Garage and Time of Day
--
--------------------------------------------------------------------------------

	WHEN	nReportId	=	37 	THEN
--------
		stmt_Insert_List	:=	stmt_Insert_List	||
'	,Data31
	,Data32
	,Data1
	,Data2
	,Data3
	,Data4
	,Data5
	,Data6
	,Data7
	,Data8
	,Data9
	,Data10
	,Data11
	,Data12
	,Data13
	,Data14
	,Data15
	,Data16
	,Data17
	,Data18
	,Data19
	,Data20
	,Data21
	,Data22
	,Data23
	,Data24
	,Data25
	)
';
--------
		stmt_Hint_List	:=	stmt_Hint_List	||
'		USE_NL		(tvm)
		USE_NL		(sta)
';
--------
		stmt_Select_List	:=	stmt_Select_List	||
'	,sta.Name																	--	Station
	,To_Char	(Nvl	(sd.BranchLineId, 0)	)								--	Route
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''00'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''01'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''02'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''03'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''04'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''05'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''06'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''07'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''08'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''09'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''10'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''11'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''12'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''13'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''14'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''15'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''16'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''17'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''18'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''19'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''20'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''21'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''22'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''23'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1))	)
';
--------
		stmt_From_List	:=	stmt_From_List	||
'	,TVMTable				tvm
	,tvmStation				sta
';
--------
		stmt_Where_Join		:=	stmt_Where_Join		||
'	AND	tvm.TVMID			=	st.DeviceID
	AND	tvm.DeviceClassID	=	st.DeviceClassID

	AND	sta.StationID 	(+)	=	tvm.TVMTariffLocationID

';
--------
		stmt_Where_Filter	:=	stmt_Where_Filter		||
'	AND	mcm.DeviceClassID		IN	(
										SELECT
											DeviceClassID
										FROM
											DeviceClass
										WHERE	DeviceClassType	IN	(5			--	Fareboxes
  																	)
									)
';
--------
		stmt_Group_List		:=	stmt_Group_List	||
'	 sd.BranchLineId
	,sta.NAME
';

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--
--	38	Route Ridership by Time of Day
--
--------------------------------------------------------------------------------

	WHEN	nReportId	=	38 	THEN
--------
		stmt_Insert_List	:=	stmt_Insert_List	||
'	,Data31
	,Data1
	,Data2
	,Data3
	,Data4
	,Data5
	,Data6
	,Data7
	,Data8
	,Data9
	,Data10
	,Data11
	,Data12
	,Data13
	,Data14
	,Data15
	,Data16
	,Data17
	,Data18
	,Data19
	,Data20
	,Data21
	,Data22
	,Data23
	,Data24
	,Data25
	)
';
--------
		stmt_Hint_List	:=	stmt_Hint_List	||
'		USE_NL		(tvm)
';
--------
		stmt_Select_List	:=	stmt_Select_List	||
'	,To_Char	(Nvl	(sd.BranchLineId, 0)	)								--	Route
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''00'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''01'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''02'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''03'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''04'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''05'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''06'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''07'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''08'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''09'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''10'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''11'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''12'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''13'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''14'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''15'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''16'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''17'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''18'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''19'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''20'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''21'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''22'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''23'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1))	)
';
--------
		stmt_From_List	:=	stmt_From_List	||
'	,TVMTable				tvm
';
--------
		stmt_Where_Join		:=	stmt_Where_Join		||
'	AND	tvm.TVMID			=	st.DeviceID
	AND	tvm.DeviceClassID	=	st.DeviceClassID

';
--------
		stmt_Where_Filter	:=	stmt_Where_Filter		||
'	AND	mcm.DeviceClassID		IN	(
										SELECT
											DeviceClassID
										FROM
											DeviceClass
										WHERE	DeviceClassType	IN	(5			--	Fareboxes
  																	)
									)
';
--------
		stmt_Group_List		:=	stmt_Group_List	||
'	 sd.BranchLineId
';

--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
--
--	39	Time of Day Line
--
--------------------------------------------------------------------------------

	WHEN	nReportId	=	39 	THEN
--------
		stmt_Insert_List	:=	stmt_Insert_List	||
'	,Data31
	,Data32
	,Data1
	,Data2
	,Data3
	,Data4
	,Data5
	,Data6
	,Data7
	,Data8
	,Data9
	,Data10
	,Data11
	,Data12
	,Data13
	,Data14
	,Data15
	,Data16
	,Data17
	,Data18
	,Data19
	,Data20
	,Data21
	,Data22
	,Data23
	,Data24
	,Data25
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
'	,rou.Description															--	Line
	,sta.Name																	--	Station
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''00'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''01'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''02'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''03'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''04'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''05'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''06'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''07'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''08'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''09'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''10'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''11'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''12'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''13'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''14'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''15'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''16'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''17'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''18'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''19'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''20'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''21'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''22'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''23'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1))	)
';
--------
		stmt_From_List	:=	stmt_From_List	||
'	,Mainshift				ms
	,Routes					rou
	,TVMTable				tvm
	,tvmStation				sta
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

	AND	rou.RouteID		(+)	=	ms.RouteNo

';
--------
		stmt_Group_List		:=	stmt_Group_List	||
'	 rou.Description
	,sta.NAME
';

--------------------------------------------------------------------------------
--
--	40	Time of Day by Fare Class - Systemwide
--
--------------------------------------------------------------------------------

	WHEN	nReportId	=	40 	THEN
--------
		stmt_Insert_List	:=	stmt_Insert_List	||
'	,Data5
	,Data11
	,Data12
	,Data13
	,Data14
	,Data15
	,Data16
	,Data17
	,Data18
	,Data19
	,Data20
	,Data21
	,Data22
	,Data23
	,Data24
	,Data25
	,Data26
	,Data27
	,Data28
	,Data29
	,Data30
	,Data31
	,Data32
	,Data33
	,Data34
	,Data35
	)
';
--------
		stmt_Select_List	:=	stmt_Select_List	||
'	,cd.Text																	--	FareClass
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''00'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''01'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''02'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''03'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''04'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''05'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''06'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''07'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''08'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''09'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''10'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''11'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''12'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''13'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''14'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''15'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''16'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''17'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''18'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''19'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''20'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''21'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''22'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''23'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1))	)
';
--------
		stmt_From_List	:=	stmt_From_List	||
'	,CodeText				cd
';
--------
		stmt_Where_Join		:=	stmt_Where_Join		||
'	AND	cd.id 			(+)	= 	6												-- FareClass
	AND	cd.code			(+)	= 	SubStr	(sd.articleno, 5, 3)

';
--------
		stmt_Where_Filter	:=	stmt_Where_Filter		||
'	AND 	sd.ArticleNo   NOT  IN 	(105200000
									,105100000
									,1300
									)

';
--------
		stmt_Group_List		:=	stmt_Group_List	||
'	 cd.Text
';

--------------------------------------------------------------------------------
--
--	41	Time of Day by Product - Systemwide
--
--------------------------------------------------------------------------------

	WHEN	nReportId	=	41 	THEN
--------
		stmt_Insert_List	:=	stmt_Insert_List	||
'	,Data5
	,Data11
	,Data12
	,Data13
	,Data14
	,Data15
	,Data16
	,Data17
	,Data18
	,Data19
	,Data20
	,Data21
	,Data22
	,Data23
	,Data24
	,Data25
	,Data26
	,Data27
	,Data28
	,Data29
	,Data30
	,Data31
	,Data32
	,Data33
	,Data34
	,Data35
	)
';
--------
		stmt_Select_List	:=	stmt_Select_List	||
'	,tte.Description															--	Product
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''00'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''01'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''02'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''03'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''04'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''05'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''06'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''07'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''08'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''09'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''10'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''11'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''12'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''13'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''14'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''15'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''16'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''17'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''18'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''19'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''20'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''21'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''22'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''HH24''), ''23'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1))	)
';
--------
		stmt_From_List	:=	stmt_From_List	||
'	,TicketType				tte
';
--------
		stmt_Where_Join		:=	stmt_Where_Join		||
'	AND	tte.TicketTypeId(+)	= 	sd.ArticleNo
	AND	tte.VersionId	(+)	=	sd.TariffVersion

';
--------
		stmt_Where_Filter	:=	stmt_Where_Filter		||
'	AND 	sd.ArticleNo   NOT  IN 	(105200000
									,105100000
									,1300
									)

';
--------
		stmt_Group_List		:=	stmt_Group_List	||
'	tte.Description
';

--------------------------------------------------------------------------------
--
--	122	Route Ridership by Garage and Weekday
--
--------------------------------------------------------------------------------

	WHEN	nReportId	=	122 	THEN
--------
		stmt_Insert_List	:=	stmt_Insert_List	||
'	,Data31
	,Data32
	,Data1			--	day 1
	,Data2			--	day 2
	,Data3			--	day 3
	,Data4			--	day 4
	,Data5			--	day 5
	,Data6			--	day 6
	,Data7			--	day 7
	,Data8			--	total
	)
';
--------
		stmt_Hint_List	:=	stmt_Hint_List	||
'		USE_NL		(tvm)
		USE_NL		(sta)
';
--------
		stmt_Select_List	:=	stmt_Select_List	||
'	,sta.Name																	--	Station
	,To_Char	(Nvl	(sd.BranchLineId, 0)	)								--	Route
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''1'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''2'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''3'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''4'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''5'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''6'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''7'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1))	)
';
--------
		stmt_From_List	:=	stmt_From_List	||
'	,TVMTable				tvm
	,tvmStation				sta
';
--------
		stmt_Where_Join		:=	stmt_Where_Join		||
'	AND	tvm.TVMID			=	st.DeviceID
	AND	tvm.DeviceClassID	=	st.DeviceClassID

	AND	sta.StationID 	(+)	=	tvm.TVMTariffLocationID

';
--------
		stmt_Where_Filter	:=	stmt_Where_Filter		||
'	AND	mcm.DeviceClassID		IN	(
										SELECT
											DeviceClassID
										FROM
											DeviceClass
										WHERE	DeviceClassType	IN	(5			--	Fareboxes
  																	)
									)
';
--------
		stmt_Group_List		:=	stmt_Group_List	||
'	 sd.BranchLineId
	,sta.NAME
';

--------------------------------------------------------------------------------
--
--	123	Route Ridership by Garage and Service Type
--
--------------------------------------------------------------------------------

	WHEN	nReportId	=	123 	THEN
--------
		stmt_Insert_List	:=	stmt_Insert_List	||
'	,Data31
	,Data32
	,Data1			--	day 1 - day 5
	,Data6			--	day 6
	,Data7			--	day 7
	,Data8			--	total
	)
';
--------
		stmt_Hint_List	:=	stmt_Hint_List	||
'		USE_NL		(tvm)
		USE_NL		(sta)
';
--------
		stmt_Select_List	:=	stmt_Select_List	||
'	,sta.Name																	--	Station
	,To_Char	(Nvl	(sd.BranchLineId, 0)	)								--	Route
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''1'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))
		+		 sum(Decode(To_Char(sd.Creadate,''D''), ''2'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))
		+		 sum(Decode(To_Char(sd.Creadate,''D''), ''3'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))
		+		 sum(Decode(To_Char(sd.Creadate,''D''), ''4'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))
		+		 sum(Decode(To_Char(sd.Creadate,''D''), ''5'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''6'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''7'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1))	)
';
--------
		stmt_From_List	:=	stmt_From_List	||
'	,TVMTable				tvm
	,tvmStation				sta
';
--------
		stmt_Where_Join		:=	stmt_Where_Join		||
'	AND	tvm.TVMID			=	st.DeviceID
	AND	tvm.DeviceClassID	=	st.DeviceClassID

	AND	sta.StationID 	(+)	=	tvm.TVMTariffLocationID

';
--------
		stmt_Where_Filter	:=	stmt_Where_Filter		||
'	AND	mcm.DeviceClassID		IN	(
										SELECT
											DeviceClassID
										FROM
											DeviceClass
										WHERE	DeviceClassType	IN	(5			--	Fareboxes
  																	)
									)
';
--------
		stmt_Group_List		:=	stmt_Group_List	||
'	 sd.BranchLineId
	,sta.NAME
';

--------------------------------------------------------------------------------
--
--	124	Route Ridership by Weekday
--
--------------------------------------------------------------------------------

	WHEN	nReportId	=	124 	THEN
--------
		stmt_Insert_List	:=	stmt_Insert_List	||
'
	,Data32
	,Data1			--	day 1
	,Data2			--	day 2
	,Data3			--	day 3
	,Data4			--	day 4
	,Data5			--	day 5
	,Data6			--	day 6
	,Data7			--	day 7
	,Data8			--	total
	)
';
--------
		stmt_Select_List	:=	stmt_Select_List	||
'
	,To_Char	(Nvl	(sd.BranchLineId, 0)	)								--	Route
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''1'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''2'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''3'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''4'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''5'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''6'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''7'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1))	)
';
--------
		stmt_Where_Filter	:=	stmt_Where_Filter		||
'	AND	mcm.DeviceClassID		IN	(
										SELECT
											DeviceClassID
										FROM
											DeviceClass
										WHERE	DeviceClassType	IN	(5			--	Fareboxes
  																	)
									)
';
--------
		stmt_Group_List		:=	stmt_Group_List	||
'	 sd.BranchLineId
';

--------------------------------------------------------------------------------
--
--	125	Route Ridership by Garage and Service Type
--
--------------------------------------------------------------------------------

	WHEN	nReportId	=	125 	THEN
--------
		stmt_Insert_List	:=	stmt_Insert_List	||
'	,Data32
	,Data1			--	day 1 - day 5
	,Data6			--	day 6
	,Data7			--	day 7
	,Data8			--	total
	)
';
--------
		stmt_Select_List	:=	stmt_Select_List	||
'	,To_Char	(Nvl	(sd.BranchLineId, 0)	)								--	Route
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''1'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))
		+		 sum(Decode(To_Char(sd.Creadate,''D''), ''2'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))
		+		 sum(Decode(To_Char(sd.Creadate,''D''), ''3'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))
		+		 sum(Decode(To_Char(sd.Creadate,''D''), ''4'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))
		+		 sum(Decode(To_Char(sd.Creadate,''D''), ''5'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''6'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''7'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1))	)
';
--------
		stmt_Where_Filter	:=	stmt_Where_Filter		||
'	AND	mcm.DeviceClassID		IN	(
										SELECT
											DeviceClassID
										FROM
											DeviceClass
										WHERE	DeviceClassType	IN	(5			--	Fareboxes
  																	)
									)
';
--------
		stmt_Group_List		:=	stmt_Group_List	||
'	 sd.BranchLineId
';


--------------------------------------------------------------------------------
--
--	126	weekday Line
--
--------------------------------------------------------------------------------

	WHEN	nReportId	=	126 	THEN
--------
		stmt_Insert_List	:=	stmt_Insert_List	||
'	,Data31			--	Line
	,Data32			--	Station
	,Data1			--	day 1
	,Data2			--	day 2
	,Data3			--	day 3
	,Data4			--	day 4
	,Data5			--	day 5
	,Data6			--	day 6
	,Data7			--	day 7
	,Data8			--	total
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
'	,rou.Description															--	Line
	,sta.Name																	--	Station
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''1'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''2'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''3'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''4'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''5'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''6'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''7'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1))	)
';
--------
		stmt_From_List	:=	stmt_From_List	||
'	,Mainshift				ms
	,Routes					rou
	,TVMTable				tvm
	,tvmStation				sta
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

	AND	rou.RouteID		(+)	=	ms.RouteNo

';
--------
		stmt_Group_List		:=	stmt_Group_List	||
'	 rou.Description
	,sta.NAME
';

--------------------------------------------------------------------------------
--
--	127	Service Type Line
--
--------------------------------------------------------------------------------

	WHEN	nReportId	=	127 	THEN
--------
		stmt_Insert_List	:=	stmt_Insert_List	||
'	,Data31			--	Line
	,Data32			--	Station
	,Data1			--	day 1
	,Data6			--	day 6
	,Data7			--	day 7
	,Data8			--	total
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
'	,rou.Description															--	Line
	,sta.Name																	--	Station
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''1'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))
		+		 sum(Decode(To_Char(sd.Creadate,''D''), ''2'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))
		+		 sum(Decode(To_Char(sd.Creadate,''D''), ''3'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))
		+		 sum(Decode(To_Char(sd.Creadate,''D''), ''4'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))
		+		 sum(Decode(To_Char(sd.Creadate,''D''), ''5'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''6'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''7'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1))	)
';
--------
		stmt_From_List	:=	stmt_From_List	||
'	,Mainshift				ms
	,Routes					rou
	,TVMTable				tvm
	,tvmStation				sta
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

	AND	rou.RouteID		(+)	=	ms.RouteNo

';
--------
		stmt_Group_List		:=	stmt_Group_List	||
'	 rou.Description
	,sta.NAME
';

--------------------------------------------------------------------------------
--
--	128	Weekday by Fare Class
--
--------------------------------------------------------------------------------

	WHEN	nReportId	=	128 	THEN
--------
		stmt_Insert_List	:=	stmt_Insert_List	||
'	,Data5
	,Data11
	,Data12
	,Data13
	,Data14
	,Data15
	,Data16
	,Data17
	,Data18
	)
';
--------
		stmt_Select_List	:=	stmt_Select_List	||
'	,cd.Text																	--	FareClass
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''1'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''2'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''3'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''4'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''5'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''6'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''7'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1))	)

';
--------
		stmt_From_List	:=	stmt_From_List	||
'	,CodeText				cd
';
--------
		stmt_Where_Join		:=	stmt_Where_Join		||
'	AND	cd.id 			(+)	= 	6												-- FareClass
	AND	cd.code			(+)	= 	SubStr	(sd.articleno, 5, 3)

';
--------
		stmt_Where_Filter	:=	stmt_Where_Filter		||
'	AND 	sd.ArticleNo   NOT  IN 	(105200000
									,105100000
									,1300
									)

';
--------
		stmt_Group_List		:=	stmt_Group_List	||
'	 cd.Text
';

--------------------------------------------------------------------------------
--
--	129	Service Type by Fare Class
--
--------------------------------------------------------------------------------

	WHEN	nReportId	=	129 	THEN
--------
		stmt_Insert_List	:=	stmt_Insert_List	||
'	,Data5
	,Data11
	,Data16
	,Data17
	,Data18
	)
';
--------
		stmt_Select_List	:=	stmt_Select_List	||
'	,cd.Text																	--	FareClass
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''1'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))
		+		 sum(Decode(To_Char(sd.Creadate,''D''), ''2'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))
		+		 sum(Decode(To_Char(sd.Creadate,''D''), ''3'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))
		+		 sum(Decode(To_Char(sd.Creadate,''D''), ''4'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))
		+		 sum(Decode(To_Char(sd.Creadate,''D''), ''5'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''6'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''7'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1))	)

';
--------
		stmt_From_List	:=	stmt_From_List	||
'	,CodeText				cd
';
--------
		stmt_Where_Join		:=	stmt_Where_Join		||
'	AND	cd.id 			(+)	= 	6												-- FareClass
	AND	cd.code			(+)	= 	SubStr	(sd.articleno, 5, 3)

';
--------
		stmt_Where_Filter	:=	stmt_Where_Filter		||
'	AND 	sd.ArticleNo   NOT  IN 	(105200000
									,105100000
									,1300
									)

';
--------
		stmt_Group_List		:=	stmt_Group_List	||
'	 cd.Text
';

--------------------------------------------------------------------------------
--
--	130	Weekday by Product Type
--
--------------------------------------------------------------------------------

	WHEN	nReportId	=	130 	THEN
--------
		stmt_Insert_List	:=	stmt_Insert_List	||
'	,Data5
	,Data11
	,Data12
	,Data13
	,Data14
	,Data15
	,Data16
	,Data17
	,Data18
	)
';
--------
		stmt_Select_List	:=	stmt_Select_List	||
'	,tte.Description															--	Product
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''1'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''2'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''3'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''4'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''5'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''6'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''7'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1))	)

';
--------
		stmt_From_List	:=	stmt_From_List	||
'	,TicketType				tte
';
--------
		stmt_Where_Join		:=	stmt_Where_Join		||
'	AND	tte.TicketTypeId(+)	= 	sd.ArticleNo
	AND	tte.VersionId	(+)	=	sd.TariffVersion

';
--------
		stmt_Where_Filter	:=	stmt_Where_Filter		||
'	AND 	sd.ArticleNo   NOT  IN 	(105200000
									,105100000
									,1300
									)

';
--------
		stmt_Group_List		:=	stmt_Group_List	||
'	tte.Description
';

--------------------------------------------------------------------------------
--
--	131	Weekday by Product Type
--
--------------------------------------------------------------------------------

	WHEN	nReportId	=	131 	THEN
--------
		stmt_Insert_List	:=	stmt_Insert_List	||
'	,Data5
	,Data11
	,Data16
	,Data17
	,Data18
	)
';
--------
		stmt_Select_List	:=	stmt_Select_List	||
'	,tte.Description															--	Product
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''1'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))
		+		 sum(Decode(To_Char(sd.Creadate,''D''), ''2'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))
		+		 sum(Decode(To_Char(sd.Creadate,''D''), ''3'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))
		+		 sum(Decode(To_Char(sd.Creadate,''D''), ''4'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))
		+		 sum(Decode(To_Char(sd.Creadate,''D''), ''5'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''6'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(Decode(To_Char(sd.Creadate,''D''), ''7'', decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1), 0))	)
	,To_Char	(sum(decode(sd.Machinebooking||'':''||sd.Cancellation,''1:1'',1,''0:0'',1,-1))	)

';
--------
		stmt_From_List	:=	stmt_From_List	||
'	,TicketType				tte
';
--------
		stmt_Where_Join		:=	stmt_Where_Join		||
'	AND	tte.TicketTypeId(+)	= 	sd.ArticleNo
	AND	tte.VersionId	(+)	=	sd.TariffVersion

';
--------
		stmt_Where_Filter	:=	stmt_Where_Filter		||
'	AND 	sd.ArticleNo   NOT  IN 	(105200000
									,105100000
									,1300
									)

';
--------
		stmt_Group_List		:=	stmt_Group_List	||
'	tte.Description
';

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
';

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

	sp_Output	(stmt_Main_Full);
	sp_Output	(stmt_Main_Single);

--------------------------------------------------------------------------------
--
--	Divide time range into 4 partitioning sections
--	-	1. section:	partition containing dDateFirst
--	-	2. section:	partition(s) not containing dDateFirst nor dDatelast
--	-	3. section:	partition containing dDateLast
--	-	4. section:	partions not containing dDateLast with date > dDateLast
--
--------------------------------------------------------------------------------
																				--	1. section
	dDateFirst_1	:=	dDateFirst;
	dDateLast_1		:=	Trunc	(Last_Day (dDateFirst), 'DD') + 1;				-- 	First day of next month

																				--	2. section
	dDateFirst_2	:=	dDateLast_1;
	dDateLast_2		:=	Trunc	(dDateLast, 'MM');								--	First day of month containing dDateLast

																				--	3. section
	dDateFirst_3	:=	dDateLast_2;
	dDateLast_3		:=	Trunc	(Last_Day (dDateLast) +	1, 'MM');				--	First day of next month

																				--	4. section
	dDateFirst_4	:=	dDateLast_3;
	dDateLast_4		:=	To_Date	('9999-12-31 23-59-59','YYYY-MM-DD HH24-MI-SS');--	Max. date

--------------------

	nDays	:=	Ceil	(dDateLast   - dDateFirst  );							--	Count of all days
	nDays_1	:=	Ceil	(dDateLast_1 - dDateFirst_1);							--	count of days in 1. section
	nDays_2	:=	Ceil	(dDateLast_2 - dDateFirst_2);							--	count of days in 2. section

	IF		(	Trunc	(dDateFirst_1, 'MM')
			=	Trunc	(dDateFirst_3, 'MM')
			)	THEN															--	1. section contains 3. section
		nDays_3	:=	0;
	ELSE
		nDays_3	:=	Ceil	(dDateLast   - dDateFirst_3);						--	count of days in 3. section
	END IF;

--------------------------------------------------------------------------------

	sp_Output	(To_Char (dDateFirst, 'YYYY-MM-DD')||', '||To_Char (dDateLast, 'YYYY-MM-DD')||', '||To_Char (nDays));
	sp_Output	(' 1. Section: '||To_Char (dDateFirst_1, 'YYYY-MM-DD')||', '||To_Char (dDateLast_1, 'YYYY-MM-DD')||', '||To_Char (nDays_1));
	sp_Output	(' 2. Section: '||To_Char (dDateFirst_2, 'YYYY-MM-DD')||', '||To_Char (dDateLast_2, 'YYYY-MM-DD')||', '||To_Char (nDays_2));
	sp_Output	(' 3. Section: '||To_Char (dDateFirst_3, 'YYYY-MM-DD')||', '||To_Char (dDateLast_3, 'YYYY-MM-DD')||', '||To_Char (nDays_3));
	sp_Output	(' 4. Section: '||To_Char (dDateFirst_4, 'YYYY-MM-DD')||', '||To_Char (dDateLast_4, 'YYYY-MM-DD'));

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
  
		EXECUTE	IMMEDIATE
			stmt_Main_Single
		USING
		  	nQueryID
			,dDateFirst															--	date range
			,dDateLast
			,dDateFirst															--	partitioning date range
			,dDateLast_1
		;
	ELSE
		cHint	:=	stmt_Hint_Complete_Full;

		EXECUTE	IMMEDIATE
			stmt_Main_Full
		USING
		  	nQueryID
			,dDateFirst															--	date range
			,dDateLast
			,dDateFirst															--	partitioning date range
			,dDateLast_1
		;
	END IF;

	sp_Output	(' 1. Section: '||cHint||'  '||To_Char (dDateFirst_1, 'YYYY-MM-DD')||', '||To_Char (dDateLast_1, 'YYYY-MM-DD')||', '||To_Char (nDays_1));

----------------
--
--	2. section
--
----------------

	IF	(nDays_2	>	0)	THEN												--	section contains days
		cHint	:=	stmt_Hint_Complete_Full;									--	2. section always full scan

		sp_Output	(' 2. Section: '||cHint||'  '||To_Char (dDateFirst_2, 'YYYY-MM-DD')||', '||To_Char (dDateLast_2, 'YYYY-MM-DD')||', '||To_Char (nDays_2));

		EXECUTE	IMMEDIATE
			stmt_Main_Full
		USING
			 nQueryID
			,dDateFirst															--	date range
			,dDateLast
			,dDateFirst_2														--	partitioning date range
			,dDateLast_2
		;
	END IF;

----------------
--
--	3. section
--
----------------

	IF	(nDays_3	>	0)	THEN												--	section contains days
		IF	(nDays_3	<=	pnDays4SingleScan)	THEN
			cHint	:=	stmt_Hint_Complete_Single;
			EXECUTE	IMMEDIATE
				stmt_Main_Single
			USING
				 nQueryID
				,dDateFirst														--	date range
				,dDateLast
				,dDateFirst_3													--	partitioning date range
				,dDateLast_3
			;
		ELSE
			cHint	:=	stmt_Hint_Complete_Full;								--	Assume full scan
			EXECUTE	IMMEDIATE
				stmt_Main_Full
			USING
				 nQueryID
				,dDateFirst														--	date range
				,dDateLast
				,dDateFirst_3													--	partitioning date range
				,dDateLast_3
			;
		END IF;

		sp_Output	(' 3. Section: '||cHint||'  '||To_Char (dDateFirst_3, 'YYYY-MM-DD')||', '||To_Char (dDateLast_3, 'YYYY-MM-DD')||', '||To_Char (nDays_3));


	END IF;

----------------
--
--	4. section
--
----------------

	cHint	:=	stmt_Hint_Complete_Single;										--	4. section always single scan

	sp_Output	(' 4. Section: '||cHint||'  '||To_Char (dDateFirst_4, 'YYYY-MM-DD')||', '||To_Char (dDateLast_4, 'YYYY-MM-DD'));


	EXECUTE	IMMEDIATE
		stmt_Main_Single
	USING
		 nQueryID
		,dDateFirst																--	date range
		,dDateLast
		,dDateFirst_4															--	partitioning date range
		,dDateLast_4
	;

	dEnd := SYSDATE;
	COMMIT;

--==============================================================================

	SELECT Count(*) INTO iRows FROM tempResult WHERE queryid = nQueryID;
	vMail := vMail || 'Read Count Transactions and Tickets, duration: '||LPad(Trunc((dEnd - dStart) * 24),2,'0')||':'||LPad(Trunc((((dEnd - dStart) * 24) - (Trunc((dEnd - dStart) * 24))) * 60),2,'0')|| ' for ' ||To_Char(iRows) || ' Rows' || vCrLf;

	dStart := SYSDATE;
	iNum := 0;
	COMMIT;
--	sp_Output(To_Char(iNum));
	dEnd := SYSDATE;
--	send_mail('Database@MBTA.com','Bujnoch.Adalbert@Scheidt-Bachmann.de;','RiderShip Performance',vMail);

--EXCEPTION
--	WHEN exc_Test THEN
--		sp_Output(vGetTables);
--	WHEN Others THEN
--		vMail := vMail || vCrLf || SQLERRM || vCrLf;
--		dEnd := SYSDATE;
--		vMail := vMail || 'Overall duration: '||LPad(Trunc((dEnd - dStart) * 24),2,'0')||':'||LPad(Trunc((((dEnd - dStart) * 24) - (Trunc((dEnd - dStart) * 24))) * 60),2,'0')|| vCrLf;
----		send_mail('Database@MBTA.com','Bujnoch.Adalbert@Scheidt-Bachmann.de;','RiderShip Performance with an error',vMail);
--		RAISE;

END;
/

