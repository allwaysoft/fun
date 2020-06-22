CREATE OR REPLACE VIEW "DA1"."NACHA_FILE_FORMAT_CADVW" ("NFFC_ROW_ID", "NFFC_ROW_ID1", "NFFC_DATA") 
AS 

WITH 

NACHA_PARAMETERS AS
(
SELECT LPAD(CEIL((NVL(COUNT(1), 0)+4)/10), 6, '0') COUNT_BLOCKS
     , NVL(COUNT(1), 0)                            COUNT_6_RECS
     , LPAD(                               
       REVERSE(
         SUBSTR(
         REVERSE(
          TO_CHAR(NVL(SUM(SUBSTR(RTRIM(LTRIM(BNK.BNK_ROUTING_CODE)), 1, 8)), 0))
                )
              , 1, 10
               )
              )
           , 10, '0'  
           )                                       SUM_ROUT_NUM
     , 10 - (DECODE(MOD((NVL(COUNT(1), 0)+4), 10)
                  , 0, 10
                     , MOD((NVL(COUNT(1), 0)+4), 10)
                   )
            )                                      COUNT_9_RECS
     --, REMAINDER((COUNT(1)+4), 10) COUNT_9_RECS                                        
FROM DA.PYEMPSALSPL SPL
   , DA.BABANK BNK
   , DA.PYEMPLOYEE_TABLE EMP
WHERE SPL.ESS_ACH_TRAN_CODE IN ('23', '33')
AND SPL.ESS_COMP_CODE NOT IN ('ZZ')
AND SPL.ESS_BANK_CODE   = BNK.BNK_BANK_CODE
AND SPL.ESS_EMP_NO      = EMP.EMP_NO
--AND BNK.BNK_BANK_CODE NOT IN ('EFTVEN')
),

NACHA_CMPS_BNK AS                        --COMPASS BANK
(
SELECT LTRIM(BNK.BNK_ROUTING_CODE) BNK_ROUTING_CODE
     , BNK.BNK_SHORT_NAME   BNK_SHORT_NAME
FROM DA.BABANK BNK 
WHERE BNK.BNK_BANK_CODE = '062001186'
AND ROWNUM <=1
),

NACHA_CADDELL_CMP AS
(
SELECT CMP.COMP_NAME
     , CMP.COMP_TAX_CODE 
FROM DA.COMPANY CMP
WHERE CMP.COMP_CODE = '01'
AND ROWNUM <=1
)

SELECT 1 ROW_ID, 1 ROW_ID1, 
       '1'                       
    || '01' 
    || RPAD(' ',1 , ' ')    
/*  
    || (
        SELECT BNK.BNK_ROUTING_CODE
        FROM DA.BABANK BNK 
        WHERE BNK.BNK_BANK_CODE = '062001186'
       )
*/
    || NCB.BNK_ROUTING_CODE
    || '4'  
    || NCC.COMP_TAX_CODE 
    || TO_CHAR(SYSDATE, 'YYMMDD') 
    || TO_CHAR(SYSDATE, 'HH24MI')
    || '0'  
    || '094'             
    || '10' 
    || '1'                
/*    
    || (
        SELECT RPAD(BNK.BNK_SHORT_NAME,23,' ')
        FROM DA.BABANK BNK 
        WHERE BNK.BNK_BANK_CODE = '062001186'
       )    
*/
    || RPAD(NCB.BNK_SHORT_NAME, 23, ' ')
    || SUBSTR(UPPER(NCC.COMP_NAME),1 , 23) 
    || RPAD(' ', 8, ' ') ROW1
FROM NACHA_CADDELL_CMP NCC
--     DA.COMPANY CMP
   , NACHA_PARAMETERS NP
   , NACHA_CMPS_BNK   NCB
WHERE NP.COUNT_6_RECS >= 1

UNION ALL

SELECT 2, 2 ROW_ID1, 
       '5' 
    || '200' 
    || SUBSTR(UPPER(NCC.COMP_NAME), 1, 16)    
    || RPAD(' ', 20, ' ') 
    || '4'  
    || NCC.COMP_TAX_CODE 
    || 'PPD' 
    || RPAD('PAYROLL', 10, ' ') 
    || TO_CHAR(SYSDATE, 'YYMMDD')
    || TO_CHAR(SYSDATE, 'YYMMDD') 
    || RPAD(' ', 3, ' ')        
    || '1' 
/*
    || (
        SELECT SUBSTR(BNK.BNK_ROUTING_CODE, 1, 8) 
        FROM DA.BABANK BNK 
        WHERE BNK.BNK_BANK_CODE = '062001186'
       )
*/  
    || SUBSTR(NCB.BNK_ROUTING_CODE, 1, 8)
    || LPAD(ROWNUM, 7, 0) ROW2
FROM --DA.COMPANY CMP
     NACHA_CADDELL_CMP NCC
   , NACHA_PARAMETERS NP
   , NACHA_CMPS_BNK   NCB
WHERE NP.COUNT_6_RECS >= 1

UNION ALL

SELECT 3, ROWNUM ROW_ID1, 
       '6'       
    || SPL.ESS_ACH_TRAN_CODE 
    || SUBSTR(LTRIM(BNK.BNK_ROUTING_CODE), 1, 8) 
    || SUBSTR(LTRIM(BNK.BNK_ROUTING_CODE), 9, 1) 
    || RPAD(SPL.ESS_BANK_ACC_NUMBER, 17, ' ') 
    || RPAD('0', 10, '0')                 
    || LPAD(EMP.EMP_NO, 15, '0') 
    || DECODE(
        GREATEST(
           LENGTH(EMP.EMP_LAST_NAME || ', ' 
                                    || EMP.EMP_FIRST_NAME 
                                    || ' ' 
                                    || EMP.EMP_MIDDLE_NAME
                 )
               , 22
                )
            , 22 , RPAD(EMP.EMP_LAST_NAME || ', ' 
                                          || EMP.EMP_FIRST_NAME 
                                          || ' ' 
                                          || EMP.EMP_MIDDLE_NAME
                      , 22, ' '
                       )
            , SUBSTR(EMP.EMP_LAST_NAME || ', ' 
                                       || EMP.EMP_FIRST_NAME 
                                       || ' ' 
                                       || EMP.EMP_MIDDLE_NAME
                   , 1, 22
                    ) 
             )
     || RPAD(' ', 2, ' ') 
     || '0' 
/*     
     || (
          SELECT SUBSTR(BNK1.BNK_ROUTING_CODE, 1, 8) 
          FROM DA.BABANK BNK1
          WHERE BNK_BANK_CODE = '062001186'
        )
*/
     || SUBSTR(NCB.BNK_ROUTING_CODE, 1, 8) 
     || LPAD(ROWNUM, 7, '0') ROW3           
FROM DA.PYEMPSALSPL      SPL
   , DA.BABANK           BNK
   , DA.PYEMPLOYEE_TABLE EMP
   , NACHA_CMPS_BNK      NCB
WHERE SPL.ESS_ACH_TRAN_CODE IN ('23', '33') 
AND SPL.ESS_COMP_CODE NOT IN ('ZZ') 
AND SPL.ESS_BANK_CODE = BNK.BNK_BANK_CODE
AND SPL.ESS_EMP_NO    = EMP.EMP_NO
--AND BNK.BNK_BANK_CODE NOT IN ('EFTVEN')

UNION ALL

SELECT 4, 4 ROW_ID1, 
       '8' 
    || '200' 
/*    
    || (SELECT LPAD(COUNT(1), 6, '0') 
            || REVERSE(
                 SUBSTR(
                 REVERSE(
                  TO_CHAR(SUM(SUBSTR(RTRIM(LTRIM(BNK.BNK_ROUTING_CODE)), 1, 8)))
                        )
                      , 1, 10
                       )
                      )  
          FROM DA.PYEMPSALSPL SPL
             , DA.BABANK BNK
             , DA.PYEMPLOYEE_TABLE EMP
          WHERE SPL.ESS_BANK_CODE = BNK.BNK_BANK_CODE
          AND SPL.ESS_EMP_NO      = EMP.EMP_NO
          AND BNK.BNK_BANK_CODE NOT IN ('EFTVEN')
       )                                        
*/
    || LPAD(NP.COUNT_6_RECS, 6, '0')
    || NP.SUM_ROUT_NUM 
    || RPAD('0', 12, '0') 
    || RPAD('0', 12, '0') 
    || '4' 
    || NCC.COMP_TAX_CODE 
    || RPAD(' ', 25, ' ') 
/*    
    || (
        SELECT SUBSTR(BNK1.BNK_ROUTING_CODE, 1, 8) 
        FROM DA.BABANK BNK1
        WHERE BNK_BANK_CODE = '062001186'
       )
*/   
    || SUBSTR(NCB.BNK_ROUTING_CODE, 1, 8)
    || LPAD(ROWNUM, 7, '0') ROW4
FROM --     DA.COMPANY CMP
     NACHA_CADDELL_CMP NCC
   , NACHA_PARAMETERS NP
   , NACHA_CMPS_BNK   NCB
WHERE NP.COUNT_6_RECS >= 1

UNION ALL

SELECT 5, 5 ROW_ID1, 
       '9' 
    || LPAD('1', 6, '0') 
/*    
    || LPAD(CEIL(COUNT(1)/10), 6, '0') 
    || LPAD(COUNT(1), 8, '0')
    || REVERSE(
         SUBSTR(
         REVERSE(
          TO_CHAR(SUM(SUBSTR(RTRIM(LTRIM(BNK.BNK_ROUTING_CODE)), 1, 8)))
                )
              , 1, 10
               )
              )                         
*/
    || NP.COUNT_BLOCKS
    || LPAD(NP.COUNT_6_RECS, 8, '0')
    || NP.SUM_ROUT_NUM 
    || RPAD('0', 12, '0') 
    || RPAD('0', 12, '0') 
    || RPAD(' ', 39, ' ')
FROM DUAL
   , NACHA_PARAMETERS NP
WHERE NP.COUNT_6_RECS >= 1
/*
DA.PYEMPSALSPL SPL
   , DA.BABANK BNK
   , DA.PYEMPLOYEE_TABLE EMP
WHERE SPL.ESS_BANK_CODE   = BNK.BNK_BANK_CODE
AND SPL.ESS_EMP_NO        = EMP.EMP_NO
AND BNK.BNK_BANK_CODE NOT IN ('EFTVEN')
*/

UNION ALL

SELECT ROWNUM+5, 99 ROW_ID1, RPAD('9', 94, '9')
FROM DUAL
   , NACHA_PARAMETERS NP
WHERE ROWNUM        <= NP.COUNT_9_RECS
AND NP.COUNT_6_RECS >= 1
CONNECT BY LEVEL    <= NP.COUNT_9_RECS