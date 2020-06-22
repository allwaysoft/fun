select distinct cadh1.cadh_cad_id,cadh1.cadh_recall_Date,cadh1.cadh_send_date from ccs_account_dispatch_history cadh1
where cadh_recall_date=(SELECT /*+ PARALLEL(CCS_ACCOUNT_DISPATCH_HISTORY, 8 */
                            MAX(CADH_SEND_DATE)  
                            FROM CCS_ACCOUNT_DISPATCH_HISTORY cadh2 
                            where cadh1.cadh_cad_id=cadh2.cadh_cad_id
                            GROUP BY CADH_CAD_ID) 
                            
                            
                            
                            
        SELECT  /*+ FIRST_ROWS PARALLEL(CCS_ACCOUNT_DETAIL, 12) 
            PARALLEL(CCS_ACCOUNT_DISPATCH_HISTORY, 12) 
            PARALLEL(CCS_ACCOUNT_PAYMENT_HISTORY, 12) */
        DISTINCT CAD_IDENTIFIER, 
        CAD_CUSTOMER_NAME,
        CAD_ACCOUNT_NUMBER,        
        CAD_TOTAL_ENERGY_BAL,
        CAD_TOTAL_NONENERGY_BAL,
        CADH_CAD_ID,        CAD_TOTAL_ENERGY_BAL+CAD_TOTAL_NONENERGY_BAL TBAL, 
        MAX(CADH_CCA_AGENCY_CODE),
        MAX(INLV1.ELEC_BAL),
        MAX(INLV1.GAS_BAL),
        MAX(INLV1.NON_ENERGY_BAL),
        CAPH_PYMT_AMT,
        CAPH_PYMT_DATE,
        SYSDATE                      
FROM  CCS_ACCOUNT_DETAIL, 
      CCS_ACCOUNT_DISPATCH_HISTORY,
      CCS_ACCOUNT_PAYMENT_HISTORY,
      (SELECT CASA_CAD_ID,
      CASA_ENERGY_TYPE,      DECODE(CASA_ENERGY_TYPE,'E',SUM(CASA_THIRTY_BUCKET)+SUM(CASA_SIXTY_BUCKET)         +SUM(CASA_NINETY_BUCKET)+SUM(CASA_OVER_NINETY_BUCKET)+SUM(CASA_CURRENT_BALANCE),0) ELEC_BAL,      DECODE(CASA_ENERGY_TYPE,'G',SUM(CASA_THIRTY_BUCKET)+SUM(CASA_SIXTY_BUCKET)         +SUM(CASA_NINETY_BUCKET)+SUM(CASA_OVER_NINETY_BUCKET)+SUM(CASA_CURRENT_BALANCE),0) GAS_BAL,      DECODE(CASA_ENERGY_TYPE,'N',SUM(CASA_THIRTY_BUCKET)+SUM(CASA_SIXTY_BUCKET)         +SUM(CASA_NINETY_BUCKET)+SUM(CASA_OVER_NINETY_BUCKET)+SUM(CASA_CURRENT_BALANCE),0) NON_ENERGY_BAL
      FROM CCS_ACCOUNT_SERVICE_AGREEMENT
                      -- WHERE    CASA_CAD_ID = 513452
      GROUP BY CASA_CAD_ID,CASA_ENERGY_TYPE) INLV1      
WHERE CAD_IDENTIFIER = INLV1.CASA_CAD_ID      
      AND CAD_IDENTIFIER = CADH_CAD_ID(+)
      AND CAD_IDENTIFIER = CAPH_CAD_ID
      AND CAD_STATUS_CODE_CURR IN ('LGL','RMSC','RMGT')
      AND  CAPH_PYMT_AMT<>0
      AND TRUNC(CAPH_PYMT_DATE) BETWEEN NEXT_DAY(TRUNC( SYSDATE), 'MONDAY')-14 AND NEXT_DAY(TRUNC( SYSDATE), 'MONDAY')-8   
      AND CADH_SEND_DATE=(SELECT /*+ PARALLEL(CCS_ACCOUNT_DISPATCH_HISTORY, 12 */
                            MAX(CADH_SEND_DATE) 
                            FROM CCS_ACCOUNT_DISPATCH_HISTORY 
                            WHERE CADH_CAD_ID = CAD_IDENTIFIER
                            --cadh_cad_id = 513452
                            GROUP BY CADH_CAD_ID) 
      GROUP BY CAD_IDENTIFIER, 
               CAD_CUSTOMER_NAME,
               CAD_ACCOUNT_NUMBER,        
               CAD_TOTAL_ENERGY_BAL,
               CAD_TOTAL_NONENERGY_BAL,
               CADH_CAD_ID,               CAD_TOTAL_ENERGY_BAL+CAD_TOTAL_NONENERGY_BAL,
               CAPH_PYMT_AMT,
               CAPH_PYMT_DATE 
               order by cad_identifier