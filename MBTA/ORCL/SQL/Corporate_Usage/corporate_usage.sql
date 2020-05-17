--10 mins
select /*+ index(sd, XIE5SALESDETAIL) index(sd, XIE7SALESDETAIL) */  
company_id, company_serialno, replace(company_name,',',' ') company_name, creadate 
from MBTA.MBTA_TEMP_CORPORATE_USAGE mtcu
     , salesdetail sd
WHERE 1=1
AND sd.ticketserialno = mtcu.company_serialno AND
sd.ticketstocktype = 5 AND
sd.deviceclassid in (411,441,501,801,802,901,902) AND
sd.creadate >= to_date('2013-02-01-03-00-00','YYYY-MM-DD-HH24-MI-SS') AND 
sd.creadate <= to_date('2013-03-01-02-59-59','YYYY-MM-DD-HH24-MI-SS') AND
sd.partitioningdate >=  to_date('2013-02-01-03-00-00','YYYY-MM-DD-HH24-MI-SS') AND
sd.productionunsure <> 1
ORDER BY  creadate, company_id, company_serialno, company_name 


select count(1) from MBTA.MBTA_TEMP_CORPORATE_USAGE