select * from holiday_mbta

insert into holiday_mbta(dateis)
select to_date('02-01-2007 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual

commit
sele

delete from holiday_mbta where dateis = to_date('01-31-2007', 'mm-dd-yyyy')

select * from reportparameter where listid = 790  




select * from tempresult_mbta

select * from mbta_holiday

alter table add column holiday_schedule to mbta_holiday


ALTER TABLE mbta_holiday
ADD holiday_schedule varchar2(1)

update mbta_holiday 
set holiday_description = 'Monday December 26th 2011 is a Holiday Schedule as December 25th 2011 is a Sunday', holiday_schedule = 'Y'
--where to_char(holiday_date, 'MON') = 'OCT'
where to_char(holiday_date, 'MON') = 'DEC'
and holiday_schedule is null

commit

to_char(holiday_date, 'MON-DD') = 'JAN-01' 

select * from mbta_holiday where to_char(holiday_date, 'MON') = 'DEC' and holiday_schedule is null

select * from mbta_holiday where to_char(holiday_date, 'MON') = 'JUN'

select holiday_date, to_char(holiday_date, 'D') from mbta_holiday where to_char(holiday_date, 'MON-DD') = 'JUL-04' 

select holiday_date, to_char(holiday_date, 'D') from mbta_holiday where to_char(holiday_date, 'MON') = 'JUL'

commit



select 'select to_date(''' || to_char(holiday_date, 'mm/dd/yyyy') ||''', ''mm/dd/yyyy'' ), ''' ||holiday_description||''' , '''||weekend_schedule||''' from dual union all' 
from mbta_holiday order by holiday_description, holiday_date