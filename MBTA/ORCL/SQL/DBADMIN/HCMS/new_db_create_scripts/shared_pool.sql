select kghluidx,kghluops,kghlurcr,kghlutrn from x$kghlu;
select ksmlridx,ksmlrsiz,ksmlrnum from x$ksmlru where ksmlrnum > 0;
   
   
		 
		 
BEGIN
FOR x IN (select * from dba_objects where owner = upper('SYSADM') and object_type in ('VIEW'))
LOOP
EXECUTE IMMEDIATE 'DROP VIEW ' || upper('SYSADM') ||'.' || x.object_name || ' CASCADE CONSTRAINTS ';
END LOOP;
END;
/
		 
   