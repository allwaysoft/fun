CREATE OR REPLACE PACKAGE     EUL_DISCO_PKG
AS
/*********************************************************************
** Name:    EUL_DISCO_PKG
** Author:  Kranthi Pabba                  Date:08/25/2009
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

  FUNCTION UPDATE_EFTPRENOTE_FN
    RETURN VARCHAR2;  -- USED IN COMPASS_NACHA_VENDOR_REPORT

  FUNCTION VEN_DIRDEP_EMAIL_FN (P_BP_CODE IN VARCHAR2)
    RETURN VARCHAR2;

  FUNCTION VEN_DIRDEP_EMAIL_FN1 (P_EMAIL_SERVER IN VARCHAR2 -- USED IN 1st TAB OF VENDOR_EMAIL REPORT
                               , P_SENDER IN VARCHAR2
                               , P_PASSWORD IN VARCHAR2
                               , P_REPLY_TO IN VARCHAR2
                               , P_BP_CODE IN VARCHAR2
                                )
    RETURN VARCHAR2;
  FUNCTION VEN_DIRDEP_EMAIL_FN2 (P_EMAIL_SERVER IN VARCHAR2 -- USED IN 2nd TAB OF VENDOR_EMAIL REPORT
                               , P_SENDER IN VARCHAR2
                               , P_PASSWORD IN VARCHAR2
                               , P_REPLY_TO IN VARCHAR2
                               , P_BP_CODE IN VARCHAR2
                                )
    RETURN VARCHAR2;

  FUNCTION SET_CONTEXT (P_NAME VARCHAR2
                      , P_VALUE VARCHAR2
                       ) RETURN VARCHAR2;

  FUNCTION SHOW_CONTEXT(P_NAME VARCHAR2) RETURN VARCHAR2;

  PROCEDURE UPDATE_EFTPRENOTE;

  FUNCTION CALL_FN (P_NAME VARCHAR2) RETURN VARCHAR2;

END EUL_DISCO_PKG;

/


CREATE OR REPLACE PACKAGE BODY     EUL_DISCO_PKG
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

FUNCTION UPDATE_EFTPRENOTE_FN RETURN VARCHAR2 -- USED IN COMPASS_NACHA_VENDOR_REPORT
IS
PRAGMA AUTONOMOUS_TRANSACTION;

V_SQLSTMT          MAX_STRING%TYPE;
--CUR_VAR          CUR_REF;

BEGIN

--DBMS_OUTPUT.PUT_LINE ('1');
/*
    v_sqlstmt := 'UPDATE DA.UETD_EFTPRENOT '
              || 'SET BPPRENOTE = ''SENT'' '
              || 'WHERE BPPRENOTE = ''REPORTED''';
  EXECUTE IMMEDIATE v_sqlstmt;
  COMMIT;
*/
--DBMS_OUTPUT.PUT_LINE ('2');

  V_SQLSTMT := 'UPDATE DA.UETD_EFTPRENOT '
            || 'SET BPPRENOTE = ''SENT'' '
            || 'WHERE BPPRENOTE = ''SEND'' '
            || 'AND (COMP_CODE, VEN_CODE) IN '
            || '(SELECT BPVEN_COMP_CODE, BPVEN_BP_CODE '
            || 'FROM DA.BPVENDORS '
            || 'WHERE BPVEN_COMP_CODE NOT IN (''ZZ'') '
            || 'AND BPVEN_BANK_ACC_NUM1 IS NOT NULL)';

  EXECUTE IMMEDIATE V_SQLSTMT;
  COMMIT;

--DBMS_OUTPUT.PUT_LINE ('3');

  RETURN (NULL);

  EXCEPTION
    WHEN OTHERS
      THEN
        RAISE_APPLICATION_ERROR(-20003, SQLERRM);

END UPDATE_EFTPRENOTE_FN;

----------------------------------------------------------------------------------------

FUNCTION VEN_DIRDEP_EMAIL_FN(P_BP_CODE IN VARCHAR2)
  RETURN VARCHAR2
IS
PRAGMA AUTONOMOUS_TRANSACTION;

V_SQLSTMT         MAX_STRING%TYPE;
CUR_VAR           CUR_REF;
V_LOOP_CNT        NUMBER :=0 ;
V_CUR_VALUE       DA.BPVENDORS.BPVEN_BP_CODE%TYPE;
V_CUR_VALUE1      MAX_STRING%TYPE;
FNAME             VARCHAR2(10) :='VEN_PAY';
SENDER            VARCHAR2(50) :='ORACLE.DBA@CADDELL.COM';
RECEPIENT         DA.BPVENDORS.BPVEN_PAY_EMAIL%TYPE :='KRANTHI.PABBA@GMAIL.COM';
V_ERR_MSG         MAX_STRING%TYPE := '';
V_HEADER_TEXT     MAX_STRING%TYPE;
TEXT              MAX_STRING%TYPE;

HEADER_STRING     VARCHAR2(83);
V_HEADER_L1       HEADER_STRING%TYPE := 'ELECTRONIC FUNDS TRANSFER PAYMENT NOTIFICATION';
V_HEADER_L2       HEADER_STRING%TYPE := 'from';
V_HEADER_L3       HEADER_STRING%TYPE := 'Caddell Construction Co., Inc.';
V_HEADER_L4       HEADER_STRING%TYPE := '';
V_HEADER_L5       HEADER_STRING%TYPE ;
V_HEADER_L6       HEADER_STRING%TYPE := '';
V_HEADER_L7       HEADER_STRING%TYPE ;
V_HEADER_L8       HEADER_STRING%TYPE := '';
V_HEADER_L9       HEADER_STRING%TYPE := 'Invoice Invoice                                     Invoice    Discount     Payment';
V_HEADER_L10      HEADER_STRING%TYPE := 'Date    Number     Invoice Description               Amount      Amount      Amount';
V_HEADER_L11      HEADER_STRING%TYPE := '------- ---------- ---------------------------- ----------- ----------- -----------';

--- SMTP CODE

v_email_server VARCHAR2(100) := 'mail.caddell.com';
v_conn UTL_SMTP.CONNECTION;
v_port NUMBER := 587;

---

CURSOR CUR_VEN_DET(PC_BP_CODE IN VARCHAR2) IS
  SELECT VEN.BPVEN_BP_CODE
         || ', '
         || BP.BP_NAME
         || ', '
         || BP.BP_CREATE_DATE DATA1
       , VEN.BPVEN_BP_CODE    BP_CODE
    FROM DA.BPVENDORS VEN
       , DA.BPARTNERS BP
       , DA.CHEQUE CHK
   WHERE VEN.BPVEN_BP_CODE = BP.BP_CODE
     AND BP.BP_CODE = CHK.CHQ_VEN_CODE
     AND VEN.BPVEN_BP_CODE = PC_BP_CODE;

CUR_VEN_DET_REC   CUR_VEN_DET%ROWTYPE;

--LOOP_CNT NUMBER := 0;

--'REA001','READ001','REAM001'

BEGIN

DELETE FROM DA1.VENDOR_DIRDEP_EMAIL
 WHERE TRUNC(VDE_PROCESS_DATE) <= TRUNC(SYSDATE)-30
    OR ( VDE_STATUS = 'NOT SENT'
     AND TRUNC(VDE_PROCESS_DATE ) = TRUNC(SYSDATE)
       );
COMMIT;

-- SMTP CODE

v_conn:= UTL_SMTP.OPEN_CONNECTION(v_email_server, v_port );
utl_smtp.command(v_conn, 'AUTH LOGIN');
utl_smtp.command(v_conn,UTL_RAW.CAST_TO_VARCHAR2(utl_encode.base64_encode(utl_raw.cast_to_raw('kranthi.pabba'))));
utl_smtp.command(v_conn,UTL_RAW.CAST_TO_VARCHAR2(utl_encode.base64_encode(utl_raw.cast_to_raw('krapab'))));

--


V_SQLSTMT := 'SELECT DISTINCT VEN.BPVEN_BP_CODE BP_CODE '
          || 'FROM DA.BPVENDORS VEN, '
          || '(SELECT DISTINCT EMAIL.VDE_BP_CODE VDE_BP_CODE '
          || 'FROM DA1.VENDOR_DIRDEP_EMAIL EMAIL '
          || 'WHERE TRUNC(EMAIL.VDE_PROCESS_DATE ) = TRUNC(SYSDATE) '
          || 'AND EMAIL.VDE_STATUS = ''SENT'') MAIL '
          || 'WHERE  VEN.BPVEN_BP_CODE = MAIL.VDE_BP_CODE (+) '
          || 'AND MAIL.VDE_BP_CODE IS NULL '
          || 'AND VEN. BPVEN_BP_CODE IN '
          || FORMAT_STRING_FN(P_BP_CODE);

--DBMS_OUTPUT.PUT_LINE(1);
--DBMS_OUTPUT.PUT_LINE(FORMAT_STRING_FN(P_BP_CODE));

OPEN CUR_VAR FOR V_SQLSTMT;
  LOOP

    BEGIN

      FETCH CUR_VAR INTO V_CUR_VALUE;
      EXIT WHEN CUR_VAR%NOTFOUND;

      --LOOP_CNT :=LOOP_CNT+1;

      V_HEADER_L5 := 'Payment Date: ' || SYSDATE || ' Reference: ' || '035685';
      V_HEADER_L7 := 'Vendor: ' || V_CUR_VALUE;
      V_HEADER_TEXT := '';

      V_HEADER_TEXT := RPAD(LPAD(V_HEADER_L1, (83-LENGTH(V_HEADER_L1))/2+LENGTH(V_HEADER_L1), ' '), 83, ' ')
                    || CHR(13) || CHR(10)
                    || RPAD(LPAD(V_HEADER_L2, (83-LENGTH(V_HEADER_L2))/2+LENGTH(V_HEADER_L2), ' '), 83, ' ')
                    || CHR(13) || CHR(10)
                    || RPAD(LPAD(V_HEADER_L3, (83-LENGTH(V_HEADER_L3))/2+LENGTH(V_HEADER_L3), ' '), 83, ' ')
                    || CHR(13) || CHR(10)
                    || V_HEADER_L4
                    || CHR(13) || CHR(10)
                    || RPAD(LPAD(V_HEADER_L5, (83-LENGTH(V_HEADER_L5))/2+LENGTH(V_HEADER_L5), ' '), 83, ' ')
                    || CHR(13) || CHR(10)
                    || V_HEADER_L6
                    || CHR(13) || CHR(10)
                    || RPAD(LPAD(V_HEADER_L7, (83-LENGTH(V_HEADER_L7))/2+LENGTH(V_HEADER_L7), ' '), 83, ' ')
                    || CHR(13) || CHR(10)
                    || V_HEADER_L8
                    || CHR(13) || CHR(10)
                    || RPAD(LPAD(V_HEADER_L9, (83-LENGTH(V_HEADER_L9))/2+LENGTH(V_HEADER_L9), ' '), 83, ' ')
                    || CHR(13) || CHR(10)
                    || RPAD(LPAD(V_HEADER_L10, (83-LENGTH(V_HEADER_L10))/2+LENGTH(V_HEADER_L10), ' '), 83, ' ')
                    || CHR(13) || CHR(10)
                    || RPAD(V_HEADER_L11, 83, '-')
                    || CHR(13) || CHR(10);

      OPEN CUR_VEN_DET(V_CUR_VALUE);
        LOOP

          V_ERR_MSG := 'BP_CODE:' || V_CUR_VALUE || ', ' || 'EMAIL:' || RECEPIENT || '--';

          FETCH CUR_VEN_DET INTO CUR_VEN_DET_REC;
          EXIT WHEN CUR_VEN_DET%NOTFOUND;
          IF V_LOOP_CNT = 0
          THEN
            TEXT := V_HEADER_TEXT
                 || RPAD(
                      LPAD(CUR_VEN_DET_REC.DATA1
                         , (83-LENGTH(CUR_VEN_DET_REC.DATA1))/2+LENGTH(CUR_VEN_DET_REC.DATA1)
                         , ' '
                          )
                       , 83
                       , ' '
                        );
--               || CUR_VEN_DET_REC.DATA1;
            V_LOOP_CNT := V_LOOP_CNT+1;
          ELSE
            TEXT := TEXT
                 || CHR(13) || CHR(10)
                 || RPAD(
                         LPAD(CUR_VEN_DET_REC.DATA1
                            , (83-LENGTH(CUR_VEN_DET_REC.DATA1))/2+LENGTH(CUR_VEN_DET_REC.DATA1)
                            , ' '
                             )
                       , 83
                       , ' '
                        );
               --|| CUR_VEN_DET_REC.DATA1;
          END IF;
        END LOOP;
      CLOSE CUR_VEN_DET;

      IF V_LOOP_CNT <> 0
      THEN

      --IF LOOP_CNT =2
      --THEN RECEPIENT := 'KRANTHI.PABBA@CADDELL.COM';
      --END IF;

        UTL_MAIL.SEND_ATTACH_VARCHAR2(SENDER => SENDER
                                    , RECIPIENTS => RECEPIENT
                                    , SUBJECT => 'TESTMAIL'
                                    , MESSAGE => 'HALLO'
                                    , ATTACHMENT => TEXT
                                    , ATT_INLINE => FALSE
                                    , ATT_FILENAME => FNAME
                                     );

        INSERT INTO DA1.VENDOR_DIRDEP_EMAIL(VDE_BP_CODE
                                          , VDE_EMAIL_ID
                                          , VDE_STATUS
                                          , VDE_PROCESS_DATE
                                          , VDE_DESCRIPTION
                                           )
            VALUES (V_CUR_VALUE
                  , RECEPIENT
                  , 'SENT'
                  , TO_DATE(TO_CHAR(SYSDATE, 'DD-MON-YY HH:MI:SS'), 'DD-MON-YY HH:MI:SS')
                  , 'SUCCESSFUL'
                   );
        COMMIT;
      ELSE
        V_ERR_MSG := V_ERR_MSG || 'NO INVOICE INFO FOUND FOR VENDOR TO ATTACH IN EMAIL';
        INSERT INTO DA1.VENDOR_DIRDEP_EMAIL(VDE_BP_CODE
                                          , VDE_EMAIL_ID
                                          , VDE_STATUS
                                          , VDE_PROCESS_DATE
                                          , VDE_DESCRIPTION
                                           )
            VALUES (V_CUR_VALUE
                  , RECEPIENT
                  , 'NOT SENT'
                  , TO_DATE(TO_CHAR(SYSDATE, 'DD-MON-YY HH:MI:SS'), 'DD-MON-YY HH:MI:SS')
                  , V_ERR_MSG
                   );
        COMMIT;
      END IF;
      V_LOOP_CNT :=0;

      EXCEPTION
        WHEN OTHERS
        THEN
          V_LOOP_CNT :=0;
          V_ERR_MSG := V_ERR_MSG || SUBSTR(SQLERRM, 1, 500-LENGTH(V_ERR_MSG));
          INSERT INTO DA1.VENDOR_DIRDEP_EMAIL(VDE_BP_CODE
                                            , VDE_EMAIL_ID
                                            , VDE_STATUS
                                            , VDE_PROCESS_DATE
                                            , VDE_DESCRIPTION
                                             )
              VALUES (V_CUR_VALUE
                    , RECEPIENT
                    , 'NOT SENT'
                    , TO_DATE(TO_CHAR(SYSDATE, 'DD-MON-YY HH:MI:SS'), 'DD-MON-YY HH:MI:SS')
                    , V_ERR_MSG
                     );
          COMMIT;

    END;

  END LOOP;
CLOSE CUR_VAR;

DBMS_OUTPUT.PUT_LINE(1);

-------------------- Sending email to Andy about Vendors who have not recieved emails.

BEGIN
DBMS_OUTPUT.PUT_LINE(2);
V_SQLSTMT := 'SELECT DISTINCT VDE_BP_CODE || '' '' || '
          || 'VDE_PROCESS_DATE || '' '' || VDE_DESCRIPTION '
          || 'FROM DA1.VENDOR_DIRDEP_EMAIL '
          || 'WHERE TRUNC(VDE_PROCESS_DATE) = TRUNC(SYSDATE) '
          || 'AND VDE_STATUS <> ''SENT'' ';
TEXT := '';

OPEN CUR_VAR FOR V_SQLSTMT;
  LOOP
    FETCH CUR_VAR INTO V_CUR_VALUE1;
    EXIT WHEN CUR_VAR%NOTFOUND;
    TEXT := TEXT
         || CHR(13) || CHR(10)
         || V_CUR_VALUE1;
  END LOOP;

UTL_MAIL.SEND_ATTACH_VARCHAR2(SENDER => SENDER
                            , RECIPIENTS => 'KRANTHI.PABBA@CADDELL.COM'
                            , SUBJECT => 'Error Vendor list'
                            , MESSAGE => 'Atached is the list of vendors whose emails were not sent. '
                                      || 'Attached file also has the explanation of why they were not sent.'
                            , ATTACHMENT => TEXT
                            , ATT_INLINE => FALSE
                            , ATT_FILENAME => 'vend_no_email'
                             );
EXCEPTION
  WHEN OTHERS
    THEN
    TEXT:= 'Vendor list could not be generated because of the below error from Oracle, '
        || 'but below given query can be run against databse to see the vendors who were not sent.'
        || CHR(13) || CHR(10) || CHR(13) || CHR(10)
        || SQLERRM
        || CHR(13) || CHR(10)
        || 'SELECT DISTINCT VDE_BP_CODE, VDE_PROCESS_DATE, VDE_DESCRIPTION '
        || 'FROM VENDOR_DIRDEP_EMAIL '
        || 'WHERE TRUNC(VDE_PROCESS_DATE) = TRUNC(SYSDATE) '
        || 'AND VDE_STATUS <> ''SENT'' ';

    UTL_MAIL.SEND_ATTACH_VARCHAR2(SENDER => SENDER
                                , RECIPIENTS => 'KRANTHI.PABBA@CADDELL.COM'
                                , SUBJECT => 'Error Vendor list'
                                , MESSAGE => 'List of vendors who did not recieve the emails could not be generated. '
                                          || 'Please see the attached file for more information. '
                                , ATTACHMENT => TEXT
                                , ATT_FILENAME => 'err_vend_no_email'
                                 );

END;
DBMS_OUTPUT.PUT_LINE(3);
--------------------------

RETURN(P_BP_CODE);

DBMS_OUTPUT.PUT_LINE(4);

-- UTL_SMTP CODE

UTL_SMTP.QUIT( v_conn );

--

EXCEPTION
  WHEN OTHERS
    THEN
      RAISE_APPLICATION_ERROR(-20004, V_ERR_MSG || SQLERRM);

END VEN_DIRDEP_EMAIL_FN;

----------------------------------------------------------------------------------------
/*
-- Below two functions go hand in hand are used to set the paramters from disco desktop and
   use them in disco admin SQL.

-- Function SET_CONTEXT should be used in the CONDITION of first sheet of disco report which
   will set the context. Then the disco adimn can use the SHOW_CONTEXT in it's SQL, this SQL
   becomes the source for the second sheet of the disco report.

-- USAGE      SET_CONTEXT('DISCO_CONTEXT', :DISCO DESKTOP PARAMETER)
*/

--CREATE OR REPLACE CONTEXT DISCO_CONTEXT
--USING DA1.EUL_DISCO_PKG
--/

FUNCTION SET_CONTEXT(P_NAME VARCHAR2
                   , P_VALUE VARCHAR2
                    )
RETURN VARCHAR2
AS

  V_CONTEXT CONSTANT MAX_STRING%TYPE := 'DISCO_CONTEXT';

BEGIN
  DBMS_SESSION.SET_CONTEXT(V_CONTEXT, P_NAME, P_VALUE);
  RETURN P_VALUE;
END SET_CONTEXT;

--------------------------------------------------------
/*
-- Function SHOW_CONTEXT should be used in the WHERE of SQL of disco admin and the parameter
   passed by SET_CONTEXT will be in hold in SYS_CONTEXT for that (DISCO_CONTECT) context.

-- USAGE       SHOW_CONTEXT('DISCO_CONTEXT')
*/
FUNCTION SHOW_CONTEXT(P_NAME VARCHAR2) RETURN VARCHAR2
IS

  V_CONTEXT CONSTANT MAX_STRING%TYPE :='DISCO_CONTEXT';

BEGIN
  RETURN SYS_CONTEXT(V_CONTEXT, P_NAME);
END SHOW_CONTEXT;

----------------------------------------------------------------------------------------

FUNCTION VEN_DIRDEP_EMAIL_FN1 (P_EMAIL_SERVER IN VARCHAR2
                             , P_SENDER IN VARCHAR2
                             , P_PASSWORD IN VARCHAR2
                             , P_REPLY_TO IN VARCHAR2
                             , P_BP_CODE IN VARCHAR2
                              )
  RETURN VARCHAR2
IS
PRAGMA AUTONOMOUS_TRANSACTION;

V_SQLSTMT         MAX_STRING%TYPE;
CUR_VAR           CUR_REF;
V_LOOP_CNT        NUMBER :=0 ;
V_CUR_VALUE       DA.BPVENDORS.BPVEN_BP_CODE%TYPE;
V_CUR_VALUE1      MAX_STRING%TYPE;
RECEPIENT         DA.BPVENDORS.BPVEN_PAY_EMAIL%TYPE := 'KRANTHI.PABBA@CADDELL.COM';
V_ERR_MSG         MAX_STRING%TYPE := '';
V_HEADER_TEXT     MAX_STRING%TYPE;
TEXT              MAX_STRING%TYPE := '';

HEADER_STRING     VARCHAR2(83);
COLUMN_HEADER     VARCHAR2(50);
V_HEADER_L1       HEADER_STRING%TYPE := 'ELECTRONIC FUNDS TRANSFER PAYMENT NOTIFICATION';
V_HEADER_L2       HEADER_STRING%TYPE := 'from';
V_HEADER_L3       HEADER_STRING%TYPE := 'Caddell Construction Co., Inc.';
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

CURSOR CUR_VEN_DET(PC_BP_CODE IN VARCHAR2) IS
  SELECT VEN.BPVEN_BP_CODE  BP_CODE
       , BP.BP_NAME         BP_NAME
       , BP.BP_CREATE_DATE  CREATE_DATE
       --, VEN.BPVEN_BP_CODE
    FROM DA.BPVENDORS VEN
       , DA.BPARTNERS BP
       , DA.CHEQUE CHK
   WHERE VEN.BPVEN_BP_CODE = BP.BP_CODE
     AND BP.BP_CODE = CHK.CHQ_VEN_CODE
     AND VEN.BPVEN_BP_CODE = PC_BP_CODE;

CUR_VEN_DET_REC   CUR_VEN_DET%ROWTYPE;

BEGIN

DBMS_OUTPUT.PUT_LINE(1);

DELETE FROM DA1.VENDOR_DIRDEP_EMAIL
 WHERE TRUNC(VDE_PROCESS_DATE) <= TRUNC(SYSDATE)-30
    OR ( VDE_STATUS = 'NOT SENT'
     AND TRUNC(VDE_PROCESS_DATE ) = TRUNC(SYSDATE)
       );
COMMIT;

DBMS_OUTPUT.PUT_LINE(2);

V_SQLSTMT := 'SELECT DISTINCT VEN.BPVEN_BP_CODE BP_CODE '
          || 'FROM DA.BPVENDORS VEN, '
          || '(SELECT DISTINCT EMAIL.VDE_BP_CODE VDE_BP_CODE '
          || 'FROM DA1.VENDOR_DIRDEP_EMAIL EMAIL '
          || 'WHERE TRUNC(EMAIL.VDE_PROCESS_DATE ) = TRUNC(SYSDATE) '
          || 'AND EMAIL.VDE_STATUS = ''SENT'') MAIL '
          || 'WHERE VEN.BPVEN_BP_CODE = MAIL.VDE_BP_CODE (+) '
          || 'AND MAIL.VDE_BP_CODE IS NULL '
          || 'AND VEN. BPVEN_BP_CODE IN '
          || FORMAT_STRING_FN(P_BP_CODE);

DBMS_OUTPUT.PUT_LINE(3);

OPEN CUR_VAR FOR V_SQLSTMT;
  LOOP

    BEGIN

      FETCH CUR_VAR INTO V_CUR_VALUE;
      EXIT WHEN CUR_VAR%NOTFOUND;

      V_HEADER_L5 := 'Payment Date: ' || SYSDATE || ' Reference: ' || '035685';
      V_HEADER_L7 := 'Vendor: ' || V_CUR_VALUE;
      V_HEADER_TEXT := '';

      V_HEADER_TEXT := '<TABLE WIDTH="100%"> <TR> <TH ALIGN="CENTER">' || V_HEADER_L1 ||'</TH> </TR>'
                    --|| CRLF
                    || '<TR> <TH ALIGN="CENTER">' || V_HEADER_L2 ||'</TH> </TR>'
                    --|| CRLF
                    || '<TR> <TH ALIGN="CENTER">' || V_HEADER_L3 ||'</TH> </TR>'
                    --|| CRLF
                    || '<TR> </TR>'
                    --|| CRLF
                    || '<TR> <TD ALIGN="CENTER">' || V_HEADER_L5 ||'</TD> </TR>'
                    --|| CRLF
                    || '<TR> </TR>'
                    --|| CRLF
                    || '<TR> <TD ALIGN="CENTER">' || V_HEADER_L7 ||'</TD> </TR>'
                    || '<TR> <HR> </TR>'
                    --|| CRLF
                    || '<TR> </TR> </TABLE>'
                    --|| CRLF
                    || '<TABLE WIDTH= "100%" ALIGN="CENTER"> <THEAD> <TR> <TH ROWSPAN="2" ALIGN="LEFT">' || V_CHEADER_1 ||'</TH> '                   
                    --|| CRLF
                    || '<TH ROWSPAN="2" ALIGN="LEFT">' || V_CHEADER_2 ||'</TH> ' --BGCOLOR="GRAY"
                    --|| CRLF
                    || '<TH ROWSPAN="2" ALIGN="LEFT">' || V_CHEADER_3 ||'</TH> '
                    --|| CRLF
                    || '<TH ROWSPAN="2" ALIGN="RIGHT">' || V_CHEADER_4 ||'</TH> '
                    --|| CRLF
                    || '<TH ROWSPAN="2" ALIGN="RIGHT">' || V_CHEADER_5 ||'</TH> '
                    --|| CRLF
                    || '<TH ROWSPAN="2" ALIGN="RIGHT">' || V_CHEADER_6 ||'</TH> </TR> </THEAD>';
                    --|| CRLF
                    --|| '<TR> <TD>' || 
                    
DBMS_OUTPUT.PUT_LINE(4);

      OPEN CUR_VEN_DET(V_CUR_VALUE);
        LOOP

          V_ERR_MSG := 'BP_CODE:' || V_CUR_VALUE || ', ' || 'EMAIL:' || RECEPIENT || '--';

          FETCH CUR_VEN_DET INTO CUR_VEN_DET_REC;
          EXIT WHEN CUR_VEN_DET%NOTFOUND;
          IF V_LOOP_CNT = 0
          THEN
            TEXT := --V_HEADER_TEXT
                 --|| 
                 '<TR> </TR>' 
                 || '<TBODY> <TR> <TD>' || CUR_VEN_DET_REC.BP_CODE ||'</TD> '
                 || '<TD>' || CUR_VEN_DET_REC.BP_NAME ||'</TD> '
                 || '<TD>' || CUR_VEN_DET_REC.CREATE_DATE ||'</TD> '
                 || '<TD ALIGN="RIGHT">' || 'AA' ||'</TD> ' 
                 || '<TD ALIGN="RIGHT">' || 'AA' ||'</TD> ' 
                 || '<TD ALIGN="RIGHT">' || 'AA' ||'</TD> </TR>';
            V_LOOP_CNT := V_LOOP_CNT+1;
          ELSE
            TEXT := TEXT
                 || '<TR> <TD>' || CUR_VEN_DET_REC.BP_CODE ||'</TD> '
                 || '<TD>' || CUR_VEN_DET_REC.BP_NAME ||'</TD> '
                 || '<TD>' || CUR_VEN_DET_REC.CREATE_DATE ||'</TD> '
                 || '<TD ALIGN="RIGHT">' || 'AA' ||'</TD> ' 
                 || '<TD ALIGN="RIGHT">' || 'AA' ||'</TD> ' 
                 || '<TD ALIGN="RIGHT">' || 'AA' ||'</TD> </TR>';
               --|| CUR_VEN_DET_REC.DATA1;
          END IF;
        END LOOP;
            TEXT := TEXT || '</TBODY> </TABLE>';
      CLOSE CUR_VEN_DET;

      IF V_LOOP_CNT <> 0
      THEN

DBMS_OUTPUT.PUT_LINE(5);

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
        UTL_SMTP.WRITE_DATA(V_CONN, 'SUBJECT: ' || V_CUR_VALUE || '_CHEQUE' || UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(V_CONN, 'MIME-VERSION: 1.0' || UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(V_CONN, 'CONTENT-TYPE: TEXT/HTML' || UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(V_CONN, 'REPLY-TO: ' || P_REPLY_TO || UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(V_CONN, UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(V_CONN, V_HEADER_TEXT);
        UTL_SMTP.WRITE_DATA(V_CONN, TEXT);
        UTL_SMTP.WRITE_DATA(V_CONN, UTL_TCP.CRLF);

DBMS_OUTPUT.PUT_LINE(6);

        UTL_SMTP.CLOSE_DATA(V_CONN);
        UTL_SMTP.QUIT(V_CONN);

DBMS_OUTPUT.PUT_LINE(7);

        INSERT INTO DA1.VENDOR_DIRDEP_EMAIL(VDE_BP_CODE
                                          , VDE_EMAIL_ID
                                          , VDE_STATUS
                                          , VDE_PROCESS_DATE
                                          , VDE_DESCRIPTION
                                           )
            VALUES (V_CUR_VALUE
                  , RECEPIENT
                  , 'SENT'
                  , TO_DATE(TO_CHAR(SYSDATE, 'DD-MON-YY HH:MI:SS'), 'DD-MON-YY HH:MI:SS')
                  , 'SUCCESSFUL'
                   );
        COMMIT;

DBMS_OUTPUT.PUT_LINE(8);

      ELSE
        V_ERR_MSG := V_ERR_MSG || 'NO INVOICE INFO FOUND FOR VENDOR TO ATTACH IN EMAIL';
        INSERT INTO DA1.VENDOR_DIRDEP_EMAIL(VDE_BP_CODE
                                          , VDE_EMAIL_ID
                                          , VDE_STATUS
                                          , VDE_PROCESS_DATE
                                          , VDE_DESCRIPTION
                                           )
            VALUES (V_CUR_VALUE
                  , RECEPIENT
                  , 'NOT SENT'
                  , TO_DATE(TO_CHAR(SYSDATE, 'DD-MON-YY HH:MI:SS'), 'DD-MON-YY HH:MI:SS')
                  , V_ERR_MSG
                   );
        COMMIT;

DBMS_OUTPUT.PUT_LINE(9);

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
            INSERT INTO DA1.VENDOR_DIRDEP_EMAIL(VDE_BP_CODE
                                              , VDE_EMAIL_ID
                                              , VDE_STATUS
                                              , VDE_PROCESS_DATE
                                              , VDE_DESCRIPTION
                                               )
                VALUES (V_CUR_VALUE
                      , RECEPIENT
                      , 'NOT SENT'
                      , TO_DATE(TO_CHAR(SYSDATE, 'DD-MON-YY HH:MI:SS'), 'DD-MON-YY HH:MI:SS')
                      , V_ERR_MSG
                       );
            COMMIT;
            
              EXCEPTION
                WHEN UTL_SMTP.TRANSIENT_ERROR OR UTL_SMTP.PERMANENT_ERROR 
                  THEN
                    NULL; -- WHEN THE SMTP SERVER IS DOWN OR UNAVAILABLE, WE DON'T HAVE
                          -- A CONNECTION TO THE SERVER. THE QUIT CALL WILL RAISE AN
                          -- EXCEPTION THAT WE CAN IGNORE.                        
          END;
          
            V_LOOP_CNT :=0;
            V_ERR_MSG := V_ERR_MSG || SUBSTR(SQLERRM, 1, 500-LENGTH(V_ERR_MSG));
            INSERT INTO DA1.VENDOR_DIRDEP_EMAIL(VDE_BP_CODE
                                              , VDE_EMAIL_ID
                                              , VDE_STATUS
                                              , VDE_PROCESS_DATE
                                              , VDE_DESCRIPTION
                                               )
                VALUES (V_CUR_VALUE
                      , RECEPIENT
                      , 'NOT SENT'
                      , TO_DATE(TO_CHAR(SYSDATE, 'DD-MON-YY HH:MI:SS'), 'DD-MON-YY HH:MI:SS')
                      , V_ERR_MSG
                       );
            COMMIT;      
        WHEN OTHERS
          THEN
            UTL_SMTP.CLOSE_DATA(V_CONN);
            UTL_SMTP.QUIT(V_CONN);
            V_LOOP_CNT :=0;
            V_ERR_MSG := V_ERR_MSG || SUBSTR(SQLERRM, 1, 500-LENGTH(V_ERR_MSG));
            INSERT INTO DA1.VENDOR_DIRDEP_EMAIL(VDE_BP_CODE
                                              , VDE_EMAIL_ID
                                              , VDE_STATUS
                                              , VDE_PROCESS_DATE
                                              , VDE_DESCRIPTION
                                               )
                VALUES (V_CUR_VALUE
                      , RECEPIENT
                      , 'NOT SENT'
                      , TO_DATE(TO_CHAR(SYSDATE, 'DD-MON-YY HH:MI:SS'), 'DD-MON-YY HH:MI:SS')
                      , V_ERR_MSG
                       );
            COMMIT;
/* EXCEPTION HANDLING IN THE LOOP */

    END;
  END LOOP;
CLOSE CUR_VAR;

------------ Sending email to Andy about Vendors who have not recieved emails.
BEGIN
DBMS_OUTPUT.PUT_LINE(2);
V_SQLSTMT := 'SELECT DISTINCT VDE_BP_CODE || '' '' || '
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
    TEXT:= 'Vendor list could not be generated because of the below error from Oracle, '
        || 'but below given query can be run against databse to see the vendors who were not sent an email.'
        || CRLF || CRLF
        || SQLERRM
        || CRLF
        || 'SELECT DISTINCT VDE_BP_CODE, VDE_PROCESS_DATE, VDE_DESCRIPTION '
        || 'FROM VENDOR_DIRDEP_EMAIL '
        || 'WHERE TRUNC(VDE_PROCESS_DATE) = TRUNC(SYSDATE) '
        || 'AND VDE_STATUS <> ''SENT'' ';

    UTL_MAIL.SEND_ATTACH_VARCHAR2(SENDER => P_SENDER
                                , RECIPIENTS => P_REPLY_TO
                                , SUBJECT => 'Error Vendor list'
                                , MESSAGE => 'List of vendors who did not recieve the emails could not be generated. '
                                          || 'Please see the attached file for more information. '
                                , ATTACHMENT => TEXT
                                , ATT_FILENAME => 'err_vend_no_email'
                                 );

END;
DBMS_OUTPUT.PUT_LINE(10);
-------------

RETURN(P_BP_CODE);

EXCEPTION
  WHEN OTHERS
    THEN
--     UTL_SMTP.CLOSE_DATA(V_CONN);
--     UTL_SMTP.QUIT(V_CONN);
      RAISE_APPLICATION_ERROR(-20004, V_ERR_MSG || SQLERRM);

END VEN_DIRDEP_EMAIL_FN1;

----------------------------------------------------------------------------------------

FUNCTION VEN_DIRDEP_EMAIL_FN2 (P_EMAIL_SERVER IN VARCHAR2
                             , P_SENDER IN VARCHAR2
                             , P_PASSWORD IN VARCHAR2
                             , P_REPLY_TO IN VARCHAR2
                             , P_BP_CODE IN VARCHAR2
                              )
  RETURN VARCHAR2
IS
PRAGMA AUTONOMOUS_TRANSACTION;

V_SQLSTMT         MAX_STRING%TYPE;
CUR_VAR           CUR_REF;
V_LOOP_CNT        NUMBER :=0 ;
V_CUR_VALUE       DA.BPVENDORS.BPVEN_BP_CODE%TYPE;
V_CUR_VALUE1      MAX_STRING%TYPE;
RECEPIENT         DA.BPVENDORS.BPVEN_PAY_EMAIL%TYPE :='KRANTHI.PABBA@CADDELL.COM';
V_ERR_MSG         MAX_STRING%TYPE := '';
V_HEADER_TEXT     MAX_STRING%TYPE;
TEXT              MAX_STRING%TYPE;

HEADER_STRING     VARCHAR2(83);
COLUMN_HEADER     VARCHAR2(50);
V_HEADER_L1       HEADER_STRING%TYPE := 'ELECTRONIC FUNDS TRANSFER PAYMENT NOTIFICATION';
V_HEADER_L2       HEADER_STRING%TYPE := 'from';
V_HEADER_L3       HEADER_STRING%TYPE := 'Caddell Construction Co., Inc.';
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

CURSOR CUR_VEN_DET(PC_BP_CODE IN VARCHAR2) IS
  SELECT VEN.BPVEN_BP_CODE  BP_CODE
       , BP.BP_NAME         BP_NAME
       , BP.BP_CREATE_DATE  CREATE_DATE
       --, VEN.BPVEN_BP_CODE
    FROM DA.BPVENDORS VEN
       , DA.BPARTNERS BP
       , DA.CHEQUE CHK
   WHERE VEN.BPVEN_BP_CODE = BP.BP_CODE
     AND BP.BP_CODE = CHK.CHQ_VEN_CODE
     AND VEN.BPVEN_BP_CODE = PC_BP_CODE;
CUR_VEN_DET_REC   CUR_VEN_DET%ROWTYPE;

BEGIN

V_SQLSTMT := 'SELECT DISTINCT VEN.BPVEN_BP_CODE BP_CODE '
          || 'FROM DA.BPVENDORS VEN, '
          || 'WHERE VEN. BPVEN_BP_CODE IN '
          || FORMAT_STRING_FN(P_BP_CODE);

OPEN CUR_VAR FOR V_SQLSTMT;
  LOOP

    BEGIN

      FETCH CUR_VAR INTO V_CUR_VALUE;
      EXIT WHEN CUR_VAR%NOTFOUND;

      V_HEADER_L5 := 'Payment Date: ' || SYSDATE || ' Reference: ' || '035685';
      V_HEADER_L7 := 'Vendor: ' || V_CUR_VALUE;
      V_HEADER_TEXT := '';

      V_HEADER_TEXT := '<TABLE WIDTH="100%"> <TR> <TH ALIGN="CENTER">' || V_HEADER_L1 ||'</TH> </TR>'
                    --|| CRLF
                    || '<TR> <TH ALIGN="CENTER">' || V_HEADER_L2 ||'</TH> </TR>'
                    --|| CRLF
                    || '<TR> <TH ALIGN="CENTER">' || V_HEADER_L3 ||'</TH> </TR>'
                    --|| CRLF
                    || '<TR> </TR>'
                    --|| CRLF
                    || '<TR> <TD ALIGN="CENTER">' || V_HEADER_L5 ||'</TD> </TR>'
                    --|| CRLF
                    || '<TR> </TR>'
                    --|| CRLF
                    || '<TR> <TD ALIGN="CENTER">' || V_HEADER_L7 ||'</TD> </TR>'
                    || '<TR> <HR> </TR>'
                    --|| CRLF
                    || '<TR> </TR> </TABLE>'
                    --|| CRLF
                    || '<TABLE WIDTH= "100%" ALIGN="CENTER"> <THEAD> <TR> <TH ROWSPAN="2" ALIGN="LEFT">' || V_CHEADER_1 ||'</TH> '                   
                    --|| CRLF
                    || '<TH ROWSPAN="2" ALIGN="LEFT">' || V_CHEADER_2 ||'</TH> ' --BGCOLOR="GRAY"
                    --|| CRLF
                    || '<TH ROWSPAN="2" ALIGN="LEFT">' || V_CHEADER_3 ||'</TH> '
                    --|| CRLF
                    || '<TH ROWSPAN="2" ALIGN="RIGHT">' || V_CHEADER_4 ||'</TH> '
                    --|| CRLF
                    || '<TH ROWSPAN="2" ALIGN="RIGHT">' || V_CHEADER_5 ||'</TH> '
                    --|| CRLF
                    || '<TH ROWSPAN="2" ALIGN="RIGHT">' || V_CHEADER_6 ||'</TH> </TR> </THEAD>';
                    --|| CRLF
                    --|| '<TR> <TD>' || 

      OPEN CUR_VEN_DET(V_CUR_VALUE);
        LOOP

          V_ERR_MSG := 'BP_CODE:' || V_CUR_VALUE || ', ' || 'EMAIL:' || RECEPIENT || '--';

          FETCH CUR_VEN_DET INTO CUR_VEN_DET_REC;
          EXIT WHEN CUR_VEN_DET%NOTFOUND;
          IF V_LOOP_CNT = 0
          THEN
            TEXT := --V_HEADER_TEXT
                 --|| 
                 '<TR> </TR>' 
                 || '<TBODY> <TR> <TD>' || CUR_VEN_DET_REC.BP_CODE ||'</TD> '
                 || '<TD>' || CUR_VEN_DET_REC.BP_NAME ||'</TD> '
                 || '<TD>' || CUR_VEN_DET_REC.CREATE_DATE ||'</TD> '
                 || '<TD ALIGN="RIGHT">' || 'AA' ||'</TD> ' 
                 || '<TD ALIGN="RIGHT">' || 'AA' ||'</TD> ' 
                 || '<TD ALIGN="RIGHT">' || 'AA' ||'</TD> </TR>';
            V_LOOP_CNT := V_LOOP_CNT+1;
          ELSE
            TEXT := TEXT
                 || '<TR> <TD>' || CUR_VEN_DET_REC.BP_CODE ||'</TD> '
                 || '<TD>' || CUR_VEN_DET_REC.BP_NAME ||'</TD> '
                 || '<TD>' || CUR_VEN_DET_REC.CREATE_DATE ||'</TD> '
                 || '<TD ALIGN="RIGHT">' || 'AA' ||'</TD> ' 
                 || '<TD ALIGN="RIGHT">' || 'AA' ||'</TD> ' 
                 || '<TD ALIGN="RIGHT">' || 'AA' ||'</TD> </TR>';
                 --|| CUR_VEN_DET_REC.DATA1;
          END IF;
        END LOOP;
            TEXT := TEXT || '</TBODY> </TABLE>';
      CLOSE CUR_VEN_DET;
      IF V_LOOP_CNT <> 0
      THEN

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
        UTL_SMTP.WRITE_DATA(V_CONN, 'SUBJECT: ' || V_CUR_VALUE || '_CHEQUE' || UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(V_CONN, 'MIME-VERSION: 1.0' || UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(V_CONN, 'CONTENT-TYPE: TEXT/PLAIN' || UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(V_CONN, 'REPLY-TO: ' || P_REPLY_TO || UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(V_CONN, UTL_TCP.CRLF);
        UTL_SMTP.WRITE_DATA(V_CONN, V_HEADER_TEXT);
        UTL_SMTP.WRITE_DATA(V_CONN, TEXT);
        UTL_SMTP.WRITE_DATA(V_CONN, UTL_TCP.CRLF);

        UTL_SMTP.CLOSE_DATA(V_CONN);
        UTL_SMTP.QUIT(V_CONN);

        COMMIT;
      ELSE
    V_ERR_MSG := V_ERR_MSG || 'INVOICE INFO NOT FOUND.';
    UTL_MAIL.SEND(SENDER => P_SENDER
                , RECIPIENTS => P_REPLY_TO
                , SUBJECT => 'Email Failed for Vendor: ' || V_CUR_VALUE
                , MESSAGE => V_ERR_MSG
                 );
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
            UTL_MAIL.SEND(SENDER => P_SENDER
                        , RECIPIENTS => P_REPLY_TO
                        , SUBJECT => 'Email Failed for Vendor: ' || V_CUR_VALUE
                        , MESSAGE => V_ERR_MSG
                         );            
            EXCEPTION
              WHEN UTL_SMTP.TRANSIENT_ERROR OR UTL_SMTP.PERMANENT_ERROR THEN
              NULL; -- WHEN THE SMTP SERVER IS DOWN OR UNAVAILABLE, WE DON'T HAVE
                    -- A CONNECTION TO THE SERVER. THE QUIT CALL WILL RAISE AN
                    -- EXCEPTION THAT WE CAN IGNORE.                        
          END;
          UTL_SMTP.CLOSE_DATA(V_CONN);
          UTL_SMTP.QUIT(V_CONN);             
          V_LOOP_CNT :=0;
          V_ERR_MSG := V_ERR_MSG || SUBSTR(SQLERRM, 1, 500-LENGTH(V_ERR_MSG));
          UTL_MAIL.SEND(SENDER => P_SENDER
                      , RECIPIENTS => P_REPLY_TO
                      , SUBJECT => 'Email Failed for Vendor: ' || V_CUR_VALUE
                      , MESSAGE => V_ERR_MSG
                       );
        WHEN OTHERS
        THEN
          UTL_SMTP.CLOSE_DATA(V_CONN);
          UTL_SMTP.QUIT(V_CONN);
          V_LOOP_CNT :=0;
          V_ERR_MSG := V_ERR_MSG || SUBSTR(SQLERRM, 1, 500-LENGTH(V_ERR_MSG));
          UTL_MAIL.SEND(SENDER => P_SENDER
                      , RECIPIENTS => P_REPLY_TO
                      , SUBJECT => 'Email Failed for Vendor: ' || V_CUR_VALUE
                      , MESSAGE => V_ERR_MSG
                       );
/* EXCEPTION HANDLING IN THE LOOP */
    END;
  END LOOP;
CLOSE CUR_VAR;

RETURN(P_BP_CODE);

EXCEPTION
  WHEN OTHERS
    THEN
--      UTL_SMTP.CLOSE_DATA(V_CONN);
--      UTL_SMTP.QUIT(V_CONN);
      RAISE_APPLICATION_ERROR(-20004, V_ERR_MSG || SQLERRM);

END VEN_DIRDEP_EMAIL_FN2;

----------------------------------------------------------------------------------------
Procedure UPDATE_EFTPRENOTE
IS
--v_date         varchar2(20);
v_sqlstmt        MAX_STRING%TYPE;
cur_var          CUR_REF;
v_batch_val      MAX_STRING%TYPE;
v_batch_str      MAX_STRING%TYPE:= '-000';
--v_loop_cnt     NUMBER:=0;

begin

--v_date = to_char(p_date, 'DD-MON-YY');

    v_sqlstmt := 'UPDATE DA1.PYEMPLOYEE_TABLE '
              || 'SET EMP_FIRST_NAME = ''N'' '
              || 'WHERE EMP_NO IN '
              || v_batch_str;

--DynamicExecute(v_sqlstmt );

EXECUTE IMMEDIATE v_sqlstmt;
COMMIT;

  v_sqlstmt := 'SELECT distinct EMP_NO '
             || 'FROM DA1.PYEMPLOYEE_TABLE '
             || 'WHERE EMP_FIRST_NAME IN (''Y'')';

    OPEN cur_var FOR v_sqlstmt;

      LOOP

         FETCH cur_var
          INTO v_batch_val;

         EXIT WHEN cur_var%NOTFOUND;

         v_batch_str := v_batch_str || ', ' || v_batch_val;

      END LOOP;

 CLOSE cur_var;

v_batch_str := '(' || v_batch_str || ')';

--RETURN ('Y');

/*
 	v_cnt_err := v_cnt_err+1;
	INSERT into da1.errors(ers_order, ers_table_name, ers_column_name)
	values(v_cnt_err,v_tab_name,'CONSTRUCT COMPLETE');
commit;
DBMS_OUTPUT.PUT_LINE ('BATCH STRING CONSTRUCT successful.');
*/

  EXCEPTION
    WHEN OTHERS
    THEN
        RAISE_APPLICATION_ERROR(-20036, SQLERRM);

end update_eftprenote;

----------------------------------------------------------------------------------------

FUNCTION CALL_FN (P_NAME VARCHAR2) RETURN VARCHAR2
AS
BEGIN

RETURN p_NAME;

--return NULL;

end call_fn;

END EUL_DISCO_PKG;

/
