CREATE OR REPLACE PROCEDURE sp_mvar_2013	(nQueryID 		NUMBER
					,dDateFirst   	DATE
					,dDateLast	   	DATE
					,vFarebox		    VARCHAR2
					,vGarage		    VARCHAR2
					,vEmployee 		  VARCHAR2
					,vReceiverVault VARCHAR2
					,vMobileVault	  VARCHAR2
					)
IS
--******************************************************************************
--	Changes
--
--	2008-02-21	ABU			Revised
--  2010-02-18  AS      device classes 502,503 considered
--  2010-04-20  AS      Duplicates removed.
--  2010-08-01  AS      Filter Criteria for Garages modified.
--------------------------------------------------------------------------------
--******************************************************************************
--
--	Declarations
--
--------------------------------------------------------------------------------
	sql_Main			VARCHAR2	(10000);

	sql_Main_Insert		VARCHAR2	( 2000) :=
'INSERT	INTO	TempQueryResult
	(LineID
	,QueryID
	,Data1			--	MobilVaultNo
	,Data2			--	GarageId
	,Data3			--	Garage
	,Data4			--	ReceiverVault
	,Data5			--	DateVaultInserted
	,Data6			--	DateVaultRemoved
	,Data7			--	CashboxSerNo
	,Data8		 	--	DateCashboxEmptied
	,Data9			--	AgentId
	,Data10			--	DeviceId
	,Data11			--	DeviceClassId
	,Data13			--	number of bypasses
				--	number of particular coins tokens, and bills
	,Data20			--	coins   1 cent
	,Data21			--	coins   5 cent
	,Data22			--	coins  10 cent
	,Data23			--	coins  25 cent
	,Data24			--	coins 100 cent
	,Data25			--	tokens
	,Data26			--	bills	1 dolar
	,Data27			--	bills	5 dolar
	,Data28			--	bills  10 dolar
	,Data29			--	bills  20 dolar
	,Data30			--	bills  50 dolar
	,Data31			--	bills 100 dolar
	,Data32			--	total
	,Data33			--	coins bypass
	,Data34			--	Percent coins
	,Data35			--	Percent bills
  ,Data36     --  ManCorrStatus
	)
';

	sql_Main1			    VARCHAR2	(10000);
	sql_Main_Insert1		VARCHAR2	( 2000):=
'INSERT	INTO	TempQueryResult
	(LineID
	,QueryID
	,Data1			--	MobilVaultNo
	,Data2			--	GarageId
	,Data3			--	Garage
	,Data4			--	ReceiverVault
	,Data5			--	DateVaultInserted
	,Data6			--	DateVaultRemoved
	,Data7			--	CashboxSerNo
	,Data8		 	--	DateCashboxEmptied
	,Data9			--	AgentId
	,Data10			--	DeviceId
	,Data11			--	DeviceClassId
	,Data13			--	number of bypasses
				--	number of particular coins tokens, and bills
	,Data20			--	coins   1 cent
	,Data21			--	coins   5 cent
	,Data22			--	coins  10 cent
	,Data23			--	coins  25 cent
	,Data24			--	coins 100 cent
	,Data25			--	tokens
	,Data26			--	bills	1 dolar
	,Data27			--	bills	5 dolar
	,Data28			--	bills  10 dolar
	,Data29			--	bills  20 dolar
	,Data30			--	bills  50 dolar
	,Data31			--	bills 100 dolar
	,Data32			--	total
	,Data33			--	coins bypass
	,Data34			--	Percent coins
	,Data35			--	Percent bills
  ,Data36     --  ManCorrStatus
	)
';

--------------------------------------------------------------------------------
	sql_Main_Select_01		VARCHAR2	(10000) :=
'SELECT
  		/*+
			Use_HASH	(se)
		*/
	 1
	,:P_QueryId
	,cb.MobVaultSerNo
	,cb.GarageId
	,cb.Garage
	,cb.ReceiverNo
  ,To_Char	(cb.MvInRecVaultDateTime,	''YYYY/MM/DD HH24:MI:SS'')
  ,To_Char	(cb.MvOutRecVaultDateTime,	''YYYY/MM/DD HH24:MI:SS'')
  ,cb.CashboxSerNo
	,To_Char	(cb.BoxInRecVaultDateTime,	''YYYY/MM/DD HH24:MI:SS'')
	,cb.ProbingUserID
	,cb.DeviceID
	,cb.DeviceClassID
    ,To_Char	(Sum	(Decode	(se.EventCode
									,46715	,1
								,0
								)
						)														-- ByPassOpen
				)
    ,cb.Coins1Cent
    ,cb.Coins5Cent
    ,cb.Coins10Cent
    ,cb.Coins25Cent
    ,cb.Coins1Dolar
    ,cb.Tokens125Cent
    ,cb.Bills1Bug
    ,cb.Bills5Bug
    ,cb.Bills10Bug
    ,cb.Bills20Bug
    ,cb.Bills50Bug
    ,cb.Bills100Bug
    ,cb.TotalRecRev
    ,cb.CoinsByPass
	  ,cb.Transp_No_Coins
	  ,cb.Transp_No_Bills
    ,cb.ManCorrStatus
FROM
	(
		SELECT
				/*+
					ORDERED
				*/
     		 cbmcb.DeviceClassID
    		,cbmcb.DeviceID
			  ,cbmcb.ProbingUserID
    		,cbmcb.BoxInRecVaultDateTime
    		,cbmcb.BoxOutRecVaultDateTime
    		,cbmcb.CashboxSerNo
			 ,(
				SELECT
						/*+
							INDEX_DESC	(sra	XPKSUMRECORDACTION)
						*/
					sra.CreaDate
				FROM
					SumRecordAction		sra
				WHERE	1 = 1
					AND	sra.DeviceClassId		  =	cbmcb.DeviceClassId
					AND	sra.DeviceId			    =	cbmcb.DeviceId
					AND	sra.ActionCode			  =	6
					AND	sra.MoneyContainerId	=	cbmcb.CashBoxSerNo
					AND	sra.CreaDate			   <=	cbmcb.BoxOutRecVaultDateTime + (5/86400)

					AND	ROWNUM	=	1
			)							MaxCreaDate

    		,sum(decode(cmd.PaymentType || ''-'' || cmd.PaymentTypeValue, ''1-1'', cmd.NumberPieces, 0)) 									Coins1Cent
    		,sum(decode(cmd.PaymentType || ''-'' || cmd.PaymentTypeValue, ''1-5'', cmd.NumberPieces, 0)) 									Coins5Cent
    		,sum(decode(cmd.PaymentType || ''-'' || cmd.PaymentTypeValue, ''1-10'', cmd.NumberPieces, 0)) 									Coins10Cent
    		,sum(decode(cmd.PaymentType || ''-'' || cmd.PaymentTypeValue, ''1-25'', cmd.NumberPieces, 0)) 									Coins25Cent
    		,sum(decode(cmd.PaymentType || ''-'' || cmd.PaymentTypeValue, ''1-100'', cmd.NumberPieces, 0)) 									Coins1Dolar
    		,sum(decode(cmd.PaymentType || ''-'' || cmd.PaymentTypeID || ''-'' || cmd.PaymentTypeValue, ''3-8-125'', cmd.NumberPieces, 0)) 	Tokens125Cent
    		,sum(decode(cmd.PaymentType || ''-'' || cmd.PaymentTypeValue, ''2-100'', cmd.NumberPieces, 0)) 									Bills1Bug
    		,sum(decode(cmd.PaymentType || ''-'' || cmd.PaymentTypeValue, ''2-500'', cmd.NumberPieces, 0)) 									Bills5Bug
    		,sum(decode(cmd.PaymentType || ''-'' || cmd.PaymentTypeValue, ''2-1000'', cmd.NumberPieces, 0)) 	    						Bills10Bug
    		,sum(decode(cmd.PaymentType || ''-'' || cmd.PaymentTypeValue, ''2-2000'', cmd.NumberPieces, 0)) 	    						Bills20Bug
    		,sum(decode(cmd.PaymentType || ''-'' || cmd.PaymentTypeValue, ''2-5000'', cmd.NumberPieces, 0)) 	    						Bills50Bug
    		,sum(decode(cmd.PaymentType || ''-'' || cmd.PaymentTypeValue, ''2-10000'', cmd.NumberPieces, 0))	    						Bills100Bug
    		,sum(decode(cmd.PaymentType || ''-'' || cmd.PaymentTypeValue, ''5-0'', cmd.NumberPieces, 0))         							CoinsByPass
    		,sum(decode(cmd.PaymentType || ''-'' || cmd.PaymentTypeValue,
            		''2-100'', cmd.NumberPieces * cmd.PaymentTypeValue,
            		''2-500'', cmd.NumberPieces * cmd.PaymentTypeValue,
            		''2-1000'', cmd.NumberPieces * cmd.PaymentTypeValue,
            		''2-2000'', cmd.NumberPieces * cmd.PaymentTypeValue,
            		''2-5000'', cmd.NumberPieces * cmd.PaymentTypeValue,
            		''2-10000'', cmd.NumberPieces * cmd.PaymentTypeValue,
            		''1-1'', cmd.NumberPieces * cmd.PaymentTypeValue,
            		''1-5'', cmd.NumberPieces * cmd.PaymentTypeValue,
            		''1-10'', cmd.NumberPieces * cmd.PaymentTypeValue,
            		''1-25'', cmd.NumberPieces * cmd.PaymentTypeValue,
            		''1-100'', cmd.NumberPieces * cmd.PaymentTypeValue,
            		''3-125'', cmd.NumberPieces * cmd.PaymentTypeValue, 0)) / 100		TotalRecRev

		---

			,cbmmv.MobVaultSerNo												  MobVaultSerNo
			,sc.LOCATIONID											          GarageID
			,sta.Name                                     Garage
			,cbmmv.ReceiverNo													    ReceiverNo
			,cbmmv.BoxInRecVaultDateTime									MvInRecVaultDateTime
			,Nvl	(cbmmv.BoxOutRecVaultDateTime
					,To_Date	(''3000'',''YYYY'')
					)															            MvOutRecVaultDateTime
			,cbmmv.Transp_No_Coins												Transp_No_Coins
			,cbmmv.Transp_No_Bills												Transp_No_Bills
      ,to_char(cbmcb.ManCorrStatus)                 ManCorrStatus
		FROM
			 CashBoxMovement				      cbmmv
      ,stationcontroller            sc
			,TVMStation						        sta
			,CashBoxMovement				      cbmcb
			,CashBoxMovementMoneyDetails	cmd
		WHERE	1	=	1
		--
		--	Join conditions
		--
      AND cbmcb.BoxInRecVaultDateTime    >= cbmmv.BoxInRecVaultDateTime
      AND cbmcb.BoxInRecVaultDateTime    <  Nvl	(cbmmv.BoxOutRecVaultDateTime,To_Date	(''3000'',''YYYY''))
      AND cbmcb.MobVaultSerNo           	= cbmmv.MobVaultSerNo
      AND	cbmcb.GcDeviceId				        =	cbmmv.GcDeviceId
      AND	cbmcb.ReceiverNo				        =	cbmmv.ReceiverNo
      AND cmd.SequenceParent       		    =	cbmcb.SEQUENCE

      AND	sc.DeviceClassID				        = cbmmv.GCDeviceClassID
      AND	sc.SCID						              = cbmmv.GCDeviceID
      AND	sta.StationID					          = sc.LocationID
		--
		--	Filter conditions
		--
			AND	cbmmv.MobVaultSerNo				    >	0
			AND	cbmmv.ManCorrStatus			        IN	(100,101)
			AND	cbmmv.BoxInRecVaultDateTime		<	cbmmv.BoxOutRecVaultDateTime
			AND	cbmcb.ManCorrStatus			      IN (1,2,3,4)
      AND cbmcb.DeviceClassId 			    IN (SELECT deviceclassid FROM deviceclass WHERE deviceclasstype = 5)  --Added 02.18.2010
		--
		--	Parameter conditions
		--
			AND	cbmmv.BoxInRecVaultDateTime		>=	:P_DateFirst
			AND	cbmmv.BoxInRecVaultDateTime		<=	:P_DateLast
';
--------------------------------------------------------------------------------
	sql_Main_Select_02		VARCHAR2	(10000) :=
'		GROUP	BY
	 		 cbmmv.MobVaultSerNo
			,sc.LOCATIONID
			,sta.NAME
			,cbmmv.ReceiverNo
			,cbmmv.BoxInRecVaultDateTime
			,Nvl	(cbmmv.BoxOutRecVaultDateTime
					,To_Date	(''3000'',''YYYY'')
					)
    ,cbmmv.Transp_No_Coins
    ,cbmmv.Transp_No_Bills
    ,cbmcb.CashboxSerNo
    ,cbmcb.DeviceClassID
    ,cbmcb.DeviceID
    ,cbmcb.ProbingUserID
    ,cbmcb.BoxInRecVaultDateTime
    ,cbmcb.BoxOutRecVaultDateTime
    ,to_char(cbmcb.ManCorrStatus)
	)								cb
	,(
		SELECT
  				/*+
					INDEX		  (se	XIE5ShiftEvent)
					NO_INDEX	(se	XIE1ShiftEvent)
					NO_INDEX	(se	XIE2ShiftEvent)
					NO_INDEX	(se	XIE4ShiftEvent)
					NO_INDEX	(se	XPKShiftEvent)
				*/
			se.DeviceClassId
			,se.DeviceId
			,se.CreaDate
			,se.EventCode
			,se.PartitioningDate
		FROM
			ShiftEvent				se
		WHERE	1	=	1
			AND	se.EventCode			IN	(46715			--	Bypass open
											)
	)								se
WHERE	1=1

--
--	Join conditions
--

    AND se.DeviceClassId(+)		 = 	cb.DeviceClassId
    AND se.DeviceId 		(+)		 = 	cb.DeviceId
	  AND	se.CreaDate 		(+)		<= 	cb.BoxInRecVaultDateTime		--	DateLast
	  AND	se.CreaDate 		(+)		>= 	cb.MaxCreaDate					    --	DateCashBoxIn

--
--	Filter conditions
--


--
--	Parameter conditions
--

--
--	Performance conditions
--

	AND	se.PartitioningDate	(+)		>= 	cb.MaxCreaDate


GROUP BY
      cb.DeviceClassID
      ,cb.DeviceID
      ,cb.ProbingUserID
      ,cb.BoxInRecVaultDateTime
      ,cb.CashboxSerNo
      ,cb.Coins1Cent
      ,cb.Coins5Cent
      ,cb.Coins10Cent
      ,cb.Coins25Cent
      ,cb.Coins1Dolar
      ,cb.Tokens125Cent
      ,cb.Bills1Bug
      ,cb.Bills5Bug
      ,cb.Bills10Bug
      ,cb.Bills20Bug
      ,cb.Bills50Bug
      ,cb.Bills100Bug
      ,cb.CoinsByPass
      ,cb.TotalRecRev
      ,cb.MobVaultSerNo
      ,cb.GarageID
      ,cb.Garage
      ,cb.ReceiverNo
      ,cb.MvInRecVaultDateTime
      ,cb.MvOutRecVaultDateTime
      ,cb.Transp_No_Coins
      ,cb.Transp_No_Bills
      ,cb.ManCorrStatus
'
;
----------------------------------------------------------------------------------------------------------------------------------------------------------------
	stmt_OtherContainer1		VARCHAR2(10000) :=
	--sql_Main_Select_01		VARCHAR2	(10000) :=
'SELECT
  		/*+
			Use_HASH	(se)
		*/
	 1
	,:P_QueryId
	,cb.MobVaultSerNo
	,cb.GarageId
	,cb.Garage
	,cb.ReceiverNo
  ,To_Char	(cb.MvInRecVaultDateTime,	''YYYY/MM/DD HH24:MI:SS'')
  ,To_Char	(cb.MvOutRecVaultDateTime,	''YYYY/MM/DD HH24:MI:SS'')
  ,cb.CashboxSerNo
	,To_Char	(cb.BoxInRecVaultDateTime,	''YYYY/MM/DD HH24:MI:SS'')
	,cb.ProbingUserID
	,cb.DeviceID
	,cb.DeviceClassID
    ,To_Char	(Sum	(Decode	(se.EventCode
									,46715	,1
								,0
								)
						)														-- ByPassOpen
				)
    ,cb.Coins1Cent
    ,cb.Coins5Cent
    ,cb.Coins10Cent
    ,cb.Coins25Cent
    ,cb.Coins1Dolar
    ,cb.Tokens125Cent
    ,cb.Bills1Bug
    ,cb.Bills5Bug
    ,cb.Bills10Bug
    ,cb.Bills20Bug
    ,cb.Bills50Bug
    ,cb.Bills100Bug
    ,cb.TotalRecRev
    ,cb.CoinsByPass
	  ,cb.Transp_No_Coins
	  ,cb.Transp_No_Bills
    ,cb.ManCorrStatus
FROM
	(
		SELECT
				/*+
					ORDERED
				*/
     		 cbmcb.DeviceClassID
    		,cbmcb.DeviceID
			  ,cbmcb.ProbingUserID
    		,cbmcb.BoxInRecVaultDateTime
    		,cbmcb.BoxOutRecVaultDateTime
    		,cbmcb.CashboxSerNo
			 ,(
				SELECT
						/*+
							INDEX_DESC	(sra	XPKSUMRECORDACTION)
						*/
					sra.CreaDate
				FROM
					SumRecordAction		sra
				WHERE	1 = 1
					AND	sra.DeviceClassId		  =	cbmcb.DeviceClassId
					AND	sra.DeviceId			    =	cbmcb.DeviceId
					AND	sra.ActionCode			  =	6
					AND	sra.MoneyContainerId	=	cbmcb.CashBoxSerNo
					AND	sra.CreaDate			   <=	cbmcb.BoxOutRecVaultDateTime + (5/86400)

					AND	ROWNUM	=	1
			)							MaxCreaDate

    		,sum(decode(cmd.PaymentType || ''-'' || cmd.PaymentTypeValue, ''1-1'', cmd.NumberPieces, 0)) 									Coins1Cent
    		,sum(decode(cmd.PaymentType || ''-'' || cmd.PaymentTypeValue, ''1-5'', cmd.NumberPieces, 0)) 									Coins5Cent
    		,sum(decode(cmd.PaymentType || ''-'' || cmd.PaymentTypeValue, ''1-10'', cmd.NumberPieces, 0)) 									Coins10Cent
    		,sum(decode(cmd.PaymentType || ''-'' || cmd.PaymentTypeValue, ''1-25'', cmd.NumberPieces, 0)) 									Coins25Cent
    		,sum(decode(cmd.PaymentType || ''-'' || cmd.PaymentTypeValue, ''1-100'', cmd.NumberPieces, 0)) 									Coins1Dolar
    		,sum(decode(cmd.PaymentType || ''-'' || cmd.PaymentTypeID || ''-'' || cmd.PaymentTypeValue, ''3-8-125'', cmd.NumberPieces, 0)) 	Tokens125Cent
    		,sum(decode(cmd.PaymentType || ''-'' || cmd.PaymentTypeValue, ''2-100'', cmd.NumberPieces, 0)) 									Bills1Bug
    		,sum(decode(cmd.PaymentType || ''-'' || cmd.PaymentTypeValue, ''2-500'', cmd.NumberPieces, 0)) 									Bills5Bug
    		,sum(decode(cmd.PaymentType || ''-'' || cmd.PaymentTypeValue, ''2-1000'', cmd.NumberPieces, 0)) 	    						Bills10Bug
    		,sum(decode(cmd.PaymentType || ''-'' || cmd.PaymentTypeValue, ''2-2000'', cmd.NumberPieces, 0)) 	    						Bills20Bug
    		,sum(decode(cmd.PaymentType || ''-'' || cmd.PaymentTypeValue, ''2-5000'', cmd.NumberPieces, 0)) 	    						Bills50Bug
    		,sum(decode(cmd.PaymentType || ''-'' || cmd.PaymentTypeValue, ''2-10000'', cmd.NumberPieces, 0))	    						Bills100Bug
    		,sum(decode(cmd.PaymentType || ''-'' || cmd.PaymentTypeValue, ''5-0'', cmd.NumberPieces, 0))         							CoinsByPass
    		,sum(decode(cmd.PaymentType || ''-'' || cmd.PaymentTypeValue,
            		''2-100'', cmd.NumberPieces * cmd.PaymentTypeValue,
            		''2-500'', cmd.NumberPieces * cmd.PaymentTypeValue,
            		''2-1000'', cmd.NumberPieces * cmd.PaymentTypeValue,
            		''2-2000'', cmd.NumberPieces * cmd.PaymentTypeValue,
            		''2-5000'', cmd.NumberPieces * cmd.PaymentTypeValue,
            		''2-10000'', cmd.NumberPieces * cmd.PaymentTypeValue,
            		''1-1'', cmd.NumberPieces * cmd.PaymentTypeValue,
            		''1-5'', cmd.NumberPieces * cmd.PaymentTypeValue,
            		''1-10'', cmd.NumberPieces * cmd.PaymentTypeValue,
            		''1-25'', cmd.NumberPieces * cmd.PaymentTypeValue,
            		''1-100'', cmd.NumberPieces * cmd.PaymentTypeValue,
            		''3-125'', cmd.NumberPieces * cmd.PaymentTypeValue, 0)) / 100		TotalRecRev

		---

			,cbmmv.MobVaultSerNo												  MobVaultSerNo
			,sc.LOCATIONID											          GarageID
			,sta.Name                                     Garage
			,cbmmv.ReceiverNo													    ReceiverNo
			,cbmmv.BoxInRecVaultDateTime									MvInRecVaultDateTime
			,Nvl	(cbmmv.BoxOutRecVaultDateTime
					,To_Date	(''3000'',''YYYY'')
					)															            MvOutRecVaultDateTime
			,cbmmv.Transp_No_Coins												Transp_No_Coins
			,cbmmv.Transp_No_Bills												Transp_No_Bills
      ,to_char(cbmcb.ManCorrStatus)                 ManCorrStatus
		FROM
			 CashBoxMovement				      cbmmv
      ,stationcontroller            sc
			,TVMStation						        sta
			,CashBoxMovement				      cbmcb
			,CashBoxMovementMoneyDetails	cmd
		WHERE	1	=	1
		--
		--	Join conditions
		--
      AND cbmcb.BoxInRecVaultDateTime    >= cbmmv.BoxInRecVaultDateTime
      AND cbmcb.BoxInRecVaultDateTime    <  Nvl	(cbmmv.BoxOutRecVaultDateTime,To_Date	(''3000'',''YYYY''))
      AND cbmcb.MobVaultSerNo           	= cbmmv.MobVaultSerNo
      AND	cbmcb.GcDeviceId				        =	cbmmv.GcDeviceId
      AND	cbmcb.ReceiverNo				        =	cbmmv.ReceiverNo
      AND cmd.SequenceParent       		(+) =	cbmcb.SEQUENCE

      AND	sc.DeviceClassID				        = cbmmv.GCDeviceClassID
      AND	sc.SCID						              = cbmmv.GCDeviceID
      AND	sta.StationID					          = sc.LocationID
		--
		--	Filter conditions
		--
			AND	cbmmv.MobVaultSerNo				    >	0
			AND	cbmmv.ManCorrStatus			        IN	(100,101)
			AND	cbmmv.BoxInRecVaultDateTime		<	cbmmv.BoxOutRecVaultDateTime
			AND	cbmcb.ManCorrStatus			      IN (3)--(1,2,3,4)
    --  AND cbmcb.DeviceClassId 			    IN (SELECT deviceclassid FROM deviceclass WHERE deviceclasstype = 5)  --Added 02.18.2010
		--
		--	Parameter conditions
		--
			AND	cbmmv.BoxInRecVaultDateTime		>=	:P_DateFirst
			AND	cbmmv.BoxInRecVaultDateTime		<=	:P_DateLast
';
--------------------------------------------------------------------------------
	stmt_OtherContainer2		VARCHAR2	(10000) :=
'		GROUP	BY
	 		 cbmmv.MobVaultSerNo
			,sc.LOCATIONID
			,sta.NAME
			,cbmmv.ReceiverNo
			,cbmmv.BoxInRecVaultDateTime
			,Nvl	(cbmmv.BoxOutRecVaultDateTime
					,To_Date	(''3000'',''YYYY'')
					)
    ,cbmmv.Transp_No_Coins
    ,cbmmv.Transp_No_Bills
    ,cbmcb.CashboxSerNo
    ,cbmcb.DeviceClassID
    ,cbmcb.DeviceID
    ,cbmcb.ProbingUserID
    ,cbmcb.BoxInRecVaultDateTime
    ,cbmcb.BoxOutRecVaultDateTime
    ,to_char(cbmcb.ManCorrStatus)
	)								cb
	,(
		SELECT
  				/*+
					INDEX		  (se	XIE5ShiftEvent)
					NO_INDEX	(se	XIE1ShiftEvent)
					NO_INDEX	(se	XIE2ShiftEvent)
					NO_INDEX	(se	XIE4ShiftEvent)
					NO_INDEX	(se	XPKShiftEvent)
				*/
			se.DeviceClassId
			,se.DeviceId
			,se.CreaDate
			,se.EventCode
			,se.PartitioningDate
		FROM
			ShiftEvent				se
		WHERE	1	=	1
			AND	se.EventCode			IN	(46715			--	Bypass open
											)
	)								se
WHERE	1=1

--
--	Join conditions
--

    AND se.DeviceClassId(+)		 = 	cb.DeviceClassId
    AND se.DeviceId 		(+)		 = 	cb.DeviceId
	  AND	se.CreaDate 		(+)		<= 	cb.BoxInRecVaultDateTime		--	DateLast
	  AND	se.CreaDate 		(+)		>= 	cb.MaxCreaDate					    --	DateCashBoxIn

--
--	Filter conditions
--


--
--	Parameter conditions
--

--
--	Performance conditions
--

	AND	se.PartitioningDate	(+)		>= 	cb.MaxCreaDate


GROUP BY
      cb.DeviceClassID
      ,cb.DeviceID
      ,cb.ProbingUserID
      ,cb.BoxInRecVaultDateTime
      ,cb.CashboxSerNo
      ,cb.Coins1Cent
      ,cb.Coins5Cent
      ,cb.Coins10Cent
      ,cb.Coins25Cent
      ,cb.Coins1Dolar
      ,cb.Tokens125Cent
      ,cb.Bills1Bug
      ,cb.Bills5Bug
      ,cb.Bills10Bug
      ,cb.Bills20Bug
      ,cb.Bills50Bug
      ,cb.Bills100Bug
      ,cb.CoinsByPass
      ,cb.TotalRecRev
      ,cb.MobVaultSerNo
      ,cb.GarageID
      ,cb.Garage
      ,cb.ReceiverNo
      ,cb.MvInRecVaultDateTime
      ,cb.MvOutRecVaultDateTime
      ,cb.Transp_No_Coins
      ,cb.Transp_No_Bills
      ,cb.ManCorrStatus
';
----------------------------------------------------------------------------------------------------------------------------------------------------------------
  exit_prog         EXCEPTION;
  PRAGMA exception_init(exit_prog,-20001);
--******************************************************************************
--
--	Start work
--
--******************************************************************************
BEGIN

	DELETE 		tempQueryResult;
	COMMIT;
-----------------------------------------
	sql_Main	:=		sql_Main_Insert
                ||sql_Main_Select_01
                ||SF_TRANSFORM_PARAM_2004	('sc.LocationID' ,vGarage)
                ||SF_TRANSFORM_PARAM_2004	('cbmmv.MobVaultSerNo' ,vMobileVault	,	1)
                ||SF_TRANSFORM_PARAM_2004	('cbmcb.DeviceId	'		 ,vFarebox		,	1)
                ||sql_Main_Select_02
                ;

	sp_Output	(sql_Main);

	sql_Main1	:=		sql_Main_Insert1
                ||stmt_OtherContainer1
                ||SF_TRANSFORM_PARAM_2004	('sc.LocationID' ,vGarage)
                ||SF_TRANSFORM_PARAM_2004	('cbmmv.MobVaultSerNo' ,vMobileVault	,	1)
                ||stmt_OtherContainer2
                ;

--		sql_Main1 := 	sql_Main_Insert1
--                  ||stmt_OtherContainer1||
--                    SF_TRANSFORM_PARAM_2004('sra.DeviceID', vFarebox) ||
--                    SF_TRANSFORM_PARAM_2004('sra.EmployeeNo', vEmployee) ||
--                  stmt_OtherContainer2  ||
--                    SF_TRANSFORM_PARAM_2004('sra.DeviceID', vFarebox) ||
--                    SF_TRANSFORM_PARAM_2004('sra.EmployeeNo', vEmployee) ||
--                  stmt_OtherContainerEnd;
-----------------------------------------
	EXECUTE	IMMEDIATE
		sql_Main	USING 	 nQueryID,dDateFirst,dDateLast
	;
	COMMIT;

		EXECUTE	IMMEDIATE
		sql_Main1	USING  nQueryID,dDateFirst,dDateLast;

--		EXECUTE	IMMEDIATE
--		sql_Main1	USING  nQueryID,dDateFirst,dDateFirst,dDateLast,dDateFirst,dDateFirst,dDateLast  ;

--	COMMIT;
--******************************************************************************
--
--	Execeptions
--
--******************************************************************************
EXCEPTION
	WHEN	exit_prog	THEN
		NULL;
	WHEN	OTHERS	THEN
    RAISE;
END;
/

