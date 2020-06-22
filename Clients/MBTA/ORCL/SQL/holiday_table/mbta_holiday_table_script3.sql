set serveroutput on size 1000000

alter session set nls_date_format = "MM-DD-YYYY HH24:MI:SS"
/

CREATE TABLE "MBTA"."MBTA_WEEKEND_SERVICE"
  (
    "SERVICE_DATE" DATE NOT NULL ENABLE, 
    "SERVICE_DESCRIPTION" VARCHAR2(100 BYTE),
    "SERVICE_TYPE" NUMBER(1)
  ) 
TABLESPACE USER_DATA_G
/

comment on column mbta_weekend_service.service_date is 'Stores holiday date by each hour.'
/
comment on column mbta_weekend_service.service_description is 'Stores Service Description.'
/
comment on column mbta_weekend_service.SERVICE_TYPE is 'Stores numbers 1 through 3. 1: Holiday, 2: Saturday, 3: Sunday.'
/

INSERT INTO MBTA.MBTA_WEEKEND_SERVICE
SELECT * from
(
select to_date('12/25/2008', 'mm/dd/yyyy' ), 'Christmas Day' , 0 from dual union all
select to_date('12/25/2009', 'mm/dd/yyyy' ), 'Christmas Day' , 0 from dual union all
select to_date('12/25/2010', 'mm/dd/yyyy' ), 'Christmas Day' , 0 from dual union all
select to_date('12/25/2011', 'mm/dd/yyyy' ), 'Christmas Day' , 0 from dual union all
select to_date('10/13/2008', 'mm/dd/yyyy' ), 'Columbus Day' , 0 from dual union all
select to_date('10/12/2009', 'mm/dd/yyyy' ), 'Columbus Day' , 0 from dual union all
select to_date('10/11/2010', 'mm/dd/yyyy' ), 'Columbus Day' , 0 from dual union all
select to_date('10/10/2011', 'mm/dd/yyyy' ), 'Columbus Day' , 0 from dual union all
select to_date('12/26/2011', 'mm/dd/yyyy' ), 'Day after Christmans' , 0 from dual union all
select to_date('07/05/2010', 'mm/dd/yyyy' ), 'Day after Independence Day' , 0 from dual union all
select to_date('07/04/2008', 'mm/dd/yyyy' ), 'Independence Day' , 0 from dual union all
select to_date('07/04/2009', 'mm/dd/yyyy' ), 'Independence Day' , 0 from dual union all
select to_date('07/04/2010', 'mm/dd/yyyy' ), 'Independence Day' , 0 from dual union all
select to_date('07/04/2011', 'mm/dd/yyyy' ), 'Independence Day' , 0 from dual union all
select to_date('09/01/2008', 'mm/dd/yyyy' ), 'Labor Day' , 0 from dual union all
select to_date('09/07/2009', 'mm/dd/yyyy' ), 'Labor Day' , 0 from dual union all
select to_date('09/06/2010', 'mm/dd/yyyy' ), 'Labor Day' , 0 from dual union all
select to_date('09/05/2011', 'mm/dd/yyyy' ), 'Labor Day' , 0 from dual union all
select to_date('01/21/2008', 'mm/dd/yyyy' ), 'MLK Day' , 0 from dual union all
select to_date('01/19/2009', 'mm/dd/yyyy' ), 'MLK Day' , 0 from dual union all
select to_date('01/18/2010', 'mm/dd/yyyy' ), 'MLK Day' , 0 from dual union all
select to_date('01/17/2011', 'mm/dd/yyyy' ), 'MLK Day' , 0 from dual union all
select to_date('05/26/2008', 'mm/dd/yyyy' ), 'Memorial Day' , 0 from dual union all
select to_date('05/25/2009', 'mm/dd/yyyy' ), 'Memorial Day' , 0 from dual union all
select to_date('05/31/2010', 'mm/dd/yyyy' ), 'Memorial Day' , 0 from dual union all
select to_date('05/30/2011', 'mm/dd/yyyy' ), 'Memorial Day' , 0 from dual union all
select to_date('01/01/2008', 'mm/dd/yyyy' ), 'New Year''s Day' , 0 from dual union all
select to_date('01/01/2009', 'mm/dd/yyyy' ), 'New Year''s Day' , 0 from dual union all
select to_date('01/01/2010', 'mm/dd/yyyy' ), 'New Year''s Day' , 0 from dual union all
select to_date('01/01/2011', 'mm/dd/yyyy' ), 'New Year''s Day' , 0 from dual union all
select to_date('04/21/2008', 'mm/dd/yyyy' ), 'Patriot''s Day' , 0 from dual union all
select to_date('04/20/2009', 'mm/dd/yyyy' ), 'Patriot''s Day' , 0 from dual union all
select to_date('04/19/2010', 'mm/dd/yyyy' ), 'Patriot''s Day' , 0 from dual union all
select to_date('04/18/2011', 'mm/dd/yyyy' ), 'Patriot''s Day' , 0 from dual union all
select to_date('02/18/2008', 'mm/dd/yyyy' ), 'President''s Day' , 0 from dual union all
select to_date('02/16/2009', 'mm/dd/yyyy' ), 'President''s Day' , 0 from dual union all
select to_date('02/15/2010', 'mm/dd/yyyy' ), 'President''s Day' , 0 from dual union all
select to_date('02/21/2011', 'mm/dd/yyyy' ), 'President''s Day' , 0 from dual union all
select to_date('11/27/2008', 'mm/dd/yyyy' ), 'Thanksgiving Day' , 0 from dual union all
select to_date('11/26/2009', 'mm/dd/yyyy' ), 'Thanksgiving Day' , 0 from dual union all
select to_date('11/25/2010', 'mm/dd/yyyy' ), 'Thanksgiving Day' , 0 from dual union all
select to_date('11/24/2011', 'mm/dd/yyyy' ), 'Thanksgiving Day' , 0 from dual
) 
/
------------
insert into MBTA.MBTA_WEEKEND_SERVICE                
select to_date((service_date+(num+2)/24), 'mm/dd/yyyy hh24:mi:ss') hd , SERVICE_DESCRIPTION hdes, 1
from MBTA.MBTA_WEEKEND_SERVICE,
(select rownum num from user_tables where rownum <= 21)
union all
select to_date(((trunc(service_date)+1)+(num-1)/24), 'mm/dd/yyyy hh24:mi:ss'), SERVICE_DESCRIPTION, 1
from MBTA.MBTA_WEEKEND_SERVICE,
(select rownum num from user_tables where rownum <= 3)
where trunc(service_date)+1 not in (select trunc(service_date) from MBTA.MBTA_WEEKEND_SERVICE)
/
--------------
delete from mbta_weekend_service where SERVICE_TYPE = 0
/
--------------
delete from MBTA_WEEKEND_SERVICE where to_char(service_date, 'yyyy') = '2008'
/
---------------
CREATE UNIQUE INDEX MBTA.PK_MBTA_WEEKEND_SERVICE_DATE ON MBTA.MBTA_WEEKEND_SERVICE
(SERVICE_DATE)
TABLESPACE USER_DATA_G
/
------------
ALTER TABLE MBTA.MBTA_WEEKEND_SERVICE ADD (
  CONSTRAINT CK_MBTA_WEEKWND_SERVICE_TYPE
  CHECK (SERVICE_TYPE in (1,2,3)),
  CONSTRAINT PK_MBTA_WEEKEND_SERVICE_DATE
  PRIMARY KEY
  (SERVICE_DATE)
  USING INDEX MBTA.PK_MBTA_WEEKEND_SERVICE_DATE)
/
 --===============>insert Saturdays into holiday table
INSERT INTO MBTA.MBTA_WEEKEND_SERVICE
select to_date(we_date+(num+2)/24, 'mm/dd/yyyy hh24:mi:ss') hd , 'SATURDAY', 2
from (select wed we_date --into v_weekends                   --	Count Weekends only
      from ( select rownum rnum, to_date('2009-01-01','YYYY-MM-DD') + rownum-1  wed
               from tvmtable
              where rownum <= ceil(to_date('2012-01-01','YYYY-MM-DD') - to_date('2009-01-01','YYYY-MM-DD')) )
     where to_char( to_date('2009-01-01','YYYY-MM-DD') + rnum-1, 'D' ) 
                in ('7')
       ),
(select rownum num from user_tables where rownum <= 21)
where not exists 
        ( select 1 from MBTA.MBTA_WEEKEND_SERVICE
          where service_date = to_date(we_date+(num+2)/24, 'mm/dd/yyyy hh24:mi:ss')
        )        
UNION ALL
select to_date((trunc(we_date)+1)+(num-1)/24, 'mm/dd/yyyy hh24:mi:ss'), 'SATURDAY', 2
from (select wed  we_date--into v_weekends                   --	Count Weekends only
      from ( select rownum rnum, to_date('2009-01-01','YYYY-MM-DD') + rownum-1  wed
               from tvmtable
              where rownum <= ceil(to_date('2012-01-01','YYYY-MM-DD') - to_date('2009-01-01','YYYY-MM-DD')) )
     where to_char( to_date('2009-01-01','YYYY-MM-DD') + rnum-1, 'D' ) 
                in ('7')),
(select rownum num from user_tables where rownum <= 3)
where not exists 
        ( select 1 from MBTA.MBTA_WEEKEND_SERVICE
          where service_date = to_date((trunc(we_date)+1)+(num-1)/24, 'mm/dd/yyyy hh24:mi:ss')
        )
/
--=========>insert Sundays into holiday table
INSERT INTO MBTA.MBTA_WEEKEND_SERVICE
select to_date(we_date+(num+2)/24, 'mm/dd/yyyy hh24:mi:ss') hd , 'SUNDAY',3
from (select wed we_date --into v_weekends                   --	Count Weekends only
      from ( select rownum rnum, to_date('2009-01-01','YYYY-MM-DD') + rownum-1  wed
               from tvmtable
              where rownum <= ceil(to_date('2012-01-01','YYYY-MM-DD') - to_date('2009-01-01','YYYY-MM-DD')) )
     where to_char( to_date('2009-01-01','YYYY-MM-DD') + rnum-1, 'D' ) 
                in ('1')
       ),
(select rownum num from user_tables where rownum <= 21)
where not exists 
        ( select 1 from MBTA.MBTA_WEEKEND_SERVICE
          where service_date = to_date(we_date+(num+2)/24, 'mm/dd/yyyy hh24:mi:ss')
        )
union all
select to_date((trunc(we_date)+1)+(num-1)/24, 'mm/dd/yyyy hh24:mi:ss'), 'SUNDAY',3
from (select wed  we_date--into v_weekends                   --	Count Weekends only
      from ( select rownum rnum, to_date('2009-01-01','YYYY-MM-DD') + rownum-1  wed
               from tvmtable
              where rownum <= ceil(to_date('2012-01-01','YYYY-MM-DD') - to_date('2009-01-01','YYYY-MM-DD')) )
     where to_char( to_date('2009-01-01','YYYY-MM-DD') + rnum-1, 'D' ) 
                in ('1')),
(select rownum num from user_tables where rownum <= 3)
where not exists 
        ( select 1 from MBTA.MBTA_WEEKEND_SERVICE
          where service_date = to_date((trunc(we_date)+1)+(num-1)/24, 'mm/dd/yyyy hh24:mi:ss')
        )
/
-------------------------
delete from MBTA_WEEKEND_SERVICE where to_char(service_date, 'mon yyyy') = 'jan 2009'
/
delete from MBTA_WEEKEND_SERVICE where to_char(service_date, 'mon yyyy') = 'feb 2009'
/
delete from MBTA_WEEKEND_SERVICE where to_char(service_date, 'mon yyyy') = 'mar 2009'
/
delete from MBTA_WEEKEND_SERVICE where to_char(service_date, 'mon yyyy') = 'apr 2009'
/
delete from MBTA_WEEKEND_SERVICE where to_char(service_date, 'mon yyyy') = 'may 2009'
/
delete from MBTA_WEEKEND_SERVICE where to_char(service_date, 'mon yyyy') = 'jun 2009'
/

select count(1) from mbta.mbta_weekend_service
/