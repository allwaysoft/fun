DROP PROCEDURE MBTA.SP_CHR_2004;

CREATE OR REPLACE PROCEDURE MBTA.sp_chr_2004		(nQueryID 			NUMBER
					,dDateFirst 		DATE
					,dDateLast 			DATE
					,dDateFirstPulled	DATE
					,dDateLastPulled	DATE
					,vBusNo 			VARCHAR2
					,vCashbox 			VARCHAR2
					,vEmployee 			VARCHAR2
					,vFareboxFrom 		VARCHAR2
					,vFareboxInto		VARCHAR2
					,vGarage 			VARCHAR2
					,vMobileVault 		VARCHAR2
					,vReceiverVault 	VARCHAR2
					)
IS
--******************************************************************************
--
--	Changes
--
--	2008-02-21	ABU			Revised
--
--	2008-03-14	ABU			Added time filter BoxInRecVaultDateTime to get insertion
--							into mobil vault, if BoxRemDateTime is NULL
--							Removed filter for RemDeviceClassID to get insertion
--							into mobil vault, if RemDeviceClassID is NULL
--
--	2008-04-08	ABU			Combined cashbox removal from farebox (SumrecordAction)
--							with emptying into mobil vault (CashBoxMovement)
--
--	2008-10-24	ABU			Specified join between SumRecordAction und MoneyContainerContensum.
--							This correction has no influence, because the missing join condition
--							is present in the Decode statement
--
--
--------------------------------------------------------------------------------


--******************************************************************************
--
--	Declarations
--
--------------------------------------------------------------------------------
	sql_Main			VARCHAR2	(11000);


	sql_Main_Insert		VARCHAR2	( 1000) :=
'INSERT	INTO	TempQueryResult
	(LineID
	,QueryID
	,Data1		--	EmployeeId
	,Data2		--	CashboxNo
	,Data3		--	BusNo
  	,Data4		--	Garage
	,Data5		--	FareboxRemoved
	,Data6		--	FareboxInserted
	,Data7		--	MobVaultSerNo
	,Data8		--	ReceiverNo
	,Data9		--	DateTimeRemoved
	,Data10		--	DateTimeInserted
	,Data11		--	DeviceClassId
	,Data12		--	Coins1Cent
	,Data13		--	Coins5Cent
	,Data14		--	Coins10Cent
	,Data15		--	Coins25Cent
	,Data16		--	Coins1Dolar
	,Data17		--	Tokens
	,Data18		--	Bills1Dolar
	,Data26		--	Bills2Dolar
	,Data19		--	Bills5Dolar
	,Data20		--	Bills10Dolar
	,Data21		--	Bills20Dolar
	,Data22		--	Bills50Dolar
	,Data23		--	Bills100Dolar
	,Data24		--	Total
	,Data25		--	0
	,Data27		--	StationId
	,Data30		--	TableAlias
	)
'
;
--------------------------------------------------------------------------------
	sql_Main_Select_cbm01		VARCHAR2	(6000) :=
'SELECT
	 1
	,:P_QueryId
	,To_Char	(cbm.ProbingUserID)      										EmployeeID
	,To_Char	(cbm.CashBoxSerNo)      										CashboxNo
	,To_Char	(cbm.RemDeviceID)       										BusNo
	,sta.Name				       												Garage
	,To_Char	(cbm.RemDeviceID)    											FareboxRemoved
	,(
		SELECT
				/*
					INDEX	(se	XIE3SHIFTEVENT)
				*/
			To_Char	(se.DeviceId)
		FROM
			ShiftEvent		se
		WHERE	1	=	1
			AND	ROWNUM				=	1
			AND	se.Creadate			>	cbm.BoxRemDateTime
			AND se.PartitioningDate >	cbm.BoxRemDateTime
			AND se.AssemblyNo 		=	cbm.CashBoxSerNo
			AND se.DeviceClassId 	=	501
			AND se.EventCode 		=	48011
	)					        												FareboxInserted
	,To_Char	(cbm.MobVaultSerNo)												MobVaultSerNo
	,To_Char	(cbm.ReceiverNo)												ReceiverNo
--	,Decode	(cbm.BoxRemDateTime
--				,NULL	,To_Char	(cbm.BoxInRecVaultDateTime, ''MM/DD/YYYY HH24:MI:SS'')
--			,To_Char	(cbm.BoxRemDateTime, ''MM/DD/YYYY HH24:MI:SS'')
--			)																	DateTimeRemoved
	,To_Char	(cbm.BoxRemDateTime, ''MM/DD/YYYY HH24:MI:SS'')					DateTimeRemoved
--	,NULL																		DateTimeInserted
	,To_Char	(cbm.BoxInRecVaultDateTime, ''MM/DD/YYYY HH24:MI:SS'')			DateTimeInserted
	,To_Char	(cbm.RemDeviceClassID)											DeviceClassID
	,To_Char	(Sum	(Decode	(cbmmd.PaymentType || ''-'' || cbmmd.PaymentTypeValue
									,''1-1''		,cbmmd.NumberPieces
								,0
								)
						)
				)																Coins1Cent
	,To_Char	(Sum	(Decode	(cbmmd.PaymentType || ''-'' || cbmmd.PaymentTypeValue
									,''1-5''		,cbmmd.NumberPieces
								,0
								)
						)
				)																Coins5Cent
	,To_Char	(Sum	(Decode	(cbmmd.PaymentType || ''-'' || cbmmd.PaymentTypeValue
									,''1-10''		,cbmmd.NumberPieces
								,0
								)
						)
				)																Coins10Cent
	,To_Char	(Sum	(Decode	(cbmmd.PaymentType || ''-'' || cbmmd.PaymentTypeValue
									,''1-25''		,cbmmd.NumberPieces
								,0
								)
						)
				)																Coins25Cent
	,To_Char	(Sum	(Decode	(cbmmd.PaymentType || ''-'' || cbmmd.PaymentTypeValue
									,''1-100''	,cbmmd.NumberPieces
								,0
								)
						)
				)																Coins1Dolar
	,To_Char	(Sum	(Decode	(cbmmd.PaymentType || ''-'' || cbmmd.PaymentTypeValue
									,''3-125''	,cbmmd.NumberPieces
								, 0
								)
						)
				)																Tokens125Cent
	,To_Char	(Sum	(Decode	(cbmmd.PaymentType || ''-'' || cbmmd.PaymentTypeValue
									,''2-100''	,cbmmd.NumberPieces
								, 0
								)
						)
				)																Bills1Bug
	,To_Char	(Sum	(Decode	(cbmmd.PaymentType || ''-'' || cbmmd.PaymentTypeValue
									,''2-200''	,cbmmd.NumberPieces
								,0
								)
						)
				)																Bills2Bug
	,To_Char	(Sum	(Decode	(cbmmd.PaymentType || ''-'' || cbmmd.PaymentTypeValue
									,''2-500''	,cbmmd.NumberPieces
								,0
								)
						)
				)																Bills5Bug
	,To_Char	(Sum	(Decode	(cbmmd.PaymentType || ''-'' || cbmmd.PaymentTypeValue
									,''2-1000''	,cbmmd.NumberPieces
								,0
								)
						)
				)																Bills10Bug
	,To_Char	(Sum	(Decode	(cbmmd.PaymentType || ''-'' || cbmmd.PaymentTypeValue
									,''2-2000''	,cbmmd.NumberPieces
								,0
								)
						)
				)																Bills20Bug
	,To_Char	(Sum	(Decode	(cbmmd.PaymentType || ''-'' || cbmmd.PaymentTypeValue
									,''2-5000''	,cbmmd.NumberPieces
								,0
								)
						)
				)																Bills50Bug
	,To_Char	(Sum	(Decode	(cbmmd.PaymentType || ''-'' || cbmmd.PaymentTypeValue
									,''2-10000''	,cbmmd.NumberPieces
								,0
								)
						)
				)																Bills100Bug
	,To_Char	(Sum	(Decode	(cbmmd.PaymentType || ''-'' || cbmmd.PaymentTypeValue
									,''2-100''	,cbmmd.NumberPieces * cbmmd.PaymentTypeValue
									,''2-200''	,cbmmd.NumberPieces * cbmmd.PaymentTypeValue				--	2006-12-15	ABU
									,''2-500''	,cbmmd.NumberPieces * cbmmd.PaymentTypeValue
									,''2-1000''	,cbmmd.NumberPieces * cbmmd.PaymentTypeValue
									,''2-2000''	,cbmmd.NumberPieces * cbmmd.PaymentTypeValue
									,''2-5000''	,cbmmd.NumberPieces * cbmmd.PaymentTypeValue
									,''2-10000''	,cbmmd.NumberPieces * cbmmd.PaymentTypeValue
									,''1-1''		,cbmmd.NumberPieces * cbmmd.PaymentTypeValue
									,''1-5''		,cbmmd.NumberPieces * cbmmd.PaymentTypeValue
									,''1-10''		,cbmmd.NumberPieces * cbmmd.PaymentTypeValue
									,''1-25''		,cbmmd.NumberPieces * cbmmd.PaymentTypeValue
									,''1-100''	,cbmmd.NumberPieces * cbmmd.PaymentTypeValue
									,''3-125''	,cbmmd.NumberPieces * cbmmd.PaymentTypeValue
								,0
								)
						) / 100
				)																TotalRecRev
	,''0''																		Zero
	,sta.StationID
	,''cbm''																	TableAlias

FROM
	 CashBoxMovement     			cbm
	,CashBoxMovementMoneyDetails	cbmmd
	,StationController   			sc
	,TVMStation						sta

WHERE 	1=1

--
--	Join conditions
--
	AND	cbmmd.sequenceparent	=	cbm.Sequence

	AND	sc.SCID    				=	cbm.GCDeviceID
	AND	sc.DeviceClassID		=	cbm.GCDeviceClassID

	AND	sta.StationID			=	sc.LocationID
	AND	sta.StationType			=	1

--
--	Filter conditions
--
	AND	cbm.ManCorrStatus		IN	(1			--	Cashbox removed from farebox
									,2			--	Cashbox emptied into mobil vault
									,4			--	manual correction
									)

	AND	cbm.BoxRemDateTime		IS	NOT	NULL	--	Do not list incomplete cbm, they are combined
												--	with sra later		2008-04-08	ABU


-----------------------
--
--	Removed		2008-03-14	ABU
--
--	AND	cbm.RemDeviceClassID	IN	(
--										SELECT
--											DeviceClassId
--										FROM
--											DeviceClass
--										WHERE	DeviceClassType	=	5
--									)
----------------------

--
--	Performance conditions
--

--
--	Parameter conditions
--

	AND	(	cbm.BoxRemDateTime       	>= 	:P_DateFirst
		OR
			cbm.BoxInRecVaultDateTime	>= 	:P_DateFirst						--	2008-03-14	ABU
		)
	AND	(	cbm.BoxRemDateTime       	<= 	:P_DateLast
		OR
			cbm.BoxInRecVaultDateTime	<= 	:P_DateLast							--	2008-03-14	ABU
		)

'
;
-----------------------------------------

	sql_Main_Select_cbm02		VARCHAR2	(1000) :=
'GROUP BY
	 cbm.ProbingUserID
	,cbm.CashBoxSerNo
	,cbm.RemDeviceID
	,sta.Name
	,cbm.RemDeviceClassID
	,cbm.BoxRemDateTime
	,cbm.BoxInRecVaultDateTime
	,cbm.MobVaultSerNo
	,To_Char	(cbm.ReceiverNo)
	,sta.StationID
'
;

--------------------------------------------------------------------------------

	sql_Main_Select_sra01		VARCHAR2	(2000)	:=
'SELECT
	 1
	,:P_QueryId
	,coin.EmployeeNo						--	Data1		Employee
	,coin.MoneyContainerID					--	Data2		CashBoxNo
	,coin.DeviceID							--	Data3		BusNo		FareBoxRemoved
	,sta.Name								--	Data4		Garage
	,coin.DeviceID							--	Data5		FareBoxRemoved
	,(
		SELECT
				/*
					INDEX	(se	XIE3SHIFTEVENT)
				*/
			To_Char	(se.DeviceId)
		FROM
			ShiftEvent		se
		WHERE	1	=	1
			AND	ROWNUM				=	1
			AND	se.Creadate			>	coin.CreaDate
			AND se.PartitioningDate >	coin.CreaDate
			AND se.AssemblyNo 		=	coin.MoneyContainerID
			AND se.DeviceClassId 	=	501
			AND se.EventCode 		=	48011
	)										--	Data6		FareboxInserted
	,To_Char	(cbm.MobVaultSerNo)			--	Data7		MobVaultSerNo
	,To_Char	(cbm.ReceiverNo)			--	Data8		ReceiverNo
	,To_Char	(coin.CreaDate
				, ''MM/DD/YYYY HH24:MI:SS''
				)							--	Data9		DataTimeRemoved
	,To_Char	(cbm.BoxInRecVaultDateTime, ''MM/DD/YYYY HH24:MI:SS'')
											--	Data10		DateTimeInserted
	,To_Char	(cbm.RemDeviceClassID)		--	Data11		DeviceClassId
	,coin.Coins1Cent						--	Data12
	,coin.Coins5Cent						--	Data13
	,coin.Coins10Cent						--	Data14
	,coin.Coins25Cent						--	Data15
	,coin.Coins1Dolar						--	Data16
	,coin.Tokens125Cent						--	Data17
	,bill.Bills1Bug							--	Data18
	,bill.Bills2Bug							--	Data26
	,bill.Bills5Bug							--	Data19
	,bill.Bills10Bug						--	Data20
	,bill.Bills20Bug						--	Data21
	,bill.Bills50Bug						--	Data22
	,bill.Bills100Bug						--	Data23
	,bill.TotalRecRev + coin.TotalRecRev	--	Data24		Total
	,''1''									--	Data25		Probing
	,sta.StationID							--	Data27
	,''sra''																	TableAlias

FROM
	 CashBoxMovement     			cbm
	,TVMStation						sta
	,StationController   			sc
'
;
-----------------------------------------

	sql_Main_Select_Coin01		VARCHAR2	(4000)	:=
'	,(
		SELECT
			 To_Char	(sra.DeviceClassID)												DeviceClassID
			,To_Char	(sra.DeviceID)													DeviceID
			,sra.CreaDate																CreaDate
			,To_Char	(sra.MoneyContainerID)											MoneyContainerID
			,To_Char	(sra.SumRecActEvSequNo)											SumRecActEvSequNo
			,To_Char	(sra.UniquemsID)												UniquemsID
			,To_Char	(sra.EmployeeNo)												EmployeeNo
			,To_Char	(Sum	(Decode	(mccs.PaymentType || ''-'' || mccs.PaymentTypeValue
											,''1-1''		,mccs.NumberPieces
										,0
										)
								)
						)														 		Coins1Cent
			,To_Char	(Sum	(Decode	(mccs.PaymentType || ''-'' || mccs.PaymentTypeValue
											,''1-5''		,mccs.NumberPieces
										,0
										)
								)
						)																Coins5Cent
			,To_Char	(Sum	(Decode	(mccs.PaymentType || ''-'' || mccs.PaymentTypeValue
											,''1-10''		,mccs.NumberPieces
										,0
										)
								)
						) 																Coins10Cent
			,To_Char	(Sum	(Decode	(mccs.PaymentType || ''-'' || mccs.PaymentTypeValue
											,''1-25''		,mccs.NumberPieces
										,0
										)
								)
						) 																Coins25Cent
			,To_Char	(Sum	(Decode	(mccs.PaymentType || ''-'' || mccs.PaymentTypeValue
											,''1-100''	,mccs.NumberPieces
										,0
										)
								)
						) 																Coins1Dolar
			,To_Char	(Sum	(Decode	(mccs.PaymentType || ''-'' || mccs.PaymentTypeValue
											,''3-125''	,mccs.NumberPieces
										,0
										)
								)
						) 																Tokens125Cent
			,To_Char	(Sum	(Decode	(mccs.PaymentType || ''-'' || mccs.PaymentTypeValue
											,''1-1''		,mccs.NumberPieces * mccs.PaymentTypeValue
											,''1-5''		,mccs.NumberPieces * mccs.PaymentTypeValue
											,''1-10''		,mccs.NumberPieces * mccs.PaymentTypeValue
											,''1-25''		,mccs.NumberPieces * mccs.PaymentTypeValue
											,''1-100''	,mccs.NumberPieces * mccs.PaymentTypeValue
											,''3-125''	,mccs.NumberPieces * mccs.PaymentTypeValue
										,0
										)
								) / 100
						)																TotalRecRev
		FROM
		 	 SumRecordAction					sra
			,MoneyContainerContentSum			mccs
		WHERE	1=1

		--
		--	Join conditions
		--
			AND	mccs.DeviceClassID		(+)	=	sra.DeviceClassID
			AND	mccs.DeviceID			(+)	=	sra.DeviceID
			AND	mccs.UniquemsID			(+)	=	sra.UniquemsID
			AND	mccs.SumRecActEvSequNo	(+)	=	sra.SumRecActEvSequNo
			AND	mccs.MoneyContainerType	(+)	=	sra.MoneyContainerType			--	Added	2008-10-24	ABU
			AND	mccs.MoneyContainerId	(+)	=	sra.MoneyContainerId			--	Added	2008-10-24	ABU


		--
		--	Filter conditions
		--
			AND sra.DeviceClassID			= 501
			AND sra.MoneyContainerType		=	1		-- Coin vault
			AND sra.ActionCode				=	7		-- Container Remove
			AND sra.RatedActualFlag         =	0

			AND mccs.TypeOfCounter		(+)	=	2

			AND NOT EXISTS (
								SELECT
									''*''
								FROM
									CashBoxMovement		cbm
								WHERE 1=1
									AND	cbm.RemDeviceClassID		=	sra.DeviceClassID
									AND cbm.RemDeviceID				=	sra.DeviceID
									AND cbm.BoxRemEvSequNo			>=	sra.SumRecActEvSequNo 	- 25
									AND cbm.BoxRemEvSequNo			<=	sra.SumRecActEvSequNo 	+ 5
									AND cbm.BoxRemDateTime			>=	sra.CreaDate 			- 5/1440
									AND cbm.BoxRemDateTime			<=	sra.CreaDate 			+ 5/1440
							)

		--
		--	Performance conditions
		--

		--
		--	Parameter conditions
		--

			AND sra.CreaDate				>= :DateFirst
			AND sra.PartitioningDate		>= :DateFirst
			AND sra.CreaDate				<= :DateLast
'
;
-----------------------------------------

	sql_Main_Select_Coin02		VARCHAR2	(500)	:=
'		GROUP BY
			sra.DeviceClassID,
			sra.DeviceID,
			sra.MoneyContainerID,
			sra.UniquemsID,
			sra.SumRecActEvSequNo,
			sra.CreaDate,
			sra.EmployeeNo
	)				coin
';
-----------------------------------------

	sql_Main_Select_Bill01		VARCHAR2	(4000)	:=
'	,(
		SELECT
			 To_Char	(sra.DeviceClassID)												DeviceClassID
			,To_Char	(sra.DeviceID)													DeviceID
			,sra.CreaDate																CreaDate
			,To_Char	(sra.MoneyContainerID)											MoneyContainerID
			,To_Char	(sra.SumRecActEvSequNo)											SumRecActEvSequNo
			,To_Char	(sra.UniquemsID)												UniquemsID
			,To_Char	(sra.EmployeeNo)												EmployeeNo
			,To_Char	(Sum	(Decode	(mccs.PaymentType || ''-'' || mccs.PaymentTypeValue
											,''2-100''	, mccs.NumberPieces
										,0
										)
								)
						)																Bills1Bug
			,To_Char	(Sum	(Decode	(mccs.PaymentType || ''-'' || mccs.PaymentTypeValue
											,''2-200''	, mccs.NumberPieces
										,0
										)
								)
						)			 													Bills2Bug
			,To_Char	(Sum	(Decode	(mccs.PaymentType || ''-'' || mccs.PaymentTypeValue
											,''2-500''	, mccs.NumberPieces
										,0
										)
								)
						) 																Bills5Bug
			,To_Char	(Sum	(Decode	(mccs.PaymentType || ''-'' || mccs.PaymentTypeValue
											,''2-1000''	, mccs.NumberPieces
										,0
										)
								)
						) 																Bills10Bug
			,To_Char	(Sum	(Decode	(mccs.PaymentType || ''-'' || mccs.PaymentTypeValue
											,''2-2000''	, mccs.NumberPieces
										,0
										)
								)
						) 																Bills20Bug
			,To_Char	(Sum	(Decode	(mccs.PaymentType || ''-'' || mccs.PaymentTypeValue
											,''2-5000''	, mccs.NumberPieces
										,0
										)
								)
						) 																Bills50Bug
			,To_Char	(Sum	(Decode	(mccs.PaymentType || ''-'' || mccs.PaymentTypeValue
											,''2-10000''	, mccs.NumberPieces
										,0
										)
								)
						)																Bills100Bug
			,To_Char	(Sum	(Decode	(mccs.PaymentType || ''-'' || mccs.PaymentTypeValue
											,''2-100''	,mccs.NumberPieces * mccs.PaymentTypeValue
											,''2-200''	,mccs.NumberPieces * mccs.PaymentTypeValue
											,''2-500''	,mccs.NumberPieces * mccs.PaymentTypeValue
											,''2-1000''	,mccs.NumberPieces * mccs.PaymentTypeValue
											,''2-2000''	,mccs.NumberPieces * mccs.PaymentTypeValue
											,''2-5000''	,mccs.NumberPieces * mccs.PaymentTypeValue
											,''2-10000''	,mccs.NumberPieces * mccs.PaymentTypeValue
										,0
										)
								) / 100
						)																TotalRecRev
	FROM
		SumRecordAction					sra,
		MoneyContainerContentSum		mccs
	WHERE		1=1

		--
		--	Join conditions
		--
			AND	mccs.DeviceClassID		(+)	=	sra.DeviceClassID
			AND	mccs.DeviceID			(+)	=	sra.DeviceID
			AND	mccs.UniquemsID			(+)	=	sra.UniquemsID
			AND	mccs.SumRecActEvSequNo	(+)	=	sra.SumRecActEvSequNo
			AND	mccs.MoneyContainerType	(+)	=	sra.MoneyContainerType			--	Added	2008-10-24	ABU
			AND	mccs.MoneyContainerId	(+)	=	sra.MoneyContainerId			--	Added	2008-10-24	ABU


		--
		--	Filter conditions
		--
			AND sra.DeviceClassID			= 501
			AND sra.MoneyContainerType		=	2		--	Bills
			AND sra.ActionCode				=	7		--	Container Remove
			AND sra.RatedActualFlag         =	0

			AND mccs.TypeOfCounter		(+)	=	2

			AND NOT EXISTS (
								SELECT
									''*''
								FROM
									CashBoxMovement		cbm
								WHERE 1=1
									AND	cbm.RemDeviceClassID		=	sra.DeviceClassID
									AND cbm.RemDeviceID				=	sra.DeviceID
									AND cbm.BoxRemEvSequNo			>=	sra.SumRecActEvSequNo 	- 25
									AND cbm.BoxRemEvSequNo			<=	sra.SumRecActEvSequNo 	+ 5
									AND cbm.BoxRemDateTime			>=	sra.CreaDate 			- 5/1440
									AND cbm.BoxRemDateTime			<=	sra.CreaDate 			+ 5/1440
							)

		--
		--	Performance conditions
		--

		--
		--	Parameter conditions
		--

			AND sra.CreaDate				>= :DateFirst
			AND sra.PartitioningDate		>= :DateFirst
			AND sra.CreaDate				<= :DateLast
'
;
-----------------------------------------

	sql_Main_Select_Bill02		VARCHAR2	(500)	:=
'		GROUP BY
			 sra.DeviceClassID
			,sra.DeviceID
			,sra.MoneyContainerID
			,sra.UniquemsID
			,sra.SumRecActEvSequNo
			,sra.CreaDate
			,sra.EmployeeNo
	)											bill
';
-----------------------------------------

	sql_Main_Select_sra02		VARCHAR2	(1000)	:=
'WHERE	1	=	1

--
--	Join conditions
--
	AND	sc.SCID    								=	cbm.GCDeviceID
	AND	sc.DeviceClassID						=	cbm.GCDeviceClassID

	AND	sta.StationID							=	sc.LocationID
	AND	sta.StationType							=	1

	AND	cbm.CashBoxSerNo					(+)	=	coin.MoneyContainerId			--	CashBoxNo

	AND	cbm.BoxInRecVaultDateTime			(+)	<=	coin.CreaDate		+ 5 / (24 * 60)
	AND	cbm.BoxInRecVaultDateTime			(+)	>=	coin.CreaDate		- 5 / (24 * 60)

	AND	coin.DeviceClassID						=	bill.DeviceClassID
	AND	coin.DeviceID							=	bill.DeviceID
	AND	coin.MoneyContainerID					=	bill.MoneyContainerID
	AND	coin.UniquemsID							=	bill.UniquemsID
	AND	(bill.CreaDate - coin.CreaDate) * 86400	<=	10
	AND	(bill.CreaDate - coin.CreaDate) * 86400	>=	-5

	AND	Abs	(bill.SumRecActEvSequNo	-	coin.SumRecActEvSequNo)	<=	15			--	2008-03-12	ABU
';

--******************************************************************************
--
--	Start work
--
--******************************************************************************

BEGIN

	DELETE 		tempQueryResult;
	COMMIT;

-----------------------------------------
--
--	Cashboxes from CashboxMovement
--
-----------------------------------------

/*
	sql_Main	:=		sql_Main_Insert
					||	sql_Main_Select_cbm01
                   	||		SF_TRANSFORM_PARAM_2004	('cbm.RemDeviceID'		,vBusNo)
                   	||		SF_TRANSFORM_PARAM_2004	('cbm.CashBoxSerNo'		,vCashbox)
                   	||		SF_TRANSFORM_PARAM_2004	('cbm.ProbingUserID'	,vEmployee)
                   	||		SF_TRANSFORM_PARAM_2004	('cbm.RemDeviceID'		,vFareboxFrom)
                   	||		SF_TRANSFORM_PARAM_2004	('sc.LocationID'		,vGarage)
					||	sql_Main_Select_cbm02
	;

	sp_Output	(sql_Main);

-----------------------------------------

	EXECUTE	IMMEDIATE
		sql_Main	USING 	 nQueryID
							,dDateFirst
							,dDateFirst											--	2008-03-14	ABU
							,dDateLast
							,dDateLast											--	2008-03-14	ABU

	;

	COMMIT;
*/
-----------------------------------------
--
--	Cashboxes from SumRecordAction
--
-----------------------------------------


	sql_Main	:=		sql_Main_Insert
					||	sql_Main_Select_sra01
					||		sql_Main_Select_Coin01
                   	||			SF_TRANSFORM_PARAM_2004	('sra.DeviceID'			,vBusNo)
                   	||			SF_TRANSFORM_PARAM_2004	('sra.MoneyContainerID'	,vCashbox)
                   	||			SF_TRANSFORM_PARAM_2004	('sra.EmployeeNo'		,vEmployee)
                   	||			SF_TRANSFORM_PARAM_2004	('sra.DeviceID'			,vFareboxFrom)
					||		sql_Main_Select_Coin02
					||		sql_Main_Select_Bill01
                   	||			SF_TRANSFORM_PARAM_2004	('sra.DeviceID'			,vBusNo)
                   	||			SF_TRANSFORM_PARAM_2004	('sra.MoneyContainerID'	,vCashbox)
                   	||			SF_TRANSFORM_PARAM_2004	('sra.EmployeeNo'		,vEmployee)
                   	||			SF_TRANSFORM_PARAM_2004	('sra.DeviceID'			,vFareboxFrom)
					||		sql_Main_Select_Bill02
					||	sql_Main_Select_sra02
	;

	sp_Output	(sql_Main);

-----------------------------------------

	EXECUTE	IMMEDIATE
		sql_Main	USING 	 nQueryID
							,dDateFirst						--	for coins
							,dDateFirst
							,dDateLast
							,dDateFirst						--	for bills
							,dDateFirst
							,dDateLast
	;

	COMMIT;

END;
/

DROP SYNONYM CARDUSER.SP_CHR_2004;

CREATE OR REPLACE SYNONYM CARDUSER.SP_CHR_2004 FOR MBTA.SP_CHR_2004;


GRANT EXECUTE ON MBTA.SP_CHR_2004 TO CARDUSER;

GRANT EXECUTE ON MBTA.SP_CHR_2004 TO EXECUTE_MBTA_STORED_PROCEDURES;

GRANT EXECUTE ON MBTA.SP_CHR_2004 TO RIGHTS_TO_MBTA_PROCEDURES;
