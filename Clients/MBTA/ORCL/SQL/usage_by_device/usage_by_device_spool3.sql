set linesize 10000;
set pages 0 emb on newp none;
set feedback off;
set echo off;
set trimspool on;
set termout off;
set underline off;
--parallel(sd 4)
--parallel(sub 4) -- these parameter are actually slowing the query 
--parallel(mcm 4) -- even thoug they are using the same explain plan with OR without these. 
--parallel(st 4) 
--INDEX(mcm, XIE5MISCCARDMOVEMENT)
--INDEX(sd, XPKSALESDETAIL)
--INDEX(st, XIE1SALESTRANSACTION)
--INDEX       (sub, XPKSALESDETAIL)
SELECT 
    /*+
        ORDERED
        INDEX       (sub    XIE1SalesDetail)
        USE_HASH    (sd)
        USE_HASH    (sub)        
        USE_HASH    (mcm)
        USE_HASH    (st)
        USE_HASH    (hol)
        FULL        (sd)
        FULL        (mcm)
        FULL        (st)        
        USE_NL        (rou)
        USE_NL        (tvm)
        USE_NL        (sta)
    */
     '"' ||sd.DeviceId
|| '"|"' ||  st.deviceclassid
|| '"|"' ||  sd.ticketserialno
|| '"|"' ||  To_char(st.creadate,'YYYY-MM-DD-HH24:MI:SS')
|| '"|"' ||  sd.articleno
|| '"|"' ||  sd.ticketstocktype
|| '"|"' ||  sta.name
|| '"|"' ||  sd.BranchLineId 
|| '"|"' ||  decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1, 0)  
|| '"'
From SalesDetail             sd
    ,SalesDetail             sub
    ,MiscCardMovement        mcm
    ,SalesTransaction        st
    ,TVMTable                tvm
    ,tvmStation              sta
--,tICKETTYPE TT
--,ticketstocktype tst
/* 
,MiscFuncItemMovement        fimvt1 
,MiscFuncItemMovement        fimvt2 
,MiscFuncItemMovement        fimvt3 
,MiscFuncItemMovement        fimvt4 
,MiscFuncItemMovement        fimvt5 
,MiscFuncItemMovement        fimvt6 
*/
Where 1 = 1 
AND sub.DeviceClassId (+) = sd.DeviceClassId 
AND sub.DeviceId (+) = sd.DeviceId 
AND sub.Uniquemsid (+) = sd.Uniquemsid 
AND sub.SalestransactionNo (+) = sd.SalesTransactionNo 
AND sub.SalesDetailEvSequNo (+) = sd.SalesDetailEvSequNo+1 
AND sub.CorrectionCounter(+) = sd.CorrectionCounter 
AND sub.PartitioningDate (+) = sd.PartitioningDate 
AND mcm.DeviceClassId = sd.DeviceClassId 
AND mcm.DeviceId = sd.DeviceId 
AND mcm.Uniquemsid = sd.Uniquemsid 
AND mcm.SalestransactionNo = sd.SalesTransactionNo 
AND mcm.SequenceNo = Decode(sub.SalesDetailEvSequNo ,NULL ,sd.SalesDetailEvSequNo,sub.SalesDetailEvSequNo) 
AND mcm.CorrectionCounter = sd.CorrectionCounter 
AND mcm.PartitioningDate= sd.PartitioningDate 
AND mcm.TimeStamp = sd.CreaDate
/* 
AND    fimvt1.CardMovementId    (+)    =    mcm.CardMovementId 
AND    fimvt1.ElementId        (+)    =    714 
AND    fimvt1.PartitioningDate    (+)    =    mcm.PartitioningDate 
AND    fimvt2.CardMovementId    (+)    =    mcm.CardMovementId 
AND    fimvt2.ElementId        (+)    =    713 
AND    fimvt2.PartitioningDate    (+)    =    mcm.PartitioningDate 
AND    fimvt3.CardMovementId    (+)    =    mcm.CardMovementId 
AND    fimvt3.ElementId        (+)    =    20                        
AND    fimvt3.PartitioningDate    (+)    =    mcm.PartitioningDate 
AND    fimvt4.CardMovementId    (+)    =    mcm.CardMovementId 
AND    fimvt4.ElementId        (+)    =    21 
AND    fimvt4.PartitioningDate    (+)    =    mcm.PartitioningDate 
AND    fimvt5.CardMovementId    (+)    =    mcm.CardMovementId 
AND    fimvt5.ElementId        (+)    =    38 
AND    fimvt5.PartitioningDate    (+)    =    mcm.PartitioningDate 
AND    fimvt6.CardMovementId    (+)    =    mcm.CardMovementId 
AND    fimvt6.ElementId        (+)    =    39 
AND    fimvt6.PartitioningDate    (+)    =    mcm.PartitioningDate
*/ 
AND sd.DeviceID = st.DeviceID 
AND sd.DeviceClassID = st.DeviceClassID 
AND sd.UniqueMSID = st.UniqueMSID 
AND sd.SalesTransactionNo = st.SalesTransactionNo
and sd.CreaDate = st.CreaDate  
AND sd.PartitioningDate = st.PartitioningDate 
--AND sd.articleno = tt.tickettypeid 
--AND sd.tariffversion = tt.versionid 
--AND tst.inttickettype (+) = sd.ticketstocktype 
AND tvm.DeviceClassID = sd.DeviceClassID 
AND tvm.TVMID=sd.DeviceID 
AND sta.StationId (+)= tvm.TVMTariffLocationID 
AND    sd.CreaDate           >=  To_Date('2012-04-01-03-00-03', 'YYYY-MM-DD-HH24:MI:SS')       
AND    sd.CreaDate           <=  To_Date('2012-05-01-02-59-59', 'YYYY-MM-DD-HH24:MI:SS') 
AND    sd.PartitioningDate   >=  To_Date('2012-04-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS')   
AND    sd.PartitioningDate   <=  To_Date('2012-06-01-02-59-59', 'YYYY-MM-DD-HH24:MI:SS') 
--   
AND mcm.TimeStamp >= To_Date('2012-04-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS') 
AND mcm.TimeStamp <= To_Date('2012-05-01-02-59-59', 'YYYY-MM-DD-HH24:MI:SS') 
AND mcm.PartitioningDate >= To_Date('2012-04-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS') 
AND mcm.PartitioningDate < To_Date('2012-06-01-02-59-59', 'YYYY-MM-DD-HH24:MI:SS') 
--AND sd.PartitioningDate >= To_Date('2010-09-20-03-00-00', 'YYYY-MM-DD-HH24:MI:SS') 
--AND sd.PartitioningDate < To_Date('2009-11-03-03-00-00', 'YYYY-MM-DD-HH24:MI:SS') 
AND st.PartitioningDate >= To_Date('2012-04-01-03-00-00', 'YYYY-MM-DD-HH24:MI:SS') 
AND st.PartitioningDate < To_Date('2012-06-01-02-59-59', 'YYYY-MM-DD-HH24:MI:SS') 
-- 
AND mcm.movementtype IN (7,20) 
AND sd.ArticleNo > 100000 
AND sd.CorrectionFlag = 0 
AND sd.RealStatisticArticle = 0 
AND sd.TempBooking = 0 
AND sd.ArticleNo <> 607900100 
AND sub.ArticleNo (+) =607900100 
AND st.TestSaleFlag = 0 
--AND sta.StationType (+) = 1 
AND mcm.DeviceClassID in (501,411,441,901,801,802,902,442); 
-- device 442 added later, Rob Creedon
--AND mcm.DeviceClassID in (442);
spool C:\usage_by_device_04-01-2012_to_05-01-2012.csv
--spool T:\Oracle\data\report_outputs\usage_by_device_04-01-2012_to_05-01-2012.csv --do not give the network location, it is taking for ever.
/
spool off