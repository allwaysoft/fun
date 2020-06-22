/*
DECLARE
BEGIN
dbms_job.submit(
l_jobno,
'BEGIN XX_VOUCH_SUM( trunc( add_months( sysdate, -1 ), ''MM'' ), last_day(add_months( trunc(sysdate), -1)));END;',
 trunc( add_months( sysdate, 1 ), 'MM' ),
'trunc( add_months( sysdate, 1 ), ''MM'')' ) ;
END;
*/
DECLARE
  X NUMBER;
BEGIN
  SYS.DBMS_JOB.SUBMIT
  ( job       => X 
   ,what      => 'sp_email_police_info_mbta;'
   ,next_date => trunc( add_months( sysdate, 1 ), 'MM' )
   ,interval  => '/*1:mnth*/ trunc( add_months( sysdate, 1 ), ''MM'')'
   ,no_parse  => FALSE
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Job Number is: ' || to_char(x));
COMMIT;
END; 