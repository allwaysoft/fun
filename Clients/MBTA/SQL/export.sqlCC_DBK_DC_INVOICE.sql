CREATE OR REPLACE PACKAGE    CC_Dbk_Dc_Invoice AS

 PROCEDURE Verify_data;

 PROCEDURE Process_Temp_Data;

END CC_Dbk_Dc_Invoice;
/


CREATE OR REPLACE PACKAGE BODY    CC_Dbk_Dc_Invoice AS

--=====================================================================
-- DISPLAY_STATUS
--  display status, put result into da.dc_import_status table too
--=====================================================================
--display_status
PROCEDURE display_status(text VARCHAR2) AS
BEGIN
        da.Dbk_Dc.display_status('DC_INVOICE',text);
END display_status;


--======================================================================
--FK_CON check foreign constrains
--======================================================================
PROCEDURE FK_CON AS

CURSOR cur_INVOICE_ARINVSERC_FK IS
  SELECT dc_rownum,
         INV_SER_CODE,
         INV_COMP_CODE
        FROM DA.DC_INVOICE  T1
        WHERE NOT EXISTS
           (SELECT '1'
              FROM DA.ARINVSERC T2
                WHERE NVL(T1.INV_SER_CODE,T2.ARI_INV_SER_CODE) = T2.ARI_INV_SER_CODE
                  AND NVL(T1.INV_COMP_CODE,T2.ARI_COMP_CODE) = T2.ARI_COMP_CODE );

CURSOR cur_INVOICE_COMPANY_FK IS
  SELECT dc_rownum,
         INV_COMP_CODE
        FROM DA.DC_INVOICE  T1
        WHERE NOT EXISTS
           (SELECT '1'
              FROM DA.COMPANY T2
                WHERE NVL(T1.INV_COMP_CODE,T2.COMP_CODE) = T2.COMP_CODE );

CURSOR cur_INVOICE_BPCUSTOMERS_FK IS
  SELECT dc_rownum,
         INV_COMP_CODE,
         INV_CUST_CODE
        FROM DA.DC_INVOICE  T1
        WHERE NOT EXISTS
           (SELECT '1'
              FROM DA.BPCUSTOMERS T2
                WHERE NVL(T1.INV_COMP_CODE,T2.BPCUST_COMP_CODE) = T2.BPCUST_COMP_CODE
                  AND NVL(T1.INV_CUST_CODE,T2.BPCUST_BP_CODE) = T2.BPCUST_BP_CODE );

BEGIN
NULL;
--INVOICE_ARINVSERC_FK
 FOR row_dc IN cur_INVOICE_ARINVSERC_FK
LOOP
  IF ( row_dc.INV_SER_CODE IS NOT NULL
         AND  row_dc.INV_COMP_CODE IS NOT NULL  ) THEN
         da.Dbk_Dc.error('DC_INVOICE',
                                 row_dc.dc_rownum,
                                 'INVOICE_ARINVSERC_FK',
                                 'ARINVSERC',
                'Record with '|| ' ARI_INV_SER_CODE '||row_dc.INV_SER_CODE||
                ','||' ARI_COMP_CODE '||row_dc.INV_COMP_CODE||
                ' does not exist in DA.ARINVSERC table.');
 END IF;
END LOOP;
--INVOICE_COMPANY_FK
 FOR row_dc IN cur_INVOICE_COMPANY_FK
LOOP
  IF ( row_dc.INV_COMP_CODE IS NOT NULL  ) THEN
         da.Dbk_Dc.error('DC_INVOICE',
                                 row_dc.dc_rownum,
                                 'INVOICE_COMPANY_FK',
                                 'COMPANY',
                'Record with '|| ' COMP_CODE '||row_dc.INV_COMP_CODE||
                ' does not exist in DA.COMPANY table.');
 END IF;
END LOOP;
--INVOICE_BPCUSTOMERS_FK
 FOR row_dc IN cur_INVOICE_BPCUSTOMERS_FK
LOOP
  IF ( row_dc.INV_COMP_CODE IS NOT NULL
         AND  row_dc.INV_CUST_CODE IS NOT NULL  ) THEN
         da.Dbk_Dc.error('DC_INVOICE',
                                 row_dc.dc_rownum,
                                 'INVOICE_BPCUSTOMERS_FK',
                                 'BPCUSTOMERS',
                'Record with '|| ' BPCUST_COMP_CODE '||row_dc.INV_COMP_CODE||
                ','||' BPCUST_BP_CODE '||row_dc.INV_CUST_CODE||
                ' does not exist in DA.BPCUSTOMERS table.');
 END IF;
END LOOP;

END FK_CON;


--======================================================================
--CHECK_CON
--======================================================================
PROCEDURE CHECK_CON AS
--SYS_C0049623 - "INV_COMP_CODE" IS NOT NULL
 CURSOR cur_SYS_C0049623 IS
        SELECT dc_rownum
          FROM DA.DC_INVOICE
            WHERE NOT "INV_COMP_CODE" IS NOT NULL ;

--SYS_C0049624 - "INV_NUM" IS NOT NULL
 CURSOR cur_SYS_C0049624 IS
        SELECT dc_rownum
          FROM DA.DC_INVOICE
            WHERE NOT "INV_NUM" IS NOT NULL ;

--INV_CON1 - INV_SOURCE_CODE IN ( 'R' , 'S' )
 CURSOR cur_INV_CON1 IS
        SELECT dc_rownum
          FROM DA.DC_INVOICE
            WHERE NOT INV_SOURCE_CODE IN ( 'R' , 'S' ) ;

BEGIN
NULL;

 FOR row_dc IN cur_SYS_C0049623
 LOOP
    da.Dbk_Dc.error('DC_INVOICE',
                    row_dc.dc_rownum,
                    'SYS_C0049623',
                    'SYS_C0049623',
                    'Condition "INV_COMP_CODE" IS NOT NULL failed.');
 END LOOP;

 FOR row_dc IN cur_SYS_C0049624
 LOOP
    da.Dbk_Dc.error('DC_INVOICE',
                    row_dc.dc_rownum,
                    'SYS_C0049624',
                    'SYS_C0049624',
                    'Condition "INV_NUM" IS NOT NULL failed.');
 END LOOP;

 FOR row_dc IN cur_INV_CON1
 LOOP
    da.Dbk_Dc.error('DC_INVOICE',
                    row_dc.dc_rownum,
                    'INV_CON1',
                    'INV_CON1',
                    'Condition INV_SOURCE_CODE IN ( ''R'' , ''S'' ) failed.');
 END LOOP;

END CHECK_CON;

--======================================================================
--IDX_CHECK - check if exists duplicates in DA.INVOICE table
--======================================================================
PROCEDURE IDX_CHECK AS

--INVOICE_PK
CURSOR cur_INVOICE_PK IS
  SELECT dc_rownum,
         INV_COMP_CODE,
         INV_NUM
    FROM DA.DC_INVOICE S1
      WHERE EXISTS (SELECT '1'
                      FROM DA.INVOICE S2
                        WHERE S1.INV_COMP_CODE = S2.INV_COMP_CODE
                          AND S1.INV_NUM = S2.INV_NUM );
BEGIN
 NULL;

--INVOICE_PK
 FOR row_dc IN cur_INVOICE_PK
 LOOP
        da.Dbk_Dc.error('DC_INVOICE',row_dc.dc_rownum,
                'INVOICE_PK',
                'INVOICE_PK',
                'Record with '||'INV_COMP_CODE '||row_dc.INV_COMP_CODE ||
                ', '||'INV_NUM '||row_dc.INV_NUM ||
                ' already exists in DA.INVOICE table.');

 END LOOP;
END IDX_CHECK;

--======================================================================
--IDX_DUPL - check if exists duplicates in DA.DC_INVOICE table
--======================================================================
PROCEDURE IDX_DUPL AS

--INVOICE_PK
CURSOR cur_INVOICE_PK IS
  SELECT dc_rownum,
         INV_COMP_CODE,
         INV_NUM
    FROM DA.DC_INVOICE S1
      WHERE
        EXISTS (SELECT '1'
                  FROM DA.DC_INVOICE S2
                    WHERE S1.INV_COMP_CODE = S2.INV_COMP_CODE
                      AND S1.INV_NUM = S2.INV_NUM
                      AND S1.ROWID != S2.ROWID );
BEGIN
 NULL;

--INVOICE_PK
 FOR row_dc IN cur_INVOICE_PK
 LOOP
        da.Dbk_Dc.error('DC_INVOICE',row_dc.dc_rownum,
                'INVOICE_PK',
                'INVOICE_PK',
                'Record with '||'INV_COMP_CODE '||row_dc.INV_COMP_CODE ||
                ', '||'INV_NUM '||row_dc.INV_NUM ||
                ' already exists in DA.DC_INVOICE table.');
END LOOP;
END IDX_DUPL;

--======================================================================
--INV_BCH_NUM
--======================================================================
PROCEDURE INV_BCH_NUM AS
  CURSOR cur_INV_BCH_NUM_null IS
    SELECT dc_rownum
      FROM DA.DC_INVOICE
        WHERE INV_BCH_NUM IS NULL;
BEGIN
  FOR row_dc IN cur_INV_BCH_NUM_null
  LOOP
        da.Dbk_Dc.error('DC_INVOICE',row_dc.dc_rownum,'INV_BCH_NUM',
        'INV_BCH_NUM',
        'INV_BCH_NUM can not be null.');
  END LOOP;
END INV_BCH_NUM;

--======================================================================
--INV_BCH_NUM_2
--======================================================================
PROCEDURE INV_BCH_NUM_2 AS
  CURSOR cur_INV_BCH_NUM_2 IS
    SELECT dc_rownum,
           INV_BCH_NUM
        FROM DA.DC_INVOICE T1
          WHERE INV_BCH_NUM IS NOT NULL
            AND EXISTS (SELECT '1'
                    FROM DA.ARBATCH_TABLE  T2
                      WHERE T1.INV_BCH_NUM = T2.ARBCH_NUM
                        AND T2.ARBCH_TYPE_CODE != 'T' );

BEGIN
  FOR row_dc IN cur_INV_BCH_NUM_2
  LOOP
    IF ( row_dc.INV_BCH_NUM IS NOT NULL ) THEN

        da.Dbk_Dc.error('DC_INVOICE',
                row_dc.dc_rownum,
                'INV_BCH_NUM',
                'ARBATCH_TABLE',
                'Record with'||
                ' ARBCH_NUM '||TO_CHAR(row_dc.INV_BCH_NUM) ||
                ' and ARBCH_TYPE_CODE != ''T'' '||
                ' exists in DA.ARBATCH_TABLE table.');
    END IF;
 END LOOP;

END INV_BCH_NUM_2;

--======================================================================
--INV_COMP_CODE
--======================================================================
PROCEDURE INV_COMP_CODE AS
  CURSOR cur_INV_COMP_CODE_null IS
    SELECT dc_rownum
      FROM DA.DC_INVOICE
        WHERE INV_COMP_CODE IS NULL;
BEGIN
  FOR row_dc IN cur_INV_COMP_CODE_null
  LOOP
        da.Dbk_Dc.error('DC_INVOICE',row_dc.dc_rownum,'INV_COMP_CODE',
        'INV_COMP_CODE',
        'INV_COMP_CODE can not be null.');
  END LOOP;
END INV_COMP_CODE;

--======================================================================
--INV_COMP_CODE_2
--======================================================================
PROCEDURE INV_COMP_CODE_2 AS
  CURSOR cur_INV_COMP_CODE IS
    SELECT dc_rownum,
           INV_COMP_CODE
      FROM DA.DC_INVOICE  ;

 t_result        da.Apkc.t_result_type%TYPE;
 t_comp_name     da.company.comp_name%TYPE;

BEGIN

 FOR row_dc IN cur_INV_COMP_CODE
 LOOP
   t_result := da.Apk_Gl_Company.chk(da.Apk_Util.context(DA.Apkc.IS_ON_FILE,DA.Apkc.IS_NOT_NULL),
              row_dc.INV_COMP_CODE,t_comp_name);
   IF ('0' != t_result) THEN
         da.Dbk_Dc.error('DC_INVOICE',
                row_dc.dc_rownum,
                'INV_COMP_CODE',
                 'COMP_CODE',
                 t_result);
   END IF;
 END LOOP;
END INV_COMP_CODE_2;

--======================================================================
--INV_NUM
--======================================================================
PROCEDURE INV_NUM AS
  CURSOR cur_INV_NUM_null IS
    SELECT dc_rownum
      FROM DA.DC_INVOICE
        WHERE INV_NUM IS NULL;
BEGIN
  FOR row_dc IN cur_INV_NUM_null
  LOOP
        da.Dbk_Dc.error('DC_INVOICE',row_dc.dc_rownum,'INV_NUM',
        'INV_NUM',
        'INV_NUM can not be null.');
  END LOOP;
END INV_NUM;

--======================================================================
--INV_CUST_CODE
--======================================================================
PROCEDURE INV_CUST_CODE AS
  CURSOR cur_INV_CUST_CODE_null IS
    SELECT dc_rownum
      FROM DA.DC_INVOICE
        WHERE INV_CUST_CODE IS NULL;
BEGIN
  FOR row_dc IN cur_INV_CUST_CODE_null
  LOOP
        da.Dbk_Dc.error('DC_INVOICE',row_dc.dc_rownum,'INV_CUST_CODE',
        'INV_CUST_CODE',
        'INV_CUST_CODE can not be null.');
  END LOOP;
END INV_CUST_CODE;

--======================================================================
--INV_DATE
--======================================================================
PROCEDURE INV_DATE AS
  CURSOR cur_INV_DATE_null IS
    SELECT dc_rownum
      FROM DA.DC_INVOICE
        WHERE INV_DATE IS NULL;
BEGIN
  FOR row_dc IN cur_INV_DATE_null
  LOOP
        da.Dbk_Dc.error('DC_INVOICE',row_dc.dc_rownum,'INV_DATE',
        'INV_DATE',
        'INV_DATE can not be null.');
  END LOOP;
END INV_DATE;

--======================================================================
--INV_DUE_DATE
--======================================================================
PROCEDURE INV_DUE_DATE AS
  CURSOR cur_INV_DUE_DATE_null IS
    SELECT dc_rownum
      FROM DA.DC_INVOICE
        WHERE INV_DUE_DATE IS NULL;

  CURSOR cur_due_date_before IS
    SELECT dc_rownum, inv_due_date, inv_date
	  FROM da.dc_invoice
	    WHERE inv_date     IS NOT NULL
		  AND inv_due_date IS NOT NULL
		  AND inv_due_date < inv_date;
BEGIN
  FOR row_dc IN cur_INV_DUE_DATE_null
  LOOP
        da.Dbk_Dc.error('DC_INVOICE',row_dc.dc_rownum,'INV_DUE_DATE',
        'INV_DUE_DATE',
        'INV_DUE_DATE cannot be null.');
  END LOOP;

  FOR row_dc IN cur_due_date_before
  LOOP
         da.Dbk_Dc.error('DC_INVOICE',row_dc.dc_rownum,'INV_DUE_DATE',
                 'INV_DUE_DATE',
                 'Due date ' || TO_CHAR(row_dc.inv_due_date,'YYYY-MM-DD') ||
				 ' cannot be before invoice date ' || TO_CHAR(row_dc.inv_date,'YYYY-MM-DD') || '.');
  END LOOP;
END INV_DUE_DATE;

--======================================================================
--INV_DISC_DATE
--======================================================================
PROCEDURE INV_DISC_DATE AS
  CURSOR cur_INV_DISC_DATE_null IS
    SELECT dc_rownum
      FROM DA.DC_INVOICE
        WHERE INV_DISC_DATE IS NULL;

  CURSOR cur_disc_date_in_range IS
    SELECT dc_rownum, inv_disc_date, inv_date, inv_due_date
	  FROM da.dc_invoice
	    WHERE inv_date      IS NOT NULL
		  AND inv_disc_date IS NOT NULL
		  AND (inv_disc_date < inv_date
		       OR
			   inv_due_date < inv_disc_date);
BEGIN
  FOR row_dc IN cur_INV_DISC_DATE_null
  LOOP
        da.Dbk_Dc.error('DC_INVOICE',row_dc.dc_rownum,'INV_DISC_DATE',
        'INV_DISC_DATE',
        'INV_DISC_DATE can not be null.');
  END LOOP;

  FOR row_dc IN cur_disc_date_in_range
  LOOP
         da.Dbk_Dc.error('DC_INVOICE',row_dc.dc_rownum,'INV_DISC_DATE',
                 'INV_DISC_DATE',
                 'Discount date ' || TO_CHAR(row_dc.inv_disc_date,'YYYY-MM-DD') ||
				 ' cannot be before invoice date ' || TO_CHAR(row_dc.inv_date,'YYYY-MM-DD') ||
				 ' or after due date ' ||  TO_CHAR(row_dc.inv_due_date,'YYYY-MM-DD') || '.');
  END LOOP;
END INV_DISC_DATE;

--======================================================================
--INV_POST_DATE
--======================================================================
PROCEDURE INV_POST_DATE AS
  CURSOR cur_INV_POST_DATE_null IS
    SELECT dc_rownum
      FROM DA.DC_INVOICE
        WHERE INV_POST_DATE IS NULL;

  CURSOR cur_post_date_before IS
    SELECT dc_rownum, inv_post_date, inv_date
	  FROM da.dc_invoice
	    WHERE inv_date IS NOT NULL
		  AND inv_post_date IS NOT NULL
		  AND inv_post_date < inv_date;
BEGIN
  FOR row_dc IN cur_INV_POST_DATE_null
  LOOP
        da.Dbk_Dc.error('DC_INVOICE',row_dc.dc_rownum,'INV_POST_DATE',
        'INV_POST_DATE',
        'INV_POST_DATE cannot be null.');
  END LOOP;

  FOR row_dc IN cur_post_date_before
  LOOP
         da.Dbk_Dc.error('DC_INVOICE',row_dc.dc_rownum,'INV_POST_DATE',
                 'INV_POST_DATE',
                 'Posting date ' || TO_CHAR(row_dc.inv_post_date,'YYYY-MM-DD') ||
				 ' cannot be before invoice date ' || TO_CHAR(row_dc.inv_date,'YYYY-MM-DD') || '.');
  END LOOP;
END INV_POST_DATE;

--=====================================================================
-- DISC_TAKEN
-- cannot exceed inv_disc_amt
--=====================================================================
--inv_disc_taken_amt
PROCEDURE disc_taken AS
  CURSOR cur_disc_taken IS
    SELECT dc_rownum
	     , inv_disc_taken_amt
		 , inv_disc_amt
      FROM da.dc_invoice
        WHERE (NVL(inv_disc_amt,0) > 0 AND NVL(inv_disc_amt,0) < NVL(inv_disc_taken_amt,0)) -- normal vouchers
		   OR (NVL(inv_disc_amt,0) < 0 AND NVL(inv_disc_amt,0) > NVL(inv_disc_taken_amt,0));-- reversal vouchers
BEGIN
  FOR row_dc IN cur_disc_taken
  LOOP
         da.Dbk_Dc.error('DC_INVOICE',row_dc.dc_rownum,'INV_DISC_TAKEN_AMT',
                 'INV_DISC_TAKEN_AMT',
                 'Discount taken of ' || NVL(row_dc.INV_DISC_TAKEN_AMT,0) ||
                 ' exceeds discount amount of ' || NVL(row_dc.INV_DISC_AMT,0) || '.');
  END LOOP;
END disc_taken;


--======================================================================
--INV_CHARGE_CODE
--======================================================================
PROCEDURE INV_CHARGE_CODE AS
  CURSOR cur_INV_CHARGE_CODE_null IS
    SELECT dc_rownum
      FROM DA.DC_INVOICE
        WHERE INV_CHARGE_CODE IS NULL;
BEGIN
  FOR row_dc IN cur_INV_CHARGE_CODE_null
  LOOP
        da.Dbk_Dc.error('DC_INVOICE',row_dc.dc_rownum,'INV_CHARGE_CODE',
        'INV_CHARGE_CODE',
        'INV_CHARGE_CODE can not be null.');
  END LOOP;
END INV_CHARGE_CODE;

--======================================================================
--INV_CHARGE_CODE_2
--======================================================================
PROCEDURE INV_CHARGE_CODE_2 AS
  CURSOR cur_INV_CHARGE_CODE_2 IS
    SELECT dc_rownum,
           INV_COMP_CODE,
           INV_CHARGE_CODE
        FROM DA.DC_INVOICE T1
          WHERE NOT EXISTS (SELECT '1'
                        FROM DA.ARCHARGE  T2
                          WHERE T1.INV_COMP_CODE = T2.ARCHRG_COMP_CODE
                            AND T1.INV_CHARGE_CODE = T2.ARCHRG_CODE );

BEGIN
  FOR row_dc IN cur_INV_CHARGE_CODE_2
  LOOP
    IF ( row_dc.INV_CHARGE_CODE IS NOT NULL ) THEN
                da.Dbk_Dc.error('DC_INVOICE',
                row_dc.dc_rownum,
                'INV_CHARGE_CODE',
                'ARCHARGE',
                'Record with'||
                ' ARCHRG_COMP_CODE '||row_dc.INV_COMP_CODE||
                ','||' ARCHRG_CODE '||row_dc.INV_CHARGE_CODE||
                ' does not exist in DA.ARCHARGE table.');
    END IF;
 END LOOP;

END INV_CHARGE_CODE_2;

--======================================================================
--INV_COLL_CODE
--======================================================================
PROCEDURE INV_COLL_CODE AS
  CURSOR cur_INV_COLL_CODE_null IS
    SELECT dc_rownum
      FROM DA.DC_INVOICE
        WHERE INV_COLL_CODE IS NULL;
BEGIN
  FOR row_dc IN cur_INV_COLL_CODE_null
  LOOP
        da.Dbk_Dc.error('DC_INVOICE',row_dc.dc_rownum,'INV_COLL_CODE',
        'INV_COLL_CODE',
        'INV_COLL_CODE can not be null.');
  END LOOP;
END INV_COLL_CODE;

--======================================================================
--INV_COLL_CODE_2
--======================================================================
PROCEDURE INV_COLL_CODE_2 AS
  CURSOR cur_INV_COLL_CODE_2 IS
    SELECT dc_rownum,
           INV_COMP_CODE,
           INV_COLL_CODE
        FROM DA.DC_INVOICE T1
          WHERE NOT EXISTS (SELECT '1'
                        FROM DA.COLLECT  T2
                          WHERE T1.INV_COMP_CODE = T2.COLL_COMP_CODE
                            AND T1.INV_COLL_CODE = T2.COLL_CODE );

BEGIN
  FOR row_dc IN cur_INV_COLL_CODE_2
  LOOP
    IF ( row_dc.INV_COLL_CODE IS NOT NULL ) THEN
                da.Dbk_Dc.error('DC_INVOICE',
                row_dc.dc_rownum,
                'INV_COLL_CODE',
                'COLLECT',
                'Record with'||
                ' COLL_COMP_CODE '||row_dc.INV_COMP_CODE||
                ','||' COLL_CODE '||row_dc.INV_COLL_CODE||
                ' does not exist in DA.COLLECT table.');
    END IF;
 END LOOP;

END INV_COLL_CODE_2;

--======================================================================
--INV_CURR_CODE
--======================================================================
PROCEDURE INV_CURR_CODE AS
  CURSOR cur_INV_CURR_CODE IS
   SELECT dc_rownum,
          INV_CURR_CODE
     FROM DA.DC_INVOICE ;

 t_result       da.Apkc.t_result_type%TYPE;
 t_curr_name    da.bacurrency.bacurr_name%TYPE;

BEGIN
 FOR row_dc IN cur_INV_CURR_CODE
 LOOP
       t_result := da.Apk_Sys_Currency.chk(da.Apk_Util.context(DA.Apkc.IS_NOT_NULL,DA.Apkc.IS_ON_FILE),
                                  row_dc.INV_CURR_CODE,
                                  t_curr_name);

        IF ('0' != t_result) THEN
             da.Dbk_Dc.error('DC_INVOICE',
                     row_dc.dc_rownum,
                     'INV_CURR_CODE',
                     'CURR_CODE',
                     t_result);
      END IF;

 END LOOP;
END INV_CURR_CODE;

--======================================================================
--INV_CUR_FACTOR_NUM
--======================================================================
PROCEDURE INV_CUR_FACTOR_NUM AS
  CURSOR cur_INV_CUR_FACTOR_NUM_null IS
    SELECT dc_rownum
      FROM DA.DC_INVOICE
        WHERE INV_CUR_FACTOR_NUM IS NULL;
BEGIN
  FOR row_dc IN cur_INV_CUR_FACTOR_NUM_null
  LOOP
        da.Dbk_Dc.error('DC_INVOICE',row_dc.dc_rownum,'INV_CUR_FACTOR_NUM',
        'INV_CUR_FACTOR_NUM',
        'INV_CUR_FACTOR_NUM can not be null.');
  END LOOP;
END INV_CUR_FACTOR_NUM;

--======================================================================
--INV_TERM_CODE
--======================================================================
PROCEDURE INV_TERM_CODE AS
  CURSOR cur_INV_TERM_CODE_null IS
    SELECT dc_rownum
      FROM DA.DC_INVOICE
        WHERE INV_TERM_CODE IS NULL;
BEGIN
  FOR row_dc IN cur_INV_TERM_CODE_null
  LOOP
        da.Dbk_Dc.error('DC_INVOICE',row_dc.dc_rownum,'INV_TERM_CODE',
        'INV_TERM_CODE',
        'INV_TERM_CODE can not be null.');
  END LOOP;
END INV_TERM_CODE;

--======================================================================
--INV_TERM_CODE_2
--======================================================================
PROCEDURE INV_TERM_CODE_2 AS
  CURSOR cur_INV_TERM_CODE_2 IS
    SELECT dc_rownum,
           INV_COMP_CODE,
           INV_TERM_CODE
        FROM DA.DC_INVOICE T1
          WHERE NOT EXISTS (SELECT '1'
                        FROM DA.TERM  T2
                          WHERE T1.INV_COMP_CODE = T2.TERM_COMP_CODE
                            AND T1.INV_TERM_CODE = T2.TERM_CODE );

BEGIN
  FOR row_dc IN cur_INV_TERM_CODE_2
  LOOP
    IF ( row_dc.INV_TERM_CODE IS NOT NULL ) THEN
                da.Dbk_Dc.error('DC_INVOICE',
                row_dc.dc_rownum,
                'INV_TERM_CODE',
                'TERM',
                'Record with'||
                ' TERM_COMP_CODE '||row_dc.INV_COMP_CODE||
                ','||' TERM_CODE '||row_dc.INV_TERM_CODE||
                ' does not exist in DA.TERM table.');
    END IF;
 END LOOP;

END INV_TERM_CODE_2;

--======================================================================
--INV_SALES_AMT
--======================================================================
PROCEDURE INV_SALES_AMT AS
  CURSOR cur_INV_SALES_AMT_null IS
    SELECT dc_rownum
      FROM DA.DC_INVOICE
        WHERE INV_SALES_AMT IS NULL;
BEGIN
  FOR row_dc IN cur_INV_SALES_AMT_null
  LOOP
        da.Dbk_Dc.error('DC_INVOICE',row_dc.dc_rownum,'INV_SALES_AMT',
        'INV_SALES_AMT',
        'INV_SALES_AMT can not be null.');
  END LOOP;
END INV_SALES_AMT;

--======================================================================
--INV_TAX1_CODE
--======================================================================
PROCEDURE INV_TAX1_CODE AS
  CURSOR cur_INV_TAX1_CODE IS
    SELECT dc_rownum,
           INV_COMP_CODE,
           INV_TAX1_CODE
        FROM DA.DC_INVOICE T1
          WHERE NOT EXISTS (SELECT '1'
                        FROM DA.ARTAX  T2
                          WHERE T1.INV_COMP_CODE = T2.ARTAX_COMP_CODE
                            AND T1.INV_TAX1_CODE = T2.ARTAX_CODE );

BEGIN
  FOR row_dc IN cur_INV_TAX1_CODE
  LOOP
    IF ( row_dc.INV_TAX1_CODE IS NOT NULL ) THEN
                da.Dbk_Dc.error('DC_INVOICE',
                row_dc.dc_rownum,
                'INV_TAX1_CODE',
                'ARTAX',
                'Record with'||
                ' ARTAX_COMP_CODE '||row_dc.INV_COMP_CODE||
                ','||' ARTAX_CODE '||row_dc.INV_TAX1_CODE||
                ' does not exist in DA.ARTAX table.');
    END IF;
 END LOOP;

END INV_TAX1_CODE;

--======================================================================
--INV_TAX2_CODE
--======================================================================
PROCEDURE INV_TAX2_CODE AS
  CURSOR cur_INV_TAX2_CODE IS
    SELECT dc_rownum,
           INV_COMP_CODE,
           INV_TAX2_CODE
        FROM DA.DC_INVOICE T1
          WHERE NOT EXISTS (SELECT '1'
                        FROM DA.ARTAX  T2
                          WHERE T1.INV_COMP_CODE = T2.ARTAX_COMP_CODE
                            AND T1.INV_TAX2_CODE = T2.ARTAX_CODE );

BEGIN
  FOR row_dc IN cur_INV_TAX2_CODE
  LOOP
    IF ( row_dc.INV_TAX2_CODE IS NOT NULL ) THEN
                da.Dbk_Dc.error('DC_INVOICE',
                row_dc.dc_rownum,
                'INV_TAX2_CODE',
                'ARTAX',
                'Record with'||
                ' ARTAX_COMP_CODE '||row_dc.INV_COMP_CODE||
                ','||' ARTAX_CODE '||row_dc.INV_TAX2_CODE||
                ' does not exist in DA.ARTAX table.');
    END IF;
 END LOOP;

END INV_TAX2_CODE;

--======================================================================
--INV_TAX3_CODE
--======================================================================
PROCEDURE INV_TAX3_CODE AS
  CURSOR cur_INV_TAX3_CODE IS
    SELECT dc_rownum,
           INV_COMP_CODE,
           INV_TAX3_CODE
        FROM DA.DC_INVOICE T1
          WHERE NOT EXISTS (SELECT '1'
                        FROM DA.ARTAX  T2
                          WHERE T1.INV_COMP_CODE = T2.ARTAX_COMP_CODE
                            AND T1.INV_TAX3_CODE = T2.ARTAX_CODE );

BEGIN
  FOR row_dc IN cur_INV_TAX3_CODE
  LOOP
    IF ( row_dc.INV_TAX3_CODE IS NOT NULL ) THEN
                da.Dbk_Dc.error('DC_INVOICE',
                row_dc.dc_rownum,
                'INV_TAX3_CODE',
                'ARTAX',
                'Record with'||
                ' ARTAX_COMP_CODE '||row_dc.INV_COMP_CODE||
                ','||' ARTAX_CODE '||row_dc.INV_TAX3_CODE||
                ' does not exist in DA.ARTAX table.');
    END IF;
 END LOOP;

END INV_TAX3_CODE;

--======================================================================
--AMT
--======================================================================
PROCEDURE AMT AS
 CURSOR cur_AMT IS
   SELECT dc_rownum
     FROM DA.DC_INVOICE
       WHERE NVL(INV_AMT,0) != NVL(INV_SALES_AMT,0);
BEGIN
 FOR row_dc IN cur_AMT
 LOOP
        da.Dbk_Dc.error('DC_INVOICE',
                row_dc.dc_rownum,
                'INV_AMT',
                'INV_SALES_AMT',
                'Column INV_AMT does not equal column INV_SALES_AMT.');
 END LOOP;
END AMT;

--======================================================================
--STATUS_CODE
--======================================================================
PROCEDURE STATUS_CODE AS
  CURSOR cur_STATUS_CODE IS
    SELECT dc_rownum,
           INV_STATUS_CODE
      FROM DA.DC_INVOICE
        WHERE NVL(INV_STATUS_CODE,'xxxx') NOT IN ('O','P','C');
BEGIN
  FOR row_dc IN cur_STATUS_CODE
  LOOP

        da.Dbk_Dc.error('DC_INVOICE',row_dc.dc_rownum,'INV_STATUS_CODE',
        'INV_STATUS_CODE',
        'INV_STATUS_CODE must be set to ''O'',''P'',''C''.');

  END LOOP;
END STATUS_CODE;

--======================================================================
--INV_JOB_CODE
--======================================================================
PROCEDURE INV_JOB_CODE AS
  CURSOR cur_INV_JOB_CODE IS
    SELECT dc_rownum,
           INV_COMP_CODE,
           INV_JOB_CODE
        FROM DA.DC_INVOICE T1
          WHERE NOT EXISTS (SELECT '1'
                        FROM DA.JCJOBCAT  T2
                          WHERE T1.INV_COMP_CODE = T2.JCAT_COMP_CODE
                            AND T1.INV_JOB_CODE = T2.JCAT_JOB_CODE );

BEGIN
  FOR row_dc IN cur_INV_JOB_CODE
  LOOP
    IF ( row_dc.INV_JOB_CODE IS NOT NULL ) THEN
                da.Dbk_Dc.error('DC_INVOICE',
                row_dc.dc_rownum,
                'INV_JOB_CODE',
                'JCJOBCAT',
                'Record with'||
                ' JCAT_COMP_CODE '||row_dc.INV_COMP_CODE||
                ','||' JCAT_JOB_CODE '||row_dc.INV_JOB_CODE||
                ' does not exist in DA.JCJOBCAT table.');
    END IF;
 END LOOP;

END INV_JOB_CODE;

--======================================================================
--TRAN_CODE
--======================================================================
PROCEDURE TRAN_CODE AS
  CURSOR cur_TRAN_CODE IS
    SELECT dc_rownum,
           INV_TRAN_CODE
      FROM DA.DC_INVOICE
        WHERE NVL(INV_TRAN_CODE,'xxxx') NOT IN ('I');
BEGIN
  FOR row_dc IN cur_TRAN_CODE
  LOOP

        da.Dbk_Dc.error('DC_INVOICE',row_dc.dc_rownum,'INV_TRAN_CODE',
        'INV_TRAN_CODE',
        'INV_TRAN_CODE must be set to ''I''.');

  END LOOP;
END TRAN_CODE;

--======================================================================
--INV_BCH_NUM_3
--======================================================================
PROCEDURE INV_BCH_NUM_3 AS
  CURSOR cur_INV_BCH_NUM_3 IS
    SELECT dc_rownum,
           INV_BCH_NUM
      FROM DA.DC_INVOICE
        WHERE INV_BCH_NUM IN (SELECT INV_BCH_NUM FROM DA.DC_INVOICE GROUP BY INV_BCH_NUM HAVING COUNT(DISTINCT(INV_COMP_CODE)) > 1) ;
BEGIN
 FOR row_dc IN cur_INV_BCH_NUM_3
 LOOP
        da.Dbk_Dc.error('DC_INVOICE',
                row_dc.dc_rownum,
                'INV_BCH_NUM',
                'INV_BCH_NUM',
                'THERE ARE 2 OR MORE COMPANIES IN BATCH '||TO_CHAR(row_dc.INV_BCH_NUM)||'.');
 END LOOP;
END INV_BCH_NUM_3;

--======================================================================
-- INV_TAX1_TAXABLE_FLAG
-- Y/N
--======================================================================
PROCEDURE inv_tax1_taxable_flag AS
   CURSOR inv_taxable1_cur IS
      SELECT dc_rownum
        FROM da.dc_invoice
       WHERE NVL(inv_tax1_taxable_flag,'N') NOT IN ('Y','N');

BEGIN
   FOR row_dc IN inv_taxable1_cur LOOP
      da.Dbk_Dc.error('DC_INVOICE'
                     ,row_dc.dc_rownum
                     ,'INV_TAX1_TAXABLE_FLAG'
                     ,'INV_TAX1_TAXABLE_FLAG'
                     ,'Value must be either Y - taxable or N - non-taxable.');
   END LOOP;
END INV_TAX1_TAXABLE_FLAG;

--======================================================================
-- INV_TAX2_TAXABLE_FLAG
-- Y/N
--======================================================================
PROCEDURE inv_tax2_taxable_flag AS
   CURSOR inv_taxable2_cur IS
      SELECT dc_rownum
        FROM da.dc_invoice
       WHERE NVL(inv_tax2_taxable_flag,'N') NOT IN ('Y','N');

BEGIN
   FOR row_dc IN inv_taxable2_cur LOOP
      da.Dbk_Dc.error('DC_INVOICE'
                     ,row_dc.dc_rownum
                     ,'INV_TAX2_TAXABLE_FLAG'
                     ,'INV_TAX2_TAXABLE_FLAG'
                     ,'Value must be either Y - taxable or N - non-taxable.');
   END LOOP;
END INV_TAX2_TAXABLE_FLAG;

--======================================================================
-- INV_TAX3_TAXABLE_FLAG
-- Y/N
--======================================================================
PROCEDURE inv_tax3_taxable_flag AS
   CURSOR inv_taxable3_cur IS
      SELECT dc_rownum
        FROM da.dc_invoice
       WHERE NVL(inv_tax3_taxable_flag,'N') NOT IN ('Y','N');

BEGIN
   FOR row_dc IN inv_taxable3_cur LOOP
      da.Dbk_Dc.error('DC_INVOICE'
                     ,row_dc.dc_rownum
                     ,'INV_TAX3_TAXABLE_FLAG'
                     ,'INV_TAX3_TAXABLE_FLAG'
                     ,'Value must be either Y - taxable or N - non-taxable.');
   END LOOP;
END INV_TAX3_TAXABLE_FLAG;

--======================================================================
-- INV_SOURCE_CODE
-- must be R for conversion
--======================================================================
PROCEDURE inv_source_code AS
   CURSOR inv_src_cur IS
      SELECT dc_rownum
        FROM da.dc_invoice
       WHERE NVL(inv_source_code,'R') NOT IN ('R','S');
BEGIN
   FOR row_dc IN inv_src_cur LOOP
      da.Dbk_Dc.error('DC_INVOICE'
                     ,row_dc.dc_rownum
                     ,'INV_SOURCE_CODE'
                     ,'INV_SOURCE_CODE'
                     ,'Value must be either R - Regular Invoice or S - Sakes Invoice.');
   END LOOP;
END INV_SOURCE_CODE;

--======================================================================
--CREATE_BATCHES - create batches in da.batch file
--      post date will be taken as max post date for apropriate batch
--      the calling of procedure has to be added into process_temp_data
--      procedure to appropriate place
--======================================================================

PROCEDURE create_batches AS
  CURSOR cur_batches IS
    SELECT inv_bch_num "INV_BCH_NUM",
           MAX(inv_post_date) "INV_POST_DATE",
           MAX(inv_comp_code) "INV_COMP_CODE"
      FROM da.dc_invoice T1
        WHERE NOT EXISTS ( SELECT '1'
                             FROM da.arbatch T2
                                WHERE T1.inv_bch_num = T2.ARBCH_NUM
                                  AND T2.ARBCH_TYPE_CODE = 'T' )
      GROUP BY inv_bch_num;

BEGIN
 FOR row_batch IN cur_batches
 LOOP
     INSERT INTO da.arbatch
        (ARBCH_NUM,             --1
        ARBCH_COMP_CODE,        --2
        ARBCH_NAME,             --3
        ARBCH_USER,             --4
        ARBCH_AMT,              --5
        ARBCH_DATE,             --6
        ARBCH_POST_DATE,        --7
        ARBCH_TYPE_CODE)        --8
     VALUES
        (row_batch.inv_bch_num,                         --1
         row_batch.inv_comp_code,                       --2
         'DC - '||TO_CHAR(SYSDATE,'YYYYMMDD HH:MI:SS'), --3
         USER,                                          --4
         0,                                             --5
         SYSDATE,                                       --6
         row_batch.inv_post_date,                       --7
         'T');                                          --8
 END LOOP;

EXCEPTION WHEN OTHERS THEN
        display_status('Can not insert into DA.ARBATCH table.');
        dbms_output.put_line(SQLERRM);
        ROLLBACK;
        RAISE;

END create_batches;

--======================================================================
--VERIFY_DATA - run all verify procedures define for INVOICE table
--======================================================================
PROCEDURE Verify_data AS
BEGIN
        display_status(' Delete rows DC_INVOICE from DA.DC_ERROR.');
        DELETE FROM da.dc_error
          WHERE UPPER(dcerr_table_name) = 'DC_INVOICE' ;
/*
        IF NOT da.Dbk_Dc_Verify.verify('DC_INVOICE') THEN
          RETURN;
        END IF;
*/
        COMMIT;

        display_status(' INDEX checking in DA.INVOICE');
        idx_check;

        COMMIT;

        display_status(' INDEX  checking in DA.DC_INVOICE');
        idx_dupl;

        COMMIT;

        display_status(' FOREIGN KEYS checking in DA.DC_INVOICE');
        Fk_con;

        COMMIT;

        display_status(' CHECK constraints checking in DA.DC_INVOICE');
        check_con;

        COMMIT;


        display_status(' INV_INV_BCH_NUM - checking');
        INV_BCH_NUM;

        COMMIT;

        display_status(' INV_BCH_NUM_2 - checking');
        INV_BCH_NUM_2;

        COMMIT;

        display_status(' INV_INV_COMP_CODE - checking');
        INV_COMP_CODE;

        COMMIT;

        display_status(' INV_INV_COMP_CODE_2 - checking');
        INV_COMP_CODE_2;

        COMMIT;

        display_status(' INV_INV_NUM - checking');
        INV_NUM;

        COMMIT;

        display_status(' INV_INV_CUST_CODE - checking');
        INV_CUST_CODE;

        COMMIT;

        display_status(' INV_INV_DATE - checking');
        INV_DATE;

        COMMIT;

        display_status(' INV_INV_DUE_DATE - checking');
        INV_DUE_DATE;

        COMMIT;

        display_status(' INV_INV_DISC_DATE - checking');
        INV_DISC_DATE;

        COMMIT;

        display_status(' INV_POST_DATE - checking');
        INV_POST_DATE;

        COMMIT;

        display_status(' INV_DISC_TAKEN - checking');
        DISC_TAKEN;

        COMMIT;

        display_status(' INV_INV_CHARGE_CODE - checking');
        INV_CHARGE_CODE;

        COMMIT;

        display_status(' INV_CHARGE_CODE_2 - checking');
        INV_CHARGE_CODE_2;

        COMMIT;

        display_status(' INV_INV_COLL_CODE - checking');
        INV_COLL_CODE;

        COMMIT;

        display_status(' INV_COLL_CODE_2 - checking');
        INV_COLL_CODE_2;

        COMMIT;

        display_status(' INV_INV_CURR_CODE - checking');
        INV_CURR_CODE;

        COMMIT;

        display_status(' INV_INV_CUR_FACTOR_NUM - checking');
        INV_CUR_FACTOR_NUM;

        COMMIT;

        display_status(' INV_INV_TERM_CODE - checking');
        INV_TERM_CODE;

        COMMIT;

        display_status(' INV_TERM_CODE_2 - checking');
        INV_TERM_CODE_2;

        COMMIT;

        display_status(' INV_INV_SALES_AMT - checking');
        INV_SALES_AMT;

        COMMIT;

        display_status(' INV_TAX1_CODE - checking');
        INV_TAX1_CODE;

        COMMIT;

        display_status(' INV_TAX2_CODE - checking');
        INV_TAX2_CODE;

        COMMIT;

        display_status(' INV_TAX3_CODE - checking');
        INV_TAX3_CODE;

        COMMIT;

        display_status(' INV_AMT - checking');
        AMT;

        COMMIT;

        display_status(' INV_STATUS_CODE - checking');
        STATUS_CODE;

        COMMIT;

        display_status(' INV_JOB_CODE - checking');
        INV_JOB_CODE;

        COMMIT;

        display_status(' INV_TRAN_CODE - checking');
        TRAN_CODE;

        COMMIT;

        display_status(' INV_BCH_NUM_3 - checking');
        INV_BCH_NUM_3;

        COMMIT;

        display_status(' INV_TAX1_TAXABLE_FLAG - checking');
        inv_tax1_taxable_flag;

        COMMIT;

        display_status(' INV_TAX2_TAXABLE_FLAG - checking');
	inv_tax2_taxable_flag;

        COMMIT;

        display_status(' INV_TAX3_TAXABLE_FLAG - checking');
	inv_tax3_taxable_flag;

        COMMIT;

        display_status(' INV_SOURCE_CODE - checking');
	inv_source_code;

        COMMIT;
 END Verify_data;
--======================================================================
--PROCESS_TEMP_DATE - move data into DA.INVOICE table
--======================================================================
PROCEDURE Process_Temp_data AS
   --cursor for number of errors for DC_INVOICE table
   CURSOR cur_err_INVOICE IS
     SELECT COUNT(1)
       FROM da.dc_error
        WHERE UPPER(dcerr_table_name) = 'DC_INVOICE' ;

   t_num_errors_INVOICE         NUMBER;

BEGIN
 OPEN  cur_err_INVOICE;
 FETCH cur_err_INVOICE INTO t_num_errors_INVOICE;
 CLOSE cur_err_INVOICE;

 display_status('Number of errors in DC_ERROR table for DC_INVOICE table :'||
                TO_CHAR(t_num_errors_INVOICE));

 IF ( t_num_errors_INVOICE = 0 )
 THEN
   display_status('Create batches');
   create_batches;

   display_status('Insert into DA.INVOICE');

     INSERT INTO DA.INVOICE
        (INV_TAX2_CODE          --1
        ,INV_SMAN1_CODE         --2
        ,INV_DISPUTED_FLAG              --3
        ,INV_SMAN1_COMM_PC              --4
        ,INV_LAST_PAY_AMT               --5
        ,INV_SMAN2_COMM_PC              --6
        ,INV_STATUS_CODE                --7
        ,INV_TAX1_AMT           --8
        ,INV_SMAN3_COMM_PC              --9
        ,INV_ALLOW_AMT          --10
        ,INV_TAX2_AMT           --11
        ,INV_TAX3_AMT           --12
        ,INV_OE_PRT_CODE                --13
        ,INV_COLL_CODE          --14
        ,INV_INS_DISC_CODE              --15
        ,INV_INS_AMT            --16
        ,INV_RLS_BCH_NUM                --17
        ,INV_SMAN2_COMM_AMT             --18
        ,INV_CONT_CODE          --19
        ,INV_RLS_AMT            --20
        ,INV_DISC_TAKEN_AMT             --21
        ,INV_CURR_CODE          --22
        ,INV_HLDBK_PC           --23
        ,INV_DELINQ_CODE                --24
        ,INV_CUR_FACTOR_NUM             --25
        ,INV_SALES_AMT          --26
        ,INV_CUST_CODE          --27
        ,INV_PLANT_CODE         --28
        ,INV_TAX3_CODE          --29
        ,INV_SMAN2_CODE         --30
        ,INV_BCH_NUM            --31
        ,INV_FIN_AMT            --32
        ,INV_PAID_AMT           --33
        ,INV_CASH_ACC_CODE              --34
        ,INV_AMT                --35
        ,INV_STMT_DATE          --36
        ,INV_WO_AMT             --37
        ,INV_DET_TAX_AMT                --38
        ,INV_RLS_DATE           --39
        ,INV_SMAN3_COMM_AMT             --40
        ,INV_TRAN_CODE          --41
        ,INV_DESC1              --42
        ,INV_DESC2              --43
        ,INV_ORIG_HLDBK_AMT             --44
        ,INV_SDISC_AMT          --45
        ,INV_CREDIT_AMT         --46
        ,INV_SMAN3_CODE         --47
        ,INV_DRAW_NUM           --48
        ,INV_CREDIT_TAX1_HLDBK_AMT              --49
        ,INV_DATE               --50
        ,INV_APPROVED_DATE              --51
        ,INV_DISC_DATE          --52
        ,INV_NODISC_AMT         --53
        ,INV_HLDBK_PAID_AMT             --54
        ,INV_POST_DATE          --55
        ,INV_SER_CODE           --56
        ,INV_CHARGE_CODE                --57
        ,INV_SDISC_PERCENT              --58
        ,INV_HLDBK_AMT          --59
        ,INV_DEPT_CODE          --60
        ,INV_FRT_DISC_CODE              --61
        ,INV_MISC_DISC_CODE             --62
        ,INV_COMP_CODE          --63
        ,INV_REV_DATE           --64
        ,INV_TERM_PC            --65
        ,INV_SOURCE_CODE                --66
        ,INV_RLS_INV_NUM                --67
        ,INV_FRT_AMT            --68
        ,INV_MISC_AMT           --69
        ,INV_ORIG_TAX1_HLDBK_AMT                --70
        ,INV_ORD_NUM            --71
        ,INV_AR_AMT             --72
        ,INV_JOB_CODE           --73
        ,INV_TAX1_CODE          --74
        ,INV_DUE_DATE           --75
        ,INV_CREDIT_HLDBK_AMT           --76
        ,INV_IMAGE_FILENAME             --77
        ,INV_TAX1_HLDBK_AMT             --78
        ,INV_DISC_AMT           --79
        ,INV_RLS_W_AMT          --80
        ,INV_TAX_DISC_CODE              --81
        ,INV_SMAN1_COMM_AMT             --82
        ,INV_RLS_TAX1_AMT               --83
        ,INV_NUM                --84
        ,INV_TERM_CODE          --85
        ,INV_OUTSTAND_AMT               --86
        ,INV_TOTAL_RLS_TAX_AMT --88
        ,INV_ADD_TYPE_CODE     --89
        ,INV_TAX1_TAXABLE_FLAG --90
        ,INV_TAX2_TAXABLE_FLAG --91
        ,INV_TAX3_TAXABLE_FLAG --92
) SELECT
        INV_TAX2_CODE           --1
        ,INV_SMAN1_CODE         --2
        ,INV_DISPUTED_FLAG              --3
        ,INV_SMAN1_COMM_PC              --4
        ,INV_LAST_PAY_AMT               --5
        ,INV_SMAN2_COMM_PC              --6
        ,INV_STATUS_CODE                --7
        ,INV_TAX1_AMT           --8
        ,INV_SMAN3_COMM_PC              --9
        ,INV_ALLOW_AMT          --10
        ,INV_TAX2_AMT           --11
        ,INV_TAX3_AMT           --12
        ,INV_OE_PRT_CODE                --13
        ,INV_COLL_CODE          --14
        ,INV_INS_DISC_CODE              --15
        ,INV_INS_AMT            --16
        ,INV_RLS_BCH_NUM                --17
        ,INV_SMAN2_COMM_AMT             --18
        ,INV_CONT_CODE          --19
        ,INV_RLS_AMT            --20
        ,INV_DISC_TAKEN_AMT             --21
        ,INV_CURR_CODE          --22
        ,INV_HLDBK_PC           --23
        ,INV_DELINQ_CODE                --24
        ,INV_CUR_FACTOR_NUM             --25
        ,INV_SALES_AMT          --26
        ,INV_CUST_CODE          --27
        ,INV_PLANT_CODE         --28
        ,INV_TAX3_CODE          --29
        ,INV_SMAN2_CODE         --30
        ,INV_BCH_NUM            --31
        ,INV_FIN_AMT            --32
        ,INV_PAID_AMT           --33
        ,INV_CASH_ACC_CODE              --34
        ,INV_AMT                --35
        ,INV_STMT_DATE          --36
        ,INV_WO_AMT             --37
        ,INV_DET_TAX_AMT                --38
        ,INV_RLS_DATE           --39
        ,INV_SMAN3_COMM_AMT             --40
        ,INV_TRAN_CODE          --41
        ,INV_DESC1              --42
        ,INV_DESC2              --43
        ,INV_ORIG_HLDBK_AMT             --44
        ,INV_SDISC_AMT          --45
        ,INV_CREDIT_AMT         --46
        ,INV_SMAN3_CODE         --47
        ,INV_DRAW_NUM           --48
        ,INV_CREDIT_TAX1_HLDBK_AMT              --49
        ,INV_DATE               --50
        ,INV_APPROVED_DATE              --51
        ,INV_DISC_DATE          --52
        ,INV_NODISC_AMT         --53
        ,INV_HLDBK_PAID_AMT             --54
        ,INV_POST_DATE          --55
        ,INV_SER_CODE           --56
        ,INV_CHARGE_CODE                --57
        ,INV_SDISC_PERCENT              --58
        ,INV_HLDBK_AMT          --59
        ,INV_DEPT_CODE          --60
        ,INV_FRT_DISC_CODE              --61
        ,INV_MISC_DISC_CODE             --62
        ,INV_COMP_CODE          --63
        ,INV_REV_DATE           --64
        ,INV_TERM_PC            --65
        ,INV_SOURCE_CODE                --66
        ,INV_RLS_INV_NUM                --67
        ,INV_FRT_AMT            --68
        ,INV_MISC_AMT           --69
        ,INV_ORIG_TAX1_HLDBK_AMT                --70
        ,INV_ORD_NUM            --71
        ,INV_AR_AMT             --72
        ,INV_JOB_CODE           --73
        ,INV_TAX1_CODE          --74
        ,INV_DUE_DATE           --75
        ,INV_CREDIT_HLDBK_AMT           --76
        ,INV_IMAGE_FILENAME             --77
        ,INV_TAX1_HLDBK_AMT             --78
        ,INV_DISC_AMT           --79
        ,INV_RLS_W_AMT          --80
        ,INV_TAX_DISC_CODE              --81
        ,INV_SMAN1_COMM_AMT             --82
        ,INV_RLS_TAX1_AMT               --83
        ,INV_NUM                --84
        ,INV_TERM_CODE          --85
        ,INV_OUTSTAND_AMT               --86
        ,INV_TOTAL_RLS_TAX_AMT --88
        ,INV_ADD_TYPE_CODE     --89
        ,INV_TAX1_TAXABLE_FLAG --90
	,INV_TAX2_TAXABLE_FLAG --91
	,INV_TAX3_TAXABLE_FLAG --92
   FROM DA.DC_INVOICE;

  --delete everything from DA.DC_INVOICE
    display_status('Delete rows from DA.DC_INVOICE table.');
    DELETE FROM DA.DC_INVOICE;
    display_status('Number of records deleted from DA.DC_INVOICE table:'||TO_CHAR(SQL%rowcount));

     display_status('INVOICE moving from temp table was successful.');
--     commit;

 END IF; /*    if nvl(t_num_errors_INVOICE,0) = 0 */

EXCEPTION WHEN OTHERS
     THEN
       display_status('Can not move data from DA.DC_INVOICE into DA.INVOICE.');
       da.Dbk_Dc.output(SQLERRM);
       ROLLBACK;
       RAISE;

END Process_temp_data ;

END CC_Dbk_Dc_Invoice;
/
