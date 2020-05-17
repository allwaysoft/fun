SELECT p.lastname, p.firstname, p.employeenumber,Ad.street, c.serialnumber, c.cardstatus
FROM person p, appluser ap, applimplementation app, applimplelements ape, address Ad, card c
WHERE ap.personid = p.personid
AND app.appluserid = ap.appluserid
AND ad.addressid = p.addressid
AND ape.applserialno = app.applserialno
AND ape.applicationid = app.applicationid
AND c.cardid = ape.cardid
AND app.salespacketid in (606300100)
AND c.cardstatus = 2

