SELECT to_number(SUBSTR(CAD_ACCOUNT_NUMBER ,1,7)) cust_idn,
              TO_NUMBER(SUBSTR(CAD_ACCOUNT_NUMBER ,8,4) ) CCS_ACT_SEQ, 
               SUBSTR(CAD_ACCOUNT_NUMBER ,5,2)  CCS_KEY,
                TO_NUMBER(SUBSTR(CAD_ACCOUNT_NUMBER ,12,1) ) ccs_check_digit,
      Nvl(CAD_STATUS_CODE_CURR,'None') status_code,
             nvl(decode(CAD_ENERGY_TYPE, 'E', 'Elec', 'G', 'Gas', 'B', 'Both') , 'Other') energy_type        ,
         CAD_ACCOUNT_TYPE            ,
       nvl(CAD_METER_LOCATION, 'Other') meter_location   ,
       count(*) No_of_accts,
         CAD_TOTAL_ENERGY_ARR,
      CAD_TOTAL_NONENERGY_ARR   ,
      CADH_CCA_AGENCY_CODE,
      sum(CASA_NINETY_BUCKET),
      sum(CASA_OVER_NINETY_BUCKET),
      sum(CASA_SIXTY_BUCKET),
      sum(CASA_THIRTY_BUCKET) 
FROM CCS_ACCOUNT_DETAIL AD,  
     CCS_ACCOUNT_DISPATCH_HISTORY ADH,
     CCS_ACCOUNT_SERVICE_AGREEMENT ASG --,
--     ccs_code_lookup CDLK
WHERE AD.CAD_ACCOUNT_STATUS = 'FINAL'
AND    AD.CAD_IDENTIFIER =  ASG.CASA_CAD_ID
and     ASG.CASA_LAST_EFFECTIVE_DATE IS NULL
AND   AD.CAD_IDENTIFIER =    ADH.CADH_CAD_ID (+)
--AND    ASG.CASA_CCL_ID_PC = CDLK.ccl_identifier
--AND  CDLK.CCL_ASSOCIATED_VALUE = 'E'
GROUP BY 
CAD_STATUS_CODE_CURR,
  CAD_ACCOUNT_TYPE            ,
CAD_ENERGY_TYPE,
  CAD_METER_LOCATION   ,
   CAD_TOTAL_ENERGY_ARR,
  CAD_TOTAL_NONENERGY_ARR   ,
  CAD_METER_LOCATION   ,
to_number(SUBSTR(CAD_ACCOUNT_NUMBER ,1,7)),
TO_NUMBER(SUBSTR(CAD_ACCOUNT_NUMBER ,8,4) ) , 
               SUBSTR(CAD_ACCOUNT_NUMBER ,5,2)  ,
TO_NUMBER(SUBSTR(CAD_ACCOUNT_NUMBER ,12,1) ),
  CADH_CCA_AGENCY_CODE
  
  select casa_cad_id from CCS_ACCOUNT_SERVICE_AGREEMENT where CASA_LAST_EFFECTIVE_DATE IS NULL
  group by casa_cad_id
  order by count(casa_cad_id) desc