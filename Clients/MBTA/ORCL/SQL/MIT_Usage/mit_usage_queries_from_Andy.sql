Usage report sql for May:

SELECT charliecard, To_Char(s.creadate,'MM/DD/YYYY HH24:MI:SS') AS createdate, s.Deviceclassid, s.deviceid, s.Machinebooking , s.cancellation,
decode(s.Machinebooking||':'||s.Cancellation,'1:1',1,'0:0',1,-1,0) AS test,
s.fareoptamount,
Decode (s.deviceclassid,501,trunc(s.branchlineid/10,0),'') AS route, s.branchlineid
, ts.nameshort AS stationname
FROM mitcards left outer join salesdetail s ON s.ticketserialno = charliecard
left outer join tvmtable t ON s.deviceid = t.tvmid
left outer join tvmstation ts ON t.tvmtarifflocationid = ts.stationid
WHERE s.ticketstocktype = 5 AND s.partitioningdate > To_Date('08/01/2010','mm/dd/yyyy')
AND s.productionunsure <> 1
ORDER BY s.ticketserialno,To_Char(creadate,'MM/DD/YYYY HH24:MI:SS');


--Ken's usage report sql document info:


SELECT ticketserialno, To_Char(creadate,'mm/dd/yyyy hh24:mm:ss') AS createdate, Deviceclassid, deviceid, Machinebooking ,
cancellation, fareoptamount, branchlineid, nameshort AS stationname
FROM salesdetail, mitcards, tvmstation
WHERE  ticketserialno = charliecard AND stationid (+) = branchlineid AND ticketstocktype = 5 AND ticketserialno = 242357545 AND partitioningdate > To_Date('03/01/2010','mm/dd/yyyy')
ORDER BY ticketserialno,To_Char(creadate,'mm/dd/yyyy hh24:mm:ss')


SELECT charliecard, To_Char(s.creadate,'MM/DD/YYYY HH24:MI:SS') AS createdate, s.Deviceclassid, s.deviceid, s.Machinebooking , s.cancellation,
decode(s.Machinebooking||':'||s.Cancellation,'1:1',1,'0:0',1,-1,0) AS test,
s.fareoptamount,
Decode (s.deviceclassid,501,trunc(s.branchlineid/10,0),'') AS route, s.branchlineid
, ts.nameshort AS stationname
FROM mitcards left outer join salesdetail s ON s.ticketserialno = charliecard
left outer join tvmtable t ON s.deviceid = t.tvmid
left outer join tvmstation ts ON t.tvmtarifflocationid = ts.stationid
WHERE s.ticketstocktype = 5 AND s.partitioningdate > To_Date('03/01/2010','mm/dd/yyyy')
AND s.productionunsure <> 1
ORDER BY s.ticketserialno,To_Char(creadate,'MM/DD/YYYY HH24:MI:SS');





DELETE  FROM mitcards WHERE charliecard = 0;


SELECT * FROM tmp_mit_info WHERE remainingamount = 0 AND description LIKE '%Smart Card%';


SELECT tickettypeid, description FROM tickettype WHERE versionid = 271;


SELECT DISTINCT ticketserialno from salesdetail WHERE articleno IN (102400400,
102402500,
102402700,
208000400,
606200400,
606202600,
607000400,
607102700,
611400400,
611500400)
AND partitioningdate < To_Date('09/01/2009','mm/dd/yyyy');


SELECT * FROM salesdetail WHERE ticketserialno = 207911898;

SELECT * FROM tvmstation ORDER BY stationid;

SELECT * FROM tvmtable;




