SET ECHO OFF
SET VERIFY OFF
/* HOLIDAY Criteria

Please amend the directions given by Sandra originally. 
- If a holiday falls on a Saturday, then it should be considered a holiday still.
- If a holiday falls on a Sunday, then only consider the observed holiday on the Monday; the actual holiday would be a Sunday.

*/

accept holiday_year prompt 'Please enter the year for which holiday info has to be inserted:'

column trim(next_yr) new_value next_year
column trim(year_del) new_value year_to_delete

select '&&holiday_year'+1 next_yr from dual
/

select '&&holiday_year'-3 year_del from dual
/  


ALTER SESSION SET NLS_DATE_FORMAT = 'MM-DD-YYYY HH24:MI:SS'
/

--ALTER TABLE MBTA_WEEKEND_SERVICE DROP CONSTRAINT CK_MBTA_WEEKWND_SERVICE_TYPE
--/

--ALTER TABLE MBTA_WEEKEND_SERVICE ADD (CONSTRAINT CK_MBTA_WEEKWND_SERVICE_TYPE CHECK (SERVICE_TYPE in (0,1,2,3)))
--/

--alter table MBTA_WEEKEND_SERVICE add (date_inserted date)
--/

--update MBTA_WEEKEND_SERVICE set date_inserted = to_date('09/29/2010','mm/dd/yyyy')
--/


--alter table MBTA_WEEKEND_SERVICE modify (date_inserted default trunc(sysdate) not null)
--/

--===============Insert holidays of 2012 into weekend_service table with service_type 0
INSERT INTO MBTA_WEEKEND_SERVICE
SELECT * from
(
select to_date('01/01/2013', 'mm/dd/yyyy' ), 'New Year''s Day' , 0, trunc(sysdate) from dual union all
select to_date('01/21/2013', 'mm/dd/yyyy' ), 'MLK Day' , 0, trunc(sysdate) from dual union all
select to_date('02/18/2013', 'mm/dd/yyyy' ), 'President''s Day' , 0, trunc(sysdate) from dual union all
select to_date('04/14/2013', 'mm/dd/yyyy' ), 'Patriot''s Day' , 0, trunc(sysdate) from dual union all
select to_date('05/27/2013', 'mm/dd/yyyy' ), 'Memorial Day' , 0, trunc(sysdate) from dual union all
select to_date('07/04/2013', 'mm/dd/yyyy' ), 'Independence Day' , 0, trunc(sysdate) from dual union all
select to_date('09/02/2013', 'mm/dd/yyyy' ), 'Labor Day' , 0, trunc(sysdate) from dual union all
select to_date('10/14/2013', 'mm/dd/yyyy' ), 'Columbus Day' , 0, trunc(sysdate) from dual union all
select to_date('11/11/2013', 'mm/dd/yyyy' ), 'Veteran''s Day' , 0, trunc(sysdate) from dual union all
select to_date('11/28/2013', 'mm/dd/yyyy' ), 'Thanksgiving Day' , 0, trunc(sysdate) from dual union all
select to_date('12/25/2013', 'mm/dd/yyyy' ), 'Christmas Day' , 0, trunc(sysdate) from dual
)
/ 

--===============Insert holidays of the year provided: by hour,starting at 3:00 am and extendinding 3 hours in to the next day
insert into MBTA_WEEKEND_SERVICE
select to_date((service_date+(num+2)/24), 'mm/dd/yyyy hh24:mi:ss') hd , SERVICE_DESCRIPTION hdes, 1 ser_type, trunc(sysdate) dt
from MBTA_WEEKEND_SERVICE a,
(select rownum num from user_tables where rownum <= 21)
where to_char(service_date, 'yyyy') = '&&holiday_year'
and service_type = 0
and to_date((service_date+(num+2)/24), 'mm/dd/yyyy hh24:mi:ss') not in (select service_Date from mbta_weekend_service)
union all
select to_date(((trunc(service_date)+1)+(num-1)/24), 'mm/dd/yyyy hh24:mi:ss'), SERVICE_DESCRIPTION, 1, trunc(sysdate) dt
from MBTA_WEEKEND_SERVICE,
(select rownum num from user_tables where rownum <= 3)
where to_char(service_date, 'yyyy') = '&&holiday_year'
and service_type = 0
and to_date((service_date+(num+2)/24), 'mm/dd/yyyy hh24:mi:ss') not in (select service_Date from mbta_weekend_service)
/

--=================Delete from service_table with service_type 0
delete from mbta_weekend_service where SERVICE_TYPE = 0
/

--===============>insert Saturdays into holiday table
INSERT INTO MBTA_WEEKEND_SERVICE
select to_date(we_date+(num+2)/24, 'mm/dd/yyyy hh24:mi:ss') hd , 'SATURDAY', 2, trunc(sysdate) dt
from (select wed we_date --into v_weekends                   --    Count Weekends only
from ( select rownum rnum, to_date('&&holiday_year-01-01','YYYY-MM-DD') + rownum-1  wed
from tvmtable
where rownum <= ceil(to_date('&&next_year-01-01','YYYY-MM-DD') - to_date('&&holiday_year-01-01','YYYY-MM-DD')) )
where to_char( to_date('&&holiday_year-01-01','YYYY-MM-DD') + rnum-1, 'D' ) 
in ('7')
),
(select rownum num from user_tables where rownum <= 21)
where not exists 
( select 1 from MBTA_WEEKEND_SERVICE
where service_date = to_date(we_date+(num+2)/24, 'mm/dd/yyyy hh24:mi:ss')
)        
UNION ALL
select to_date((trunc(we_date)+1)+(num-1)/24, 'mm/dd/yyyy hh24:mi:ss'), 'SATURDAY', 2, trunc(sysdate) dt
from (select wed  we_date--into v_weekends                   --    Count Weekends only
from ( select rownum rnum, to_date('&&holiday_year-01-01','YYYY-MM-DD') + rownum-1  wed
from tvmtable
where rownum <= ceil(to_date('&&next_year-01-01','YYYY-MM-DD') - to_date('&&holiday_year-01-01','YYYY-MM-DD')) )
where to_char( to_date('&&holiday_year-01-01','YYYY-MM-DD') + rnum-1, 'D' ) 
in ('7')),
(select rownum num from user_tables where rownum <= 3)
where not exists 
( select 1 from MBTA_WEEKEND_SERVICE
where service_date = to_date((trunc(we_date)+1)+(num-1)/24, 'mm/dd/yyyy hh24:mi:ss')
)       
/

--=========>insert Sundays into holiday table
INSERT INTO MBTA_WEEKEND_SERVICE
select to_date(we_date+(num+2)/24, 'mm/dd/yyyy hh24:mi:ss') hd , 'SUNDAY',3, trunc(sysdate) dt
from (select wed we_date --into v_weekends                   --    Count Weekends only
      from ( select rownum rnum, to_date('&&holiday_year-01-01','YYYY-MM-DD') + rownum-1  wed
               from tvmtable
              where rownum <= ceil(to_date('&&next_year-01-01','YYYY-MM-DD') - to_date('&&holiday_year-01-01','YYYY-MM-DD')) )
     where to_char( to_date('&&holiday_year-01-01','YYYY-MM-DD') + rnum-1, 'D' ) 
                in ('1')
       ),
(select rownum num from user_tables where rownum <= 21)
where not exists 
        ( select 1 from MBTA_WEEKEND_SERVICE
          where service_date = to_date(we_date+(num+2)/24, 'mm/dd/yyyy hh24:mi:ss')
        )
union all
select to_date((trunc(we_date)+1)+(num-1)/24, 'mm/dd/yyyy hh24:mi:ss'), 'SUNDAY',3, trunc(sysdate) dt
from (select wed  we_date--into v_weekends                   --    Count Weekends only
      from ( select rownum rnum, to_date('&&holiday_year-01-01','YYYY-MM-DD') + rownum-1  wed
               from tvmtable
              where rownum <= ceil(to_date('&&next_year-01-01','YYYY-MM-DD') - to_date('&&holiday_year-01-01','YYYY-MM-DD')) )
     where to_char( to_date('&&holiday_year-01-01','YYYY-MM-DD') + rnum-1, 'D' ) 
                in ('1')),
(select rownum num from user_tables where rownum <= 3)
where not exists 
        ( select 1 from MBTA_WEEKEND_SERVICE
          where service_date = to_date((trunc(we_date)+1)+(num-1)/24, 'mm/dd/yyyy hh24:mi:ss')
        )           
/

-------------------------

commit
/

UNDEF holiday_year

pause 'Next step is to del from holiday table for year &&year_to_delete, to EXIT, close this window'


delete from mbta_weekend_service where to_char(service_date, 'yyyy') = trim('&&year_to_delete')
/

commit
/

-------------------------------------------
--Query to get all the holidays in a year--
-------------------------------------------
/*
select service_description, min(service_Date) from MBTA_WEEKEND_SERVICE 
where to_char(date_inserted,'yyyy') = '2011'
and service_type =1
group by service_Description
order by min(service_Date)

select * from MBTA_WEEKEND_SERVICE
*/

select * from mbta_weekend_service where to_char(service_date, 'yyyy') = '2010'