SELECT distinct BPSap_ID, BPSap_serialno
FROM MBTA_TEMP_BPSchool_ACT_PASSES bpsap
        ,salesdetail s
WHERE s.ticketserialno(+) = bpsap.BPSap_serialno AND
s.ticketstocktype(+) = 5 AND
--s.deviceclassid in (441,411,501) AND
s.creadate(+) >= to_date('2013-02-01-03-00-00','YYYY-MM-DD-HH24-MI-SS') AND 
s.creadate (+) <= to_date('2013-03-01-02-59-59','YYYY-MM-DD-HH24-MI-SS') AND
s.partitioningdate(+) >=  to_date('2013-02-01-00-00-00','YYYY-MM-DD-HH24-MI-SS') AND
s.productionunsure(+) <> 1 AND
S.TICKETSERIALNO is NULL
ORDER BY BPSap_ID, BPSap_serialno

select count(1) from MBTA_TEMP_BPSchool_ACT_PASSES


select * from tickettype

ticketstocktype