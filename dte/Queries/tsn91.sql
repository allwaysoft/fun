SELECT to_number(SUBSTR(CAD_ACCOUNT_NUMBER ,1,7)) cust_idn,
      Nvl(CAD_STATUS_CODE_CURR,'None') status_code,
             nvl(decode(CAD_ENERGY_TYPE, 'E', 'Elec', 'G', 'Gas', 'B', 'Both') , 'Other') energy_type        ,
         CAD_ACCOUNT_TYPE            ,
       nvl(CAD_METER_LOCATION, 'Other') meter_location   ,
       count(distinct ad.cad_account_number) No_of_accts,
         CAD_TOTAL_ENERGY_ARR,
      CAD_TOTAL_NONENERGY_ARR   ,
      CADH_CCA_AGENCY_CODE,
      sum(CASA_NINETY_BUCKET),
      sum(CASA_OVER_NINETY_BUCKET),
      sum(CASA_SIXTY_BUCKET),
      sum(CASA_THIRTY_BUCKET) 
FROM CCS_ACCOUNT_DETAIL AD,  
     CCS_ACCOUNT_DISPATCH_HISTORY ADH,
     CCS_ACCOUNT_SERVICE_AGREEMENT ASG 
WHERE  AD.CAD_ACCOUNT_STATUS = 'ACTIVE'
AND    AD.CAD_IDENTIFIER =  ASG.CASA_CAD_ID
AND AD.CAD_IDENTIFIER =    ADH.CADH_CAD_ID (+)
GROUP BY 
CAD_STATUS_CODE_CURR,
  CAD_ACCOUNT_TYPE            ,
CAD_ENERGY_TYPE,
  CAD_METER_LOCATION   ,
   CAD_TOTAL_ENERGY_ARR,
  CAD_TOTAL_NONENERGY_ARR   ,
  to_number(SUBSTR(CAD_ACCOUNT_NUMBER ,1,7)),
  CADH_CCA_AGENCY_CODE