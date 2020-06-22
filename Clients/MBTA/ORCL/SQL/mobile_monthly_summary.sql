		SELECT
				/*+
					ORDERED
				*/
--     		cbmcb.DeviceClassID
--    		,cbmcb.DeviceID
--			,cbmcb.ProbingUserID
--    		,cbmcb.BoxInRecVaultDateTime
--    		,cbmcb.BoxOutRecVaultDateTime
--    		,cbmcb.CashboxSerNo
to_char(cbmmv.BoxInRecVaultDateTime,'MON-YYYY') Month_Year
    		,sum(decode(cmd.PaymentType || '-' || cmd.PaymentTypeValue, '1-1', cmd.NumberPieces, 0)) 									Coins1Cent
    		,sum(decode(cmd.PaymentType || '-' || cmd.PaymentTypeValue, '1-5', cmd.NumberPieces, 0)) 									Coins5Cent
    		,sum(decode(cmd.PaymentType || '-' || cmd.PaymentTypeValue, '1-10', cmd.NumberPieces, 0)) 									Coins10Cent
    		,sum(decode(cmd.PaymentType || '-' || cmd.PaymentTypeValue, '1-25', cmd.NumberPieces, 0)) 									Coins25Cent
    		,sum(decode(cmd.PaymentType || '-' || cmd.PaymentTypeValue, '1-100', cmd.NumberPieces, 0)) 									Coins1Dolar
    		,sum(decode(cmd.PaymentType || '-' || cmd.PaymentTypeID || '-' || cmd.PaymentTypeValue, '3-8-125', cmd.NumberPieces, 0)) 	Tokens125Cent
    		,sum(decode(cmd.PaymentType || '-' || cmd.PaymentTypeValue, '2-100', cmd.NumberPieces, 0)) 									Bills1Bug
    		,sum(decode(cmd.PaymentType || '-' || cmd.PaymentTypeValue, '2-500', cmd.NumberPieces, 0)) 									Bills5Bug
    		,sum(decode(cmd.PaymentType || '-' || cmd.PaymentTypeValue, '2-1000', cmd.NumberPieces, 0)) 	    						Bills10Bug
    		,sum(decode(cmd.PaymentType || '-' || cmd.PaymentTypeValue, '2-2000', cmd.NumberPieces, 0)) 	    						Bills20Bug
    		,sum(decode(cmd.PaymentType || '-' || cmd.PaymentTypeValue, '2-5000', cmd.NumberPieces, 0)) 	    						Bills50Bug
    		,sum(decode(cmd.PaymentType || '-' || cmd.PaymentTypeValue, '2-10000', cmd.NumberPieces, 0))	    						Bills100Bug
 --   		,sum(decode(cmd.PaymentType || '-' || cmd.PaymentTypeValue, '5-0', cmd.NumberPieces, 0))         							CoinsByPass
    		,sum(decode(cmd.PaymentType || '-' || cmd.PaymentTypeValue,
            		'2-100', cmd.NumberPieces * cmd.PaymentTypeValue,
            		'2-500', cmd.NumberPieces * cmd.PaymentTypeValue,
            		'2-1000', cmd.NumberPieces * cmd.PaymentTypeValue,
            		'2-2000', cmd.NumberPieces * cmd.PaymentTypeValue,
            		'2-5000', cmd.NumberPieces * cmd.PaymentTypeValue,
            		'2-10000', cmd.NumberPieces * cmd.PaymentTypeValue,
            		'1-1', cmd.NumberPieces * cmd.PaymentTypeValue,
            		'1-5', cmd.NumberPieces * cmd.PaymentTypeValue,
            		'1-10', cmd.NumberPieces * cmd.PaymentTypeValue,
            		'1-25', cmd.NumberPieces * cmd.PaymentTypeValue,
            		'1-100', cmd.NumberPieces * cmd.PaymentTypeValue,
            		'3-125', cmd.NumberPieces * cmd.PaymentTypeValue, 0)) / 100		TotalRecRev
		---
--			,cbmmv.MobVaultSerNo												MobVaultSerNo
--			,tvm.TVMTariffLocationID											GarageID
--			,sta.NAME                                                    		Garage
--			,cbmmv.ReceiverNo													ReceiverNo
--			,cbmmv.BoxInRecVaultDateTime										MvInRecVaultDateTime
--			,Nvl	(cbmmv.BoxOutRecVaultDateTime
--					,To_Date	('3000','YYYY')
--					)															MvOutRecVaultDateTime
--			,cbmmv.Transp_No_Coins												Transp_No_Coins
--			,cbmmv.Transp_No_Bills												Transp_No_Bills
		FROM
			 CashBoxMovement				cbmmv
			,TVMTable						tvm
			,TVMStation						sta
			,CashBoxMovement				cbmcb
			,CashBoxMovementMoneyDetails	cmd
		WHERE	1	=	1
		--
		--	Join conditions
		--
    		AND cbmcb.BoxInRecVaultDateTime   >= 	cbmmv.BoxInRecVaultDateTime
    		AND cbmcb.BoxInRecVaultDateTime   < 	Nvl	(cbmmv.BoxOutRecVaultDateTime
														,To_Date	('3000','YYYY')
														)
      AND cbmcb.MobVaultSerNo           	= 	cbmmv.MobVaultSerNo
			AND	cbmcb.GcDeviceId				=	cbmmv.GcDeviceId
			AND	cbmcb.ReceiverNo				=	cbmmv.ReceiverNo

      AND cmd.SequenceParent       		=	cbmcb.SEQUENCE

			AND	tvm.DeviceClassID				= 	cbmmv.GCDeviceClassID
			AND	tvm.TVMID						= 	cbmmv.GCDeviceID

			AND	sta.StationID					= 	tvm.TVMTariffLocationID
		--
		--	Filter conditions
		--
			AND	cbmmv.MobVaultSerNo				>	0
			AND	cbmmv.ManCorrStatus			IN	(100,101)
			AND	cbmmv.BoxInRecVaultDateTime		<	cbmmv.BoxOutRecVaultDateTime

			AND	cbmcb.ManCorrStatus			in (2,3,4)
      AND cbmcb.DeviceClassId 			= 501
		--
		--	Parameter conditions
		--
			AND	cbmmv.BoxInRecVaultDateTime		>=	to_date('2010-09-01-03-00-00','YYYY-MM-DD-HH24-MI-SS') --:P_DateFirst
			AND	cbmmv.BoxInRecVaultDateTime		<=	to_date('2010-10-01-02-59-59','YYYY-MM-DD-HH24-MI-SS') --:P_DateLast
--AND to_number(tvm.TVMTariffLocationID) = AND to_number(cbmmv.MobVaultSerNo) = AND to_number(cbmcb.DeviceId	) = 		
GROUP	BY to_char(cbmmv.BoxInRecVaultDateTime,'MON-YYYY')
/*
	 		cbmmv.MobVaultSerNo
			,tvm.TVMTariffLocationID
			,sta.NAME
			,cbmmv.ReceiverNo
			,cbmmv.BoxInRecVaultDateTime
			,Nvl	(cbmmv.BoxOutRecVaultDateTime
					,To_Date	('3000','YYYY')
					)
			,cbmmv.Transp_No_Coins
			,cbmmv.Transp_No_Bills
    		,cbmcb.CashboxSerNo
    		,cbmcb.DeviceClassID
    		,cbmcb.DeviceID
			,cbmcb.ProbingUserID
    		,cbmcb.BoxInRecVaultDateTime
    		,cbmcb.BoxOutRecVaultDateTime
*/
