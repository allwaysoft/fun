insert into DA.pyempsecgrpuser(esgu_group_code,esgu_user)
select esg_code, 'DA' 
FROM	da.pyempsecgrpuser, da.pyempsecgrp 
where esgu_user(+) = 'DA'
and  esg_code = esgu_group_code(+)
and esgu_group_code is null

commit

select * from pyempsecgrp
select * from pyempsecgrpuser     

delete from DA.PYEMPSECGRP
where esg_code not in('SALARY','HOURLY')     
       
delete from pyempsecgrpuser
where esgu_group_code not in('SALARY','HOURLY');
