DECLARE
  X NUMBER;
BEGIN
  SYS.DBMS_JOB.SUBMIT
  ( job       => X 
   ,what      => 'SP_EMAIL_ACTIONLIST_TRNS_MBTA(6);'
   ,next_date => sysdate
   ,interval  => '/*15:mnts*/ sysdate+1/24/60*15'
   ,no_parse  => FALSE
  );
  SYS.DBMS_OUTPUT.PUT_LINE('Job Number is: ' || to_char(x));
COMMIT;
END; 
/
