SELECT sysrecno,
       sysaccess,
       TO_CHAR (mea_date, 'YYYYMMDD'),
       trip_id,
       original_trip_no,
       route_id,
       direction,
       block_id,
       stop_rank,
       stop_id,
       scheduled_time,
       mea_arr_time,
       mea_dep_time,
       nb_boarding,
       nb_debarking,
       passenger_load,
       mea_is_mandatory,
       mea_source,
       mea_location,
       chk_assignment,
       chk_comment,
       chk_weather,
       mea_nb_passenger_left,
       TO_CHAR (chk_assignment_date, 'YYYYMMDD'),
       chk_checker,
       chk_vehicle,
       chk_fare_box_amount,
       chk_assignment_type,
       ud_operator_id
  FROM HASTUS_MEASURE
 WHERE     route_id = :route_id
       AND mea_date = TO_DATE (:mea_date, 'YYYYMMDD')
       AND trip_id = :trip_id
       AND original_trip_no = :original_trip_no
       AND mea_location = :mea_location
       AND scheduled_time = :scheduled_time
       AND mea_source = :mea_source
       AND ROWNUM = 1
	   
	   
	   
SELECT sysrecno,
       sysaccess,
       TO_CHAR (mea_date, 'YYYYMMDD'),
       trip_id,
       original_trip_no,
       route_id,
       direction,
       block_id,
       stop_rank,
       stop_id,
       scheduled_time,
       mea_arr_time,
       mea_dep_time,
       nb_boarding,
       nb_debarking,
       passenger_load,
       mea_is_mandatory,
       mea_source,
       mea_location,
       chk_assignment,
       chk_comment,
       chk_weather,
       mea_nb_passenger_left,
       TO_CHAR (chk_assignment_date, 'YYYYMMDD'),
       chk_checker,
       chk_vehicle,
       chk_fare_box_amount,
       chk_assignment_type,
       ud_operator_id
  FROM HASTUS_MEASURE
 WHERE     route_id = :route_id
       AND mea_date = TO_DATE (:mea_date, 'YYYYMMDD')
       AND trip_id = :trip_id
       AND original_trip_no IS NULL
       AND mea_location = :mea_location
       AND scheduled_time = :scheduled_time
       AND mea_source = :mea_source
       AND ROWNUM = 1


	   
SELECT sysrecno,
       sysaccess,
       TO_CHAR (mea_date, 'YYYYMMDD'),
       trip_id,
       original_trip_no,
       route_id,
       direction,
       block_id,
       stop_rank,
       stop_id,
       scheduled_time,
       mea_arr_time,
       mea_dep_time,
       nb_boarding,
       nb_debarking,
       passenger_load,
       mea_is_mandatory,
       mea_source,
       mea_location,
       chk_assignment,
       chk_comment,
       chk_weather,
       mea_nb_passenger_left,
       TO_CHAR (chk_assignment_date, 'YYYYMMDD'),
       chk_checker,
       chk_vehicle,
       chk_fare_box_amount,
       chk_assignment_type,
       ud_operator_id
  FROM HASTUS_MEASURE
 WHERE     route_id = :route_id
       AND mea_date = TO_DATE (:mea_date, 'YYYYMMDD')
       AND trip_id IS NULL
       AND original_trip_no = :original_trip_no
       AND mea_location = :mea_location
       AND scheduled_time = :scheduled_time
       AND mea_source = :mea_source
       AND ROWNUM = 1

*****************************************************************************************
-- How to create outlines
-- http://www.oracle-base.com/articles/misc/outlines.php

-- First find the SQLID of the SQL
SELECT sql_id, sql_fulltext, PLAN_HASH_VALUE, first_load_time,PARSE_CALLS ,EXECUTIONS ,USERS_EXECUTING, sql_text 
FROM V$SQL 
WHERE SQL_TEXT LIKE 'SELECT DISTINCT B.BUSINESS_UNIT, B.DEPTID, A.EMPLID, D.NAME_PSFORMAT, D.SEX, TO_CHAR(D.BIRTHDATE,%'
order by first_load_time desc, sql_text asc

-- Use the SQLID from above output to find the execution plan
select * from table(dbms_xplan.display_cursor('88647kpghcx13',0))  

--------- Then do below to create a baseline
ALTER SESSION SET query_rewrite_enabled=TRUE;
ALTER SESSION SET use_stored_outlines=SCOTT_OUTLINES;
	   
	   
CREATE OUTLINE hastus_measure3  --FOR CATEGORY HASTUS_OUTLINES
ON 
SELECT sysrecno,sysaccess,TO_CHAR(mea_date,'YYYYMMDD'),trip_id,
  original_trip_no,route_id,direction,block_id,stop_rank,stop_id,
  scheduled_time,mea_arr_time,mea_dep_time,nb_boarding,nb_debarking,
  passenger_load,mea_is_mandatory,mea_source,mea_location,chk_assignment,
  chk_comment,chk_weather,mea_nb_passenger_left,TO_CHAR(chk_assignment_date,
  'YYYYMMDD'),chk_checker,chk_vehicle,chk_fare_box_amount,chk_assignment_type,
  ud_operator_id 
FROM HASTUS_MEASURE 
WHERE route_id = :route_id 
AND mea_date = TO_DATE(:mea_date,'YYYYMMDD') 
AND trip_id IS NULL 
AND original_trip_no = :original_trip_no 
AND mea_location = :mea_location 
AND scheduled_time = :scheduled_time 
AND mea_source = :mea_source AND ROWNUM = 1
------------
CREATE OUTLINE hastus_measure2 --FOR CATEGORY HASTUS_OUTLINES  
ON  
SELECT sysrecno,sysaccess,TO_CHAR(mea_date,'YYYYMMDD'),trip_id,
  original_trip_no,route_id,direction,block_id,stop_rank,stop_id,
  scheduled_time,mea_arr_time,mea_dep_time,nb_boarding,nb_debarking,
  passenger_load,mea_is_mandatory,mea_source,mea_location,chk_assignment,
  chk_comment,chk_weather,mea_nb_passenger_left,TO_CHAR(chk_assignment_date,
  'YYYYMMDD'),chk_checker,chk_vehicle,chk_fare_box_amount,chk_assignment_type,
  ud_operator_id 
FROM HASTUS_MEASURE 
WHERE route_id = :route_id 
AND mea_date = TO_DATE(:mea_date,'YYYYMMDD') 
AND trip_id = :trip_id 
AND original_trip_no IS NULL 
AND mea_location = :mea_location 
AND scheduled_time = :scheduled_time 
AND mea_source = :mea_source AND ROWNUM = 1
-------------
CREATE OUTLINE hastus_measure1 --FOR CATEGORY HASTUS_OUTLINES 
ON
SELECT sysrecno,sysaccess,TO_CHAR(mea_date,'YYYYMMDD'),trip_id,
  original_trip_no,route_id,direction,block_id,stop_rank,stop_id,
  scheduled_time,mea_arr_time,mea_dep_time,nb_boarding,nb_debarking,
  passenger_load,mea_is_mandatory,mea_source,mea_location,chk_assignment,
  chk_comment,chk_weather,mea_nb_passenger_left,TO_CHAR(chk_assignment_date,
  'YYYYMMDD'),chk_checker,chk_vehicle,chk_fare_box_amount,chk_assignment_type,
  ud_operator_id 
FROM HASTUS_MEASURE 
WHERE route_id = :route_id 
AND mea_date = TO_DATE(:mea_date,'YYYYMMDD') 
AND trip_id = :trip_id 
AND original_trip_no = :original_trip_no 
AND mea_location = :mea_location 
AND scheduled_time = :scheduled_time 
AND mea_source = :mea_source AND ROWNUM = 1	   
-------------
CREATE OUTLINE hastus_measure4  --FOR CATEGORY HASTUS_OUTLINES
ON
SELECT sysrecno,sysaccess,TO_CHAR(mea_date,'YYYYMMDD'),trip_id,original_trip_no,route_id,
direction,block_id,stop_rank,stop_id,scheduled_time,mea_arr_time,mea_dep_time,nb_boarding,
nb_debarking,passenger_load,mea_is_mandatory,mea_source,mea_location,chk_assignment,chk_comment,
chk_weather,mea_nb_passenger_left,TO_CHAR(chk_assignment_date,'YYYYMMDD'),chk_checker,chk_vehicle,
chk_fare_box_amount,chk_assignment_type,ud_operator_id 
FROM HASTUS_MEASURE 
WHERE route_id = :0 
AND mea_date >= TO_DATE(:1, 'YYYYMMDD') 
AND mea_date <= TO_DATE(:2, 'YYYYMMDD') 
ORDER BY mea_date ASC, route_id ASC, original_trip_no ASC, trip_id ASC, stop_rank ASC, mea_source ASC 
	   
*****************************************************************************************

CREATE INDEX GIRO.HASTUS_MEASURE_IDXB ON GIRO.HASTUS_MEASURE
(NLSSORT("ROUTE_ID",'nls_sort=''PUNCTUATION'''), NLSSORT("TRIP_ID",'nls_sort=''PUNCTUATION'''), ORIGINAL_TRIP_NO)
LOGGING
TABLESPACE GIRO
PCTFREE    10
INITRANS   2
MAXTRANS   255
STORAGE    (
            INITIAL          4096M
            MINEXTENTS       1
            MAXEXTENTS       UNLIMITED
            PCTINCREASE      0
            BUFFER_POOL      DEFAULT
           )
NOPARALLEL;

	   