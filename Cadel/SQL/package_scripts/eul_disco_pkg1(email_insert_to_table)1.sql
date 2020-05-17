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

  FUNCTION SET_CONTEXT (P_NAME VARCHAR2,
                        P_VALUE VARCHAR2
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
FNAME             VARCHAR2(10) :='VEN_PAY';
SENDER            VARCHAR2(50) :='ORACLE.DBA@CADDELL.COM';
RECEPIENT         DA.BPVENDORS.BPVEN_PAY_EMAIL%TYPE :='KRANTHI.PABBA@CADDELL.COM';
V_ERR_MSG         MAX_STRING%TYPE := '';
TEXT              MAX_STRING%TYPE;

--'REA001','READ001','REAM001'

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

--'REA001','READ001','REAM001'
--REC1 CUR_DATE%ROWTYPE;

BEGIN

DELETE FROM DA1.VENDOR_DIRDEP_EMAIL
 WHERE TRUNC(VDE_PROCESS_DATE) <= TRUNC(SYSDATE)-30;
COMMIT; 

V_SQLSTMT := 'SELECT DISTINCT VEN.BPVEN_BP_CODE BP_CODE '
          || 'FROM DA.BPVENDORS VEN, DA1.VENDOR_DIRDEP_EMAIL MAIL '
          || 'WHERE  VEN.BPVEN_BP_CODE = MAIL.VDE_BP_CODE (+) '
          || 'AND MAIL.VDE_STATUS = ''SENT'' '
          || 'AND MAIL.VDE_BP_CODE IS NULL '
          || 'AND VEN. BPVEN_BP_CODE IN '
          || FORMAT_STRING_FN(P_BP_CODE);

--DBMS_OUTPUT.PUT_LINE(1);
--DBMS_OUTPUT.PUT_LINE(FORMAT_STRING_FN(P_BP_CODE));

OPEN CUR_VAR FOR V_SQLSTMT;       
  LOOP
    FETCH CUR_VAR INTO V_CUR_VALUE;
    EXIT WHEN CUR_VAR%NOTFOUND;          
    
    --DBMS_OUTPUT.PUT_LINE(2);
   
    OPEN CUR_VEN_DET(V_CUR_VALUE);
      LOOP
        FETCH CUR_VEN_DET INTO CUR_VEN_DET_REC;
        EXIT WHEN CUR_VEN_DET%NOTFOUND;
        --DBMS_OUTPUT.PUT_LINE(3);  
        --  IF REC1.BP_CODE = REC2.BP_CODE
        --  THEN                     
        IF V_LOOP_CNT = 0
        THEN
          TEXT := CUR_VEN_DET_REC.DATA1;
          V_LOOP_CNT := V_LOOP_CNT+1;
        ELSE
          TEXT := TEXT || CHR(13) || CHR(10) || CUR_VEN_DET_REC.DATA1; 
        END IF;
        -- END IF;
      END LOOP;
    CLOSE CUR_VEN_DET;  
   
    --DBMS_OUTPUT.PUT_LINE(4);   
    
    V_ERR_MSG := 'BP_CODE:' || V_CUR_VALUE || ', ' || 'EMAIL:' || RECEPIENT;
    
    IF V_LOOP_CNT <> 0
    THEN    
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
                 , 'VENDOR INFO NOT FOUND'
                  );
       COMMIT; 
     END IF;
     
    --DBMS_OUTPUT.PUT_LINE(5);

    V_LOOP_CNT :=0;
  END LOOP;
CLOSE CUR_VAR;

--DBMS_OUTPUT.PUT_LINE(6);

RETURN(P_BP_CODE);

EXCEPTION
  WHEN OTHERS 
    THEN
    
      --  DBMS_OUTPUT.PUT_LINE('ERROR');
     
      RAISE_APPLICATION_ERROR(-20004, V_ERR_MSG || '-' || SQLERRM);   

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

----------------------------------------------------------------------------------------

END EUL_DISCO_PKG;
/
