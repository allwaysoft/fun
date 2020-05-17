CREATE OR REPLACE PROCEDURE MBTA.SP_EMAIL_ACTIONLIST_TRNS_MBTA(P_TRANS_TIME_DIFF NUMBER)
IS
V_RECENT_TRANS_TIME DATE;
V_TRANS_TIME_DIFF NUMBER;
crlf varchar2(2):= chr(13) || chr(10);

TYPE email_type is table of varchar2(32000) index by binary_integer;
v_email_val email_type;

cursor email_cur is 
select mel.mel_email_id email_id
from mbta_email_list mel , mbta_email_object_ref meor
where mel.mel_emp_id = meor.meor_emp_id
and mel_emp_status = 'A'
and MEOR.MEOR_OBJECT_OWNER = sys_context('USERENV', 'SESSION_USER')
and MEOR.MEOR_OBJECT_NAME = 'SP_EMAIL_ACTIONLIST_TRNS_MBTA';

BEGIN

-- This Procedure takes a number as input parameter,it will be considered as number of hours.
-- If there hasn't been a transaction with in that number of hours, an email will be sent out raising an alert.
-- This procedure is scheduled to run every 15 mins, checking for the transactions in the table.

V_TRANS_TIME_DIFF := P_TRANS_TIME_DIFF;

SELECT MAX(TIMENEW) INTO V_RECENT_TRANS_TIME
FROM ACTIONLIST
WHERE USERNEW = 'OrderExecuter';

IF (SYSDATE-V_RECENT_TRANS_TIME)*24 > V_TRANS_TIME_DIFF
THEN

select mel.mel_email_id into v_email_val(1) from mbta_email_list mel where mel.mel_emp_id='DATABASE';

FOR email_rec IN email_cur
   LOOP
      if email_cur%rowcount = 1
      then
      v_email_val(2) := email_rec.email_id;
      else
      v_email_val(2) := v_email_val(2) || ',' || email_rec.email_id;
      end if;
   END LOOP;

v_email_val(3) := 'Alert: No "OrderExecuter" Transaction in ACTIONLIST Table, in the past ' || V_TRANS_TIME_DIFF || ' Hrs!';
v_email_val(4) := 'Hi, '
                  || crlf || crlf
                  ||'Please be advised that the last "Order Executer" transaction inserted in to ACTIONLIST table in production AFC CCS DB was at '
                  ||to_char(V_RECENT_TRANS_TIME, 'mm-dd-yyyy hh:mi:ss AM')
                  ||'.'
                  || crlf || crlf
                  ||'Reply to this email for any further questions.'
                  || crlf || crlf
                  ||'Thanks! ';

send_mail_mbta(v_email_val(1),v_email_val(2),v_email_val(3),v_email_val(4));

--dbms_output.put_line(v_email_val(2));

ELSE
NULL;
END IF;

exception
 when others
 then
   raise_application_error(-20001,  substr(sqlerrm, 1, 2048-20));
END;
/