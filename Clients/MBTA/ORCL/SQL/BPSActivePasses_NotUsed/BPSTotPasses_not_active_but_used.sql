SELECT /*+ index(sd, XIE5SALESDETAIL) index(sd, XIE7SALESDETAIL) */  --18 mins 1 mnth
distinct BPSTP_ID, BPSTP_serialno, to_char(creadate, 'Month') Month_Used 
FROM MBTA_TEMP_BPSchool_TOT_PASSES bpstp
    ,MBTA_TEMP_BPSchool_ACT_PASSES bpsap
    ,hotlist hl
    ,salesdetail sd
WHERE 1=1
AND bpsap.BPSap_serialno(+) =  bpstp.bpstp_serialno
and hl.serialnumber(+) = bpstp.bpstp_serialno
and sd.ticketserialno = bpstp.bpstp_serialno
and sd.ticketstocktype = 5
--s.deviceclassid in (441,411,501) AND
and sd.creadate >= to_date('2013-02-01-03-00-00','YYYY-MM-DD-HH24-MI-SS') 
and sd.creadate <= to_date('2013-03-01-02-59-59','YYYY-MM-DD-HH24-MI-SS')
and sd.partitioningdate >=  to_date('2013-02-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
and sd.productionunsure <> 1
and BPSAp.bpsap_serialno is NULL
and hl.serialnumber is NULL
ORDER BY  to_char(creadate, 'Month'), BPSTP_ID, BPSTP_serialno
--17 mins