SELECT /*+ FIRST_ROWS ORDERED PARALLEL(AD, 8) PARALLEL(CADH, 8) PARALLEL(sub1, 8) */ 
       ad.cad_account_number,
       to_number(SUBSTR(ad.CAD_ACCOUNT_NUMBER ,1,7)) cust_idn,
       cad_identifier,decode(nvl(instr((extract(XMLType(cad_account_xmlstring), '/csbAccount/customer/profile/profileCode/text()').getStringVal()),'LI'),0),0,'N','Y')     
       LOW_INCOME,    
       Nvl(ad.CAD_STATUS_CODE_CURR,'None') status_code,
       nvl(decode(ad.CAD_ENERGY_TYPE, 'E', 'Elec', 'G', 'Gas', 'B', 'Both') , 'Other') energy_type        ,
       ad.CAD_ACCOUNT_TYPE            ,
       nvl(ad.CAD_METER_LOCATION, 'Other') meter_location   ,
       cadh.cadh_cad_id,
       cadh.cadh_cca_agency_code,
       ad.CAD_TOTAL_ENERGY_ARR ,
       ad.CAD_TOTAL_NONENERGY_ARR   ,
       sub1.ninety,
       sub1.oninety,
       sub1.sixty,
       sub1.thirty,
       sysdate Run_date 
FROM CCS_ACCOUNT_DETAIL AD,  
     CCS_ACCOUNT_DISPATCH_HISTORY CADH,
    (select casa_cad_id,  
             sum(CASA_NINETY_BUCKET) ninety,
             sum(CASA_OVER_NINETY_BUCKET) oninety,
             sum(CASA_SIXTY_BUCKET) sixty,
             sum(CASA_THIRTY_BUCKET) thirty
          from CCS_ACCOUNT_SERVICE_AGREEMENT        
            group by casa_cad_id) sub1
WHERE  AD.CAD_ACCOUNT_STATUS = 'ACTIVE'
--and    AD.cad_account_number = '379437700014'
  and rownum <1000
AND    AD.CAD_IDENTIFIER = cadh.cadh_cad_id(+)
and AD.CAD_IDENTIFIER = sub1.CASA_CAD_ID 
AND cadh.cadh_send_date = (select /*+ PARALLEL(cadh2, 8) */
                           max(cadh2.cadh_send_date) 
                           from ccs_account_dispatch_history cadh2
                           where cadh2.cadh_cad_id = cadh.cadh_cad_id)
                        







