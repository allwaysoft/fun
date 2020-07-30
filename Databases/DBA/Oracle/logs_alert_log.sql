/******--css logs for node eviction *******/
--1. css agent logs
--2. css server logs
--and some others


https://forums.oracle.com/forums/thread.jspa?threadID=2354037&tstart=4798

create view sys.mbta_alert_log as select  * from sys.x$dbgalertext;
  
  
select inst_id, host_id, message_type, message_level, ORIGINATING_TIMESTAMP, message_text 
from v$diag_alert_ext
where 1=1
--and (MESSAGE_TEXT like '%ORA-%' or upper(MESSAGE_TEXT) like '%ERROR%')
  and cast(ORIGINATING_TIMESTAMP as DATE) > trunc(sysdate) - 1
--message_type in (2,3,4) --Incident_Error, Error, Warning
order by ORIGINATING_TIMESTAMP desc;


select * from v$diag_info


-- below solution might not work on Standby DB as it is open only in ready only mode and we cannot create or execute procedures in Standby read only DB.

select cast(ORIGINATING_TIMESTAMP as DATE) ddt, substr(MESSAGE_TEXT, 1, 300) message_text, count(*) cnt
  from sys.mbta_alert_log
  where (MESSAGE_TEXT like '%ORA-%' or upper(MESSAGE_TEXT) like '%ERROR%')
  and cast(ORIGINATING_TIMESTAMP as DATE) > trunc(sysdate) - 1
  group by substr(MESSAGE_TEXT, 1, 300), cast(ORIGINATING_TIMESTAMP as DATE)
  order by cast(ORIGINATING_TIMESTAMP as DATE);

select * from v$instance


select * from DBA_THRESHOLDS;	--Lists the threshold settings defined for the instance

select * from DBA_OUTSTANDING_ALERTS;	--Describes the outstanding alerts in the database

select * from DBA_ALERT_HISTORY;	--Lists a history of alerts that have been cleared

select * from gV$ALERT_TYPES;--Provides information such as group and type for each alert

select * from gV$METRICNAME;	--Contains the names, identifiers, and other information about the system metrics

select * from gV$METRIC;	--Contains system-level metric values

select * from gV$METRIC_HISTORY;	--Contains a history of system-level metric values


------------------------------------------------------------------------------------------
--***************
--***************
--***************
------------------------------------------------------------------------------------------

CREATE OR REPLACE procedure DBADMIN.mbta_sp_db_size_insert(P_SENDER IN VARCHAR2
                                                                                           , P_RECEPIENT IN VARCHAR2
                                                                                           , P_REPLY_TO IN VARCHAR2
                                                                                           , P_DAYS_TO_CHECK number)
is
--------------------------------------------------------------------------------
-- Procedure: mbta_sp_alert_log_monitor
-- Procedure to email the alert log errors
-- Creation :    10-15-2012, Kranthi Pabba
-- Purpose  :    Inserts data into mbta_db_size_hist table
-- Input    :   
-- Return   :    Data in mbta_db_size_hist table
--------------------------------------------------------------------------------
-- Change:
--------------------------------------------------------------------------------
TYPE CUR_REF IS  REF CURSOR;

MAX_STRING        VARCHAR2(32767);
CUR_VAR             CUR_REF;
CRLF                    VARCHAR2(2):= CHR(13) || CHR(10);
--
V_SQLSTMT         MAX_STRING%TYPE;
TEXT                   MAX_STRING%TYPE;
--
V_EMAIL_SERVER    VARCHAR2(50) := 'smtprelayhs.mbta.com';
V_PORT                  NUMBER := 25;
v_CONN                  UTL_SMTP.CONNECTION;
V_REPLY                 UTL_SMTP.REPLY;

BEGIN

V_SQLSTMT := 'select cast(ORIGINATING_TIMESTAMP as DATE) || ''     '' ||'
      ||' , substr(MESSAGE_TEXT, 1, 300) || ''     '' ||'
      ||' , count(*) message'
      ||' from sys.mbta_alert_log'
      ||' where (MESSAGE_TEXT like ''%ORA-%'' or upper(MESSAGE_TEXT) like ''%ERROR%'')'
      ||' and cast(ORIGINATING_TIMESTAMP as DATE) > trunc(sysdate) - 1'
      ||' group by substr(MESSAGE_TEXT, 1, 300), cast(ORIGINATING_TIMESTAMP as DATE)'
      ||' order by cast(ORIGINATING_TIMESTAMP as DATE);'
TEXT := '';
V_LOOP_CNT := 0;

OPEN CUR_VAR FOR V_SQLSTMT;
  LOOP
    FETCH CUR_VAR INTO V_CUR_VALUE1;
    EXIT WHEN CUR_VAR%NOTFOUND;
    TEXT := TEXT
         || CHR(13) || CHR(10)
         || V_CUR_VALUE1;
    V_LOOP_CNT := V_LOOP_CNT+1;
  END LOOP;

  IF V_LOOP_CNT <> 0
  THEN
    UTL_MAIL.SEND_ATTACH_VARCHAR2(SENDER => P_SENDER
                                , RECIPIENTS => P_REPLY_TO
                                , SUBJECT => 'Error Vendor list'
                                , MESSAGE => 'Atached is the list of vendors whose emails were not sent. '
                                          || 'Attached file also has the explanation of why they were not sent.'
                                , ATTACHMENT => TEXT
                                , ATT_INLINE => FALSE
                                , ATT_FILENAME => 'vend_no_email'
                                 );
  END IF;
  
  
  
  
EXCEPTION
  WHEN UTL_SMTP.TRANSIENT_ERROR OR UTL_SMTP.PERMANENT_ERROR THEN
    BEGIN
            UTL_SMTP.CLOSE_DATA(V_CONN);
            UTL_SMTP.QUIT(V_CONN);
            V_LOOP_CNT :=0;
            V_ERR_MSG := V_ERR_MSG || SUBSTR(SQLERRM, 1, 500-LENGTH(V_ERR_MSG));
            INSERT INTO DA1.VENDOR_DIRDEP_EMAIL(VDE_VEN_CODE
                                              , VDE_EMAIL_ID
                                              , VDE_STATUS
                                              , VDE_PROCESS_DATE
                                              , VDE_DESCRIPTION
                                              , VDE_CHECK_NUM
                                               )
                VALUES (CUR_VEN_MAST_REC.VENDOR
                      , RECEPIENT
                      , 'NOT SENT'
                      , TO_DATE(TO_CHAR(SYSDATE, 'DD-MON-YY HH:MI:SS'), 'DD-MON-YY HH:MI:SS')
                      , V_ERR_MSG
                      , CUR_VEN_MAST_REC.JFAPM_CHQ_NUM                      
                       );
  COMMIT;
end;
/  
  
  