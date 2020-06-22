create table MBTA_WEEKEND_SERVICE1 as
SELECT * from
(
select to_date('12/25/2009', 'mm/dd/yyyy' ) service_date, 'Christmas Day' service_description, 0 service_type,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') service_day_of_year from dual union all
select to_date('12/25/2010', 'mm/dd/yyyy' ), 'Christmas Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('12/25/2011', 'mm/dd/yyyy' ), 'Christmas Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('10/12/2009', 'mm/dd/yyyy' ), 'Columbus Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('10/11/2010', 'mm/dd/yyyy' ), 'Columbus Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('10/10/2011', 'mm/dd/yyyy' ), 'Columbus Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('12/26/2011', 'mm/dd/yyyy' ), 'Day after Christmas' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('07/05/2010', 'mm/dd/yyyy' ), 'Day after Independence Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('07/04/2009', 'mm/dd/yyyy' ), 'Independence Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('07/04/2010', 'mm/dd/yyyy' ), 'Independence Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('07/04/2011', 'mm/dd/yyyy' ), 'Independence Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('09/07/2009', 'mm/dd/yyyy' ), 'Labor Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('09/06/2010', 'mm/dd/yyyy' ), 'Labor Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('09/05/2011', 'mm/dd/yyyy' ), 'Labor Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('01/19/2009', 'mm/dd/yyyy' ), 'MLK Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('01/18/2010', 'mm/dd/yyyy' ), 'MLK Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('01/17/2011', 'mm/dd/yyyy' ), 'MLK Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('05/25/2009', 'mm/dd/yyyy' ), 'Memorial Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('05/31/2010', 'mm/dd/yyyy' ), 'Memorial Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('05/30/2011', 'mm/dd/yyyy' ), 'Memorial Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('01/01/2009', 'mm/dd/yyyy' ), 'New Year''s Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('01/01/2010', 'mm/dd/yyyy' ), 'New Year''s Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('01/01/2011', 'mm/dd/yyyy' ), 'New Year''s Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('04/20/2009', 'mm/dd/yyyy' ), 'Patriot''s Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('04/19/2010', 'mm/dd/yyyy' ), 'Patriot''s Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('04/18/2011', 'mm/dd/yyyy' ), 'Patriot''s Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('02/16/2009', 'mm/dd/yyyy' ), 'President''s Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('02/15/2010', 'mm/dd/yyyy' ), 'President''s Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('02/21/2011', 'mm/dd/yyyy' ), 'President''s Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('11/26/2009', 'mm/dd/yyyy' ), 'Thanksgiving Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('11/25/2010', 'mm/dd/yyyy' ), 'Thanksgiving Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual union all
select to_date('11/24/2011', 'mm/dd/yyyy' ), 'Thanksgiving Day' , 0,to_char(to_date('12/25/2009','mm/dd/yyyy'), 'd' )||'-'||to_char(to_date('12/25/2009','mm/dd/yyyy'), 'yyyy') from dual
) 


select * from mbta_weekend_service1

drop table mbta_weekend_service1

create table mbta_weekend_service1 as
select trunc(service_date) service_date
        ,service_description
        ,to_char(service_date,'ddd') service_day
        ,to_char(service_date,'mm') service_month
        ,to_char(service_date,'yyyy')service_year
from MBTA_WEEKEND_SERVICE 
where service_type = 1 and To_Char(service_Date,'HH24') = '01'
    