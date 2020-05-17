select * from card where serialnumber = 1691415200     --16779
  
  
delete from userdata where username = '6662480'
  
  select count(1) from userdata
  
select p.employeenumber, p.personid, c.serialnumber, replace(firstname,',',' ') firstname, replace(lastname,',',' ') lastname, c.cardstatus, c.cardvaliduntil 
from person p
      , userdata ud
      , card c      
where p.employeenumber = to_number(ud.username)
and c.delivertopersonid = p.personid
and c.cardstatus = 2
and c.cardvaliduntil >= sysdate
--and employeenumber is not null
order by 1, 2, 5

select * from person


select * from userdata where upper(username) = lower(username)
