SELECT
	/*+
		ORDERED
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
		
	*/
	 :QueryID
	,1
	,nvl	(sd.BranchLineId, 0)						sign_code	--	Route

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
                    then Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1)  
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
                   then Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1) 
                 end 
            end),0)  Month_ticket_riders
      
,nvl(Sum(case when sd.articleno in (607000100,607000300,607200100,620000100,620000400,620000500, 620000600)
                then
                  case when sd.ticketstocktype not in (5,40)
                    then Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1)  
                  end
              end),0) stored_value_magnetic_riders
             
,nvl(Sum(case when sd.articleno in (208000100,208000200,208000300,208000400,208000500,208000600,208000700,208000800,208000900,208001000,208001100)
               then Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1)  
             end),0) Cash_riders         
      
,nvl(Sum(Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1)),0)  total_riders

,:weekdays
,:saturdays
,:sundays
,:holidays
,:Totaldays
FROM
	 SalesDetail			sd
	,SalesDetail			sub
	,MiscCardMovement		mcm
	,SalesTransaction		st
	
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

	AND	sd.CreaDate			>=      :dDateFirst                                             --to_date(:dDateFirst, 'mm/dd/yyyy hh24:mi:ss')
	AND	sd.CreaDate			<=      :dDateLast
	AND	sd.PartitioningDate	>= :dPartitioningDateFirst
	AND	sd.PartitioningDate	<   :dPartitioningDateLast
	
 AND sd.sellingrrid <> 2 AND 1=1 GROUP	BY
	Nvl(sd.BranchLineId, 0), :dDateFirst, :dDateLast