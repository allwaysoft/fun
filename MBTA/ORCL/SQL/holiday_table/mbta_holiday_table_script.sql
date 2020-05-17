CREATE TABLE "MBTA"."MBTA_HOLIDAY"
  (
    "HOLIDAY_DATE" DATE NOT NULL ENABLE, 
    "HOLIDAY_DESCRIPTION" VARCHAR2(100 BYTE),
    CONSTRAINT HOLIDAY_DATE_UQ UNIQUE (HOLIDAY_DATE)
  )
/

INSERT INTO MBTA.MBTA_HOLIDAY (HOLIDAY_DATE)
SELECT * from
(
select to_date('01-01-2008 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('01-01-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('01-01-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('01-01-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('01-21-2008 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('01-19-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('01-18-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('01-17-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('02-18-2008 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('02-16-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('02-15-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('02-21-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('04-18-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('04-19-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('04-20-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('04-21-2008 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('05-30-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('05-31-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('05-26-2008 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('06-17-2008 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('06-17-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('06-17-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('06-17-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('07-04-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('07-04-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('07-04-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('07-04-2008 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('07-05-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('07-08-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('09-05-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('09-06-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('09-07-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('09-01-2008 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('10-10-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('10-11-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('10-12-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('10-13-2008 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('11-11-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('11-11-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('11-11-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('11-11-2008 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('11-24-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('11-25-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('11-26-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('11-27-2008 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('11-25-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('11-26-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('11-27-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('11-28-2008 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('12-24-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('12-24-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('12-25-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('12-25-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('12-25-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('12-25-2008 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('12-26-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('12-31-2008 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('12-31-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('12-31-2010 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('12-31-2011 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual    union all
select to_date('05-25-2009 00:00:00', 'mm-dd-yyyy hh24:mi:ss') dateis from dual                                         
) 
/