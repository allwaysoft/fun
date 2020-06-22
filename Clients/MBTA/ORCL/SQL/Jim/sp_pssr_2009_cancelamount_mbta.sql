create or replace
PROCEDURE        "SP_PSSR_2009_CANCELAMOUNT_MBTA" 
		(nQueryID 		  NUMBER
		,dDateFirst 	  DATE
		,dDateLast 		  DATE
		,pRoute 		    VARCHAR2
		,pStation 		  VARCHAR2
		,pDeviceGroup 	VARCHAR2
		,pDeviceClass 	VARCHAR2
		,pDevice 		    VARCHAR2
		,pProductType 	VARCHAR2
		)
IS
--------------------------------------------------------------------------------
-- Procedure: SP_PSSR_2009_CANCELAMOUNT_MBTA
--
-- Custom Version of Procedure SP_PSSR_2009_CANCELAMOUNT by S&B, any modifications done to the original SP_PSSR_2009_CANCELAMOUNT 
-- procedure after the below create date of this procedure should be changed in this procedure too. This procedure is for MBCR transactions only.
--
-- Creation :	11-30-2010  Kranthi Pabba
--
-- Purpose  :	Executes query for product sales summary report (MBCR Transactions only)
--
--
-- Input    :	nQueryID		ID to identify result set in table TempResult
--
--				dDateFirst		start date of query
--				dDateLast		end date of query
--
-- Output   : 	Results in TempResult
-- 			 	Data1	= RouteDesc
--				Data2	= StationDesc
--				Data3	= TicketsCount
--				Data4	= TicketTypeDesc
--				Data5	= TicketTypeID
--				Data6	= SumAmountsPerRecord w/o Token
--				Data7	= Credit/Debit Amount
--				Data8	= Check Amount
--				Data9	= Cash Amount
--				Data10	= Token Amount
--
--------------------------------------------------------------------------------
	vMail		VARCHAR2	(30000);
	dStart	DATE;
	dEnd		DATE;
	iRows		NUMBER		(10);
	nDays		NUMBER		(10);
	vCrLf		VARCHAR2	(10) 	:= Chr(13)||Chr(10);

	TYPE EmptyCursorTyp IS REF CURSOR;

	stmt_Main					  VARCHAR2	(30000);						-- Main statemenent
	stmt_HintMain				VARCHAR2	(  700);							-- Hint for main select
	stmt_HintClp				VARCHAR2	(  700);							  -- Hint	for	CashlessPayment subselect
	stmt_HintCp					VARCHAR2	(  700);							-- Hint for CashPayment subselect
	stmt_HintSd					VARCHAR2	(  700);							-- Hint for SalesDetail subselect
	stmt_HintSt					VARCHAR2	(  700);							-- Hint for SalesTransaction subselect

--------------------------------------------------------------------------------
--
--	statement presets
--
--------------------------------------------------------------------------------
	stmt_Insert					VARCHAR2	(  600) :=					-- First part of Insert statement
'INSERT INTO
	TempResult_MBTA
	(QueryID
	,LineId
 	,Data1		--	RouteDesc
	,Data2		--	StationDesc
	,number3		--	TicketsCount
	,Data4		--	TicketTypeDesc
	,number55		--	TicketTypeID

	,number6		--	SumAmountWoToken

	,number7		--	SumCreditAmount
	,number11		--	SumCancelAmount
	,number8		--	SumCheckAmount

	,number9		--	SumCashAmountWoToken

	,number10		--	SumTokenAmount
	)
';
--------------------------------------------------------------------------------
	stmt_Select					VARCHAR2	(30000) :=					-- Select statement
'SELECT
		/*+
%HintMain%
		*/
	:QueryID
	,1
	,rou.Description															RouteDesc
	,sta.NAME																	StationDesc
	,To_Char	(Sum	(Decode	(Decode	(mcm.MovementType
												,1		,1
												,2		,1
												,20		,1
												,null	,1
										,0
										)
									,1	,Decode	(sd.MachineBooking||'':''||sd.Cancellation
														,''0:0''	,1
														,''1:1''	,1
												,-1
												)
								,0
								)
						)
					-
				Sum		(Decode	(mcm.MovementType
									,6	,Decode	(sd.MachineBooking||'':''||sd.Cancellation
									 				,''0:0''	,1
									 				,''1:1''	,1
												,-1
												)
								,0
								)
						)
				)																TicketsCount
	,tte.Description															TicketTypeDesc
	,To_Char	(tte.TicketTypeID)												TicketTypeID
 	,To_Char	(Sum	(		(		st.SumCashAmountWoToken
									+	st.SumCreditAmount
									+	st.SumCheckAmount
									-	st.SumCancelAmount
								)
							*	sd.FareOptAmount
							/	st.SumFareOptAmount
						)
				)																SumAmountWoToken
	,To_Char	(Sum	(		st.SumCreditAmount
							*	sd.FareOptAmount
							/	st.SumFareOptAmount
						)
				)																CreditAmount
	,To_Char	(Sum	(		st.SumCancelAmount
							*	sd.FareOptAmount
							/	st.SumFareOptAmount
						)
				)																CancelAmount
	,To_Char	(Sum	(		st.SumCheckAmount
							*	sd.FareOptAmount
							/	st.SumFareOptAmount
						)
				)																CheckAmount

	,To_Char	(Sum	( 		(		st.SumCashAmountWoToken
									-	st.SumCancelAmount
								)
							*	sd.FareOptAmount
							/	st.SumFareOptAmount
						)
				)																CashAmountWoToken

 	,To_Char	(Sum	(		st.SumTokenAmount
							*	sd.FareOptAmount
							/	st.SumFareOptAmount
						)
				)																TokenAmount
FROM
	(
	----------------------------------------------------------------------------
 	--
	--	Subselect for Transactions
	--
	----------------------------------------------------------------------------
		SELECT
		/*+
%HintMain%
		*/
	 		 st.DeviceClassId
			,st.DeviceId
			,st.UniqueMsId
			,st.SalesTransactionNo
			,st.Partitioningdate
			,Nvl	(cp.SumCashAmount	-	cp.SumTokenAmount,	0)		SumCashAmountWoToken
 			,Nvl	(cp.SumTokenAmount,	0)								        SumTokenAmount
			,st.SnobAmount
			,Decode	(sd.SumFareOptAmount
						,0	,1													--	to avoid division by zero
					,sd.SumFareOptAmount
					)													              SumFareOptAmount

			,Nvl	(clp.SumCreditAmount,	0)							SumCreditAmount
			,Nvl	(clp.SumCheckAmount,	0)							SumCheckAmount
 			,Nvl	(clp.SumCancelAmount,	0)							SumCancelAmount
		FROM
			(
			--------------------------------------------------------------------
			--
			--	Subselect for SalesTransaction
			--
			--------------------------------------------------------------------
				SELECT
						/*+
%HintSt%
						*/
	 		 		 st.DeviceClassId
					,st.DeviceId
					,st.UniqueMsId
					,st.SalesTransactionNo
					,st.PartitioningDate
					,st.SnobAmount
				FROM
	 		 		 	SalesTransaction	st
 				WHERE	1 = 1

				--
				--	Filter conditions
				--

					AND st.TestSaleFlag				=	0
				-- MBCR Transactions Only
          AND (st.DEVICECLASSID, st.DEVICEID) in (select  tvm.DeviceClassID DeviceClassId, tvm.TVMID DeviceId
                                                                       from TVMTable					tvm
                                                                              ,Routes						rou
                                                                              ,TVMStation					sta
                                                                    where sta.StationID 	=	tvm.TVMTariffLocationID
                                                                       AND rou.RouteID	 =	tvm.RouteID
                                                                       AND (rou.routeid = 9996 and (sta.stationid in(1080,1009,1075)) or (rou.routeid = 1500))
                                                                     ) 
				-- MBCR Transactions Only
				--
				--	Parameter conditions
				--

					AND	st.CreaDate					>=	%pDateFirst%
					AND	st.CreaDate					<=	%pDateLast%
					AND	st.PartitioningDate			>=	%pDateFirst%

			--------------------------------------------------------------------
			)								st
			,
			(
			--------------------------------------------------------------------
			--
			--	Subselect for CashPayment of SalesTransaction
			--
			--------------------------------------------------------------------
				SELECT
						/*+
%HintCp%
						*/
	 		 		 cp.DeviceClassId
					,cp.DeviceId
					,cp.UniqueMsId
					,cp.SalesTransactionNo
					,cp.PartitioningDate
					,Sum	(Decode	(cp.ChangeFlag
										,1	, cp.PaymentTypeValue * NumberPieces
										,2	,-cp.PaymentTypeValue * NumberPieces
									,0
									)
							)											SumCashAmount
             		,Sum	(Decode	(cp.changeFlag || '':'' || cp.PaymentTypeID || '':'' || cp.PaymentTypeValue
										,''1:8:125''	, cp.paymentTypeValue * cp.NumberPieces
										,''2:8:125''	,-cp.paymentTypeValue * cp.NumberPieces
									,0
									)
							)											SumTokenAmount
				FROM
						CashPayment		cp

 				WHERE	1 = 1
				--
				--	Filter conditions
        --
				-- MBCR Transactions Only
          AND (cp.DEVICECLASSID, cp.DEVICEID) in (select  tvm.DeviceClassID DeviceClassId, tvm.TVMID DeviceId
                                                                       from TVMTable					tvm
                                                                              ,Routes						rou
                                                                              ,TVMStation					sta
                                                                    where sta.StationID 	=	tvm.TVMTariffLocationID
                                                                       AND rou.RouteID	 =	tvm.RouteID
                                                                       AND (rou.routeid = 9996 and (sta.stationid in(1080,1009,1075)) or (rou.routeid = 1500))
                                                                     ) 
				-- MBCR Transactions Only
        --
				--	Parameter conditions
				--

					AND	cp.CreaDate					>=	%pDateFirst%
					AND	cp.CreaDate					<=	%pDateLast%
					AND	cp.PartitioningDate			>=	%pDateFirst%

				GROUP	BY
	 		 		 cp.DeviceClassId
					,cp.DeviceId
					,cp.UniqueMsId
					,cp.SalesTransactionNo
					,cp.PartitioningDate
			--------------------------------------------------------------------
			)								cp
			,
			(
			--------------------------------------------------------------------
			--
			--	Subselect for SalesDetail of SalesTransaction
			--
			--------------------------------------------------------------------
				SELECT
						/*+
%HintSd%
						*/
	 		 		 sd.DeviceClassId
					,sd.DeviceId
					,sd.UniqueMsId
					,sd.SalesTransactionNo
					,sd.Partitioningdate
					,Abs(Sum(sd.FareOptAmount))				SumFareOptAmount
 				FROM
						SalesDetail					sd
 				WHERE	1 = 1
				--
				--	Filter conditions
				--
				-- MBCR Transactions Only
          AND (sd.DEVICECLASSID, sd.DEVICEID) in (select  tvm.DeviceClassID DeviceClassId, tvm.TVMID DeviceId
                                                                       from TVMTable					tvm
                                                                              ,Routes						rou
                                                                              ,TVMStation					sta
                                                                    where sta.StationID 	=	tvm.TVMTariffLocationID
                                                                       AND rou.RouteID	 =	tvm.RouteID
                                                                       AND (rou.routeid = 9996 and (sta.stationid in(1080,1009,1075)) or (rou.routeid = 1500))
                                                                     ) 
				-- MBCR Transactions Only
				--
				--	Parameter conditions
				--
					AND	sd.CreaDate					>=	%pDateFirst%
					AND	sd.CreaDate					<=	%pDateLast%
					AND	sd.PartitioningDate			>=	%pDateFirst%
				GROUP	BY
	 		 		 sd.DeviceClassId
					,sd.DeviceId
					,sd.UniqueMsId
					,sd.SalesTransactionNo
					,sd.PartitioningDate
			--------------------------------------------------------------------
			)								sd
			,
			(
			--------------------------------------------------------------------
			--
			--	Subselect for CashlessPayment of SalesTransaction
			--
			--------------------------------------------------------------------
				SELECT
						/*+
%HintClp%
						*/
	 		 		 clp.DeviceClassId
					,clp.DeviceId
					,clp.UniqueMsId
					,clp.SalesTransactionNo
					,clp.PartitioningDate
					,Sum	(Decode	(clp.PayTypeCashless
										,1	,clp.Amount
										,2	,clp.Amount
									,0
									)
							)															SumCreditAmount
					,Sum	(Decode	(clp.PayTypeCashless
										,4	,clp.Amount
									,0
									)
							)															SumCheckAmount
					,Sum	(Decode	(clp.PayTypeCashless
										,16	,clp.Amount
										,19	,clp.Amount
										,32	,clp.Amount
										,64	,clp.Amount
									,0
									)
							)															SumCancelAmount
				FROM
						CashlessPayment		clp

 				WHERE	1 = 1
				--
				--	Filter conditions
				--
					AND	clp.PayTypeCashless		IN	(1
													,2
													,4
													,16
													,19
													,32
													,64
													)
				-- MBCR Transactions Only
          AND (clp.DEVICECLASSID, clp.DEVICEID) in (select  tvm.DeviceClassID DeviceClassId, tvm.TVMID DeviceId
                                                                         from TVMTable					tvm
                                                                                ,Routes						rou
                                                                                ,TVMStation					sta
                                                                       where sta.StationID 	=	tvm.TVMTariffLocationID
                                                                          AND rou.RouteID	 =	tvm.RouteID
                                                                          AND (rou.routeid = 9996 and (sta.stationid in(1080,1009,1075)) or (rou.routeid = 1500))
                                                                       ) 
				-- MBCR Transactions Only
                          
				--
				--	Parameter conditions
				--

					AND	clp.CreaDate				>=	%pDateFirst%
					AND	clp.CreaDate				<=	%pDateLast%
					AND	clp.PartitioningDate		>=	%pDateFirst%

				GROUP	BY
	 		 		 clp.DeviceClassId
					,clp.DeviceId
					,clp.UniqueMsId
					,clp.SalesTransactionNo
					,clp.PartitioningDate
			--------------------------------------------------------------------
			)								clp
		WHERE	1 = 1

			AND	cp.DeviceClassId		(+)	=	st.DeviceClassId
			AND	cp.DeviceId				(+)	=	st.DeviceId
			AND	cp.UniqueMsId			(+)	=	st.UniqueMsId
			AND	cp.SalesTransactionNo	(+)	=	st.SalesTransactionNo
			AND	cp.PartitioningDate		(+)	=	st.PartitioningDate

			AND	sd.DeviceClassId			=	st.DeviceClassId
			AND	sd.DeviceId					=	st.DeviceId
			AND	sd.UniqueMsId				=	st.UniqueMsId
			AND	sd.SalesTransactionNo		=	st.SalesTransactionNo
			AND	sd.PartitioningDate			=	st.PartitioningDate

			AND	clp.DeviceClassId		(+)	=	st.DeviceClassId
			AND	clp.DeviceId			(+)	=	st.DeviceId
			AND	clp.UniqueMsId			(+)	=	st.UniqueMsId
			AND	clp.SalesTransactionNo	(+)	=	st.SalesTransactionNo
			AND	clp.PartitioningDate	(+)	=	st.PartitioningDate
	----------------------------------------------------------------------------
	)							st
	,SalesDetail 				sd
	,SalesDetail 				sub
	,MiscCardMovement			mcm
	,TicketType					tte
	,TVMTable					tvm
	,Routes						rou
	,TVMStation					sta
WHERE	1	=	1

--
--	Join conditions
--
	AND sd.DeviceClassID			=	st.DeviceClassID
	AND sd.DeviceID					=	st.DeviceID
	AND sd.UniquemsID				=	st.UniquemsID
	AND sd.SalesTransactionNo		=	st.SalesTransactionNo
	AND sd.PartitioningDate			=	st.PartitioningDate

-- MBCR Transactions Only
  AND (sd.DEVICECLASSID, sd.DEVICEID) in (select  tvm.DeviceClassID DeviceClassId, tvm.TVMID DeviceId
                                                                from TVMTable					tvm
                                                                       ,Routes						rou
                                                                       ,TVMStation					sta
                                                              where sta.StationID 	=	tvm.TVMTariffLocationID
                                                                 AND rou.RouteID	 =	tvm.RouteID
                                                                AND (rou.routeid = 9996 and (sta.stationid in(1080,1009,1075)) or (rou.routeid = 1500))
                                                              ) 
-- MBCR Transactions Only

	AND	sub.DeviceClassId   	(+)	=	sd.DeviceClassId
	AND	sub.DeviceId       		(+)	=	sd.DeviceId
	AND	sub.Uniquemsid     		(+)	=	sd.Uniquemsid
	AND	sub.SalestransactionNo	(+)	=	sd.SalesTransactionNo
	AND	sub.SalesDetailEvSequNo	(+)	=	sd.SalesDetailEvSequNo	+1
	AND	sub.CorrectionCounter	(+)	=	sd.CorrectionCounter
	AND	sub.PartitioningDate	(+)	=	sd.PartitioningDate

	AND	mcm.DeviceClassId   		=	sd.DeviceClassId
	AND	mcm.DeviceId	       		=	sd.DeviceId
	AND	mcm.Uniquemsid  	   		=	sd.Uniquemsid
	AND	mcm.SalestransactionNo		=	sd.SalesTransactionNo
	AND	mcm.SequenceNo				=	Decode	(sub.SalesDetailEvSequNo
													,NULL	,sd.SalesDetailEvSequNo
												,sub.SalesDetailEvSequNo
												)
	AND	mcm.CorrectionCounter		=	sd.CorrectionCounter
	AND	mcm.PartitioningDate		=	sd.PartitioningDate
	AND	mcm.TimeStamp				=	sd.CreaDate

	AND tte.TicketTypeID			=	sd.ArticleNo
	AND tte.VersionID				=	sd.TariffVersion

	AND tvm.DeviceClassID			= 	st.DeviceClassID
	AND tvm.TVMID					=	st.DeviceID

	AND sta.StationID				=	tvm.TVMTariffLocationID

	AND rou.RouteID					=	tvm.RouteID

--
--	Filter conditions
--

	AND mcm.MovementType			IN (  1
										, 2
										, 4					--	2008-04-17	ABU
										, 6					--	2008-04-17	ABU
										,16					--	2008-04-17	ABU
										,18					--	2008-04-17	ABU
										,20
										)

	AND sd.ArticleNo				NOT	IN	(605400100
											,607900100
											)
	AND sd.RealStatisticArticle		=	0
	AND sd.Tempbooking				=	0
	AND sd.CorrectionFlag			=	0

	AND sub.ArticleNo			(+)	=	607900100

--
--	Parameter conditions
--

	AND	sd.CreaDate					>=	%pDateFirst%
	AND	sd.CreaDate					<=	%pDateLast%
	AND	sd.PartitioningDate			>=	%pDateFirst%

';

	stmt_Select_Group					VARCHAR2	(  200)	:=							-- Group By clause
'GROUP	BY
	 rou.Description
	,sta.NAME
	,tte.Description
	,tte.TicketTypeID
';

--------------------------------------------------------------------------------
	exc_Test            		EXCEPTION;
--==============================================================================
--
--	Start procedure
--
--------------------------------------------------------------------------------
BEGIN
	DELETE tempQueryResult;
	COMMIT;

--------------------------------------------------------------------------------
--
--	Compose Statement
--
--------------------------------------------------------------------------------
--
--	Compose	Hints
--
--------------------------------------------------------------------------------

--	IF	dDateLast 		<=	   dDateFirst	+ 2	THEN							--	Only 2 Days, index range scan

		stmt_HintMain	:=
'             INDEX    (sd XPKSALESDETAIL)                           
'
		;

		stmt_HintClp	:=
'							INDEX    (clp XPKCASHLESSPAYMENT)
'
		;

		stmt_HintCp	:=
'							INDEX        (cp XPKCASHPAYMENT)
'
		;

		stmt_HintSd	:=
'							INDEX        (sd XPKSALESDETAIL)
'
		;

		stmt_HintSt	:=
'							INDEX    (st  XPKSALESTRANSACTION)
'
		;

/*
	ELSE																		--	more than 2 days, full table scan
		stmt_HintMain	:=
'			ORDERED
			FULL		(st)
			FULL		(mcm)
			FULL		(sd)
			INDEX		(sub	XIE1SalesDetail)
			USE_HASH	(sd)
			USE_HASH	(mcm)
			USE_HASH	(sub)
'
		;

		stmt_HintClp	:=
'							INDEX	(clp XPKCASHLESSPAYMENT)
'
		;

		stmt_HintCp	:=
'							INDEX		(cp XPKCASHPAYMENT)
'
		;

		stmt_HintSd	:=
'							INDEX		(sd XPKSALESDETAIL)
'
		;

		stmt_HintSt	:=
'							INDEX	(st, XPKSALESTRANSACTION)
'
		;
*/
--	END IF;

--------------------------------------------------------------------------------
--
--	Compose parameter
--
--------------------------------------------------------------------------------

	stmt_Select	:= 	stmt_Select
					||	SF_TRANSFORM_PARAM_2008	('tvm.TVMTariffLocationID'	,pStation)
					||	SF_TRANSFORM_PARAM_2008	('tvm.RouteID'				,pRoute)
					||	SF_TRANSFORM_PARAM_2008	('tvm.TVMGroupRef'			,pDeviceGroup)
					||	SF_TRANSFORM_PARAM_2008	('tvm.DeviceClassID'		,pDeviceClass)
					||	SF_TRANSFORM_PARAM_2008	('sd.ArticleNo'				,pProductType	,1)
					||	SF_TRANSFORM_PARAM_2008	('tvm.TVMID'				,pDevice)
					|| 	' '					
||	stmt_Select_Group
	;

	stmt_Main			:=		stmt_Insert
							||	stmt_Select
	;

	stmt_Main	:=	REPLACE	(stmt_Main
							,'%pDateFirst%'
							,'To_Date	(''' 	|| To_Char	(dDateFirst
														,'YYYY-MM-DD HH24-MI-SS'
														)
												|| ''',''YYYY-MM-DD HH24-MI-SS'')'
							)
	;
	stmt_Main	:=	REPLACE	(stmt_Main
							,'%pDateLast%'
							,'To_Date	(''' 	|| To_Char	(dDateLast
														,'YYYY-MM-DD HH24-MI-SS'
														)
												|| ''',''YYYY-MM-DD HH24-MI-SS'')'
							)
	;

	stmt_Main	:=	REPLACE	(stmt_Main,	'%HintMain%',	stmt_HintMain);
	stmt_Main	:=	REPLACE	(stmt_Main,	'%HintCp%',		stmt_HintCp);
	stmt_Main	:=	REPLACE	(stmt_Main,	'%HintClp%',	stmt_HintClp);
	stmt_Main	:=	REPLACE	(stmt_Main,	'%HintSd%',		stmt_HintSd);
	stmt_Main	:=	REPLACE	(stmt_Main,	'%HintSt%',		stmt_HintSt);


-------------------------------------------------------------------------------
	sp_Output	(stmt_Main);


	EXECUTE IMMEDIATE stmt_Main USING nQueryID;

	COMMIT;

--------------------------------------------------------------------------------
EXCEPTION
--	WHEN exc_Test THEN
--		sp_Output(vGetTables);
	WHEN Others THEN
		RAISE;

END;