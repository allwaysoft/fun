-- If run for a year, this will run over night.

accept start_date prompt 'Enter Value for start_date in mm/dd/yyyy-hh-mi-ss format:'
accept end_date prompt 'Enter Value for end_date in mm/dd/yyyy-hh-mi-ss format:'
--
var ddatefirst varchar2(30)
var ddatelast varchar2(30)
--
exec :ddatefirst := '&start_date';
exec :ddatelast := '&end_date';
--
declare
--
ddate_start DATE := to_date(:ddatefirst,'mm/dd/yyyy-hh-mi-ss');
ddate_end DATE := to_date(:ddatelast,'mm/dd/yyyy-hh-mi-ss');
dDateFirst_loop    DATE := ddate_start;                                -- Date first for looping
dDatelast_loop    DATE;                                               -- Date last for looping
--
begin
--
EXECUTE IMMEDIATE 'TRUNCATE TABLE mbta_temp_card_usage';
--
loop
--
if  ddate_end - ddatefirst_loop > 90
then
ddatelast_loop := ddatefirst_loop -1/(24*60*60) + 90;
else
ddatelast_loop := ddate_end;
end if;
--
Insert into mbta_temp_card_usage
SELECT 
    /*+
        ORDERED
        USE_HASH    (sd)        
        USE_HASH    (mcm)
        USE_HASH    (st)
        parallel (c 4)
        parallel (sd 4)
        parallel (mcm 4)
        parallel (st 4)
        FULL        (sd)
        FULL        (mcm)
        FULL        (st)
        FULL        (c)
    */
    c.serialnumber card_num,
    To_Char(c.cardvaliduntil,'mm/dd/yyyy') card_valid_till,   
    to_char(trunc(sd.Creadate,'mm'),'mm/dd/yyyy') creadate, 
    sum(Decode(sd.Machinebooking||':'||sd.Cancellation,'1:1',1,'0:0',1,-1)) num_card_used -- This is to make sure that it is a valid transaction.
from card c 
    ,SalesDetail            sd
    --,SalesDetail          sub
    ,MiscCardMovement        mcm
    ,SalesTransaction        st
where   c.cardvaliduntil <= To_Date ('12/31/2021','mm/dd/yyyy')   
--between To_Date ('01/14/2019','mm/dd/yyyy') and To_Date ('12/31/2021','mm/dd/yyyy')-- 
    and c.cardstatus = 2       -- Active Cards
    and c.mediatype = 5        -- It says that it is a charlie card
    and sd.ticketserialno = c.serialnumber
/*       
    AND    sub.DeviceClassId       (+)    = sd.DeviceClassId
    AND    sub.DeviceId            (+)    = sd.DeviceId
    AND    sub.Uniquemsid          (+)    = sd.Uniquemsid
    AND    sub.SalestransactionNo  (+)    = sd.SalesTransactionNo
    AND    sub.SalesDetailEvSequNo (+)    = sd.SalesDetailEvSequNo    +1
    AND    sub.CorrectionCounter   (+)    = sd.CorrectionCounter
    AND    sub.PartitioningDate    (+)    = sd.PartitioningDate
*/    
    AND    mcm.DeviceClassId           = sd.DeviceClassId
    AND    mcm.DeviceId                = sd.DeviceId
    AND    mcm.Uniquemsid              = sd.Uniquemsid
    AND    mcm.SalestransactionNo      = sd.SalesTransactionNo
/*
    AND    mcm.SequenceNo              = Decode    (sub.SalesDetailEvSequNo
                                                    ,NULL    ,sd.SalesDetailEvSequNo
                                                ,sub.SalesDetailEvSequNo
                                                )
*/
    AND    mcm.sequenceno = sd.salesdetailevsequno
--    
    AND    mcm.CorrectionCounter       = sd.CorrectionCounter
    AND    mcm.PartitioningDate        = sd.PartitioningDate
    AND    mcm.TimeStamp               = sd.CreaDate
--    
    AND    sd.DeviceID                 = st.DeviceID
    AND    sd.DeviceClassID            = st.DeviceClassID
    AND    sd.UniqueMSID               = st.UniqueMSID
    AND    sd.SalesTransactionNo       = st.SalesTransactionNo
    AND    sd.PartitioningDate         = st.PartitioningDate
--          
    AND    mcm.MovementType    IN     (7,20)
/*    
    AND    sd.ArticleNo             >     100000          -- All cards have article number greater than 100000, so eliminate this condition.
*/    
    AND    sd.CorrectionFlag           =     0
/*    
    --AND    sd.RealStatisticArticle  =     0     
    -- The above condition is to eliminate one of the transaction if a online purchase card is used. If a card is bought noline, when it is used,
    -- it will make two transactions, one to validate the card and other to see if it is good to make a ride. This condition has to be used for ridership
    -- but not in this case where we are looking for the number of times a car has been used.
*/     
    AND    sd.TempBooking              =     0
    AND    sd.ticketstocktype = 5             -- This is to say that it is a charlie card
/*    
    --AND    sd.ArticleNo             <>     607900100     
    -- This condition is to eliminate bonus ridership, MBTA doesn't have any bonus progra. 
    -- So,this condition is not required.
    --AND    sub.ArticleNo           (+)    =    607900100
*/    
    AND    st.TestSaleFlag             =     0
/*    
    AND    sd.PartitioningDate         >= to_date('2010-02-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')
    AND    sd.PartitioningDate         <= to_date('2010-03-01-02-59-59','YYYY-MM-DD-HH24-MI-SS')          
    AND    sd.CreaDate                 >= to_date('2010-02-01-03-00-00','YYYY-MM-DD-HH24-MI-SS')      
    AND    sd.CreaDate                 <= to_date('2010-03-01-02-59-59','YYYY-MM-DD-HH24-MI-SS')
      -------
*/      
AND sd.creadate >= ddatefirst_loop 
AND sd.creadate <= ddatelast_loop                                      
AND sd.PartitioningDate >= ddatefirst_loop                           
AND sd.PartitioningDate < ddatelast_loop+30    
--AND sd.PartitioningDate < trunc(last_day (Trunc (Last_Day (ddatelast_loop) +    1, 'MM')) +1, 'mm')                      
-------        
group by   c.serialnumber, To_Char(c.cardvaliduntil,'mm/dd/yyyy'), to_char(trunc(sd.Creadate,'mm'),'mm/dd/yyyy');
--
commit;
--
if dDatelast_loop = ddate_end
then
exit;
else
  ddatefirst_loop := ddatelast_loop + 1/(24*60*60);
end if; 
--
end loop;
--
end;
/
