CREATE OR REPLACE PACKAGE     CC_UTL_PKG
AS
/*********************************************************************
** Name:    CC_UTL_PKG
** Author:  Kranthi Pabba                  Date:12/14/2009
** Description:
**
** Parameter Description:
**
** Modified By :
*********************************************************************/

  --Global Declarations
  TYPE CUR_REF IS  REF CURSOR;
  MAX_STRING VARCHAR2(32767);

  FUNCTION FORMAT_STRING_FN (P_STRING IN VARCHAR2)
    RETURN VARCHAR2;

  FUNCTION VEN_DIRDEP_EMAIL_FN1 (P_COMP_CODE IN VARCHAR2,
                                 P_SENDER IN VARCHAR2
                               , P_PASSWORD IN VARCHAR2
                               , P_REPLY_TO IN VARCHAR2
                                )
    RETURN VARCHAR2;

  FUNCTION EMP_DIRDEP_EMAIL_FN(P_COMP_CODE IN VARCHAR2,
                                 P_SENDER IN VARCHAR2
                               , P_PASSWORD IN VARCHAR2
                               , P_REPLY_TO IN VARCHAR2
                              )
    RETURN VARCHAR2;
    
END CC_UTL_PKG;

/


CREATE OR REPLACE PACKAGE BODY     CC_UTL_PKG
IS

FUNCTION FORMAT_STRING_FN(P_STRING IN VARCHAR2)
  RETURN VARCHAR2
IS
    LV_STRING      MAX_STRING%TYPE := NULL;
    OV_STRING      MAX_STRING%TYPE := '(';
    LV_POSITION1   NUMBER          := 0;
    V_ERR_MSG      MAX_STRING%TYPE := '';
BEGIN
  V_ERR_MSG := 'P_STRING:' || P_STRING;
  LV_STRING := P_STRING;
  WHILE INSTR (LV_STRING, ',') > 0
    LOOP
      LV_POSITION1 := INSTR (LV_STRING, ',');
      OV_STRING :=
        OV_STRING || ''''
                  || SUBSTR (LV_STRING, 1, LV_POSITION1 - 1)
                  || ''',';
      LV_STRING := SUBSTR (LV_STRING, LV_POSITION1 + 1);
    END LOOP;

  OV_STRING := OV_STRING || '''' || LV_STRING || ''')';

  RETURN (OV_STRING);

  EXCEPTION
    WHEN OTHERS
      THEN
        RAISE_APPLICATION_ERROR(-20002,  V_ERR_MSG || '-' || SQLERRM);
        --RETURN (SQLERRM||' - '||V_ERR_MSG);

END FORMAT_STRING_FN;

----------------------------------------------------------------------------------------

FUNCTION VEN_DIRDEP_EMAIL_FN1 (P_COMP_CODE IN VARCHAR2,
                               P_SENDER IN VARCHAR2
                             , P_PASSWORD IN VARCHAR2
                             , P_REPLY_TO IN VARCHAR2
                              )
  RETURN VARCHAR2
IS
PRAGMA AUTONOMOUS_TRANSACTION;

P_EMAIL_SERVER    VARCHAR2(50) := 'mail.caddell.com';

V_SQLSTMT         MAX_STRING%TYPE;
CUR_VAR           CUR_REF;
V_LOOP_CNT        NUMBER := 0;
V_CUR_VALUE       MAX_STRING%TYPE;
V_CUR_VALUE1      MAX_STRING%TYPE;
RECEPIENT         DA.BPVENDORS.BPVEN_PAY_EMAIL%TYPE;
V_ERR_MSG         MAX_STRING%TYPE := '';
V_HEADER_TEXT     MAX_STRING%TYPE;
TEXT              MAX_STRING%TYPE := '';
V_FOTTER_TEXT     MAX_STRING%TYPE;

HEADER_STRING     VARCHAR2(83);
COLUMN_HEADER     VARCHAR2(50);
V_HEADER_L1       HEADER_STRING%TYPE := 'ELECTRONIC FUNDS TRANSFER PAYMENT NOTIFICATION';
V_HEADER_L2       HEADER_STRING%TYPE := 'from';
V_HEADER_L3       HEADER_STRING%TYPE ;         --:= 'Caddell Construction Co., Inc.'
--V_HEADER_L4       HEADER_STRING%TYPE := '';
V_HEADER_L5       HEADER_STRING%TYPE ;
--V_HEADER_L6       HEADER_STRING%TYPE := '';
V_HEADER_L7       HEADER_STRING%TYPE ;
--V_HEADER_L8       HEADER_STRING%TYPE := '';
--V_HEADER_L9       HEADER_STRING%TYPE := 'Invoice Invoice                                     Invoice    Discount     Payment';
--V_HEADER_L10      HEADER_STRING%TYPE := 'Date    Number     Invoice Description               Amount      Amount      Amount';
--V_HEADER_L11      HEADER_STRING%TYPE := '------- ---------- ---------------------------- ----------- ----------- -----------';
V_CHEADER_1      COLUMN_HEADER%TYPE := 'Invoice<BR>Date';
V_CHEADER_2      COLUMN_HEADER%TYPE := 'Invoice<BR>Number';
V_CHEADER_3      COLUMN_HEADER%TYPE := 'Invoice<BR>Description';
V_CHEADER_4      COLUMN_HEADER%TYPE := 'Invoice<BR>Amount';
V_CHEADER_5      COLUMN_HEADER%TYPE := 'Discount<BR>Amount';
V_CHEADER_6      COLUMN_HEADER%TYPE := 'Payment<BR>Amount';

v_CONN            UTL_SMTP.CONNECTION;
V_PORT            NUMBER := 587;
V_REPLY           UTL_SMTP.REPLY;
B_CONNECTED       BOOLEAN := FALSE;
CRLF              VARCHAR2(2):= CHR(13) || CHR(10);

CURSOR CUR_VEN_MAST IS
SELECT JFAPM_PROC_ID || RPAD(RTRIM(JFAPM_MAST_KEY),21) JFAPM_PROC_MAST_KEY
  , JFAPM_CHQ_VEN_CODE                             VENDOR
  , JFAPM_CHQ_VEN_CODE || ' - ' || JFAPM_VEN_NAME1 VENDOR_NUM_DESC
  , JFAPM_CHQ_DATE, JFAPM_CHQ_NUM, C.COMP_CODE COMP_CODE
FROM 	DA.JFAPMAST
    , DA.COMPANY C
    , (SELECT DISTINCT EMAIL.VDE_VEN_CODE VDE_VEN_CODE
                     , EMAIL.VDE_CHECK_NUM
       FROM DA1.VENDOR_DIRDEP_EMAIL EMAIL
       WHERE TRUNC(EMAIL.VDE_PROCESS_DATE ) = TRUNC(SYSDATE)
         AND EMAIL.VDE_STATUS = 'SENT') MAIL
WHERE JFAPM_COMP_CODE = C.COMP_CODE
  AND DA.DBK_AP_PRTCHK_CMETH.F_IsVendor_IN_DistList(jFAPM_COMP_CODE,jFAPM_CHQ_VEN_CODE,0) IS NOT NULL
  AND JFAPM_CHQ_VEN_CODE = MAIL.VDE_VEN_CODE (+)
  AND JFAPM_CHQ_NUM = MAIL.VDE_CHECK_NUM     (+)
  AND MAIL.VDE_VEN_CODE IS NULL;

CUR_VEN_MAST_REC   CUR_VEN_MAST%ROWTYPE;

CURSOR CUR_VEN_DET(PC_JFAPM_MAST_KEY IN VARCHAR2) IS
SELECT JFAPM_PROC_ID
  , RPAD(RTRIM(JFAPM_MAST_KEY),21) JFAPM_MAST_KEY
	, JFAPM_CHQ_VEN_CODE	           INV_VEN_CODE
	, JFAPM_VEN_NAME1	               INV_VEN_NAME
  , JFAPM_CHQ_NUM		               CHQ_NUM
  , JFAPM_CHQ_DATE		             CHQ_DATE
  , JFAPM_ACC_CODE                 ACC_CODE
  , JFAPM_BANK_TRANSIT_NUM         TRANSIT_NUM
  , JFAPM_BANK_ACCOUNT_NUM         ACCOUNT_NUM
  , JFAPM_CHQ_GROSS_AMT            CHQ_GROSS
  , JFAPM_CHQ_AMT			             CHQ_AMT
  , C.COMP_CODE                    C_COMPANY_CODE
  , JFAPD_VOU_INV_CODE	                                            INV_NUM
  , JFAPD_VOU_INV_DATE 	                                            INV_DATE
  , JFAPD_VOU_DESC1  	                                              INV_DESC
	, NVL(JFAPD_VOU_INV_OUTSTAND_AMT,0) + NVL(JFAPD_VOU_HLDBK_AMT,0)  INV_GROSS
  , NVL(JFAPD_VOU_HLDBK_AMT,0) + NVL(JFAPD_VOU_DISC_TAKEN ,0)       DEDUCTION
  , JFAPD_PA_AMT		                                                INV_NET
FROM 	DA.JFAPMAST
    , DA.COMPANY  C
    , DA.JFAPDET  D
WHERE JFAPM_COMP_CODE = C.COMP_CODE
AND JFAPM_PROC_ID = D.JFAPD_PROC_ID
AND RPAD(RTRIM(JFAPM_MAST_KEY),21) = RPAD(RTRIM(D.JFAPD_MAST_KEY),21)
AND D.JFAPD_PROC_ID || RPAD(RTRIM(D.JFAPD_MAST_KEY),21) = PC_JFAPM_MAST_KEY
AND DA.DBK_AP_PRTCHK_CMETH.F_ISVENDOR_IN_DISTLIST(JFAPM_COMP_CODE,JFAPM_CHQ_VEN_CODE,0) IS NOT NULL;

CUR_VEN_DET_REC   CUR_VEN_DET%ROWTYPE;

BEGIN
--DBMS_OUTPUT.PUT_LINE(1);

DELETE FROM DA1.VENDOR_DIRDEP_EMAIL
 WHERE TRUNC(VDE_PROCESS_DATE) <= TRUNC(SYSDATE)-1;
 
COMMIT;
--DBMS_OUTPUT.PUT_LINE(2);

OPEN CUR_VEN_MAST;
  LOOP
    BEGIN

      FETCH CUR_VEN_MAST INTO CUR_VEN_MAST_REC;

      V_CUR_VALUE := CUR_VEN_MAST_REC.JFAPM_PROC_MAST_KEY;
      EXIT WHEN CUR_VEN_MAST%NOTFOUND;
--DBMS_OUTPUT.PUT_LINE(3);

      SELECT NVL(BPVEN_PAY_EMAIL, P_REPLY_TO) INTO RECEPIENT
      FROM DA.BPVENDORS
      WHERE BPVEN_BP_CODE = CUR_VEN_MAST_REC.VENDOR
      AND BPVEN_COMP_CODE = CUR_VEN_MAST_REC.COMP_CODE;
--DBMS_OUTPUT.PUT_LINE(4);
      V_HEADER_L5 := 'Payment Date: ' || CUR_VEN_MAST_REC.JFAPM_CHQ_DATE
                                      || ' Reference: '
                                      || CUR_VEN_MAST_REC.JFAPM_CHQ_NUM;
      V_HEADER_L7 := 'Vendor: ' || CUR_VEN_MAST_REC.VENDOR_NUM_DESC;
      SELECT COMP_NAME INTO V_HEADER_L3 FROM COMPANY WHERE COMP_CODE = P_COMP_CODE;
      
      V_HEADER_TEXT := '';

      V_HEADER_TEXT := '<TABLE WIDTH="100%"> <TR> <TH ALIGN="CENTER">' || V_HEADER_L1 ||'</TH> </TR>'
                    || '<TR> <TH ALIGN="CENTER">' || V_HEADER_L2 ||'</TH> </TR>'
                    || '<TR> <TH ALIGN="CENTER">' || V_HEADER_L3 ||'</TH> </TR>'
                    || '<TR> </TR>'
                    || '<TR> <TD ALIGN="CENTER">' || V_HEADER_L5 ||'</TD> </TR>'
                    || '<TR> </TR>'
                    || '<TR> <TD ALIGN="CENTER">' || V_HEADER_L7 ||'</TD> </TR>'
                    || '<TR> <HR NOSHADE SIZE=1 COLOR=BLACK > </TR>'
                    || '<TR> </TR> </TABLE>'
                    || '<TABLE WIDTH= "100%" ALIGN="CENTER"> <THEAD> <TR> <TH ROWSPAN="2" ALIGN="LEFT">' || V_CHEADER_1 ||'</TH> '
                    || '<TH ROWSPAN="2" ALIGN="LEFT">' || V_CHEADER_2 ||'</TH> ' --BGCOLOR="GRAY"
                    || '<TH ROWSPAN="2" ALIGN="LEFT">' || V_CHEADER_3 ||'</TH> '
                    || '<TH ROWSPAN="2" ALIGN="RIGHT">' || V_CHEADER_4 ||'</TH> '
                    || '<TH ROWSPAN="2" ALIGN="RIGHT">' || V_CHEADER_5 ||'</TH> '
                    || '<TH ROWSPAN="2" ALIGN="RIGHT">' || V_CHEADER_6 ||'</TH> </TR> </THEAD>';

--DBMS_OUTPUT.PUT_LINE(4);

      OPEN CUR_VEN_DET(V_CUR_VALUE);
        LOOP

          FETCH CUR_VEN_DET INTO CUR_VEN_DET_REC;

          V_ERR_MSG := 'VEN_CODE:' || CUR_VEN_DET_REC.INV_VEN_CODE
                                   || ', '
                                   || 'EMAIL:' || RECEPIENT || '--';

          EXIT WHEN CUR_VEN_DET%NOTFOUND;
          IF V_LOOP_CNT = 0
          THEN
            TEXT := '<TR> </TR>' -- Required for correct output in outlook
                 || '<TBODY> <TR> <TD> <HR> </TD> <TD> <HR> </TD> <TD> <HR> </TD> <TD> <HR> </TD> <TD> <HR> </TD> <TD> <HR> </TD> </TR> '
                 || '<TR> <TD>' || CUR_VEN_DET_REC.INV_DATE ||'</TD> '
                 || '<TD>' || CUR_VEN_DET_REC.INV_NUM ||'</TD> '
                 || '<TD>' || CUR_VEN_DET_REC.INV_DESC ||'</TD> '
                 || '<TD ALIGN="RIGHT">' || NVL(TO_CHAR(CUR_VEN_DET_REC.INV_GROSS, '999,999,990.99'), 0.00) ||'</TD> '
                 || '<TD ALIGN="RIGHT">' || NVL(TO_CHAR(CUR_VEN_DET_REC.DEDUCTION, '999,999,990.99'), 0.00) ||'</TD> '
                 || '<TD ALIGN="RIGHT">' || NVL(TO_CHAR(CUR_VEN_DET_REC.INV_NET, '999,999,990.99'), 0.00) ||'</TD> </TR>';
            V_LOOP_CNT := V_LOOP_CNT+1;
          ELSE
            TEXT := TEXT
                 || '<TR> <TD>' || CUR_VEN_DET_REC.INV_DATE ||'</TD> '
                 || '<TD>' || CUR_VEN_DET_REC.INV_NUM ||'</TD> '
                 || '<TD>' || CUR_VEN_DET_REC.INV_DESC ||'</TD> '
                 || '<TD ALIGN="RIGHT">' || NVL(TO_CHAR(CUR_VEN_DET_REC.INV_GROSS, '999,999,990.99'), 0.00) ||'</TD> '
                 || '<TD ALIGN="RIGHT">' || NVL(TO_CHAR(CUR_VEN_DET_REC.DEDUCTION, '999,999,990.99'), 0.00) ||'</TD> '
                 || '<TD ALIGN="RIGHT">' || NVL(TO_CHAR(CUR_VEN_DET_REC.INV_NET, '999,999,990.99'), 0.00) ||'</TD> </TR>';
          END IF;
        END LOOP;

            TEXT := TEXT
                 || '<TR> <TD> <HR> </TD> <TD> <HR> </TD> <TD> <HR> </TD> <TD> <HR> </TD> <TD> <HR> </TD> <TD> <HR> </TD> </TR>'
                 || '<TR> <TD>' || '' ||'</TD> '
                 || '<TD>' || '' ||'</TD> '
                 || '<TD ALIGN="RIGHT">' || 'TOTAL:' ||'</TD> '
                 || '<TD ALIGN="RIGHT">' || '' ||'</TD> ' --NVL(TO_CHAR(CUR_VEN_DET_REC.CHQ_GROSS, '999,999,990.99'), 0.00)
                 || '<TD ALIGN="RIGHT">' || '' ||'</TD> ' --NVL(TO_CHAR(NVL(CUR_VEN_DET_REC.CHQ_GROSS, 0)- NVL(CUR_VEN_DET_REC.CHQ_AMT, 0),'999,999,990.99'), 0.00)
                 || '<TD ALIGN="RIGHT" COLOR=BURGUNDY>' || NVL(TO_CHAR(CUR_VEN_DET_REC.CHQ_AMT, '999,999,990.99'), 0.00) ||'</TD> </TR>';

            TEXT := TEXT
                 || '<TR> <TD>' || 'Reference: ' ||'</TD> '
                 || '<TD>' || CUR_VEN_DET_REC.C_COMPANY_CODE || '*COMP*' || CUR_VEN_MAST_REC.JFAPM_CHQ_NUM ||'</TD> '
                 || '<TD>' || '' ||'</TD> '
                 || '<TD>' || '' ||'</TD> '
                 || '<TD>' || '' ||'</TD> '
                 || '<TD>' || '' ||'</TD> </TR> </TBODY> </TABLE>';

            V_FOTTER_TEXT := 'To be deposited within two working days of the Payment Date posted on this advice. '
                          || 'Please verify receipt of funds with your bank. '
                          || 'If there are any problems with this deposit, '
                          || 'please contact your local Accounting office.';


      CLOSE CUR_VEN_DET;

      IF V_LOOP_CNT <> 0
      THEN

--DBMS_OUTPUT.PUT_LINE(5);

      --open the connection with the smtp server and do the handshake
        V_CONN:= UTL_SMTP.OPEN_CONNECTION(P_EMAIL_SERVER, V_PORT );
        UTL_SMTP.COMMAND(V_CONN, 'AUTH LOGIN');
        UTL_SMTP.COMMAND(V_CONN,UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(P_SENDER))));
        UTL_SMTP.COMMAND(V_CONN,UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(P_PASSWORD))));
        V_REPLY := UTL_SMTP.HELO( V_CONN, P_EMAIL_SERVER);
        V_REPLY := UTL_SMTP.MAIL(V_CONN, P_SENDER);
        V_REPLY := UTL_SMTP.RCPT(V_CONN, RECEPIENT);

        UTL_SMTP.OPEN_DATA (V_CONN);

        UTL_SMTP.WRITE_DATA(V_CONN, 'DATE: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') || UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(V_CONN, 'FROM: ' || P_SENDER || UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(V_CONN, 'TO: '   || RECEPIENT || UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(V_CONN, 'SUBJECT: Electronic Payments from ' || V_HEADER_L3 || UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(V_CONN, 'MIME-VERSION: 1.0' || UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(V_CONN, 'CONTENT-TYPE: TEXT/HTML' || UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(V_CONN, 'REPLY-TO: ' || P_REPLY_TO || UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(V_CONN, UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(V_CONN, V_HEADER_TEXT);
        UTL_SMTP.WRITE_DATA(V_CONN, TEXT);
        UTL_SMTP.WRITE_DATA(V_CONN, '');
        UTL_SMTP.WRITE_DATA(V_CONN, V_FOTTER_TEXT);
        UTL_SMTP.WRITE_DATA(V_CONN, UTL_TCP.CRLF);

--DBMS_OUTPUT.PUT_LINE(6);

        UTL_SMTP.CLOSE_DATA(V_CONN);
        UTL_SMTP.QUIT(V_CONN);

--DBMS_OUTPUT.PUT_LINE(7);

        INSERT INTO DA1.VENDOR_DIRDEP_EMAIL(VDE_VEN_CODE
                                          , VDE_EMAIL_ID
                                          , VDE_STATUS
                                          , VDE_PROCESS_DATE
                                          , VDE_DESCRIPTION
                                          , VDE_CHECK_NUM
                                          , VDE_COMP_CODE
                                           )
            VALUES (CUR_VEN_MAST_REC.VENDOR
                  , RECEPIENT
                  , 'SENT'
                  , TO_DATE(TO_CHAR(SYSDATE, 'DD-MON-YY HH:MI:SS'), 'DD-MON-YY HH:MI:SS')
                  , 'SUCCESSFUL'
                  , CUR_VEN_MAST_REC.JFAPM_CHQ_NUM
                  , CUR_VEN_MAST_REC.COMP_CODE
                   );
        COMMIT;
--DBMS_OUTPUT.PUT_LINE(8);

      ELSE
        V_ERR_MSG := V_ERR_MSG || 'NO INVOICE INFO FOUND FOR VENDOR TO ATTACH IN EMAIL';
        INSERT INTO DA1.VENDOR_DIRDEP_EMAIL(VDE_VEN_CODE
                                          , VDE_EMAIL_ID
                                          , VDE_STATUS
                                          , VDE_PROCESS_DATE
                                          , VDE_DESCRIPTION
                                          , VDE_CHECK_NUM
                                          , VDE_COMP_CODE
                                           )
            VALUES (CUR_VEN_MAST_REC.VENDOR
                  , RECEPIENT
                  , 'NOT SENT'
                  , TO_DATE(TO_CHAR(SYSDATE, 'DD-MON-YY HH:MI:SS'), 'DD-MON-YY HH:MI:SS')
                  , V_ERR_MSG
                  , CUR_VEN_MAST_REC.JFAPM_CHQ_NUM
                  , CUR_VEN_MAST_REC.COMP_CODE
                   );
        COMMIT;
--DBMS_OUTPUT.PUT_LINE(9);

      END IF;
      V_LOOP_CNT :=0;

/* EXCEPTION HANDLING IN THE LOOP */
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
                                              , VDE_COMP_CODE
                                               )
                VALUES (CUR_VEN_MAST_REC.VENDOR
                      , RECEPIENT
                      , 'NOT SENT'
                      , TO_DATE(TO_CHAR(SYSDATE, 'DD-MON-YY HH:MI:SS'), 'DD-MON-YY HH:MI:SS')
                      , V_ERR_MSG
                      , CUR_VEN_MAST_REC.JFAPM_CHQ_NUM
                      , CUR_VEN_MAST_REC.COMP_CODE
                       );
            COMMIT;

              EXCEPTION
                WHEN UTL_SMTP.TRANSIENT_ERROR OR UTL_SMTP.PERMANENT_ERROR
                  THEN
                    NULL; -- WHEN THE SMTP SERVER IS DOWN OR UNAVAILABLE, WE DON'T HAVE
                          -- A CONNECTION TO THE SERVER. THE QUIT CALL WILL RAISE AN
                          -- EXCEPTION THAT WE CAN IGNORE AND THIS EXCEPTION IS DOING THAT.
                    V_LOOP_CNT :=0;
                    V_ERR_MSG := V_ERR_MSG || SUBSTR(SQLERRM, 1, 500-LENGTH(V_ERR_MSG));
                    INSERT INTO DA1.VENDOR_DIRDEP_EMAIL(VDE_VEN_CODE
                                                      , VDE_EMAIL_ID
                                                      , VDE_STATUS
                                                      , VDE_PROCESS_DATE
                                                      , VDE_DESCRIPTION
                                                      , VDE_CHECK_NUM
                                                      , VDE_COMP_CODE
                                                       )
                        VALUES (CUR_VEN_MAST_REC.VENDOR
                              , RECEPIENT
                              , 'NOT SENT'
                              , TO_DATE(TO_CHAR(SYSDATE, 'DD-MON-YY HH:MI:SS'), 'DD-MON-YY HH:MI:SS')
                              , V_ERR_MSG
                              , CUR_VEN_MAST_REC.JFAPM_CHQ_NUM
                              , CUR_VEN_MAST_REC.COMP_CODE
                               );
                    COMMIT;
          END;

        WHEN OTHERS
          THEN
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
                                              , VDE_COMP_CODE
                                               )
                VALUES (CUR_VEN_MAST_REC.VENDOR
                      , RECEPIENT
                      , 'NOT SENT'
                      , TO_DATE(TO_CHAR(SYSDATE, 'DD-MON-YY HH:MI:SS'), 'DD-MON-YY HH:MI:SS')
                      , V_ERR_MSG
                      , CUR_VEN_MAST_REC.JFAPM_CHQ_NUM
                      , CUR_VEN_MAST_REC.COMP_CODE
                       );
            COMMIT;
/* EXCEPTION HANDLING IN THE LOOP */

    END;
  END LOOP;
CLOSE CUR_VEN_MAST;

------------ Sending email to Andy about Vendors who have not recieved emails.
BEGIN
DBMS_OUTPUT.PUT_LINE(2);
V_SQLSTMT := 'SELECT DISTINCT VDE_VEN_CODE || '' '' || '
          || 'VDE_PROCESS_DATE || '' '' || VDE_DESCRIPTION '
          || 'FROM DA1.VENDOR_DIRDEP_EMAIL '
          || 'WHERE TRUNC(VDE_PROCESS_DATE) = TRUNC(SYSDATE) '
          || 'AND VDE_STATUS <> ''SENT'' ';
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
  WHEN OTHERS
    THEN
    TEXT:= 'List of vendors whose emails are not sent could not be generated because '
        || 'of the below error from Oracle, but below given query can be run against '
        || 'databse to see the vendors who were not sent an email.'
        || CRLF || CRLF
        || SUBSTR(SQLERRM, 1, 1000)
        || CRLF
        || 'SELECT DISTINCT VDE_VEN_CODE, VDE_PROCESS_DATE, VDE_DESCRIPTION '
        || 'FROM VENDOR_DIRDEP_EMAIL '
        || 'WHERE TRUNC(VDE_PROCESS_DATE) = TRUNC(SYSDATE) '
        || 'AND VDE_STATUS <> ''SENT'' ';

    UTL_MAIL.SEND_ATTACH_VARCHAR2(SENDER => P_SENDER
                                , RECIPIENTS => P_REPLY_TO
                                , SUBJECT => 'Error Vendor list'
                                , MESSAGE => 'List of vendors who did not recieve the '
                                          || 'emails could not be generated. Please see '
                                          || 'the attached file for more information. '
                                , ATTACHMENT => TEXT
                                , ATT_FILENAME => 'err_vend_no_email'
                                 );

END;
--DBMS_OUTPUT.PUT_LINE(10);
-------------

RETURN(NULL);

EXCEPTION
  WHEN OTHERS
    THEN
--     UTL_SMTP.CLOSE_DATA(V_CONN);
--     UTL_SMTP.QUIT(V_CONN);
      RAISE_APPLICATION_ERROR(-20004, SQLERRM);

END VEN_DIRDEP_EMAIL_FN1;

----------------------------------------------------------------------------------------

FUNCTION EMP_DIRDEP_EMAIL_FN (P_COMP_CODE IN VARCHAR2,
                               P_SENDER IN VARCHAR2
                             , P_PASSWORD IN VARCHAR2
                             , P_REPLY_TO IN VARCHAR2
                             )
  RETURN VARCHAR2
IS
PRAGMA AUTONOMOUS_TRANSACTION;

P_EMAIL_SERVER    VARCHAR2(50) := 'mail.caddell.com';

V_SQLSTMT         MAX_STRING%TYPE;
CUR_VAR           CUR_REF;
V_LOOP_CNT        NUMBER := 0;
V_LOOP_CNT1       NUMBER := 0;
V_NET_TOT         NUMBER := 0;
V_GROSS           NUMBER := 0;
V_YTD_GROSS       NUMBER := 0;
V_CUR_VALUE       MAX_STRING%TYPE;
V_CUR_VALUE1      MAX_STRING%TYPE;
RECEPIENT         DA.BPVENDORS.BPVEN_PAY_EMAIL%TYPE;
V_ERR_MSG         MAX_STRING%TYPE := '';
V_HEADER_TEXT     MAX_STRING%TYPE;
TEXT              MAX_STRING%TYPE := '';
V_FOTTER_TEXT     MAX_STRING%TYPE;

HEADER_STRING     VARCHAR2(83);
COLUMN_HEADER     VARCHAR2(50);
V_HEADER_L1       HEADER_STRING%TYPE := 'DIRECT DEPOSIT NOTIFICATION';
V_HEADER_L2       HEADER_STRING%TYPE ;
V_HEADER_L3       HEADER_STRING%TYPE ;  --:= 'Caddell Construction Co., Inc.'
V_EMPHEADER_1     HEADER_STRING%TYPE ;
V_EMPHEADER_2     HEADER_STRING%TYPE ;
V_EMPHEADER_3     HEADER_STRING%TYPE ;
V_EMPHEADER_4     HEADER_STRING%TYPE ;
V_EMPHEADER_5     HEADER_STRING%TYPE ;
V_EMPHEADER_6     HEADER_STRING%TYPE ;
V_EMPHEADER_7     HEADER_STRING%TYPE ;
V_CHEADER_1      COLUMN_HEADER%TYPE := 'Earnings';
V_CHEADER_2      COLUMN_HEADER%TYPE := 'Current';
V_CHEADER_3      COLUMN_HEADER%TYPE := 'Hours';
V_CHEADER_4      COLUMN_HEADER%TYPE := 'YTD';
V_CHEADER_5      COLUMN_HEADER%TYPE := 'Deductions';
V_CHEADER_6      COLUMN_HEADER%TYPE := 'Current';
V_CHEADER_7      COLUMN_HEADER%TYPE := 'YTD';
V_BNKHEADER_1    COLUMN_HEADER%TYPE := 'Bank Routing';
V_BNKHEADER_2    COLUMN_HEADER%TYPE := 'Bank Account';
V_BNKHEADER_3    COLUMN_HEADER%TYPE := 'Type';
V_BNKHEADER_4    COLUMN_HEADER%TYPE := 'Amount';

V_CONN            UTL_SMTP.CONNECTION;
V_PORT            NUMBER := 587;
V_REPLY           UTL_SMTP.REPLY;
B_CONNECTED       BOOLEAN := FALSE;
CRLF              VARCHAR2(2):= CHR(13) || CHR(10);

CURSOR CUR_EMP_MAST IS
SELECT DISTINCT STB.EMP_CODE EMP_CODE 
  FROM DA.V_PYSTUB_01 STB
    ,  UETD_EXTENDEDDE EXT
    , (SELECT DISTINCT EMAIL.EDE_EMP_CODE EDE_EMP_CODE
                     , EMAIL.EDE_CHECK_NUM
       FROM DA1.EMP_DIRDEP_EMAIL EMAIL
       WHERE TRUNC(EMAIL.EDE_PROCESS_DATE ) = TRUNC(SYSDATE)
         AND EMAIL.EDE_STATUS = 'SENT'
      ) MAIL
WHERE STB.C_ORDER_BY = 1
  AND STB.EMP_CODE = EXT.EMP_NUM
  AND STB.EMP_CODE = MAIL.EDE_EMP_CODE (+)
  AND MAIL.EDE_EMP_CODE IS NULL
ORDER BY STB.EMP_CODE;

CUR_EMP_MAST_REC   CUR_EMP_MAST%ROWTYPE;

CURSOR CUR_EMP_DET(PC_EMP_CODE IN VARCHAR2) IS
SELECT STB.C_ORDER_BY   C_ORDER_BY
  , STB.EMP_CODE        EMP_CODE
  , STB.STB_EARN_DESC   EARN_DESC
  , STB.STB_EARN_AMT    EARN_AMT
	, STB.STB_EARN_HRS    EARN_HRS
	, STB.STB_EARN_YTD	  EARN_YTD
  , STB.STB_DED_DESC		DED_DESC
  , STB.STB_DED_AMT		  DED_AMT
FROM 	DA.V_PYSTUB_01 STB
WHERE STB.EMP_CODE = PC_EMP_CODE
GROUP BY STB.C_ORDER_BY 
       , STB.EMP_CODE
       , STB.STB_EARN_DESC
       , STB.STB_EARN_AMT
       , STB.STB_EARN_HRS
       , STB.STB_EARN_YTD
       , STB.STB_DED_DESC
       , STB.STB_DED_AMT	
       , STB.STB_EARN_YTD
ORDER BY STB.C_ORDER_BY;

CUR_EMP_DET_REC   CUR_EMP_DET%ROWTYPE;

CURSOR CUR_EMP_GROSS(PC_EMP_CODE IN VARCHAR2) IS
SELECT DISTINCT STB.EMP_CHK_NUM EMP_CHK_NUM
  , STB.C_TAXABLE       GROSS
  , STB.C_YTD_TAXABLE   YTD_GROSS
	, STB.EMP_CHK_AMT     NET
FROM 	DA.V_PYSTUB_01 STB
WHERE STB.EMP_CODE = PC_EMP_CODE;

CUR_EMP_GROSS_REC   CUR_EMP_GROSS%ROWTYPE;

CURSOR CUR_BANK_DET(PC_EMP_CODE IN VARCHAR2) IS
SELECT DISTINCT  STB.EMP_CHK_NUM EMP_CHK_NUM
     , CHK.PYC_EMP_BANK_CODE ROUTING
     , CHK.PYC_EMP_BANK_ACC_NUM       ACCT
     , DECODE(CHK.PYC_ACH_TRAN_CODE, 32, 'Savings', 'Checking') ACCTYPE
     , STB.EMP_CHK_AMT AMT
FROM 	DA.V_PYSTUB_01 STB
    , DA.PYCHECKS CHK
WHERE STB.EMP_CODE = CHK.PYC_EMP_NO
AND STB.EMP_CHK_NUM = CHK.PYC_CHECK_NUM
AND STB.EMP_CHK_ACC_NUM = CHK.PYC_EMP_BANK_ACC_NUM
AND STB.EMP_CODE = PC_EMP_CODE
ORDER BY STB.EMP_CHK_NUM;

CUR_BANK_DET_REC   CUR_BANK_DET%ROWTYPE;

BEGIN
--DBMS_OUTPUT.PUT_LINE(1);

DELETE FROM DA1.EMP_DIRDEP_EMAIL
 WHERE TRUNC(EDE_PROCESS_DATE) <= TRUNC(SYSDATE)-30
    OR (EDE_STATUS = 'NOT SENT' AND TRUNC(EDE_PROCESS_DATE ) = TRUNC(SYSDATE));
COMMIT;

SELECT COMP_NAME
     , COMP_ADD2 || ', ' || COMP_REGION_CODE || ', ' || COMP_POSTAL_CODE
INTO V_HEADER_L2, V_HEADER_L3
FROM DA.COMPANY 
WHERE COMP_CODE = P_COMP_CODE;
      
--DBMS_OUTPUT.PUT_LINE(2);

OPEN CUR_EMP_MAST;
  LOOP
    BEGIN

      FETCH CUR_EMP_MAST INTO CUR_EMP_MAST_REC;
      V_CUR_VALUE := CUR_EMP_MAST_REC.EMP_CODE;
      EXIT WHEN CUR_EMP_MAST%NOTFOUND;
      
--DBMS_OUTPUT.PUT_LINE(3);

      SELECT NVL(EMP_EMAIL_ADDRESS, P_REPLY_TO) INTO RECEPIENT
      FROM DA.PYEMPLOYEE
      WHERE EMP_NO = CUR_EMP_MAST_REC.EMP_CODE;
      
      SELECT DISTINCT EMP_NO
                    , CHK_EMP_NAME
                    , 'xxx-xx-'||SUBSTR(C_SIN_NO,6,4)  C_SIN_NO
                    , 'Pay Period Ending: ' || C_END_DATE
                    , EMP_JOB_TITLE TITLE
                    , 'Location: ' || EMP_WRL_CODE LOCATION
                    , 'Deposit Date: ' || EMP_CHK_DATE                     
       INTO V_EMPHEADER_1, V_EMPHEADER_2, V_EMPHEADER_3, V_EMPHEADER_4, V_EMPHEADER_5
          , V_EMPHEADER_6, V_EMPHEADER_7
       FROM DA.V_PYSTUB_01
          , DA.PYEMPLOYEE
       WHERE EMP_NO = EMP_CODE
       AND EMP_CHK_DATE IS NOT NULL
       AND EMP_CODE = CUR_EMP_MAST_REC.EMP_CODE;
      
      V_HEADER_TEXT := '';

      V_HEADER_TEXT := '<TABLE WIDTH="100%"> <TR> <TH ALIGN="CENTER">' || V_HEADER_L1 ||'</TH> </TR>'
                    || '<TR> <TH ALIGN="CENTER">' || V_HEADER_L2 ||'</TH> </TR>'
                    || '<TR> <TH ALIGN="CENTER">' || V_HEADER_L3 ||'</TH> </TR>'
                    || '<TR> </TR>'
                    || '<TR> <HR NOSHADE SIZE=2 COLOR=BLACK > </TR>'
                    || '<TR> </TR> </TABLE>'  

                    || '<TABLE WIDTH= "100%" ALIGN="CENTER"> <TR> <TH ROWSPAN="1" ALIGN="LEFT">' || V_EMPHEADER_1 ||'</TH> '
                    || '<TH ALIGN="LEFT">' || '' ||'</TH> ' --BGCOLOR="GRAY"
                    || '<TH ALIGN="LEFT">' || '' ||'</TH> </TR> '
                    
                    || '<TR> <TH ALIGN="LEFT">' || V_EMPHEADER_2 ||'</TH> ' --BGCOLOR="GRAY"
                    || '<TH ALIGN="LEFT">' || V_EMPHEADER_3 ||'</TH> '
                    || '<TH ALIGN="LEFT">' || V_EMPHEADER_4 ||'</TH> </TR>' 
                    
                    || '<TR> <TH ALIGN="LEFT">' || V_EMPHEADER_5 ||'</TH> ' --BGCOLOR="GRAY"
                    || '<TH ALIGN="LEFT">' || V_EMPHEADER_6 ||'</TH> '
                    || '<TH ALIGN="LEFT">' || V_EMPHEADER_7 ||'</TH> </TR> </TABLE>'                    
                    
                    || '<TABLE WIDTH= "100%" ALIGN="CENTER"> <THEAD> <TR> <TH ROWSPAN="1" ALIGN="LEFT">' || V_CHEADER_1 ||'</TH> '
                    || '<TH ROWSPAN="1" ALIGN="RIGHT">' || V_CHEADER_2 ||'</TH> ' --BGCOLOR="GRAY"
                    || '<TH ROWSPAN="1" ALIGN="RIGHT">' || V_CHEADER_3 ||'</TH> '
                    || '<TH ROWSPAN="1" ALIGN="RIGHT">' || V_CHEADER_4 ||'</TH> '
                    || '<TH ROWSPAN="1" ALIGN="LEFT">' || V_CHEADER_5 ||'</TH> '
                    || '<TH ROWSPAN="1" ALIGN="RIGHT">' || V_CHEADER_6 ||'</TH> '
                    || '<TH ROWSPAN="1" ALIGN="RIGHT">' || V_CHEADER_7 ||'</TH> </TR> </THEAD>';

--DBMS_OUTPUT.PUT_LINE(4);

      OPEN CUR_EMP_DET(V_CUR_VALUE);
        LOOP

          FETCH CUR_EMP_DET INTO CUR_EMP_DET_REC;

          V_ERR_MSG := 'EMP_CODE:' || CUR_EMP_DET_REC.EMP_CODE
                                   || ', '
                                   || 'EMAIL:' || RECEPIENT || '--';

          EXIT WHEN CUR_EMP_DET%NOTFOUND;
          IF V_LOOP_CNT = 0
          THEN
            TEXT := '<TR> </TR>' -- Required for correct output in outlook
                 || '<TBODY> <TR> <TD> <HR> </TD> <TD> <HR> </TD> <TD> <HR> </TD> <TD> <HR> </TD> <TD> <HR> </TD> <TD> <HR> </TD> <TD> <HR> </TD> </TR> '
                 || '<TR> <TD>' || CUR_EMP_DET_REC.EARN_DESC ||'</TD> '
                 || '<TD ALIGN="RIGHT">' || NVL(TO_CHAR(CUR_EMP_DET_REC.EARN_AMT, '999,999,990.99'), 0.00) ||'</TD> '
                 || '<TD ALIGN="RIGHT">' || NVL(TO_CHAR(CUR_EMP_DET_REC.EARN_HRS, '999,999,990.99'), 0.00) ||'</TD> '
                 || '<TD ALIGN="RIGHT">' || NVL(TO_CHAR(CUR_EMP_DET_REC.EARN_YTD, '999,999,990.99'), 0.00) ||'</TD> '
                 || '<TD>' || CUR_EMP_DET_REC.DED_DESC ||'</TD> '
                 || '<TD ALIGN="RIGHT">' || NVL(TO_CHAR(CUR_EMP_DET_REC.DED_DESC, '999,999,990.99'), 0.00) ||'</TD> '
                 || '<TD ALIGN="RIGHT">' || NVL(TO_CHAR(CUR_EMP_DET_REC.DED_AMT, '999,999,990.99'), 0.00) ||'</TD> </TR>';
            V_LOOP_CNT := V_LOOP_CNT+1;
          ELSE
            TEXT := TEXT
                 || '<TR> <TD>' || CUR_EMP_DET_REC.EARN_DESC ||'</TD> '
                 || '<TD ALIGN="RIGHT">' || NVL(TO_CHAR(CUR_EMP_DET_REC.EARN_AMT, '999,999,990.99'), 0.00) ||'</TD> '
                 || '<TD ALIGN="RIGHT">' || NVL(TO_CHAR(CUR_EMP_DET_REC.EARN_HRS, '999,999,990.99'), 0.00) ||'</TD> '
                 || '<TD ALIGN="RIGHT">' || NVL(TO_CHAR(CUR_EMP_DET_REC.EARN_YTD, '999,999,990.99'), 0.00) ||'</TD> '
                 || '<TD>' || CUR_EMP_DET_REC.DED_DESC ||'</TD> '
                 || '<TD ALIGN="RIGHT">' || NVL(TO_CHAR(CUR_EMP_DET_REC.DED_DESC, '999,999,990.99'), 0.00) ||'</TD> '
                 || '<TD ALIGN="RIGHT">' || NVL(TO_CHAR(CUR_EMP_DET_REC.DED_AMT, '999,999,990.99'), 0.00) ||'</TD> </TR>';
          END IF;
        END LOOP;

      OPEN CUR_EMP_GROSS(V_CUR_VALUE);
        LOOP
          FETCH CUR_EMP_GROSS INTO CUR_EMP_GROSS_REC;
          EXIT WHEN CUR_EMP_GROSS%NOTFOUND;      
          IF V_NET_TOT = 0
          THEN
            V_GROSS := CUR_EMP_GROSS_REC.GROSS;
            V_YTD_GROSS := CUR_EMP_GROSS_REC.YTD_GROSS;
            V_NET_TOT := V_NET_TOT + CUR_EMP_GROSS_REC.NET;
          ELSE
            V_NET_TOT := V_NET_TOT + CUR_EMP_GROSS_REC.NET;
            END IF;
        END LOOP;        
      CLOSE CUR_EMP_GROSS;
          

            TEXT := TEXT
                 || '<TR> <TD> <HR> </TD> <TD> <HR> </TD> <TD> <HR> </TD> <TD> <HR> </TD> <TD> <HR> </TD> <TD> <HR> </TD> <TD> <HR> </TD></TR>'
                 || '<TR> <TD> ALIGN="RIGHT"' || 'Gross Pay:' ||'</TD> '
                 || '<TD ALIGN="RIGHT">' || NVL(TO_CHAR(V_GROSS, '999,999,990.99'), 0.00) ||'</TD> '
                 || '<TD>' || '' ||'</TD> '
                 || '<TD ALIGN="RIGHT">' || NVL(TO_CHAR(V_YTD_GROSS, '999,999,990.99'), 0.00) ||'</TD> '
                 || '<TD>' || '' ||'</TD> ' 
                 || '<TD>' || '' ||'</TD> ' 
                 || '<TD>' || '' ||'</TD> </TR>';

            TEXT := TEXT
                 || '<TR> <TD> ALIGN="RIGHT"' || 'Net Pay: ' ||'</TD> '
                 || '<TD ALIGN="RIGHT">' || NVL(TO_CHAR(V_NET_TOT, '999,999,990.99'), 0.00) ||'</TD> '
                 || '<TD>' || '' ||'</TD> '
                 || '<TD>' || '' ||'</TD> '
                 || '<TD>' || '' ||'</TD> '
                 || '<TD>' || '' ||'</TD> '
                 || '<TD>' || '' ||'</TD> </TR> '
                 || '<TR> <HR NOSHADE SIZE=1 COLOR=BLACK > </TR> </TBODY> </TABLE>';
                 

      OPEN CUR_BANK_DET(V_CUR_VALUE);
        LOOP
          FETCH CUR_BANK_DET INTO CUR_BANK_DET_REC;
          EXIT WHEN CUR_BANK_DET%NOTFOUND;
          --IF V_LOOP_CNT1 = 0
          --THEN                 
V_FOTTER_TEXT := '<TABLE WIDTH= "100%" ALIGN="CENTER"> <THEAD> <TR> <TH ROWSPAN="1" ALIGN="LEFT">' || V_BNKHEADER_1 ||'</TH> '
              || '<TH ROWSPAN="1" ALIGN="LEFT">' || V_BNKHEADER_2 ||'</TH> ' --BGCOLOR="GRAY"
              || '<TH ROWSPAN="1" ALIGN="LEFT">' || V_BNKHEADER_3 ||'</TH> '
              || '<TH ROWSPAN="1" ALIGN="RIGHT">' || V_BNKHEADER_4 ||'</TH> </TR> </THEAD>';

V_FOTTER_TEXT := '<TR> </TR>' -- Required for correct output in outlook
              || '<TBODY> <TR> <TD> <HR> </TD> <TD> <HR> </TD> <TD> <HR> </TD> <TD> <HR> </TD> </TR> '
              || '<TR> <TD> ALIGN="LEFT"' || CUR_BANK_DET_REC.ROUTING ||'</TD> '
              || '<TD ALIGN="LEFT">' || CUR_BANK_DET_REC.ACCT ||'</TD> '
              || '<TD ALIGN="LEFT">' || CUR_BANK_DET_REC.ACCTYPE ||'</TD> '
              || '<TD ALIGN="RIGHT">' || NVL(TO_CHAR(CUR_BANK_DET_REC.AMT, '999,999,990.99'), 0.00) ||'</TD> </TR> </TBODY> </TABLE>';              
       END LOOP;        
      CLOSE CUR_EMP_GROSS;              
              
      CLOSE CUR_EMP_DET;
      V_NET_TOT := 0;
--      V_LOOP_CNT1 := 0;
      
      IF V_LOOP_CNT <> 0
      THEN

--DBMS_OUTPUT.PUT_LINE(5);

      --open the connection with the smtp server and do the handshake
        V_CONN:= UTL_SMTP.OPEN_CONNECTION(P_EMAIL_SERVER, V_PORT );
        UTL_SMTP.COMMAND(V_CONN, 'AUTH LOGIN');
        UTL_SMTP.COMMAND(V_CONN,UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(P_SENDER))));
        UTL_SMTP.COMMAND(V_CONN,UTL_RAW.CAST_TO_VARCHAR2(UTL_ENCODE.BASE64_ENCODE(UTL_RAW.CAST_TO_RAW(P_PASSWORD))));
        V_REPLY := UTL_SMTP.HELO( V_CONN, P_EMAIL_SERVER);
        V_REPLY := UTL_SMTP.MAIL(V_CONN, P_SENDER);
        V_REPLY := UTL_SMTP.RCPT(V_CONN, RECEPIENT);

        UTL_SMTP.OPEN_DATA (V_CONN);

        UTL_SMTP.WRITE_DATA(V_CONN, 'DATE: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY HH24:MI:SS') || UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(V_CONN, 'FROM: ' || P_SENDER || UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(V_CONN, 'TO: '   || RECEPIENT || UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(V_CONN, 'SUBJECT: Confidentail Notification of Direct Payroll Deposit' || UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(V_CONN, 'MIME-VERSION: 1.0' || UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(V_CONN, 'CONTENT-TYPE: TEXT/HTML' || UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(V_CONN, 'REPLY-TO: ' || P_REPLY_TO || UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(V_CONN, UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(V_CONN, V_HEADER_TEXT);
        UTL_SMTP.WRITE_DATA(V_CONN, TEXT);
        UTL_SMTP.WRITE_DATA(V_CONN, '');
        UTL_SMTP.WRITE_DATA(V_CONN, V_FOTTER_TEXT);
        UTL_SMTP.WRITE_DATA(V_CONN, UTL_TCP.CRLF);

--DBMS_OUTPUT.PUT_LINE(6);

        UTL_SMTP.CLOSE_DATA(V_CONN);
        UTL_SMTP.QUIT(V_CONN);

--DBMS_OUTPUT.PUT_LINE(7);

        INSERT INTO DA1.EMP_DIRDEP_EMAIL(EDE_EMP_CODE
                                       , EDE_EMAIL_ID
                                       , EDE_STATUS
                                       , EDE_PROCESS_DATE
                                       , EDE_DESCRIPTION
                                       --, EDE_CHECK_NUM
                                           )
            VALUES (CUR_EMP_MAST_REC.EMP_CODE
                  , RECEPIENT
                  , 'SENT'
                  , TO_DATE(TO_CHAR(SYSDATE, 'DD-MON-YY HH:MI:SS'), 'DD-MON-YY HH:MI:SS')
                  , 'SUCCESSFUL'
                  --, CUR_EMP_MAST_REC.JFAPM_CHQ_NUM
                   );
        COMMIT;
--DBMS_OUTPUT.PUT_LINE(8);

      ELSE
        V_ERR_MSG := V_ERR_MSG || 'NO INVOICE INFO FOUND FOR VENDOR TO ATTACH IN EMAIL';
        INSERT INTO DA1.EMP_DIRDEP_EMAIL(EDE_EMP_CODE
                                       , EDE_EMAIL_ID
                                       , EDE_STATUS
                                       , EDE_PROCESS_DATE
                                       , EDE_DESCRIPTION
                                       --, EDE_CHECK_NUM
                                           )
            VALUES (CUR_EMP_MAST_REC.EMP_CODE
                  , RECEPIENT
                  , 'NOT SENT'
                  , TO_DATE(TO_CHAR(SYSDATE, 'DD-MON-YY HH:MI:SS'), 'DD-MON-YY HH:MI:SS')
                  , V_ERR_MSG
                  --, CUR_EMP_MAST_REC.JFAPM_CHQ_NUM
                   );
        COMMIT;
--DBMS_OUTPUT.PUT_LINE(9);

      END IF;
      V_LOOP_CNT :=0;

/* EXCEPTION HANDLING IN THE LOOP */
      EXCEPTION
        WHEN UTL_SMTP.TRANSIENT_ERROR OR UTL_SMTP.PERMANENT_ERROR THEN
          BEGIN
            UTL_SMTP.CLOSE_DATA(V_CONN);
            UTL_SMTP.QUIT(V_CONN);
            V_LOOP_CNT :=0;
            V_ERR_MSG := V_ERR_MSG || SUBSTR(SQLERRM, 1, 500-LENGTH(V_ERR_MSG));
            INSERT INTO DA1.EMP_DIRDEP_EMAIL(EDE_EMP_CODE
                                           , EDE_EMAIL_ID
                                           , EDE_STATUS
                                           , EDE_PROCESS_DATE
                                           , EDE_DESCRIPTION
                                           --, EDE_CHECK_NUM
                                               )
                VALUES (CUR_EMP_MAST_REC.EMP_CODE
                      , RECEPIENT
                      , 'NOT SENT'
                      , TO_DATE(TO_CHAR(SYSDATE, 'DD-MON-YY HH:MI:SS'), 'DD-MON-YY HH:MI:SS')
                      , V_ERR_MSG
                      --, CUR_EMP_MAST_REC.JFAPM_CHQ_NUM
                       );
            COMMIT;

              EXCEPTION
                WHEN UTL_SMTP.TRANSIENT_ERROR OR UTL_SMTP.PERMANENT_ERROR
                  THEN
                    NULL; -- WHEN THE SMTP SERVER IS DOWN OR UNAVAILABLE, WE DON'T HAVE
                          -- A CONNECTION TO THE SERVER. THE QUIT CALL WILL RAISE AN
                          -- EXCEPTION THAT WE CAN IGNORE AND THIS EXCEPTION IS DOING THAT.
                    V_LOOP_CNT :=0;
                    V_ERR_MSG := V_ERR_MSG || SUBSTR(SQLERRM, 1, 500-LENGTH(V_ERR_MSG));
                    INSERT INTO DA1.EMP_DIRDEP_EMAIL(EDE_EMP_CODE
                                                   , EDE_EMAIL_ID
                                                   , EDE_STATUS
                                                   , EDE_PROCESS_DATE
                                                   , EDE_DESCRIPTION
                                                   --, EDE_CHECK_NUM
                                                       )
                        VALUES (CUR_EMP_MAST_REC.EMP_CODE
                              , RECEPIENT
                              , 'NOT SENT'
                              , TO_DATE(TO_CHAR(SYSDATE, 'DD-MON-YY HH:MI:SS'), 'DD-MON-YY HH:MI:SS')
                              , V_ERR_MSG
                              --, CUR_EMP_MAST_REC.JFAPM_CHQ_NUM
                               );
                    COMMIT;
          END;

        WHEN OTHERS
          THEN
            UTL_SMTP.CLOSE_DATA(V_CONN);
            UTL_SMTP.QUIT(V_CONN);
            V_LOOP_CNT :=0;
            V_ERR_MSG := V_ERR_MSG || SUBSTR(SQLERRM, 1, 500-LENGTH(V_ERR_MSG));
            INSERT INTO DA1.EMP_DIRDEP_EMAIL(EDE_EMP_CODE
                                           , EDE_EMAIL_ID
                                           , EDE_STATUS
                                           , EDE_PROCESS_DATE
                                           , EDE_DESCRIPTION
                                           --, EDE_CHECK_NUM
                                               )
                VALUES (CUR_EMP_MAST_REC.EMP_CODE
                      , RECEPIENT
                      , 'NOT SENT'
                      , TO_DATE(TO_CHAR(SYSDATE, 'DD-MON-YY HH:MI:SS'), 'DD-MON-YY HH:MI:SS')
                      , V_ERR_MSG
                      --, CUR_EMP_MAST_REC.JFAPM_CHQ_NUM
                       );
            COMMIT;
/* EXCEPTION HANDLING IN THE LOOP */

    END;
  END LOOP;
CLOSE CUR_EMP_MAST;

------------ Sending email to Andy about Vendors who have not recieved emails.
BEGIN
DBMS_OUTPUT.PUT_LINE(2);
V_SQLSTMT := 'SELECT DISTINCT EDE_EMP_CODE || '' '' || '
          || 'EDE_PROCESS_DATE || '' '' || EDE_DESCRIPTION '
          || 'FROM DA1.EMP_DIRDEP_EMAIL '
          || 'WHERE TRUNC(EDE_PROCESS_DATE) = TRUNC(SYSDATE) '
          || 'AND EDE_STATUS <> ''SENT'' ';
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
                                , SUBJECT => 'Error Emp list'
                                , MESSAGE => 'Atached is the list of Employees whose emails were not sent. '
                                          || 'Attached file also has the details of why they were not sent.'
                                , ATTACHMENT => TEXT
                                , ATT_INLINE => FALSE
                                , ATT_FILENAME => 'Emp_no_email'
                                 );
  END IF;
EXCEPTION
  WHEN OTHERS
    THEN
    TEXT:= 'List of Employees whose emails were not sent could not be generated because '
        || 'of the below error from Oracle, but below given query can be run against '
        || 'databse to see the Employees who were not sent an email.'
        || CRLF || CRLF
        || SUBSTR(SQLERRM, 1, 1000)
        || CRLF
        || 'SELECT DISTINCT EDE_EMP_CODE, EDE_PROCESS_DATE, EDE_DESCRIPTION '
        || 'FROM EMP_DIRDEP_EMAIL '
        || 'WHERE TRUNC(EDE_PROCESS_DATE) = TRUNC(SYSDATE) '
        || 'AND EDE_STATUS <> ''SENT'' ';

    UTL_MAIL.SEND_ATTACH_VARCHAR2(SENDER => P_SENDER
                                , RECIPIENTS => P_REPLY_TO
                                , SUBJECT => 'Error Employee list'
                                , MESSAGE => 'List of Employees who did not recieve the '
                                          || 'emails could not be generated. Please see '
                                          || 'the attached file for more information. '
                                , ATTACHMENT => TEXT
                                , ATT_FILENAME => 'err_emp_no_email'
                                 );

END;
--DBMS_OUTPUT.PUT_LINE(10);
-------------

RETURN(NULL);

EXCEPTION
  WHEN OTHERS
    THEN
--     UTL_SMTP.CLOSE_DATA(V_CONN);
--     UTL_SMTP.QUIT(V_CONN);
      RAISE_APPLICATION_ERROR(-20004, SQLERRM);

END EMP_DIRDEP_EMAIL_FN;

----------------------------------------------------------------------------------------

END CC_UTL_PKG;

/
