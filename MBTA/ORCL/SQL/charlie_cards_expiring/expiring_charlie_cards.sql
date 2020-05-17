-- ** ** 1   -- All except Carporate and School and some special cards
SELECT serialnumber, articleno, max(creadate) 
FROM card a, salesdetail s 
WHERE cardvaliduntil < To_Date ('11/01/2011','mm/dd/yyyy') 
AND cardstatus = 2 
AND mediatype = 5
AND (delivertopersonid IS NULL OR delivertopersonid = 0) 
AND a.serialnumber = s.ticketserialno
AND s.ticketstocktype = 5 
AND s.partitioningdate >= To_Date('06/01/2011','mm/dd/yyyy')
group by serialnumber, articleno
--***********

-- ** ** 2  -- Carporate and School and some special cards
SELECT serialnumber, articleno, max(creadate) 
FROM card a, salesdetail s 
WHERE cardvaliduntil < To_Date ('11/01/2011','mm/dd/yyyy') 
AND cardstatus = 2 
AND mediatype = 5
AND (delivertopersonid<>0) 
AND a.serialnumber = s.ticketserialno
AND s.ticketstocktype = 5 
AND s.partitioningdate >= To_Date('06/01/2011','mm/dd/yyyy')
group by serialnumber, articleno
--***********


-- ** ** 3     -- All except Carporate and School and some special cards, with apllserialno
SELECT /*+ USE_Hash (s)  PARALLEL (s 2)  */
 cr.serialnumber,aie.applserialno 
FROM card cr
       , applimplelements AIE
       , salesdetail s
WHERE cardvaliduntil between To_Date ('11/1/2011','mm/dd/yyyy') and To_Date ('1/1/2012','mm/dd/yyyy')
AND cardstatus = 2 
AND mediatype = 5
AND (delivertopersonid IS NULL OR delivertopersonid = 0)
and aie.cardid = cr.cardid
AND cr.serialnumber = s.ticketserialno
AND s.ticketstocktype = 5 
AND s.partitioningdate >= To_Date('04/01/2011','mm/dd/yyyy')
group by cr.serialnumber,aie.applserialno 
--*********** 


--AND serialnumber IN (SELECT DISTINCT ticketserialno FROM salesdetail WHERE ticketstocktype = 5 AND partitioningdate >= To_Date('04/01/2011','mm/dd/yyyy'));

--So what i need are the card serial numbers and applserialno for cards expiring between 11/1 and 1/1 with usage since 4/01




create table mbta_temp_cards_expiring
(charlie_card_no  number(28)
)

--truncate table mbta_temp_cards_expiring
select count(1) from mbta_temp_cards_expiring


delete from 
   mbta_temp_cards_expiring a
where 
   a.rowid > 
   any (select b.rowid
   from 
      mbta_temp_cards_expiring b
   where 
      a.charlie_card_no = b.charlie_card_no
   );

--commit


--All Cards articleno, createdate and expiry date
SELECT a.serialnumber, s.articleno, max(s.creadate) createdate, a.cardvaliduntil 
FROM mbta_temp_cards_expiring e, card a, salesdetail s  
WHERE a.serialnumber = e.charlie_card_no
  AND s.ticketserialno = a.serialnumber
--cardvaliduntil < To_Date ('11/01/2011','mm/dd/yyyy') 
  AND a.cardstatus = 2                                          --Active
  AND a.mediatype = 5                                           --charlied cards only
--AND (delivertopersonid IS NULL OR delivertopersonid = 0)    --this to exclude carporate cards
  AND s.ticketstocktype = 5                                   --same as mediatype
  AND s.partitioningdate >= To_Date('06/01/2011','mm/dd/yyyy')
group by a.serialnumber, s.articleno, a.cardvaliduntil




--Not carporate cards
SELECT serialnumber, articleno, max(creadate) 
FROM card a, salesdetail s, mbta_temp_cards_expiring e 
WHERE cardvaliduntil < To_Date ('11/01/2011','mm/dd/yyyy') 
AND cardstatus = 2                                          --Active
AND mediatype = 5                                           --charlied cards only
AND (delivertopersonid IS NULL OR delivertopersonid = 0)    --this to exclude carporate cards
AND a.serialnumber = s.ticketserialno
AND s.ticketstocktype = 5                                   --same as mediatype
AND s.partitioningdate >= To_Date('06/01/2011','mm/dd/yyyy')
and a.serialnumber = E.charlie_card_no (+)
and E.charlie_card_no is null
group by serialnumber, articleno




--All Cards only expiry date. This gives duplicates of serial numbers if there are any with more than one cardstatus and applserialno
SELECT a.serialnumber, a.cardstatus, a.mediatype, aie.applserialno, a.cardvaliduntil 
FROM mbta_temp_cards_expiring e, card a, applimplelements AIE--, salesdetail s  
WHERE a.serialnumber = e.charlie_card_no
and aie.cardid = a.cardid
--  AND s.ticketserialno = a.serialnumber
--cardvaliduntil < To_Date ('11/01/2011','mm/dd/yyyy') 
  --AND a.cardstatus = 2                                          --Active
  --AND a.mediatype = 5                                           --charlied cards only
--AND (delivertopersonid IS NULL OR delivertopersonid = 0)    --this to exclude carporate cards
--  AND s.ticketstocktype = 5                                   --same as mediatype
--  AND s.partitioningdate >= To_Date('06/01/2011','mm/dd/yyyy')
group by a.serialnumber
--, s.articleno
, a.cardvaliduntil, a.cardstatus, a.mediatype, aie.applserialno











select * from card where delivertopersonid  <>0 and serialnumber = 1986783734

SELECT count(distinct(serialnumber))
FROM card a, salesdetail s 
WHERE cardvaliduntil < To_Date ('11/01/2011','mm/dd/yyyy') 
AND cardstatus = 2 
AND mediatype = 5
AND (delivertopersonid IS NULL OR delivertopersonid = 0) 
AND a.serialnumber = s.ticketserialno
AND s.ticketstocktype = 5 
AND s.partitioningdate >= To_Date('06/01/2011','mm/dd/yyyy')
105124

SELECT count(distinct(serialnumber)) 
FROM card 
WHERE cardvaliduntil < To_Date ('11/01/2011','mm/dd/yyyy') 
and    cardstatus = 2 
AND mediatype = 5
AND (delivertopersonid <> 0) 
AND serialnumber IN (SELECT DISTINCT ticketserialno FROM salesdetail WHERE ticketstocktype = 5 AND partitioningdate >= To_Date('06/01/2011','mm/dd/yyyy'));

group by serialnumber
order by count(1) desc

IN (SELECT DISTINCT ticketserialno FROM salesdetail WHERE ticketstocktype = 5 AND partitioningdate >= To_Date('06/01/2011','mm/dd/yyyy'));

CORRECTIONCOUNTER
SALESDETAILEVSEQUNO
SALESTRANSACTIONNO
UNIQUEMSID
DEVICEID
DEVICECLASSID


select * from salesdetail where partitioningdate >= To_Date('06/01/2011','mm/dd/yyyy')





select * from mbta_temp_cards_expiring 

where charlie_card_no=3683045106


select * from mbta_temp_cards_expiring