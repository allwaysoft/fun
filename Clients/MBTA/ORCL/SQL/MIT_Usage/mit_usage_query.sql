SELECT /*+ index(s, XIE5SALESDETAIL) index(s, XIE7SALESDETAIL) */   
charliecard, To_Char(s.creadate,'MM/DD/YYYY HH24:MI:SS') AS createdate, s.Deviceclassid, s.deviceid, s.Machinebooking , s.cancellation,
decode(s.Machinebooking||':'||s.Cancellation,'1:1',1,'0:0',1,-1,0) AS test,
s.fareoptamount,
Decode (s.deviceclassid,501,trunc(s.branchlineid/10,0),'') AS route, s.branchlineid
, ts.nameshort AS stationname
FROM mitcards left outer join salesdetail s ON s.ticketserialno = charliecard
left outer join tvmtable t ON s.deviceid = t.tvmid
left outer join tvmstation ts ON t.tvmtarifflocationid = ts.stationid
WHERE s.ticketstocktype = 5 
AND s.CreaDate >= to_date('2010-11-01-00-00-00', 'YYYY-MM-DD-HH24-MI-SS')
AND s.CreaDate < to_date('2010-12-01-00-00-00', 'YYYY-MM-DD-HH24-MI-SS') 
AND s.PartitioningDate >= to_date('2010-11-01-00-00-00', 'YYYY-MM-DD-HH24-MI-SS') 
AND s.PartitioningDate < to_date('2011-01-01-00-00-00', 'YYYY-MM-DD-HH24-MI-SS') 
--AND s.partitioningdate >=To_Date('11/01/2010','mm/dd/yyyy')
AND s.productionunsure <> 1
ORDER BY s.ticketserialno,To_Char(creadate,'MM/DD/YYYY HH24:MI:SS');