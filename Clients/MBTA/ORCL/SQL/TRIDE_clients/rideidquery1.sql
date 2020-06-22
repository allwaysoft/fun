--*************************************************************************************************
-- RAN BELOW IN 2011, ANOTHER QUERY BELOW THIS QUERY IS USED IN 2012
--*************************************************************************************************
SELECT tride.clientid client_id,
       upper(tride.lastname) || ' ' || upper(tride.firstname) full_Name,
       upper(tride.lastname) tride_lastname,
       upper(tride.firstname) tride_firstname,
       upper(p.lastname) p_lastname,
       upper(p.firstname) p_firstname,
       upper(p.middleinitial) P_middle_initial,
       --p.employeenumber,
       --Ad.street,
       c.serialnumber charlie_card, --charlie card number
       c.cardissued card_issude_on,
       c.cardstatus card_status,
       app.salespacketid article_no,
       tride.zipcode tride_zipcode,
       SUBSTR (ad.zipcode, 1, INSTR (ad.zipcode, '-') - 1) add_zipcode
FROM person p,
     mbta_temp_tride tride,
     appluser ap,
     address Ad,
     applimplementation app,
     applimplelements ape,
     card c
WHERE UPPER (REPLACE(TRANSLATE(SUBSTR(p.lastname(+),1,DECODE(INSTR(p.lastname(+),' '),0,LENGTH(p.lastname(+)),INSTR(p.lastname(+),' ')- 1)),',.-_+',' '),' ',''))=
      UPPER (REPLACE(TRANSLATE(SUBSTR(tride.lastname,1,DECODE(INSTR(tride.lastname,' '),0,LENGTH(tride.lastname),INSTR(tride.lastname,' ')- 1)),',.-_+',' '),' ',''))
  AND UPPER (REPLACE(TRANSLATE(SUBSTR(p.firstname(+),1,DECODE(INSTR(p.firstname(+),' '),0,LENGTH(p.firstname(+)),INSTR(p.firstname(+),' ')- 1)),',.-_+',' '),' ',''))=
      UPPER (REPLACE(TRANSLATE(SUBSTR(tride.firstname,1,DECODE(INSTR(tride.firstname,' '),0,LENGTH(tride.firstname),INSTR(tride.firstname,' ')- 1)),',.-_+',' '),' ',''))
       AND ap.personid(+) = p.personid
       AND ad.addressid(+) = p.addressid
       AND app.appluserid(+) = ap.appluserid
       AND app.salespacketid(+) = 606300100 -- this articel no is for tride customers only
       AND ape.applserialno(+) = app.applserialno
       AND ape.applicationid(+) = app.applicationid
       AND c.cardid(+) = ape.cardid
       AND c.cardstatus(+) = 2
--and substr(ad.zipcode(+),1,instr(ad.zipcode(+),'-')-1) = tride.zipcode
--order by 1
--and tride.lastname = 'DIRUZZA' and tride.firstname = 'JUDITH'
--and tride.firstname = 'CHRISTINE' and tride.lastname = 'SPACONE'


--*************************************************************************************************
-- Version 2. RAN BELOW IN March, Dec 2012
--*************************************************************************************************
SELECT --tride.clientid client_id,
       --tride.lastname || ' ' || tride.firstname full_Name,
       --tride.lastname tride_lastname,
       --tride.firstname tride_firstname,
       upper(p.lastname) LAST_NAME,
       upper(p.firstname) FIRST_NAME,
       upper(p.middleinitial) MIDDLE_INITIAL,
       p.personid PERSON_ID,
       P.DATEOFBIRTH DATE_OF_BIRTH,
       --p.employeenumber,
       --Ad.street,
       c.serialnumber charlie_card, --charlie card number
       c.cardissued card_issude_on,
       SUBSTR (ad.zipcode, 1, INSTR (ad.zipcode, '-') - 1) add_zipcode,        
       c.cardstatus card_status,      
       app.salespacketid article_no
      -- tride.zipcode tride_zipcode,
  FROM person p,
       --mbta_temp_tride tride,
       appluser ap,
       address Ad,
       applimplementation app,
       applimplelements ape,
       card c
 WHERE 1=1    
 /* UPPER (
              REPLACE (
                 TRANSLATE (
                    SUBSTR (
                       p.lastname(+),
                       1,
                       DECODE (INSTR (p.lastname(+), ' '),
                               0, LENGTH (p.lastname(+)),
                               INSTR (p.lastname(+), ' ') - 1)),
                    ',.-_+',
                    ' '),
                 ' ',
                 '')) =
              UPPER (
                 REPLACE (
                    TRANSLATE (
                       SUBSTR (
                          tride.lastname,
                          1,
                          DECODE (INSTR (tride.lastname, ' '),
                                  0, LENGTH (tride.lastname),
                                  INSTR (tride.lastname, ' ') - 1)),
                       ',.-_+',
                       ' '),
                    ' ',
                    ''))
       AND UPPER (
              REPLACE (
                 TRANSLATE (
                    SUBSTR (
                       p.firstname(+),
                       1,
                       DECODE (INSTR (p.firstname(+), ' '),
                               0, LENGTH (p.firstname(+)),
                               INSTR (p.firstname(+), ' ') - 1)),
                    ',.-_+',
                    ' '),
                 ' ',
                 '')) =
              UPPER (
                 REPLACE (
                    TRANSLATE (
                       SUBSTR (
                          tride.firstname,
                          1,
                          DECODE (INSTR (tride.firstname, ' '),
                                  0, LENGTH (tride.firstname),
                                  INSTR (tride.firstname, ' ') - 1)),
                       ',.-_+',
                       ' '),
                    ' ',
                    '')) 
*/
       AND ap.personid(+) = p.personid
       AND ad.addressid(+) = p.addressid
       AND app.appluserid(+) = ap.appluserid
       AND app.salespacketid(+) = 606300100 -- this articel no is for tride customers only
       AND ape.applserialno(+) = app.applserialno
       AND ape.applicationid(+) = app.applicationid
       AND c.cardid(+) = ape.cardid
       AND c.cardstatus(+) = 2  --active cards for more info on status, look in about_tables folder in docs    
--       AND c.cardid(+) = ape.cardid
--       AND c.cardstatus(+) = 2
--and substr(ad.zipcode(+),1,instr(ad.zipcode(+),'-')-1) = tride.zipcode
--order by 1
--and tride.lastname = 'DIRUZZA' and tride.firstname = 'JUDITH'
--and tride.firstname = 'CHRISTINE' and tride.lastname = 'SPACONE'


--*************************************************************************************************
-- Version 3. RAN BELOW on Dec 20th 2012. Some outer joins are removed as they didn't make sense and alos has the descritption for card status and added two additional fields        c.cardvalidfrom Carid_Valid_From, c.cardvaliduntil Carid_Valid_Till. Commented out the cardstatsus from the where clause to get all cards
--*************************************************************************************************

SELECT --tride.clientid client_id,
       --tride.lastname || ' ' || tride.firstname full_Name,
       --tride.lastname tride_lastname,
       --tride.firstname tride_firstname,
       upper(p.lastname) LAST_NAME,
       upper(p.firstname) FIRST_NAME,
       upper(p.middleinitial) MIDDLE_INITIAL,
       p.personid PERSON_ID,
       P.DATEOFBIRTH DATE_OF_BIRTH,
       --p.employeenumber,
       --Ad.street,
       c.serialnumber charlie_card, --charlie card number
       c.cardissued card_issude_on,
       c.cardvalidfrom Carid_Valid_From, 
       c.cardvaliduntil Carid_Valid_Till,
       SUBSTR (ad.zipcode, 1, INSTR (ad.zipcode, '-') - 1) add_zipcode,        
       decode(c.cardstatus,2,'Active',8,'Declared Blocked',9,'Actually Blocked',14,'Declared Lost',c.cardstatus) card_status,      
       app.salespacketid article_no
      -- tride.zipcode tride_zipcode,
  FROM person p,
       --mbta_temp_tride tride,
       appluser ap,
       address Ad,
       applimplementation app,
       applimplelements ape,
       card c
 WHERE 1=1    
 /* UPPER (
              REPLACE (
                 TRANSLATE (
                    SUBSTR (
                       p.lastname(+),
                       1,
                       DECODE (INSTR (p.lastname(+), ' '),
                               0, LENGTH (p.lastname(+)),
                               INSTR (p.lastname(+), ' ') - 1)),
                    ',.-_+',
                    ' '),
                 ' ',
                 '')) =
              UPPER (
                 REPLACE (
                    TRANSLATE (
                       SUBSTR (
                          tride.lastname,
                          1,
                          DECODE (INSTR (tride.lastname, ' '),
                                  0, LENGTH (tride.lastname),
                                  INSTR (tride.lastname, ' ') - 1)),
                       ',.-_+',
                       ' '),
                    ' ',
                    ''))
       AND UPPER (
              REPLACE (
                 TRANSLATE (
                    SUBSTR (
                       p.firstname(+),
                       1,
                       DECODE (INSTR (p.firstname(+), ' '),
                               0, LENGTH (p.firstname(+)),
                               INSTR (p.firstname(+), ' ') - 1)),
                    ',.-_+',
                    ' '),
                 ' ',
                 '')) =
              UPPER (
                 REPLACE (
                    TRANSLATE (
                       SUBSTR (
                          tride.firstname,
                          1,
                          DECODE (INSTR (tride.firstname, ' '),
                                  0, LENGTH (tride.firstname),
                                  INSTR (tride.firstname, ' ') - 1)),
                       ',.-_+',
                       ' '),
                    ' ',
                    '')) 
*/
       AND ap.personid(+) = p.personid
       AND ad.addressid(+) = p.addressid
       AND app.appluserid = ap.appluserid
       AND app.salespacketid = 606300100 -- this articel no is for tride customers only
       AND ape.applserialno = app.applserialno
       AND ape.applicationid = app.applicationid
       AND c.cardid = ape.cardid
	   and p.personid not in (999)  -- This is to eliminate some TEST data from the output
       --AND c.cardstatus = 2  --active cards for more info on status, look in about_tables folder in docs    
--       AND c.cardid(+) = ape.cardid
--       AND c.cardstatus(+) = 2
--and substr(ad.zipcode(+),1,instr(ad.zipcode(+),'-')-1) = tride.zipcode
--order by 1
--and tride.lastname = 'DIRUZZA' and tride.firstname = 'JUDITH'
--and tride.firstname = 'CHRISTINE' and tride.lastname = 'SPACONE'





select * from person where lastname = 'ABRAMOVA'

select * from appluser where personid = 121101

select * from address