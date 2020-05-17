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
-- Global Declarations
  TYPE CUR_REF IS  REF CURSOR; 
  MAX_STRING VARCHAR2(32767);
  
  FUNCTION UPDATE_EFTPRENOTE_FN RETURN VARCHAR2;  -- USED IN COMPASS_NACHA_VENDOR_REPORT
  
  FUNCTION SET_CONTEXT
  ( 
    P_NAME VARCHAR2,
    P_VALUE VARCHAR2
  ) RETURN VARCHAR2;
  
  FUNCTION SHOW_CONTEXT(P_NAME VARCHAR2) RETURN VARCHAR2;
  
  PROCEDURE UPDATE_EFTPRENOTE;

  FUNCTION CALL_FN (P_NAME VARCHAR2) RETURN VARCHAR2;

END EUL_DISCO_PKG;

/


CREATE OR REPLACE PACKAGE BODY     EUL_DISCO_PKG
IS

----------------------------------------------------------------------------------------

FUNCTION UPDATE_EFTPRENOTE_FN RETURN VARCHAR2 -- USED IN COMPASS_NACHA_VENDOR_REPORT
IS
PRAGMA AUTONOMOUS_TRANSACTION;

V_SQLSTMT          MAX_STRING%TYPE;
--CUR_VAR          CUR_REF;

BEGIN

--  DBMS_OUTPUT.PUT_LINE ('1');
/*
    v_sqlstmt := 'UPDATE DA.UETD_EFTPRENOT '       
              || 'SET BPPRENOTE = ''SENT'' '
              || 'WHERE BPPRENOTE = ''REPORTED''';
  EXECUTE IMMEDIATE v_sqlstmt;
  COMMIT;
*/  
--    DBMS_OUTPUT.PUT_LINE ('2');

  V_SQLSTMT := 'UPDATE DA.UETD_EFTPRENOT '
            || 'SET BPPRENOTE = ''SENT'' '
            || 'WHERE BPPRENOTE = ''SEND'' '
            || 'AND (COMP_CODE, VEN_CODE) IN '
            || '(SELECT BPVEN_COMP_CODE, BPVEN_BP_CODE '
            || 'FROM DA.BPVENDORS '
            || 'WHERE BPVEN_COMP_CODE NOT IN (''ZZ'') '
            || 'AND BPVEN_BANK_ACC_NUM1 IS NOT NULL)'; 
            
  EXECUTE IMMEDIATE v_sqlstmt;
  COMMIT;
  
--    DBMS_OUTPUT.PUT_LINE ('3');
    
  RETURN (NULL);

  EXCEPTION
    WHEN OTHERS
    THEN
      RAISE_APPLICATION_ERROR(-20036, SQLERRM); 
        
END UPDATE_EFTPRENOTE_FN;

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

  V_CONTEXT CONSTANT MAX_STRING%TYPE :='DISCO_CONTEXT';

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

    v_sqlstmt := 'UPDATE DA1.PYEMPLOYEE_TABLE '      || 
                    'SET EMP_FIRST_NAME = ''N'' '    || 
                    'WHERE EMP_NO IN '               || v_batch_str;

--DynamicExecute(v_sqlstmt );
                    
EXECUTE IMMEDIATE v_sqlstmt;
COMMIT;

   v_sqlstmt := 'SELECT distinct EMP_NO ';
   v_sqlstmt := v_sqlstmt 
             || ' from DA1.PYEMPLOYEE_TABLE where EMP_FIRST_NAME IN (''Y'')';        

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
