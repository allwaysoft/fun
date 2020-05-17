--============================> BELOW scripts should be run to insert sundays and saturday for an year after the holidays of the year
-- are entered in to the table. Change the dates accordingly in the "Sunday and Saturday Scripts of that rescpective Years of which you want to insert the dates.

delete from mbta_holiday where weekend_schedule = 'N'   --Count 19
/

alter table mbta_holiday disable constraint UK_MBTA_HOLIDAY_DATE    --count42
/

insert into mbta_holiday(holiday_date, holiday_description)                      --count 1002   =  42*24-6
select to_date(holiday_date+(num+2)/24, 'mm/dd/yyyy hh24:mi:ss') hd , holiday_description hdes
from mbta_holiday,
(select rownum num from user_tables where rownum <= 21)
union all
select to_date((trunc(holiday_date)+1)+(num-1)/24, 'mm/dd/yyyy hh24:mi:ss'), holiday_description
from mbta_holiday,
(select rownum num from user_tables where rownum <= 3)
where trunc(holiday_date)+1 not in (select trunc(holiday_date) from mbta_holiday)
--and holiday_date = to_date('01-01-2008 00:00:00','mm-dd-yy hh24:mi:ss')
/

delete from mbta_holiday where weekend_schedule = 'Y'     --count 42
/

alter table mbta_holiday enable constraint UK_MBTA_HOLIDAY_DATE    --count42
/



commit








--=========>insert Sundays into holiday table
INSERT INTO MBTA_HOLIDAY(HOLIDAY_DATE, HOLIDAY_DESCRIPTION)
select to_date(we_date+(num+2)/24, 'mm/dd/yyyy hh24:mi:ss') hd , 'SUNDAY'
from (select wed we_date --into v_weekends                   --	Count Weekends only
      from ( select rownum rnum, to_date('2008-01-01','YYYY-MM-DD') + rownum-1  wed
               from tvmtable
              where rownum <= ceil(to_date('2012-01-01','YYYY-MM-DD') - to_date('2008-01-01','YYYY-MM-DD')) )
     where to_char( to_date('2008-01-01','YYYY-MM-DD') + rnum-1, 'D' ) 
                in ('1')
       ),
(select rownum num from user_tables where rownum <= 21)
where not exists 
        ( select 1 from mbta_holiday
          where holiday_date = to_date(we_date+(num+2)/24, 'mm/dd/yyyy hh24:mi:ss')
        )

union all
select to_date((trunc(we_date)+1)+(num-1)/24, 'mm/dd/yyyy hh24:mi:ss'), 'SUNDAY'
from (select wed  we_date--into v_weekends                   --	Count Weekends only
      from ( select rownum rnum, to_date('2008-01-01','YYYY-MM-DD') + rownum-1  wed
               from tvmtable
              where rownum <= ceil(to_date('2012-01-01','YYYY-MM-DD') - to_date('2008-01-01','YYYY-MM-DD')) )
     where to_char( to_date('2008-01-01','YYYY-MM-DD') + rnum-1, 'D' ) 
                in ('1')),
(select rownum num from user_tables where rownum <= 3)
where not exists 
        ( select 1 from mbta_holiday
          where holiday_date = to_date((trunc(we_date)+1)+(num-1)/24, 'mm/dd/yyyy hh24:mi:ss')
          )

commit

 --===============>insert Saturdays into holiday table

INSERT INTO MBTA_HOLIDAY(HOLIDAY_DATE, HOLIDAY_DESCRIPTION)                     
select to_date(we_date+(num+2)/24, 'mm/dd/yyyy hh24:mi:ss') hd , 'SATURDAY'
from (select wed we_date --into v_weekends                   --	Count Weekends only
      from ( select rownum rnum, to_date('2008-01-01','YYYY-MM-DD') + rownum-1  wed
               from tvmtable
              where rownum <= ceil(to_date('2012-01-01','YYYY-MM-DD') - to_date('2008-01-01','YYYY-MM-DD')) )
     where to_char( to_date('2008-01-01','YYYY-MM-DD') + rnum-1, 'D' ) 
                in ('7')
       ),
(select rownum num from user_tables where rownum <= 21)
where not exists 
        ( select 1 from mbta_holiday
          where holiday_date = to_date(we_date+(num+2)/24, 'mm/dd/yyyy hh24:mi:ss')
        )        
UNION ALL
select to_date((trunc(we_date)+1)+(num-1)/24, 'mm/dd/yyyy hh24:mi:ss'), 'SATURDAY'
from (select wed  we_date--into v_weekends                   --	Count Weekends only
      from ( select rownum rnum, to_date('2008-01-01','YYYY-MM-DD') + rownum-1  wed
               from tvmtable
              where rownum <= ceil(to_date('2012-01-01','YYYY-MM-DD') - to_date('2008-01-01','YYYY-MM-DD')) )
     where to_char( to_date('2008-01-01','YYYY-MM-DD') + rnum-1, 'D' ) 
                in ('7')),
(select rownum num from user_tables where rownum <= 3)
where not exists 
        ( select 1 from mbta_holiday
          where holiday_date = to_date((trunc(we_date)+1)+(num-1)/24, 'mm/dd/yyyy hh24:mi:ss')
        )

        
commit        

delete from mbta_holiday where holiday_date in
(
select to_date((trunc(we_date)+1)+(num-1)/24, 'mm/dd/yyyy hh24:mi:ss')
from (select wed  we_date--into v_weekends                   --	Count Weekends only
      from ( select rownum rnum, to_date('2008-01-01','YYYY-MM-DD') + rownum-1  wed
               from tvmtable
              where rownum <= ceil(to_date('2012-01-01','YYYY-MM-DD') - to_date('2008-01-01','YYYY-MM-DD')) )
     where to_char( to_date('2008-01-01','YYYY-MM-DD') + rnum-1, 'D' ) 
                in ('7')),
(select rownum num from user_tables where rownum <= 3)
)

delete  from mbta_holiday where to_char(holiday_date, 'yyyy') = '2008'

commit


---====================> Check from holiday table if the sunday date is already present because it was a holiday. Change 1 to 7 to check for Saturday same condition.
select * from mbta_holiday,
(
select to_date(we_date+(num+2)/24, 'mm/dd/yyyy hh24:mi:ss') hd , 'SUNDAY'
from (select wed we_date --into v_weekends                   --	Count Weekends only
      from ( select rownum rnum, to_date('2008-01-01','YYYY-MM-DD') + rownum-1  wed
               from tvmtable
              where rownum <= ceil(to_date('2012-01-01','YYYY-MM-DD') - to_date('2008-01-01','YYYY-MM-DD')) )
     where to_char( to_date('2008-01-01','YYYY-MM-DD') + rnum-1, 'D' ) 
                in ('1')
       ),
(select rownum num from user_tables where rownum <= 21)
where not exists 
        ( select 1 from mbta_holiday
          where holiday_date = to_date(we_date+(num+2)/24, 'mm/dd/yyyy hh24:mi:ss')
        )
)
where hd = holiday_date